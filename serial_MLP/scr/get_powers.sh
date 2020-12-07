widths=(8 16 32)
fractionals=(5 10 20)
depths=(2 4 8 16 32 64 128)

echo "width,depth,power" > ./syn/rpt/powers.csv
for dpt in ${depths[@]}
do
    for idx in ${!widths[@]}
    do
        power=$(tail -n 3 syn/rpt/parallel_neuron_power_${widths[$idx]}x${dpt}_.txt | head -n 1 | awk '{print $5}')
        echo "${widths[$idx]},${dpt},${power}" >> ./syn/rpt/power.csv
    done
done


