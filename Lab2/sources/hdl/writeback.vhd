library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rv_pipeline_writeback is
  generic ( 
    DATA_WIDTH : positive := 32
  );
  port (
    in_rd_addr : in std_logic_vector(DATA_WIDTH-1 downto 0);
    in_alu_result : in std_logic_vector(DATA_WIDTH-1 downto 0);
    in_dmem_read : in std_logic_vector(DATA_WIDTH-1 downto 0);
    in_lw : in std_logic;

    out_rd_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
    out_rd_addr : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );

end rv_pipeline_writeback;

architecture arch of rv_pipeline_writeback is

  signal rd_data : std_logic_vector(DATA_WIDTH-1 downto 0);

begin

  rd_data <= in_dmem_read when in_lw = '1' else in_alu_result;
  
  out_rd_data <= rd_data;
  out_rd_addr < in_rd_addr;

end arch;
