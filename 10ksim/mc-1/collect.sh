TMPDIR=/dev/shm

f(){
    rep=$1
    size=$2
    TMREP=`mktemp -dt XXXXXXX`
    mkdir -p $TMREP
    ls -d  hgt/0.4/$size/$rep/output/udance/*/ | rev | cut -f2 -d '/' | rev | while read cl; do
        for gn in `seq -w 1 $size`; do 
            nw_labels -I hgt/0.4/$size/$rep/output/udance/$cl/$gn/bestTree.nwk > $TMREP/labs.txt
            nw_prune -v <(nw_topology -bI hgt/0.4/$size/$rep/fasttree/s_tree.trees) `cat $TMREP/labs.txt` > $TMREP/tsp.nwk
            nw_prune -v <(head -n $gn hgt/0.4/$size/$rep/fasttree/estimatedgenetrees | tail -n 1 | nw_topology -bI -) `cat $TMREP/labs.txt` > $TMREP/est.nwk
            nw_prune -v <(head -n $gn hgt/0.4/$size/$rep/fasttree/truegenetrees | tail -n 1 | nw_topology -bI -) `cat $TMREP/labs.txt` > $TMREP/tru.nwk
            x=$(compareTrees.missingBranch $TMREP/tsp.nwk hgt/0.4/$size/$rep/output/udance/$cl/$gn/bestTree.nwk -simplify   | awk '{print $3}')
            y=$(compareTrees.missingBranch $TMREP/tsp.nwk $TMREP/est.nwk -simplify   | awk '{print $3}')
            z=$(compareTrees.missingBranch $TMREP/tsp.nwk $TMREP/tru.nwk -simplify   | awk '{print $3}'); 
            g1d=$(compareTrees.missingBranch $TMREP/tru.nwk hgt/0.4/$size/$rep/output/udance/$cl/$gn/bestTree.nwk -simplify   | awk '{print $3}')
            g2d=$(compareTrees.missingBranch $TMREP/tru.nwk $TMREP/est.nwk -simplify   | awk '{print $3}')
            printf "$rep\t$cl\t$gn\t$size\t$x\t$y\t$z\t$g1d\t$g2d\n"
        done
    done
    rm -r $TMREP
}
export -f f

seq -w 1 10 | xargs -n1 -P10 -I% bash -c "f % 100" > gene_discordance_100.csv &
seq -w 1 10 | xargs -n1 -P10 -I% bash -c "f % 500" > gene_discordance_500.csv
#f 03 100
