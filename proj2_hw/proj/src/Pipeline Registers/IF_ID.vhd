library IEEE;
use IEEE.std_logic_1164.all;

entity IF_ID is 
  port (
    in_instruct     : in std_logic_vector(31 downto 0);
    in_PC_val       : in std_logic_vector(31 downto 0);
    in_PC_plus4     : in std_logic_vector(31 downto 0);
    in_stall_fetch  : in std_logic;
    in_flush_fetch  : in std_logic;
    WE              : in std_logic;
    out_instruct    : out std_logic_vector(31 downto 0);
    out_PC_val      : out std_logic_vector(31 downto 0);
    out_PC_plus4    : out std_logic_vector(31 downto 0);
    RST             : in std_logic;
    CLK             : in std_logic
  );
end IF_ID;

architecture structural of IF_ID is 
  
  component Nbit_reg is 
    generic(N : integer := 32); 
    port (
      in_1  : in std_logic_vector(N-1 downto 0);
      WE    : in std_logic;
      out_1 : out std_logic_vector(N-1 downto 0);
      RST   : in std_logic;
      CLK   : in std_logic
    );
  end component;
  
  signal instr_in_s    : std_logic_vector(31 downto 0);
  signal pc_val_in_s   : std_logic_vector(31 downto 0);
  signal pc_plus4_in_s : std_logic_vector(31 downto 0);
  signal we_internal   : std_logic;
  
begin

  -- When flushing: insert NOP
  -- When stalling: disable write enable (holds current value)
  -- Otherwise: pass through new input
  instr_in_s    <= (others => '0') when in_flush_fetch = '1' else in_instruct;
  pc_val_in_s   <= (others => '0') when in_flush_fetch = '1' else in_PC_val;
  pc_plus4_in_s <= (others => '0') when in_flush_fetch = '1' else in_PC_plus4;
  
  -- Disable write enable when stalling (but not when flushing)
  we_internal <= '0' when (in_stall_fetch = '1' and in_flush_fetch = '0') else WE;

  instruct_pipe_reg: Nbit_reg
    port map (
      in_1   => instr_in_s,
      WE     => we_internal,
      out_1  => out_instruct,
      RST    => RST,
      CLK    => CLK
    );
    
  pc_val_pipe_reg: Nbit_reg
    port map (
      in_1   => pc_val_in_s,
      WE     => we_internal,
      out_1  => out_PC_val,
      RST    => RST,
      CLK    => CLK
    );
    
  pc_plus4_pipe_reg: Nbit_reg
    port map (
      in_1   => pc_plus4_in_s,
      WE     => we_internal,
      out_1  => out_PC_plus4,
      RST    => RST,
      CLK    => CLK
    );
    
end structural;
