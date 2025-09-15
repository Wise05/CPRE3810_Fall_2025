library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_RV32_regFile is 
end tb_RV32_regFile;

architecture sim of tb_RV32_regFile is 
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component RV32_regFile is 
    port (
      clk : in std_logic;
      rst : in std_logic;
      RegWrite: in std_logic;
      Rd: in std_logic_vector(4 downto 0);
      DATA_IN : in std_logic_vector(31 downto 0);
      RS1 : in std_logic_vector(4 downto 0);
      RS2 : in std_logic_vector(4 downto 0);
      OS1 : out std_logic_vector(31 downto 0);
      OS2 : out std_logic_vector(31 downto 0);
         );
      end componenent;
  
  signal clk : std_logic := '0';
  signal rst  : std_logic := '0';
  signal RegWrite : std_logic := '0';
  signal Rd : std_logic_vector(4 downto 0) := (others => '0');
  signal DATA_IN : std_logic_vector(31 downto 0) := (others => '0');
  signal RS1 : std_logic_vector(4 downto 0) := (others => '0');
  signal RS2 : std_logic_vector(4 downto 0) := (others => '0');
  signal OS1 : std_logic_vector(31 downto 0);
  signal OS2 : std_logic_vector(31 downto 0);

  DUT: entity RV32_regFile
    port map (
      clk      => clk,
      rst      => rst,
      RegWrite => RegWrite,
      Rd       => Rd,
      DATA_IN  => DATA_IN,
      RS1      => RS1,
      RS2      => RS2,
      OS1      => OS1,
      OS2      => OS2
    );

  P_CLK: process
  begin
    clk <= '0';
    wait for gCLK_HPER;
    clk <= '1';
    wait for gCLK_HPER;
  end process;
 

  P_TB: process
  begin
    -- Reset
    rst <= '1';
    wait for gCLK_HPER;
    rst <= '0';
    wait for cCLK_PER;

    -- Try writing to x0 (should stay 0)
    Rd <= "00000";
    DATA_IN <= x"DEADBEEF";
    RegWrite <= '1';
    wait for cCLK_PER;
    RegWrite <= '0';
    RS1 <= "00000";
    wait for cCLK_PER;
    -- expect x0 to stay 0x00000000 from OS1

    -- Write value to x5
    Rd <= "00101";
    DATA_IN <= x"12345678";
    RegWrite <= '1';
    wait for cCLK_PER;
    RegWrite <= '0';

    -- Read back from x5
    RS1 <= "00101";
    RS2 <= "00101";
    wait for cCLK_PER;
    -- Expect 0S1 and OS2 to be 0x12345678

    -- Write different value to x10
    Rd <= "01010"; 
    DATA_IN <= x"CAFEBABE";
    RegWrite <= '1';
    wait for cCLK_PER;
    RegWrite <= '0';

    -- Read from x5 and x10 simultaneously
    RS1 <= "00101";
    RS2 <= "01010";
    wait for cCLK_PER;
    -- Expect OS1=0x12345678 and OS2=0xCAFEBABE

    -- Test overwrite in x5
    Rd <= "00101";
    DATA_IN <= x"A5A5A5A5";
    RegWrite <= '1';
    wait for cCLK_PER;
    RegWrite <= '0';

    RS1 <= "00101";
    wait for cCLK_PER;
    -- Expect OS1 to read 0xA5A5A5A5

    wait;
  end process;
end sim;


