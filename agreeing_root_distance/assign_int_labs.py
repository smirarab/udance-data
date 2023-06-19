#!/usr/bin/env python3
import treeswift as ts

t = ts.read_tree_newick(input())

counter = 0
for i in t.traverse_postorder(internal=True, leaves=False):
    i.label = "N"+str(counter)
    counter+=1
print(t)


