read_hdl -vhdl pc.vhd
read_hdl -vhdl fetch.vhd
elaborate rv_pipeline_fetch
check_design -unresolved
