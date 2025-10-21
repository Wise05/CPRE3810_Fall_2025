library ieee;
use ieee.std_logic_1164.all;

entity Branch is 
  port (
    Difference : in std_logic_vector(31 downto 0);
    Branch_Control : in std_logic_vector(2 downto 0);
    C_out : in std_logic;
    Overflow : in std_logic;
    Zero : out std_logic
  );
end Branch;

architecture structural of Branch is 
-- 000 beq, 001 bne, blt 010, 011 bge, 100 bltu, 101 bgeu
  signal s_beq, s_bne, s_blt, s_bge, s_bltu, s_bgeu : std_logic;
  signal sign_bit : std_logic;

begin
  sign_bit <= Difference(31);

  -- beq check if zero
  with Difference select
    s_beq <= '1' when x"00000000",
             '0' when others;

  -- bne check if not zero
  with Difference select
    s_bne <= '0' when x"00000000",
             '1' when others;

  -- blt check if sign != overflow
  s_blt <= sign_bit xor Overflow;

  -- bge check if sign == overflow
  s_bge <= not (sign_bit xor Overflow);

  -- bltu check carry out = 1
  s_bltu <= C_out;

  -- bgeu check carry out = 0
  s_bgeu <= not C_out;

  with Branch_Control select
    Zero <= s_beq when "000",
             s_bne when "001",
             s_blt when "010",
             s_bge when "011",
             s_bltu when "100",
             s_bgeu when "101",
             '0' when others;

end structural;

