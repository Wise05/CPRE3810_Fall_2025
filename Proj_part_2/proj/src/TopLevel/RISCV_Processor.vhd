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
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0));

end  RISCV_Processor;


architecture structure of RISCV_Processor is

-- ===================Signals===================
  -- Required data memory signals
  signal s_DMemWr        : std_logic;
  signal s_DMemAddr      : std_logic_vector(N-1 downto 0);
  signal s_DMemData      : std_logic_vector(N-1 downto 0);
  signal s_DMemOut       : std_logic_vector(N-1 downto 0);
  
  -- Required register file signals 
  signal s_RegWr         : std_logic;
  signal s_RegWrAddr     : std_logic_vector(4 downto 0);
  signal s_RegWrData     : std_logic_vector(N-1 downto 0);

  -- Required instruction memory signals
  signal s_IMemAddr      : std_logic_vector(N-1 downto 0);
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0);
  signal s_Inst          : std_logic_vector(N-1 downto 0);

  -- Required halt signal
  signal s_Halt          : std_logic; 

  -- Required overflow signal
  signal s_Ovfl          : std_logic;

  -- ==========IF SIGS===================
  signal s_PC_in         : std_logic_vector(31 downto 0);
  signal s_PC_out        : std_logic_vector(31 downto 0);
  signal s_PC_plus4      : std_logic_vector(31 downto 0);
  signal s_cout_plus4    : std_logic;
  signal s_PC_val_ID     : std_logic_vector(31 downto 0);
  signal s_PC_plus4_ID   : std_logic_vector(31 downto 0);
  signal s_stall_pc      : std_logic;
  signal s_flush_fetch   : std_logic;
  signal s_IF_ID_WE      : std_logic;

  -- ==========ID SIGS==================
  signal s_Inst_ID : std_logic_vector(N-1 downto 0);
  signal s_ID_EX_WE : std_logic;

  -- control
  signal s_ALUSRC      : std_logic;
  signal s_ALUControl : std_logic_vector(3 downto 0);  
  signal s_ImmType    : std_logic_vector(2 downto 0);
  signal s_Mem_Write  : std_logic;
  signal s_RegWrite    : std_logic;
  signal s_imm_sel    : std_logic_vector(1 downto 0);
  signal s_BranchType : std_logic_vector(2 downto 0);
  signal s_MemtoReg    :  std_logic;
  signal s_Jump        : std_logic;
  signal s_Link        : std_logic;
  signal s_Branch      : std_logic;
  signal s_PCReg      : std_logic;
  signal s_auipcSrc    : std_logic;
  signal s_load        : std_logic_vector(2 downto 0);
  signal s_jalr        : std_logic;
  signal s_halt_ID     : std_logic;
  signal s_stall_IF_ID  : std_logic;
  signal s_flush_decode  : std_logic;

  -- Sign extend
  signal s_extended_imm : std_logic_vector(31 downto 0);
  signal s_OS1 : std_logic_vector(31 downto 0);
  signal s_OS2 : std_logic_vector(31 downto 0);

  -- ==========EX SIGS===================
  signal s_ALUSrc_EX     : std_logic;
  signal s_ALUControl_EX : std_logic_vector(3 downto 0);
  signal s_ImmType_EX    : std_logic_vector(2 downto 0);
  signal s_MemWrite_EX   : std_logic;
  signal s_RegWrite_EX   : std_logic;
  signal s_RegWriteAddr_EX : std_logic_vector(4 downto 0);
  signal s_imm_sel_EX    : std_logic_vector(1 downto 0);
  signal s_branch_type_EX: std_logic_vector(2 downto 0);
  signal s_jump_EX       : std_logic;
  signal s_link_EX       : std_logic;
  signal s_PCReg_EX      : std_logic;
  signal s_auipc_EX      : std_logic;
  signal s_data1_EX      : std_logic_vector(31 downto 0);
  signal s_data2_EX      : std_logic_vector(31 downto 0);
  signal s_extender_EX   : std_logic_vector(31 downto 0);
  signal s_halt_EX       : std_logic;
  signal s_MemToReg_EX   : std_logic;
  signal s_load_EX       : std_logic_vector(2 downto 0);
  signal s_PC_val_EX     : std_logic_vector(31 downto 0);
  signal s_PC_plus4_EX   : std_logic_vector(31 downto 0);
  signal s_Branch_EX     : std_logic;
  signal s_Inst_EX       : std_logic_vector(31 downto 0);
  signal s_stall_ID_EX : std_logic;
  signal s_flush_execute : std_logic;
  signal s_alu_a_mux     : std_logic_vector(1 downto 0);
  signal s_alu_b_mux     : std_logic_vector(1 downto 0);
  signal s_dmem_data_EX  : std_logic_vector(31 downto 0);
  signal s_sw_mux        : std_logic_vector(1 downto 0);

  -- ALU
  signal s_ALU_A : std_logic_vector(31 downto 0);
  signal s_ALU_B : std_logic_vector(31 downto 0);
  signal s_ALU_Out : std_logic_vector(31 downto 0);
  signal s_Zero : std_logic;

  -- and link mux
  signal s_andLink_mux_out : std_logic_vector(31 downto 0);
  
  -- Branch/Jump computation
  signal imm_shifted_s : std_logic_vector(31 downto 0);
  signal PC_offset_s : std_logic_vector(31 downto 0);
  signal PC_off_cOut_s : std_logic;
  signal instr_addr_s : std_logic_vector(31 downto 0);
  
  -- ==========MEM SIGS===================
  signal s_ImmType_MEM     : std_logic_vector(2 downto 0);
  signal s_MemWrite_MEM    : std_logic;
  signal s_RegWrite_MEM    : std_logic;
  signal s_RegWriteAddr_MEM: std_logic_vector(4 downto 0);
  signal s_imm_sel_MEM     : std_logic_vector(1 downto 0);
  signal s_branch_type_MEM : std_logic_vector(2 downto 0);
  signal s_jump_MEM        : std_logic;
  signal s_PCReg_MEM       : std_logic;
  signal s_data1_MEM       : std_logic_vector(31 downto 0);
  signal s_data2_MEM       : std_logic_vector(31 downto 0);
  signal s_extender_MEM    : std_logic_vector(31 downto 0);
  signal s_halt_MEM        : std_logic;
  signal s_MemToReg_MEM    :  std_logic;
  signal s_load_MEM        : std_logic_vector(2 downto 0);
  signal s_mux_MEM         : std_logic_vector(31 downto 0);
  signal s_alu_MEM         : std_logic_vector(31 downto 0);
  signal s_zero_MEM        : std_logic;
  signal s_Branch_MEM      : std_logic;
  signal s_PC_offset_MEM   : std_logic_vector(31 downto 0);
  signal s_inst_MEM        : std_logic_vector(31 downto 0);

  -- Jump/Branch control signals
  signal s_branch_taken    : std_logic;  -- Output of AND gate (branch AND zero)
  signal s_take_branch_or_jump : std_logic;  -- Output of XOR gate
  signal s_PC_PCReg_out    : std_logic_vector(31 downto 0);

  -- ==========WB SIGS========================
  signal s_dmem_WB         : std_logic_vector(31 downto 0);
  signal s_MemtoReg_WB     : std_logic;
  signal s_RegWrite_WB     : std_logic;
  signal s_RegWriteAddr_WB : std_logic_vector(4 downto 0);
  signal s_mux_WB          : std_logic_vector(31 downto 0);
  signal s_alu_WB          : std_logic_vector(31 downto 0);
  signal s_DMEM_fixed      : std_logic_vector(31 downto 0);
  signal s_load_WB         : std_logic_vector(2 downto 0);
  signal s_halt_WB         : std_logic;
  
  signal s_RegWrite_ctrl : std_logic;

  -- ===================Components===================
  component PC is
  port(clk      : in std_logic;
       rst      : in std_logic;
       RegWrite : in std_logic;
       DATA_IN  : in std_logic_vector(N-1 downto 0);
       OS       : out std_logic_vector(N-1 downto 0));
