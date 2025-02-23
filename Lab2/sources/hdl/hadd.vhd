library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mini_riscv.all;

entity rv_hadd is
  port (
    in_a : in std_logic;
    in_b : in std_logic;
    out_sum : out std_logic;
    out_carry : out std_logic);
end entity rv_hadd;

architecture arch of rv_hadd is
begin
  out_sum <= in_a xor in_b;
  out_carry <= in_a and in_b;
end arch;