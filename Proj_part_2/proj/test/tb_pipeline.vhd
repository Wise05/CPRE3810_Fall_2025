library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_pipeline is
end tb_pipeline;

architecture behavior of tb_pipeline is

    -- Clock + reset
    signal CLK    : std_logic := '0';
    signal RST    : std_logic := '1';
    signal WE     : std_logic := '1';

    -- IF/ID inputs
    signal if_instr_in  : std_logic_vector(31 downto 0) := (others=>'0');
    signal if_pc_in     : std_logic_vector(31 downto 0) := (others=>'0');
    signal if_pc4_in    : std_logic_vector(31 downto 0) := (others=>'0');
    signal flush_if     : std_logic := '0';

    -- IF/ID outputs
    signal id_instr_out : std_logic_vector(31 downto 0);
    signal id_pc_out    : std_logic_vector(31 downto 0);
    signal id_pc4_out   : std_logic_vector(31 downto 0);

    -- ID/EX control inputs
    signal stall_id     : std_logic := '0';
    signal flush_id     : std_logic := '0';

    -- ID/EX outputs (selected examples only)
    signal ex_data1     : std_logic_vector(31 downto 0);
    signal ex_data2     : std_logic_vector(31 downto 0);
    signal ex_ext       : std_logic_vector(31 downto 0);

    -- EX/MEM control inputs
    signal stall_ex     : std_logic := '0';
    signal flush_ex     : std_logic := '0';

    -- EX/MEM outputs
    signal mem_data1    : std_logic_vector(31 downto 0);
    signal mem_data2    : std_logic_vector(31 downto 0);

    -- MEM/WB inputs
    signal mem_alu_in   : std_logic_vector(31 downto 0) := (others=>'0');
    signal mem_mux_in   : std_logic_vector(31 downto 0) := (others=>'0');
    signal mem_load_in  : std_logic_vector(2 downto 0) := (others=>'0');
    signal mem_rw_in    : std_logic := '0';
    signal mem_rwaddr_in : std_logic_vector(4 downto 0) := (others=>'0');
    signal mem_mtreg_in : std_logic := '0';
    signal mem_halt_in  : std_logic := '0';

    -- MEM/WB outputs
    signal wb_alu       : std_logic_vector(31 downto 0);
    signal wb_mux       : std_logic_vector(31 downto 0);
    signal wb_load      : std_logic_vector(2 downto 0);
    signal wb_rw        : std_logic;
    signal wb_rwaddr    : std_logic_vector(4 downto 0);

