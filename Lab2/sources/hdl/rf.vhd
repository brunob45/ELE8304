library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity rv_rf is
  generic ( REG : natural := 5, XLEN : natural := 32);
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
  signal addr_ra_w_eq, addr_rb_w_eq : std_logic;
  signal registers is array (2**REG-1 downto 0) of std_logic_vector(XLEN-1 downto 0);
  signal mid_data_a, mid_data_b, mid_data_w : std_logic_vector(XLEN-1 downto 0);
begin
  addr_ra_w_eq <= (unsigned(in_addr_ra)=unsigned(in_addr_w));
  addr_rb_w_eq <= (unsigned(in_addr_rb)=unsigned(in_addr_w));

  mid_data_a <= registers(unsigned(in_addr_ra));
  mid_data_b <= registers(unsigned(in_addr_rb));

  REGISTERS_MEMORY: process(in_rstn, in_clk) is
  begin
    if (in_rstn = '0') then
      for I in 0 to 2**REG-1 loop
        registers(I) <= std_logic_vector(to_unsigned(0, XLEN));
      end loop;
    elseif (in_clk'event) and (in_clk='1') then
      if (in_we = '1') and (unsigned(in_addr_w) /= 0) then
        registers(unsigned(in_addr_w)) <= in_data_w;
      end if;
    end if;
  end process;

  OUTPUT: process(in_clk)
  begin
    if (in_clk'event) and (in_clk = '1') then
      mid_data_w <= in_data_w;
    end if;
  end process;

  out_data_ra <= mid_data_w when addr_ra_w_eq = '1' else mid_data_a;
  out_data_rb <= mid_data_w when addr_rb_w_eq = '1' else mid_data_b;

end arch;