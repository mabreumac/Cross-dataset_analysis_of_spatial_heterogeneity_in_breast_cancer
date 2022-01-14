#!/bin/bash

#SBATCH -A sens2020609
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 1:00:00
#SBATCH -J MAKE_TRIMMING
#SBATCH --mail-user=marcos.abreu.machado@stud.ki.se
#SBATCH --mail-type=All

SAMPLE=$1
SLIDE=${SAMPLE::-2}

echo IMPORTANT: make sure "TSO_polyA_trimming.sh" is in the working directory

echo creating new directory "${SAMPLE}_trimmed"
mkdir ${SAMPLE}_trimmed
mkdir ${SAMPLE}_trimmed/output_data
echo copying "/castor/project/proj/main_folder/ST/ST/${SLIDE}/${SAMPLE}/raw_data" to "${SAMPLE}_trimmed/"
cp -R /castor/project/proj/main_folder/ST/ST/${SLIDE}/${SAMPLE}/raw_data ${SAMPLE}_trimmed/
echo finished!
echo copying images...
cp -R /castor/project/proj/main_folder/ST/ST/${SLIDE}/${SAMPLE}/image* ${SAMPLE}_trimmed/
echo finished!
echo copying ".gpr"...
cp /castor/project/proj/main_folder/ST/ST/${SLIDE}/*.gpr ${SAMPLE}_trimmed/
echo finished!

echo initiating trimming...
echo loading modules "bioinfo-tools" and "cutadapt"
module load bioinfo-tools cutadapt

cp TSO_polyA_trimming.sh ${SAMPLE}_trimmed/raw_data/
for file in ${SAMPLE}_trimmed/raw_data/*R2*
do ./TSO_polyA_trimming.sh $file
done

rm ${SAMPLE}_trimmed/raw_data/TSO_polyA_trimming.sh
for f in ${SAMPLE}_trimmed/raw_data/*R2*_TSO_and_polyA_filtered*; do newname=$( echo $f | sed -r 's/_TSO_and_polyA_filtered//' ); mv $f $newname; done

echo creating new SBATCH script for job submission...

FASTQ=/castor/project/proj_nobackup/wharf/rasha/rasha-sens2020609/ST/ST/${SAMPLE}_trimmed/raw_data
SAMPLEID=$SAMPLE
JPEG=$(realpath ${SAMPLE}_trimmed/images/*)
SLIDE=$SLIDE
AREA=${SAMPLE: -1}1
REF=/sw/data/Chromium/spaceranger-data/2020-A/refdata-gex-GRCh38-2020-A
gprfile=$(realpath ${SAMPLE}_trimmed/*.gpr)

echo "#!/bin/bash

#SBATCH -A sens2020609
#SBATCH -p core
#SBATCH -n 16
#SBATCH -t 12:00:00
#SBATCH -J ST_${SAMPLE}_TRIMMING
#SBATCH -o result_%ST_${SAMPLE}_TRIMMING.out
#SBATCH -e result_%ST_${SAMPLE}_TRIMMING.err
#SBATCH --mail-user=marcos.abreu.machado@stud.ki.se
#SBATCH --mail-type=All

module load bioinfo-tools spaceranger/1.0.0

#Run spaceranger
spaceranger count --id=$SAMPLEID --fastqs=$FASTQ --transcriptome=$REF --sample=$SAMPLEID --image=$JPEG --slide=$SLIDE --area=$AREA --slidefile=$gprfile" >> ${SAMPLE}_trimmed/output_data/sbatchspaceranger_$

