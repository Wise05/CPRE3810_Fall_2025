-- N-bit one's complementor
-- Zephaniah Gustafson


library IEEE;
use IEEE.std_logic_1164.all;

entity ones_comp_N is 
generic (N : integer := 16);
port(i_C : in std_logic_vector(N-1 downto 0);
	o_C : out std_logic_vector(N-1 downto 0));
end ones_comp_N;

architecture structural of ones_comp_N is 

component invg is 
port (i_A : in std_logic;
	o_F : out std_logic);
end component;

begin

G_NBit_OnesComp: for i in 0 to N-1 generate
	INVGI: invg port map(
		i_A => i_C(i),
		o_F => o_C(i));
end generate G_NBit_OnesComp;

end structural;