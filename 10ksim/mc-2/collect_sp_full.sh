TMPDIR=/dev/shm

f(){
    rep=$1
    size=$2
            x=$(~/tools/qd-rf.sh sim/model-0.5_0.5-5.5/$rep/s_tree.trees uDance/hgt/$size/$rep/output/udance/udance.maxqs.nwk)
            y=$(~/tools/qd-rf.sh sim/model-0.5_0.5-5.5/$rep/s_tree.trees estaln/trees/$size/$rep/astral-mp.nwk)
            z=$(~/tools/qd-rf.sh sim/model-0.5_0.5-5.5/$rep/s_tree.trees concat/$size/$rep/fasttree.nwk)
            printf "$rep\t$size\t$x\t$y\t$z\tmc-2\n" | tr ' ' '\t'
}
export -f f

rm -r stee_full.csv
touch stee_full.csv

seq -w 1 10 | xargs -n1 -P10 -I% bash -c "f % 100" >> stee_full.csv #&
seq -w 1 10 | xargs -n1 -P10 -I% bash -c "f % 500" >> stee_full.csv #&
#seq -w 1 10 | xargs -n1 -P10 -I% bash -c "f % 500" > stee_500.csv
#f 03 100
