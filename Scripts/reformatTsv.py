filename = "/mnt/storage/Documents/Academia/Daub_Lab/ST_BRCA_Project/Scripts/C.Daub_21_01_sample_information.tsv"
outfile = "C.Daub_21_01_sample_information_edited.tsv"

with open(filename) as file:
    writer = open(outfile, "w")
    for line in file.readlines():
        line = line[::-1]
        line = line.replace("-", "_",1)
        line = line[::-1]
        writer.write(line)
    writer.close()

        