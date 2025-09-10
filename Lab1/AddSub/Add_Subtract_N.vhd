-- adder/subtractor 
-- Zephaniah Gustafson

library IEEE;
use IEEE.std_logic_1164.all;

entity add_sub_N is 
  generic(N : integer := 16);
  port (
    A_i      : in  std_logic_vector(N-1 downto 0);
    B_i      : in  std_logic_vector(N-1 downto 0);
    nAdd_Sub : in  std_logic;  -- 0 => Add, 1 => Subtract
    S_i      : out std_logic_vector(N-1 downto 0);
    C_out    : out std_logic
  );
end add_sub_N;

architecture structural of add_sub_N is

  signal B_inverted : std_logic_vector(N-1 downto 0);
  signal B_muxed    : std_logic_vector(N-1 downto 0);

  component ones_comp_N is
    generic (N : integer := 16);
    port(
      i_C : in  std_logic_vector(N-1 downto 0);
      o_C : out std_logic_vector(N-1 downto 0)
    );
  end component;

  component mux2t1_N is
    generic(N : integer := 16);
    port(
      i_S  : in  std_logic;
      i_D0 : in  std_logic_vector(N-1 downto 0);
      i_D1 : in  std_logic_vector(N-1 downto 0);
      o_O  : out std_logic_vector(N-1 downto 0)
    );
  end component;

  component carry_adder_N is
    generic(N : integer := 16);
    port(
      A_i   : in  std_logic_vector(N-1 downto 0);
      B_i   : in  std_logic_vector(N-1 downto 0);
      C_in  : in  std_logic;
      S_i   : out std_logic_vector(N-1 downto 0);
      C_out : out std_logic
    );
  end component;

begin

  INV_B : ones_comp_N
    generic map(N => N)
    port map(
      i_C => B_i,
      o_C => B_inverted
    );

  B_SELECT : mux2t1_N
    generic map(N => N)
    port map(
      i_S  => nAdd_Sub,
      i_D0 => B_i,
      i_D1 => B_inverted,
      o_O  => B_muxed
    );

  ADDER : carry_adder_N
    generic map(N => N)
    port map(
      A_i   => A_i,
      B_i   => B_muxed,
      C_in  => nAdd_Sub,
      S_i   => S_i,
      C_out => C_out
    );

end structural;

