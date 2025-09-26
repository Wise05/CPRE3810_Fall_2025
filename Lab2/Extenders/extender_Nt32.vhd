library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Generic extender: can sign- or zero-extend
entity extender_Nt32 is
  generic (
    N : integer := 12  
  );
  port (
    imm_in : in  std_logic_vector(N-1 downto 0);
    sign_ext : in  std_logic; -- '1' = sign extend, '0' = zero extend
    imm_out : out std_logic_vector(31 downto 0)
  );
end entity extender_Nt32;

architecture Behavioral of extender_Nt32 is
begin
  process(imm_in, sign_ext)
    variable temp : std_logic_vector(31 downto 0);
  begin
    if sign_ext = '1' then
      -- Sign extend
      temp := (others => imm_in(N-1)) & imm_in;
      imm_out <= temp(31 downto 0);
    else
      -- Zero extend
      temp := (others => '0') & imm_in;
      imm_out <= temp(31 downto 0);
    end if;
  end process;
end architecture Behavioral;

