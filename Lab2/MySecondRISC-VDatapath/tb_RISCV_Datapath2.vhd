library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_RISCV_Datapath2 is
end tb_RISCV_Datapath2;

architecture tb of tb_RISCV_Datapath2 is
  signal clk : std_logic := '0';
  signal rst : std_logic := '1';
  signal RS1 : std_logic_vector(4 downto 0);
  signal RS2 : std_logic_vector(4 downto 0);
  signal RegWrite : std_logic;
  signal Rd : std_logic_vector(4 downto 0);
  signal imm : std_logic_vector(11 downto 0);
  signal imm_sel : std_logic;
  signal ALUSrc : std_logic; -- 0 => register, 1 => immediate
  signal nAdd_Sub : std_logic; -- 0 => add, 1 => subtract
  signal memToReg : std_logic;
  signal memWrite : std_logic;
  signal C_out : std_logic;
  signal OS1_obs : std_logic_vector(31 downto 0);
  signal OS2_obs : std_logic_vector(31 downto 0);
  signal S_i_obs : std_logic_vector(31 downto 0);
  
  constant gCLK_HPER : time := 5 ns;
  constant cCLK_PER  : time := gCLK_HPER * 2;
  
  component RISCV_Datapath2 is 
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
      C_out: out std_logic;
      OS1 : out std_logic_vector(31 downto 0);  
      OS2 : out std_logic_vector(31 downto 0);
      S_i : out std_logic_vector(31 downto 0)
    );
  end component;

begin
  DUT: RISCV_Datapath2
    port map (
      clk => clk,
      rst => rst,
      RS1 => RS1,
      RS2 => RS2,
      RegWrite => RegWrite,
      Rd => Rd,
      imm => imm,
      imm_sel => imm_sel,
      ALUSrc => ALUSrc,
      nAdd_Sub => nAdd_Sub,
      memToReg => memToReg,
      memWrite => memWrite,
      C_out => C_out,
      OS1 => OS1_obs, 
      OS2 => OS2_obs,
      S_i => S_i_obs
    );

  clk_process : process
  begin
    clk <= '0';
    wait for gCLK_HPER;
    clk <= '1';
    wait for gCLK_HPER;
  end process;

  sim_proc : process
  begin
    -- Reset
    rst <= '1';
    RegWrite <= '0';
    RS1 <= "00000";
    RS2 <= "00000";
    Rd <= "00000";
    imm <= "000000000000";
    imm_sel <= '0';
    ALUSrc <= '0';
    nAdd_Sub <= '0';
    memToReg <= '0';
    memWrite <= '0';
    wait for 3*cCLK_PER;
    
    rst <= '0';
    wait for cCLK_PER;
    
    -- addi x25, x25, 0 # Load &A into x25, assuming x25 initially has 0x10010000
    RS1 <= "11001";
    RS2 <= "00000";
    Rd <= "11001";
    imm <= "000000000000";
    imm_sel <= '1';
    ALUSrc <= '1';
    nAdd_Sub <= '0';
    RegWrite <= '1';
    memToReg <= '0';
    memWrite <= '0';
wait for 1 ns;
    wait for cCLK_PER;
    
    -- addi x26, x26, 256 # Load &B into x26, assuming x26 initially has 0x10010000
    RS1 <= "11010";
    Rd <= "11010";
    imm <= "100000000000";
wait for 1 ns;
    wait for cCLK_PER;
    
    -- lw x1, 0(x25) # Load A[0] into x1
    RS1 <= "11001";
    Rd <= "00001";
    imm <= "000000000000";
    ALUSrc <= '1';
    memToReg <= '1';
    RegWrite <= '1';
wait for 1 ns;
    wait for cCLK_PER;
    
    -- lw x2, 4(x25) # Load A[1] into x2
    RS1 <= "11001";
    Rd <= "00010";
    imm <= "000000000100";
wait for 1 ns;
    wait for cCLK_PER;
    
    -- add x1, x1, x2 # x1 = x1 + x2
    RS1 <= "00001";
    RS2 <= "00010";
    Rd <= "00001";
    ALUSrc <= '0';
    nAdd_Sub <= '0';
    memToReg <= '0';
