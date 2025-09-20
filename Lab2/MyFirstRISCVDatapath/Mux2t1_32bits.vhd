-- Zevan Gustafson
-- mux 2 to 1 for a 32 bit bus

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity mux2t1_32bits is 
port(i_D : in std_logic_vector(31 downto 0);
	i_imm : in std_logic_vector(31 downto 0); -- Immediate
	ALUSrc : in std_logic;
	o_O : out std_logic_vector(31 downto 0));
end mux2t1;

-- Structural
architecture behavior of mux2t1 is
begin
  with ALUSrc select
    o_O <= i_D0 when '0',
           i_imm when '1',
           '0' when others;
end behavior;
