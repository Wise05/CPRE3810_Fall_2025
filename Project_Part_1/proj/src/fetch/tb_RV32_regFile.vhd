-- tb_RV32_regfile.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_RV32_regfile is
end entity;

architecture sim of tb_RV32_regfile is
    constant gCLK_HPER : time := 5 ns;
    constant cCLK_PER  : time := gCLK_HPER * 2;

    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal RegWrite : std_logic := '0';
    signal Rd       : std_logic_vector(4 downto 0) := (others => '0');
    signal DATA_IN  : std_logic_vector(31 downto 0) := (others => '0');
    signal RS1      : std_logic_vector(4 downto 0) := (others => '0');
    signal RS2      : std_logic_vector(4 downto 0) := (others => '0');
    signal OS1      : std_logic_vector(31 downto 0);
    signal OS2      : std_logic_vector(31 downto 0);

    component RV32_regFile is 
      port (
        clk      : in std_logic;
        rst      : in std_logic;
        RegWrite : in std_logic;
        Rd       : in std_logic_vector(4 downto 0);
        DATA_IN  : in std_logic_vector(31 downto 0);
        RS1      : in std_logic_vector(4 downto 0);
        RS2      : in std_logic_vector(4 downto 0);
        OS1      : out std_logic_vector(31 downto 0);
        OS2      : out std_logic_vector(31 downto 0)
      );
    end component;

begin
    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for gCLK_HPER;
            clk <= '1';
            wait for gCLK_HPER;
        end loop;
    end process;

    -- Instantiate DUT
    dut : RV32_regFile
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

    -- Stimulus
    stim_proc : process
    begin
        -- Reset pulse
        rst <= '1';
        wait for cCLK_PER;
        rst <= '0';
        wait for cCLK_PER;

        -- Attempt to write to x0 (should stay zero)
        Rd      <= "00000";
        DATA_IN <= x"DEADBEEF";
        RegWrite <= '1';
	wait for gCLK_HPER;
        wait until rising_edge(clk);
        RegWrite <= '0';
        wait for cCLK_PER;

        -- Write some test values into x1, x2, x3
        Rd      <= "00001"; -- x1
        DATA_IN <= x"00000011";
        RegWrite <= '1';
	wait for gCLK_HPER;
        wait until rising_edge(clk);
        RegWrite <= '0';
        wait for cCLK_PER;

        Rd      <= "00010"; -- x2
        DATA_IN <= x"00000022";
        RegWrite <= '1';
	wait for gCLK_HPER;
        wait until rising_edge(clk);
        RegWrite <= '0';
        wait for cCLK_PER;

        Rd      <= "00011"; -- x3
        DATA_IN <= x"00000033";
        RegWrite <= '1';
	wait for gCLK_HPER;
        wait until rising_edge(clk);
        RegWrite <= '0';
        wait for cCLK_PER;

        -- Set RS1 and RS2 to read back x1 and x2
        RS1 <= "00001";
        RS2 <= "00010";
        wait for cCLK_PER;

        -- Change RS1 and RS2 to read back x3 and x0
        RS1 <= "00011";
        RS2 <= "00000";
        wait for cCLK_PER;

        wait;
    end process;
end architecture;

