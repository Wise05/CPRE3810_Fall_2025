-- Generic immediate extender for RISC-V instruction formats
-- Supports sign extension, zero extension, and LUI operation
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity butter_extender_Nt32 is
  generic (
    N : integer := 32
  );
  port (
    imm_in   : in  std_logic_vector(N-1 downto 0);
    sign_ext : in  std_logic_vector(1 downto 0);  -- '01' = sign extend, '00' = zero extend, '10' = lui
    imm_type : in  std_logic_vector(2 downto 0);  -- '000' = I, '001' = S, '010' = SB, '011' = U, '100' = UJ
    imm_out  : out std_logic_vector(31 downto 0)
  );
end butter_extender_Nt32;

architecture GenerateBased of butter_extender_Nt32 is
  signal imm_i   : std_logic_vector(31 downto 0);
  signal imm_s   : std_logic_vector(31 downto 0);
  signal imm_sb  : std_logic_vector(31 downto 0);
  signal imm_u   : std_logic_vector(31 downto 0);
  signal imm_uj  : std_logic_vector(31 downto 0);
  signal imm_sel : std_logic_vector(31 downto 0);
  signal ext_bit : std_logic;
begin
  -- Determine extension bit based on sign_ext mode
  ext_bit <= imm_in(31) when sign_ext = "01" else
             '0';
  
  -- I-type: immediate in bits [31:20]
  imm_i <= (31 downto 12 => ext_bit) & imm_in(31 downto 20);
  
  -- S-type: immediate in bits [31:25] and [11:7]
  imm_s <= (31 downto 12 => ext_bit) & imm_in(31 downto 25) & imm_in(11 downto 7);
  
  -- SB-type: branch offset
  imm_sb <= (31 downto 13 => ext_bit) & imm_in(31) & imm_in(7) & imm_in(30 downto 25) & imm_in(11 downto 8) & '0';
  
  -- U-type: upper immediate in bits [31:12], lower 12 bits are zero
  imm_u <= imm_in(31 downto 12) & x"000";
  
  -- UJ-type: jump offset
  imm_uj <= (31 downto 21 => ext_bit) & imm_in(31) & imm_in(19 downto 12) & imm_in(20) & imm_in(30 downto 21) & '0';
  
  -- Select immediate format based on imm_type
  with imm_type select
    imm_sel <= imm_i            when "000",
               imm_s            when "001",
               imm_sb           when "010",
               imm_u            when "011",
               imm_uj           when "100",
               (others => '0')  when others;
  
  -- Output selected immediate (extension already applied)
  imm_out <= imm_sel;
  
end GenerateBased;
