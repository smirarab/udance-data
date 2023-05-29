# M1 Arch
# M2 CPR
# M3 BAC1
# M4 BAC2


#TreeCluster.py -m max -i astral.cons.lpp.nwk -t 0.9 -o clusters.txt
#grep -wFf archsublabels.txt clusters.txt > .t ;  y=`sort -k2n .t | cut -f2 | uniq -c | sort -k1n | tail -n 1 | awk '{print $2}'`; grep "$y$" .t | cut -f1 > select_M1.txt
#grep -wFf cprsublabels.txt clusters.txt > .t ;  y=`sort -k2n .t | cut -f2 | uniq -c | sort -k1n | tail -n 1 | awk '{print $2}'`; grep "$y$" .t | cut -f1 > select_M2.txt
#grep -wFf <(nw_labels -I ordbacsubtree.nwk) clusters.txt > .t ;  y=`sort -k2n .t | cut -f2 | uniq -c | sort -k1n | tail -n 1 | awk '{print $2}'` ; grep "$y$" .t | cut -f1 > select_M3.txt
#grep -wFf <(nw_labels -I ordbacsubtree.nwk) clusters.txt > .t ;  y=`sort -k2n .t | cut -f2 | uniq -c | sort -k1n | tail -n 2 | head -n 1 | awk '{print $2}'`; grep "$y$" .t | cut -f1 > select_M4.txt
#
#mkdir -p indeldir
#touch indeldir/control.txt
#for i in {1..4}; do
#    faSomeRecords concat.fa select_M${i}.txt M${i}_concat.fa
#    python countfreq.py < M${i}_concat.fa > M${i}.txt
#done
#
## at this point we created M1 ... M4.txt
#
##python model_assigner.py < trees.txt
#python model_assigner.py /mirarablab_data/balaban/udance/10ksim/mc-2/sim/model-0.5_0.5-5.5/01/control.txt 100
#snakemake --profile /mirarablab_data/balaban/udance/10ksim/vsize/uDance/calab_profile all
#rm indeldir/*/*_TRUE.fas
for al in `ls indeldir/*/*.fas | grep -v "TRUE"`; do
	python add_gaps.py $al 42 > ${al}.gap
done
