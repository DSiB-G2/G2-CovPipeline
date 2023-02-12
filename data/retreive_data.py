import os

path_name = "FastqExamples"
extension = ".tar.gz"
target_path = "../../../../../local/work/FastqModuleDSiB/" + path_name + extension

#copy files
os.system("cp " + target_path + " .")

#unpack
os.system("tar -xf "+ path_name + extension + " --strip-components 1")
#os.system("tar -xf "+ path_name + extension)


#get all compressed fastq files
compressed_fastq_files = []
for files in os.listdir():
    if files.endswith(".fastq.gz"):
        compressed_fastq_files.append(files)

print(compressed_fastq_files)

#uncompressed compressed fastq files
for i in range(len(compressed_fastq_files)):
    if not compressed_fastq_files[i].startswith("._"):
        os.system("gzip -d "+ compressed_fastq_files[i])


#clean up
#delete parent gz
os.system("rm "+ path_name + extension)
#delete compressed fastqfiles
for i in range(len(compressed_fastq_files)):
    os.system("rm "+ compressed_fastq_files[i])

print("FINISHED!!!")