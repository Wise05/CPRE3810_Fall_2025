library IEEE;
use IEEE.std_logic_1164.all;


entity ID_EX is --13 inputs
  port (
        in_ALUSrc : in std_logic;
	in_ALUControl : in std_logic_vector(3 downto 0);
	in_ImmType : in std_logic_vector(2 downto 0);
	in_MemWrite : in std_logic;
	in_imm_sel : in std_logic_vector(1 downto 0);
	in_branch_type : in std_logic_vector(2 downto 0);
	in_jump : in std_logic;
	in_link : in std_logic;
	in_PCReg : in std_logic;
	in_auipc : in std_logic;
	in_data1 : in std_logic_vector(31 downto 0);
	in_data2 : in std_logic_vector(31 downto 0);
	in_extender : in std_logic_vector(31 downto 0);
	in_halt     : in std_logic;
	in_MemtoReg     : in std_logic;
	in_load : in std_logic_vector(2 downto 0);
	WE : in std_logic;
	out_ALUSrc : out std_logic;
	out_ALUControl : out std_logic_vector(3 downto 0);
	out_ImmType : out std_logic_vector(2 downto 0);
	out_MemWrite : out std_logic;
	out_imm_sel : out std_logic_vector(1 downto 0);
	out_branch_type : out std_logic_vector(2 downto 0);
	out_jump : out std_logic;
	out_link : out std_logic;
	out_PCReg : out std_logic;
	out_auipc : out std_logic;
	out_data1 : out std_logic_vector(31 downto 0);
	out_data2 : out std_logic_vector(31 downto 0);
	out_extender : out std_logic_vector(31 downto 0);
	out_halt     : out std_logic;
	out_MemtoReg     : out std_logic;
	out_load : out std_logic_vector(2 downto 0);
	RST : in std_logic;
	CLK: in std_logic
  );
end ID_EX;

architecture structural of ID_EX is 
  
  component Nbit_reg is 
    generic(N : integer := 32); 
    port (
        in_1 : in std_logic_vector(N-1 downto 0);
	WE : in std_logic;
	out_1 : out std_logic_vector(N-1 downto 0);
	RST : in std_logic;
	CLK: in std_logic
);
  end component;

begin

ALUSrc_reg: Nbit_reg
	generic map (N => 1)
	port map (
		in_1(0) => in_ALUSrc,
		WE => WE,
		out_1(0) => out_ALUSrc,
		RST => RST,
		CLK => CLK
    );

ALUControl_reg: Nbit_reg
	generic map (N => 4)
	port map (
		in_1 => in_ALUControl,
		WE => WE,
		out_1 => out_ALUControl,
		RST => RST,
		CLK => CLK
    );

ImmType_reg: Nbit_reg
	generic map (N => 3)
	port map (
		in_1 => in_ImmType,
		WE => WE,
		out_1 => out_ImmType,
		RST => RST,
		CLK => CLK
    );

MemWrite_reg: Nbit_reg
	generic map (N => 1)
	port map (
		in_1(0) => in_MemWrite,
		WE => WE,
		out_1(0) => out_MemWrite,
		RST => RST,
		CLK => CLK
    );

imm_sel_reg: Nbit_reg
	generic map (N => 2)
	port map (
		in_1 => in_imm_sel,
		WE => WE,
		out_1 => out_imm_sel,
		RST => RST,
		CLK => CLK
    );

branch_type_reg: Nbit_reg
	generic map (N => 3)
	port map (
		in_1 => in_branch_type,
		WE => WE,
		out_1 => out_branch_type,
		RST => RST,
		CLK => CLK
    );

jump_reg: Nbit_reg
	generic map (N => 1)
	port map (
		in_1(0) => in_jump,
		WE => WE,
		out_1(0) => out_jump,
		RST => RST,
		CLK => CLK
    );

link_reg: Nbit_reg
	generic map (N => 1)
	port map (
		in_1(0) => in_link,
		WE => WE,
		out_1(0) => out_link,
		RST => RST,
		CLK => CLK
    );

PCReg_reg: Nbit_reg
	generic map (N => 1)
	port map (
		in_1(0) => in_PCReg,
		WE => WE,
		out_1(0) => out_PCReg,
		RST => RST,
		CLK => CLK
    );

auipc_reg: Nbit_reg
	generic map (N => 1)
	port map (
		in_1(0) => in_auipc,
		WE => WE,
		out_1(0) => out_auipc,
		RST => RST,
		CLK => CLK
    );

data1_reg: Nbit_reg
	generic map (N => 32)
	port map (
		in_1 => in_data1,
		WE => WE,
		out_1 => out_data1,
		RST => RST,
		CLK => CLK
    );

data2_reg: Nbit_reg
	generic map (N => 32)
	port map (
		in_1 => in_data2,
		WE => WE,
		out_1 => out_data2,
		RST => RST,
		CLK => CLK
    );

extender_reg: Nbit_reg
	generic map (N => 32)
	port map (
		in_1 => in_extender,
		WE => WE,
		out_1 => out_extender,
		RST => RST,
		CLK => CLK
    );

halt_reg: Nbit_reg
	generic map (N => 1)
	port map (
		in_1(0) => in_halt,
		WE => WE,
		out_1(0) => out_halt,
		RST => RST,
		CLK => CLK
    );

MemtoReg_reg: Nbit_reg
	generic map (N => 1)
	port map (
		in_1(0) => in_MemtoReg,
		WE => WE,
		out_1(0) => out_MemtoReg,
		RST => RST,
		CLK => CLK
    );

load_reg: Nbit_reg
	generic map (N => 3)
	port map (
		in_1 => in_load,
		WE => WE,
		out_1 => out_load,
		RST => RST,
		CLK => CLK
    );

end structural;