end component;

component carry_adder_N is
  generic(N : integer := 32);
  port(A_i  : in std_logic_vector(N-1 downto 0);
       B_i  : in std_logic_vector(N-1 downto 0);
       C_in : in std_logic;
       S_i  : out std_logic_vector(N-1 downto 0);
       C_out: out std_logic);
end component;

component mux2t1_N is
  generic(N : integer := 32);
  port(i_S  : in std_logic;
       i_D0 : in std_logic_vector(N-1 downto 0);
       i_D1 : in std_logic_vector(N-1 downto 0);
       o_O  : out std_logic_vector(N-1 downto 0));
end component;

component mem is
  generic(ADDR_WIDTH : integer := ADDR_WIDTH;
          DATA_WIDTH : integer := DATA_WIDTH);
  port(clk  : in std_logic;
       addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
       data : in std_logic_vector(DATA_WIDTH-1 downto 0);
       we   : in std_logic;
       q    : out std_logic_vector(DATA_WIDTH-1 downto 0));
end component;

component IF_ID is
  port (
    in_instruct     : in std_logic_vector(31 downto 0);
    in_PC_val       : in std_logic_vector(31 downto 0);
    in_PC_plus4     : in std_logic_vector(31 downto 0);
    in_stall_fetch  : in std_logic;
    in_flush_fetch  : in std_logic;
    WE              : in std_logic;
    out_instruct    : out std_logic_vector(31 downto 0);
    out_PC_val      : out std_logic_vector(31 downto 0);
    out_PC_plus4    : out std_logic_vector(31 downto 0);
    RST             : in std_logic;
    CLK             : in std_logic
  );
