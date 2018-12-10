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

entity adder_tb is 
  generic (N : positive := 16);
end adder_tb;

architecture tb of adder_tb is

  component rv_adder is
    generic (N : positive := N);
    port( 
      in_a : in std_logic_vector(N-1 downto 0);
      in_b : in std_logic_vector(N-1 downto 0);
      in_sign : in std_logic;
      in_sub : in std_logic;
      out_sum : out std_logic_vector(N downto 0)
    );
  end component;

  signal in_a : std_logic_vector(N-1 downto 0) := std_logic_vector(to_signed(-8, N));
  signal in_b : std_logic_vector(N-1 downto 0) := std_logic_vector(to_signed(-16, N));
  signal in_sign : std_logic := '1';
  signal in_sub : std_logic := '1';
  signal out_sum : std_logic_vector(N downto 0);

  constant PERIOD   : time := 10 ns;
  constant TB_LOOP  : positive := 100;
--  constant EXPECTED : std_logic_vector(3 downto 0) := "0010";
  
begin
  

  -- Clock
  -- clk <= not clk after PERIOD / 2;

  -- DUT
  u_adder : rv_adder
    port map (
      in_a => in_a,
      in_b => in_b,
      in_sign => in_sign,
      in_sub => in_sub,
      out_sum => out_sum
    );

  -- Main TB process
  do_tb : process
  begin
    report "<<---- Simulation Start ---->>";

    in_a <= std_logic_vector(to_signed(-1, N));
    in_b <= std_logic_vector(to_signed(1, N));
    in_sign <= '0';
    in_sub <= '0';
    wait for PERIOD;
    in_a <= std_logic_vector(to_signed(1, N));
    in_b <= std_logic_vector(to_signed(-1, N));
    in_sign <= '1';
    in_sub <= '0';
    wait for PERIOD;
    in_a <= std_logic_vector(to_signed(12, N));
    in_b <= std_logic_vector(to_signed(4, N));
    in_sign <= '0';
    in_sub <= '1';
    wait for PERIOD;
    in_a <= std_logic_vector(to_signed(12, N));
    in_b <= std_logic_vector(to_signed(-1, N));
    in_sign <= '1';
    in_sub <= '0';
    wait for PERIOD;

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
