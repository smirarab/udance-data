TMPDIR=/dev/shm
PATH=$PATH:`echo ~`/compareTrees

f(){
    rep=$1
    size=$2
    TMREP=`mktemp -dt XXXXXXX`
    mkdir -p $TMREP
    ls -d  uDance/hgt/$size/$rep/output/udance/*/ | rev | cut -f2 -d '/' | rev | while read cl; do
        ls -d uDance/hgt/$size/$rep/output/udance/$cl/*/ | xargs -n1 basename | while read gn; do 
        #for gn in `seq -w 1 $size`; do 
            nw_labels -I uDance/hgt/$size/$rep/output/udance/$cl/$gn/bestTree.nwk > $TMREP/labs.txt
            nw_prune -v <(nw_topology -bI /panfs/mebalaba/hgt/mc-2/sim/model-0.5_0.5-5.5/$rep/s_tree.trees) `cat $TMREP/labs.txt` > $TMREP/tsp.nwk
            nw_prune -v <(cat /panfs/mebalaba/hgt/mc-2/estaln/alignments/$rep/$gn/fasttree.nwk | nw_topology -bI -) `cat $TMREP/labs.txt` > $TMREP/est.nwk
            nw_prune -v <(cat /panfs/mebalaba/hgt/mc-2/sim/model-0.5_0.5-5.5/$rep/g_trees${gn}.trees | nw_topology -bI -) `cat $TMREP/labs.txt` > $TMREP/tru.nwk
            x=$(compareTrees.missingBranch $TMREP/tsp.nwk uDance/hgt/$size/$rep/output/udance/$cl/$gn/bestTree.nwk -simplify   | awk '{print $3}')
            y=$(compareTrees.missingBranch $TMREP/tsp.nwk $TMREP/est.nwk -simplify   | awk '{print $3}')
            z=$(compareTrees.missingBranch $TMREP/tsp.nwk $TMREP/tru.nwk -simplify   | awk '{print $3}'); 
            g1d=$(compareTrees.missingBranch $TMREP/tru.nwk uDance/hgt/$size/$rep/output/udance/$cl/$gn/bestTree.nwk -simplify   | awk '{print $3}')
            g2d=$(compareTrees.missingBranch $TMREP/tru.nwk $TMREP/est.nwk -simplify   | awk '{print $3}')
            printf "$rep\t$cl\t$gn\t100\t$x\t$y\t$z\t$g1d\t$g2d\t$size\n"
        done
    done
    rm -r $TMREP
}
export -f f

rm -f gene_discordance.csv
touch gene_discordance.csv
for i in 100 200 300 400 500; do 
    seq -w 1 10 | xargs -n1 -P32 -I% bash -c "f % $i" >> gene_discordance.csv
done
#seq -w 1 10 | xargs -n1 -P20 -I% bash -c "f % 500" | tee gene_discordance_500.csv
#f 03 100