end component;

component hazard_detection is
  port (
    i_opcode_execute  : in  std_logic_vector(6 downto 0); 
    i_rs1_decode      : in  std_logic_vector(4 downto 0);
    i_rs2_decode       : in  std_logic_vector(4 downto 0);
    i_rd_execute      : in  std_logic_vector(4 downto 0);
    i_offsetpc        : in  std_logic;
    o_stall_pc        : out std_logic;
    o_stall_IF_ID     : out std_logic;
    o_stall_ID_EX     : out std_logic;
    o_flush_fetch     : out std_logic;
    o_flush_decode    : out std_logic;
    o_flush_execute   : out std_logic
  );
end component;

component control is
  port (i_opcode     : in std_logic_vector(6 downto 0);
        i_funct3     : in std_logic_vector(2 downto 0);
        i_funct7     : in std_logic_vector(6 downto 0);
        i_imm        : in std_logic_vector(11 downto 0);
        o_ALUSRC     : out std_logic;
        o_ALUControl : out std_logic_vector(3 downto 0);
        o_ImmType    : out std_logic_vector(2 downto 0);
        o_Mem_Write  : out std_logic;
        o_RegWrite   : out std_logic;
        o_imm_sel    : out std_logic_vector(1 downto 0);
        o_BranchType : out std_logic_vector(2 downto 0);
        o_MemtoReg   : out std_logic;
        o_halt       : out std_logic;
        o_Jump       : out std_logic;
        o_Link       : out std_logic;
        o_Branch     : out std_logic;
        o_auipcSrc   : out std_logic;
        o_PCReg      : out std_logic;
        o_load       : out std_logic_vector(2 downto 0));
end component;

component RV32_regFile is
  port(clk      : in std_logic;
       rst      : in std_logic;
       RegWrite : in std_logic;
       Rd       : in std_logic_vector(4 downto 0);
       DATA_IN  : in std_logic_vector(N-1 downto 0);
       RS1      : in std_logic_vector(4 downto 0);
       RS2      : in std_logic_vector(4 downto 0);
       OS1      : out std_logic_vector(N-1 downto 0);
       OS2      : out std_logic_vector(N-1 downto 0));
end component;

component butter_extender_Nt32 is
  generic(N : integer := 32);
  port(imm_in     : in std_logic_vector(N-1 downto 0);
       sign_ext   : in std_logic_vector(1 downto 0);
       imm_type   : in std_logic_vector(2 downto 0);
       imm_out    : out std_logic_vector(N-1 downto 0));
end component;

