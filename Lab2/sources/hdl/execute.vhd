
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mini_riscv.all;

entity rv_pipeline_execute is
  port (
    in_clk, in_rstn : in FLAG;
    in_jump, in_branch: in FLAG;
    in_rs1_data, in_rs2_data, in_imm : in WORD;
    in_pc : in ADDRESS;
    in_loadword, in_storeword : in FLAG;
    out_loadword, out_storeword : out FLAG;

    in_alu_arith : in FLAG;
    in_alu_sign : in FLAG;
    in_alu_opcode : in OPCODE;
    in_alu_shamt : in SHAMT;
    in_alu_use_src2 : in FLAG;

    out_pc_transfer : out FLAG;
    out_pc_target : out ADDRESS;
    out_alu_result : out WORD;
    out_store_data : out WORD;
    out_flush : out FLAG;

    in_rd_addr : in REG_ADDR;
    out_rd_addr : out REG_ADDR
  );
    
end rv_pipeline_execute;

architecture arch of rv_pipeline_execute is
-- SIGNAUX
  signal alu_src2, alu_out : WORD;
  signal pc_target : ADDRESS;
  signal pc_transfer : FLAG;

begin
  -- selection d'entree ALU
  alu_src2 <= in_rs2_data when in_alu_use_src2 = '1' else in_imm;

  -- port map
  u_alu : rv_alu port map (
    in_arith => in_alu_arith,
    in_sign => in_alu_sign,
    in_opcode => in_alu_opcode,
    in_shamt => in_alu_shamt,
    in_src1 => in_rs1_data,
    in_src2 => alu_src2,
    out_res => alu_out
  );

  u_adder : rv_adder port map (
    in_a => in_imm,
    in_b => in_pc,
    in_sign => '0',
    in_sub => '0',
    out_sum => pc_target
  );

  -- branchements
--  if in_branch = '1' then
    -- TODO
--  end if;
  pc_transfer <= in_branch;

-- EX/ME register
  exme : process(in_clk)
  begin
    if in_clk'event and in_clk = '1' then
      -- passthrough
      out_loadword <= in_loadword;
      out_storeword <= in_loadword;
      out_store_data <= in_rs2_data;

      out_alu_result <= alu_out;
      out_pc_target <= pc_target;
      out_pc_transfer <= pc_transfer;
      out_rd_addr <= in_rd_addr;
    end if;
  end process;

end arch;
