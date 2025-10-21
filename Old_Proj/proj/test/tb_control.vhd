library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_control is
end tb_control;

architecture behavior of tb_control is

  -- Component Declaration
  component control
    port (
      i_opcode     : in  std_logic_vector(6 downto 0);
      i_funct3     : in  std_logic_vector(2 downto 0);
      i_funct7     : in  std_logic_vector(6 downto 0);
      o_ALUSRC     : out std_logic;
      o_ALUControl : out std_logic_vector(3 downto 0);
      o_ImmType    : out std_logic_vector(2 downto 0);
      o_ResultSrc  : out std_logic_vector(1 downto 0);
      o_Mem_Write  : out std_logic;
      o_RegWrite   : out std_logic;
      o_imm_sel    : out std_logic_vector(1 downto 0);
      o_BranchType : out std_logic_vector(1 downto 0);
      o_Jump       : out std_logic
    );
  end component;

  -- Signals
  signal i_opcode     : std_logic_vector(6 downto 0) := (others => '0');
  signal i_funct3     : std_logic_vector(2 downto 0) := (others => '0');
  signal i_funct7     : std_logic_vector(6 downto 0) := (others => '0');
  signal o_ALUSRC     : std_logic;
  signal o_ALUControl : std_logic_vector(3 downto 0);
  signal o_ImmType    : std_logic_vector(2 downto 0);
  signal o_ResultSrc  : std_logic_vector(1 downto 0);
  signal o_Mem_Write  : std_logic;
  signal o_RegWrite   : std_logic;
  signal o_imm_sel    : std_logic_vector(1 downto 0);
  signal o_BranchType : std_logic_vector(1 downto 0);
  signal o_Jump       : std_logic;

