library ieee;
use ieee.std_logic_1164.all;

entity mux_16t1 is
    generic (
        WIDTH : integer := 32  
    );
    port (
        sel    : in  std_logic_vector(3 downto 0);
        in0    : in  std_logic_vector(WIDTH-1 downto 0);
        in1    : in  std_logic_vector(WIDTH-1 downto 0);
        in2    : in  std_logic_vector(WIDTH-1 downto 0);
        in3    : in  std_logic_vector(WIDTH-1 downto 0);
        in4    : in  std_logic_vector(WIDTH-1 downto 0);
        in5    : in  std_logic_vector(WIDTH-1 downto 0);
        in6    : in  std_logic_vector(WIDTH-1 downto 0);
        in7    : in  std_logic_vector(WIDTH-1 downto 0);
        in8    : in  std_logic_vector(WIDTH-1 downto 0);
        in9    : in  std_logic_vector(WIDTH-1 downto 0);
        in10   : in  std_logic_vector(WIDTH-1 downto 0);
        in11   : in  std_logic_vector(WIDTH-1 downto 0);
        in12   : in  std_logic_vector(WIDTH-1 downto 0);
        in13   : in  std_logic_vector(WIDTH-1 downto 0);
        in14   : in  std_logic_vector(WIDTH-1 downto 0);
        in15   : in  std_logic_vector(WIDTH-1 downto 0);
        y      : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity mux_16t1;

architecture Behavioral of mux_16t1 is
begin
with sel select
        y <= in0  when "0000",
               in1  when "0001",
               in2 when "0010",
               in3 when "0011",
               in4 when "0100",
               in5 when "0101",
               in6 when "0110",
               in7 when "0111",
               in8 when "1000",
               in9 when "1001",
               in10 when "1010",
               in11 when "1011",
               in12 when "1100",
               in13 when "1101",
               in14 when "1110",
               in15 when "1111",
               x"00000000" when others;
end Behavioral;

