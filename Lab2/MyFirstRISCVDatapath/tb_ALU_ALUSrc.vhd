library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
library std;
use std.textio.all;

entity tb_ALU_ALUSrc is
generic (
gCLK_HPER : time := 10 ns
);
end tb_ALU_ALUSrc;

architecture sim of tb_ALU_ALUSrc is

-- DUT component
component ALU_ALUSrc is
port (
A_i      : in  std_logic_vector(31 downto 0);
B_i      : in  std_logic_vector(31 downto 0);
Imm      : in  std_logic_vector(31 downto 0);
ALUSrc   : in  std_logic;
nAdd_Sub : in  std_logic;
C_out    : out std_logic;
S_i      : out std_logic_vector(31 downto 0)
);
end component;

-- signals
signal sA_i      : std_logic_vector(31 downto 0) := (others => '0');
signal sB_i      : std_logic_vector(31 downto 0) := (others => '0');
signal sImm      : std_logic_vector(31 downto 0) := (others => '0');
signal sALUSrc   : std_logic := '0';
signal snAdd_Sub : std_logic := '0';
signal sC_out    : std_logic;
signal sS_i      : std_logic_vector(31 downto 0);

begin

-- DUT instance
DUT0: ALU_ALUSrc
port map (
A_i      => sA_i,
B_i      => sB_i,
Imm      => sImm,
ALUSrc   => sALUSrc,
nAdd_Sub => snAdd_Sub,
C_out    => sC_out,
S_i      => sS_i
);

-- Stimulus
stim_proc: process
begin
wait for gCLK_HPER;


-- Test 1: A + B
sA_i <= x"00000005";
sB_i <= x"00000003";
sALUSrc <= '0';  -- use B_i
snAdd_Sub <= '0'; -- add 
wait for gCLK_HPER*2;

-- Test 2: A - B
snAdd_Sub <= '1'; -- subtract
wait for gCLK_HPER*2;

-- Test 3: A + Imm
sImm <= x"0000000A";
sALUSrc <= '1';  -- use Imm
snAdd_Sub <= '0'; -- add
wait for gCLK_HPER*2;

-- Test 4: A - Imm
snAdd_Sub <= '1'; -- subtract
wait for gCLK_HPER*2;

-- Test 5: Overflow case
sA_i <= x"FFFFFFFF";
sImm <= x"00000001";
sALUSrc <= '1'; -- use Imm
snAdd_Sub <= '0'; -- add
wait for gCLK_HPER*2;

wait;


end process;

end sim;