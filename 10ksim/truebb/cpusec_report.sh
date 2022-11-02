
#$1 udance outdir

OUTDIR=$1

for i in udance; do 
    x=`grep -o -E "\-\-threads [0-9]+" $OUTDIR/$i/*/*/*/RUN.raxml.log | awk '{print $2}' | awk '{sum+=$1} END { print sum/NR}'`
    y=`grep "Elapsed" $OUTDIR/$i/*/*/*/RUN.raxml.log | awk '{print int($3)}' | awk '{sum+=$1} END { print sum}'`
    ans=$((x * y))
    printf "raxml-$i,$x,$y,$ans\n"
    y=`grep "Total wall-clock" $OUTDIR/$i/*/*/*/shrunk.fasta.log | awk '{print int($5)}' | awk '{sum+=$1} END { print sum}'`
    ans=$((x * y))
    printf "iqtree-$i,$x,$y,$ans\n"
done

#x=`grep "Starting" $OUTDIR/backbone/0/astral.incremental.log | awk '{print $2}'`
#y=`grep "ASTRAL finished" $OUTDIR/backbone/0/astral.incremental.log | awk '{print int($4)}'`
#ans=$((x * y))
#printf "ASTRAL-backbone,$x,$y,$ans\n"

#y=`grep "APPLES finished" $OUTDIR/placement/apples2.err | awk '{print int($5)}'`
#ans=$((x * y))
#printf "APPLES-2,$x,$y,$ans\n"

x=`if grep "Starting" $OUTDIR/udance/0/astral.updates.log ; then :;  else echo Starting 1; fi | awk '{print $2}'`
y=`grep "ASTRAL finished" $OUTDIR/udance/*/astral.updates.log | awk '{print int($4)}' | awk '{sum+=$1} END { print sum}'`
ans=$((2 * x * y))
printf "ASTRAL-udance,$x,$y,$ans\n"

