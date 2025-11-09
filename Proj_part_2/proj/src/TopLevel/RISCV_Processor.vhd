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
       oALUOut         : out std_logic_vector(N-1 downto 0));

end  RISCV_Processor;


architecture structure of RISCV_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic;
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0);
  signal s_DMemData     : std_logic_vector(N-1 downto 0);
  signal s_DMemOut      : std_logic_vector(N-1 downto 0);
 
  -- Required register file signals 
  signal s_RegWr        : std_logic;
  signal s_RegWrAddr    : std_logic_vector(4 downto 0);
  signal s_RegWrData    : std_logic_vector(N-1 downto 0);

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0);
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0);
  signal s_Inst         : std_logic_vector(N-1 downto 0);

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic; 

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;

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

  -- ############### MY SIGNALS ##################
  -- ==========IF SIGS===================
  signal s_Inst_ID : std_logic_vector(N-1 downto 0);

  -- ==========ID SIGS==================
  -- control
  signal s_ALUSRC : std_logic;
  signal s_ALUControl : std_logic_vector(3 downto 0);  
  signal s_ImmType    : std_logic_vector(2 downto 0);
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
  signal s_load : std_logic_vector(2 downto 0);
  signal s_jalr : std_logic;

  -- Sign extend
  signal s_extended_imm : std_logic_vector(31 downto 0);

  -- ==========EX SIGS===================
  -- ALU
  signal s_OS1 : std_logic_vector(31 downto 0);
  signal s_ALU_A : std_logic_vector(31 downto 0);
  signal s_ALU_B : std_logic_vector(31 downto 0);
  signal s_Zero : std_logic;

  -- and link mux
  signal s_andLink_imm : std_logic_vector(31 downto 0);
  signal s_andLink_mux_out : std_logic_vector(31 downto 0);
  
  -- ==========MEM SIGS===================

  -- ==========WB SIGS========================
  signal s_DMEM_fixed : std_logic_vector(31 downto 0);
  
  signal s_RegWrite_ctrl : std_logic; 

 -- ### THE COMPONENTS WE MADE ALONG THE WAY ###
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
        o_PCReg : out std_logic;
        o_load : out std_logic_vector(2 downto 0)
      );
    end component;

    component fetch is 
      port (
        clk : in std_logic;
        rst : in std_logic;
        branch : in std_logic;
        zero_flag_ALU : in std_logic;
        jump : in std_logic;
        imm : in std_logic_vector(31 downto 0); 
        PCReg : in std_logic;
        reg_in : in std_logic_vector(31 downto 0);
        instr_addr : out std_logic_vector(31 downto 0);
        plus4_o : out std_logic_vector(31 downto 0)
     );
    end component;

    component butter_extender_Nt32 is
      generic (
        N : integer := 32
      );
      port (
        imm_in : in  std_logic_vector(N-1 downto 0);
        sign_ext : in  std_logic_vector(1 downto 0);
        imm_type : in std_logic_vector(2 downto 0);
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
      generic(N : integer := 16);
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

  component load_handler is 
    port (
      DMEM_in : in std_logic_vector(31 downto 0);
      load_control : in std_logic_vector(2 downto 0);
      offset      : in  std_logic_vector(1 downto 0);
      DMEM_out : out std_logic_vector(31 downto 0)
    );
  end component;

  component IF_ID is 
    port (
          in_instruct : in std_logic_vector(31 downto 0);
    WE : in std_logic;
    out_instruct : out std_logic_vector(31 downto 0);
    RST : in std_logic;
    CLK: in std_logic
  );
  end component;

  component ID_EX is --14 inputs
  port (
    in_ALUSrc : in std_logic;
    in_ALUControl : in std_logic_vector(3 downto 0);
    in_ImmType : in std_logic_vector(2 downto 0);
    in_regWrite : in std_logic;
    in_MemWrite : in std_logic;
    in_imm_sel : in std_logic_vector(1 downto 0);
    in_branch_type : in std_logic_vector(2 downto 0);
    in_jump : in std_logic;
    in_link : in std_logic;
    in_PCReg : in std_logic;
    in_auipc : in std_logic;
    in_data1 : in std_logic_vector(31 downto 0);
    in_data2 : in std_logic_vector(31 downto 0);
    in_extender : in std_logic_vector(31 downto 0);
    in_halt     : in std_logic;
    in_MemtoReg     : in std_logic;
    in_load : in std_logic_vector(2 downto 0);
    WE : in std_logic;
    out_ALUSrc : out std_logic;
    out_ALUControl : out std_logic_vector(3 downto 0);
    out_ImmType : out std_logic_vector(2 downto 0);
    out_MemWrite : out std_logic;
    out_imm_sel : out std_logic_vector(1 downto 0);
    out_branch_type : out std_logic_vector(2 downto 0);
    out_jump : out std_logic;
    out_link : out std_logic;
    out_PCReg : out std_logic;
    out_auipc : out std_logic;
    out_data1 : out std_logic_vector(31 downto 0);
    out_data2 : out std_logic_vector(31 downto 0);
    out_extender : out std_logic_vector(31 downto 0);
    out_halt     : out std_logic;
    out_MemtoReg     : out std_logic;
    out_load : out std_logic_vector(2 downto 0);
    RST : in std_logic;
    CLK: in std_logic
  );
 end component;

 component EX_MEM is
   port (
    in_ImmType : in std_logic_vector(2 downto 0);
    in_MemWrite : in std_logic;
    in_imm_sel : in std_logic_vector(1 downto 0);
    in_branch_type : in std_logic_vector(2 downto 0);
    in_jump : in std_logic;
    in_PCReg : in std_logic;
    in_data1 : in std_logic_vector(31 downto 0);
    in_data2 : in std_logic_vector(31 downto 0);
    in_extender : in std_logic_vector(31 downto 0);
    in_halt     : in std_logic;
    in_MemtoReg     : in std_logic;
    in_regWrite : in std_logic;
    in_load : in std_logic_vector(2 downto 0);
    in_mux : in std_logic_vector(31 downto 0);
    in_alu : in std_logic_vector(31 downto 0);
    in_zero : in std_logic;
    WE : in std_logic;
    out_ImmType : out std_logic_vector(2 downto 0);
    out_MemWrite : out std_logic;
    out_regWrite : out std_logic;
    out_imm_sel : out std_logic_vector(1 downto 0);
    out_branch_type : out std_logic_vector(2 downto 0);
    out_jump : out std_logic;
    out_PCReg : out std_logic;
    out_data1 : out std_logic_vector(31 downto 0);
    out_data2 : out std_logic_vector(31 downto 0);
    out_extender : out std_logic_vector(31 downto 0);
    out_halt     : out std_logic;
    out_MemtoReg     : out std_logic;
    out_load : out std_logic_vector(2 downto 0);
    out_mux : out std_logic_vector(31 downto 0);
    out_alu : out std_logic_vector(31 downto 0);
    out_zero : out std_logic;
    RST : in std_logic;
    CLK: in std_logic
    );
  end component;

  component MEM_WB is
    port (
      in_dmem : in std_logic_vector(31 downto 0);
      in_MemtoReg     : in std_logic;
      in_RegWrite     : in std_logic;
      in_mux : in std_logic_vector(31 downto 0);
      in_alu : in std_logic_vector(31 downto 0);
      WE : in std_logic;
      out_dmem : out std_logic_vector(31 downto 0);
      out_MemtoReg     : out std_logic;
      out_RegWrite     : out std_logic;
      out_mux : out std_logic_vector(31 downto 0);
      out_alu : out std_logic_vector(31 downto 0);
      RST : in std_logic;
      CLK: in std_logic
    );
  end MEM_WB;

begin

  -- ================IF========================= 
  with iInstLd select                 -- Dont touch prob
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

  Fetch_of_ultamite_power : fetch
      port map (
        clk => iCLK,
        rst => iRST,
        branch => s_Branch,
        zero_flag_ALU => s_Zero,
        jump => s_Jump,
        imm => s_extended_imm,
        PCReg => s_PCReg,
        reg_in => s_DMEMAddr,
        instr_addr => s_NextInstAddr,
        plus4_o => s_andLink_imm
      );

  reg_IF_ID : IF_ID 
    port (
      in_instruct  => s_Inst,
      WE           => '1',
      out_instruct => s_Inst_ID, 
      RST          => iRST,        
      CLK          => iCLK    
  );

-- ===================ID===================
  s_RegWr <= s_RegWrite_ctrl when s_Inst(11 downto 7) /= "00000" else '0'; -- Don't touch prob

  s_RegWrAddr <= s_Inst(11 downto 7);

  mind_control : control
    port map (
      i_opcode     => s_Inst_ID(6 downto 0),
      i_funct3     => s_Inst_ID(14 downto 12),
      i_funct7     => s_Inst_ID(31 downto 25),
      i_imm        => s_Inst_ID(31 downto 20),
      o_ALUSRC     => s_ALUSRC,
      o_ALUControl => s_ALUControl,
      o_ImmType    => s_ImmType,
      o_Mem_Write  => s_DMemWr,
      o_RegWrite   => s_RegWrite_ctrl,
      o_imm_sel    => s_imm_sel,
      o_BranchType => s_BranchType,
      o_MemtoReg   => s_MemtoReg,
      o_halt       => s_Halt,
      o_Jump       => s_Jump,
      o_Link       => s_Link,	
      o_Branch     => s_Branch,
      o_auipcSrc   => s_auipcSrc,
      o_PCReg      => s_PCReg,
      o_load       => s_load                
    );

  Register_File : RV32_regFile 
    port map (
      clk       => iCLK,
      rst       => iRST,
      RegWrite  => s_RegWr,
      Rd        => s_RegWrAddr,
      DATA_IN   => s_RegWrData,
      RS1       => s_Inst_ID(19 downto 15),
      RS2       => s_Inst_ID(24 downto 20),
      OS1       => s_OS1,
      OS2       => s_OS2  
    );
    s_DMemData <= s_OS2;

   Sign_Extend : butter_extender_Nt32
      generic map (N => 32)
      port map (
        imm_in     => s_Inst_ID,
        sign_ext   => s_imm_sel,
        imm_type   => s_ImmType,
        imm_out    => s_extended_imm
      );

  -- s_Branch dunno if this should be somewhere
  reg_ID_EX : ID_EX
    port (
      in_ALUSrc       => s_ALUSRC,                       
      in_ALUControl   => s_ALUControl,                      
      in_ImmType      => , -- should not be here                        
      in_regWrite     => s_RegWr,
      in_MemWrite     => s_DMemWr,                      
      in_imm_sel      => s_imm_sel,                     
      in_branch_type  => s_BranchType,                           
      in_jump         => s_Jump,                      
      in_link         => s_Link,                    
      in_PCReg        => s_PCReg,                            
      in_auipc        => s_auipcSrc,                      
      in_data1        => s_OS1,
      in_data2        => s_OS2,
      in_extender     => s_extended_imm,
      in_halt         => s_Halt,
      in_MemtoReg     => s_MemtoReg,                      
      in_load         => s_load,                   
      WE              => '1',                             
      out_ALUSrc      => s_ALUSrc_EX,                    
      out_ALUControl  => s_ALUControl_EX,                     
      out_ImmType     => s_ImmType_EX,                      
      out_MemWrite    => s_MemWrite_EX,                      
      out_imm_sel     => s_imm_sel_EX,
      out_branch_type => s_branch_type_EX,
      out_jump        => s_jump_EX,
      out_link        => s_link_EX,
      out_PCReg       => s_PCReg_EX,
      out_auipc       => s_auipc_EX,
      out_data1       => s_data1_EX,
      out_data2       => s_data2_EX,
      out_extender    => s_extender_EX,
      out_halt        => s_halt_EX,
      out_MemtoReg    => s_MemToReg_EX,
      out_load        => s_load_EX,
      RST             => iRST,
      CLK             => iCLK               
    );

-- ==================EX==========================
    ALU_Src_Mux : mux2t1_N
      generic map (N => 32)
      port map (
        i_S    => s_ALUSRC,
        i_D0   => s_DMemData,
        i_D1   => s_extended_imm,
        o_O    => s_ALU_B
      );
  
     AuiPC_Mux : mux2t1_N
      generic map (N => 32)
      port map (
        i_S    => s_auipcSrc,
        i_D0   => s_OS1,
        i_D1   => s_NextInstAddr,
        o_O    => s_ALU_A
      );
      
     ALU : ALU_Total
      port map (
        A               => s_ALU_A,
        B               => s_ALU_B,
        ALU_Control     => s_ALUControl,
        Branch_Control  => s_BranchType,
        S               => s_DMemAddr,
        zero            => s_Zero,
        overflow        => s_Ovfl
      );
    oALUOut <= s_DMemAddr;

    AndLink_Mux : mux2t1_N
      generic map (N => 32)
      port map (
        i_S     => s_Link,
        i_D0    => s_DMemAddr,
        i_D1    => s_andLink_imm,
        o_O     => s_andLink_mux_out
      );     

   reg_EX_MEM : EX_MEM
     port (
      in_ImmType          => ,              
      in_MemWrite         => ,          
      in_imm_sel          => ,           
      in_branch_type      => ,               
      in_jump             => ,        
      in_PCReg            => ,        
      in_data1            => ,                  
      in_data2            => ,                        
      in_extender         => ,                       
      in_halt             => ,              
      in_MemtoReg         => ,          
      in_regWrite         => ,                         
      in_load             => ,                          
      in_mux              => ,                      
      in_alu              => ,                   
      in_zero             => ,                       
      WE                  => ,                    
      out_ImmType         => ,                     
      out_MemWrite        => ,                   
      out_regWrite        => ,                   
      out_imm_sel         => ,               
      out_branch_type     => ,                        
      out_jump            => ,                    
      out_PCReg           => ,                 
      out_data1           => ,                   
      out_data2           => ,              
      out_extender        => ,             
      out_halt            => ,               
      out_MemtoReg        => ,             
      out_load            => ,                 
      out_mux             => ,              
      out_alu             => ,         
      out_zero            => ,            
      RST                 => ,         
      CLK                 =>       
      );

-- ===================MEM=================
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  reg_MEM_WB : MEM_WB 
    port (
      in_dmem      => ,   
      in_MemtoReg  => ,        
      in_RegWrite  => ,       
      in_mux       => ,         
      in_alu       => ,         
      WE           => ,         
      out_dmem     => ,          
      out_MemtoReg => ,             
      out_RegWrite => ,              
      out_mux      => ,                   
      out_alu      => ,           
      RST          => ,          
      CLK          =>           
    );

-- =================WB===================

  DMEM_fixer : load_handler 
    port map (
      DMEM_in      => s_DMemOut,
      load_control => s_load,
      offset       => s_Inst(21 downto 20),
      DMEM_out     => s_DMEM_fixed
    );
     
    MemtoReg_Mux : mux2t1_N
      generic map (N => 32)
      port map (
        i_S  => s_MemtoReg,
        i_D0 => ,
        i_D1 => s_DMEM_fixed,
        o_O  => s_RegWrData
      );

end structure;
