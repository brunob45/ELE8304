
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rv_pipeline_execute is
  generic ( 
    ADDR_WIDTH : positive := 10;
    DATA_WIDTH : positive := 32;
    REG_WIDTH : positive := 5
  );
  port (
    in_clk, in_rstn : in std_logic;
    in_jump, in_branch: in std_logic;
    in_rs1_data, in_rs2_data, in_imm : in std_logic_vector(DATA_WIDTH-1 downto 0);
    in_pc : in std_logic_vector(ADDR_WIDTH downto 0);
    in_loadword, in_storeword : in std_logic;

    in_alu_arith : in std_logic;
    in_alu_sign : in std_logic;
    in_alu_opcode : in std_logic_vector(2 downto 0);
    in_alu_shamt : in std_logic_vector(4 downto 0);
    in_alu_use_src2 : in std_logic;

    out_pc_transfer : out std_logic_vector(ADDR_WIDTH downto 0);
    out_alu_result : out std_logic_vector(DATA_WIDTH-1 downto 0);
    out_store_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
    out_pc_target : out std_logic_vector(ADDR_WIDTH-1 downto 0);
    out_loadword, out_storeword : out std_logic;
    out_flush : out std_logic
  );
    
end rv_pipeline_execute;

architecture arch of rv_pipeline_execute is
  -- components
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
end component;

component rv_adder is
  generic ( N : positive := 32 );
  port (
    in_a : in std_logic_vector(N-1 downto 0);
    in_b : in std_logic_vector(N-1 downto 0);
    in_sign : in std_logic;
    in_sub : in std_logic;
    out_sum : out std_logic_vector(N downto 0));
end component;

  -- signaux
  signal alu_in, alu_out : std_logic_vector(DATA_WIDTH-1 downto 0);

begin
  alu_in <= in_rs2_data when in_alu_use_src2 = '1' else in_imm;
  
  -- port map
  u_alu : rv_alu port map (
    in_arith => in_alu_arith,
    in_sign => in_alu_sign,
    in_opcode => in_alu_opcode,
    in_shamt => in_alu_shamt,
    in_src1 => in_rs1_data,
    in_src2 => alu_in,
    out_res => alu_out
  );

  u_adder : rv_adder port map(
    in_a => in_imm,
    in_b => in_pc,
    in_sign => '0',
    in_sub => '0',
    out_sum => out_pc_target
  );



-- EX/ME register
  exme : process(in_clk)
  begin
    if in_clk'event and in_clk = '1' then
      out_alu_result <= alu_out;
      out_store_data <= in_rs2_data;
    end if;
  end process;

end arch;
