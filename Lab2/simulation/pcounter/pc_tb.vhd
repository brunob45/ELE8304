
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
use work.all;

entity pc_tb is 
  generic ( XLEN : natural := 32 );
end pc_tb;

architecture tb of pc_tb is

  component rv_pc is
  generic ( 
    RESET_VECTOR : natural := 16#00000000#;
    XLEN : natural := XLEN
  );
  port (
    in_clk, in_rstn : in std_logic;
    in_stall : in std_logic;
    in_transfert : in std_logic;
    in_target : in std_logic_vector(XLEN-1 downto 0);
    out_pc : out std_logic_vector(XLEN-1 downto 0)
  );
  end component;

  signal in_clk, in_rstn : std_logic := '0';
  signal  in_stall, in_transfert : std_logic := '0';
  signal  in_target : std_logic_vector(XLEN-1 downto 0) := std_logic_vector(to_unsigned(100,XLEN));
  signal  out_pc : std_logic_vector(XLEN-1 downto 0);

  constant PERIOD   : time := 10 ns;
  constant TB_LOOP  : positive := 100;
--  constant EXPECTED : std_logic_vector(3 downto 0) := "0010";
  
begin
  

  -- Clock
  in_clk <= not in_clk after PERIOD / 2;

  -- DUT
  u_pc : rv_pc
    port map (
      in_clk, in_rstn,
      in_stall,
      in_transfert, 
      in_target,
      out_pc
    );

  -- Main TB process
  do_tb : process
  begin
    report "<<---- Simulation Start ---->>";
    wait for PERIOD;
    in_rstn <= '1';
    wait for PERIOD*3;
    in_transfert <= '1';
    wait for PERIOD;
    in_transfert <= '0';
    wait for PERIOD*3;
    in_stall <= '1';
    wait for PERIOD*2;
  
    report "<<---- Simulation End ---->>";
    stop;      
  end process do_tb;	
			
end tb;
