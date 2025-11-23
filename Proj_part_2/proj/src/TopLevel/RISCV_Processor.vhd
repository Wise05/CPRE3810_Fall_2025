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
  signal s_PC_plus4_ID : std_logic_vector(31 downto 0);
  signal s_stall_pc      : std_logic;
  signal s_flush_fetch   : std_logic;

  -- ==========ID SIGS==================
  signal s_Inst_ID : std_logic_vector(N-1 downto 0);

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
  signal s_jalr        : std_logic; -- Not used in control but kept for future
  signal s_halt_ID     : std_logic;
  signal s_stall_decode  : std_logic;
  signal s_flush_decode  : std_logic;

  -- Sign extend
  signal s_extended_imm : std_logic_vector(31 downto 0);
  signal s_OS1 : std_logic_vector(31 downto 0);
  signal s_OS2 : std_logic_vector(31 downto 0);
  signal s_reg_write_addr_ID : std_logic_vector(4 downto 0);

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
  signal s_stall_execute : std_logic;
  signal s_flush_execute : std_logic;

  -- Forwarding signals
  signal s_forward_A_mux : std_logic_vector(1 downto 0);
  signal s_forward_B_mux : std_logic_vector(1 downto 0);
  signal s_ALU_A_forwarded : std_logic_vector(31 downto 0);
  signal s_ALU_B_forwarded : std_logic_vector(31 downto 0);
  signal s_Data2_forwarded : std_logic_vector(31 downto 0);

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
  signal s_MemWrite_MEM    : std_logic; -- Connected to s_DMemWr
  signal s_RegWrite_MEM    : std_logic;
  signal s_RegWriteAddr_MEM : std_logic_vector(4 downto 0);
  signal s_imm_sel_MEM     : std_logic_vector(1 downto 0);
  signal s_branch_type_MEM: std_logic_vector(2 downto 0);
  signal s_jump_MEM        : std_logic;
  signal s_PCReg_MEM       : std_logic;
  signal s_data1_MEM       : std_logic_vector(31 downto 0);
  signal s_data2_MEM       : std_logic_vector(31 downto 0); -- Connected to s_DMemData
  signal s_extender_MEM    : std_logic_vector(31 downto 0);
  signal s_halt_MEM        : std_logic;
  signal s_MemToReg_MEM    :  std_logic;
  signal s_load_MEM        : std_logic_vector(2 downto 0);
  signal s_mux_MEM         : std_logic_vector(31 downto 0);
  signal s_alu_MEM         : std_logic_vector(31 downto 0); -- Connected to s_DMemAddr
  signal s_zero_MEM        : std_logic;
  signal s_Branch_MEM      : std_logic;
  signal s_PC_offset_MEM   : std_logic_vector(31 downto 0);

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
  
  -- Mux for data2 in MEM/WB (needed for store/load data forwarding)
  signal s_Data2_Mux_sel_EX : std_logic_vector(1 downto 0); -- Forwarding select for Data2
  signal s_Data2_Mux_EX_out : std_logic_vector(31 downto 0); -- Forwarded Data2 value

  -- ===================Components===================
  -- (Component declarations omitted for brevity, assuming they are available)
  
  component forwarding_unit is
    port (
      i_rs1_ex         : in  std_logic_vector(4 downto 0);
      i_rs2_ex         : in  std_logic_vector(4 downto 0);
      i_rd_mem         : in  std_logic_vector(4 downto 0);
      i_rd_wb          : in  std_logic_vector(4 downto 0);
      i_regWrite_mem   : in  std_logic;
      i_regWrite_wb    : in  std_logic;
      o_alu_a_mux      : out std_logic_vector(1 downto 0);
      o_alu_b_mux      : out std_logic_vector(1 downto 0)
    );
  end component;
  
