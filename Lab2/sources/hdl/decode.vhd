library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mini_riscv.all;


entity rv_pipeline_decode is
  port (
    in_clk, in_rstn : in FLAG;
    in_instr : in WORD;
    in_rd_we : in FLAG;
    in_flush: in FLAG;
    in_rd_data : in WORD;
    in_rd_addr : in REG_ADDR;
    in_pc : in WORD;

    out_rs1_data, out_rs2_data, out_imm : out WORD;
    out_pc : out WORD;

    out_jump, out_branch : out FLAG;
    out_loadword, out_storeword : out FLAG;

    out_alu_arith : out FLAG;
    out_alu_sign : out FLAG;
    out_alu_opcode : out OPCODE;
    out_alu_shamt : out SHAMT;
    out_alu_use_src2 : out FLAG;
    out_rd_addr : out REG_ADDR;
    out_rd_we : out FLAG
  );
    
end rv_pipeline_decode;

architecture arch of rv_pipeline_decode is
-- SIGNAUX
  signal local_opcode : std_logic_vector(6 downto 0);
  signal funct3 : OPCODE;
  signal rs1_addr, rs2_addr : REG_ADDR := (others=>'0');
  signal u_imm, j_imm, i_imm, s_imm, b_imm, rs1_data : WORD := ZERO_VALUE;

begin
  rs1_addr <= in_instr(19 downto 15);
  rs2_addr <= in_instr(24 downto 20);

  u_rf : rv_rf port map (
    in_clk, in_rstn,
    in_we => in_rd_we,
    in_addr_ra => rs1_addr,
    out_data_ra => rs1_data,
    in_addr_rb => rs2_addr,
    out_data_rb => out_rs2_data,
    in_addr_w => in_rd_addr,
    in_data_w => in_rd_data
  );
  out_rs1_data <= rs1_data;

-- predecode
  local_opcode <= in_instr(6 downto 0);
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
    if (in_flush = '1') or (in_rstn = '0') then
      out_imm <= ZERO_VALUE;
      out_jump <= '0';
      out_branch <= '0';
      out_loadword <= '0';
      out_storeword <= '0';
      out_alu_arith <= '0';
      out_alu_sign <= '0';
      out_alu_use_src2 <= '0';
      out_alu_opcode <= (others => '0');
      out_alu_shamt <= (others => '0');
      out_rd_addr <= (others => '0');
      
    elsif (in_clk'event) and (in_clk = '1') then
      case local_opcode is
	when "0110111" => out_imm <= u_imm;
	when "1101111" => out_imm <= j_imm;
	when "1100011" => out_imm <= b_imm;
	when "0100011" => out_imm <= s_imm;
	when others => out_imm <= i_imm;
      end case;
      if local_opcode = "1100111" then -- JALR when in_lw = '1'
	out_pc <= rs1_data;
      else
	out_pc <= in_pc;
      end if;
      out_jump <= (local_opcode(6) and local_opcode(2));
      out_branch <= (local_opcode(6) and not local_opcode(2));
      if local_opcode = "0000011" then
	out_loadword <= '1';
      else
	out_loadword <= '0';
      end if;

      if local_opcode = "0100011" then
	out_storeword <= '1';
      else
	out_storeword <= '0';
      end if;

      -- use signed values unless SLT(I)U
      if funct3 = "011" then
	out_alu_sign <= '0';
      else
	out_alu_sign <= '1';
      end if;
      
      out_alu_arith <= i_imm(10);
      out_alu_opcode <= funct3;
      out_alu_shamt <= i_imm(4 downto 0);
      out_alu_use_src2 <= (local_opcode(5) and (not local_opcode(2)));
      out_rd_addr <= in_instr(11 downto 7);
      if (local_opcode = "1100011") or (local_opcode = "0100011") then 
        out_rd_we <= '0';
      else 
        out_rd_we <= '1';
      end if;
    end if;
  end process idex;

end arch;
