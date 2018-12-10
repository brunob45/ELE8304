# File: compteur.sdc
# Description : Contraintes de timing
# ------------------------------------------------
set clk_name "Clk"
set clk_period 1
set inout_delay 0.5
create_clock -period $clk_period -name $clk_name [get_ports clk]
set_input_delay $inout_delay -clock $clk_name [all_inputs]
set_output_delay $inout_delay -clock $clk_name [all_outputs]
