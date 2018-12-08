library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mini_riscv_mem is
component dmem is
  generic(
    ADDR_WIDTH : positive := 10;
    DATA_WIDTH : positive := 32);
  port(
    in_clk  : in std_logic;
    in_we   : in std_logic;
    in_addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
    in_write: in std_logic_vector(DATA_WIDTH-1 downto 0);
    out_read: out std_logic_vector(DATA_WIDTH-1 downto 0));
  end component;

  component imem is
  generic(        
    INIT_FILE  : string   := "../asm/init.hex";
    ADDR_WIDTH : positive := 10;
    DATA_WIDTH : positive := 32);
  port(
    in_addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);    
    out_read: out std_logic_vector(DATA_WIDTH-1 downto 0));
  end component;
end package;