begin

    -----------------------------------
    -- CLOCK PROCESS
    -----------------------------------
    CLK <= not CLK after 5 ns;

    -----------------------------------
    -- DUT INSTANTIATION
    -----------------------------------

    -- 1. IF/ID REGISTER
    IFID : entity work.IF_ID
    port map(
        in_instruct     => if_instr_in,
        in_PC_val       => if_pc_in,
        in_PC_plus4     => if_pc4_in,
        in_flush_fetch  => flush_if,
        WE              => WE,
        out_instruct    => id_instr_out,
        out_PC_val      => id_pc_out,
        out_PC_plus4    => id_pc4_out,
        RST             => RST,
        CLK             => CLK
    );


    -- 2. ID/EX REGISTER
    IDEX : entity work.ID_EX
    port map(
        in_ALUSrc       => '1',
        in_ALUControl   => "0001",
        in_ImmType      => "001",
        in_regWrite     => '1',
        in_regWrite_addr => "00010",
        in_MemWrite     => '0',
        in_imm_sel      => "00",
        in_branch_type  => "000",
        in_jump         => '0',
        in_link         => '0',
        in_branch       => '0',
        in_PCReg        => '0',
        in_auipc        => '0',
        in_data1        => id_instr_out,
        in_data2        => id_pc_out,
        in_extender     => id_pc4_out,
        in_halt         => '0',
        in_MemtoReg     => '0',
        in_load         => "000",
        in_pc_val       => id_pc_out,
        in_pc_plus4     => id_pc4_out,
        in_stall_decode => stall_id,
        in_flush_decode => flush_id,
        WE              => WE,
        out_data1       => ex_data1,
        out_data2       => ex_data2,
        out_extender    => ex_ext,
        RST             => RST,
        CLK             => CLK
    );


    -- 3. EX/MEM REGISTER
    EXMEM : entity work.EX_MEM
    port map(
        in_ImmType      => "000",
        in_MemWrite     => '0',
        in_imm_sel      => "00",
        in_branch_type  => "000",
        in_jump         => '0',
        in_branch       => '0',
        in_PCReg        => '0',
        in_data1        => ex_data1,
        in_data2        => ex_data2,
        in_extender     => ex_ext,
        in_halt         => '0',
        in_MemtoReg     => '0',
        in_regWrite     => '1',
        in_regWrite_addr => "00101",
        in_load         => "000",
        in_mux          => ex_data1,
        in_alu          => ex_data2,
        in_zero         => '0',
        in_PC_offset    => (others=>'0'),
        in_stall_execute => stall_ex,
        in_flush_execute => flush_ex,
        WE              => WE,
        out_data1       => mem_data1,
        out_data2       => mem_data2,
        RST             => RST,
        CLK             => CLK
    );


    -- 4. MEM/WB REGISTER
    MEMWB : entity work.MEM_WB
    port map(
        in_dmem         => mem_data1,
        in_MemtoReg     => mem_mtreg_in,
        in_RegWrite     => mem_rw_in,
        in_regWrite_addr => mem_rwaddr_in,
        in_mux          => mem_data2,
        in_alu          => mem_data1,
        in_load         => mem_load_in,
        in_halt         => mem_halt_in,
        WE              => WE,
        out_dmem        => wb_alu,
        out_MemtoReg    => open,
        out_RegWrite    => wb_rw,
        out_regWrite_addr => wb_rwaddr,
        out_mux         => wb_mux,
        out_alu         => wb_alu,
        out_load        => wb_load,
        out_halt        => open,
        RST             => RST,
        CLK             => CLK
    );


    -----------------------------------
    -- TEST STIMULUS
    -----------------------------------
    stim : process
    begin
        -- Reset for two cycles
        RST <= '1';
        wait for 20 ns;
        RST <= '0';

        ------------------------------------------------------------------
        -- 1. NORMAL PIPELINE FLOW: new values each cycle
        ------------------------------------------------------------------
        for i in 1 to 8 loop
            if_instr_in <= std_logic_vector(to_unsigned(i,32));
            if_pc_in    <= std_logic_vector(to_unsigned(i+100,32));
            if_pc4_in   <= std_logic_vector(to_unsigned(i+200,32));
            wait for 10 ns;
        end loop;

        ------------------------------------------------------------------
        -- 2. STALL ID/EX for 2 cycles
        ------------------------------------------------------------------
        stall_id <= '1';
        wait for 20 ns;
        stall_id <= '0';

        ------------------------------------------------------------------
        -- 3. FLUSH ID/EX once
        ------------------------------------------------------------------
        flush_id <= '1';
        wait for 10 ns;
        flush_id <= '0';

        ------------------------------------------------------------------
        -- 4. STALL EX/MEM
        ------------------------------------------------------------------
        stall_ex <= '1';
        wait for 20 ns;
        stall_ex <= '0';

        ------------------------------------------------------------------
        -- 5. FLUSH EX/MEM once
        ------------------------------------------------------------------
        flush_ex <= '1';
        wait for 10 ns;
        flush_ex <= '0';

        ------------------------------------------------------------------
        -- 6. Flush IF/ID
        ------------------------------------------------------------------
        flush_if <= '1';
        wait for 10 ns;
        flush_if <= '0';

        wait;
    end process;

end behavior;

