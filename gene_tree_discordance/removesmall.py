import sys

smalls = set()
for line in open(sys.argv[1]).readlines():
    leaves, cluster, gene = line.strip().split()
    if int(leaves) < 7:
        smalls.add(cluster+"-"+gene)

for line in open(sys.argv[2]).readlines():
    x= line.strip().split()
    cluster, gene = x[-2:]
    if cluster+"-"+gene in smalls:
        pass
    else:
        print(line.strip())
