import sys
import argparse
import re
import math
import random


DATA_FILE = ''
ROM_FILE = './../rtl/weight_ROM.vhd'
LIB_FILE = './../rtl/types_and_constants.vhd'

if __name__ == '__main__':
    with open(LIB_FILE, 'r') as fp:
        lib_text = fp.read()
    mtch = re.search(r' *constant *NUM_LAYERS *: *integer *:= (\d+) *;', lib_text)
    num_layers = int(mtch.group(1))
    mtch = re.search(r' *constant *DATA_DEPTH *: *integer *:= (\d+) *;', lib_text)
    data_depth = int(mtch.group(1))
    mtch = re.search(r' *constant *DATA_WIDTH *: *integer *:= (\d+) *;', lib_text)
    data_width = int(mtch.group(1))
    mtch = re.search(r' *constant *FRACTIONAL_BITS *: *integer *:= (\d+) *;', lib_text)
    fractional_bits = int(mtch.group(1))
    integer_bits = data_width - fractional_bits

    print('num layers', num_layers)
    print('data depth', data_depth)
    print('data width', data_width)
    print('fractional bits', fractional_bits)

    text = ''
    for i in range(num_layers):
        for j in range(data_depth):
            for k in range(data_depth):
                frac_part = random.randrange(2**fractional_bits - 1 )
                int_part  = random.randrange(2*integer_bits) # generate a small random int sort of proportional to num of intere bits
                frac_part_txt = '{0:0{num_bits}b}'.format(frac_part, num_bits=fractional_bits)
                int_part_txt = '{0:0{num_bits}b}'.format(int_part, num_bits=integer_bits)
                text += '  all_weights({layer})({neuron})({connection}) <= B\"'.format(layer=i, neuron=j, connection=k)\
                     + int_part_txt + '_' + frac_part_txt + '\"; -- {int}.{frac}\n'.format(int=int_part, frac=frac_part)

    with open(ROM_FILE, 'r') as fp:
        lines = fp.read().splitlines()
    with open(ROM_FILE, 'w') as fp:
        weight_start = lines.index('-- BEGIN WEIGHTS')
        weight_end   = lines.index('-- END WEIGHTS')
        write_lines  = lines[:weight_start+1] + text.splitlines() + lines[weight_end:]
        fp.write('\n'.join(write_lines))

