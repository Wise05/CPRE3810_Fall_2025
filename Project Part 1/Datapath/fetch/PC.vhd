library IEEE;
use IEEE.std_logic_1164.all;
use work.regfile_pkg.all;

entity PC is 
  port (
    clk : in std_logic;
    rst : in std_logic;
    RegWrite: in std_logic; -- write enable
    DATA_IN : in std_logic_vector(9 downto 0);
    OS : out std_logic_vector(9 downto 0);
  );
end RV32_regFile;

architecture structural of RV32_regFile is 
  component dffg_N is 
    generic(N : integer := 32);
    port(i_CLK : in std_logic;
         i_RST: in std_logic;
         i_WE: in std_logic;
         i_D : in std_logic_vector(N-1 downto 0);
         o_Q : out std_logic_vector(N-1 downto 0));
  end component;

begin
  pc_reg : dffg_N is 
    generic map (N => 10)
    port map (
      i_CLK => clk,
      i_RST => rst,
      i_WE => RegWrite,
      DATA_IN => i_D,
      o_Q => OS
             );

end structural;

