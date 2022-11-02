TMPDIR=/dev/shm
PATH=$PATH:`echo ~`/compareTrees


f(){
    rep=$1
    size=$2
            x=$(~/tools/qd-rf.sh /panfs/mebalaba/hgt/mc-2/sim/model-0.5_0.5-5.5/$rep/s_tree.trees uDance/hgt/$size/$rep/output/udance.maxqs.nwk)
            y=$(~/tools/qd-rf.sh /panfs/mebalaba/hgt/mc-2/sim/model-0.5_0.5-5.5/$rep/s_tree.trees estaln/trees/$size/$rep/astral-mp.nwk)
            z=$(~/tools/qd-rf.sh /panfs/mebalaba/hgt/mc-2/sim/model-0.5_0.5-5.5/$rep/s_tree.trees concat/$size/$rep/fasttree.nwk)
            printf "$rep\t100\t$x\t$y\t$z\t$size\n" | tr ' ' '\t'
}
export -f f

rm -f stee_full.csv
touch stee_full.csv
for i in 100 200 300 400 500; do 
    seq -w 1 10 | xargs -n1 -P4 -I% bash -c "f % $i" >> stee_full.csv #&
done
#seq -w 1 10 | xargs -n1 -P10 -I% bash -c "f % 500" > stee_500.csv
#f 01 100