wait for 1 ns;
    wait for cCLK_PER;
    
    -- sw x1, 0(x26) # Store x1 value into B[0]
    RS1 <= "11010";
    RS2 <= "00001";
    imm <= "000000000000";
    ALUSrc <= '1';
    RegWrite <= '0';
    memWrite <= '1';
wait for 1 ns;
    wait for cCLK_PER;
    
    -- lw x2, 8(x25) # Load A[2] into x2
    RS1 <= "11001";
    Rd <= "00010";
    imm <= "000000001000";
    ALUSrc <= '1';
    RegWrite <= '1';
    memToReg <= '1';
    memWrite <= '0';
wait for 1 ns;
    wait for cCLK_PER;
    
    -- add x1, x1, x2 # x1 = x1 + x2
    RS1 <= "00001";
    RS2 <= "00010";
    Rd <= "00001";
    ALUSrc <= '0';
    memToReg <= '0';
wait for 1 ns;
    wait for cCLK_PER;
    
    -- sw x1, 4(x26) # Store x1 value into B[1]
    RS1 <= "11010";
    RS2 <= "00001";
    imm <= "000000000100";
    ALUSrc <= '1';
    RegWrite <= '0';
    memWrite <= '1';
wait for 1 ns;
    wait for cCLK_PER;
    
    -- lw x2, 12(x25) # Load A[3] into x2
    RS1 <= "11001";
    Rd <= "00010";
    imm <= "000000001100";
    ALUSrc <= '1';
    RegWrite <= '1';
    memToReg <= '1';
    memWrite <= '0';
wait for 1 ns;
    wait for cCLK_PER;
    
    -- add x1, x1, x2 # x1 = x1 + x2  
    RS1 <= "00001";
    RS2 <= "00010";
    Rd <= "00001";
    ALUSrc <= '0';
    memToReg <= '0';
wait for 1 ns;
    wait for cCLK_PER;
    
    -- sw x1, 12(x26) # Store x1 value into B[3]
    RS1 <= "11010";
    RS2 <= "00001";
    imm <= "000000001100";
    ALUSrc <= '1';
    RegWrite <= '0';
    memWrite <= '1';
wait for 1 ns;
    wait for cCLK_PER;
    
    -- lw x2, 20(x25) # Load A[5] into x2
    RS1 <= "11001";
    Rd <= "00010";
    imm <= "000000010100";
    RegWrite <= '1';
    memToReg <= '1';
    memWrite <= '0';
wait for 1 ns;
    wait for cCLK_PER;
    
    -- add x1, x1, x2 # x1 = x1 + x2
    RS1 <= "00001";
    RS2 <= "00010";
    Rd <= "00001";
    ALUSrc <= '0';
    memToReg <= '0';
wait for 1 ns;
    wait for cCLK_PER;
    
    -- sw x1, 16(x26) # Store x1 value into B[4]
    RS1 <= "11010";
    RS2 <= "00001";
    imm <= "000000010000";
    ALUSrc <= '1';
    RegWrite <= '0';
    memWrite <= '1';
wait for 1 ns;
    wait for cCLK_PER;
    
    -- lw x2, 24(x25) # Load A[6] into x2
    RS1 <= "11001";
    Rd <= "00010";
    imm <= "000000011000";
    RegWrite <= '1';
    memToReg <= '1';
    memWrite <= '0';
wait for 1 ns;
    wait for cCLK_PER;
    
    -- add x1, x1, x2 # x1 = x1 + x2
    RS1 <= "00001";
    RS2 <= "00010";
    Rd <= "00001";
    ALUSrc <= '0';
    memToReg <= '0';
wait for 1 ns;
    wait for cCLK_PER;
    
    -- addi x27, x27, 512 # Load &B[64] into x27
    RS1 <= "11011";
    Rd <= "11011";
    imm <= "001000000000";
    ALUSrc <= '1';
    RegWrite <= '1';
    memToReg <= '0';
wait for 1 ns;
    wait for cCLK_PER;
    
    -- sw x1, -4(x27) # Store x1 into B[63]
    RS1 <= "11011";
    RS2 <= "00001";
    imm <= "111111111100";
    ALUSrc <= '1';
    RegWrite <= '0';
    memWrite <= '1';
wait for 1 ns;
    wait for cCLK_PER;
    
    -- End simulation
    RegWrite <= '0';
    memWrite <= '0';
wait for 1 ns;
    wait for 2*cCLK_PER;
    wait;
  end process;
end tb;
