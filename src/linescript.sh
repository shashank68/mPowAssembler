grep -n ".data" $1 | cut -f1 -d: > linedet.txt
grep -n ".text" $1 | cut -f1 -d: >> linedet.txt
