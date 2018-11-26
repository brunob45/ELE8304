
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rv_pipeline_decode is
  generic ( 
    ADDR_WIDTH : positive := 10;
    DATA_WIDTH : positive := 32;
    REG_WIDTH : positive := 5
  );
  port (
    in_clk, in_rstn : in std_logic;
    in_instr : in std_logic_vector(DATA_WIDTH-1 downto 0);
    in_we : in std_logic;
    in_flush: in std_logic;
    in_rd_data : in std_logic_vector(DATA_WIDTH-1 downto 0);
    in_rd_addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
    out_rs1_data, out_rs2_data, out_imm : out std_logic_vector(DATA_WIDTH-1 downto 0);
    out_jump, out_branch : out std_logic;
    out_pc : out std_logic_vector(ADDR_WIDTH downto 0)
  );
    
end rv_pipeline_decode;

architecture arch of rv_pipeline_decode is
  component rv_rf is
  generic (
    REG : natural := REG_WIDTH;
    XLEN : natural := DATA_WIDTH
  );
  port (
    in_clk, in_rstn : in std_logic;
    in_we : in std_logic;
    in_addr_ra : in std_logic_vector(REG-1 downto 0);
    out_data_ra : out std_logic_vector(XLEN-1 downto 0);
    in_addr_rb : in std_logic_vector(REG-1 downto 0);
    out_data_rb : out std_logic_vector(XLEN-1 downto 0);
    in_addr_w : in std_logic_vector(REG-1 downto 0);
    in_data_w : in std_logic_vector(XLEN-1 downto 0)
  );
  end component;

  signal rs1_addr, rs2_addr : std_logic_vector(REG_WIDTH-1 downto 0);
  signal opcode : std_logic_vector(6 downto 0);
  signal func3 : std_logic_vector(2 downto 0);
  signal u_imm, j_imm, i_imm, s_imm, b_imm, imm, rs1, rs2 : std_logic_vector(DATA_WIDTH-1 downto 0) := x"00000000";
  signal rd : std_logic_vector(4 downto 0);

begin
  u_rf : rv_rf port map (
    in_clk, in_rstn,
    in_we => in_we, 
    in_addr_ra => rs1_addr, 
    out_data_ra => rs1,
    in_addr_rb => rs2_addr, 
    out_data_rb => rs2,
    in_addr_w => in_rd_addr,
    in_data_w => in_rd_data
  );

-- predecode
  opcode <= in_instr(6 downto 0);
  func3 <= in_instr(14 downto 12);
  rs1_addr <= in_instr(19 downto 15);
  rs2_addr <= in_instr(24 downto 20);
  rd <= in_instr(11 downto 7);

-- decode
  i_imm(10 downto 0) <= in_instr(30 downto 20);
  
  s_imm(10 downto 0) <= in_instr(30 downto 25) & in_instr(11 downto 7);
  
  b_imm(11 downto 0) <= in_instr(7) & in_instr(30 downto 25) & in_instr(11 downto 8) & '0';

  u_imm(31 downto 0) <= in_instr(31 downto 12) & x"000";

  j_imm (19 downto 0) <= in_instr(19 downto 12) & in_instr(20) & in_instr(30 downto 21) & '0';

  gen_imm : for I in 11 to 31 generate
    j_imm(I) <= in_instr(31);
    i_imm(I) <= in_instr(31);
    gen_b: if I >= 12 generate
      b_imm(I) <= in_instr(31);
    end generate gen_b;
    gen_j: if I >= 20 generate
      j_imm(I) <= in_instr(31);
    end generate gen_j;
  end generate gen_imm;

  decode: process(in_instr)
  begin
    if (opcode = "0110111") then -- LUI
      imm <= u_imm;
    elsif (opcode = "1101111") then -- JAL
      imm <= j_imm;
    elsif (opcode = "1100011") then  -- BEQ
      imm <= b_imm;
    elsif (opcode = "0100011") then -- SW
      imm <= s_imm;
    else -- others
      imm <= i_imm;
    end if;
  end process decode;
   
-- ID/EX
  idex : process (in_clk, in_rstn)
  begin 
    if (in_clk'event) and (in_clk = '1') then
      out_jump <= (opcode(6) and opcode(2));
      out_branch <= (opcode(6) and not opcode(2));
      out_imm <= imm;
      out_rs1_data <= rs1;
      out_rs2_data <= rs2;
    end if;
  end process idex;

end arch;
