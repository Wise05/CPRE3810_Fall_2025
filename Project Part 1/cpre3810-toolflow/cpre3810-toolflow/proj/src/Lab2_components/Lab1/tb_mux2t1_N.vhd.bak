-- zevan gustafson zevang@iastate.edu
-- tb_mux2t1_N

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;

entity tb_mux2t1_N is 
  generic (gCLK_HPER : time := 10ns;
          DATA_WIDTH : integer := 16);
end tb_mux2t1_N;

architecture mixed of tb_mux2t1_N is 
  constant cCLK_PER : time := gCLK_HPER * 2;

  component mux2t1_N is
    generic (N : integer := 16);
    port (i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
  end component;

signal si_S : std_logic := '0';
signal si_D0, si_D1 : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
signal so_O : std_logic_vector(DATA_WIDTH-1 downto 0);

begin 

  DUT0: mux2t1_N
  generic map (N => DATA_WIDTH)
  port map(
   i_S => si_S,
   i_D0 => si_D0,
   i_D1 => si_D1,
   o_O => so_O);

    P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; 

    -- Test case 1:
    si_S <= '0'; si_D0 <= x"AAAA"; si_D1 <= x"BBBB";
    wait for gCLK_HPER * 2;
    -- expect so_O = AAAA

    -- Test case 2:
    si_S <= '1'; si_D0 <= x"1234"; si_D1 <= x"0101";
    wait for gCLK_HPER * 2;
    -- expect so_O = 0101

    si_S <= '0'; si_D0 <= x"FFFF"; si_D1 <= x"0000";
    wait for gCLK_HPER * 2;
    -- expect so_O = FFFF

    wait;
  end process;
end mixed;


  

