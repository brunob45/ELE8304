
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
    out_instr : out std_logic_vector(DATA_WIDTH-1 downto 0);
    out_imem_addr : out std_logic_vector(ADDR_WIDTH-1 downto 0);
    in_imem_read : in std_logic_vector(DATA_WIDTH-1 downto 0)
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
  
  signal imem_addr_byte, imem_addr_word : std_logic_vector(ADDR_WIDTH-1 downto 0);
  signal imem_read : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal zero : std_logic_vector(DATA_WIDTH-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_WIDTH));

begin
  u_pc : rv_pc port map (
    in_clk, in_rstn, 
    in_stall => in_stall, 
    in_transfert => in_transfert, 
    in_target => in_target, 
    out_pc => imem_addr_byte
  );
  
  -- Memory is addressed as word, so we divide the address by 4 (shift right 2x)
  out_imem_addr <= "00" & imem_addr_byte(ADDR_WIDTH-1 downto 2);

-- ID/EX register
  fetch : process (in_clk, in_rstn)
  begin 
    if (in_rstn = '0') then
      out_instr <= zero;
    elsif (in_clk'event) and (in_clk = '1') then
      if (in_stall = '0') then
        out_instr <= in_imem_read;
      elsif (in_flush = '1') then 
        out_instr <= zero;
      end if;
    end if;
      
  end process;
end arch;
