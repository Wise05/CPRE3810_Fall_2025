library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_forwarding_unit is
end tb_forwarding_unit;

architecture behavior of tb_forwarding_unit is

    -- Inputs to DUT
    signal i_rs1_ex       : std_logic_vector(4 downto 0);
    signal i_rs2_ex       : std_logic_vector(4 downto 0);
    signal i_rd_mem       : std_logic_vector(4 downto 0);
    signal i_rd_wb        : std_logic_vector(4 downto 0);
    signal i_regWrite_mem : std_logic;
    signal i_regWrite_wb  : std_logic;
    signal i_ALU_src      : std_logic;
    signal i_auipc        : std_logic;

    -- Outputs from DUT
    signal o_alu_a_mux    : std_logic_vector(1 downto 0);
    signal o_alu_b_mux    : std_logic_vector(1 downto 0);

begin

    --------------------------------------------------------------------
    -- DUT instantiation
    --------------------------------------------------------------------
    DUT: entity work.forwarding_unit
    port map(
        i_rs1_ex        => i_rs1_ex,
        i_rs2_ex        => i_rs2_ex,
        i_rd_mem        => i_rd_mem,
        i_rd_wb         => i_rd_wb,
        i_regWrite_mem  => i_regWrite_mem,
        i_regWrite_wb   => i_regWrite_wb,
        i_ALU_src       => i_ALU_src,
        i_auipc         => i_auipc,
        o_alu_a_mux     => o_alu_a_mux,
        o_alu_b_mux     => o_alu_b_mux
    );


    --------------------------------------------------------------------
    -- Test Stimulus
    --------------------------------------------------------------------
    stim : process
    begin

        ----------------------------------------------------------------
        -- DEFAULT CASE (NO FORWARDING)
        ----------------------------------------------------------------
        report "TEST 1: Default case, no forwarding" severity note;
        i_rs1_ex <= "00001";
        i_rs2_ex <= "00010";
        i_rd_mem <= "00000";
        i_rd_wb  <= "00000";
        i_regWrite_mem <= '0';
        i_regWrite_wb  <= '0';
        i_ALU_src      <= '0';
        i_auipc        <= '0';
        wait for 10 ns;

        ----------------------------------------------------------------
        -- MEM → EX FORWARD (ALU A)
        ----------------------------------------------------------------
        report "TEST 2: MEM hazard forwarding to ALU A" severity note;
        i_rs1_ex <= "00101";
        i_rd_mem <= "00101";
        i_regWrite_mem <= '1';
        i_rd_wb  <= "00000";
        i_regWrite_wb <= '0';
        i_auipc <= '0';
        wait for 10 ns;

        ----------------------------------------------------------------
        -- MEM → EX FORWARD (ALU B)
        ----------------------------------------------------------------
        report "TEST 3: MEM hazard forwarding to ALU B" severity note;
        i_rs2_ex <= "01010";
        i_rd_mem <= "01010";
        i_regWrite_mem <= '1';
        wait for 10 ns;

        ----------------------------------------------------------------
        -- WB → EX FORWARD (ALU A)
        ----------------------------------------------------------------
        report "TEST 4: WB hazard forwarding to ALU A" severity note;
        i_rd_mem <= "11111";   -- mismatch → MEM should not forward
        i_regWrite_mem <= '0';
        i_rs1_ex <= "00110";
        i_rd_wb  <= "00110";
        i_regWrite_wb <= '1';
        wait for 10 ns;

        ----------------------------------------------------------------
        -- WB → EX FORWARD (ALU B)
        ----------------------------------------------------------------
        report "TEST 5: WB hazard forwarding to ALU B" severity note;
        i_rs2_ex <= "01111";
        i_rd_wb  <= "01111";
        i_regWrite_wb <= '1';
        wait for 10 ns;

        ----------------------------------------------------------------
        -- PRIORITY CHECK: MEM MUST OVERRIDE WB
        ----------------------------------------------------------------
        report "TEST 6: MEM priority over WB" severity note;
        i_rs1_ex <= "10101";
        i_rd_mem <= "10101";
        i_rd_wb  <= "10101";
        i_regWrite_mem <= '1';
        i_regWrite_wb  <= '1';
        wait for 10 ns;

        ----------------------------------------------------------------
        -- AUIPC HANDLING (ALU A gets 11)
        ----------------------------------------------------------------
        report "TEST 7: AUIPC sets ALU A to 11" severity note;
        i_auipc <= '1';
        i_regWrite_mem <= '0';
        i_regWrite_wb  <= '0';
        wait for 10 ns;
        i_auipc <= '0';

        ----------------------------------------------------------------
        -- ALU_src = 1 → ALU B gets 11 (immediate operand)
        ----------------------------------------------------------------
        report "TEST 8: ALU_src sets ALU B to 11" severity note;
        i_ALU_src <= '1';
        i_rs2_ex <= "00111";
        wait for 10 ns;
        i_ALU_src <= '0';

        ----------------------------------------------------------------
        -- ZERO REGISTER MUST NEVER FORWARD
        ----------------------------------------------------------------
        report "TEST 9: Forwarding must ignore x0 register" severity note;
        i_rd_mem <= "00000";
        i_rd_wb  <= "00000";
        i_rs1_ex <= "00000";
        i_rs2_ex <= "00000";
        i_regWrite_mem <= '1';
        i_regWrite_wb  <= '1';
        wait for 10 ns;

        ----------------------------------------------------------------
        -- END OF TEST
        ----------------------------------------------------------------
        report "All tests completed." severity note;
        wait;

    end process;

end behavior;

