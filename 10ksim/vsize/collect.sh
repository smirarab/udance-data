for i in 500 1000 2000; do 
    x=`cat sample/$i/trees/species/benchmark.txt | grep -v "rss" | cut -f1 | awk '{print int($1)*14}'`

    y=`cat sample/$i/trees/species/benchmark.txt | grep -v "rss" | cut -f3 | awk '{print int($1)*1}'`   
    printf "$x\t$y\tFT2+ASTRAL\t$i\n"

done > udance_runtime.csv
for i in 250 500 1000 2000 4000 8000 16000 32000; do 
#for i in 500 ; do 
    x=`(cat uDance/sample/1/$i/output/udance/*/*/benchmark.txt | grep -v "rss" | cut -f1 | numlist -sum | awk '{print int($1)*1}'; cat uDance/sample/1/$i/output/benchmarks/{refine,placement,placement_prep,decompose}*.txt | grep -v "rss" | cut -f1 | numlist -sum | awk '{print int($1)*14}')  | numlist -sum` 
    y=`cat uDance/sample/1/$i/output/benchmarks/{refine,placement,placement_prep,decompose}*.txt | grep -v "rss" | cut -f3 | numlist -max | awk '{print int($1)*1}'` 
    printf "$x\t$y\tuDance\t$i\n"
done >> udance_runtime.csv


for i in 250 500 1000 2000 4000 8000 16000 32000; do 
    x=`cat sample/$i/trees/species/benchmark_concat.txt | grep -v "rss" | cut -f1 | awk '{print int($1)*3}'
`
    y=`cat sample/$i/trees/species/benchmark_concat.txt | grep -v "rss" | cut -f3 | awk '{print int($1)*1}'`
   printf "$x\t$y\tconcat\t$i\n"
done >> udance_runtime.csv
