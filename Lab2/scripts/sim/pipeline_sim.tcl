set lib     "beh/pipeline"
set srcD    "../sources/hdl"
set top     "pipeline"
set tb      "${top}_tb"
set dut     "u_${top}"
set modules [list "pkg" "pkg_mem" "hadd" "shifter" "adder" "alu" "pc" "rf" "fetch" "decode" "execute" "memory" "writeback"]
set simtime "2000"
# Librairie de travail
if { [file exists $lib] } {
file delete -force $lib
}
vlib $lib
# Compilation
foreach module $modules {
vcom -work $lib $srcD/$module.vhd
}
vcom -work $lib $srcD/$top.vhd

vcom -2008 -work $lib $srcD/$tb.vhd
# Simulation
vsim $lib.$tb

vcd file $lib/$top.vcd
vcd add /$tb/$dut/*

run -all
vcd flush
