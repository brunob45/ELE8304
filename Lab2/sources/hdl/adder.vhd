library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mini_riscv.all;

entity rv_adder is
  generic ( N : positive := DATA_WIDTH );
  port (
    in_a : in std_logic_vector(N-1 downto 0);
    in_b : in std_logic_vector(N-1 downto 0);
    in_sign : in std_logic;
    in_sub : in std_logic;
    out_sum : out std_logic_vector(N downto 0));
end rv_adder;

architecture arch of rv_adder is
  component rv_hadd is
    port( 
      in_a : in std_logic;
      in_b : in std_logic;
      out_sum : out std_logic;
      out_carry : out std_logic);
  end component;

  signal signed_a, signed_b, mid_b : std_logic_vector(N downto 0);
  signal carry1, carry2 : std_logic_vector(N downto 0);
  signal sum, carry3 : std_logic_vector(N downto 0);

begin
  signed_a <= in_a(N-1) & in_a when (in_sign = '1') else '0' & in_a;
  mid_b <= in_b(N-1) & in_b when (in_sign = '1') else '0' & in_b;

  signed_b <= not mid_b when in_sub = '1' else mid_b; -- mid_b when (in_sub = '0') else std_logic_vector(unsigned(not mid_b) + 1);

  carry3(0) <= in_sub;

  GEN_ADD: for I in 0 to N generate
      U0: rv_hadd port map (signed_a(I), signed_b(I), sum(I), carry1(I));
      U1: rv_hadd port map (carry3(I), sum(I), out_sum(I), carry2(I));
      CARRY_XOR: if I < N generate
        carry3(I+1) <= carry1(I) or carry2(I);
      end generate CARRY_XOR;
  end generate GEN_ADD;

end arch;