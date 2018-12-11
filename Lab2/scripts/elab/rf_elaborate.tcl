read_hdl -vhdl pkg.vhd
read_hdl -vhdl rf.vhd
elaborate rv_rf
check_design -unresolved
