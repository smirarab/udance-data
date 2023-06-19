import treeswift as ts
import sys

# 1=origin 2=destination
t1 = ts.read_tree_newick(sys.argv[1])
t2 = ts.read_tree_newick(sys.argv[2])
for i,j in zip(t1.traverse_postorder(internal=True, leaves=False),t2.traverse_postorder(internal=True, leaves=False)):
    if not i.is_root() and hasattr(i,"label"):
        j.label = i.label
print(t2)

