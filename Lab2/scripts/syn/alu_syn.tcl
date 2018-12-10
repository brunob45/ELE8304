source ~/Labs/Lab2/scripts/config.tcl
source ~/Labs/Lab2/scripts/elab/alu_elaborate.tcl

set ::env(LAB2_SRC_SDC) /users/Cours/ele8304/2/Labs/Lab2/sources/sdc
set ::env(LAB2_SYN_REP) /users/Cours/ele8304/2/Labs/Lab2/implementation/syn/reports
set ::env(LAB2_SYN_NET) /users/Cours/ele8304/2/Labs/Lab2/implementation/syn/netlists

read_sdc $::env(LAB2_SRC_SDC)/timing.sdc
report_timing -lint > $::env(LAB2_SYN_REP)/alu_timing_lint.rpt

set_db syn_generic_effort medium
syn_generic rv_alu
write_hdl > $::env(LAB2_SYN_NET)/alu_gen.v

ungroup -all -simple
uniquify rv_alu

set_db syn_map_effort medium
syn_map rv_alu
write_hdl > $::env(LAB2_SYN_NET)/alu_map.v

set_db syn_opt_effort medium
syn_opt rv_alu
write_hdl > $::env(LAB2_SYN_NET)/alu_opt.v

write_hdl > $::env(LAB2_SYN_NET)/alu_net.v
write_sdf > $::env(LAB2_SYN_NET)/alu_net.sdf

report_timing > $::env(LAB2_SYN_REP)/alu_timing.rpt
report_area > $::env(LAB2_SYN_REP)/alu_area.rpt
report_gates > $::env(LAB2_SYN_REP)/alu_gates.rpt
report_power > $::env(LAB2_SYN_REP)/alu_power.rpt

gui_show
