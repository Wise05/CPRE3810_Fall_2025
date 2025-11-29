library IEEE;
use IEEE.std_logic_1164.all;

entity EX_MEM is
  port (
    in_ImmType        : in std_logic_vector(2 downto 0);
    in_MemWrite       : in std_logic;
    in_imm_sel        : in std_logic_vector(1 downto 0);
    in_branch_type    : in std_logic_vector(2 downto 0);
    in_jump           : in std_logic;
    in_branch         : in std_logic;
    in_PCReg          : in std_logic;
    in_data1          : in std_logic_vector(31 downto 0);
    in_data2          : in std_logic_vector(31 downto 0);
    in_extender       : in std_logic_vector(31 downto 0);
    in_halt           : in std_logic;
    in_MemtoReg       : in std_logic;
    in_regWrite       : in std_logic;
    in_regWrite_addr  : in std_logic_vector(4 downto 0);
    in_load           : in std_logic_vector(2 downto 0);
    in_mux            : in std_logic_vector(31 downto 0);
    in_alu            : in std_logic_vector(31 downto 0);
    in_zero           : in std_logic;
    in_PC_offset      : in std_logic_vector(31 downto 0);
    in_instruct       : in std_logic_vector(31 downto 0);
    in_flush_execute  : in std_logic;
    WE                : in std_logic;
    out_ImmType       : out std_logic_vector(2 downto 0);
    out_MemWrite      : out std_logic;
    out_regWrite      : out std_logic;
    out_regWrite_addr : out std_logic_vector(4 downto 0);
    out_imm_sel       : out std_logic_vector(1 downto 0);
    out_branch_type   : out std_logic_vector(2 downto 0);
    out_jump          : out std_logic;
    out_branch        : out std_logic;
    out_PCReg         : out std_logic;
    out_data1         : out std_logic_vector(31 downto 0);
    out_data2         : out std_logic_vector(31 downto 0);
    out_extender      : out std_logic_vector(31 downto 0);
    out_halt          : out std_logic;
    out_MemtoReg      : out std_logic;
    out_load          : out std_logic_vector(2 downto 0);
    out_mux           : out std_logic_vector(31 downto 0);
    out_alu           : out std_logic_vector(31 downto 0);
    out_zero          : out std_logic;
    out_PC_offset     : out std_logic_vector(31 downto 0);
    out_instruct      : out std_logic_vector(31 downto 0);
    RST               : in std_logic;
    CLK               : in std_logic
  );
end EX_MEM;

architecture structural of EX_MEM is 
  
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

  signal regWrite_in       : std_logic;
  signal regWrite_addr_in  : std_logic_vector(4 downto 0);
  signal MemWrite_in       : std_logic;
  signal jump_in           : std_logic;
  signal PCReg_in          : std_logic;
  signal data1_in          : std_logic_vector(31 downto 0);
  signal data2_in          : std_logic_vector(31 downto 0);
  signal MemtoReg_in       : std_logic;
  signal load_in           : std_logic_vector(2 downto 0);
  signal halt_in           : std_logic;
  signal instruct_in       : std_logic_vector(31 downto 0);

begin

