library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Generic extender: can sign or zero-extend
entity extender_Nt32 is
generic (
N : integer := 12
);
port (
imm_in   : in  std_logic_vector(N-1 downto 0);
sign_ext : in  std_logic; -- '1' = sign extend, '0' = zero extend
imm_out  : out std_logic_vector(31 downto 0)
);
end entity extender_Nt32;

architecture GenerateBased of extender_Nt32 is
begin
-- Lower N bits: direct mapping
imm_out(N-1 downto 0) <= imm_in;

-- Upper bits: generated either from sign bit or zero
gen_extend: for i in N to 31 generate
imm_out(i) <= imm_in(N-1) when sign_ext = '1' else '0';
end generate;
end architecture GenerateBased;