component ID_EX is
   port (
    in_ALUSrc        : in std_logic;
    in_ALUControl    : in std_logic_vector(3 downto 0);
    in_ImmType       : in std_logic_vector(2 downto 0);
    in_regWrite      : in std_logic;
    in_regWrite_addr : in std_logic_vector(4 downto 0);
    in_MemWrite      : in std_logic;
    in_imm_sel       : in std_logic_vector(1 downto 0);
    in_branch_type   : in std_logic_vector(2 downto 0);
    in_jump          : in std_logic;
    in_link          : in std_logic;
    in_branch        : in std_logic;
    in_PCReg         : in std_logic;
    in_auipc         : in std_logic;
    in_data1         : in std_logic_vector(31 downto 0);
    in_data2         : in std_logic_vector(31 downto 0);
    in_extender      : in std_logic_vector(31 downto 0);
    in_halt          : in std_logic;
    in_MemtoReg      : in std_logic;
    in_load          : in std_logic_vector(2 downto 0);
    in_pc_val        : in std_logic_vector(31 downto 0);
    in_pc_plus4      : in std_logic_vector(31 downto 0);
    in_instruct      : in std_logic_vector(31 downto 0);
    in_stall_decode  : in std_logic;
    in_flush_decode  : in std_logic;
    WE               : in std_logic;
    out_ALUSrc       : out std_logic;
    out_ALUControl   : out std_logic_vector(3 downto 0);
    out_ImmType      : out std_logic_vector(2 downto 0);
    out_MemWrite     : out std_logic;
    out_regWrite     : out std_logic;
    out_regWrite_addr : out std_logic_vector(4 downto 0);
    out_imm_sel      : out std_logic_vector(1 downto 0);
    out_branch_type  : out std_logic_vector(2 downto 0);
    out_jump         : out std_logic;
    out_link         : out std_logic;
    out_branch       : out std_logic;
    out_PCReg        : out std_logic;
    out_auipc        : out std_logic;
    out_data1        : out std_logic_vector(31 downto 0);
    out_data2        : out std_logic_vector(31 downto 0);
    out_extender     : out std_logic_vector(31 downto 0);
    out_halt         : out std_logic;
    out_MemtoReg     : out std_logic;
    out_load         : out std_logic_vector(2 downto 0);
    out_pc_val       : out std_logic_vector(31 downto 0);
    out_pc_plus4     : out std_logic_vector(31 downto 0);
    out_instruct     : out std_logic_vector(31 downto 0);
    RST              : in std_logic;
    CLK              : in std_logic
  );
end component;

component mux_4t1 is
  generic(N : integer := 32);
  port(sel : in std_logic_vector(1 downto 0);
       in0 : in std_logic_vector(N-1 downto 0);
       in1 : in std_logic_vector(N-1 downto 0);
       in2 : in std_logic_vector(N-1 downto 0);
       in3 : in std_logic_vector(N-1 downto 0);
       y   : out std_logic_vector(N-1 downto 0));
end component;

component ALU_Total is
  port(A               : in std_logic_vector(N-1 downto 0);
       B               : in std_logic_vector(N-1 downto 0);
       ALU_Control     : in std_logic_vector(3 downto 0);
       Branch_Control  : in std_logic_vector(2 downto 0);
       S               : out std_logic_vector(N-1 downto 0);
       zero            : out std_logic;
       overflow        : out std_logic);
end component;

component Left_Shifter is
  port(i : in std_logic_vector(N-1 downto 0);
       o : out std_logic_vector(N-1 downto 0));
end component;

component forwarding_unit is
  port(i_rs1_ex         : in std_logic_vector(4 downto 0);
       i_rs2_ex         : in std_logic_vector(4 downto 0);
       i_rd_mem         : in std_logic_vector(4 downto 0);
       i_rd_wb          : in std_logic_vector(4 downto 0);
       i_regWrite_mem   : in std_logic;
       i_regWrite_wb    : in std_logic;
       i_ALU_src        : in std_logic;
       i_auipc          : in std_logic;
       o_alu_a_mux      : out std_logic_vector(1 downto 0);
       o_alu_b_mux      : out std_logic_vector(1 downto 0);
       o_sw_mux         : out std_logic_vector(1 downto 0));
end component;

