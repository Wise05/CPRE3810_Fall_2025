library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_barrel_shifter is
end tb_barrel_shifter;

architecture behavior of tb_barrel_shifter is

  -- Component under test (CUT)
  component barrel_shifter
    port (
      data_in     : in  std_logic_vector(31 downto 0);
      shift_amt   : in  std_logic_vector(4 downto 0);
      ALU_control : in  std_logic_vector(3 downto 0);
      result      : out std_logic_vector(31 downto 0)
    );
  end component;

  -- Signals
  signal data_in     : std_logic_vector(31 downto 0) := (others => '0');
  signal shift_amt   : std_logic_vector(4 downto 0)  := (others => '0');
  signal ALU_control : std_logic_vector(3 downto 0)  := (others => '0');
  signal result      : std_logic_vector(31 downto 0);

begin
  -- Instantiate CUT
  uut: barrel_shifter
    port map (
      data_in     => data_in,
      shift_amt   => shift_amt,
      ALU_control => ALU_control,
      result      => result
    );

  -- Stimulus process
  stim_proc: process
  begin

    -- Test 1: Logical left shift
    data_in     <= x"0000000F";  -- 0000...1111
    shift_amt   <= "00010";      -- shift by 2
    ALU_control <= "0000";       -- assume logical left
    wait for 20 ns;

    -- Test 2: Logical right shift
    data_in     <= x"F0000000";
    shift_amt   <= "00011";      -- shift by 3
    ALU_control <= "0001";       -- assume logical right
    wait for 20 ns;

    -- Test 3: Arithmetic right shift
    data_in     <= x"F0000000";  -- negative number if signed
    shift_amt   <= "00100";      -- shift by 4
    ALU_control <= "0111";       -- arithmetic right
    wait for 20 ns;

    -- Test 4: Rotate right (if implemented)
    data_in     <= x"12345678";
    shift_amt   <= "00010";
    ALU_control <= "0010";       -- rotate right (custom)
    wait for 20 ns;

    -- Test 5: No shift
    data_in     <= x"A5A5A5A5";
    shift_amt   <= "00000";
    ALU_control <= "0000";
    wait for 20 ns;

    wait;
  end process;

end behavior;

