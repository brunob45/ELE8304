library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity rv_shifter is
  generic (N : positive := 5);
    port (
    in_data      : in  std_logic_vector(2**N-1 downto 0);
    in_shamt     : in  std_logic_vector(N-1 downto 0);
    in_arith     : in  std_logic;
    in_direction : in  std_logic;
    out_data     : out std_logic_vector(2**N-1 downto 0));
end entity rv_shifter;

architecture shifter_arch of rv_shifter is
  type TMP_VECTOR is array (2**N-1 downto 0) of std_logic_vector(2**N-1 downto 0);

  signal mid_rev, mid_sh : std_logic_vector(2**N-1 downto 0);
  signal tmp : TMP_VECTOR;
  signal shift_count : unsigned(N-1 downto 0);

begin
  shift_count <= unsigned(in_shamt);
  tmp(0) <= mid_rev;  

  REVERSE: for I in 0 to 2**N-1 generate
    mid_rev(I) <= in_data(2**N-1-I) when in_direction = '0' else in_data(I);
    out_data(I) <= mid_sh(2**N-1-I) when in_direction = '0' else mid_sh(I);
  end generate REVERSE;

  SHIFT: for I in 1 to 2**N-1 generate
    with in_arith select tmp(I) <=
      std_logic_vector(shift_right(signed(tmp(I-1)), 1)) when '1', -- signed conversion means arithmetic shift
      std_logic_vector(shift_right(unsigned(tmp(I-1)), 1)) when others; -- unsigned for logic shift
  end generate SHIFT;

  mid_sh <= std_logic_vector(tmp(to_integer(shift_count)));

end shifter_arch;
