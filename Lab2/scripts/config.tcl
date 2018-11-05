set ::env(LAB2_SRC_HDL) /users/Cours/ele8304/2/Labs/Lab2/sources/hdl

set_db information_level 7
set_db hdl_vhdl_read_version 2008
set_db init_hdl_search_path [list $::env(LAB2_SRC_HDL)]
set_db init_lib_search_path [list $::env(LIBSCTIM) $::env(LIBSCLEF) $::env(LIBIOLEF) $::env(LIBSCQRC)]
read_libs [list fast_vdd1v0_basicCells.lib fast_vdd1v0_extvdd1v0.lib fast_vdd1v0_multibitsDFF.lib]
read_physical -lef [list gsclib045_tech.lef gsclib045_macro.lef gsclib045_multibitsDFF.lef]
read_qrc gpdk045.tch

