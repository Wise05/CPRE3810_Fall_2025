library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity forwarding_unit is 
  port (
    i_rs1_ex       : in std_logic_vector(4 downto 0);
    i_rs2_ex       : in std_logic_vector(4 downto 0);
    i_rd_mem       : in std_logic_vector(4 downto 0);
    i_rd_wb        : in std_logic_vector(4 downto 0);
    i_regWrite_mem : in std_logic;
    i_regWrite_wb  : in std_logic;
    i_ALU_src      : in std_logic;
    i_auipc        : in std_logic;
    o_alu_a_mux    : out std_logic_vector(1 downto 0);
    o_alu_b_mux    : out std_logic_vector(1 downto 0)
  );
end forwarding_unit;

architecture dataflow of forwarding_unit is
begin

  o_alu_a_mux <=
      "10" when (i_regWrite_mem = '1' and 
                 i_rd_mem /= "00000" and 
                 i_rd_mem = i_rs1_ex) else
      "01" when (i_regWrite_wb = '1' and 
                 i_rd_wb /= "00000" and 
                 i_rd_wb = i_rs1_ex) else
      "11" when (i_auipc = '1') else
      "00";

  o_alu_b_mux <=
      "10" when (i_regWrite_mem = '1' and 
                 i_rd_mem /= "00000" and 
                 i_rd_mem = i_rs2_ex) else
      "01" when (i_regWrite_wb = '1' and 
                 i_rd_wb /= "00000" and 
                 i_rd_wb = i_rs2_ex) else
      "11" when (i_ALU_src = '1') else
      "00";

end dataflow;

