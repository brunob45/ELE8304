set lib     "rtl/alu"
set srcD    "../sources/hdl"
set top     "alu"
set tb      "${top}_tb"
set dut     "u_${top}"
set net     "${top}_net"
set netD    "../implementation/syn/netlists"
set netLib  "/CMC/kits/AMSKIT616_GPDK/simlib/gsclib045_ver"
set modules [list "pkg" "hadd" "adder" "shifter"]
set simtime "2000"

# Librairie de travail
if { [file exists $lib] } {
file delete -force $lib
}
vlib $lib
# Compilation
vlog -work $lib $netD/$net.v
vcom -2008 -work $lib $srcD/$tb.vhd

# Simulation
vsim -L $netLib -t ps -sdfmax $dut=$netD/$net.sdf $lib.$tb

# VCD
vcd file $lib/$top.vcd
vcd add /$tb/$dut/*

# Execution
do ${top}_wave.do
run -all
vcd flush