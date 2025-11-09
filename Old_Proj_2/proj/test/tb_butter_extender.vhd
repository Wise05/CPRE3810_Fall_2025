library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_butter_extender is
end entity tb_butter_extender;

architecture testbench of tb_butter_extender is
    component butter_extender_Nt32 is
    generic (
        N : integer := 32
    );
    port (
        imm_in   : in  std_logic_vector(N-1 downto 0);
        sign_ext : in  std_logic_vector(1 downto 0);
        imm_type : in  std_logic_vector(2 downto 0);
        imm_out  : out std_logic_vector(31 downto 0)
    );
    end component;
    
    -- Signals
    signal imm_in   : std_logic_vector(31 downto 0) := (others => '0');
    signal sign_ext : std_logic_vector(1 downto 0) := "00";
    signal imm_type : std_logic_vector(2 downto 0) := "000";
    signal imm_out  : std_logic_vector(31 downto 0);
    
    signal test_num : integer := 0;
    
begin
    DUT: butter_extender_Nt32
        generic map (
            N => 32
        )
        port map (
            imm_in   => imm_in,
            sign_ext => sign_ext,
            imm_type => imm_type,
            imm_out  => imm_out
        );
    
    test_proc: process
    begin
        -- Test 1: I-type with sign extension (positive immediate)
        test_num <= 1;
        imm_in <= x"00000FFF"; -- 12-bit immediate = 0xFFF
        sign_ext <= "01"; -- sign extend
        imm_type <= "000"; -- I-type
        wait for 10 ns;
        
        -- Test 2: I-type with sign extension (negative immediate)
        test_num <= 2;
        imm_in <= x"FFF00000"; -- bit 31 = 1 (negative)
        sign_ext <= "01";
        imm_type <= "000";
        wait for 10 ns;
        
        -- Test 3: I-type with zero extension
        test_num <= 3;
        imm_in <= x"FFF00000";
        sign_ext <= "00"; -- zero extend
        imm_type <= "000";
        wait for 10 ns;
        
        -- Test 4: S-type with sign extension
        test_num <= 4;
        imm_in <= x"FE00001F"; -- imm[11:5] in bits[31:25], imm[4:0] in bits[11:7]
        sign_ext <= "01";
        imm_type <= "001"; -- S-type
        wait for 10 ns;
        
        -- Test 5: S-type with zero extension
        test_num <= 5;
        imm_in <= x"0000001F";
        sign_ext <= "00";
        imm_type <= "001";
        wait for 10 ns;
        
        -- Test 6: SB-type (branch) with sign extension
        test_num <= 6;
        imm_in <= x"80000080"; -- negative branch offset
        sign_ext <= "01";
        imm_type <= "010"; -- SB-type
        wait for 10 ns;
        
        -- Test 7: SB-type with positive offset
        test_num <= 7;
        imm_in <= x"00000F80";
        sign_ext <= "01";
        imm_type <= "010";
        wait for 10 ns;
        
        -- Test 8: U-type with sign extension
        test_num <= 8;
        imm_in <= x"12345000";
        sign_ext <= "01";
        imm_type <= "011"; -- U-type
        wait for 10 ns;
        
        -- Test 9: U-type with LUI mode
        test_num <= 9;
        imm_in <= x"ABCDE000";
        sign_ext <= "10"; -- LUI mode
        imm_type <= "011";
        wait for 10 ns;
        
        -- Test 10: UJ-type (jump) with sign extension
        test_num <= 10;
        imm_in <= x"80100000"; -- negative jump offset
        sign_ext <= "01";
        imm_type <= "100"; -- UJ-type
        wait for 10 ns;
        
        -- Test 11: UJ-type with positive offset
        test_num <= 11;
        imm_in <= x"7FF00000";
        sign_ext <= "01";
        imm_type <= "100";
        wait for 10 ns;
        
        -- Test 12: Invalid imm_type
        test_num <= 12;
        imm_in <= x"FFFFFFFF";
        sign_ext <= "01";
        imm_type <= "111"; -- invalid
        wait for 10 ns;
        
        -- Test 13: Edge case - all zeros
        test_num <= 13;
        imm_in <= x"00000000";
        sign_ext <= "01";
        imm_type <= "000";
        wait for 10 ns;
        
        -- Test 14: Edge case - all ones with zero extend
        test_num <= 14;
        imm_in <= x"FFFFFFFF";
        sign_ext <= "00";
        imm_type <= "000";
        wait for 10 ns;
        
        -- Test 15: LUI with various patterns
        test_num <= 15;
        imm_in <= x"DEADC000";
        sign_ext <= "10";
        imm_type <= "011";
        wait for 10 ns;
        
        report "Testbench completed successfully!";
        wait;
    end process;
    
end architecture testbench;
