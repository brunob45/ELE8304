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
    out_rd_addr : out REG_ADDR
  );

end rv_pipeline_memory;

architecture arch of rv_pipeline_memory is
-- COMPONENT
  component dmem is
    generic(
      ADDR_WIDTH : positive := 10;
      DATA_WIDTH : positive := 32
  );
    port(
      in_clk  : in std_logic;
      in_we   : in std_logic;
      in_addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
      in_write: in std_logic_vector(DATA_WIDTH-1 downto 0);
      out_read: out std_logic_vector(DATA_WIDTH-1 downto 0));
  end component;

-- SIGNAUX
  signal dmem_read, alu_result : WORD;
  signal dmem_addr : ADDRESS;
  signal rd_addr : REG_ADDR;

begin
-- la memoire est addressable par mots de 32 bits, alors il faut diviser l'addresse par 4
  dmem_addr <= "00" & in_alu_result(ADDR_WIDTH-1 downto 2);

  u_dmem : dmem port map (
    in_clk => in_clk,
    in_we => in_storeword,
    in_addr => dmem_addr,
    in_write => in_store_data,
    out_read => dmem_read
  );

-- registre ME/WB
  mewb : process (in_clk)
  begin 
    if (in_clk'event) and (in_clk = '1') then
      rd_addr <= in_rd_addr;
      alu_result <= in_alu_result; 
    end if;
  end process mewb;

-- multiplexeur dans write-back, inutile de faire un autre module juste pour ca
  out_rd_data <= dmem_read when in_loadword = '1' else alu_result;
  out_rd_addr <= rd_addr;

end arch;
