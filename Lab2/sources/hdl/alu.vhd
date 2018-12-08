library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mini_riscv.all;

entity rv_alu is
  generic (XLEN : natural := DATA_WIDTH);
  port (
    in_arith : in std_logic;
    in_sign : in std_logic;
    in_opcode : in OPCODE;
    in_shamt : in SHAMT;
    in_src1 : in std_logic_vector(XLEN-1 downto 0);
    in_src2 : in std_logic_vector(XLEN-1 downto 0);
    out_res : out std_logic_vector(XLEN-1 downto 0)
  );
end entity rv_alu;

architecture arch of rv_alu is
-- SINGAUX
  signal out_sh, out_slt, out_and, out_xor, out_or, out_tmp : std_logic_vector(XLEN-1 downto 0);
  signal out_add : std_logic_vector(XLEN downto 0);
  signal sh_dir : std_logic;

begin
  sh_dir <= in_opcode(2);
  U0: rv_shifter port map (
    in_data => in_src1,
    in_shamt => in_shamt,
    in_arith => in_arith,
    in_direction => sh_dir,
    out_data => out_sh
  );
  U1: rv_adder port map (
    in_a => in_src1,
    in_b => in_src2,
    in_sign => in_sign,
    in_sub => in_arith,
    out_sum => out_add
  );
  out_or <= in_src1 or in_src2;
  out_and <= in_src1 and in_src2;
  out_xor <= in_src1 xor in_src2;

  out_slt(XLEN-1 downto 1) <= std_logic_vector(to_unsigned(0, XLEN-1));
  out_slt(0) <= out_add(XLEN-1) and in_sign; -- using signed numbers and sign bit is 1

  with in_opcode select out_tmp <= 
    out_add(XLEN-1 downto 0) when "000",
    out_sh when "001",
    out_slt when "010",
    out_slt when "011",
    out_xor when "100",
    out_sh when "101",
    out_or when "110",
    out_and when others;
  out_res <= out_tmp;

end arch;