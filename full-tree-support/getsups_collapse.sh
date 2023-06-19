for i in {0..100}; do x=`python -c "print($i/100)"`; nw_ed 16k/06-12-2022-16k-v4-loof-backbonenextiter.nwk.rt "i & b <= $x" o | nw_stats - | grep -A 1 "leaves" | awk '{print $2}' | tr '\n' '\t' | sed "s/$/\t$x\n/g"; done | sed "s/$/\t16k/g" > subs_collapse.csv

for i in {0..100}; do x=`python -c "print($i/100)"`; nw_ed 200k/06-26-2022-200K-udance-astral-bl-5-17-2-rt.nwk "i & b <= $x" o | nw_stats - | grep -A 1 "leaves" | awk '{print $2}' | tr '\n' '\t' | sed "s/$/\t$x\n/g"; done | sed "s/$/\t200k/g" >> subs_collapse.csv
