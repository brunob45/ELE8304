library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;                                                      
use std.env.all;

library work;
use work.all;

entity shifter_tb is 
end shifter_tb;

architecture tb of shifter_tb is

  constant SIZE : positive := 4;
  constant PERIOD   : time := 10 ns;

  component rv_shifter is
    generic (N : positive := SIZE);
    port (
      in_data      : in  std_logic_vector(2**N-1 downto 0);
      in_shamt     : in  std_logic_vector(N-1 downto 0);
      in_arith     : in  std_logic;
      in_direction : in  std_logic;
      out_data     : out std_logic_vector(2**N-1 downto 0));
  end component rv_shifter;

  signal in_data : std_logic_vector(2**SIZE-1 downto 0) := std_logic_vector(to_signed(-1, 2**SIZE));
  signal in_shamt : std_logic_vector(SIZE-1 downto 0) := "0001";
  signal in_arith : std_logic := '0';
  signal in_direction : std_logic := '1';
  signal out_data : std_logic_vector(2**SIZE-1 downto 0);

begin
  -- DUT
  u_shifter : rv_shifter
    port map ( 
      in_data => in_data,
      in_shamt => in_shamt,
      in_arith => in_arith,
      in_direction => in_direction,
      out_data => out_data
    );

  -- Main TB process
  do_tb : process
  begin
--    report "<<---- Simulation Start ---->>";

    in_data <= "0010110100000000";
    in_shamt <= "0001";
    in_arith <= '0';
    in_direction <= '0';
    wait for PERIOD;
    in_direction <= '1';
    wait for PERIOD;
--    report "out = " & to_hstring(out_data);
    in_data <= "0000111111110000";
    in_shamt <= "1010";
    in_arith <= '1';
    wait for PERIOD;
    in_direction <= '0';
--    report "out = " & to_hstring(out_data);    
    in_data <= "1111111111110000";
    wait for PERIOD;
--    report "out = " & to_hstring(out_data);
    
    
    report "<<---- Simulation End ---->>";
    stop;
  end process do_tb;	
			
end tb;
