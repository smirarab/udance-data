import treeswift as ts
import sys
import random
import os

# $1 the original control file that uses GTR model
# $2 the first N genes to tranform

random.seed(2452)
keep = 0.95

# assign 4 models to each node in the tree
def transform(t):
    for e in t.traverse_preorder():
        if e.is_root():
            e.edge_length=random.choice([1,2,3,4])
            continue
        if random.random() >= keep:
            e.edge_length=random.choice([i for i in [1,2,3,4] if i!=e.parent.edge_length])
        else:
            e.edge_length=e.parent.edge_length
    return t

def wri(spath,control):
    with open(spath,'r') as f:
        for line in f:
            control.write(line)


numtrees = int(sys.argv[2])
trees = []
treelines = []
lendic = dict()
with open(sys.argv[1], "r") as f:
    for line in f.readlines():
        if line.startswith("[TREE]"):
            treelines.append(line)
            _, name, nwkstr = line.strip().split()
            trees.append((name,nwkstr))
        if line.startswith("[PARTITIONS]"):
            _, name, _, _, length = line.strip().split()
            lendic[name] = int(length.replace("]",""))


for i in range(numtrees):
    os.mkdir("indeldir/%d" % (i+1))
   # open both files
    with open('indeldir/%d/control.txt' % (i+1) ,'a') as control:
        wri('header.txt',control)
        for j in [1,2,3,4]:
            wri("M%d.txt" % j, control)
        print(treelines[i],file=control)

        name = trees[i][0]
        treeX = ts.read_tree_newick(trees[i][1])

        print("[BRANCHES]\tB"+str(i+1) + "\t" + str(transform(treeX)).replace(":"," #MOD"), file=control)

        print("[PARTITIONS] P%d [%s B%d %d]" % (i+1,name,i+1,lendic[name]),file=control)

        print("[EVOLVE] ", end="",file=control)

        print("P%d 1 %s" % (i+1,trees[i][0][1:]),file=control)

