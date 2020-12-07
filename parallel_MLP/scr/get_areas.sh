widths=(8 16 32)
fractionals=(5 10 20)
depths=(2 4 8 16 32 64 128)

echo "width,depth,area" > ./syn/rpt/areas.csv
for dpt in ${depths[@]}
do
    for idx in ${!widths[@]}
    do
        area=$(tail -n 3 syn/rpt/parallel_neuron_area_${widths[$idx]}x${dpt}_.txt | head -n 1 | awk '{print $5}')
        echo "${widths[$idx]},${dpt},${area}" >> ./syn/rpt/areas.csv
    done
done


