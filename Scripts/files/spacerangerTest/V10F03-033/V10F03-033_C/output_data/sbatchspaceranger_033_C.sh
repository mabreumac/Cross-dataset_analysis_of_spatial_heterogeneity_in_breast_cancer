#!/bin/bash
 
#SBATCH -A sens2020609
 #SBATCH -p core
#SBATCH -n 8
#SBATCH -t 4:00:00
#SBATCH -J ST_V10F03-033_C 
#SBATCH -o result_%ST_V10F03-033_C.out
#SBATCH -e result_%ST_V10F03-033_C.err
#SBATCH --mail-user=rasha.fahad.a.aljelaify@ki.se
#SBATCH --mail-user=marcos.abreu.machado@stud.ki.se
#SBATCH --mail-type=All

module load bioinfo-tools spaceranger/1.2.0

FASTQ=/mnt/storage/Documents/Academia/Daub_Lab/ST_BRCA_Project/Scripts/files/spacerangerTest/V10F03-033/V10F03-033_C/raw_data
SAMPLEID=V10F03-033_C
JPEG=/mnt/storage/Documents/Academia/Daub_Lab/ST_BRCA_Project/Scripts/files/spacerangerTest/V10F03-033/V10F03-033_C/images/img.jpg
SLIDE=V10F03-033
AREA=C1
REF=/sw/data/Chromium/spaceranger-data/2020-A/refdata-gex-GRCh38-2020-A
gprfile=/mnt/storage/Documents/Academia/Daub_Lab/ST_BRCA_Project/Scripts/files/spacerangerTest/V10F03-033/V10F03-033.gpr

#Run spaceranger
spaceranger count --id=$SAMPLEID \
        --fastqs=$FASTQ \
        --transcriptome=$REF \
        --sample=$SAMPLEID \
        --image=$JPEG \
        --slide=$SLIDE \
        --area=$AREA \
        --slidefile=$gprfile