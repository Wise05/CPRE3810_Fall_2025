library IEEE;
use IEEE.std_logic_1164.all;


entity IF_ID is 
  port (
        in_instruct : in std_logic_vector(31 downto 0);
	WE : in std_logic;
	out_instruct : out std_logic_vector(31 downto 0);
	RST : in std_logic;
	CLK: in std_logic
  );
end IF_ID;

architecture structural of IF_ID is 
  
  component Nbit_reg is 
    generic(N : integer := 32); 
    port (
        in_1 : in std_logic_vector(N-1 downto 0);
	WE : in std_logic;
	out_1 : out std_logic_vector(N-1 downto 0);
	RST : in std_logic;
	CLK: in std_logic
);
  end component;

begin

instruct_reg: Nbit_reg
	port map (
		in_1 => in_instruct,
		WE => WE,
		out_1 => out_instruct,
		RST => RST,
		CLK => CLK
    );
end structural;
