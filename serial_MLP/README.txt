-- "rtl" folder contains VHDL source codes
MAC.vhd -- Mac unit implementation for the neuron unit
parallel_neuron.vhd -- Neuron unit with parallel MAC units
ReLU.vhd -- ReLU function
serial_MLP.vhd -- final implementation of the serial MLP
types_and_constants.vhd -- contains generics

-- "tb" folder contains testbenches for each component: MAC, neuron, and MLP units. They have been named accordingly. For the simulation result given in Figure 8, please, refer to "serial_MLP_tb.vhd" file after setting M=3 from "types_and_constants.vhd" file.
