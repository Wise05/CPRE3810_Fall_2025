library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_fetch is
  generic(gCLK_HPER   : time := 50 ns;
          N : integer := 32);
end tb_fetch;

architecture behavior of tb_fetch is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component fetch
  port (
    clk : in std_logic;
    rst : in std_logic;
    -- Maybe we need RegWrite for the PC, but rn it will be set to 1
    branch : in std_logic;
    zero_flag_ALU : in std_logic;
    jump : in std_logic;
    imm : in std_logic_vector(31 downto 0); -- immediate offset
    instr_addr : out std_logic_vector(31 downto 0); -- address sent to imem
    plus4_o : out std_logic_vector(31 downto 0) -- address that gets sent to "AndLink" address
);
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK : std_logic := '0';
  signal s_RST : std_logic := '0';
  signal s_branch : std_logic := '0';
  signal s_zero_flag_ALU : std_logic := '0';
  signal s_jump : std_logic := '0';
  signal s_imm : std_logic_vector(31 downto 0) := (others => '0');
  signal s_instr_addr : std_logic_vector(31 downto 0) := (others => '0');
  signal s_plus4_o : std_logic_vector(31 downto 0) := (others => '0');

begin

  DUT: fetch
  port map(clk => s_CLK,
    	   rst => s_RST,
    	   branch => s_branch,
    	   zero_flag_ALU => s_zero_flag_ALU,
   	   jump => s_jump,
    	   imm => s_imm,
    	   instr_addr => s_instr_addr,
    	   plus4_o => s_plus4_o
);
	

  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin

  s_RST <= '1';
  wait for 2 * cCLK_PER;
  s_RST <= '0';

--1 Addi
    s_branch <= '0';
    s_jump <= '0';
    s_imm <= x"00000111";
    s_zero_flag_ALU <= '0';
    wait for cCLK_PER; 

--2 Add
    s_branch <= '0';
    s_jump <= '1';
    s_imm <= (others => '0');
    s_zero_flag_ALU <= '0';
    wait for cCLK_PER; 

    wait;
  end process;
  
end behavior;
