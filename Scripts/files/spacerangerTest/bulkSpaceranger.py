import subprocess
import sys
import os 

def bash_command(command):
    """
    Function to execute bash commands. NOTE: Return value is in binary. Needs to be decoded to use as a string
    
    @param command: a string containing the command to input
    @return: the output from the function in binary
    """
    result = subprocess.check_output(command, shell=True) # executes command in terminal
    return result

def get_path():
    # defining the path 
    try:
        path = sys.argv[1]
    except IndexError:
        path = os.getcwd()
    return path

def load_modules():
    bash_command("module load bioinfo-tools")
    bash_command("module load spaceranger")

def main():

    pathSource = get_path()

    ref = "/sw/data/Chromium/spaceranger-data/2020-A/refdata-gex-GRCh38-2020-A"

    for slide in os.listdir(pathSource):
        if "V" in slide and slide != "bulkSpaceranger.py":
            gprfile = "{}/{}/{}.gpr".format(pathSource, slide, slide)
            for sample in os.listdir(slide):
                if "_A" in sample or "_B" in sample or "_C" in sample or "_D" in sample:
                    sampleID = "{}".format(sample)
                    fastq = "{}/{}/{}/raw_data".format(pathSource, slide, sample)
                    jpeg = subprocess.getoutput("realpath {}/{}/images/*.jpg".format(slide, sample)) 
                    area = sampleID[-1]
                    sbatchString = "#!/bin/bash\n \
\
\n#SBATCH -A sens2020609\n \
#SBATCH -p core\n\
#SBATCH -n 8\n\
#SBATCH -t 4:00:00\n\
#SBATCH -J ST_{} \n\
#SBATCH -o result_%ST_{}.out\n\
#SBATCH -e result_%ST_{}.err\n\
#SBATCH --mail-user=rasha.fahad.a.aljelaify@ki.se\n\
#SBATCH --mail-user=marcos.abreu.machado@stud.ki.se\n\
#SBATCH --mail-type=All\n\
\
\nmodule load bioinfo-tools spaceranger/1.2.0\n\
\
\nFASTQ={}\n\
SAMPLEID={}\n\
JPEG={}\n\
SLIDE={}\n\
AREA={}1\n\
REF={}\n\
gprfile={}\n\
\
\n#Run spaceranger\n\
spaceranger count --id=$SAMPLEID \\\n\
        --fastqs=$FASTQ \\\n\
        --transcriptome=$REF \\\n\
        --sample=$SAMPLEID \\\n\
        --image=$JPEG \\\n\
        --slide=$SLIDE \\\n\
        --area=$AREA \\\n\
        --slidefile=$gprfile"

                    shString = sbatchString.format(sampleID, sampleID, sampleID, fastq, sampleID, jpeg, slide, area, ref, gprfile)
                    shFile = "sbatchspaceranger_{}.sh".format(sampleID[7:])
                    writePath = "{}/{}/output_data/{}".format(slide, sample, shFile)
                    shFileWriter = open(writePath, "w")
                    shFileWriter.write(shString)
                    shFileWriter.close()
                
if __name__ == "__main__":
    main()
