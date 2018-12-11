set lib     "beh/alu"
set srcD    "../sources/hdl"
set top     "alu"
set tb      "${top}_tb"
set modules [list "pkg" "hadd" "adder" "shifter"]
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
