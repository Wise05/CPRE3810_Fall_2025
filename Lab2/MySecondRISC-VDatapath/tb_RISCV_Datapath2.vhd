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
    -- Initialize all signals
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
    
    -- Reset
    rst <= '1';
    wait for 3*cCLK_PER;
    rst <= '0';
    wait for cCLK_PER;
    
    -- Initialize base addresses (simplified approach using small addresses)
    -- addi x25, x0, 64  # Base address for array A (address 64)
    RS1 <= "00000";  -- x0 (always 0)
    RS2 <= "00000";
    Rd <= "11001";   -- x25
    imm <= "000001000000";  -- 64 in binary (12 bits)
    imm_sel <= '1';  -- Sign extend
    ALUSrc <= '1';   -- Use immediate
    nAdd_Sub <= '0'; -- Add
    RegWrite <= '1';
    memToReg <= '0';
    memWrite <= '0';
    wait for 1 ns;
    wait for cCLK_PER;
    
    -- addi x26, x0, 320  # Base address for array B (address 320 = 64 + 256)
    RS1 <= "00000";  -- x0
    Rd <= "11010";   -- x26
    imm <= "101000000000";  -- 320 in 12-bit binary (truncated, use 320 mod 2048)
    wait for 1 ns;
    wait for cCLK_PER;
    
    -- addi x27, x0, 576  # Base address for B[64] (576 = 320 + 256)
    RS1 <= "00000";  -- x0  
    Rd <= "11011";   -- x27
    imm <= "001001000000";  -- 576 in 12-bit binary (truncated)
    wait for 1 ns;
    wait for cCLK_PER;
    
    -- Pre-populate some memory locations for testing
    -- Store test value 10 at address 64 (A[0])
    RS1 <= "00000";  -- x0
    Rd <= "00011";   -- x3 (temp register)
    imm <= "000000001010";  -- 10
    ALUSrc <= '1';
    RegWrite <= '1';
    memToReg <= '0';
    wait for 1 ns;
    wait for cCLK_PER;
    
    -- Store x3 to memory address 64 (A[0])
    RS1 <= "11001";  -- x25 (base address 64)
    RS2 <= "00011";  -- x3 (data to store)
    imm <= "000000000000";  -- offset 0
    ALUSrc <= '1';   -- Use immediate for address calculation
    RegWrite <= '0';
    memWrite <= '1';
    wait for 1 ns;
    wait for cCLK_PER;
    
    -- Store test value 20 at address 68 (A[1])
    RS1 <= "00000";  -- x0
    Rd <= "00011";   -- x3
    imm <= "000000010100";  -- 20
    ALUSrc <= '1';
    RegWrite <= '1';
    memToReg <= '0';
    memWrite <= '0';
    wait for 1 ns;
    wait for cCLK_PER;
    
    -- Store x3 to memory address 68 (A[1])
    RS1 <= "11001";  -- x25
    RS2 <= "00011";  -- x3
    imm <= "000000000100";  -- offset 4
    ALUSrc <= '1';
    RegWrite <= '0';
    memWrite <= '1';
    wait for 1 ns;
    wait for cCLK_PER;
    
    -- Now start the actual algorithm
    -- lw x1, 0(x25) # Load A[0] into x1
    RS1 <= "11001";  -- x25
    RS2 <= "00000";  -- Don't care for load
    Rd <= "00001";   -- x1
    imm <= "000000000000";  -- offset 0
    imm_sel <= '1';
    ALUSrc <= '1';   -- Use immediate
    nAdd_Sub <= '0';
    RegWrite <= '1';
    memToReg <= '1'; -- Write memory data to register
    memWrite <= '0';
    wait for 1 ns;
    wait for cCLK_PER;
    
    -- lw x2, 4(x25) # Load A[1] into x2
    RS1 <= "11001";  -- x25
    Rd <= "00010";   -- x2
    imm <= "000000000100";  -- offset 4
    wait for 1 ns;
    wait for cCLK_PER;
    
    -- add x1, x1, x2 # x1 = x1 + x2
    RS1 <= "00001";  -- x1
    RS2 <= "00010";  -- x2
    Rd <= "00001";   -- x1 (destination)
    ALUSrc <= '0';   -- Use register for second operand
    nAdd_Sub <= '0'; -- Add
    memToReg <= '0'; -- Write ALU result to register
    wait for 1 ns;
    wait for cCLK_PER;
    
    -- sw x1, 0(x26) # Store x1 value into B[0]
    RS1 <= "11010";  -- x26 (base address for B)
    RS2 <= "00001";  -- x1 (data to store)
    imm <= "000000000000";  -- offset 0
    ALUSrc <= '1';   -- Use immediate for address
    RegWrite <= '0';
    memWrite <= '1';
    wait for 1 ns;
    wait for cCLK_PER;
    
    -- Add some verification reads
    -- Read back what we stored
    RS1 <= "11010";  -- x26
    Rd <= "00100";   -- x4 (temp for verification)
    imm <= "000000000000";  -- offset 0
    ALUSrc <= '1';
    RegWrite <= '1';
    memToReg <= '1';
    memWrite <= '0';
    wait for 1 ns;
    wait for cCLK_PER;
    
    -- Final state - disable all writes
    RegWrite <= '0';
    memWrite <= '0';
    wait for 2*cCLK_PER;
    wait;
  end process;

end tb;
