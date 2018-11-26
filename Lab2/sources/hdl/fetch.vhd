
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rv_pipeline_fetch is
  generic ( 
    ADDR_WIDTH : positive := 10;
    DATA_WIDTH : positive := 32
  );
  port (
    in_clk, in_rstn : in std_logic;
    in_transfert : std_logic;
    in_target : in std_logic_vector(ADDR_WIDTH-1 downto 0);
    in_stall : in std_logic;
    in_flush: in std_logic;
    out_instr : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
    
end rv_pipeline_fetch;

architecture arch of rv_pipeline_fetch is
  component rv_pc is
  port (
    in_clk, in_rstn : in std_logic;
    in_stall : in std_logic;
    in_transfert : in std_logic;
    in_target : in std_logic_vector(ADDR_WIDTH-1 downto 0);
    out_pc : out std_logic_vector(ADDR_WIDTH-1 downto 0)
  );
  end component;

  component imem is
  port(
    in_addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);    
    out_read: out std_logic_vector(DATA_WIDTH-1 downto 0));
  end component;
  
  signal imem_addr : std_logic_vector(ADDR_WIDTH-1 downto 0);
  signal imem_read : std_logic_vector(DATA_WIDTH-1 downto 0);
begin
  u_pc : rv_pc port map (
    in_clk, in_rstn, in_stall => in_stall, in_transfert => in_transfert, in_target => in_target, out_pc => imem_addr);
  i_imem : imem port map (
    in_addr => imem_addr, out_read => imem_read);

  fetch : process (in_clk, in_rstn)
  begin 
    if (in_rstn ='0') then
      out_instr <= imem_read;
    elsif (in_clk'event) and (in_clk = '1') then
      if (in_stall = '0') then
        out_instr <= imem_read;
--      elsif (in_flush = '1') then 
        
      end if;
    end if;
      
  end process;
end arch;
