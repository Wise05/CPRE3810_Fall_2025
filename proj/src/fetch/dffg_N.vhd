-- Zevan Gustafson
-- dffg_N
-- N bit register file

library IEEE;
use IEEE.std_logic_1164.all;

entity dffg_N is 
  generic(N : integer := 32);
  port(
    i_CLK : in  std_logic;
    i_RST : in  std_logic;
    i_WE : in  std_logic;
    i_D : in  std_logic_vector(N-1 downto 0);
    o_Q : out std_logic_vector(N-1 downto 0)
  );
end entity;

architecture structural of dffg_N is
  component dffg
    port(
      i_CLK : in std_logic;
      i_RST : in std_logic;
      i_WE : in std_logic;
      i_D : in std_logic;
      o_Q : out std_logic
    );
  end component;
begin
  gen_regs : for i in 0 to N-1 generate
    bit_ff: dffg
      port map (
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_D => i_D(i),
        o_Q => o_Q(i)
      );
  end generate;
end architecture;

