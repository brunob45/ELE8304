set lib     "~/Labs/Lab2/simulation/beh"
set srcD    "~/Labs/Lab2/sources/hdl"
set top     "alu"
set tb      "${top}_tb"
set modules [list "hadd" "adder" "shifter"]
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
vsim $work.$tb
do ${top}_wave.do
run $simtime ns