-- Flush only (no stall): sets signals to a NOP instruction (add zero, zero, zero)
    regWrite_in      <= '0' when in_flush_execute = '1' else in_regWrite;
    regWrite_addr_in <= (others => '0') when in_flush_execute = '1' else in_regWrite_addr;
    MemWrite_in      <= '0' when in_flush_execute = '1' else in_MemWrite; 
    jump_in          <= '0' when in_flush_execute = '1' else in_jump;
    PCReg_in         <= '0' when in_flush_execute = '1' else in_PCReg;
    data1_in         <= (others => '0') when in_flush_execute = '1' else in_data1;
    data2_in         <= (others => '0') when in_flush_execute = '1' else in_data2;
    MemtoReg_in      <= '0' when in_flush_execute = '1' else in_MemtoReg;
    load_in          <= (others => '0') when in_flush_execute = '1' else in_load;
    halt_in          <= '0' when in_flush_execute = '1' else in_halt;
    instruct_in      <= x"00000013" when in_flush_execute = '1' else in_instruct;

  ImmType_reg: Nbit_reg
    generic map (N => 3)
    port map (
      in_1  => in_ImmType,
      WE    => WE,
      out_1 => out_ImmType,
      RST   => RST,
      CLK   => CLK
    );

  MemWrite_reg: Nbit_reg
    generic map (N => 1)
    port map (
      in_1(0)  => MemWrite_in,
      WE       => WE,
      out_1(0) => out_MemWrite,
      RST      => RST,
      CLK      => CLK
    );

  regWrite_reg: Nbit_reg
    generic map (N => 1)
    port map (
      in_1(0)  => regWrite_in,
      WE       => WE,
      out_1(0) => out_regWrite,
      RST      => RST,
      CLK      => CLK
    );

  regWrite_addr_reg: Nbit_reg
    generic map (N => 5)
    port map (
      in_1  => regWrite_addr_in,
      WE    => WE,
      out_1 => out_regWrite_addr,
      RST   => RST,
      CLK   => CLK
    );

  imm_sel_reg: Nbit_reg
    generic map (N => 2)
    port map (
      in_1  => in_imm_sel,
      WE    => WE,
      out_1 => out_imm_sel,
      RST   => RST,
      CLK   => CLK
    );

  branch_type_reg: Nbit_reg
    generic map (N => 3)
    port map (
      in_1  => in_branch_type,
      WE    => WE,
      out_1 => out_branch_type,
      RST   => RST,
      CLK   => CLK
    );

  jump_reg: Nbit_reg
    generic map (N => 1)
    port map (
      in_1(0)  => jump_in,
      WE       => WE,
      out_1(0) => out_jump,
      RST      => RST,
      CLK      => CLK
    );

  branch_reg: Nbit_reg
    generic map (N => 1)
    port map (
      in_1(0)  => in_branch,
      WE       => WE,
      out_1(0) => out_branch,
      RST      => RST,
      CLK      => CLK
    );

  PCReg_reg: Nbit_reg
    generic map (N => 1)
    port map (
      in_1(0)  => PCReg_in,
      WE       => WE,
      out_1(0) => out_PCReg,
      RST      => RST,
      CLK      => CLK
    );

  data1_reg: Nbit_reg
    generic map (N => 32)
    port map (
      in_1  => data1_in,
      WE    => WE,
      out_1 => out_data1,
      RST   => RST,
      CLK   => CLK
    );

  data2_reg: Nbit_reg
    generic map (N => 32)
    port map (
      in_1  => data2_in,
      WE    => WE,
      out_1 => out_data2,
      RST   => RST,
      CLK   => CLK
    );

  extender_reg: Nbit_reg
    generic map (N => 32)
    port map (
      in_1  => in_extender,
      WE    => WE,
      out_1 => out_extender,
      RST   => RST,
      CLK   => CLK
    );

  halt_reg: Nbit_reg
    generic map (N => 1)
    port map (
      in_1(0)  => halt_in,
      WE       => WE,
      out_1(0) => out_halt,
      RST      => RST,
      CLK      => CLK
    );

  MemtoReg_reg: Nbit_reg
    generic map (N => 1)
    port map (
      in_1(0)  => MemtoReg_in,
      WE       => WE,
      out_1(0) => out_MemtoReg,
      RST      => RST,
      CLK      => CLK
    );

  load_reg: Nbit_reg
    generic map (N => 3)
    port map (
      in_1  => load_in,
      WE    => WE,
      out_1 => out_load,
      RST   => RST,
      CLK   => CLK
    );

  mux_reg: Nbit_reg
    generic map (N => 32)
    port map (
      in_1  => in_mux,
      WE    => WE,
      out_1 => out_mux,
      RST   => RST,
      CLK   => CLK
    );

  alu_reg: Nbit_reg
    generic map (N => 32)
    port map (
      in_1  => in_alu,
      WE    => WE,
      out_1 => out_alu,
      RST   => RST,
      CLK   => CLK
    );

  zero_reg: Nbit_reg
    generic map (N => 1)
    port map (
      in_1(0)  => in_zero,
      WE       => WE,
      out_1(0) => out_zero,
      RST      => RST,
      CLK      => CLK
    );

  PC_offset_reg: Nbit_reg
    generic map (N => 32)
    port map (
      in_1  => in_PC_offset,
      WE    => WE,
      out_1 => out_PC_offset,
      RST   => RST,
      CLK   => CLK
    );

  instruct_reg: Nbit_reg
    generic map (N => 32)
    port map (
      in_1  => instruct_in, 
      WE    => WE,
      out_1 => out_instruct,
      RST   => RST,
      CLK   => CLK
    );

end structural;
