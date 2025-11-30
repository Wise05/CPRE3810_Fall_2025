library ieee;
use ieee.std_logic_1164.all;

entity mux_4t1 is
    generic (
        N : integer := 32  
    );
    port (
        sel    : in  std_logic_vector(1 downto 0);
        in0    : in  std_logic_vector(N-1 downto 0);
        in1    : in  std_logic_vector(N-1 downto 0);
        in2    : in  std_logic_vector(N-1 downto 0);
        in3    : in  std_logic_vector(N-1 downto 0);
        y      : out std_logic_vector(N-1 downto 0)
    );
end entity mux_4t1;

architecture Behavioral of mux_4t1 is
begin
with sel select
        y <=   in0  when "00",
               in1  when "01",
               in2  when "10",
               in3  when "11",
               (others => '0') when others;
end Behavioral;

