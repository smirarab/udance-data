TMPDIR=/dev/shm

f(){
    rep=$1
    size=$2
    TMREP=`mktemp -dt XXXXXXX`
    mkdir -p $TMREP
    ls -d  hgt/0.4/$size/$rep/output/udance/*/ | rev | cut -f2 -d '/' | rev | while read cl; do
            nw_labels -I hgt/0.4/$size/$rep/output/udance/$cl/astral_output.updates.nwk > $TMREP/labs.txt
            nw_prune -v <(nw_topology -bI hgt/0.4/$size/$rep/fasttree/s_tree.trees) `cat $TMREP/labs.txt` > $TMREP/tsp.nwk
            nw_prune -v <(nw_topology -bI ../estaln/trees/$size/$rep/astral_mp.nwk) `cat $TMREP/labs.txt` > $TMREP/est.nwk
            nw_prune -v <(nw_topology -bI ../concat/$size/$rep/fasttree.nwk) `cat $TMREP/labs.txt` > $TMREP/estcon.nwk
            x=$(~/tools/qd-rf.sh $TMREP/tsp.nwk hgt/0.4/$size/$rep/output/udance/$cl/astral_output.updates.nwk)
            y=$(~/tools/qd-rf.sh $TMREP/tsp.nwk $TMREP/est.nwk)
            z=$(~/tools/qd-rf.sh $TMREP/tsp.nwk $TMREP/estcon.nwk)
            printf "$rep\t$cl\t$size\t$x\t$y\t$z\tmc-1\n" | tr ' ' '\t'
        done
    rm -r $TMREP
}
export -f f

rm -r stee_partition.csv
touch stee_partition.csv

seq -w 1 10 | xargs -n1 -P10 -I% bash -c "f % 100" >> stee_partition.csv #&
seq -w 1 10 | xargs -n1 -P10 -I% bash -c "f % 500" >> stee_partition.csv #&

#seq -w 1 10 | xargs -n1 -P10 -I% bash -c "f % 100" > stee_100.csv #&
#seq -w 1 10 | xargs -n1 -P10 -I% bash -c "f % 500" > stee_500.csv
#f 03 100
