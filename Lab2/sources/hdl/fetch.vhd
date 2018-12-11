
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mini_riscv.all;

entity rv_pipeline_fetch is
  port (
    in_clk, in_rstn : in FLAG;
    in_transfert : in FLAG;
    in_target : in WORD;
    in_stall : in FLAG;
    in_flush: in FLAG;
    in_imem_read : in WORD;
    out_instr : out WORD;
    out_imem_addr : out ADDRESS;
    out_pc : out WORD
  );
    
end rv_pipeline_fetch;

architecture arch of rv_pipeline_fetch is
-- SIGNAUX
  constant NOPE : WORD := x"00000013";
  signal pc : WORD := (others => '0');
  signal imem_read : WORD := (others => '0');

begin
  u_pc : rv_pc port map (
    in_clk, in_rstn, 
    in_stall => in_stall, 
    in_transfert => in_transfert, 
    in_target => in_target, 
    out_pc => pc
  );
  
-- Memory is addressed as word, so we divide the address by 4 (shift right 2x)
  out_imem_addr <= pc(ADDR_WIDTH+1 downto 2);

-- ID/EX register
  fetch : process (in_clk, in_rstn)
  begin 
    if (in_rstn = '0') then
      out_instr <= ZERO_VALUE;
    elsif (in_clk'event) and (in_clk = '1') then
      if (in_flush = '1') then
        out_instr <= NOPE;
      elsif (in_stall = '0') then
        out_instr <= in_imem_read;
        out_pc <= pc;
      end if;
    end if;
  end process;
end arch;
