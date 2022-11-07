import sys
import treeswift as ts
from pathlib import Path


def balstr(arr):
    #if len(arr) == 3:
    #    return "(%s:0,(%s:0,%s:0):0)" % (arr[0], arr[1], arr[2])
    #elif len(arr) == 2:
    #    return "(%s:0,%s:0)" % (arr[0], arr[1])
    if len(arr) == 1:
        return arr[0]
    else:
        x = balstr(arr[0:len(arr)//2])
        y = balstr(arr[len(arr)//2:])
        return "(%s:0,%s:0)0.33" % (x, y)



def expand_dedupe_balanced(treestr,dups):
    for i in dups:
        if len(i) >= 2:
            if treestr.find("("+i[0]+":") != -1:
                ex = "(" + balstr(i) + ":"
                treestr = treestr.replace("("+i[0]+":", ex, 1)
            elif treestr.find(","+i[0]+":") != -1:
                ex = "," + balstr(i) + ":"
                treestr = treestr.replace(","+i[0]+":", ex, 1)
    return treestr


treefile = sys.argv[1]
dupmap_file = sys.argv[2]


if Path(dupmap_file).is_file():
    dmp = list(map(lambda x: x.strip().split("\t"), open(dupmap_file).readlines()))
    print(expand_dedupe_balanced(open(treefile).readlines()[0],dmp))

else:
    t = ts.read_tree_newick(treefile)
    t.resolve_polytomies()
    print(str(t))
