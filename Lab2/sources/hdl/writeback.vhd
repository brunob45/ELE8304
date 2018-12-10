library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mini_riscv.all;

entity rv_pipeline_writeback is
  port (
    in_rd_addr : in REG_ADDR;
    in_alu_result : in WORD;
    in_dmem_read : in WORD;
    in_loadword : in FLAG;
    in_rd_we : in FLAG;

    out_rd_data : out WORD;
    out_rd_addr : out REG_ADDR;
    out_rd_we : out FLAG
  );

end rv_pipeline_writeback;

architecture arch of rv_pipeline_writeback is
begin
  out_rd_data <= in_dmem_read when in_loadword = '1' else in_alu_result;
  out_rd_addr <= in_rd_addr;
  out_rd_we <= in_rd_we;
end arch;
