-------------------------------------------------------------------------------
-- Project    : ELE8304 : Circuits intégrés à très grande échelle 
-------------------------------------------------------------------------------
-- File       : compteur.vhd
-- Author     : Mickael Fiorentino <mickael.fiorentino@polymtl.ca>
-- Lab        : grm@polymtl
-- Created    : 2018-06-22
-- Last update: 2018-07-09
-------------------------------------------------------------------------------
-- Description: Modele comportemental du compteur BCD 
-------------------------------------------------------------------------------
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity compteur is 
	port( 
      clk     : in std_logic;
      rst_n   : in std_logic;
      en      : in std_logic;
      q       : out std_logic_vector(3 downto 0));
end compteur;

architecture beh of compteur is
  
  signal cnt : unsigned(3 downto 0);
  
begin
  
	q <= std_logic_vector(cnt); 
    
	do_bcd : process (clk, rst_n) 
	begin
		if (rst_n = '0') then 
			cnt <= (others => '0');
		elsif (rising_edge(clk)) then 
			if (en = '1') then 
				if (cnt = "1001") then 
					cnt <= (others => '0');
				else 
					cnt <= cnt + "0001";
				end if;
			end if;
		end if;
	end process do_bcd;
    
end beh;
