for i in 500 1000 2000; do 
    bash ~/tools/qd-rf.sh sim/model-0.5_0.5-5.5/1/s_tree.trees sample/$i/trees/species/astral-mp.nwk | sed "s/$/\tFT2+ASTRAL\t$i/g"
done > udance_acc.csv

for i in 250 500 1000 2000 4000 8000 16000 32000; do 
#for i in 500 ; do 
    bash ~/tools/qd-rf.sh sim/model-0.5_0.5-5.5/1/s_tree.trees sample/$i/output/udance.maxqs.nwk | sed "s/$/\tuDance\t$i/g"
done >> udance_acc.csv


for i in 250 500 1000 2000 4000 8000 16000 32000; do 
   bash ~/tools/qd-rf.sh sim/model-0.5_0.5-5.5/1/s_tree.trees sample/$i/trees/species/concatenation.nwk | sed "s/$/\tconcat\t$i/g"
done >> udance_acc.csv
