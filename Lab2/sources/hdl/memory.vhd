
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
    in_clk, in_rstn : in std_logic;
    in_store_data : in std_logic_vector(DATA_WIDTH-1 downto 0);
    in_alu_result : in std_logic_vector(DATA_WIDTH-1 downto 0);
    in_rd_addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
    in_lw, in_sw : in std_logic;
    out_rd_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
    out_rd_addr : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
    
end rv_pipeline_memory;

architecture arch of rv_pipeline_memory is
  component dmem is 
  port(
    in_clk  : in std_logic;
    in_we   : in std_logic;
    in_addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
    in_write: in std_logic_vector(DATA_WIDTH-1 downto 0);
    out_read: out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
  end component;

  signal dmem_addr, rd_addr : std_logic_vector(ADDR_WIDTH-1 downto 0);
  signal alu_result, dmem_read : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal lw : std_logic;

begin
  -- Memory is addressable by word, so we divide the address by 4 (right shift x2)
  dmem_addr(ADDR_WIDTH-3 downto 0) <= alu_result(ADDR_WIDTH-1 downto 2);
  
  u_dmem : dmem port map (
    in_clk,
    in_sw, 
    dmem_addr, 
    in_store_data,
    dmem_read
  );

-- ME/WB
  mewb : process (in_clk, in_rstn)
  begin 
    if (in_clk'event) and (in_clk = '1') then
      alu_result <= in_alu_result;
      rd_addr <= in_rd_addr;
      lw <= in_lw;
    end if;
  end process mewb;

  out_rd_data <= dmem_read when in_lw = '1' else alu_result;
  out_rd_addr <= rd_addr;

end arch;
