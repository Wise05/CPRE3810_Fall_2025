-- N bit carry adder
-- Zephaniah Gustafson

library IEEE;
use IEEE.std_logic_1164.all;

entity carry_adder_N is 
generic(N : integer := 16);
port (A_i : in std_logic_vector(N-1 downto 0);
	B_i : in std_logic_vector(N-1 downto 0);
	C_in : in std_logic;
	S_i : out std_logic_vector(N-1 downto 0);
	C_out : out std_logic);
end carry_adder_N;

architecture structural of carry_adder_N is

  signal carry : std_logic_vector(N downto 0);  -- N+1 bits

  component full_adder is 
    port (
      A    : in std_logic;
      B    : in std_logic;
      Cin  : in std_logic;
      S    : out std_logic;
      Cout : out std_logic
    );
  end component;

begin

  carry(0) <= C_in;  

  G_NBit_Carry_Adder : for i in 0 to N-1 generate
    full_adderI : full_adder
      port map(
        A    => A_i(i),
        B    => B_i(i),
        Cin  => carry(i),
        S    => S_i(i),
        Cout => carry(i+1)
      );
  end generate;

  C_out <= carry(N);

end structural;