begin

  uut: control
    port map (
      i_opcode     => i_opcode,
      i_funct3     => i_funct3,
      i_funct7     => i_funct7,
      o_ALUSRC     => o_ALUSRC,
      o_ALUControl => o_ALUControl,
      o_ImmType    => o_ImmType,
      o_ResultSrc  => o_ResultSrc,
      o_Mem_Write  => o_Mem_Write,
      o_RegWrite   => o_RegWrite,
      o_imm_sel    => o_imm_sel,
      o_BranchType => o_BranchType,
      o_Jump       => o_Jump
    );

  -- Stimulus process
  stim_proc: process
  begin

    ----------------------------------------------------------------------
    --  I-TYPE INSTRUCTIONS
    ----------------------------------------------------------------------

    -- Test 1: ADDI (I-type)
    -- Expected: ALUSRC=1, ALUControl=0010, ImmType=000, ResultSrc=--, MemWrite=0,
    -- RegWrite=1, imm_sel=01, BranchType=--, Jump=0
    i_opcode <= "0010011"; i_funct3 <= "000"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 2: ANDI (I-type)
    -- Expected: ALUControl=0000
    i_opcode <= "0010011"; i_funct3 <= "111"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 3: ORI (I-type)
    -- Expected: ALUControl=0001
    i_opcode <= "0010011"; i_funct3 <= "110"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 4: XORI (I-type)
    -- Expected: ALUControl=0011
    i_opcode <= "0010011"; i_funct3 <= "100"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 5: SLTI (I-type)
    -- Expected: ALUControl=1000
    i_opcode <= "0010011"; i_funct3 <= "010"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 6: SLTIU (I-type)
    -- Expected: ALUControl=1001
    i_opcode <= "0010011"; i_funct3 <= "011"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 7: SLLI (I-type, funct3=001, funct7=0000000)
    -- Expected: ALUControl=0100
    i_opcode <= "0010011"; i_funct3 <= "001"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 8: SRLI (I-type, funct3=101, funct7=0000000)
    -- Expected: ALUControl=0101
    i_opcode <= "0010011"; i_funct3 <= "101"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 9: SRAI (I-type, funct3=101, funct7=0100000)
    -- Expected: ALUControl=0111
    i_opcode <= "0010011"; i_funct3 <= "101"; i_funct7 <= "0100000";
    wait for 100 ns;

    ----------------------------------------------------------------------
    --  R-TYPE INSTRUCTIONS
    ----------------------------------------------------------------------

    -- Test 10: ADD (R-type)
    -- Expected: ALUControl=0010, ALUSRC=0, RegWrite=1
    i_opcode <= "0110011"; i_funct3 <= "000"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 11: SUB (R-type)
    -- Expected: ALUControl=0110
    i_opcode <= "0110011"; i_funct3 <= "000"; i_funct7 <= "0100000";
    wait for 100 ns;

    -- Test 12: SLL (R-type)
    -- Expected: ALUControl=0100
    i_opcode <= "0110011"; i_funct3 <= "001"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 13: SRL (R-type)
    -- Expected: ALUControl=0101
    i_opcode <= "0110011"; i_funct3 <= "101"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 14: SRA (R-type)
    -- Expected: ALUControl=0111
    i_opcode <= "0110011"; i_funct3 <= "101"; i_funct7 <= "0100000";
    wait for 100 ns;

    -- Test 15: SLT (R-type)
    -- Expected: ALUControl=1000
    i_opcode <= "0110011"; i_funct3 <= "010"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 16: AND (R-type)
    -- Expected: ALUControl=0000
    i_opcode <= "0110011"; i_funct3 <= "111"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 17: OR (R-type)
    -- Expected: ALUControl=0001
    i_opcode <= "0110011"; i_funct3 <= "110"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 18: XOR (R-type)
    -- Expected: ALUControl=0011
    i_opcode <= "0110011"; i_funct3 <= "100"; i_funct7 <= "0000000";
    wait for 100 ns;

    ----------------------------------------------------------------------
    --  MEMORY INSTRUCTIONS
    ----------------------------------------------------------------------

    -- Test 19: LW (Load Word)
    -- Expected: ALUSRC=1, ALUControl=0010, ResultSrc=01, RegWrite=1, MemWrite=0
    i_opcode <= "0000011"; i_funct3 <= "010"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 20: SW (Store Word)
    -- Expected: ALUSRC=0 (per your logic), MemWrite=1, RegWrite=0
    i_opcode <= "0100011"; i_funct3 <= "010"; i_funct7 <= "0000000";
    wait for 100 ns;

    ----------------------------------------------------------------------
    --  BRANCH INSTRUCTIONS
    ----------------------------------------------------------------------

    -- Test 21: BEQ
    -- Expected: ALUControl=0110, BranchType=00, ALUSRC=1, Jump=0
    i_opcode <= "1100011"; i_funct3 <= "000"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 22: BNE
    -- Expected: BranchType=01
    i_opcode <= "1100011"; i_funct3 <= "001"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 23: BLT
    -- Expected: BranchType=10
    i_opcode <= "1100011"; i_funct3 <= "100"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 24: BGE
    -- Expected: BranchType=11
    i_opcode <= "1100011"; i_funct3 <= "101"; i_funct7 <= "0000000";
    wait for 100 ns;

    ----------------------------------------------------------------------
    --  JUMP INSTRUCTIONS
    ----------------------------------------------------------------------

    -- Test 25: JAL (Jump and Link)
    -- Expected: Jump=1, ALUControl=0010, ResultSrc=10, RegWrite=0
    i_opcode <= "1101111"; i_funct3 <= "000"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 26: JALR (Jump and Link Register)
    -- Expected: Jump=1, ALUSRC=1, ResultSrc=10
    i_opcode <= "1100111"; i_funct3 <= "000"; i_funct7 <= "0000000";
    wait for 100 ns;

    ----------------------------------------------------------------------
    --  U-TYPE INSTRUCTIONS
    ----------------------------------------------------------------------

    -- Test 27: LUI
    -- Expected: ALUControl=0001, ALUSRC=1, RegWrite=1, imm_sel=10
    i_opcode <= "0110111"; i_funct3 <= "000"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 28: AUIPC
    -- Expected: ALUControl=0010, ALUSRC=1, RegWrite=1, imm_sel=10
    i_opcode <= "0010111"; i_funct3 <= "000"; i_funct7 <= "0000000";
    wait for 100 ns;

    ----------------------------------------------------------------------
    -- END SIMULATION
    ----------------------------------------------------------------------
    wait;
  end process;

end behavior;

