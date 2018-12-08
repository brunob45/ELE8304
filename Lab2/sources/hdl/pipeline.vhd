library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mini_riscv.all;

entity rv_core is
  port (
    in_rstn, in_clk : in FLAG;
    in_imem_read : in WORD;
    out_imem_addr : out ADDRESS;
    in_dmem_read : in WORD;
    out_dmem_we : out FLAG;
    out_dmem_addr : out ADDRESS;
    out_dmem_write : out WORD
  );
end rv_core;

architecture arch of rv_core is
  -- signaux
  signal ex_if_transfer, ex_if_stall, ex_if_id_flush : FLAG;
  signal ex_if_target : ADDRESS;
  signal if_id_instr : WORD;
  signal wb_id_we, id_ex_jump, id_ex_branch, id_ex_use_src2 : FLAG;
  signal wb_id_addr : REG_ADDR;
  signal id_ex_pc : ADDRESS;
  signal wb_id_data, id_ex_rs1, id_ex_rs2, id_ex_imm: WORD;
  signal id_ex_opcode : OPCODE;
  signal ex_me_alu_result, ex_me_store_data : WORD;
  signal if_id_pc, de_ex_pc : ADDRESS;
  signal id_ex_loadword, id_ex_storeword : FLAG;
  signal ex_me_loadword, ex_me_storeword : FLAG;
  signal id_ex_rd_addr, ex_me_rd_addr : REG_ADDR;

begin
-- port map
  u_fetch : rv_pipeline_fetch
  port map (
    in_clk, in_rstn,
    in_transfert => ex_if_transfer,
    in_target => ex_if_target,
    in_stall => ex_if_stall,
    in_flush => ex_if_id_flush,
    out_instr => if_id_instr,
    out_pc => if_id_pc
  );

  u_decode : rv_pipeline_decode
  port map (
    in_clk, in_rstn,
    in_instr => if_id_instr,
    in_we => wb_id_we,
    in_flush => ex_if_id_flush,
    in_rd_data => wb_id_data,
    in_rd_addr => wb_id_addr,
    out_rs1_data => id_ex_rs1,
    out_rs2_data => id_ex_rs2,
    out_imm => id_ex_imm,
    out_jump => id_ex_jump,
    out_branch => id_ex_branch,
    in_pc => if_id_pc,
    out_pc => id_ex_pc,
    out_opcode => id_ex_opcode,
    out_use_src2 => id_ex_use_src2,
    out_loadword => id_ex_loadword,
    out_storeword => id_ex_storeword
  );

  u_execute : rv_pipeline_execute
  port map (
    in_clk, in_rstn,
    in_jump => id_ex_jump,
    in_branch => id_ex_branch,
    in_rs1_data => id_ex_rs1,
    in_rs2_data => id_ex_rs2,
    in_imm => id_ex_imm,
    in_pc => id_ex_pc,

    in_loadword => id_ex_loadword,
    in_storeword => id_ex_storeword,
    out_loadword => ex_me_loadword, 
    out_storeword => ex_me_storeword,

    in_opcode => id_ex_opcode,
    in_use_src2 => id_ex_use_src2,
    out_pc_transfer => ex_if_transfer,
    out_alu_result => ex_me_alu_result,
    out_store_data => ex_me_store_data,
    out_pc_target => ex_if_target,
    in_rd_addr => id_ex_rd_addr,
    out_rd_addr => ex_me_rd_addr
  );

  u_memory : rv_pipeline_memory
  port map (
    in_clk, in_rstn,
    in_store_data => ex_me_store_data,
    in_alu_result => ex_me_alu_result,
    in_rd_addr => ex_me_rd_addr,
    in_loadword => ex_me_loadword, 
    in_storeword => ex_me_storeword,
    out_rd_data => wb_id_data,
    out_rd_addr => wb_id_addr
  );
end arch;
