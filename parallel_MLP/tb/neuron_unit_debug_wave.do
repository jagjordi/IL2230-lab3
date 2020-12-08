onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /neuron_unit_tb/DUT/clk
add wave -noupdate /neuron_unit_tb/DUT/n_rst
add wave -noupdate -expand /neuron_unit_tb/DUT/layer_weights(2)
add wave -noupdate -expand /neuron_unit_tb/DUT/layer_data_inputs(2)
add wave -noupdate /neuron_unit_tb/DUT/reg_input_tmp(2)
add wave -noupdate /neuron_unit_tb/DUT/reg_output_tmp(2)
add wave -noupdate /neuron_unit_tb/DUT/layer_biases(2)
add wave -noupdate -divider -height 25 {Neuron 2}
add wave -noupdate /neuron_unit_tb/DUT/neuron_array(2)/parallel_neuron_1/new_data
add wave -noupdate -expand /neuron_unit_tb/DUT/neuron_array(2)/parallel_neuron_1/full_weights
add wave -noupdate -expand /neuron_unit_tb/DUT/neuron_array(2)/parallel_neuron_1/full_data_in
add wave -noupdate /neuron_unit_tb/DUT/neuron_array(2)/parallel_neuron_1/bias
add wave -noupdate /neuron_unit_tb/DUT/neuron_array(2)/parallel_neuron_1/output
add wave -noupdate /neuron_unit_tb/DUT/neuron_array(2)/parallel_neuron_1/next_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {85 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 242
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {221 ns}
