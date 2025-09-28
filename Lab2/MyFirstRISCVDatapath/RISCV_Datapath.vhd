library IEEE;
use IEEE.std_logic_1164.all;

entity RISCV_Datapath is 
  port (
    clk: in std_logic;
    rst : in std_logic;
    RS1 : in std_logic_vector(4 downto 0);
    RS2 : in std_logic_vector(4 downto 0);
    RegWrite : in std_logic;
    Rd : in std_logic_vector(4 downto 0);
    imm : in std_logic_vector(31 downto 0);
    ALUSrc : in std_logic;
    nAdd_Sub : in std_logic; -- 0 => add, 1 => subtract
    C_out: out std_logic;
    OS1 : out std_logic_vector(31 downto 0);
    OS2 : out std_logic_vector(31 downto 0);
    S_i : out std_logic_vector(31 downto 0)
  );
end RISCV_Datapath;

architecture structural of RISCV_Datapath is 
  signal OS1_s : std_logic_vector(31 downto 0);
  signal OS2_s : std_logic_vector(31 downto 0);
  signal S_i_s : std_logic_vector(31 downto 0);
  
  component ALU_ALUSrc is
    port (
      A_i : in std_logic_vector(31 downto 0);
      B_i : in std_logic_vector(31 downto 0);
      Imm : in std_logic_vector(31 downto 0);
      ALUSrc : in std_logic;
      nAdd_Sub : in std_logic;
      C_out : out std_logic;
      S_i : out std_logic_vector(31 downto 0)
    );
  end component;
  
  component RV32_regFile is 
    port (
      clk : in std_logic;
      rst : in std_logic;
      RegWrite : in std_logic; 
      Rd : in std_logic_vector(4 downto 0);
      DATA_IN : in std_logic_vector(31 downto 0);
      RS1 : in std_logic_vector(4 downto 0);
      RS2 : in std_logic_vector(4 downto 0);
      OS1 : out std_logic_vector(31 downto 0);
      OS2 : out std_logic_vector(31 downto 0)
    );
  end component;

begin
  Reg_File : RV32_regFile 
    port map (
      clk => clk,
      rst => rst,
      RegWrite => RegWrite,
      Rd => Rd,
      DATA_IN => S_i_s,
      RS1 => RS1,
      RS2 => RS2,
      OS1 => OS1_s,
      OS2 => OS2_s
    );
    
  ALU : ALU_ALUSrc
    port map (
      A_i => OS1_s,
      B_i => OS2_s,
      Imm => imm, 
      ALUSrc => ALUSrc,
      nAdd_Sub => nAdd_Sub, 
      C_out => C_out,
      S_i => S_i_s
    );
    
  OS1 <= OS1_s;
  OS2 <= OS2_s;
  S_i <= S_i_s;
  
end structural;
