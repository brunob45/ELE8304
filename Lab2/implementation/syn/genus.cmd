# Cadence Genus(TM) Synthesis Solution, Version 17.10-p007_1, built Aug  3 2017

# Date: Tue Dec 11 01:16:51 2018
# Host: vlsi310 (x86_64 w/Linux 3.10.0-957.1.3.el7.x86_64) (4cores*8cpus*1physical cpu*Intel(R) Core(TM) i7 CPU 960 @ 3.20GHz 8192KB)
# OS:   Scientific Linux release 7.6 (Nitrogen)

source scripts/core_syn.tcl
gui_sv_snapshot -overwrite -ps $::env(LAB2_SYN_REP)/core.ps
gui_show
