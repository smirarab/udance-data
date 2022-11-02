
for j in {19..10}; do 
    i=250 
    snakemake --configfile sample/$j/$i/config.yaml --profile calab_profile/ --snakefile udance.smk all
    cp sample/$j/$i/output/backbone.nwk sample/$j/$i/output/udance.maxqs.nwk
    for i in 500 1000 2000 4000 8000; do 
        x=$((i/2)) 
        cp sample/$j/$x/output/udance.maxqs.nwk sample/$j/$i/backbone.nwk
        snakemake --configfile sample/$j/$i/config.yaml --profile calab_profile/ --snakefile udance.smk all
    done 
done
