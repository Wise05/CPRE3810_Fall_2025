library IEEE;
use IEEE.std_logic_1164.all;

entity dffg_N_reset is
  generic (
    N : integer := 32;
    RESET_VALUE : std_logic_vector(31 downto 0) := (others => '0')
  );
  port (
    i_CLK : in std_logic;
    i_RST : in std_logic;
    i_WE  : in std_logic;
    i_D   : in std_logic_vector(N-1 downto 0);
    o_Q   : out std_logic_vector(N-1 downto 0)
  );
end dffg_N_reset;

architecture behavioral of dffg_N_reset is
begin
  process(i_CLK, i_RST)
  begin
    if i_RST = '1' then
      o_Q <= RESET_VALUE;
    elsif rising_edge(i_CLK) then
      if i_WE = '1' then
        o_Q <= i_D;
      end if;
    end if;
  end process;
end behavioral;

