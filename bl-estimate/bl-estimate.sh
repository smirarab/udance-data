#!/usr/bin/env bash

# $1 species tree topology

cat $2 > allgenetrees.nwk

nw_labels -I $1 > /dev/shm/specieslabs.txt

#while read tr; do 
#    echo $tr | nw_prune -v - `cat /dev/shm/specieslabs.txt` > /dev/shm/nextreeinline.nwk 
#    dco=`nw_stats /dev/shm/nextreeinline.nwk | grep "dichotomies" | awk '{print $2}'` 
#    if [ "$dco" -gt "0" ] ; then 
#        python -c 'import treeswift as ts; t=ts.read_tree_newick("/dev/shm/nextreeinline.nwk"); t.suppress_unifurcations(); print(t)' 
#    fi 
#done < allgenetrees.nwk > inducedtrees.nwk
cp allgenetrees.nwk inducedtrees.nwk
pwdd=`echo ~`
java -Xmx500G -D"java.library.path=$pwdd/ASTRAL/lib/" -jar $pwdd/ASTRAL/astralmp.5.17.2.jar -u -q $1 -i inducedtrees.nwk -C -T 32 -o $1.astralbl > astral.out 2> astral.err
