## Fast library
create_library_set -name fast_libs -timing [list $::env(LIBSCTIM)/fast_vdd1v0_basicCells.lib    \
$::env(LIBSCTIM)/fast_vdd1v0_extvdd1v0.lib     \
$::env(LIBSCTIM)/fast_vdd1v0_multibitsDFF.lib] \
-si     [list $::env(LIBSCCDB)/fast.cdb]
## Slow library
create_library_set -name slow_libs -timing [list $::env(LIBSCTIM)/slow_vdd1v0_basicCells.lib    \
$::env(LIBSCTIM)/slow_vdd1v0_extvdd1v0.lib     \
$::env(LIBSCTIM)/slow_vdd1v0_multibitsDFF.lib] \
-si     [list $::env(LIBSCCDB)/slow.cdb]
## RC corner
create_rc_corner -name rc -qx_tech_file $::env(LIBSCQRC)/gpdk045.tch
## Delay corners
create_delay_corner -name fast_corner -library_set fast_libs -rc_corner rc
create_delay_corner -name slow_corner -library_set slow_libs -rc_corner rc
## Constraint mode
create_constraint_mode -name cst_mode -sdc_files $::env(LAB2_SRC_SDC)/timing.sdc
## Analysis view
create_analysis_view -name av_fast -constraint_mode cst_mode -delay_corner fast_corner
create_analysis_view -name av_slow -constraint_mode cst_mode -delay_corner slow_corner
set_analysis_view -setup av_fast -hold av_slow