library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rv_pipeline_writeback is
  port (
    in_rd_addr : in REG_ADDR;
    in_alu_result : in WORD;
    in_dmem_read : in WORD;
    in_lw : in FLAG;

    out_rd_data : out WORD;
    out_rd_addr : out REG_ADDR
  );

end rv_pipeline_writeback;

architecture arch of rv_pipeline_writeback is

  signal rd_data : WORD;

begin
  
  out_rd_data <= in_dmem_read when in_lw = '1' else in_alu_result;;
  out_rd_addr < in_rd_addr;

end arch;
