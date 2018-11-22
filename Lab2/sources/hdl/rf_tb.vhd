
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

entity rf_tb is 
  generic (
    REG : positive := 5;
    XLEN : natural := 32);
end rf_tb;

architecture tb of rf_tb is

  component rv_rf is
    generic ( 
      REG : natural := REG;
      XLEN : natural := XLEN
    );
    port (
      in_clk, in_rstn : in std_logic;
      in_we : in std_logic;
      in_addr_ra : in std_logic_vector(REG-1 downto 0);
      out_data_ra : out std_logic_vector(XLEN-1 downto 0);
      in_addr_rb : in std_logic_vector(REG-1 downto 0);
      out_data_rb : out std_logic_vector(XLEN-1 downto 0);
      in_addr_w : in std_logic_vector(REG-1 downto 0);
      in_data_w : in std_logic_vector(XLEN-1 downto 0)
    );
  end component;

  signal in_clk, in_rstn : std_logic := '0';
  signal  in_we : std_logic := '0';
  signal  in_addr_ra : std_logic_vector(REG-1 downto 0) := std_logic_vector(to_unsigned(0,REG));
  signal  out_data_ra : std_logic_vector(XLEN-1 downto 0); -- := std_logic_vector(to_unsigned(16,XLEN));
  signal  in_addr_rb : std_logic_vector(REG-1 downto 0) := std_logic_vector(to_unsigned(0,REG));
  signal  out_data_rb : std_logic_vector(XLEN-1 downto 0); -- := std_logic_vector(to_unsigned(0,XLEN));;
  signal  in_addr_w : std_logic_vector(REG-1 downto 0) := std_logic_vector(to_unsigned(0,REG));
  signal  in_data_w : std_logic_vector(XLEN-1 downto 0) := std_logic_vector(to_unsigned(0,XLEN));

  constant PERIOD   : time := 10 ns;
  constant TB_LOOP  : positive := 100;
--  constant EXPECTED : std_logic_vector(3 downto 0) := "0010";
  
begin
  

  -- Clock
  in_clk <= not in_clk after PERIOD / 2;

  -- DUT
  u_rf : rv_rf
    port map (
      in_clk, in_rstn,
      in_we,
      in_addr_ra,
      out_data_ra,
      in_addr_rb,
      out_data_rb,
      in_addr_w,
      in_data_w
    );

  -- Main TB process
  do_tb : process
  begin
    report "<<---- Simulation Start ---->>";
    wait for PERIOD;
    in_rstn <= '1';

    -- write 16 in 01;
    in_we <= '1';
    in_addr_w <= "00001";
    in_data_w <= std_logic_vector(to_unsigned(16,XLEN));
    wait for PERIOD;

    -- read address 01
    in_addr_w <= "00010";
    in_addr_ra <= "00001";
    in_we <= '0';
    wait for PERIOD;

    -- check write read at same address
    in_addr_ra <= "00010";
    in_addr_w <= "00010";
    in_data_w <=  std_logic_vector(to_unsigned(17,XLEN));
    in_we <= '1';
    wait for PERIOD;

    -- test write at 00
    in_addr_w <= "00000";
    in_we <= '1';
    wait for PERIOD;

    -- test read at 00
    in_addr_w <= "00010";
    in_addr_ra <= "00000";
    in_we <= '0';
    wait for PERIOD;

    -- test reset
    in_rstn <= '0';
    wait for PERIOD/2;
    in_rstn <= '1';
    wait for PERIOD/2;

    -- test read after reset
    in_addr_ra <= "00001";
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