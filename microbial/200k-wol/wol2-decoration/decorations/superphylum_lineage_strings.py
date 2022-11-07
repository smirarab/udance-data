import pandas as pd
import numpy as np

t=pd.read_table("rank_names.tsv", sep='\t', header=0)
t.fillna('', inplace=True)
def sele(row):
    if row['clade']:
        return row['clade']
    return row['phylum']
t['phyprint'] = t.apply(sele, axis=1)
t=t.applymap(lambda x: x.replace(" ","_"))
def printlne(row): 
    x= row['genome'] + "\t" + "d__" + row['kingdom'] + "; p__" + row['phyprint'] + "; c__; o__; f__; g__; s__"
    print(x)
    return(x)
t['printstr'] = t.apply(printlne, axis=1)
