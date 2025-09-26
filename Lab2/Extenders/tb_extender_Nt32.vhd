library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Extender is
end entity;

architecture sim of tb_Extender is

  component Extender
    generic (
      N : integer := 12
    );
    port (
      imm_in     : in  std_logic_vector(N-1 downto 0);
      sign_ext   : in  std_logic; -- '1' = sign extend, '0' = zero extend
      imm_out    : out std_logic_vector(31 downto 0)
    );
  end component;

  signal imm_in   : std_logic_vector(11 downto 0);  
  signal sign_ext : std_logic;
  signal imm_out  : std_logic_vector(31 downto 0);

begin
  -- Instantiate the DUT
  DUT: Extender
    generic map (N => 12)
    port map (
      imm_in => imm_in,
      sign_ext => sign_ext,
      imm_out => imm_out
    );

  stim_proc: process
  begin
    -- Case 1: zero extend small positive value
    imm_in   <= "000000000101"; -- 5 decimal
    sign_ext <= '0';
    wait for 10 ns;

    -- Case 2: sign extend same value
    sign_ext <= '1';
    wait for 10 ns;

    -- Case 3: negative number (12-bit -1 = 0xFFF)
    imm_in   <= "111111111111";
    sign_ext <= '1';
    wait for 10 ns;

    -- Case 4: negative number, but zero extend
    sign_ext <= '0';
    wait for 10 ns;

    wait; 
  end process;

end architecture sim;

