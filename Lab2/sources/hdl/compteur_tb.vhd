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

library std;
use std.textio.all;                                                      
use std.env.all;

library work;
use work.all;

entity compteur_tb is 
end compteur_tb;

architecture tb of compteur_tb is

  component compteur is
    port( 
      clk   : in std_logic;
      rst_n : in std_logic;          
      en    : in std_logic;          
      q     : out std_logic_vector(3 downto 0));        
  end component;

  signal clk : std_logic := '1'; 
  signal rst_n, en : std_logic;
  signal q: std_logic_vector(3 downto 0);

  constant PERIOD   : time := 100 ns;
  constant TB_LOOP  : positive := 100;
  constant EXPECTED : std_logic_vector(3 downto 0) := "0010";
  
begin
  

  -- Clock
  clk <= not clk after PERIOD / 2;

  -- DUT
  u_compteur : compteur
    port map ( 
      clk   => clk,
      rst_n => rst_n,     
      en    => en,
      q     => q);

  -- Main TB process
  do_tb : process
  begin
    report "<<---- Simulation Start ---->>";

    for i in 0 to TB_LOOP-1 loop
      en    <='0';
      rst_n <='0';
      wait for 2*PERIOD;
      rst_n <= '1';
      wait for 1*PERIOD;
      en    <='1';
      wait for 12*PERIOD;
      en    <='0';

      -- Assertion
      wait for 1*PERIOD;
      assert q = EXPECTED
        report " q = " & to_hstring(q) & ", should be = " & to_hstring(EXPECTED)
        severity WARNING;
      wait for 1*PERIOD;
      
    end loop;
    
    report "<<---- Simulation End ---->>";
    stop;      
  end process do_tb;	
			
end tb;
