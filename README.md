# MetaPhlAn Microbiome Analysis

### Project Overview
This repository contains the workflow and scripts used to analyze a wastewater microbiome across four testing sites: an upstream site (UPA), a residential sewage influent site (RES), an aeration tank effluent site (ATE), and a downstream site (DSA). The goal of this project was to profile taxonomic clusters and determine microbial community similarity across these distinct environments using MetaPhlAn.

### Data Source & Preprocessing
The data used in this pipeline originates from a [2018 wastewater microbiome study](https://www.mdpi.com/2073-4441/10/11/1539). 

Samples represent water replicates collected across the four distinct sites mentioned above, with 3 replicates per site (12 samples total). Prior to taxonomic profiling, the paired-end FASTQ files underwent quality control (QC) and were pre-sampled down to 20% of their original size using `seqtk` to optimize computational runtimes. 

*Note: The abundance tables are excluded from this repository, but the raw pre-sampled FASTQ files can be accessed [here](https://drive.google.com/drive/folders/1sb9NPzA74Ghqrqp_HpOsFgo7EpieBxqZ?usp=sharing).*

### Technical Stack
* **Languages:** R, Bash
* **Sequencing Data:** Paired-end short-read data (FASTQ)
* **Tools:** MetaPhlAn (v 4.2.2), hclust2, R (pheatmap, vegan, ggplot2)
* **Infrastructure:** SLURM (High-Performance Computing cluster)

### Pipeline Workflow
Read Concatenation -> Taxonomic Profiling (MetaPhlAn) -> Table Merging -> Data Transformation & Parsing (Bash/grep/sed) -> Diversity Visualization (Heatmap & PCoA)

### Results
Starting with the raw FASTQ files, reads were profiled and merged into abundance tables, filtering specifically for genus and species level classifications. 

**Community Similarity**
Based on Bray-Curtis distance calculations, the ATE and DSA environments share highly similar microbial community structures. The Principal Coordinates Analysis (PCoA) confirmed that geographic location is the primary driver of the microbiome, with 95.2% of the total variance explained by the first two axes (PCoA 1: 52.4%, PCoA 2: 42.8%).

**Taxonomic Sparsity Metrics**
As specificity increases across taxonomic levels, the data becomes increasingly sparse.

<img width="570" height="141" alt="sparsity_metrics" src="https://github.com/user-attachments/assets/c301b1d3-b5d4-43e9-9a4c-5afe59d96e45" />

The increase in low abundance and zero values suggests that specific bacterial species are highly specialized to their local environments rather than broadly distributed.

### Limitations and Future Improvements
During the clustering analysis, it was observed that one of the replicates (UPA replicate 3) did not cluster with the other two UPA samples, suggesting there may be a technical issue or outlier problem with that specific replicate.

Future improvements to this pipeline could include:
* **Reproducibility:** Removing hardcoded local paths from the RMarkdown scripts to ensure the workflow is entirely reproducible on any machine.
* **Automation:** Consolidating the bash pipeline and the R visualization steps into a single automated workflow manager (like Nextflow).

### Repository Structure

```text

├── scripts/
│   ├── run_metaphlan.sh                     # SLURM script to merge FASTQ files and run MetaPhlAn profiling
│   └── MetaPhlAn-Microbiome-Analysis.rmarkdown # R script for generating PCoA plots, heatmaps, and sparsity tables
├── figures/
│   ├── stream_abundance_heatmap.pdf         # Heatmap of microbial genus abundances using Bray-Curtis distance
│   └── pcoa_plot.png                        # PCoA scatter plot clustering the microbial communities by location
├── MetaPhlAn-Microbiome-Analysis.pdf        # Detailed project documentation and full laboratory report
└── README.md                                # Project overview and repository guide
