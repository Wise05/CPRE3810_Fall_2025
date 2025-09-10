-- Zevan Gustafson zevang@iastate.edu
-- tb_carry_adder_N

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;

entity tb_carry_adder_N is 
  generic (gCLK_HPER : time := 10 ns;
          DATA_WIDTH : integer := 32);
end tb_carry_adder_N;

architecture mixed of tb_carry_adder_N is 
  component carry_adder_N is 
    generic(N : integer := 16);
    port (A_i : in std_logic_vector(N-1 downto 0);
      B_i : in std_logic_vector(N-1 downto 0);
      C_in : in std_logic;
      S_i : out std_logic_vector(N-1 downto 0);
      C_out : out std_logic);
  end component;

  signal sA_i : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
  signal sB_i : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
  signal sC_in : std_logic := '0';
  signal sS_i : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sC_out : std_logic;

begin

  DUT0 : carry_adder_N
  generic map (n => DATA_WIDTH)
  port map(
    A_i => sA_i,
    B_i => sB_i,
    C_in => sC_in,
    S_i => sS_i,
    C_out => sC_out);

  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2;

    -- Test case 1:
    sA_i <= x"00000000"; sB_i <= x"00000000"; sC_in <= '0';
    wait for gCLK_HPER * 2;
    -- expect sS_i to be 00000000 and sC_out to be 0

    -- Test case 2:
    sA_i <= x"80000000"; sB_i <= x"80000000"; sC_in <= '0';
    wait for gCLK_HPER * 2;
    -- expect sS_i to be 00000000 and sC_out to be 1

    -- Test case 3:
    sA_i <= x"CAFEF00D"; sB_i <= x"CA70F00D"; sC_in <= '0';
    wait for gCLK_HPER * 2;
    -- expect sS_i to be 956FE01A and sC_out to be 1

    -- Test case 4:
    sA_i <= x"FFFFFFFF"; sB_i <= x"FFFFFFFF"; sC_in <= '1';
    wait for gCLK_HPER * 2;
    -- expect sS_i to be FFFFFFFF and sC_out to be 1
    
    -- Test case 5:
    sA_i <= x"FFFFFFFF"; sB_i <= x"00000000"; sC_in <= '1';
    wait for gCLK_HPER * 2;
    -- expect sS_i to be 00000000 and sC_out to be 1

    wait;
  end process;
end mixed;




