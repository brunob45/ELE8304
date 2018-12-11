read_hdl -vhdl pkg.vhd
read_hdl -vhdl hadd.vhd
read_hdl -vhdl adder.vhd
elaborate rv_adder
check_design -unresolved
