library IEEE;
use IEEE.std_logic_1164.all;
use work.regfile_pkg.all;

entity fetch is 
  -- inputs jump, branch, immediate (extended), zero flag
  port (
    clk : in std_logic;
    rst : in std_logic;
    -- Maybe we need RegWrite for the PC, but rn it will be set to 1
    branch : in std_logic;
    zero_flag_ALU : in std_logic;
    jump : in std_logic;
    imm : in std_logic_vector(31 downto 0); -- immediate offset
    o_clk : out std_logic;
    instr_addr : out std_logic_vector(31 downto 0); -- address sent to imem
    plus4_o : out std_logic_vector(31 downto 0); -- address that gets sent to "AndLink" address
 );
 end fetch;

architecture structural of fetch is
  signal instr_addr_s : std_logic_vector(31 downto 0);
  signal PC_in_s : std_logic_vector(31 downto 0);
  signal plus4_s : std_logic_vector(31 downto 0);
  signal imm_shifted_s : std_logic_vector(31 downto 0);
  signal PC_offset_s : std_logic_vector(31 downto 0);
  signal PCSrc : std_logic;
  signal branch_and_zero : std_logic;

  -- signals to make compiler happy, but we don't care about
  signal plus4_cOut_s : std_logic;
  signal PC_off_cOut_s : std_logic;

  component PC is 
    port (
      clk : in std_logic;
      rst : in std_logic;
      RegWrite: in std_logic; -- write enable
      DATA_IN : in std_logic_vector(31 downto 0);
      OS : out std_logic_vector(31 downto 0);
      o_CLK : out std_logic
    );
  end component;

  component carry_adder_N is 
    generic(N : integer := 16);
    port (
      A_i : in std_logic_vector(N-1 downto 0);
      B_i : in std_logic_vector(N-1 downto 0);
      C_in : in std_logic;
      S_i : out std_logic_vector(N-1 downto 0);
      C_out : out std_logic
    );
   end component;

   component Left_Shifter is 
    port (
      i : in std_logic_vector(31 downto 0);
      o : out std_logic_vector(31 downto 0)
    );
  end component; 

  component mux2t1_N is 
    generic(N : integer := 16);
    port(i_S          : in std_logic;
         i_D0         : in std_logic_vector(N-1 downto 0);
         i_D1         : in std_logic_vector(N-1 downto 0);
         o_O          : out std_logic_vector(N-1 downto 0)
       );
  end component

begin 
  pc_reg : PC
  port map (
    clk => clk,
    rst => rst,
    RegWrite => '1',
    DATA_IN => PC_in_s,
    OS => instr_addr_s,
    o_CLK => o_clk
  );


  plus4 : carry_adder_N
  generic map(N => 32);
  port map (
    A_i => instr_addr_s,
    B_i => x"00000004",
    C_in => '0',
    S_i => plus4,
    C_out => plus4_cOut_s
  );

  pc_plus_offset : carry_adder_N
  generic map(N => 32);
  port map (
    A_i => instr_addr_s,
    B_i => imm_shifted_s,
    C_in => '0',
    S_i => PC_offset_s,
    C_out => PC_off_cOut_s
  );

  shift_off : Left_Shifter 
    port map (
      i => imm,
      o => imm_shifted_s
  );

  mux_jump : mux2t1_N
    generic map (N => 32);
    port map (
      i_S => PCSrc,
      i_D0 => plus4_s,
      i_D1 => PC_offset_s,
      o_O => PC_in_s
  );

  branch_and_zero <= branch and zero_flag_ALU;
  PCSrc <= branch_and_zero xor jump;

  instr_addr <= instr_addr_s;
  plus4_o <= plus4_s;
  
end structural;

