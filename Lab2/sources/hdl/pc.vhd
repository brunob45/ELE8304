library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rv_pc is
  generic ( RESET_VECTOR : natural := 16#00000000# );
  port (
    in_clk, in_rstn : in std_logic;
    in_stall : in std_logic;
    in_transfert : in std_logic;
    in_target : in std_logic_vector(XLEN-1 downto 0);
    out_pc : out std_logic_vector(XLEN-1 downto 0)
  );
end entity rv_pc;

architecture arch of rv_pc is
  signal out_add, out_mux : std_logic_vector(XLEN-1 downto 0);
begin
  out_add <= std_logic_vector(unsigned(out_pc)+4);
  out_mux <= in_target when in_transfert = '1' else out_add;
  
  PC_MEMORY: process (in_clk, in_rstn) is
  begin
    if (in_rstn = '0') then
      out_pc <= std_logic_vector(to_unsigned(RESET_VECTOR, XLEN));
    elseif (in_stall = '0') and (in_clk'event) and (in_clk='1') then
      out_pc <= out_mux;
    end if;
  end process;

end arch;