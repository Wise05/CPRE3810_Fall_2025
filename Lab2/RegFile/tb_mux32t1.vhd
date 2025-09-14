library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_mux_32t1 is
end tb_mux_32t1;

architecture sim of tb_mux_32t1 is
  constant cCLK_PER : time := 10 ns;

  component mux_32t1 is
    port (
      i_32 : in  std_logic_vector(31 downto 0);
      s_i  : in  std_logic_vector(4 downto 0);
      o_1  : out std_logic
    );
  end component;

  signal s_i32 : std_logic_vector(31 downto 0);
  signal s_sel : std_logic_vector(4 downto 0);
  signal s_out : std_logic;

begin
  DUT : mux_32t1
    port map (
      i_32 => s_i32,
      s_i  => s_sel,
      o_1  => s_out
    );

  P_TB : process
  begin
    -- Test case 1
    s_i32 <= x"00000001"; 
    s_sel <= "00000";    
    wait for cCLK_PER;
    -- Expect o_1 = '1'

    -- Test case 2
    s_i32 <= x"00000002"; 
    s_sel <= "00001";    
    wait for cCLK_PER;
    -- Expect o_1 = '1'

    -- Test case 3
    s_i32 <= (others => '0'); 
    s_sel <= "10101";        
    wait for cCLK_PER;
    -- Expect o_1 = '0'

    -- Test case 4
    s_i32 <= (others => '0');
    s_i32(15) <= '1';     
    s_sel <= "01111";    
    wait for cCLK_PER;
    -- Expect o_1 = '1'

    -- Test case 5
    s_i32 <= (others => '0');
    s_i32(31) <= '1';   
    s_sel <= "11111";  
    wait for cCLK_PER;
    -- Expect o_1 = '1'

    wait;
  end process;
end sim;

