import  treeswift as ts
import sys

t = ts.read_tree_newick(sys.argv[1])
lens_int=[]
lens_all=[]
for e in t.traverse_postorder(internal=True,leaves=False):
    if e.is_root():
        continue
    lens_int.append(e.edge_length)
avint=sum(lens_int)/len(lens_int)
for e in t.traverse_postorder(internal=True,leaves=True):
    if e.is_root():
        continue
    lens_all.append(e.edge_length)
avall=sum(lens_all)/len(lens_all)
levratios=dict()
for i in range(1,6):
    levratios[i]=[]
def find_level(e):
    if e.is_root():
        return 0
    else:
        return 1+find_level(e.parent)
for e in t.traverse_levelorder(internal=True,leaves=False):
    lev = find_level(e)
    if lev > 5:
        break
    if lev in levratios:
        levratios[lev].append(e.edge_length)

for k,v in levratios.items():
    for b in v:
        print("%d\t%.4f\tinternal"%(k,b/avint))
        print("%d\t%.4f\tall"%(k,b/avall))


