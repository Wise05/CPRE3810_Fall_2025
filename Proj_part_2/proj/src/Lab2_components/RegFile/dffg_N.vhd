library IEEE;
use IEEE.std_logic_1164.all;

entity dffg_N is
  generic(N : integer := 32);
  port(
    i_CLK : in std_logic;
    i_RST : in std_logic;
    i_WE  : in std_logic;
    i_D   : in std_logic_vector(N-1 downto 0);
    o_Q   : out std_logic_vector(N-1 downto 0)
  );
end entity;

architecture behavioral of dffg_N is
  signal r_Q : std_logic_vector(N-1 downto 0) := (others => '0');
begin
  process(i_CLK, i_RST)
  begin
    if i_RST = '1' then
      r_Q <= (others => '0');
    elsif falling_edge(i_CLK) then
      if i_WE = '1' then
        r_Q <= i_D;
      end if;
    end if;
  end process;

  o_Q <= r_Q;
end architecture;

