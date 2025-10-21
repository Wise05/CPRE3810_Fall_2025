library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity butter_extender_Nt32 is
  generic (
    N : integer := 32
  );
  port (
    imm_in   : in  std_logic_vector(N-1 downto 0);
    sign_ext : in  std_logic_vector(1 downto 0);  -- '01' = sign extend, '00' = zero extend, '10' = LUI
    imm_type : in  std_logic_vector(2 downto 0);  -- '000'=I, '001'=S, '010'=SB, '011'=U, '100'=UJ
    imm_out  : out std_logic_vector(31 downto 0)
  );
end butter_extender_Nt32;

architecture GenerateBased of butter_extender_Nt32 is
  signal imm_i, imm_s, imm_sb, imm_u, imm_uj, imm_sel : std_logic_vector(31 downto 0);
  signal sign_bit : std_logic;
begin
  -- Determine sign extension bit
  sign_bit <= imm_in(31) when sign_ext = "01" else '0';

  -- I-type: bits [31:20]
  imm_i <= (19 downto 0 => sign_bit) & imm_in(31 downto 20);

  -- S-type: bits [31:25] & [11:7]
  imm_s <= (19 downto 0 => sign_bit) & imm_in(31 downto 25) & imm_in(11 downto 7);

  -- SB-type: branch offset
  imm_sb <= (18 downto 0 => sign_bit) & imm_in(31) & imm_in(7) &
             imm_in(30 downto 25) & imm_in(11 downto 8) & '0';

  -- U-type: upper immediate
  imm_u <= imm_in(31 downto 12) & (11 downto 0 => '0');

  -- UJ-type: jump offset
  imm_uj <= (10 downto 0 => sign_bit) & imm_in(31) &
             imm_in(19 downto 12) & imm_in(20) &
             imm_in(30 downto 21) & '0';

  -- Select immediate
  with imm_type select
    imm_sel <= imm_i           when "000",
               imm_s           when "001",
               imm_sb          when "010",
               imm_u           when "011",
               imm_uj          when "100",
               (others => '0') when others;

  -- Handle LUI mode (if used)
  imm_out <= imm_u when sign_ext = "10" else imm_sel;
end GenerateBased;
