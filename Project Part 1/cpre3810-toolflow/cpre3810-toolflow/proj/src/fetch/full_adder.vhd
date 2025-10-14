-- 1 bit full adder
-- Zephaniah Gustafson


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity full_adder is 
port (A : in std_logic;
	B : in std_logic;
	Cin : in std_logic;
	S : out std_logic;
	Cout : out std_logic);
end full_adder;

architecture behavior of full_adder is

signal wire1, wire2, wire3 : std_logic;

component andg2 is
port(i_A : in std_logic;
	i_B : in std_logic;
	o_F : out std_logic);
end component;

component org2 is 
port (i_A : in std_logic;
	i_B : in std_logic;
	o_F : out std_logic);
end component;

component xorg2 is 
port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

begin

xor_gate1 : xorg2
port map ( i_A => A,
	i_B => B,
	o_F => wire1);

and_gate1 : andg2 
port map ( i_A => A,
	i_B => B,
	o_F => wire2);

xor_gate2 : xorg2
port map ( i_A => wire1,
	i_B => Cin,
	o_F => S);

and_gate2 : andg2
port map ( i_A => wire1,
	i_B => Cin,
	o_F => wire3);

or_gate1 : org2
port map ( i_A => wire2,
	i_B => wire3,
	o_F => Cout);

end behavior;
