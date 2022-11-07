#!/usr/bin/env bash

rf=`compareTrees.missingBranch <(nw_topology -bI $1) <(nw_topology -bI $2) -simplify| awk '{print $3}'`
TMPX=`mktemp -t XXXXXX`
comm -12 <(nw_labels -I $1 | sort) <(nw_labels -I $2 | sort) > $TMPX
nl=`cat $TMPX | wc -l`
if [ "$nl" -gt "3" ] ; then
    quartet_dist -v <(nw_prune -v <(nw_topology -bI $1) `cat $TMPX`) <(nw_prune -v <(nw_topology -bI $2) `cat $TMPX`) | cut -f4 | sed "s/$/\t$rf/g"
fi
