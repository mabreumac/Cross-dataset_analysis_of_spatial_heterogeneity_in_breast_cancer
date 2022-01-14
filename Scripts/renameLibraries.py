import subprocess

### README
'''
This script is used to copy files from the NGIfile folder to the ST file folder under the structure required by spaceranger,
and it uses the .tsv file as an index to reference which fastq folder is copied to which library folder.
'''
###

# HARDCODES
NGIfile = "P21914"
STfile = "ST"
indexfile = "C.Daub_21_01_sample_information.tsv"
# HARDCODES

def bash_command(command):
    """
    Function to execute bash commands. NOTE: Return value is in binary. Needs to be decoded to use as a string
    
    @param command: a string containing the command to input
    @return: the output from the function in binary
    """
    result = subprocess.check_output(command, shell=True) # executes command in terminal
    return result

def indexParse(indexfile):

    with open(indexfile) as file:

        parsed = dict()
        next(file)
        for line in file.readlines():
            key = line.split("\t")[0]
            value = line.split("\t")[1]
            parsed[key] = value 

        return parsed

def main():
    
    index = indexParse(indexfile)
    for target in index:
        try:
            bash_command("rename {} {} ST/{}/{}/raw_data/*.gz".format(target, index[target], index[target][:-2], index[target]))
        except:
            print("The file(s) '{}'/'{}' does not exist or it is wrongly named in the index file".format(target,index[target]))
            continue
            
if __name__ == "__main__":
    main()