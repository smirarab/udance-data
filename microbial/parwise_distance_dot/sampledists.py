#!/usr/bin/env python3

import treeswift as ts
import sys
import random
random.seed(42)

num_sample={"archaea":100,"cpr":50,"noncpr":150}



t1 = ts.read_tree_newick(sys.argv[1])
t2 = ts.read_tree_newick(sys.argv[2])

t1l = set(list(t1.labels()))
t2l = set(list(t2.labels()))
tint = t1l.intersection(t2l)

labsets = dict()
for i in num_sample.keys():
    with open("%s.ids" % i, "r") as f:
        labsets[i] =  set(list(map(lambda x: x.strip(), f.readlines())))

for i in num_sample.keys():
    print(len(labsets[i]))

sampled_memb = dict()
sampled = []
for i in num_sample.keys():
    smp = random.sample(list(labsets[i].intersection(tint)), num_sample[i])
    sampled += smp
    sampled_memb.update( dict(zip(smp, [i]*num_sample[i])))

t1dm = t1.extract_tree_with(sampled).distance_matrix(leaf_labels=True)
t2dm = t2.extract_tree_with(sampled).distance_matrix(leaf_labels=True)
print(len(t1dm), len(t2dm))
with open("treedistcomp_sampled.csv", "w") as f:
    for ni, i in enumerate(sampled):
        for nj, j in enumerate(sampled):
            if ni <= nj:
                continue
            f.write(sampled_memb[i] + "\t" + sampled_memb[j] + "\t" + "%.4f" % t1dm[i][j] + "\t" + "%.4f" % t2dm[i][j] + "\t" +  i + "\t" + j + "\t" + "\n" )  
