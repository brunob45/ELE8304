
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
    out_pc : out std_logic_vector(ADDR_WIDTH downto 0);

    out_jump, out_branch : out std_logic;
    out_loadword, out_storeword : out std_logic;

    out_alu_arith : out std_logic;
    out_alu_sign : out std_logic;
    out_alu_opcode : out std_logic_vector(2 downto 0);
    out_alu_shamt : out std_logic_vector(4 downto 0);
    out_alu_use_src2 : out std_logic
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

  signal opcode : std_logic_vector(6 downto 0);
  signal funct3 : std_logic_vector(2 downto 0);
  signal rs1_addr, rs2_addr : std_logic_vector(4 downto 0);
  signal u_imm, j_imm, i_imm, s_imm, b_imm : std_logic_vector(DATA_WIDTH-1 downto 0) := x"00000000";

begin
  rs1_addr <= in_instr(19 downto 15);
  rs2_addr <= in_instr(24 downto 20);

  u_rf : rv_rf port map (
    in_clk, in_rstn,
    in_we => in_we, 
    in_addr_ra => rs1_addr, 
    out_data_ra => out_rs1_data,
    in_addr_rb => rs2_addr, 
    out_data_rb => out_rs1_data,
    in_addr_w => in_rd_addr,
    in_data_w => in_rd_data
  );

-- predecode
  opcode <= in_instr(6 downto 0);
  funct3 <= in_instr(14 downto 12);

-- decode
  i_imm(10 downto 0) <= in_instr(30 downto 20);
  
  s_imm(10 downto 0) <= in_instr(30 downto 25) & in_instr(11 downto 7);
  
  b_imm(11 downto 0) <= in_instr(7) & in_instr(30 downto 25) & in_instr(11 downto 8) & '0';

  u_imm(31 downto 0) <= in_instr(31 downto 12) & x"000";

  j_imm (19 downto 0) <= in_instr(19 downto 12) & in_instr(20) & in_instr(30 downto 21) & '0';

  gen_imm : for I in 11 to 31 generate
    i_imm(I) <= in_instr(31);
    s_imm(I) <= in_instr(31);
    gen_b: if I >= 12 generate
      b_imm(I) <= in_instr(31);
    end generate gen_b;
    gen_j: if I >= 20 generate
      j_imm(I) <= in_instr(31);
    end generate gen_j;
  end generate gen_imm;

-- ID/EX register
  idex : process (in_clk, in_rstn)
  begin 
    if (in_clk'event) and (in_clk = '1') then
      case opcode is
        when "0110111" => out_imm <= u_imm; -- LUI
        when "1101111" => out_imm <= j_imm; -- JAL
        when "1100011" => out_imm <= b_imm; -- JALR
        when "0100011" => out_imm <= s_imm; -- BEQ
        when others => out_imm <= i_imm;    -- autres
      end case;
       
      -- out_pc <= ?
      out_jump <= (opcode(6) and opcode(2));
      out_branch <= (opcode(6) and not opcode(2));
      if opcode = "0000011" then
        out_loadword <= '1';
      else
         out_loadword <= '0';
      end if;

      if opcode = "0100011" then
        out_storeword <= '1';
      else
         out_storeword <= '0';
      end if;

    -- use signed values unless SLT(I)U
      if funct3 = "011" then
        out_storeword <= '0';
      else
         out_storeword <= '1';
      end if;

      out_alu_arith <= i_imm(10);
      out_alu_opcode <= funct3;
      out_alu_shamt <= i_imm(4 downto 0);
      out_alu_use_src2 <= (opcode(5) and (not opcode(2)));
    end if;
  end process idex;

end arch;
