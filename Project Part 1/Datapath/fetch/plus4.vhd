library IEEE;
use IEEE.std_logic_1164.all;
user work.regfile_pkg.all;

entity plus4 is 
  port (
    A : in std_logic_vector(31 downto 0);
    S : out std_logic_vector(31 downto 0);
       );
  end plus4;

architecture structual of carray_adder_N is
  component carry_adder_N is 
    generic(N : integer := 16);
    port (
      A_i ; in std_logic_vector(N-1 downto 0);
      B_i : in std_logic_vector(N-1 downto 0);
      C_in : in std_logic;
      S_i : out std_logic_vector(N-1 downto 0);
      C_out : out std_logic
    );
   end component;

begin
  carray_adder : carray_adder_N 
  generic map (N => 32)
  port map (
    A_i => A,
    B_i => x"00000004",
    C_in => '0',
    S_i => S,
    C_out => '0'
  );
       
end structural;
