library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mini_riscv is
  constant OPCODE_WIDTH : natural := 3;
  constant SHAMT_WIDTH : natural := 5;
  constant REG_ADDR_WIDTH : natural := 5;
  constant DATA_WIDTH : natural := 32;
  constant ADDR_WIDTH : natural := 10;

  subtype WORD is std_logic_vector(DATA_WIDTH-1 downto 0);
  subtype ADDRESS is std_logic_vector(ADDR_WIDTH-1 downto 0);
  subtype OPCODE is std_logic_vector(OPCODE_WIDTH-1 downto 0);
  subtype SHAMT is std_logic_vector(SHAMT_WIDTH-1 downto 0);
  subtype FLAG is std_logic;
  subtype REG_ADDR is std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
  type REGISTER_ARRAY is array (2**REG_ADDR_WIDTH-1 downto 0) of WORD;

  constant ZERO_VALUE : WORD := WORD(to_unsigned(0, DATA_WIDTH));
  constant ZERO_ADDR : ADDRESS := ADDRESS(to_unsigned(0, ADDR_WIDTH));

  component rv_adder is
    generic ( N : positive := DATA_WIDTH );
    port (
      in_a : in std_logic_vector(N-1 downto 0);
      in_b : in std_logic_vector(N-1 downto 0);
      in_sign : in std_logic;
      in_sub : in std_logic;
      out_sum : out std_logic_vector(N downto 0)
    );
  end component;

  component rv_shifter is
    generic( N : positive := SHAMT_WIDTH );
      port(
      in_data : in std_logic_vector(2**N-1 downto 0);
      in_shamt : in std_logic_vector(N-1 downto 0);
      in_arith : in std_logic;
      in_direction : in std_logic;
      out_data : out std_logic_vector(2**N-1 downto 0)
  );
  end component;

  component rv_alu is
  port (
    in_arith : in FLAG;
    in_sign : in FLAG;
    in_opcode : in OPCODE;
    in_shamt : in SHAMT;
    in_src1 : in WORD;
    in_src2 : in WORD;
    out_res : out WORD
  );
  end component;

  component rv_pc is
  generic ( 
    RESET_VECTOR : natural := 16#00000000#;
    XLEN : natural := DATA_WIDTH
  );
  port (
    in_clk, in_rstn : in std_logic;
    in_stall : in std_logic;
    in_transfert : in std_logic;
    in_target : in std_logic_vector(XLEN-1 downto 0);
    out_pc : out std_logic_vector(XLEN-1 downto 0)
  );
  end component;

component rv_rf is
  generic (
    REG : natural := REG_ADDR_WIDTH;
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

  component rv_pipeline_fetch is
  port (
    in_clk, in_rstn : in FLAG;
    in_transfert : in FLAG;
    in_target : in ADDRESS;
    in_stall : in FLAG;
    in_flush: in FLAG;
    out_instr : out WORD;
    out_pc : out ADDRESS
  );
  end component;

  component rv_pipeline_decode is
  port (
    in_clk, in_rstn : in FLAG;
    in_instr : in WORD;
    in_we : in FLAG;
    in_flush: in FLAG;
    in_rd_data : in WORD;
    in_rd_addr : in REG_ADDR;
    out_rs1_data, out_rs2_data, out_imm : out WORD;
    out_jump, out_branch : out FLAG;
    in_pc : in ADDRESS;
    out_pc : out ADDRESS;
    out_opcode : out OPCODE;
    out_use_src2 : out FLAG;
    out_loadword, out_storeword : out FLAG;
    out_rd_addr : out REG_ADDR
  );   
  end component;

  component rv_pipeline_execute is
  port (
    in_clk, in_rstn : in FLAG;
    in_jump, in_branch: in FLAG;
    in_rs1_data, in_rs2_data, in_imm : in WORD;
    in_pc : in ADDRESS;
    in_loadword, in_storeword : in FLAG;
    in_opcode : in OPCODE;
    in_use_src2 : in FLAG;

    out_pc_transfer : out FLAG;
    out_pc_target : out ADDRESS;
    out_alu_result : out WORD;
    out_store_data : out WORD;
    out_loadword, out_storeword : out FLAG;

    in_rd_addr : in REG_ADDR;
    out_rd_addr : out REG_ADDR
  );  
  end component;

  component rv_pipeline_memory is
  port (
    in_clk, in_rstn : in FLAG;
    in_store_data : in WORD;
    in_alu_result : in WORD;
    in_rd_addr : in REG_ADDR;
    in_loadword, in_storeword : in FLAG;
    out_rd_data : out WORD;
    out_rd_addr : out REG_ADDR;
    in_dmem_read : in WORD;
    out_dmem_we : out FLAG;
    out_dmem_addr : out ADDRESS;
    out_dmem_write : out WORD
  );   
  end component;

  component rv_core is
  port (
    in_rstn, in_clk : in FLAG;
    in_imem_read : in WORD;
    out_imem_addr : out ADDRESS;
    in_dmem_read : in WORD;
    out_dmem_we : out FLAG;
    out_dmem_addr : out ADDRESS;
    out_dmem_write : out WORD
  );
  end component;
end mini_riscv;
