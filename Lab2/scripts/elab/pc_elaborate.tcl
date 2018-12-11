read_hdl -vhdl pkg.vhd
read_hdl -vhdl pc.vhd
elaborate rv_pc
check_design -unresolved
