mkdir -p estaln/trees/{100,200,300,400,500}/{01,02,03,04,05,06,07,08,09,10}
for i in {100,200,300,400,500}; do for j in {01,02,03,04,05,06,07,08,09,10}; do ls  uDance/hgt/$i/$j/alignments/ | xargs -n1 basename | sed "s/.fasta//g" | sed -e "s/^/..\/mc-2\/estaln\/alignments\/$j\//g" -e "s/$/\/fasttree.nwk/g" | xargs cat > estaln/trees/$i/$j/estimatedgenetrees; done; done
