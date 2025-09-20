-- Zevan Gustafson zevang@iastate.edu
-- tb_Add_Subtract_N

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;

entity tb_add_sub_N is 
  generic (
    gCLK_HPER  : time   := 10 ns;
    DATA_WIDTH : integer := 32
  );
end tb_add_sub_N;

architecture mixed of tb_add_sub_N is 

  component add_sub_N is 
    generic(N : integer := 16);
    port (
      A_i      : in  std_logic_vector(N-1 downto 0);
      B_i      : in  std_logic_vector(N-1 downto 0);
      nAdd_Sub : in  std_logic;  -- 0 = Add, 1 = Sub
      S_i      : out std_logic_vector(N-1 downto 0);
      C_out    : out std_logic
    );
  end component;

  signal sA_i      : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
  signal sB_i      : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
  signal snAdd_Sub : std_logic := '0';
  signal sS_i      : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sC_out    : std_logic;

begin

  DUT0 : add_sub_N
    generic map (N => DATA_WIDTH)
    port map(
      A_i      => sA_i,
      B_i      => sB_i,
      nAdd_Sub => snAdd_Sub,
      S_i      => sS_i,
      C_out    => sC_out
    );

  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2;

    -- Test case 1
    sA_i <= x"00000000"; sB_i <= x"00000000"; snAdd_Sub <= '0';
    wait for gCLK_HPER * 2;
    -- expect sS_i = 00000000, sC_out = 0

    -- Test case 2
    sA_i <= x"80000000"; sB_i <= x"80000000"; snAdd_Sub <= '0';
    wait for gCLK_HPER * 2;
    -- expect sS_i = 00000000, sC_out = 1

    -- Test case 3
    sA_i <= x"CAFEF00D"; sB_i <= x"CA70F00D"; snAdd_Sub <= '0';
    wait for gCLK_HPER * 2;
    -- expect sS_i = 956FE01A, sC_out = 1

    -- Test case 4
    sA_i <= x"00000005"; sB_i <= x"00000003"; snAdd_Sub <= '1';
    wait for gCLK_HPER * 2;
    -- expect sS_i = 00000002, sC_out = 1

    -- Test case 5
    sA_i <= x"00000003"; sB_i <= x"00000005"; snAdd_Sub <= '1';
    wait for gCLK_HPER * 2;
    -- expect sS_i = FFFFFFFE, sC_out = 0

    -- Test case 6
    sA_i <= x"FFFFFFFF"; sB_i <= x"00000001"; snAdd_Sub <= '1';
    wait for gCLK_HPER * 2;
    -- expect sS_i = FFFFFFFE, sC_out = 1

    wait;
  end process;

end mixed;

