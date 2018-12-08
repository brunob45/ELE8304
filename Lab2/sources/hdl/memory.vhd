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
    in_sw, in_lw : in std_logic;
    out_rd_addr : out std_logic_vector(DATA_WIDTH-1 downto 0);
    out_alu_result : out std_logic_vector(DATA_WIDTH-1 downto 0);
    out_dmem_read : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );

end rv_pipeline_memory;

architecture arch of rv_pipeline_memory is
  component dmem is
    generic (
      ADDR_WIDTH : positive := 10;
      DATA_WIDTH : positive := 32);
    port (
      in_clk  : in std_logic;
      in_we   : in std_logic;
      in_addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
      in_write: in std_logic_vector(DATA_WIDTH-1 downto 0);
      out_read: out std_logic_vector(DATA_WIDTH-1 downto 0));
  end component;

  signal dmem_addr : std_logic_vector(ADDR_WIDTH-1 downto 0);
  signal alu_result : std_logic_vector(DATA_WIDTH-1 downto 0);

begin
  -- TODO : revoir
  u_dmem : dmem port map (
    in_clk => in_clk,
    in_we => in_sw,
    in_addr => in_rd_addr,
    in_write => dmem_addr,
    out_read => out_dmem_read
  );

  if (in_sw = '1') or (in_lw = '1') then
    dmem_addr <= in_alu_result;
  end if;
  -- TODO : revoir, maybe inutile
  -- Memory is addressable by word, so we divide the address by 4 (right shift x2)
  -- out_dmem_addr <= "00" & alu_result(ADDR_WIDTH-1 downto 2) ;
  -- out_dmem_we <= in_sw;
  -- out_dmem_read <= in_store_data;

-- ME/WB register
  mewb : process (in_clk)
  begin 
    if (in_clk'event) and (in_clk = '1') then
      out_rd_addr <= in_rd_addr;
      out_alu_result <= in_alu_result; 
    end if;
  end process mewb;
end arch;
