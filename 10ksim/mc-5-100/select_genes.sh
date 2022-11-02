
for i in `seq -w 1 10`; do 
    for j in 100 200 300 400 500; do 
        grep "$i$" ../mc-2/genetreedisc-all.csv | sort -k1n | head -n $j | tail -n 100 | cut -f3 > .t
        while read gn; do 
            ln -sf `pwd`/../mc-2/estaln/alignments/$i/$gn/output_alignment_masked.fasta uDance/hgt/$j/$i/alignments/$gn.fasta
        done < .t
        rm .t
    done
done
