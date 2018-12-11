read_hdl -vhdl pkg.vhd
read_hdl -vhdl shifter.vhd
elaborate rv_shifter
check_design -unresolved
