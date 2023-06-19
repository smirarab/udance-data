ls /panfs/mebalaba/gg2/uDance/gg2/output/udance/*/*/bestTree.nwk | cut -f9,10 -d '/' | tr '/' '\t' | while read a b; do nw_stats /panfs/mebalaba/gg2/uDance/gg2/output/udance/$a/$b/bestTree.nwk | grep "dic" | cut -f2 | sed "s/$/\t$a\t$b/g"; done > numleaves.txt


