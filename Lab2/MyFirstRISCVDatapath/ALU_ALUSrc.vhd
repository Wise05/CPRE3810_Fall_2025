-- Zevan Gustafson
-- Add/sub with ALUSrc

library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_ALUSrc is 
  port (
    A_i : in std_logic_vector(31 downto 0);
    B_i : in std_logic_vector(31 downto 0);
    Imm : in std_logic_vector(31 downto 0);
    ALUSrc : in std_logic;
    nAdd_Sub : in std_logic;
    C_out : out std_logic;
    S_i : out std_logic_vector(31 downto 0));
end ALU_ALUSrc;

architecture structural of ALU_ALUSrc is 
  signal B_Imm : std_logic_vector(31 downto 0);

  component add_sub_N is 
    generic(N : integer := 16);
    port (
      A_i      : in  std_logic_vector(N-1 downto 0);
      B_i      : in  std_logic_vector(N-1 downto 0);
      nAdd_Sub : in  std_logic;  -- 0 => Add, 1 => Subtract
      S_i      : out std_logic_vector(N-1 downto 0);
      C_out    : out std_logic
    );
  end component;

  component mux2t1_32bits is 
    port(i_D : in std_logic_vector(31 downto 0);
      i_imm : in std_logic_vector(31 downto 0); -- Immediate
      ALUSrc : in std_logic;
      o_O : out std_logic_vector(31 downto 0));
  end component;

begin 

  SRC : mux2t1_32bits 
    generic map (N => 32)
    port map (
      i_D => B_i,
      i_imm => Imm,
      ALUSrc => ALUSrc,
      o_O => B_Imm
    );

  Add_Sub : add_sub_N 
    generic map (N => 32)
    port map (
      A_i => A_i,
      B_i => B_Imm,
      nAdd_Sub => nAdd_Sub,
      S_i => S_i,
      C_out => C_out
    );

end structural; 


