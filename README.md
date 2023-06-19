# Postprocessing data for article: Generation of accurate, expandable phylogenomic trees with uDANCE

The postprocessing data after generating 16K and 200k microbial trees is located in this repository. All the input files and intermediate files generated during the tree inference is hosted at Harvard Dataverse. 

Balaban, Metin; Jiang, Yueyu; Zhu, Qiyun; McDonald, Daniel; Knight, Rob; Mirarab, Siavash, 2023, "Data for article: Generation of accurate, expandable phylogenomic trees with uDANCE", https://doi.org/10.7910/DVN/BCUM6P, Harvard Dataverse, DRAFT VERSION 

The four archives that correspond to the 16k and 200k trees are `16K.tar.xz`, `200K-ALNS-1.tar`, `200K-ALNS-2.tar`, `200K.tar.xz`. The input sequence and alignment files for the entire RefSeq snapshot (which contains ~650k genomic sequences) are under eleven archives with names `650K-*.tar.gz`.

All simulated data is hosted at Harvard Dataverse.

## Repository contents

All the following postprocessing data is regarding the 16K and 200k trees unless stated otherwise

- Published phylogenies:
    - `trees/06-26-2022-200K-udance-astral-bl-5-17-2-rt.nwk` : the 200k tree
    - `trees/06-12-2022-16k-v4-loof-backbonenextiter.rt.nwk` : the 16k tree
- `agreeing_root_distance` : depth and length of agreeing and disagreeing branches
- `full-tree-support` : branch support ECDF data
- `gene_tree_discordance` : gene tree discordance between 16K species tree and gene trees (per partition)
- `level-bl` : Branch lengths of the first few levels of branches in a 16K simulated and biological datasets
- `localpp` : comparison of branch support versus partition diveristy
- `ncbi-group-compare`: quartet distance between NCBI superphyla across 10K, 16K, 200K, and gtdb taxonomies
- `parwise_distance_dot`: pairwise distances between select subsample of species from different domains
- `quartet-support-estimate` : full ASTRAL "-t 2" annotation for the 16k tree 
- `cpureport.txt` : CPU use statistics
- `lgrates_all.csv` : inferred LG AA model parameters for all partitions
- `README.md`

- Taxonomy decoration
    - `wol2-decoration/WoL_GG2_trees/decorations/run.sh` : taxonomy decoration script (it uses t2t)
    - `wol2-decoration/WoL_GG2_trees/decorations/gtdb_tax_207_spacedelim_edited.tsv` : GTDB taxonomy
    - `wol2-decoration/WoL_GG2_trees/decorations/archaea.ids` : this is used to root the phylogeny
    - `wol2-decoration/WoL_GG2_trees/decorations/arbitrary_bacteria.txt` : also used to root the phylogeny
    - `wol2-decoration/WoL_GG2_trees/decorations/06-26-2022-200K-udance-astral-bl-5-17-2-rt.nwk_gtdb_tax_207_spacedelim_edited.tsv/` : decoration of the 200K the using GTDB taxonomy.
    - `wol2-decoration/WoL_GG2_trees/decorations/06-12-2022-16k-v4-loof-backbonenextiter.nwk_gtdb_tax_207_spacedelim_edited.tsv/` :  decoration of the 16K tree using GTDB taxonomy.
    - `wol2-decoration/WoL_GG2_trees/decorations/astral.lpp.nwk.astralbl_gtdb_tax_207_spacedelim_edited.tsv/` :  decoration of the 10K tree using GTDB taxonomy.
    - `wol2-decoration/WoL_GG2_trees/decorations/fetched_taxids/superphylum_lineage_strings.txt` : NCBI taxonomy
    - `wol2-decoration/WoL_GG2_trees/decorations/fetched_taxids/gtdb_combined_full.nwk` : GTDB phylogeny r207, Archaea and Bacteria combined
    - `wol2-decoration/WoL_GG2_trees/decorations/fetched_taxids/06-26-2022-200K-udance-astral-bl-5-17-2-rt.nwk_superphylum_lineage_strings.txt/` : decoration of the 200K the using NCBI taxonomy.
    - `wol2-decoration/WoL_GG2_trees/decorations/fetched_taxids/06-12-2022-16k-v4-loof-backbonenextiter.nwk_superphylum_lineage_strings.txt/` : decoration of the 16K the using NCBI taxonomy.
    - `wol2-decoration/WoL_GG2_trees/decorations/fetched_taxids/astral.lpp.nwk.astralbl_superphylum_lineage_strings.txt/` : decoration of the 10K the using NCBI taxonomy.
    - `wol2-decoration/WoL_GG2_trees/decorations/fetched_taxids/gtdb_combined_full.nwk_superphylum_lineage_strings.txt/` : decoration of the GTDB the using NCBI taxonomy.
    - `wol2-decoration/WoL_GG2_trees/decorations/fetched_taxids/run.sh` : taxonomy decoration script (it uses t2t)
    - `wol2-decoration/WoL_GG2_trees/decorations/fetched_taxids/consistency_results_fulltaxdump_clean.tsv` : NCBI taxonomy consistency results for all four phylogenies
    - `wol2-decoration/WoL_GG2_trees/decorations/fetched_taxids/rank_names.tsv.xz` : NCBI rank names for all the ~650k sequences in the RefSeq release
    - `wol2-decoration/WoL_GG2_trees/decorations/fetched_taxids/rank_tids.tsv.xz` : NCBI rank ids for all the ~650k sequences in the RefSeq release
    - `wol2-decoration/WoL_GG2_trees/decorations/superphylum_lineage_strings.py` : creates superphylum lineage strings
    - `wol2-decoration/WoL_GG2_trees/decorations/taxdump_to_ranks.py` : taxdump to rank ids
    - `wol2-decoration/WoL_GG2_trees/decorations/shrink_taxdump.py` : auxiliary

- Tree visualization
    - `wol2-decoration/WoL_GG2_trees/decorations/main_tree_generation/generate_main_tree.py` : this scripts takes a rooted phylogeny and taxonomy decoration string. It creates main.nwk, a contracted tree. It also creates visualization extensions, such as colored_ranges.txt, color_map.txt, leaf_background.txt, and leaf_colors.txt automatically. The scripts has some hard-coded parameters, which should be tuned based on the size of the input tree. Drag main.nwk on iTol web interface first, then drag the extensions one by one.
    - `wol2-decoration/WoL_GG2_trees/decorations/main_tree_generation/command.sh` : shows how to run generate_main_tree.py
    - `wol2-decoration/WoL_GG2_trees/decorations/main_tree_generation/main.nwk` :  phyla-collapsed 16k tree
    - `wol2-decoration/WoL_GG2_trees/decorations/main_tree_generation/colored_ranges.txt` :  assignes clades colors based on their phyla
    - `wol2-decoration/WoL_GG2_trees/decorations/main_tree_generation/leaf_background.txt` : background color for paraphyletic groups in the 16k tree
    - `wol2-decoration/WoL_GG2_trees/decorations/main_tree_generation/leaf_colors.txt` : leaf name color (black vs grey) for the 16k tree
    - `wol2-decoration/WoL_GG2_trees/decorations/main_tree_generation/color_map.txt` : legend colors for all trees
    - `wol2-decoration/WoL_GG2_trees/decorations/main_tree_generation/200k/` : directory that contains the same files for the 200k tree visualization
    - `wol2-decoration/WoL_GG2_trees/decorations/main_tree_generation/10k/` : directory that contains the same files for the 10k tree visualization
