# Cadence Genus(TM) Synthesis Solution, Version 17.10-p007_1, built Aug  3 2017

# Date: Mon Nov 05 15:50:26 2018
# Host: vlsi304 (x86_64 w/Linux 3.10.0-862.14.4.el7.x86_64) (4cores*8cpus*1physical cpu*Intel(R) Core(TM) i7 CPU 960 @ 3.20GHz 8192KB)
# OS:   Scientific Linux release 7.5 (Nitrogen)

ls
cd scripts
ls
rm -r fv
ls
source config.tcl
source shifter.tcl
ls fv
help elaborate
read_hdl -vhdl shifter.vhd
elaborate rv_shifter
help check_design
source shifter.tcl
rm fv -r
ls
source shifter.tcl
