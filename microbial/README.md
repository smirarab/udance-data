### microbial dataset

The dataset includes the data and the result for generating the 16k and 200k tree in the manuscript.

Explanation of the folders:

* 16k-wol: 16k data

* 200k-wol: 200k data and the decoration for all trees (including the 10k, 16k, 200k, gtdb, etc.)

* agreeing_root_distance: the depth of agreeing and disagreeging branches between uDance trees.

* bl-estimate: branch length reestimation of the udance trees using astral without the divide and conquer approach

* cpureport.txt: running time and memory stats

* gene_tree_discordance: gene tree species tree discordance analysis

* lgrates_all.csv: LG+G4 model rate parameters inferred by raxml-ng for all gene trees in all partitions

* localpp: ASTRAL local posterior probabilities inferred for the udance trees

* ncbi-group-compare: computation of quartet distance between ncbi superphyla groups for 10k, 16k, 200k, and gtdb trees

* parwise_distance_dot: pairwise distances between selected cpr, archaea and non-cpr genomes  dot plot (unpublished)

* quartet-support-estimate: ASTRAL full internal node annotation (-t 2)  for udance trees. 

* zero-bl-clusters:  Local posterior probability versus the diversity (average branch length) of all 78 partitions in the 200k tree.
