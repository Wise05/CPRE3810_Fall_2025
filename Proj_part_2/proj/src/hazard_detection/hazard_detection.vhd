library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity hazard_detection is
  port (
    i_opcode_execute  : in  std_logic_vector(6 downto 0); 
    i_rs1_decode      : in  std_logic_vector(4 downto 0);
    i_rs2_decode       : in  std_logic_vector(4 downto 0);
    i_rd_execute      : in  std_logic_vector(4 downto 0);
    i_offsetpc        : in  std_logic;
    o_stall_pc        : out std_logic;
    o_stall_IF_ID     : out std_logic;
    o_stall_ID_EX     : out std_logic;
    o_flush_fetch     : out std_logic;
    o_flush_decode    : out std_logic;
    o_flush_execute   : out std_logic
  );
end hazard_detection;

architecture dataflow of hazard_detection is

signal load_use_hazard : std_logic;

begin
load_use_hazard <= '1'
when (i_opcode_execute = "0000011" and
      i_rd_execute /= "00000" and
      (i_rd_execute = i_rs1_decode or
       i_rd_execute = i_rs2_decode))
else '0';     

o_stall_pc         <= '1' when (load_use_hazard = '1' and i_offsetpc  = '0') else '0';
o_stall_IF_ID     <= '1' when (load_use_hazard = '1' and i_offsetpc  = '0') else '0';
o_stall_ID_EX    <= '1' when (load_use_hazard = '1' and i_offsetpc  = '0') else '0';

o_flush_fetch      <= '1' when (i_offsetpc  = '1') else '0';
o_flush_decode     <= '1' when (i_offsetpc  = '1') else '0';
o_flush_execute    <= '1' when (i_offsetpc  = '1') else '0';

end dataflow;



