set ::env(LAB2_SRC_SDC) /users/Cours/ele8304/2/Labs/Lab2/sources/sdc
set ::env(LAB2_SYN_NET) /users/Cours/ele8304/2/Labs/Lab2/implementation/syn/netlists
set init_oa_ref_lib [list gsclib045_tech gsclib045 gpdk045 giolib045]
set init_verilog $::env(LAB2_SYN_NET)/core_net.v
set init_design_settop 1
set init_top_cell core
set init_gnd_net VSS
set init_pwr_net VDD
set init_mmmc_file $::env(LAB2_SRC_SDC)/core_mmmc.tcl