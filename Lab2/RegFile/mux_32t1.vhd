library IEEE;
use IEEE.std_logic_1164.all;

entity mux_32t1 is 
  port (i_32 : in std_logic_vector(31 downto 0);
        s_i : in std_logic_vector(4 downto 0);
       o_1 : out std_logic);
end mux_32t1;

architecture dataflow of mux_32t1 is 
begin
  with s_i select
    o_1 <= i_32(0) when "00000" ,
          i_32(1) when "00001",
          i_32(2) when "00010",
          i_32(3) when "00011",
          i_32(4) when "00100",
          i_32(5) when "00101",
          i_32(6) when "00110",
          i_32(7) when "00111",
          i_32(8) when "01000",
          i_32(9) when "01001",
          i_32(10) when "01010",
          i_32(11) when "01011",
          i_32(12) when "01100",
          i_32(13) when "01101",
          i_32(14) when "01110",
          i_32(15) when "01111",
          i_32(16) when "10000",
          i_32(17) when "10001",
          i_32(18) when "10010",
          i_32(19) when "10011",
          i_32(20) when "10100",
          i_32(21) when "10101",
          i_32(22) when "10110",
          i_32(23) when "10111",
          i_32(24) when "11000",
          i_32(25) when "11001",
          i_32(26) when "11010",
          i_32(27) when "11011",
          i_32(28) when "11100",
          i_32(29) when "11101",
          i_32(30) when "11110",
          i_32(31) when "11111",
          '0' when others;
end dataflow;
