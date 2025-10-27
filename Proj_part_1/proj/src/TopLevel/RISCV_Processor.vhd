-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- RISCV_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a RISCV_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.RISCV_types.all;

entity RISCV_Processor is
  generic(N : integer := DATA_WIDTH); -- 10
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  RISCV_Processor;


architecture structure of RISCV_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  -- SIGNALS dictionary elaboration
  -- s_DMemWr = MemWrite
  -- s_DMemAddr = ALU output
  -- s_DMemData = Value read from OS2 put into memory for sw
  -- s_DMemOut = Value taken directly from output of dmem

  -- s_RegWr = RegWrite
  -- s_RegWrAddr = Destination register bit [11:7] AKA rd
  -- s_RegWrData = DATA_IN for register file

  -- s_IMemAddr = ignore this signal do not use
  -- s_NextInstAddr = PC output (current address to imem)
  -- s_Inst = instruction memory output (basically the raw RISC V binary)

  -- s_Halt = should be given by control and sent to testbench environment 
  -- s_Ovfl = should be given by ALU dunno for what maybe just debugging

  -- MY SIGNALS

  -- control
  signal s_ALUSRC : std_logic;
  signal s_ALUControl : std_logic_vector(3 downto 0);  
  signal s_ImmType    : std_logic_vector(2 downto 0);
  signal s_ResultSrc  : std_logic_vector(1 downto 0);
  signal s_Mem_Write  : std_logic;
  signal s_RegWrite   : std_logic;
  signal s_imm_sel    : std_logic_vector(1 downto 0);
  signal s_BranchType : std_logic_vector(2 downto 0);
  signal s_MemtoReg     :  std_logic;
  signal s_Jump : std_logic;
  signal s_Link : std_logic;
  signal s_Branch : std_logic;
  signal s_PCReg : std_logic;
  signal s_auipcSrc : std_logic;


  -- ALU
  signal s_OS1 : std_logic_vector(31 downto 0);
  signal s_ALU_B : std_logic_vector(31 downto 0);
  signal s_Zero : std_logic;

  signal s_extended_imm : std_logic_vector(31 downto 0);
  signal s_andLink_imm : std_logic_vector(31 downto 0);
  signal s_notDMem : std_logic_vector(31 downto 0);

  signal s_ALU_A : std_logic_vector(31 downto 0);


  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

    component control is
      port (
        i_opcode     : in  std_logic_vector(6 downto 0);
        i_funct3     : in  std_logic_vector(2 downto 0);
        i_funct7     : in  std_logic_vector(6 downto 0);
	i_imm	     : in std_logic_vector(11 downto 0);
        o_ALUSRC     : out std_logic;
        o_ALUControl : out std_logic_vector(3 downto 0);
        o_ImmType    : out std_logic_vector(2 downto 0);
        o_ResultSrc  : out std_logic_vector(1 downto 0);
        o_Mem_Write  : out std_logic;
        o_RegWrite   : out std_logic;
        o_imm_sel    : out std_logic_vector(1 downto 0);
        o_BranchType : out std_logic_vector(2 downto 0);
        o_MemtoReg     : out std_logic;
        o_halt     : out std_logic;
        o_Jump       : out std_logic;
        o_Link       : out std_logic;
	o_Branch  : out std_logic;
	o_auipcSrc  : out std_logic;
	o_PCReg : out std_logic
      );
    end component;

    component fetch is 
      port (
    clk : in std_logic;
        rst : in std_logic;
        -- Maybe we need RegWrite for the PC, but rn it will be set to 1
        branch : in std_logic;
        zero_flag_ALU : in std_logic;
        jump : in std_logic;
        imm : in std_logic_vector(31 downto 0); -- immediate offset
	PCReg : in std_logic;
	reg_in : in std_logic_vector(31 downto 0);
        instr_addr : out std_logic_vector(31 downto 0); -- address sent to imem
        plus4_o : out std_logic_vector(31 downto 0) -- address that gets sent to "AndLink" address
     );
    end component;

    component butter_extender_Nt32 is
      generic (
        N : integer := 32
      );
      port (
        imm_in : in  std_logic_vector(N-1 downto 0);
        sign_ext : in  std_logic_vector(1 downto 0); -- '01' = sign extend, '00' = zero extend,'10' = lui
        imm_type : in std_logic_vector(2 downto 0); -- '000' = I, '001' = S, '010' = SB, '011' = U, '100' = UJ
        imm_out : out std_logic_vector(31 downto 0)
      );
    end component;

    component ALU_Total is
      port (
        A : in std_logic_vector(31 downto 0);
        B : in std_logic_vector(31 downto 0);
        ALU_Control : in std_logic_vector(3 downto 0);
        Branch_Control : in std_logic_vector(2 downto 0);
        S : out std_logic_vector(31 downto 0);
        zero : out std_logic;
        overflow : out std_logic
      );
    end component;

    component mux2t1_N is 
      generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
      port(i_S          : in std_logic;
           i_D0         : in std_logic_vector(N-1 downto 0);
           i_D1         : in std_logic_vector(N-1 downto 0);
           o_O          : out std_logic_vector(N-1 downto 0));
    end component;

    component RV32_regFile is
      port (
        clk : in std_logic;
        rst : in std_logic;
        RegWrite: in std_logic;
        Rd: in std_logic_vector(4 downto 0);
        DATA_IN : in std_logic_vector(31 downto 0);
        RS1 : in std_logic_vector(4 downto 0);
        RS2 : in std_logic_vector(4 downto 0);
        OS1 : out std_logic_vector(31 downto 0);
        OS2 : out std_logic_vector(31 downto 0)
      );
    end component;

begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;

  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);


  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 

  mind_control : control
    port map (
      i_opcode => s_Inst(6 downto 0),
      i_funct3 => s_Inst(14 downto 12),
      i_funct7 => s_Inst(31 downto 25),
      i_imm => s_Inst(31 downto 20),
      o_ALUSRC => s_ALUSRC,
      o_ALUControl => s_ALUControl,
      o_ImmType => s_ImmType,
      o_ResultSrc => s_ResultSrc,
      o_Mem_Write => s_DMemWr,
      o_RegWrite => s_RegWr,
      o_imm_sel => s_imm_sel,
      o_BranchType => s_BranchType,
      o_MemtoReg => s_MemtoReg,
      o_halt  => s_Halt,
      o_Jump => s_Jump,
      o_Link => s_Link,	
      o_Branch => s_Branch,
	o_auipcSrc => s_auipcSrc,
      o_PCReg => s_PCReg
    );

  Register_File : RV32_regFile 
    port map (
      clk => iCLK,
      rst => iRST,
      RegWrite => s_RegWr,
      Rd => s_RegWrAddr,
      DATA_IN => s_RegWrData,
      RS1 => s_Inst(19 downto 15),
      RS2 => s_Inst(24 downto 20),
      OS1 => s_OS1,
      OS2 => s_DMemData  
    );

  Fetch_of_ultamite_power : fetch
    port map (
      clk => iCLK,
      rst => iRST,
      branch => s_Branch,
      zero_flag_ALU => s_Zero,
      jump => s_Jump,
      imm => s_extended_imm,
      PCReg => s_PCReg,
      reg_in => s_OS1,
      instr_addr => s_NextInstAddr,
      plus4_o => s_andLink_imm
    );

    Sign_Extend : butter_extender_Nt32
      generic map (N => 32)
      port map (
        imm_in => s_Inst,
        sign_ext => s_imm_sel,
        imm_type => s_ImmType,
        imm_out => s_extended_imm
      );

    ALU : ALU_Total
      port map (
         A => s_ALU_A,
    	B => s_ALU_B,
    	ALU_Control => s_ALUControl,
    	Branch_Control => s_BranchType,
    	S => s_DMemAddr,
    	zero => s_Zero,
    	overflow => s_Ovfl
      );

    oALUOut <= s_DMemAddr;

    ALU_Src_Mux : mux2t1_N
      generic map (N => 32)
      port map (
        i_S => s_ALUSRC,
        i_D0 => s_DMemData,
        i_D1 => s_extended_imm,
        o_O => s_ALU_B
      );
      
     AndLink_Mux : mux2t1_N
      generic map (N => 32)
      port map (
        i_S => s_Link,
        i_D0 => s_DMemAddr,
        i_D1 => s_andLink_imm,
        o_O => s_notDMem
      );     

     MemtoReg_Mux : mux2t1_N
      generic map (N => 32)
      port map (
        i_S => s_MemtoReg,
        i_D0 => s_notDMem,
        i_D1 => s_DMemOut,
        o_O => s_RegWrData
      );

     AuiPC_Mux : mux2t1_N
      generic map (N => 32)
      port map (
        i_S => s_auipcSrc,
        i_D0 => s_OS1,
        i_D1 => s_NextInstAddr,
        o_O => s_ALU_A
      );

s_RegWrAddr <= s_Inst(11 downto 7);
end structure;
