library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_decoder_5t32 is
end tb_decoder_5t32;

architecture mixed of tb_decoder_5t32 is
  constant gCLK_HPER : time := 5 ns;
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component decoder_5t32 is
    port (
      i_5  : in  std_logic_vector(4 downto 0);
      o_32 : out std_logic_vector(31 downto 0)
    );
  end component;

  signal s_i5  : std_logic_vector(4 downto 0);
  signal s_o32 : std_logic_vector(31 downto 0);

begin

  DUT : decoder_5t32
    port map (
      i_5  => s_i5,
      o_32 => s_o32
    );

  P_TB: process
  begin
    -- Test case 1
    s_i5 <= "00000";
    wait for cCLK_PER;
    -- Expect 0x00000001

    -- Test case 2
    s_i5 <= "00001";
    wait for cCLK_PER;
    -- Expect 0x00000002

    -- Test case 3
    s_i5 <= "00100";
    wait for cCLK_PER;
    -- Expect 0x00000010

    -- Test case 4
    s_i5 <= "01010";
    wait for cCLK_PER;
    -- Expect 0x00000400

    -- Test case 5
    s_i5 <= "11111";
    wait for cCLK_PER;
    -- Expect 0x80000000

    wait;
  end process;

end mixed;

