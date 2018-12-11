read_hdl -vhdl rf.vhd
read_hdl -vhdl decode.vhd 
elaborate rv_pipeline_decode
check_design -unresolved
