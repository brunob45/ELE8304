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
    out_dmem_write : out WORD;
    
    out_if_stall : out FLAG;
    out_if_transfer : out FLAG;
    out_if_flush : out FLAG;
    out_if_pc : out WORD;
    out_id_instr : out WORD;
    -- debug
    out_branch : out FLAG;
    out_debug1, out_debug2 : out WORD
  );
end rv_core;

architecture arch of rv_core is
  -- signaux
  signal ex_if_transfer, ex_if_stall, ex_if_id_flush : FLAG := '0';
  signal id_ex_jump, id_ex_branch, id_ex_use_src2 : FLAG := '0';
  signal id_ex_loadword, id_ex_storeword : FLAG := '0';
  signal ex_me_loadword, ex_me_storeword : FLAG := '0';
  signal id_ex_alu_arith, id_ex_alu_sign : FLAG := '0';
  signal me_wb_loadword : FLAG := '0';
  signal id_ex_rd_we, ex_me_rd_we, me_wb_rd_we, wb_id_rd_we : FLAG := '0';

  signal ex_if_target, if_id_instr : WORD := ZERO_VALUE;
  signal id_ex_rs1, id_ex_rs2, id_ex_imm: WORD := ZERO_VALUE;
  signal me_wb_alu_result, wb_id_rd_data : WORD := ZERO_VALUE;
  signal ex_me_alu_result, ex_me_store_data : WORD := ZERO_VALUE;
  signal id_ex_pc, if_id_pc : WORD := ZERO_VALUE;

  signal wb_id_rd_addr, me_wb_rd_addr : REG_ADDR := "00000";
  signal id_ex_rd_addr, ex_me_rd_addr : REG_ADDR := "00000";

  signal id_ex_alu_opcode : OPCODE := "000";

  signal id_ex_alu_shamt : SHAMT := "00000";
  
  -- debug
  signal debug1, debug2 : WORD := ZERO_VALUE;
  

begin
  out_if_stall <= ex_if_stall;
  out_if_flush <= ex_if_id_flush;
  out_if_transfer <= ex_if_transfer;
  out_id_instr <= if_id_instr;
  out_if_pc <= if_id_pc;
  -- debug
  out_branch <= ex_if_transfer;
  out_debug1 <= debug1;
  out_debug2 <= debug2;
  
  debug1 <= wb_id_rd_data;
  debug2(4 downto 0) <= wb_id_rd_addr;
  debug2(20) <= id_ex_rd_we;

-- port map
  u_fetch : rv_pipeline_fetch
  port map (
    in_clk, in_rstn,
    in_transfert => ex_if_transfer,
    in_target => ex_if_target,
    in_stall => ex_if_stall,
    in_flush => ex_if_id_flush,
    
    out_imem_addr => out_imem_addr,
    in_imem_read => in_imem_read,
    
    out_instr => if_id_instr,
    out_pc => if_id_pc
  );

  u_decode : rv_pipeline_decode
  port map (
    in_clk, in_rstn,
    in_instr => if_id_instr,
    in_rd_we => wb_id_rd_we,
    in_flush => ex_if_id_flush,
    in_rd_data => wb_id_rd_data,
    in_rd_addr => wb_id_rd_addr,
    in_pc => if_id_pc,
    
    out_rs1_data => id_ex_rs1,
    out_rs2_data => id_ex_rs2,
    out_imm => id_ex_imm,
    out_jump => id_ex_jump,
    out_branch => id_ex_branch,
    out_pc => id_ex_pc,
    out_alu_opcode => id_ex_alu_opcode,
    out_alu_use_src2 => id_ex_use_src2,
    out_loadword => id_ex_loadword,
    out_storeword => id_ex_storeword,
    out_alu_sign => id_ex_alu_sign,
    out_alu_arith => id_ex_alu_arith,
    out_alu_shamt => id_ex_alu_shamt,
    out_rd_addr => id_ex_rd_addr,
    out_rd_we => id_ex_rd_we
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
    
    in_alu_arith => id_ex_alu_arith,
    in_alu_sign => id_ex_alu_sign,
    in_alu_opcode => id_ex_alu_opcode,
    in_alu_shamt => id_ex_alu_shamt,
    in_alu_use_src2 => id_ex_use_src2,
    in_rd_addr => id_ex_rd_addr,
    
    out_pc_transfer => ex_if_transfer,
    out_alu_result => ex_me_alu_result,
    out_store_data => ex_me_store_data,
    out_flush => ex_if_id_flush,
    out_stall => ex_if_stall,
    out_pc_target => ex_if_target,
    out_rd_addr => ex_me_rd_addr,
    
    in_rd_we => id_ex_rd_we,
    out_rd_we => ex_me_rd_we
  );

  u_memory : rv_pipeline_memory
  port map (
    in_clk, in_rstn,
    
    in_store_data => ex_me_store_data,
    in_alu_result => ex_me_alu_result,
    in_rd_addr => ex_me_rd_addr,
    in_loadword => ex_me_loadword, 
    in_storeword => ex_me_storeword,
    
    out_loadword => me_wb_loadword,
    out_alu_result => me_wb_alu_result,
    out_rd_addr => me_wb_rd_addr,
    
    out_dmem_we => out_dmem_we,
    out_dmem_addr => out_dmem_addr,
    out_dmem_write => out_dmem_write,
    
    in_rd_we => ex_me_rd_we,
    out_rd_we => me_wb_rd_we
  );

  u_writeback : rv_pipeline_writeback
  port map (
    in_rd_addr => me_wb_rd_addr,
    in_alu_result => me_wb_alu_result,
    in_loadword => me_wb_loadword,
    in_rd_we => me_wb_rd_we,
    
    in_dmem_read => in_dmem_read,

    out_rd_data => wb_id_rd_data,
    out_rd_addr => wb_id_rd_addr,
    out_rd_we => wb_id_rd_we
  );
    
end arch;
