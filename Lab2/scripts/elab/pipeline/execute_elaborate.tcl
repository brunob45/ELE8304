read_hdl -vhdl hadd.vhd
read_hdl -vhdl adder.vhd
read_hdl -vhdl shifter.vhd
read_hdl -vhdl alu.vhd
read_hdl -vhdl execute.vhd
elaborate rv_pipeline_execute
check_design -unresolved
