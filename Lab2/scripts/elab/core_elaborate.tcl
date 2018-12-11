read_hdl -vhdl pkg.vhd
read_hdl -vhdl hadd.vhd
read_hdl -vhdl adder.vhd
read_hdl -vhdl shifter.vhd
read_hdl -vhdl alu.vhd

read_hdl -vhdl rf.vhd
read_hdl -vhdl pc.vhd

read_hdl -vhdl decode.vhd
read_hdl -vhdl fetch.vhd
read_hdl -vhdl memory.vhd
read_hdl -vhdl execute.vhd
read_hdl -vhdl writeback.vhd

read_hdl -vhdl pipeline.vhd

elaborate rv_core
check_design -unresolved
