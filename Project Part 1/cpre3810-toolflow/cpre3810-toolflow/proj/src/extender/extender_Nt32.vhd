library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Generic extender: can sign or zero-extend
entity extender_Nt32 is
generic (
N : integer := 32
);
port (
imm_in : in  std_logic_vector(N-1 downto 0);
sign_ext : in  std_logic_vector(1 downto 0); -- '01' = sign extend, '00' = zero extend,'10' = lui
imm_type : in std_logic_vector(2 downto 0); -- '000' = I, '001' = S, '010' = SB, '011' = U, '100' = UJ
imm_out : out std_logic_vector(31 downto 0)
);
end entity extender_Nt32;

architecture GenerateBased of extender_Nt32 is
signal imm_i : std_logic_vector(31 downto 0);
signal imm_s : std_logic_vector(31 downto 0);
signal imm_sb : std_logic_vector(31 downto 0);
signal imm_u : std_logic_vector(31 downto 0);
signal imm_uj : std_logic_vector(31 downto 0);
signal imm_sel : std_logic_vector(31 downto 0);
signal ext_bit : std_logic;
begin

--I-type
imm_i <= (31 downto 12 => imm_in(31)) & imm_in(31 downto 20);

--S-type
imm_s <= (31 downto 12 => imm_in(31)) & imm_in(31 downto 25) & imm_in(11 downto 7);

--SB-type
imm_sb <= (31 downto 13 => imm_in(31)) & imm_in(31) & imm_in(30 downto 25) & imm_in(11 downto 8) & imm_in(7) & '0';

--U-type
imm_u <= (31 downto 12 => imm_in(31)) & x"000";

--UJ-type
imm_uj <= (31 downto 21 => imm_in(31)) & imm_in(31) & imm_in(19 downto 12) & imm_in(20) & imm_in(30 downto 21) & '0';

with imm_type select
	imm_sel <= imm_i when "000",
	imm_s when "001",
	imm_sb when "010",
	imm_u when "011",
	imm_uj when "100",
	(others => '0') when others;

ext_bit <= imm_sel(31) when sign_ext = "01" else
		'0' when sign_ext = "00" else
	'0';

imm_out <= (others => ext_bit) when sign_ext /= "10" else imm_sel;

end architecture GenerateBased;


