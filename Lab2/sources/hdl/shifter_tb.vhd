library ieee; 
use ieee.std_logic_1164.all;

library std;
use std.textio.all;                                                      
use std.env.all;

library work;
use work.all;

entity shifter_tb is 
end shifter_tb;

architecture tb of shifter_tb is

  component rv_shifter is
    generic( N : positive := 4 );
    port(
    in_data      : in  std_logic_vector(2**N-1 downto 0);
    in_shamt     : in  std_logic_vector(N-1 downto 0);
    in_arith     : in  std_logic;
    in_direction : in  std_logic;
    out_data     : out std_logic_vector(2**N-1 downto 0));
  end component rv_shifter;

  signal in_data : std_logic_vector(2**N-1 downto 0) := (others => '0');
  signal in_shamt : std_logic_vector(N-1 downto 0) := (others => '0');
  signal in_arith, in_direction : std_logic;
  signal out_data : std_logic_vector(2**N-1 downto 0);

begin
  -- DUT
  u_shifter : shifter
    port map ( 
      in_data => in_data,
      in_shamt => in_shamt,
      in_arith => in_arith,
      in_direction => in_direction,
      out_data => out_data);

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
