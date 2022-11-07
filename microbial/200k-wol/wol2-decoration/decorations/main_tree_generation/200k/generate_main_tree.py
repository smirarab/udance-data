#!/usr/bin/env python3


import treeswift as ts
import re
import sys
from collections import deque

def parse_lineage_string(linfile):
    taxonomy = dict()
    with open(linfile) as f:
        for line in f.readlines():
            seq, taxx = line.strip().split("\t")
            taxonomy[seq] = [i.strip()[3:] for i in taxx.split(";")]
    return taxonomy


def assign_background(mytree, taxonomy):
    cmap = dict()
    with open("color_map.txt", "r") as cm:
        for line in cm.readlines():
            grp, col = line.strip().split(",")
            cmap[grp] = col
    for i in mytree.traverse_postorder(internal=False):
        for lev in [0,1,2,3,4]:
            lbl = re.sub("_[A-Z]$",'',taxonomy[i.label][lev])
            if lbl in cmap:
                i.bgr = lbl


def condense(mytree, taxonomy, min_level, max_level):
    '''If siblings have the same label, merge them. If they have edge lengths, the resulting ``Node`` will have the larger of the lengths'''
    labels_below = dict() 
    average_leaf_dist = dict()
    for node in mytree.traverse_postorder():
        if node.is_leaf():
            if taxonomy[node.label][min_level]:
                labels_below[node] = [re.sub("_[A-Z]$",'',taxonomy[node.label][min_level])]
            else:
                # this would not work when there is a multifurcation. imagine (A,B,"")
                labels_below[node] = set()
            average_leaf_dist[node] = (0, 1)
        else:
            labels_below[node] = set()
            acc_num = 0
            acc_av = 0
            for c in node.children:
                labels_below[node].update(labels_below[c])
                av, numb = average_leaf_dist[c]
                acc_av += (c.edge_length + av)*numb
                acc_num += numb
            average_leaf_dist[node] = (acc_av/acc_num, acc_num)
    nodes = deque(); nodes.append(mytree.root)

    while len(nodes) != 0:
        node = nodes.pop()
        if len(labels_below[node]) == 1:
            if average_leaf_dist[node][1] < 2000 or min_level == max_level:
                node.edge_length += average_leaf_dist[node][0]
                node.num_des = average_leaf_dist[node][1]
                node.label = labels_below[node].pop() #+ " {" + str(node.num_des) + "}" 
                #if node.label == "Verrucomicrobiota":
                #    import pdb; pdb.set_trace()
                node.bgr = [c.bgr for c in node.traverse_postorder(internal=False)][-1]
                #node.bgr = node.children[0].bgr
                node.children = list()
                node.rank = min_level
            else:
                large_rnk = ts.Tree()
                large_rnk.is_rooted = True
                large_rnk.root = node
                condense(large_rnk, taxonomy, min_level + 1, max_level)
        elif len(labels_below[node]) == 0:
            # needs a placeholder
            #node.label = "PLHD_l"+str(level)
            #node.edge_length += average_leaf_dist[node][0]
            #node.num_des = average_leaf_dist[node][1]
            node.parent.remove_child(node)
        else:
            nodes.extend(node.children)
    mytree.suppress_unifurcations()


def prune_small(mytree, thr):
    nodes = deque(); nodes.append(mytree.root)
    while len(nodes) != 0:
        node = nodes.pop()
        if node.is_leaf() and node.num_des <= thr and not hasattr(node, "para"):
            node.parent.remove_child(node)
        else:
            num_des_dist = [0 if (l.num_des <= thr and not hasattr(node, "para"))  else 1 for l in node.traverse_postorder(internal=False)]
            if sum(num_des_dist) == 0:
                node.parent.remove_child(node)
        
            #if node.is_leaf() and node.num_des <= thr:
            #    print(node.label)
            #    node.parent.remove_child(node)
            else:
                nodes.extend(node.children)
    mytree.suppress_unifurcations()