component EX_MEM is
  port(in_ImmType          : in std_logic_vector(2 downto 0);
       in_MemWrite         : in std_logic;
       in_imm_sel          : in std_logic_vector(1 downto 0);
       in_branch_type      : in std_logic_vector(2 downto 0);
       in_jump             : in std_logic;
       in_branch           : in std_logic;
       in_PCReg            : in std_logic;
       in_data1            : in std_logic_vector(N-1 downto 0);
       in_data2            : in std_logic_vector(N-1 downto 0);
       in_extender         : in std_logic_vector(N-1 downto 0);
       in_halt             : in std_logic;
       in_MemtoReg         : in std_logic;
       in_regWrite         : in std_logic;
       in_regWrite_addr    : in std_logic_vector(4 downto 0);
       in_load             : in std_logic_vector(2 downto 0);
       in_mux              : in std_logic_vector(N-1 downto 0);
       in_alu              : in std_logic_vector(N-1 downto 0);
       in_zero             : in std_logic;
       in_PC_offset        : in std_logic_vector(N-1 downto 0);
       in_instruct         : in std_logic_vector(31 downto 0);
       in_flush_execute    : in std_logic;
       WE                  : in std_logic;
       out_ImmType         : out std_logic_vector(2 downto 0);
       out_MemWrite        : out std_logic;
       out_regWrite        : out std_logic;
       out_regWrite_addr   : out std_logic_vector(4 downto 0);
       out_imm_sel         : out std_logic_vector(1 downto 0);
       out_branch_type     : out std_logic_vector(2 downto 0);
       out_jump            : out std_logic;
       out_branch          : out std_logic;
       out_PCReg           : out std_logic;
       out_data1           : out std_logic_vector(N-1 downto 0);
       out_data2           : out std_logic_vector(N-1 downto 0);
       out_extender        : out std_logic_vector(N-1 downto 0);
       out_halt            : out std_logic;
       out_MemtoReg        : out std_logic;
       out_load            : out std_logic_vector(2 downto 0);
       out_mux             : out std_logic_vector(N-1 downto 0);
       out_alu             : out std_logic_vector(N-1 downto 0);
       out_zero            : out std_logic;
       out_PC_offset       : out std_logic_vector(N-1 downto 0);
       out_instruct         : out std_logic_vector(31 downto 0);
       RST                 : in std_logic;
       CLK                 : in std_logic);
end component;

-- Note: 'mem' component is reused for Data Memory.

component MEM_WB is
  port(in_dmem             : in std_logic_vector(N-1 downto 0);
       in_MemtoReg         : in std_logic;
       in_RegWrite         : in std_logic;
       in_regWrite_addr    : in std_logic_vector(4 downto 0);
       in_mux              : in std_logic_vector(N-1 downto 0);
       in_alu              : in std_logic_vector(N-1 downto 0);
       in_load             : in std_logic_vector(2 downto 0);
       in_halt             : in std_logic;
       WE                  : in std_logic;
       out_dmem            : out std_logic_vector(N-1 downto 0);
       out_MemtoReg        : out std_logic;
       out_RegWrite        : out std_logic;
       out_regWrite_addr   : out std_logic_vector(4 downto 0);
       out_mux             : out std_logic_vector(N-1 downto 0);
       out_alu             : out std_logic_vector(N-1 downto 0);
       out_load            : out std_logic_vector(2 downto 0);
       out_halt            : out std_logic;
       RST                 : in std_logic;
       CLK                 : in std_logic);
end component;

component load_handler is
  port(DMEM_in      : in std_logic_vector(N-1 downto 0);
       load_control : in std_logic_vector(2 downto 0);
       offset       : in std_logic_vector(1 downto 0);
       DMEM_out     : out std_logic_vector(N-1 downto 0));
end component;
  
begin

  -- ================IF=========================  
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;

  s_NextInstAddr <= s_PC_out;

  PC_reg : PC
    port map (
        clk      => iCLK,
        rst      => iRST,
        RegWrite => not s_stall_pc, 
        DATA_IN  => s_PC_in,
        OS       => s_PC_out
    );

  plus4 : carry_adder_N
  generic map(N => 32)
  port map (
    A_i  => s_PC_out,
    B_i  => x"00000004",
    C_in => '0',
    S_i  => s_PC_plus4,
    C_out => s_cout_plus4
  );
  
  -- Jump/Branch decision mux: selects between PC+4 or jump/branch target
  mux_jump : mux2t1_N
    generic map (N => 32)
    port map (
      i_S  => s_take_branch_or_jump,
      i_D0 => s_PC_plus4,
      i_D1 => s_PC_offset_MEM,
      o_O  => s_PC_PCReg_out
  );

  -- PCReg mux: selects between normal flow or register value (for JALR)
  mux_PCReg : mux2t1_N
    generic map (N => 32)
    port map (
      i_S => s_PCReg_MEM,
      i_D0 => s_PC_PCReg_out,
      i_D1 => s_alu_MEM,
      o_O => s_PC_in
  );

  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);


  reg_IF_ID : IF_ID 
    port map (
      in_instruct     => s_Inst,
      in_PC_val       => s_PC_out,  
      in_PC_plus4     => s_PC_plus4,    
      in_stall_fetch  => s_stall_IF_ID,
      in_flush_fetch  => s_flush_fetch,
      WE              => '1',
      out_instruct    => s_Inst_ID, 
      out_PC_val      => s_PC_val_ID, 
      out_PC_plus4    => s_PC_plus4_ID,   
      RST             => iRST,        
      CLK             => iCLK    
  );

