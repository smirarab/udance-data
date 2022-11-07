

python assign_int_labs.py < $1 > .t1
python assign_int_labs.py < $2 > .t2


~/compareTrees/compareTrees .t1 .t2 -simplify 2>/dev/null > ct12
~/compareTrees/compareTrees .t2 .t1 -simplify 2>/dev/null > ct21


cat ct12 | awk 'NF == 6' | cut -f1,2 | sed "s/$/\ttree1\tdisagree/g" > .t
cat ct12 | awk 'NF == 9' | cut -f1,2 | tail -n +2 | sed "s/$/\ttree1\tagree/g" >> .t

paste <(nw_distance -n .t1 `cut -f2 .t` | grep -wFf <(cut -f2 .t)) .t > ag-disag.txt

cat ct21 | awk 'NF == 6' | cut -f1,2 | sed "s/$/\ttree2\tdisagree/g" > .t
cat ct21 | awk 'NF == 9' | cut -f1,2 | tail -n +2 | sed "s/$/\ttree2\tagree/g" >> .t

paste <(nw_distance -n .t2 `cut -f2 .t` | grep -wFf <(cut -f2 .t)) .t >> ag-disag.txt

cat ct12 | awk 'NF == 9' | cut -f1,2,3,4 > agg_only.txt

#~/compareTrees/compareTrees .t2 .t1 -simplify 2>/dev/null | awk 'NF == 6' | cut -f1,2 | sed "s/$/\ttree2\tdisagree/g";


#~/compareTrees/compareTrees .t2 .t1 -simplify 2>/dev/null | awk 'NF == 6' | cut -f1,2 > dis2.txt

