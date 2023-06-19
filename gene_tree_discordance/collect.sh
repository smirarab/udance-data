#!/usr/bin/env bash


export st=$1
#export DIR=/panfs/mebalaba/gg2/uDance/gg2/output/udance
export DIR=$2

f(){
   bash qd-rf.sh $st $DIR/$1/$2/bestTree.nwk | sed "s/$/\t$1\t$2/g" 
}

export -f f


for i in {0..19}; do
    ls -d $DIR/13/*/| xargs -n1 basename | while read gn; do
    printf "f $i $gn\n"
    done
done | xargs -n1 -P32 -I % bash -c "%" > collected_gtd.csv