-- ===================ID===================
  -- Write Enable to RegFile is conditioned on RegWrite_WB and Rd not being x0
  --s_RegWr <= s_RegWrite_WB when s_RegWriteAddr_WB /= "00000" else '0';
s_RegWr <= s_RegWrite_WB;

  s_RegWrAddr <= s_RegWriteAddr_WB;

  hudini_hdu : hazard_detection
    port map (
      i_opcode_execute => s_Inst_EX(6 downto 0),  
      i_rs1_decode     => s_Inst_ID(19 downto 15), 
      i_rs2_decode     => s_Inst_ID(24 downto 20), 
      i_rd_execute     => s_RegWriteAddr_EX, 
      i_offsetpc       => s_take_branch_or_jump, 
      o_stall_pc       => s_stall_pc, 
      o_stall_IF_ID    => s_stall_IF_ID, 
      o_stall_ID_EX    => s_stall_ID_EX, 
      o_flush_fetch    => s_flush_fetch, 
      o_flush_decode   => s_flush_decode, 
      o_flush_execute  => s_flush_execute 
    );

  mind_control : control
    port map (
      i_opcode     => s_Inst_ID(6 downto 0),
      i_funct3     => s_Inst_ID(14 downto 12),
      i_funct7     => s_Inst_ID(31 downto 25),
      i_imm        => s_Inst_ID(31 downto 20),
      o_ALUSRC     => s_ALUSRC,
      o_ALUControl => s_ALUControl,
      o_ImmType    => s_ImmType,
      o_Mem_Write  => s_Mem_Write,
      o_RegWrite   => s_RegWrite,
      o_imm_sel    => s_imm_sel,
      o_BranchType => s_BranchType,
      o_MemtoReg   => s_MemtoReg,
      o_halt       => s_halt_ID,
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

    Sign_Extend : butter_extender_Nt32
      generic map (N => 32)
      port map (
        imm_in     => s_Inst_ID,
        sign_ext   => s_imm_sel,
        imm_type   => s_ImmType,
        imm_out    => s_extended_imm
      );
  
  -- ID/EX Pipeline Register Write Enable (stalled on load-use)

  reg_ID_EX : ID_EX
    port map (
      in_ALUSrc          => s_ALUSRC,                      
      in_ALUControl      => s_ALUControl,                      
      in_ImmType         => s_ImmType,                       
      in_regWrite        => s_RegWrite,
      in_regWrite_addr   => s_Inst_ID(11 downto 7),
      in_MemWrite        => s_Mem_Write,                       
      in_imm_sel         => s_imm_sel,                       
      in_branch_type     => s_BranchType,
      in_jump            => s_Jump,                      
      in_link            => s_Link,
      in_branch          => s_Branch,                      
      in_PCReg           => s_PCReg,                           
      in_auipc           => s_auipcSrc,                      
      in_data1           => s_OS1,
      in_data2           => s_OS2,
      in_extender        => s_extended_imm,
      in_halt            => s_halt_ID,
      in_MemtoReg        => s_MemtoReg,                      
      in_load            => s_load,
      in_pc_val          => s_PC_val_ID,
      in_pc_plus4        => s_PC_plus4_ID,
      in_instruct        => s_Inst_ID,
      in_stall_decode    => s_stall_ID_EX,
      in_flush_decode    => s_flush_decode,
      WE                 => '1',                            
      out_ALUSrc         => s_ALUSrc_EX,                   
      out_ALUControl     => s_ALUControl_EX,
      out_ImmType        => s_ImmType_EX,                      
      out_MemWrite       => s_MemWrite_EX,
      out_regWrite_addr  => s_RegWriteAddr_EX,
      out_regWrite       => s_RegWrite_EX,
      out_imm_sel        => s_imm_sel_EX,
      out_branch_type    => s_branch_type_EX,
      out_jump           => s_jump_EX,
      out_link           => s_link_EX,
      out_branch         => s_Branch_EX,
      out_PCReg          => s_PCReg_EX,
      out_auipc          => s_auipc_EX,
      out_data1          => s_data1_EX,
      out_data2          => s_data2_EX,
      out_extender       => s_extender_EX,
      out_halt           => s_halt_EX,
      out_MemtoReg       => s_MemToReg_EX,
      out_load           => s_load_EX,
      out_pc_val         => s_PC_val_EX,
      out_pc_plus4       => s_PC_plus4_EX,
      out_instruct       => s_Inst_EX,
      RST                => iRST,
      CLK                => iCLK            
    );

-- ==================EX==========================
  -- ALU Input Muxes (Simplistic connections without full forwarding logic)
  ALU_Src_Mux : mux_4t1
    generic map (N => 32)
    port map (
      sel => s_alu_b_mux,  
      in0 => s_data2_EX,   -- normal (RS1)
      in1 => s_RegWrData,  -- WB Forwarding (Result from WB)
      in2 => s_alu_MEM,    -- MEM Forwarding (ALU Result from MEM)
      in3 => s_extender_EX,  -- imm value
      y   => s_ALU_B   
    );

  AuiPC_Mux : mux_4t1
    generic map (N => 32)
    port map (
      sel => s_alu_a_mux, 
      in0 => s_data1_EX,   -- normal (RS2)
      in1 => s_RegWrData,  -- WB Forwarding (Result from WB)
      in2 => s_alu_MEM,    -- MEM Forwarding (ALU Result from MEM)
      in3 => s_PC_val_EX,  -- auipc (PC value)
      y   => s_ALU_A  
    );

  SW_Mux : mux_4t1
    generic map (N => 32)
    port map (
      sel => s_sw_mux, 
      in0 => s_data2_EX,  
      in1 => s_RegWrData,  
      in2 => s_alu_MEM,    
      in3 => s_extender_EX,  
      y   => s_dmem_data_EX  
    );
      
  ALU : ALU_Total
    port map (
      A               => s_ALU_A,
      B               => s_ALU_B,
      ALU_Control     => s_ALUControl_EX,
      Branch_Control  => s_branch_type_EX,
      S               => s_ALU_Out,
      zero            => s_Zero,
      overflow        => s_Ovfl
    );
  oALUOut <= s_ALU_Out;

  -- AndLink saves PC+4 for JAL/JALR instructions
  AndLink_Mux : mux2t1_N
    generic map (N => 32)
    port map (
      i_S     => s_link_EX,
      i_D0    => s_ALU_Out,
      i_D1    => s_PC_plus4_EX,
      o_O     => s_andLink_mux_out
    );      

  -- Left shift immediate for branch/jump offset calculation
  shift_off : Left_Shifter 
    port map (
      i => s_extender_EX,
      o => imm_shifted_s
    );

  -- Calculate PC + offset for branches/jumps
  instr_addr_s <= s_PC_val_EX;
    
  pc_plus_offset : carry_adder_N
  generic map(N => 32)
  port map (
    A_i => instr_addr_s,
    B_i => imm_shifted_s,
    C_in => '0',
    S_i => PC_offset_s,
    C_out => PC_off_cOut_s
  );

  forward : forwarding_unit
    port map (
      i_rs1_ex         => s_Inst_EX(19 downto 15),
      i_rs2_ex         => s_Inst_EX(24 downto 20), 
      i_rd_mem         => s_RegWriteAddr_MEM, 
      i_rd_wb          => s_RegWriteAddr_WB,  
      i_regWrite_mem   => s_RegWrite_MEM, 
      i_regWrite_wb    => s_RegWrite_WB,  
      i_ALU_src        => s_ALUSrc_EX, -- Placeholder
      i_auipc          => s_auipc_EX, -- Placeholder
      o_alu_a_mux      => s_alu_a_mux, 
      o_alu_b_mux      => s_alu_b_mux,
      o_sw_mux         => s_sw_mux
    );

  reg_EX_MEM : EX_MEM
    port map (
      in_ImmType          => s_ImmType_EX,          
      in_MemWrite         => s_MemWrite_EX,       
      in_imm_sel          => s_imm_sel_EX,        
      in_branch_type      => s_branch_type_EX,          
      in_jump             => s_jump_EX,
      in_branch           => s_Branch_EX,
      in_PCReg            => s_PCReg_EX,        
      in_data1            => s_data1_EX,          
      in_data2            => s_dmem_data_EX, 
      in_extender         => s_extender_EX,       
      in_halt             => s_halt_EX,   
      in_MemtoReg         => s_MemToReg_EX,         
      in_regWrite         => s_RegWrite_EX,
      in_regWrite_addr    => s_RegWriteAddr_EX,
      in_load             => s_load_EX,   
      in_mux              => s_andLink_mux_out,
      in_alu              => s_ALU_Out,           
      in_zero             => s_Zero,
      in_PC_offset        => PC_offset_s,
      in_instruct         => s_Inst_EX,
      in_flush_execute    => s_flush_execute,
      WE                  => '1',           
      out_ImmType         => s_ImmType_MEM,   
      out_MemWrite        => s_DMemWr,          
      out_regWrite        => s_RegWrite_MEM,
      out_regWrite_addr   => s_RegWriteAddr_MEM,
      out_imm_sel         => s_imm_sel_MEM,         
      out_branch_type     => s_branch_type_MEM,
      out_jump            => s_jump_MEM,
      out_branch          => s_Branch_MEM,
      out_PCReg           => s_PCReg_MEM,         
      out_data1           => s_data1_MEM,           
      out_data2           => s_data2_MEM,
      out_extender        => s_extender_MEM,        
      out_halt            => s_halt_MEM,        
      out_MemtoReg        => s_MemToReg_MEM,        
      out_load            => s_load_MEM,          
      out_mux             => s_mux_MEM,           
      out_alu             => s_alu_MEM,  
      out_zero            => s_zero_MEM,
      out_PC_offset       => s_PC_offset_MEM,
      out_instruct        => s_inst_MEM,
      RST                 => iRST,          
      CLK                 => iCLK        
    );

-- ===================MEM=================
  s_DMemAddr <= s_alu_MEM;
  s_DMemData <= s_data2_MEM;

  -- Branch/Jump control logic:
  -- AND gate: branch AND zero -> branch_taken
  -- OR gate: branch_taken XOR jump -> take_branch_or_jump
  s_branch_taken <= s_Branch_MEM and s_zero_MEM;
  s_take_branch_or_jump <= s_branch_taken xor s_jump_MEM;

  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  reg_MEM_WB : MEM_WB 
    port map (
      in_dmem             => s_DMemOut,   
      in_MemtoReg         => s_MemToReg_MEM,        
      in_RegWrite         => s_RegWrite_MEM,        
      in_regWrite_addr    => s_RegWriteAddr_MEM,
      in_mux              => s_mux_MEM,         
      in_alu              => s_alu_MEM,
      in_load             => s_load_MEM,
      in_halt             => s_halt_MEM,
      WE                  => '1',           
      out_dmem            => s_dmem_WB,         
      out_MemtoReg        => s_MemtoReg_WB,           
      out_RegWrite        => s_RegWrite_WB,           
      out_regWrite_addr   => s_RegWriteAddr_WB,
      out_mux             => s_mux_WB,            
      out_alu             => s_alu_WB,
      out_load            => s_load_WB,
      out_halt            => s_Halt,
      RST                 => iRST,          
      CLK                 => iCLK        
    );

-- =================WB===================

  DMEM_fixer : load_handler 
    port map (
      DMEM_in      => s_dmem_WB,
      load_control => s_load_WB,
      offset       => s_alu_WB(1 downto 0),
      DMEM_out     => s_DMEM_fixed
    );
      
  MemtoReg_Mux : mux2t1_N
    generic map (N => 32)
    port map (
      i_S  => s_MemtoReg_WB,
      i_D0 => s_mux_WB,
      i_D1 => s_DMEM_fixed,
      o_O  => s_RegWrData
    );

end structure;
