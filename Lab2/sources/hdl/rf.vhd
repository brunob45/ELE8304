library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mini_riscv.all;

entity rv_rf is
  generic (
    REG : natural := REG_ADDR_WIDTH;
    XLEN : natural := DATA_WIDTH
  );
  port (
    in_clk, in_rstn : in std_logic;
    in_we : in std_logic;
    in_addr_ra : in std_logic_vector(REG-1 downto 0);
    out_data_ra : out std_logic_vector(XLEN-1 downto 0);
    in_addr_rb : in std_logic_vector(REG-1 downto 0);
    out_data_rb : out std_logic_vector(XLEN-1 downto 0);
    in_addr_w : in std_logic_vector(REG-1 downto 0);
    in_data_w : in std_logic_vector(XLEN-1 downto 0)
  );
end entity rv_rf;

architecture arch of rv_rf is
-- SIGNAUX
  signal registers : REGISTER_ARRAY := ((others=> (others=>'0')));
  signal addr_w_valid, addr_ra_w_eq, addr_rb_w_eq : boolean;

begin
  addr_w_valid <= in_addr_w /= ZERO_VALUE(REG_ADDR_WIDTH-1 downto 0);
  addr_ra_w_eq <= in_addr_ra = in_addr_w;
  addr_rb_w_eq <= in_addr_rb = in_addr_w;

  REGISTERS_MEMORY: process(in_rstn, in_clk) is
  begin
    if (in_rstn = '0') then
      for I in 0 to 2**REG_ADDR_WIDTH-1 loop
        registers(I) <= ZERO_VALUE;
      end loop;
    elsif in_clk'event and in_clk = '1' then 
      out_data_ra <= registers(to_integer(unsigned(in_addr_ra)));
      out_data_rb <= registers(to_integer(unsigned(in_addr_rb)));
      
      if in_we = '1' and addr_w_valid then
        registers(to_integer(unsigned(in_addr_w))) <= in_data_w;
        if addr_ra_w_eq then
          out_data_ra <= in_data_w;
        end if;
        if addr_rb_w_eq then
          out_data_rb <= in_data_w;
        end if;
      end if;
    end if;
  end process;
end arch;