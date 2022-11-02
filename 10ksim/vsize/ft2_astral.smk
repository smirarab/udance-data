
# 001, 002, ... 500
GENES=["{:03d}".format(number) for number in range(1,101)]
# 001, 002, ... 100
SIZES=[250, 500, 1000, 2000, 4000, 8000]
#SIZES=[64000]
REP=[10,11,12,13,14,15,16,17,18,19]


rule all:
    input: expand("sample/{rep}{size}/trees/species/astral-mp.nwk", size=SIZES,rep=REP)

rule concatenation:
    input: expand("sample/{rep}/{size}/trees/species/concatenation.nwk", size=SIZES,rep=REP)

rule concat_and_ft:
    input: expand("sample/{{rep}}/{{size}}/alignments/{gene}.fasta", gene=GENES)
    output: "sample/{rep}/{size}/trees/species/concatenation.nwk"
    resources: cpus=14, mem_mb=120000
    benchmark: "sample/{rep}/{size}/trees/species/benchmark_concat.txt"
    shell:
        '''
            seqkit concat --quiet -w 0 {input} > sample/{wildcards.rep}/{wildcards.size}/trees/species/concat.fa
            export OMP_NUM_THREADS=3
            FastTreeMP -nt -nopr -gtr -gamma < sample/{wildcards.rep}/{wildcards.size}/trees/species/concat.fa > {output} 2> sample/{wildcards.rep}/{wildcards.size}/trees/species/concatenation.err
        '''

rule astral_mp_ft:
    input: expand("sample/{{rep}}/{{size}}/trees/gene/{gene}/fasttree.nwk", gene=GENES)
    output: "sample/{rep}/{size}/trees/species/astral-mp.nwk"
    resources: cpus=14, mem_mb=120000
    benchmark: "sample/{rep}/{size}/trees/species/benchmark.txt"
    shell:
        '''
            pwdd=`pwd`
            cat {input} > sample/{wildcards.rep}/{wildcards.size}/trees/species/estimatedgenetrees || true
            /usr/bin/time -o sample/{{wildcards.rep}/wildcards.size}/trees/species/time.txt -f "%e\t%M" java -Xmx{resources.mem_mb}M -D"java.library.path=$pwdd/uDance/uDance/tools/ASTRAL/astralmp.5.17.2.jar" -jar $pwdd/uDance/uDance/tools/ASTRAL/astralmp.5.17.2.jar -i sample/{wildcards.rep}/{wildcards.size}/trees/species/estimatedgenetrees -C -T {resources.cpus} -o {output} > sample/{wildcards.rep}/{wildcards.size}/trees/species/astral-mp.out 2>&1
        '''

rule fasttree:
    input: "sample/{rep}/{size}/alignments/{gene}.fasta"
    output: "sample/{rep}/{size}/trees/gene/{gene}/fasttree.nwk"
    resources: cpus=3, mem_mb=20000
    benchmark: "sample/{rep}/{size}/trees/gene/{gene}/benchmark.txt"
    shell: 
        '''
            export OMP_NUM_THREADS=3
            FastTreeMP -nt -nopr -gtr -gamma < {input} > {output} 2> sample/{wildcards.rep}/{wildcards.size}/trees/gene/{wildcards.gene}/fasttree.err
        '''




#rule uppalign:
#    input: "sim/%s/{rep}/{gene}.fas.gap" % mc
#    output: "estaln/alignments/{rep}/{gene}/output_alignment_masked.fasta"
#    resources: cpus=6
#    shell:
#        ''' 
#            outdir="estaln/alignments/{wildcards.rep}/{wildcards.gene}"
#            pwdd=`pwd`
#            inpfullpath=`echo $pwdd/{input}`
#            pushd $outdir
#            ln -sf $inpfullpath ./aln.fa
#            run_upp.py -s aln.fa -B 1000 -A 100 -M 0.75 -m dna -seed 1234 -x {resources.cpus} > upp.out 2> upp.err
#            popd
#        '''
