library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity barrel_shifter is
  port (
    data_in     : in  std_logic_vector(31 downto 0);
    shift_amt   : in  std_logic_vector(4 downto 0);
    ALU_control : in  std_logic_vector(3 downto 0);
    result      : out std_logic_vector(31 downto 0)
  );
end barrel_shifter;

architecture structural of barrel_shifter is

component mux2t1 is
  port (
    i_D0 : in std_logic;
    i_D1 : in std_logic;
    i_S  : in std_logic;
    o_O  : out std_logic
  );
end component;

signal stage0, stage1, stage2, stage3, stage4, stage5 : std_logic_vector(31 downto 0);
signal data_pre : std_logic_vector(31 downto 0);
signal ext_bit  : std_logic;
signal shift_type, dir : std_logic;
signal shift_amt_int : std_logic_vector(4 downto 0);

begin
  shift_type <= '1' when (ALU_control = "0111") else '0';
  dir        <= '1' when (ALU_control = "0001" or ALU_control = "0010" or ALU_control = "0100") else '0';
  shift_amt_int <= "01100" when (ALU_control = "0010") else shift_amt;
  ext_bit <= data_in(31) when shift_type = '1' else '0';

  gen_input_reverse: for i in 0 to 31 generate
  begin
    data_pre(i) <= data_in(i) when dir = '0' else data_in(31 - i);
  end generate;

  stage0 <= data_pre;

  gen_stage1_mux: for i in 0 to 30 generate
    signal D0, D1: std_logic;
  begin
    D0 <= stage0(i);
    D1 <= stage0(i + 1);
    mux1: mux2t1 port map(i_D0 => D0, i_D1 => D1, i_S => shift_amt_int(0), o_O => stage1(i));
  end generate;

  gen_stage1_ext: for i in 31 to 31 generate
  begin
    stage1(i) <= ext_bit when shift_amt_int(0) = '1' else stage0(i);
  end generate;

  gen_stage2_mux: for i in 0 to 29 generate
    signal D0, D1: std_logic;
  begin
    D0 <= stage1(i);
    D1 <= stage1(i + 2);
    mux2: mux2t1 port map(i_D0 => D0, i_D1 => D1, i_S => shift_amt_int(1), o_O => stage2(i));
  end generate;

  gen_stage2_ext: for i in 30 to 31 generate
  begin
    stage2(i) <= ext_bit when shift_amt_int(1) = '1' else stage1(i);
  end generate;

  gen_stage3_mux: for i in 0 to 27 generate
    signal D0, D1: std_logic;
  begin
    D0 <= stage2(i);
    D1 <= stage2(i + 4);
    mux3: mux2t1 port map(i_D0 => D0, i_D1 => D1, i_S => shift_amt_int(2), o_O => stage3(i));
  end generate;

  gen_stage3_ext: for i in 28 to 31 generate
  begin
    stage3(i) <= ext_bit when shift_amt_int(2) = '1' else stage2(i);
  end generate;

  gen_stage4_mux: for i in 0 to 23 generate
    signal D0, D1: std_logic;
  begin
    D0 <= stage3(i);
    D1 <= stage3(i + 8);
    mux4: mux2t1 port map(i_D0 => D0, i_D1 => D1, i_S => shift_amt_int(3), o_O => stage4(i));
  end generate;

  gen_stage4_ext: for i in 24 to 31 generate
  begin
    stage4(i) <= ext_bit when shift_amt_int(3) = '1' else stage3(i);
  end generate;

  gen_stage5_mux: for i in 0 to 15 generate
    signal D0, D1: std_logic;
  begin
    D0 <= stage4(i);
    D1 <= stage4(i + 16);
    mux5: mux2t1 port map(i_D0 => D0, i_D1 => D1, i_S => shift_amt_int(4), o_O => stage5(i));
  end generate;

  gen_stage5_ext: for i in 16 to 31 generate
  begin
    stage5(i) <= ext_bit when shift_amt_int(4) = '1' else stage4(i);
  end generate;

  gen_output_reverse: for i in 0 to 31 generate
  begin
    result(i) <= stage5(i) when dir = '0' else stage5(31 - i);
  end generate;

end structural;



