library ieee;
use ieee.std_logic_1164.all;

entity rv_shifter is
generic( N : positive := 4 );
port(
in_data      : in  std_logic_vector(2**N-1 downto 0);
in_shamt     : in  std_logic_vector(N-1 downto 0);
in_arith     : in  std_logic;
in_direction : in  std_logic;
out_data     : out std_logic_vector(2**N-1 downto 0));
end entity rv_shifter;

architecture shifter_arch of rv_shifter is
begin
    case in_direction is
        when '1' => out_data <= in_data srl in_shamt;
        when '0' => out_data <= in_data sll in_shamt;

end shifter_arch;
