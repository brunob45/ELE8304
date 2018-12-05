
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;

entity rv_core is
  generic ( 
    ADDR_WIDTH : positive := 10;
    DATA_WIDTH : positive := 32;
    REG_WIDTH : positive := 5
  ); 
  port (
    in_rstn, in_clk : in std_logic;
    in_imem_read : in std_logic_vector(31 downto 0);
    out_imem_addr : out std_logic_vector(9 downto 0);
    in_dmem_read : in std_logic_vector(31 downto 0);
    out_dmem_we : out std_logic;
    out_dmem_addr : out std_logic_vector(9 downto 0);
    out_dmem_write : out std_logic_vector(31 downto 0)
  );
end rv_core;

architecture arch of rv_core is
  -- components
  component rv_pipeline_fetch is
    port (
      in_clk, in_rstn : in std_logic;
      in_transfert : std_logic;
      in_target : in std_logic_vector(ADDR_WIDTH-1 downto 0);
      in_stall : in std_logic;
      in_flush: in std_logic;
      out_instr : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
  end component;
  component rv_pipeline_decode is
    port (
      in_clk, in_rstn : in std_logic;
      in_instr : in std_logic_vector(DATA_WIDTH-1 downto 0);
      in_we : in std_logic;
      in_flush: in std_logic;
      in_rd_data : in std_logic_vector(DATA_WIDTH-1 downto 0);
      in_rd_addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
      out_rs1_data, out_rs2_data, out_imm : out std_logic_vector(DATA_WIDTH-1 downto 0);
      out_jump, out_branch : out std_logic;
      out_pc : out std_logic_vector(ADDR_WIDTH downto 0);
      out_opcode : out std_logic_vector(2 downto 0);
      out_use_src2 : out std_logic;
      out_lw, out_sw : out std_logic
    );   
  end component;
  component rv_pipeline_execute is
    port (
      in_clk, in_rstn : in std_logic;
      in_jump, in_branch: in std_logic;
      in_rs1_data, in_rs2_data, in_imm : in std_logic_vector(DATA_WIDTH-1 downto 0);
      in_pc : in std_logic_vector(ADDR_WIDTH downto 0); -- a verifier
      in_lw, in_sw : in std_logic;
      in_opcode : in std_logic_vector(2 downto 0);
      in_use_src2 : in std_logic;

      out_pc_transfer : out std_logic_vector(ADDR_WIDTH downto 0);
      out_alu_result : out std_logic_vector(DATA_WIDTH-1 downto 0);
      out_store_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
      out_pc_target : out std_logic_vector(ADDR_WIDTH-1 downto 0);
      out_lw, out_sw : out std_logic
    );  
  end component;
  component rv_pipeline_memory is
    port (
      in_clk, in_rstn : in std_logic;
      in_store_data : in std_logic_vector(DATA_WIDTH-1 downto 0);
      in_alu_result : in std_logic_vector(DATA_WIDTH-1 downto 0);
      in_rd_addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
      in_lw, in_sw : in std_logic;
      out_rd_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
      out_rd_addr : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );   
  end component;

  -- signaux
  signal ex_if_transfer, ex_if_stall, ex_if_id_flush, id_ex_lw, id_ex_sw : std_logic;
  signal ex_if_target : std_logic_vector(ADDR_WIDTH-1 downto 0);
  signal if_id_instr : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal wb_id_we, id_ex_jump, id_ex_branch, id_ex_use_src2 : std_logic;
  signal wb_id_addr, id_ex_pc : std_logic_vector(ADDR_WIDTH-1 downto 0);
  signal wb_id_data, id_ex_rs1, id_ex_rs2, id_ex_imm: std_logic_vector(DATA_WIDTH-1 downto 0);
  signal id_ex_opcode : std_logic_vector(2 downto 0);
  signal ex_me_pc_transfer : std_logic;
  signal ex_me_alu_result, ex_me_store_data : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal ex_me_pc_target : std_logic_vector(ADDR_WIDTH-1 downto 0);
begin
  -- port map if need be
  u_fetch : rv_pipeline_fetch
  port map (
    in_clk, in_rstn,
    in_transfert => ex_if_transfer,
    in_target => ex_if_target,
    in_stall => ex_if_stall,
    in_flush => ex_if_id_flush,
    out_instr => if_id_instr
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
    out_pc => id_ex_pc,
    out_opcode => id_ex_opcode,
    out_use_src2 => id_ex_use_src2,
    out_lw => id_ex_lw,
    out_sw => id_ex_sw
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
    in_lw => id_ex_lw,
    in_sw => id_ex_sw,
    in_opcode => id_ex_opcode,
    in_use_src2 => id_ex_use_src2,
--    out_pc_transfer => ex_me_pc_transfer,
    out_alu_result => ex_me_alu_result,
    out_store_data => ex_me_store_data,
    out_pc_target => ex_me_pc_target
--    out_lw, out_sw : out std_logic
  );
  u_memory : rv_pipeline_memory
  port map (
    in_clk, in_rstn,
    in_store_data => ex_me_store_data,
    in_alu_result => ex_me_alu_result,
    in_rd_addr => ex_me_pc_target,
--    in_lw, in_sw : in std_logic;
    out_rd_data => wb_id_data,
    out_rd_addr => wb_id_addr
  );
end arch;
