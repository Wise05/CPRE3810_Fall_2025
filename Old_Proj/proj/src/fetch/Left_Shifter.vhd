library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Left_Shifter is 
  port (
    i : in std_logic_vector(31 downto 0);
    o : out std_logic_vector(31 downto 0)
  );
end Left_Shifter;

architecture structural of Left_Shifter is
begin
  o <= std_logic_vector(shift_left(unsigned(i), 1));
end structural;
