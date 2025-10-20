library ieee;
use ieee.std_logic_1164.all;

entity mux_8t1 is
    port (
        sel    : in  std_logic_vector(2 downto 0);
        in0    : in  std_logic;
        in1    : in  std_logic;
        in2    : in  std_logic;
        in3    : in  std_logic;
        in4    : in  std_logic;
        in5    : in  std_logic;
        in6    : in  std_logic;
        in7    : in  std_logic;
        y      : out std_logic
    );
end entity mux_8t1;

architecture Behavioral of mux_8t1 is
begin
with s_i select
        y <= in0  when "000",
               in1  when "001",
               in2 when "010",
               in3 when "011",
               in4 when "100",
               in5 when "101",
               in6 when "110",
               in7 when "111",
               '0' when others;
end Behavioral;

