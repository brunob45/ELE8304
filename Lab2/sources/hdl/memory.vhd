library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mini_riscv.all;

entity rv_pipeline_memory is
  port (
    in_clk : in FLAG;
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
  signal dmem_addr, rd_addr : ADDRESS;
  signal alu_result : WORD;

begin
  -- Memory is addressable by word, so we divide the address by 4 (right shift x2)
  out_dmem_addr <= "00" & alu_result(ADDR_WIDTH-1 downto 2) ;
  out_dmem_we <= in_storeword;
  out_dmem_write <= in_store_data;

-- ME/WB register
  mewb : process (in_clk)
  begin 
    if (in_clk'event) and (in_clk = '1') then
      out_rd_addr <= in_rd_addr;
      out_rd_data <= in_alu_result; 
      if in_loadword = '1' then 
        alu_result <= in_dmem_read;
      end if;
    end if;
  end process mewb;
end arch;
