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

  constant CLK_PERIOD : time := 10 ns;

begin
  DUT: entity work.RISCV_Datapath
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
      C_out => C_out
    );

  -- Clock generation
  clk_process : process
  begin
    clk <= '0';
    wait for CLK_PERIOD/2;
    clk <= '1';
    wait for CLK_PERIOD/2;
  end process;

  -- Test sequence
  stim_proc : process
  begin
    -- Reset
    rst <= '1';
    RegWrite <= '0';
    wait for 3*CLK_PERIOD;
    rst <= '0';
    wait for CLK_PERIOD;

    -- ADDI for all the needed regs
    for i in 1 to 10 loop
      Rd       <= std_logic_vector(to_unsigned(i, 5));
      RS1      <= (others => '0');  
      RS2      <= (others => '0');
      imm      <= std_logic_vector(to_signed(i, 32));
      ALUSrc   <= '1';  
      nAdd_Sub <= '0'; 
      RegWrite <= '1';
      wait for CLK_PERIOD;
    end loop;

    -- add x11, x1, x2
    Rd       <= "01011"; -- 11
    RS1      <= "00001"; -- 1
    RS2      <= "00010"; -- 2
    ALUSrc   <= '0'; 
    nAdd_Sub <= '0';
    RegWrite <= '1';
    wait for CLK_PERIOD;

    -- sub x12, x11, x3
    Rd       <= "01100"; -- 12
    RS1      <= "01011"; -- 11
    RS2      <= "00011"; -- 3
    ALUSrc   <= '0';
    nAdd_Sub <= '1';
    wait for CLK_PERIOD;

    -- add x13, x12, x4
    Rd       <= "01101";
    RS1      <= "01100";
    RS2      <= "00100";
    nAdd_Sub <= '0';
    wait for CLK_PERIOD;

    -- sub x14, x13, x5
    Rd       <= "01110";
    RS1      <= "01101";
    RS2      <= "00101";
    nAdd_Sub <= '1';
    wait for CLK_PERIOD;

    -- add x15, x14, x6
    Rd       <= "01111";
    RS1      <= "01110";
    RS2      <= "00110";
    nAdd_Sub <= '0';
    wait for CLK_PERIOD;

    -- sub x16, x15, x7
    Rd       <= "10000";
    RS1      <= "01111";
    RS2      <= "00111";
    nAdd_Sub <= '1';
    wait for CLK_PERIOD;

    -- add x17, x16, x8
    Rd       <= "10001";
    RS1      <= "10000";
    RS2      <= "01000";
    nAdd_Sub <= '0';
    wait for CLK_PERIOD;

    -- sub x18, x17, x9
    Rd       <= "10010";
    RS1      <= "10001";
    RS2      <= "01001";
    nAdd_Sub <= '1';
    wait for CLK_PERIOD;

    -- add x19, x18, x10
    Rd       <= "10011";
    RS1      <= "10010";
    RS2      <= "01010";
    nAdd_Sub <= '0';
    wait for CLK_PERIOD;

    -- addi x20, zero, -35
    Rd       <= "10100";
    RS1      <= (others => '0');
    imm      <= std_logic_vector(to_signed(-35, 32));
    ALUSrc   <= '1';
    nAdd_Sub <= '0';
    wait for CLK_PERIOD;

    -- add x21, x19, x20
    Rd       <= "10101";
    RS1      <= "10011";
    RS2      <= "10100";
    ALUSrc   <= '0';
    nAdd_Sub <= '0';
    wait for CLK_PERIOD;

    RegWrite <= '0';
    wait;
  end process;

end tb;

