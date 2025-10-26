library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Left_Shifter is 
  end entity;

architecture sim of tb_Left_Shifter is 
  signal i : std_logic_vector(31 downto 0);
  signal o : std_logic_vector(31 downto 0);

  component Left_Shifter
    port (
i : in std_logic_vector(31 downto 0);
      o : out std_logic_vector(31 downto 0)
   );
  end component;

begin 
DUT: Left_Shifter 
  port map (
    i => i,
    o => o
  );

stim: process
begin
  i <= x"00000001";
  wait for 10 ns;

  i <= x"80000000";
  wait for 10 ns;

  wait;
end process;
end architecture sim;
