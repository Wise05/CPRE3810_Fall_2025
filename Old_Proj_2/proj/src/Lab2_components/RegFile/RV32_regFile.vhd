library IEEE;
use IEEE.std_logic_1164.all;
use work.RISCV_types.all;

entity RV32_regFile is 
  port (
    clk : in std_logic;
    rst : in std_logic;
    RegWrite: in std_logic; -- write enable for entire RV32
    Rd: in std_logic_vector(4 downto 0);
    DATA_IN : in std_logic_vector(31 downto 0);
    RS1 : in std_logic_vector(4 downto 0);
    RS2 : in std_logic_vector(4 downto 0);
    OS1 : out std_logic_vector(31 downto 0);
    OS2 : out std_logic_vector(31 downto 0)
  );
end RV32_regFile;

architecture structural of RV32_regFile is 
  signal s_Rd_decoded : std_logic_vector(31 downto 0);
  signal s_WE : std_logic_vector(31 downto 0);
  signal s_o_Q : reg_array;
  signal s_DATA_IN : reg_array;  -- Array of data inputs for each register
  
  component decoder_5t32 is 
    port (i_5 : in std_logic_vector(4 downto 0);
          o_32 : out std_logic_vector(31 downto 0));
  end component;
  
  component dffg_N is 
    generic(N : integer := 32);
    port(i_CLK : in std_logic;
         i_RST: in std_logic;
         i_WE: in std_logic;
         i_D : in std_logic_vector(N-1 downto 0);
         o_Q : out std_logic_vector(N-1 downto 0));
  end component;
  
  component mux_32t1 is 
    port (i_32 : in reg_array;
          s_i : in std_logic_vector(4 downto 0);
          o_1: out std_logic_vector(31 downto 0));
  end component;

begin
  Rd_dec : decoder_5t32
    port map (
      i_5 => Rd,
      o_32 => s_Rd_decoded
    );
  
  gen_regs : for i in 0 to 31 generate
    -- Register 0 is hardwired to 0
    zero_reg : if i = 0 generate
      s_o_Q(0) <= (others => '0');
      s_WE(0) <= '0';  -- Never write to x0
    end generate;
    
    -- Register 2 (stack pointer) gets special initialization
    sp_reg : if i = 2 generate
      s_WE(i) <= s_Rd_decoded(i) and RegWrite;
      -- Initialize to stack pointer value on reset, otherwise use DATA_IN
      s_DATA_IN(i) <= x"7FFFEFFC" when rst = '1' else DATA_IN;
      dffg_32I : dffg_N
        generic map (N => 32)
        port map (
          i_CLK => clk,
          i_RST => '0',  -- Don't use reset to clear, use it to load initial value
          i_WE => s_WE(i) or rst,  -- Write enable on reset or normal write
          i_D => s_DATA_IN(i),
          o_Q => s_o_Q(i)
        );
    end generate;
    
    -- All other normal registers (1, 3-31)
    normal_reg : if (i /= 0 and i /= 2) generate
      s_WE(i) <= s_Rd_decoded(i) and RegWrite;
      dffg_32I : dffg_N
        generic map (N => 32)
        port map (
          i_CLK => clk,
          i_RST => rst,
          i_WE => s_WE(i),
          i_D => DATA_IN,
          o_Q => s_o_Q(i)
        );
    end generate;
  end generate;
  
  Mux_RS1 : mux_32t1
    port map (
      i_32 => s_o_Q,
      s_i  => RS1,
      o_1  => OS1
    );
    
  Mux_RS2 : mux_32t1
    port map (
      i_32 => s_o_Q,
      s_i  => RS2,
      o_1  => OS2
    );
end structural;
