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
    
    out_rd_addr : out REG_ADDR;
    out_dmem_we : out FLAG;
    out_dmem_addr : out ADDRESS;
    out_dmem_write : out WORD;
    out_alu_result : out WORD;
    out_loadword : out FLAG
  );

end rv_pipeline_memory;

architecture arch of rv_pipeline_memory is
-- SIGNAUX
  signal dmem_addr : ADDRESS := ZERO_ADDR;
  -- signal rd_addr : REG_ADDR := "00000";

begin
-- la memoire est addressable par mots de 32 bits, alors il faut diviser l'addresse par 4
  out_dmem_addr <= "00" & in_alu_result(ADDR_WIDTH-1 downto 2);
  out_dmem_we <= in_storeword;
  out_dmem_write <= in_store_data;

-- registre ME/WB
  mewb : process (in_clk)
  begin 
    if (in_clk'event) and (in_clk = '1') then
      out_rd_addr <= in_rd_addr;
      out_alu_result <= in_alu_result; 
      out_loadword <= in_loadword;
    end if;
  end process mewb;

end arch;
