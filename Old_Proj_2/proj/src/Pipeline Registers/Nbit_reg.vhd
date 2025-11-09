library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Nbit_reg is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.  
  port (
        in_1 : in std_logic_vector(N-1 downto 0);
	WE : in std_logic;
	out_1 : out std_logic_vector(N-1 downto 0);
	RST : in std_logic;
	CLK: in std_logic
);
end Nbit_reg;

architecture structural of Nbit_reg is
component dffg is
 port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
end component;

begin


  G_NBit_reg: for i in 0 to N-1 generate
    dffgI: dffg port map(
               i_CLK  => CLK,
	     i_RST     => RST,
	     i_WE     => WE,
	      i_D     => in_1(i),
  	      o_Q      => out_1(i)); 
  end generate G_NBit_reg;


end structural;