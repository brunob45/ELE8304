library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
    process (in_data, in_shamt, in_arith) is
    begin
        case in_direction is
            when '1' =>
out_data <= in_data srl to_integer(unsigned(in_shamt));
            when '0' => out_data <= in_data sll to_integer(unsigned(in_shamt));
            when others => out_data <= in_data;
        end case;
    end process;
end shifter_arch;

