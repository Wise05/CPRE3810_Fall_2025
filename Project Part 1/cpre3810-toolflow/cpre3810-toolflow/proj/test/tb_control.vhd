library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control_tb is
end control_tb;

architecture behavior of control_tb is

  -- Component Declaration for the Unit Under Test (UUT)
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

  -- Signals to connect to UUT
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

  -- Instantiate the Unit Under Test (UUT)
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

    -- Test 1: ADDI (I-type, opcode=0010011, funct3=000)
    i_opcode <= "0010011"; i_funct3 <= "000"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 2: ANDI (I-type, funct3=111)
    i_opcode <= "0010011"; i_funct3 <= "111"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 3: ORI (I-type, funct3=110)
    i_opcode <= "0010011"; i_funct3 <= "110"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 4: SLLI (I-type shift, funct3=001, funct7=0000000)
    i_opcode <= "0010011"; i_funct3 <= "001"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 5: SRLI (I-type shift right logical)
    i_opcode <= "0010011"; i_funct3 <= "101"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 6: SRAI (I-type shift right arithmetic)
    i_opcode <= "0010011"; i_funct3 <= "101"; i_funct7 <= "0100000";
    wait for 100 ns;

    -- Test 7: ADD (R-type, opcode=0110011, funct3=000, funct7=0000000)
    i_opcode <= "0110011"; i_funct3 <= "000"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 8: SUB (R-type, funct7=0100000)
    i_opcode <= "0110011"; i_funct3 <= "000"; i_funct7 <= "0100000";
    wait for 100 ns;

    -- Test 9: SLT (R-type)
    i_opcode <= "0110011"; i_funct3 <= "010"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 10: LUI (opcode=0110111)
    i_opcode <= "0110111"; i_funct3 <= "000"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 11: LW (Load Word, opcode=0000011)
    i_opcode <= "0000011"; i_funct3 <= "010"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 12: SW (Store Word, opcode=0100011)
    i_opcode <= "0100011"; i_funct3 <= "010"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 13: BEQ (Branch Equal, opcode=1100011, funct3=000)
    i_opcode <= "1100011"; i_funct3 <= "000"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 14: BNE (Branch Not Equal, funct3=001)
    i_opcode <= "1100011"; i_funct3 <= "001"; i_funct7 <= "0000000";
    wait for 100 ns;

    -- Test 15: JAL (Jump and Link, opcode=1101111)
    i_opcode <= "1101111"; i_funct3 <= "000"; i_funct7 <= "0000000";
    wait for 100 ns;

    wait;  -- End simulation
  end process;

end behavior;

