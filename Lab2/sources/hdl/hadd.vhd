library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hadd is
  port (
    in_a : in std_logic;
    in_b : in std_logic;
    out_sum : out std_logic;
    out_carry : out std_logic);
end entity hadd;

architecture arch of hadd is
begin
  out_sum <= in_a xor in_b;
  out_carry <= in_a and in_b;
end arch;
