filenames = ['instrfile.txt', 'initdata.txt', 'funcsymtab.txt', 'varsymtab.txt']
with open('assembledbin.out', 'w') as outfile:
    for fname in filenames:
        with open(fname) as infile:
            outfile.write(infile.read())