for i in `seq -w 1 10`; do 
    seq -w 1 500 | xargs -P16 -n1 -I % bash -c "./qd-rf.sh sim/model-0.5_0.5-5.5/$i/s_tree.trees  estaln/alignments/$i/%/fasttree.nwk | sed 's/$/\t%/g'" | sed "s/$/\t$i/g"; 
done
