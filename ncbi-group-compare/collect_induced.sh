cat select_phyla.txt | while read ph; do 
    grep "$ph" ncbi_tax_top30.txt | cut -f1 > .t
    mapfile -t < .t
    for i in gtdb 10k 16k 200k; do 
        nw_prune -v <(nw_topology -bI $i/rt) "${MAPFILE[@]}" > $i/$ph.nwk
    done
done

cat select_phyla.txt | while read ph; do
    for i in gtdb 10k 16k 200k; do
        for j in gtdb 10k 16k 200k; do
           ~/tools/qd-rf.sh $i/$ph.nwk $j/$ph.nwk | sed "s/$/\t$i\t$j\t$ph/g"
       done
   done
done > collectall.csv
