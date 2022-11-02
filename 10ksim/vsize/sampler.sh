

get_seeded_random()
{
  seed="$1"
  openssl enc -aes-256-ctr -pass pass:"$seed" -nosalt \
    </dev/zero 2>/dev/null
}
seed=42
#seed=42

for rep in {10..19}; do
#for rep in 10; do
    tseed=$((seed+rep))
    nw_labels -I sim/model-0.5_0.5-5.5/1/s_tree.trees | sort --random-source=<(get_seeded_random $tseed) -R > lab_shuf.txt
    for i in 250 500 1000 2000 4000 8000; do 
    #for i in 500; do 
        mkdir -p sample/$rep/$i/alignments
        head -n $i lab_shuf.txt > sample/$rep/$i/seqs.txt
        nw_prune -v sim/model-0.5_0.5-5.5/1/s_tree.trees `cat  sample/$rep/$i/seqs.txt` > sample/$rep/$i/true.nwk
        for j in `seq -w 1 100`; do 
            seqkit grep -f sample/$rep/$i/seqs.txt sim/model-0.5_0.5-5.5/1/${j}.fas -w 0 > sample/$rep/$i/alignments/${j}.fasta
        done
        sed "s/sample\/$i/sample\/$rep\/$i/g" sample/1/$i/config.yaml > sample/$rep/$i/config.yaml
    echo "$i $rep done"
    done
done
    

