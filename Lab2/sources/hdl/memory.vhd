
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rv_pipeline_memory is
  generic ( 
    ADDR_WIDTH : positive := 10;
    DATA_WIDTH : positive := 32;
    REG_WIDTH : positive := 5
  );
  port (
    in_clk : in std_logic;
    in_store_data : in std_logic_vector(DATA_WIDTH-1 downto 0);
    in_alu_result : in std_logic_vector(DATA_WIDTH-1 downto 0);
    in_rd_addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
    in_loadword, in_storeword : in std_logic;
    out_rd_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
    out_rd_addr : out std_logic_vector(DATA_WIDTH-1 downto 0);
    in_dmem_read : in std_logic_vector(DATA_WIDTH-1 downto 0);
    out_dmem_we : out std_logic;
    out_dmem_addr : out std_logic_vector(ADDR_WIDTH-1 downto 0);
    out_dmem_write : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
    
end rv_pipeline_memory;

architecture arch of rv_pipeline_memory is
  signal dmem_addr, rd_addr : std_logic_vector(ADDR_WIDTH-1 downto 0);
  signal alu_result : std_logic_vector(DATA_WIDTH-1 downto 0);

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
