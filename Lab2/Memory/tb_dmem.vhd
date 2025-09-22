-- tb_dmem.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_dmem is
end entity;

architecture sim of tb_dmem is
    constant DATA_WIDTH : natural := 32;
    constant ADDR_WIDTH : natural := 10;  

    signal clk   : std_logic := '0';
    signal addr  : std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');
    signal data  : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal we    : std_logic := '0';
    signal q     : std_logic_vector(DATA_WIDTH-1 downto 0);

    
    type mem_array_t is array (0 to 9) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal temp_values : mem_array_t;
begin

    clk_process : process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    -- Instantiate the data memory
    dmem : entity work.mem
        generic map (
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map (
            clk  => clk,
            addr => addr,
            data => data,
            we   => we,
            q    => q
        );

    -- Test sequence
    stim_proc : process
    begin
        report "Starting dmem testbench..." severity note;

        -- read first 10 values
        for i in 0 to 9 loop
            addr <= std_logic_vector(to_unsigned(i, ADDR_WIDTH));
            wait for 2 ns; 
            temp_values(i) <= q; -- store in testbench signal
            report "Read value at addr " & integer'image(i) &
                   " = " & to_hstring(q);
            wait for 8 ns;
        end loop;

        -- (c) WRITE values to addr starting at 0x100
        for i in 0 to 9 loop
            addr <= std_logic_vector(to_unsigned(16#100# + i, ADDR_WIDTH));
            data <= temp_values(i);
            we   <= '1';
            wait until rising_edge(clk);  -- write happens here
            we   <= '0';
            report "Wrote value " & to_hstring(data) &
                   " to addr " & integer'image(16#100# + i);
        end loop;

        -- (Optional) Verify by reading back
        for i in 0 to 9 loop
            addr <= std_logic_vector(to_unsigned(16#100# + i, ADDR_WIDTH));
            wait for 2 ns;
            report "Verify addr " & integer'image(16#100# + i) &
                   " = " & to_hstring(q);
            wait for 8 ns;
        end loop;

        report "Testbench finished." severity note;
        wait;
    end process;
end architecture;

