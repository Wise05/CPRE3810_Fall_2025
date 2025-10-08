library IEEE;
use IEEE.std_logic_1164.all;
use work.regfile_pkg.all;

entity Left_Shifter is 
  port (
    i : in std_logic_vector(31 downto 0);
       )
