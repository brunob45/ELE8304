-------------------------------------------------------------------------------
-- Project    : ELE8304 : Circuits intégrés à très grande échelle 
-------------------------------------------------------------------------------
-- File       : compteur_tb.vhd
-- Author     : Mickael Fiorentino <mickael.fiorentino@polymtl.ca>
-- Lab        : grm@polymtl
-- Created    : 2018-06-22
-- Last update: 2018-07-12
-------------------------------------------------------------------------------
-- Description: Compteur BCD 
-------------------------------------------------------------------------------
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;                                                      
use std.env.all;

library work;
use work.mini_riscv.all;
use work.mini_riscv_mem.all;

entity core_tb is 
end core_tb;

architecture tb of core_tb is
  signal rstn : FLAG := '1';
  signal clk : FLAG;
  signal imem_read : WORD;
  signal imem_addr : ADDRESS;
  signal dmem_read : WORD;
  signal dmem_we : FLAG;
  signal dmem_addr : ADDRESS;
  signal dmem_write : WORD;
  
  constant PERIOD   : time := 10 ns;
  constant TB_LOOP  : positive := 100;
  
begin
  -- Clock
   clk <= not clk after PERIOD / 2;

  -- DUT
  u_core : rv_core
  port map (
    in_rstn => rstn,
    in_clk => clk,
    in_imem_read => imem_read,
    out_imem_addr => imem_addr,
    in_dmem_read => dmem_read,
    out_dmem_we => dmem_we,
    out_dmem_addr => dmem_addr,
    out_dmem_write => dmem_write
  );
  u_dmem : dmem
  port map (
    in_clk => clk,
    in_we => dmem_we,
    in_addr => dmem_addr,
    in_write => dmem_write,
    out_read => dmem_read
  );

  u_imem : imem
  port map (
    in_addr => imem_addr,
    out_read => imem_read
  );


  -- Main TB process
  do_tb : process
  begin
    report "<<---- Simulation Start ---->>";

    wait for 20*PERIOD;
      -- Assertion
      -- wait for 1*PERIOD;
      -- assert q = EXPECTED
      --   report " q = " & to_hstring(q) & ", should be = " & to_hstring(EXPECTED)
      --   severity WARNING;
      -- wait for 1*PERIOD;
      
    
    report "<<---- Simulation End ---->>";
    stop;      
  end process do_tb;	
			
end tb;