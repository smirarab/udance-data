#!/usr/bin/env bash

TMPDIR=/dev/shm

f() {
	subs=$1
	TMPTR=`mktemp -t tmptrXXXXXX`
	ls wol2/output/udance/$subs/*/bestTree.nwk | while read tr; do
        expanded=`dirname $tr`/raxml.expanded.nwk
        if [ -f "$expanded" ] ; then
            dupmap=`dirname $tr`/dupmap.txt

            python add_dups.py $tr $dupmap | nw_prune - `cat $contbath` > $TMPTR 2>/dev/null
            dco=`nw_stats $TMPTR | grep "dichotomies" | awk '{print $2}'`
            if [ "$dco" -gt "0" ] ; then
                python -c "import treeswift as ts; t=ts.read_tree_newick(\"$TMPTR\"); t.suppress_unifurcations(); print(t)"
            fi
        else
            :
        fi
	done > wol2/output/udance/$subs/astral_input_uncontracted.trees
    rm $TMPTR
}

export -f f

export contbath=q_and_ref_contams.txt

cat redo_subs.txt | xargs -n1 -P10 -I% bash -c "f %"
#printf "18\n30\n" | xargs -n1 -P16 -I% bash -c "f %"