begin

  -- ================Global Halt Condition=================
  s_Halt <= s_halt_WB;
  
  -- ================IF========================= 
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;

  PC_reg : PC
    port map (
        clk      => iCLK,
        rst      => iRST,
        RegWrite => s_stall_pc,
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
      i_D1 => s_PC_offset_MEM, -- Branch/Jump target is calculated in EX
      o_O  => s_PC_PCReg_out
  );

  -- PCReg mux: selects between normal flow or register value (for JALR)
  mux_PCReg : mux2t1_N
    generic map (N => 32)
    port map (
      i_S => s_PCReg_MEM,
      i_D0 => s_NextInstAddr, -- Should be the next instruction address (PC+4 or branch/jump target)
      i_D1 => s_alu_MEM, -- JALR target address
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

  -- IF/ID Pipeline Register WE signal: Stalled if s_stall_pc='1'
  signal s_IF_ID_WE : std_logic;
  s_IF_ID_WE <= not s_stall_pc;
  
  reg_IF_ID : IF_ID 
    port map (
      in_instruct     => s_Inst,
      in_PC_val       => s_PC_out,  
      in_PC_plus4     => s_PC_plus4,    
      in_flush_fetch  => s_flush_fetch, -- Flush the instruction on a taken branch/jump
      WE              => s_IF_ID_WE,
      out_instruct    => s_Inst_ID, 
      out_PC_val      => s_PC_val_ID, 
      out_PC_plus4    => s_PC_plus4_ID,   
      RST             => iRST,        
      CLK             => iCLK    
  );

-- ===================ID===================
  -- Write Enable to RegFile is only active if RegWrite is asserted AND Rd is not x0
  s_RegWr <= s_RegWrite_WB and (not (s_RegWriteAddr_WB = "00000"));

  s_RegWrAddr <= s_RegWriteAddr_WB;
  s_reg_write_addr_ID <= s_Inst_ID(11 downto 7);

  -- Determine if the current instruction is a JALR (PCReg is high)
  -- Or if it's an immediate type (auipc) that needs the PC as a register source
  s_jalr <= '1' when s_Inst_ID(6 downto 0) = RISCV_JALR else '0';
  
  hudini_hdu : hazard_detection
    port map (
      i_opcode_execute => s_Inst_ID(6 downto 0),  -- ID stage instruction
      i_opcode_memory  => s_alu_MEM(6 downto 0), -- MEM stage instruction (assuming ALU Out carries the instruction)
      i_rs1            => s_Inst_ID(19 downto 15), -- RS1 of ID
      i_rs2            => s_Inst_ID(24 downto 20), -- RS2 of ID
      i_rd             => s_RegWriteAddr_EX, -- Destination register of EX stage
      i_offsetpc       => s_Branch or s_Jump, -- Instruction in ID could cause a PC change
      o_stall_pc       => s_stall_pc,
      o_stall_decode   => s_stall_decode,
      o_stall_execute  => s_stall_execute,
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
      
  -- ID/EX Pipeline Register WE signal: Stalled if s_stall_decode='1'
  signal s_ID_EX_WE : std_logic;
  s_ID_EX_WE <= not s_stall_decode;

  reg_ID_EX : ID_EX
    port map (
      in_ALUSrc          => s_ALUSRC,                      
      in_ALUControl      => s_ALUControl,                      
      in_ImmType         => s_ImmType,                       
      in_regWrite        => s_RegWrite,
      in_regWrite_addr   => s_reg_write_addr_ID, -- rd field from instruction
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
      in_stall_decode    => s_stall_decode, -- Pass through stall signal for ID
      in_flush_decode    => s_flush_decode, -- Flush on taken branch/jump/halt
      WE                 => s_ID_EX_WE,                            
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
      RST                => iRST,
      CLK                => iCLK            
    );

-- ==================EX==========================

  forward : forwarding_unit
    port map (
      i_rs1_ex         => s_Inst_ID(19 downto 15), -- RS1 address in ID
      i_rs2_ex         => s_Inst_ID(24 downto 20), -- RS2 address in ID
      i_rd_mem         => s_RegWriteAddr_MEM, -- RD address in MEM
      i_rd_wb          => s_RegWriteAddr_WB, -- RD address in WB
      i_regWrite_mem   => s_RegWrite_MEM, -- RegWrite in MEM
      i_regWrite_wb    => s_RegWrite_WB, -- RegWrite in WB
      o_alu_a_mux      => s_forward_A_mux, -- Forwarding control for ALU A input
      o_alu_b_mux      => s_forward_B_mux  -- Forwarding control for ALU B input
    );
    
  -- ALU Input A Mux (for Data1 forwarding)
  Mux_Forward_A : mux4t1_N
    generic map (WIDTH => 32)
    port map (
      sel => s_forward_A_mux, 
      in0 => s_data1_EX,                                    -- 00: No forwarding (Data1 from reg file)
      in1 => s_RegWrData,                                   -- 01: Forward from WB stage (s_RegWrData)
      in2 => s_alu_MEM,                                     -- 10: Forward from MEM stage (ALU result)
      in3 => s_PC_val_EX,                                   -- 11: Used for auipc (PC value)
      y   => s_ALU_A_forwarded
    );
    
  -- ALU Input B Mux (for Data2 forwarding)
  Mux_Forward_B : mux4t1_N
    generic map (WIDTH => 32)
    port map (
      sel => s_forward_B_mux,
      in0 => s_data2_EX,                                    -- 00: No forwarding (Data2 from reg file)
      in1 => s_RegWrData,                                   -- 01: Forward from WB stage (s_RegWrData)
      in2 => s_alu_MEM,                                     -- 10: Forward from MEM stage (ALU result)
      in3 => s_extended_imm,                                -- 11: Immediate value (for R-Type/S-Type/I-Type)
      y   => s_ALU_B_forwarded
    );

  -- ALU A Source Mux (Selects between forwarded Data1/PC for AUIPC)
  Mux_ALU_A : mux2t1_N
    generic map (N => 32)
    port map (
      i_S  => s_auipc_EX,
      i_D0 => s_ALU_A_forwarded,
      i_D1 => s_PC_val_EX,
      o_O  => s_ALU_A
    );
    
  -- ALU B Source Mux (Selects between forwarded Data2 or Immediate)
  Mux_ALU_B : mux2t1_N
    generic map (N => 32)
    port map (
      i_S  => s_ALUSrc_EX,
      i_D0 => s_ALU_B_forwarded,
      i_D1 => s_extended_imm,
      o_O  => s_ALU_B
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

  -- Data2 (Store data) forwarding mux - uses the same forwarding controls as ALU B
  Mux_Data2_Forwarding : mux4t1_N
    generic map (WIDTH => 32)
    port map (
      sel => s_forward_B_mux,
      in0 => s_data2_EX,
      in1 => s_RegWrData,
      in2 => s_alu_MEM,
      in3 => x"00000000", -- Default/unused
      y   => s_Data2_Mux_EX_out
    );

  -- EX/MEM Pipeline Register WE signal: Stalled if s_stall_execute='1'
  signal s_EX_MEM_WE : std_logic;
  s_EX_MEM_WE <= not s_stall_execute;

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
      in_data2            => s_Data2_Mux_EX_out, -- Forwarded Data2 for stores
      in_extender         => s_extender_EX,       
      in_halt             => s_halt_EX,   
      in_MemtoReg         => s_MemToReg_EX,         
      in_regWrite         => s_RegWrite_EX,
      in_regWrite_addr    => s_RegWriteAddr_EX,
      in_load             => s_load_EX,   
      in_mux              => s_andLink_mux_out, -- PC+4 or ALU result
      in_alu              => s_ALU_Out,           
      in_zero             => s_Zero,
      in_PC_offset        => PC_offset_s, -- Branch/Jump target address
      WE                  => s_EX_MEM_WE,           
      out_ImmType         => s_ImmType_MEM,   
      out_MemWrite        => s_DMemWr,          -- Data Memory Write Enable
      out_regWrite        => s_RegWrite_MEM,
      out_regWrite_addr   => s_RegWriteAddr_MEM,
      out_imm_sel         => s_imm_sel_MEM,         
      out_branch_type     => s_branch_type_MEM,
      out_jump            => s_jump_MEM,
      out_branch          => s_Branch_MEM,
      out_PCReg           => s_PCReg_MEM,         
      out_data1           => s_data1_MEM,           
      out_data2           => s_DMemData,            -- Data for stores
      out_extender        => s_extender_MEM,        
      out_halt            => s_halt_MEM,        
      out_MemtoReg        => s_MemToReg_MEM,        
      out_load            => s_load_MEM,          
      out_mux             => s_mux_MEM,           
      out_alu             => s_DMemAddr,            -- ALU Result (Data Memory Address)
      out_zero            => s_zero_MEM,
      out_PC_offset       => s_PC_offset_MEM,
      RST                 => iRST,          
      CLK                 => iCLK        
    );

-- ===================MEM=================
  s_alu_MEM <= s_DMemAddr;
  s_data2_MEM <= s_DMemData;

  -- Branch/Jump control logic:
  -- AND gate: branch AND zero -> branch_taken
  -- XOR gate: branch_taken XOR jump -> take_branch_or_jump
  s_branch_taken <= s_Branch_MEM and s_zero_MEM;
  s_take_branch_or_jump <= s_branch_taken or s_jump_MEM; -- Jumps are unconditional

  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2), -- Byte addressable, use higher bits for word address
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
      in_alu              => s_alu_MEM, -- ALU result is passed (was s_DMemAddr)
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
      out_halt            => s_halt_WB,
      RST                 => iRST,          
      CLK                 => iCLK        
    );

-- =================WB===================

  DMEM_fixer : load_handler 
    port map (
      DMEM_in      => s_dmem_WB,
      load_control => s_load_WB,
      offset       => s_alu_WB(1 downto 0), -- Last two bits of ALU result (address) for byte offset
      DMEM_out     => s_DMEM_fixed
    );
      
  MemtoReg_Mux : mux2t1_N
    generic map (N => 32)
    port map (
      i_S  => s_MemtoReg_WB,
      i_D0 => s_mux_WB, -- ALU result or PC+4
      i_D1 => s_DMEM_fixed, -- Data from Data Memory
      o_O  => s_RegWrData
    );

end structure;
