library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mini_riscv.all;

entity rv_pc is
  generic ( 
    RESET_VECTOR : natural := 16#00000000#;
    XLEN : natural := DATA_WIDTH
  );
  port (
    in_clk, in_rstn : in std_logic;
    in_stall : in std_logic;
    in_transfert : in std_logic;
    in_target : in std_logic_vector(XLEN-1 downto 0);
    out_pc : out std_logic_vector(XLEN-1 downto 0)
  );
end entity rv_pc;

architecture arch of rv_pc is
-- SIGNAUX
  signal out_add, out_mux : std_logic_vector(XLEN-1 downto 0);
  signal reset : std_logic_vector(XLEN-1 downto 0) := std_logic_vector(to_unsigned(RESET_VECTOR, XLEN));
  signal pc : std_logic_vector(XLEN-1 downto 0) := std_logic_vector(to_unsigned(RESET_VECTOR, XLEN));
begin
  out_add <= std_logic_vector(unsigned(pc)+4);
  out_mux <= in_target when in_transfert = '1' else out_add;
  
  PC_MEMORY: process (in_clk, in_rstn) is
  begin
    if (in_rstn = '0') then
      pc <= reset;
    elsif (in_stall = '0') and (in_clk'event) and (in_clk = '1') then
      pc <= out_mux;
    end if;
  end process;

  out_pc <= pc;
end arch;