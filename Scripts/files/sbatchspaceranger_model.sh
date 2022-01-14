#!/bin/bash

#SBATCH -A sens2020609
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 4:00:00
#SBATCH -J ST_V10F03-033_A 
#SBATCH -o result_%ST_V10F03-033_A.out
#SBATCH -e result_%ST_V10F03-033_A.err
#SBATCH --mail-user=rasha.fahad.a.aljelaify@ki.se
#SBATCH --mail-user=marcos.abreu.machado@stud.ki.se
#SBATCH --mail-type=All

module load bioinfo-tools spaceranger/1.2.0

FASTQ=/castor/project/proj_nobackup/wharf/rasha/rasha-sens2020609/ST/ST/V10F03-033_S8/V10F03-033-A/raw_data
SAMPLEID=V10F03-033_A
JPEG=/castor/project/proj_nobackup/wharf/rasha/rasha-sens2020609/ST/ST/V10F03-033_S8/V10F03-033-A/images/201210_BC_V10F03-033_S8C-T_RJ.A1-Spot000001.jpg
SLIDE=V10F03-033
AREA=A1
REF=/sw/data/Chromium/spaceranger-data/2020-A/refdata-gex-GRCh38-2020-A
gprfile=/castor/project/proj_nobackup/wharf/rasha/rasha-sens2020609/ST/ST/V10F03-033_S8/V10F03-033.gpr

#Run spaceranger
spaceranger count --id=$SAMPLEID \
        --fastqs=$FASTQ \
        --transcriptome=$REF \
        --sample=$SAMPLEID \
        --image=$JPEG \
        --slide=$SLIDE \
        --area=$AREA \
        --slidefile=$gprfile
        
        
