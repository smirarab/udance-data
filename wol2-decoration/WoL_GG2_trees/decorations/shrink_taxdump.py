#!/usr/bin/env python3
"""Shrink the standard NCBI taxdump files nodes.dmp and names.dmp so that they
only contain given TaxIDs and their ancestors.

Usage:
    shrink_taxdump.py taxon map taxdump_dir

Output:
    nodes.dmp, names.dmp taxid_reduced.map
"""

from sys import argv
from os.path import join

# read Gid and TaxIDs to be included
with open(argv[1], 'r') as f:
        g2tid = dict(x.split('\t') for x in f.read().splitlines())

# read the NCBI taxonomy tree
with open(join(argv[2], 'nodes.dmp'), 'r') as f:
    tid2pid = dict(x.replace('\t|', '').split('\t')[:2]
                   for x in f.read().splitlines())

# identify all ancestral TaxIDs
ancs = set()
remove_from_g2tid = []
for gid,tid in g2tid.items():
    if tid not in tid2pid:
        remove_from_g2tid.append(gid)
        continue
    cid = tid
    while True:
        pid = tid2pid[cid]
        if cid == pid or pid in ancs:
            break
        ancs.add(pid)
        cid = pid
print("the following id's are not in NCBI taxdump:", remove_from_g2tid)
for i in remove_from_g2tid:
    del g2tid[i]
tids = set(g2tid.values())
tids.update(ancs)

# shrink taxdump files
for stem in ('nodes', 'names'):
    fo = open('%s.dmp' % stem, 'w')
    fi = open(join(argv[2], '%s.dmp' % stem), 'r')
    for line in fi:
        x = line.rstrip('\r\n').replace('\t|', '').split('\t')
        if x[0] in tids:
            if stem == 'nodes' or 'scientific name' in x:
                fo.write(line)
    fi.close()
    fo.close()
with open("taxid_reduced.map", "w") as f:
    for k,v in g2tid.items():
        f.write(str(k) + "\t" + str(v) + "\n")
