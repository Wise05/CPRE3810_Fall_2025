library IEEE;
use IEEE.std_logic_1164.all;

entity RISCV_Datapath2 is 
  port (
    clk : in std_logic;
    rst : in std_logic;
    RS1 : in std_logic_vector(4 downto 0);
    RS2 : in std_logic_vector(4 downto 0);
    RegWrite : in std_logic;
    Rd : in std_logic_vector(4 downto 0);
    imm : in std_logic_vector(11 downto 0);
    imm_sel : in std_logic;
    ALUSrc : in std_logic; -- 0 => register, 1 => immediate
    nAdd_Sub : in std_logic; -- 0 => add, 1 => subtract
    memToReg : in std_logic;
    memWrite : in std_logic;
    C_out: out std_logic
    );
end RISCV_Datapath2;

architecture structural of RISCV_Datapath2 is 
  signal OS1_s : std_logic_vector(31 downto 0);
  signal OS2_s : std_logic_vector(31 downto 0);
  signal ALU_s : std_logic_vector(31 downto 0);
  signal immExt_s : std_logic_vector(31 downto 0);
  signal memQ_s : std_logic_vector(31 downto 0);
  signal DATA_IN_s : std_logic_vector(31 downto 0);

  component ALU_ALUSrc is 
    port (
      A_i      : in std_logic_vector(31 downto 0);
      B_i      : in std_logic_vector(31 downto 0);
      Imm      : in std_logic_vector(31 downto 0);
      ALUSrc   : in std_logic;
      nAdd_Sub : in std_logic;
      C_out    : out std_logic;
      S_i      : out std_logic_vector(31 downto 0)
    );
  end component;

  component RV32_regFile is 
    port (
      clk      : in std_logic;
      rst      : in std_logic;
      RegWrite : in std_logic; 
      Rd       : in std_logic_vector(4 downto 0);
      DATA_IN  : in std_logic_vector(31 downto 0);
      RS1      : in std_logic_vector(4 downto 0);
      RS2      : in std_logic_vector(4 downto 0);
      OS1      : out std_logic_vector(31 downto 0);
      OS2      : out std_logic_vector(31 downto 0)
    );
  end component;

  component mem is 
    generic 
	(
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 10
	);

	port 
	(
		clk	: in std_logic;
		addr : in std_logic_vector((ADDR_WIDTH-1) downto 0);
		data : in std_logic_vector((DATA_WIDTH-1) downto 0);
		we : in std_logic := '1';
		q	: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);
  end component;

  component extender_Nt32 is 
    generic (
      N : integer := 12  
    );
    port (
      imm_in : in  std_logic_vector(N-1 downto 0);
      sign_ext : in  std_logic; -- '1' = sign extend, '0' = zero extend
      imm_out : out std_logic_vector(31 downto 0)
    );
  end component;

  component mux2t1_32bits is 
    port(i_D : in std_logic_vector(31 downto 0);
      i_imm : in std_logic_vector(31 downto 0); -- Immediate
      ALUSrc : in std_logic;
      o_O : out std_logic_vector(31 downto 0));
  end component;

begin
  Reg_File : RV32_regFile
    port map (
      clk => clk,
      rst => rst,
      RegWrite => RegWrite,
      Rd => Rd,
      DATA_IN => DATA_IN_s,
      RS1 => RS1,
      RS2 => RS2, 
      OS1 => OS1_s,
      OS2 => OS2_s
    );

  Extender : extender_Nt32 
    generic map (N => 12)
    port map (
      imm_in => imm,
      sign_ext => imm_sel,
      imm_out => immExt_s
    );

  ALU : ALU_ALUSrc 
    port map (
      A_i => OS1_s,
      B_i => OS2_s,
      Imm => immExt_s,
      ALUSrc => ALUSrc,
      nAdd_Sub => nAdd_Sub,
      C_out => C_out,
      S_i => ALU_s
    );

  Memory : mem
    generic map (DATA_WIDTH => 32, ADDR_WIDTH => 10);
    port map (
      clk => clk,
      addr => ALU_s(9 downto 0),
      data => OS2_s,
      we => memWrite,
      q => memQ_s
    );

    Load_Src : mux2t1_32bits  
      port (
        i_D => ALU_s,
        i_imm => memQ_s,
        ALUSrc => memToReg,
        o_O => DATA_IN_s
      );

end structural;
