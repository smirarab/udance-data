TMPDIR=/dev/shm

f(){
    rep=$1
    size=$2
    TMREP=`mktemp -dt XXXXXXX`
    mkdir -p $TMREP
    ls -d  uDance/hgt/$size/$rep/output/udance/*/ | rev | cut -f2 -d '/' | rev | while read cl; do
            nw_labels -I uDance/hgt/$size/$rep/output/udance/$cl/astral_output.updates.nwk > $TMREP/labs.txt
            nw_prune -v <(nw_topology -bI sim/model-0.5_0.5-5.5/$rep/s_tree.trees) `cat $TMREP/labs.txt` > $TMREP/tsp.nwk
            nw_prune -v <(nw_topology -bI estaln/trees/$size/$rep/astral-mp.nwk) `cat $TMREP/labs.txt` > $TMREP/est.nwk
            nw_prune -v <(nw_topology -bI concat/$size/$rep/fasttree.nwk) `cat $TMREP/labs.txt` > $TMREP/estcon.nwk
            x=$(~/tools/qd-rf.sh $TMREP/tsp.nwk uDance/hgt/$size/$rep/output/udance/$cl/astral_output.updates.nwk)
            y=$(~/tools/qd-rf.sh $TMREP/tsp.nwk $TMREP/est.nwk)
            z=$(~/tools/qd-rf.sh $TMREP/tsp.nwk $TMREP/estcon.nwk)
            printf "$rep\t$cl\t$size\t$x\t$y\t$z\tmc-2\n" | tr ' ' '\t'
        done
    rm -r $TMREP
}
export -f f

rm -r stee_partition.csv
touch stee_partition.csv

seq -w 1 10 | xargs -n1 -P10 -I% bash -c "f % 100" >> stee_partition.csv #&
seq -w 1 10 | xargs -n1 -P10 -I% bash -c "f % 500" >> stee_partition.csv #&
#seq -w 1 10 | xargs -n1 -P10 -I% bash -c "f % 500" > stee_500.csv
#f 03 100
