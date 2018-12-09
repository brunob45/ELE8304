set ::env(LAB2_SRC_SDC) /users/Cours/ele8304/2/Labs/Lab2/sources/sdc
set ::env(LAB2_SYN_REP) /users/Cours/ele8304/2/Labs/Lab2/syn/rep
set ::env(LAB2_SYN_NET) /users/Cours/ele8304/2/Labs/Lab2/syn/net

read_sdc $::env(LAB2_SRC_SDC)/timing.sdc
report_timing -lint > $::env(LAB2_SYN_REP)/adder_timing_lint.rpt

set_db syn_generic_effort medium
syn_generic rv_adder
write_hdl > $::env(LAB2_SYN_NET)/adder_gen.v

ungroup -all -simple
uniquify rv_adder

set_db syn_map_effort medium
syn_map rv_adder
write_hdl > $::env(LAB2_SYN_NET)/adder_map.v

set_db syn_opt_effort medium
syn_opt rv_adder
write_hdl > $::env(LAB2_SYN_NET)/adder_opt.v

write_hdl > $::env(LAB2_SYN_NET)/adder_net.v
write_sdf > $::env(LAB2_SYN_NET)/adder_net.sdf