def manage_paraphyletic(t):
    book = dict()
    for l in t.traverse_postorder(internal=False):
        if l.label not in book:
            book[l.label] = [l]
        else:
            book[l.label] += [l]
    for k,v in book.items():
        if len(v) > 1:
            tag = 1
            for n in v:
                n.label += "_"+str(tag)
                tag += 1
                n.para=True

def add_counts_to_label(t):
    for node in t.traverse_postorder(internal=False):
        node.label += " {" + str(node.num_des) + "}"



def combine_small(mytree, thr):
    nodes = deque(); nodes.append(mytree.root)

    while len(nodes) != 0:
        node = nodes.pop()
        if node.is_leaf(): 
            continue
        else:
            num_des_dist = [0 if l.num_des <= thr else 1 for l in node.traverse_postorder(internal=False)]
            tot_num_des = sum([c.num_des for c in node.traverse_postorder(internal=False)])
            mranks = min([c.rank for c in node.traverse_postorder(internal=False)])
            xpara=False
            for c in node.traverse_postorder(internal=False):
                if hasattr(c,"para") and c.para:
                    xpara=True 
            if sum(num_des_dist) == 0 and len(num_des_dist) <= 4 and not xpara:
                tags_below = [c.label for c in node.traverse_postorder(internal=False)]
                dist_to_leaves_below = [mytree.distance_between(node,c) for c in node.traverse_postorder(internal=False)]
                node.label = "+".join(tags_below)
                node.rank = mranks
                node.num_des = tot_num_des
                node.bgr = [c.bgr for c in node.traverse_postorder(internal=False)][0]
                node.edge_length += sum(dist_to_leaves_below)/len(dist_to_leaves_below)
                for c in node.traverse_postorder(internal=False):
                    if hasattr(c,"para") and c.para:
                        node.para=True
                node.children = list()
            else:
                nodes.extend(node.children)

t = ts.read_tree_newick(sys.argv[1])
mydict=parse_lineage_string(sys.argv[2])
level = 1
assign_background(t, mydict)
condense(t,mydict, level, level+1)
manage_paraphyletic(t)
prune_small(t,0)
combine_small(t, 40)
add_counts_to_label(t)

with open("main.nwk", "w") as f:
    print(t, file=f)
totnumdes = 0
for i in t.traverse_postorder(internal=False):
    totnumdes += i.num_des
with open("leaf_colors.txt", "w") as f:
    print("TREE_COLORS\nSEPARATOR COMMA\nDATA", file=f)
    for i in t.traverse_postorder(internal=False):
        # lower rank
        if i.num_des < -40:
            sizefactor=0.000001
        else:
            sizefactor=1
        if i.rank > level:
            print("%s,label,#5b5b5b,normal,%f" % (i.label, sizefactor), file=f)
        else:
            print("%s,label,#000000,normal,%f" % (i.label, sizefactor), file=f)

with open("colored_ranges.txt", "w") as f:
    cmap = dict()
    with open("color_map.txt", "r") as cm:
        for line in cm.readlines():
            grp, col = line.strip().split(",")
            cmap[grp] = col
    print("TREE_COLORS\nSEPARATOR COMMA\nDATA", file=f)
    for i in t.traverse_postorder(internal=False):
        #if i.label.startswith("Bacteroidia"):
        #    import pdb; pdb.set_trace()
        if hasattr(i, "bgr") and i.bgr in cmap:
            print("%s,range,%s,%s" % (i.label, cmap[i.bgr], i.bgr), file=f)

with open("leaf_background.txt", "w") as f:
    print("TREE_COLORS\nSEPARATOR COMMA\nDATA", file=f)
    for c in t.traverse_postorder(internal=False):
        if hasattr(c,"para") and c.para:
            print("%s,label_background,#fceaea" % c.label, file=f)               
#print({k: mydict[k] for k in list(mydict)[:5]})
