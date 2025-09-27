library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_RISCV_Datapath is
end tb_RISCV_Datapath;

architecture tb of tb_RISCV_Datapath is
  signal clk      : std_logic := '0';
  signal rst      : std_logic := '1';
  signal RS1      : std_logic_vector(4 downto 0);
  signal RS2      : std_logic_vector(4 downto 0);
  signal RegWrite : std_logic;
  signal Rd       : std_logic_vector(4 downto 0);
  signal imm      : std_logic_vector(31 downto 0);
  signal ALUSrc   : std_logic;
  signal nAdd_Sub : std_logic;
  signal C_out    : std_logic;
  signal  OS1 : std_logic_vector(31 downto 0);
  signal OS2 : std_logic_vector(31 downto 0);
  signal S_i : std_logic_vector(31 downto 0);

  constant gCLK_HPER : time := 5 ns;
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component RISCV_Datapath is 
    port (
      clk: in std_logic;
      rst : in std_logic;
      RS1 : in std_logic_vector(4 downto 0);
      RS2 : in std_logic_vector(4 downto 0);
      RegWrite : in std_logic;
      Rd : in std_logic_vector(4 downto 0);
      imm : in std_logic_vector(31 downto 0);
      ALUSrc : in std_logic;
      nAdd_Sub : in std_logic; -- 0 => add, 1 => subtract
      C_out: out std_logic
      OS1 : out std_logic_vector(31 downto 0);
      OS2 : out std_logic_vector(31 downto 0);
      S_i : out std_logic_vector(31 downto 0);
    );
  end component;

begin
  DUT: entity RISCV_Datapath
    port map (
      clk => clk,
      rst => rst,
      RS1 => RS1,
      RS2 => RS2,
      RegWrite => RegWrite,
      Rd => Rd,
      imm => imm,
      ALUSrc => ALUSrc,
      nAdd_Sub => nAdd_Sub,
      C_out => C_out,
      OS1 => OS1,
      OS2 => OS2,
      S_i
    );

  -- Clock generation
  clk_process : process
  begin
    clk <= '0';
    wait for gCLK_HPER;
    clk <= '1';
    wait for gCLK_HPER;
  end process;

  -- Test sequence
  sim_proc : process
  begin
    -- Reset
    rst <= '1';
    RegWrite <= '0';
    wait for 3*cCLK_PER;
    rst <= '0';
    wait for cCLK_PER;

    -- ADDI for all the needed regs
    for i in 1 to 10 loop
      Rd       <= std_logic_vector(to_unsigned(i, 5));
      RS1      <= (others => '0');  
      RS2      <= (others => '0');
      imm      <= std_logic_vector(to_signed(i, 32));
      ALUSrc   <= '1';  
      nAdd_Sub <= '0'; 
      RegWrite <= '1';
      wait for cCLK_PER;
    end loop;

    -- add x11, x1, x2
    Rd       <= "01011"; -- 11
    RS1      <= "00001"; -- 1
    RS2      <= "00010"; -- 2
    ALUSrc   <= '0'; 
    nAdd_Sub <= '0';
    RegWrite <= '1';
    wait for cCLK_PER;

    -- sub x12, x11, x3
    Rd       <= "01100"; -- 12
    RS1      <= "01011"; -- 11
    RS2      <= "00011"; -- 3
    ALUSrc   <= '0';
    nAdd_Sub <= '1';
    wait for cCLK_PER;

    -- add x13, x12, x4
    Rd       <= "01101";
    RS1      <= "01100";
    RS2      <= "00100";
    nAdd_Sub <= '0';
    wait for cCLK_PER;

    -- sub x14, x13, x5
    Rd       <= "01110";
    RS1      <= "01101";
    RS2      <= "00101";
    nAdd_Sub <= '1';
    wait for cCLK_PER;

    -- add x15, x14, x6
    Rd       <= "01111";
    RS1      <= "01110";
    RS2      <= "00110";
    nAdd_Sub <= '0';
    wait for cCLK_PER;

    -- sub x16, x15, x7
    Rd       <= "10000";
    RS1      <= "01111";
    RS2      <= "00111";
    nAdd_Sub <= '1';
    wait for cCLK_PER;

    -- add x17, x16, x8
    Rd       <= "10001";
    RS1      <= "10000";
    RS2      <= "01000";
    nAdd_Sub <= '0';
    wait for cCLK_PER;

    -- sub x18, x17, x9
    Rd       <= "10010";
    RS1      <= "10001";
    RS2      <= "01001";
    nAdd_Sub <= '1';
    wait for cCLK_PER;

    -- add x19, x18, x10
    Rd       <= "10011";
    RS1      <= "10010";
    RS2      <= "01010";
    nAdd_Sub <= '0';
    wait for cCLK_PER;

    -- addi x20, zero, -35
    Rd       <= "10100";
    RS1      <= (others => '0');
    imm      <= std_logic_vector(to_signed(-35, 32));
    ALUSrc   <= '1';
    nAdd_Sub <= '0';
    wait for cCLK_PER;

    -- add x21, x19, x20
    Rd       <= "10101";
    RS1      <= "10011";
    RS2      <= "10100";
    ALUSrc   <= '0';
    nAdd_Sub <= '0';
    wait for cCLK_PER;

    RegWrite <= '0';
    wait;
  end process;

end tb;

