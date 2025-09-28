
-- Testbench for mux2t1_32bits
-- Zevan Gustafson

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_mux2t1_32bits is
end tb_mux2t1_32bits;

architecture sim of tb_mux2t1_32bits is

  -- Component under test
  component mux2t1_32bits is
    port(
      i_D : in  std_logic_vector(31 downto 0);
      i_imm : in  std_logic_vector(31 downto 0);
      ALUSrc : in  std_logic;
      o_O : out std_logic_vector(31 downto 0)
    );
  end component;

  -- Signals for stimulus
  signal i_D, i_imm, o_O : std_logic_vector(31 downto 0);
  signal ALUSrc : std_logic;

begin

  -- DUT instantiation
  uut: mux2t1_32bits
    port map (
      i_D => i_D,
      i_imm => i_imm,
      ALUSrc => ALUSrc,
      o_O => o_O
    );

  -- Stimulus process
  stim_proc: process
  begin
    -- Initial values
    i_D <= x"AAAAAAAA";
    i_imm <= x"55555555";

    -- Test case 1: Select i_D
    ALUSrc <= '0';
    wait for 10 ns;
    assert o_O = x"AAAAAAAA"
      report "Test case 1 failed: expected i_D" severity error;

    -- Test case 2: Select i_imm
    ALUSrc <= '1';
    wait for 10 ns;
    assert o_O = x"55555555"
      report "Test case 2 failed: expected i_imm" severity error;

    -- Test case 3: Invalid select
    ALUSrc <= 'X';
    wait for 10 ns;
    assert o_O = x"00000000"
      report "Test case 3 failed: expected 0x00000000 for invalid select" severity error;

    -- End simulation
    wait;
  end process;

end sim;

