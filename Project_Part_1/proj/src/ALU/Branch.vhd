library ieee;
use ieee.std_logic_1164.all;

entity Branch is 
  port (
    Difference : in std_logic_vector(31 downto 0);
    Branch_Control : in std_logic_vector(2 downto 0);
    C_out : in std_logic;
    Overflow : in std_logic;
    Zero : out std_logic;
 );
 end Branch;

architecture structural of Branch is 
-- 000 beq, 001 bne, blt 010, 011 bge, 100 bltu, 101 bgeu
  signal s_beq, s_bne, s_blt, s_bge, s_bltu, s_bgeu : std_logic;

  -- beq check if zero

  -- bne check if not zero

  -- blt check if sign != overflow

  -- bge check if sign == overflow

  -- bltu check carry out = 1

  -- bgeu check carry out = 0
