import os

#include: "workflows/decompose.smk"
wdr = config["workdir"]
outdir = os.path.join(wdr, "output")
alndir = os.path.join(wdr, "alignments")

udance_logpath = os.path.abspath(os.path.join(wdr, "udance.log"))

rule blinference:
    input: expand("%s/udance/{{cluster}}/astral_output.{approach}.nwk" % outdir, approach=["incremental", "updates"])
    output: expand("%s/udance/{{cluster}}/astral_output.{approach}.nwk.bl" % outdir, approach=["incremental", "updates"])
    resources: cpus=config["resources"]["cores"],
               mem_mb=config["resources"]["large_memory"]
    shell:
        '''
            pwdd=`pwd`
            for approach in incremental updates; do
                if [ -f  {outdir}/udance/{wildcards.cluster}/skip_partition ] ; then
                    cp {outdir}/udance/{wildcards.cluster}/astral_output.$approach.nwk {outdir}/udance/{wildcards.cluster}/astral_output.$approach.nwk.bl
                else
                    java -Xmx{resources.mem_mb}M -Djava.library.path=$pwdd/uDance/tools/ASTRAL/lib/ -jar $pwdd/uDance/tools/ASTRAL/astralmp.5.17.2.jar \
                        -q {outdir}/udance/{wildcards.cluster}/astral_output.$approach.nwk \
                        -i {outdir}/udance/{wildcards.cluster}/astral_input_uncontracted.trees \
                        -o {outdir}/udance/{wildcards.cluster}/astral_output.$approach.nwk.bl \
                        -C -T {resources.cpus} -u > {outdir}/udance/{wildcards.cluster}/astral.$approach.log.bl 2>&1
                fi
            done
        '''
