# create output directory variable
export OUTPUTDIR=output/$1

# create output directory
rm -rf $OUTPUTDIR
mkdir -p $OUTPUTDIR

# run
Gate < gate.txt