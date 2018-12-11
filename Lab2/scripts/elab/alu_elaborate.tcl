read_hdl -vhdl pkg.vhd
read_hdl -vhdl hadd.vhd
read_hdl -vhdl adder.vhd
read_hdl -vhdl shifter.vhd
read_hdl -vhdl alu.vhd
elaborate rv_alu
check_design -unresolved
