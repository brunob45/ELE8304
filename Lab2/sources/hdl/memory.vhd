library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mini_riscv.all;

entity rv_pipeline_memory is
  port (
    in_clk, in_rstn : in FLAG;
    in_store_data : in WORD;
    in_alu_result : in WORD;
    in_rd_addr : in REG_ADDR;
    in_loadword, in_storeword : in FLAG;
    out_rd_data : out WORD;
    out_rd_addr : out REG_ADDR;
    in_dmem_read : in WORD;
    out_dmem_we : out FLAG;
    out_dmem_addr : out ADDRESS;
    out_dmem_write : out WORD
  );

end rv_pipeline_memory;

architecture arch of rv_pipeline_memory is
-- SIGNAUX
  signal alu_result : WORD := ZERO_VALUE;
  signal dmem_addr : ADDRESS := ZERO_ADDR;
  signal rd_addr : REG_ADDR := "00000";

begin
-- la memoire est addressable par mots de 32 bits, alors il faut diviser l'addresse par 4
  out_dmem_addr <= "00" & in_alu_result(ADDR_WIDTH-1 downto 2);
  out_dmem_we <= in_storeword;
  out_dmem_write <= in_store_data;

-- registre ME/WB
  mewb : process (in_clk)
  begin 
    if (in_clk'event) and (in_clk = '1') then
      rd_addr <= in_rd_addr;
      alu_result <= in_alu_result; 
    end if;
  end process mewb;

-- multiplexeur dans write-back, inutile de faire un autre module juste pour ca
  out_rd_data <= in_dmem_read when in_loadword = '1' else alu_result;
  out_rd_addr <= rd_addr;

end arch;
