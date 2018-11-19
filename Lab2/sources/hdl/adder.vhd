library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
  generic ( N : positive := 32 );
  port (
    in_a : in std_logic_vector(N-1 downto 0);
    in_b : in std_logic_vector(N-1 downto 0);
    in_sign : in std_logic;
    in_sub : in std_logic;
    out_sum : out std_logic_vector(N downto 0));
end adder;

architecture arch of adder is
  component hadd is
    port( 
      in_a : in std_logic;
      in_b : in std_logic;
      out_sum : out std_logic;
      out_carry : out std_logic);
  end component;

  signal signed_a, signed_b, mid_b : std_logic_vector(N downto 0);
  signal carry1, carry2 : std_logic_vector(N-1 downto 1);
  signal sum, carry3 : std_logic_vector(N downto 1);

begin
  signed_a <= in_a(N-1) & in_a when (in_sign = '1') else '0' & in_a;
  signed_b <= in_b(N-1) & in_b when (in_sign = '1') else '0' & in_b;

  mid_b <= signed_b when (in_sub = '0') else std_logic_vector(unsigned(not signed_b) + 1);
  
  GEN_ADD: for I in 1 to N-1 generate

    FIRST_BIT: if I=0 generate
      U0: hadd port map (signed_a(I), mid_b(I), out_sum(I), carry3(I+1));
    end generate FIRST_BIT;

    OTHER_BITS: if I>0 generate
      U1: hadd port map (signed_a(I), mid_b(I), sum(I), carry1(I));
      U2: hadd port map (carry3(I), sum(I), out_sum(I), carry2(I));
      carry3(I+1) <= carry1(I) or carry2(I);
    end generate OTHER_BITS;

  end generate GEN_ADD;

  out_sum(N) <= carry3(N);

end arch;


HA1 : entity work.halfadder port map(
   a => a,
   b => b,
   sum => s1,
   carry => c1
   );
--second half adder instantiation.
HA2 : entity work.halfadder port map(
  a => s1,
  b => cin,
  sum => sum,
  carry => c2
  );