library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;                                                      
use std.env.all;

library work;
use work.all;

entity alu_tb is 
end alu_tb;

architecture tb of alu_tb is

  constant SIZE : positive := 4;
  constant PERIOD   : time := 10 ns;

  component rv_alu is
    generic (XLEN : natural := 32);
    port (
      in_arith : in std_logic;
      in_sign : in std_logic;
      in_opcode : in std_logic_vector(2 downto 0);
      in_shamt : in std_logic_vector(4 downto 0);
      in_src1 : in std_logic_vector(XLEN-1 downto 0);
      in_src2 : in std_logic_vector(XLEN-1 downto 0);
      out_res : out std_logic_vector(XLEN-1 downto 0)
    );
  end component rv_alu;

  signal in_arith : std_logic := '1';
  signal in_sign : std_logic := '0';
  signal in_opcode : std_logic_vector(2 downto 0) := "000";
  signal in_shamt : std_logic_vector(4 downto 0) := "00000";
  signal in_src1 : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(123, 32));
  signal in_src2 : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(123, 32));
  signal out_res : std_logic_vector(31 downto 0);

begin
  -- DUT
  u_alu : rv_alu
    port map ( 
      in_arith => in_arith,
      in_sign => in_sign,
      in_opcode => in_opcode,
      in_shamt => in_shamt,
      in_src1 => in_src1,
      in_src2 => in_src2,
      out_res => out_res
    );

  -- Main TB process
  do_tb : process
  begin
    report "<<---- Simulation Start ---->>";
-- addition
    in_src1 <= std_logic_vector(to_unsigned(123, 32));
    in_src2 <= std_logic_vector(to_unsigned(123, 32));
    in_arith <= '0';
    wait for PERIOD;
-- substract
    in_src1 <= std_logic_vector(to_unsigned(123, 32));
    in_src2 <= std_logic_vector(to_unsigned(123, 32));
    in_arith <= '1';
    wait for PERIOD;
-- shift left x2
    in_src1 <= std_logic_vector(to_unsigned(123, 32));
    in_opcode <= "001";
    in_arith <= '0';
    in_shamt <= "00010";
    wait for PERIOD;
-- shift right x3
    in_src1 <= std_logic_vector(to_unsigned(123, 32));
    in_opcode <= "101";
    in_arith <= '1';
    in_shamt <= "00011";
    wait for PERIOD;
    
    
    report "<<---- Simulation End ---->>";
    stop;
  end process do_tb;	
			
end tb;