source ~/Labs/Lab2/scripts/config.tcl
source ~/Labs/Lab2/scripts/elab/core_elaborate.tcl

set ::env(LAB2_SRC_SDC) /users/Cours/ele8304/2/Labs/Lab2/sources/sdc
set ::env(LAB2_SYN_REP) /users/Cours/ele8304/2/Labs/Lab2/implementation/syn/reports
set ::env(LAB2_SYN_NET) /users/Cours/ele8304/2/Labs/Lab2/implementation/syn/netlists

read_sdc $::env(LAB2_SRC_SDC)/timing.sdc
report_timing -lint > $::env(LAB2_SYN_REP)/core_timing_lint.rpt

set_db syn_generic_effort medium
syn_generic rv_core
write_hdl > $::env(LAB2_SYN_NET)/core_gen.v

ungroup -all -simple
uniquify rv_core

set_db syn_map_effort medium
syn_map rv_core
write_hdl > $::env(LAB2_SYN_NET)/core_map.v

set_db syn_opt_effort medium
syn_opt rv_core
write_hdl > $::env(LAB2_SYN_NET)/core_opt.v

write_hdl > $::env(LAB2_SYN_NET)/core_net.v
write_sdf > $::env(LAB2_SYN_NET)/core_net.sdf

report_timing > $::env(LAB2_SYN_REP)/core_timing.rpt
report_area > $::env(LAB2_SYN_REP)/core_area.rpt
report_gates > $::env(LAB2_SYN_REP)/core_gates.rpt
report_power > $::env(LAB2_SYN_REP)/core_power.rpt

gui_show
