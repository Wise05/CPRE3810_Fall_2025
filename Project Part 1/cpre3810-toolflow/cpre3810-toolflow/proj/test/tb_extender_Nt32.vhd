library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity extender_Nt32_tb is
end extender_Nt32_tb;

architecture behavior of extender_Nt32_tb is

  -- Component Declaration
  component extender_Nt32 is
    generic (
      N : integer := 32
    );
    port (
      imm_in   : in  std_logic_vector(N-1 downto 0);
      sign_ext : in  std_logic_vector(1 downto 0); -- '01' = sign extend, '00' = zero extend, '10' = lui
      imm_type : in  std_logic_vector(2 downto 0); -- '000' = I, '001' = S, '010' = SB, '011' = U, '100' = UJ
      imm_out  : out std_logic_vector(31 downto 0)
    );
  end component;

  -- Signals
  signal imm_in   : std_logic_vector(31 downto 0) := (others => '0');
  signal sign_ext : std_logic_vector(1 downto 0) := "00";
  signal imm_type : std_logic_vector(2 downto 0) := "000";
  signal imm_out  : std_logic_vector(31 downto 0);

begin

  -- Instantiate UUT
  uut: extender_Nt32
    port map (
      imm_in   => imm_in,
      sign_ext => sign_ext,
      imm_type => imm_type,
      imm_out  => imm_out
    );

  -- Stimulus
  stim_proc: process
  begin
    ---------------------------------------------------------------------
    -- Test 1: I-type, Sign Extend
    ---------------------------------------------------------------------
    imm_in   <= x"00000ABC"; -- positive number
    sign_ext <= "01"; -- sign extend
    imm_type <= "000";
    wait for 100 ns;

    ---------------------------------------------------------------------
    -- Test 2: I-type, Zero Extend
    ---------------------------------------------------------------------
    imm_in   <= x"00000ABC";
    sign_ext <= "00";
    imm_type <= "000";
    wait for 100 ns;

    ---------------------------------------------------------------------
    -- Test 3: I-type, Negative immediate (sign bit 1)
    ---------------------------------------------------------------------
    imm_in   <= x"FFF00FFF"; -- sign bit = 1
    sign_ext <= "01";
    imm_type <= "000";
    wait for 100 ns;

    ---------------------------------------------------------------------
    -- Test 4: S-type, Sign Extend
    ---------------------------------------------------------------------
    imm_in   <= x"00FF0F0F";
    sign_ext <= "01";
    imm_type <= "001";
    wait for 100 ns;

    ---------------------------------------------------------------------
    -- Test 5: S-type, Zero Extend
    ---------------------------------------------------------------------
    imm_in   <= x"00FF0F0F";
    sign_ext <= "00";
    imm_type <= "001";
    wait for 100 ns;

    ---------------------------------------------------------------------
    -- Test 6: S-type, Negative immediate
    ---------------------------------------------------------------------
    imm_in   <= x"FF000F0F";
    sign_ext <= "01";
    imm_type <= "001";
    wait for 100 ns;

    ---------------------------------------------------------------------
    -- Test 7: SB-type, Sign Extend
    ---------------------------------------------------------------------
    imm_in   <= x"0000F0F0";
    sign_ext <= "01";
    imm_type <= "010";
    wait for 100 ns;

    ---------------------------------------------------------------------
    -- Test 8: SB-type, Zero Extend
    ---------------------------------------------------------------------
    imm_in   <= x"0000F0F0";
    sign_ext <= "00";
    imm_type <= "010";
    wait for 100 ns;

    ---------------------------------------------------------------------
    -- Test 9: SB-type, Negative immediate
    ---------------------------------------------------------------------
    imm_in   <= x"F0000000";
    sign_ext <= "01";
    imm_type <= "010";
    wait for 100 ns;

    ---------------------------------------------------------------------
    -- Test 10: U-type, Sign Extend
    ---------------------------------------------------------------------
    imm_in   <= x"0000AAAA";
    sign_ext <= "01";
    imm_type <= "011";
    wait for 100 ns;

    ---------------------------------------------------------------------
    -- Test 11: U-type, Zero Extend
    ---------------------------------------------------------------------
    imm_in   <= x"0000AAAA";
    sign_ext <= "00";
    imm_type <= "011";
    wait for 100 ns;

    ---------------------------------------------------------------------
    -- Test 12: U-type, LUI mode (no sign/zero extension)
    ---------------------------------------------------------------------
    imm_in   <= x"0000AAAA";
    sign_ext <= "10";
    imm_type <= "011";
    wait for 100 ns;

    ---------------------------------------------------------------------
    -- Test 13: UJ-type, Sign Extend
    ---------------------------------------------------------------------
    imm_in   <= x"00123456";
    sign_ext <= "01";
    imm_type <= "100";
    wait for 100 ns;

    ---------------------------------------------------------------------
    -- Test 14: UJ-type, Zero Extend
    ---------------------------------------------------------------------
    imm_in   <= x"00123456";
    sign_ext <= "00";
    imm_type <= "100";
    wait for 100 ns;

    ---------------------------------------------------------------------
    -- Test 15: UJ-type, LUI mode (copy only)
    ---------------------------------------------------------------------
    imm_in   <= x"00123456";
    sign_ext <= "10";
    imm_type <= "100";
    wait for 100 ns;

    wait;  -- end of simulation
  end process;

end behavior;

