widths=(8 16 32)
fractionals=(5 10 20)
depths=(2 4 8 16 32 64 128)

#echo "width,depth,time" > ./syn/rpt/runtimes.csv
for dpt in ${depths[@]}
do
    for idx in ${!widths[@]}
    do
        # modify pkg data

        sed -i "s/DATA_DEPTH : integer := [0-9]\+/DATA_DEPTH : integer := ${dpt}/g" ./rtl/types_and_constants.vhd
        sed -i "s/DATA_WIDTH : integer := [0-9]\+/DATA_WIDTH : integer := ${widths[$idx]}/g" ./rtl/types_and_constants.vhd
        sed -i "s/FRACTIONAL_BITS : integer := [0-9]\+/FRACTIONAL_BITS : integer := ${fractionals[$idx]}/g" ./rtl/types_and_constants.vhd

        start=`date +%s`
        TOP_NAME=parallel_neuron SUFFIX="_${widths[$idx]}x${dpt}_" genus -f ./syn/scr/genus_synthesis.tcl -batch
        end=`date +%s`
        runtime=$((end-start))
        echo "${widths[$idx]},${dpt},${runtime}" >> ./syn/rpt/runtimes.csv
    done
done
