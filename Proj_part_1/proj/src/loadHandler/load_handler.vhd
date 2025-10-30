library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity load_handler is 
  port (
    DMEM_in     : in  std_logic_vector(31 downto 0);
    load_control: in  std_logic_vector(2 downto 0); -- 000: lw, 001: lb, 010: lh, 011: lbu, 100: lhu
    offset      : in  std_logic_vector(1 downto 0); -- byte offset (0?3)
    DMEM_out    : out std_logic_vector(31 downto 0)
  );
end load_handler;

architecture behavioral of load_handler is
    signal byte_sel  : std_logic_vector(7 downto 0);
    signal half_sel  : std_logic_vector(15 downto 0);
    signal s_lb, s_lh, s_lbu, s_lhu : std_logic_vector(31 downto 0);
begin

    --------------------------------------------------------------------
    -- Byte extraction based on offset
    --------------------------------------------------------------------
    process(DMEM_in, offset)
    begin
        case offset is
            when "00" => byte_sel <= DMEM_in(7 downto 0);
            when "01" => byte_sel <= DMEM_in(15 downto 8);
            when "10" => byte_sel <= DMEM_in(23 downto 16);
            when others => byte_sel <= DMEM_in(31 downto 24);
        end case;
    end process;

    --------------------------------------------------------------------
    -- Halfword extraction (unaligned)
    -- Note: we only handle offsets 0,1,2; offset=3 would wrap to next word.
    --------------------------------------------------------------------
    process(DMEM_in, offset)
    begin
        case offset is
            when "00" => half_sel <= DMEM_in(15 downto 0);
            when "01" => half_sel <= DMEM_in(23 downto 8);
            when "10" => half_sel <= DMEM_in(31 downto 16);
            when others => half_sel <= (others => '0');
        end case;
    end process;

    --------------------------------------------------------------------
    -- Sign and zero extension logic
    --------------------------------------------------------------------
    s_lb  <= (31 downto 8  => byte_sel(7)) & byte_sel;  -- sign-extend byte
    s_lbu <= (31 downto 8  => '0')        & byte_sel;   -- zero-extend byte

    s_lh  <= (31 downto 16 => half_sel(15)) & half_sel; -- sign-extend half
    s_lhu <= (31 downto 16 => '0')           & half_sel;-- zero-extend half

    --------------------------------------------------------------------
    -- Final output selection
    --------------------------------------------------------------------
    with load_control select
        DMEM_out <= DMEM_in when "000",  -- lw
                    s_lb      when "001", -- lb
                    s_lh      when "010", -- lh
                    s_lbu     when "011", -- lbu
                    s_lhu     when "100", -- lhu
                    (others => '0') when others;

end behavioral;

