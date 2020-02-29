filenames = ['instrfile.txt', 'initdata.txt', 'funcsymtab.txt', 'varsymtab.txt']
ln = open('sizedata.txt', 'r')
lidata = ln.readlines()

with open('assembledbin.out', 'w') as outfile:
    for size in lidata:
        n = size.strip()
        outfile.write(n + " ")
    outfile.write("\n")
    for fname in filenames:
        with open(fname) as infile:
            outfile.write(infile.read())
ln.close()
    