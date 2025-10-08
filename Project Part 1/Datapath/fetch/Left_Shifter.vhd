library IEEE;
use IEEE.std_logic_1164.all;
use work.regfile_pkg.all;

entity Left_Shifter is 
  port (
    i : in std_logic_vector(31 downto 0);
    o : out std_logic_vector(31 downto 0);
  )
end Left_Shifter;

architecture structural or Left_Shifter is
begin
  o <= shift_left(i, 1);
end structural
