filenames = ['file1.txt', 'file2.txt', 'file3.txt']
with open('output_file', 'w') as outfile:
    for fname in filenames:
        with open(fname) as infile:
            outfile.write(infile.read())