
The importance of phylogenetic methods when comparing functional genomic data across species
============================================================================================

Dunn, Zapata, Munro, Siebert, Hejnol

Casey W. Dunn<sup>1</sup>\*, Felipe Zapata<sup>1,2</sup>, Cat Munro<sup>1</sup>, Stefan Siebert<sup>1,3</sup>, Andreas Hejnol<sup>4</sup>

<sup>1</sup> Department of Ecology and Evolutionary Biology, Brown University, Providence, RI, USA

<sup>2</sup> Current address: Department of Ecology and Evolutionary Biology, University of California Los Angeles, Los Angeles, CA, USA

<sup>3</sup> Current address: Department of Molecular & Cellular Biology, University of California at Davis, Davis, CA, USA

<sup>4</sup> Sars Institute, Bergen, Norway

\* Corresponding author, <casey_dunn@brown.edu>

Abstract
--------

Functional genomics, the study of how genomes work, is one of the most rapidly advancing fields in Biology. There is now considerable interest in comparing genome function across species to understand what is conserved, what is variable, and how the diversity of organism traits (including anatomy, physiology, and development) relates to genome diversity. Most published comparisons of genome function across species have, however, neglected to use methods that consider the evolutionary relationships among species. This has two potential negative impacts. First, it can lead to the wrong conclusions about the evolution of genome function. Second, it is a missed opportunity to learn about biology that can only be understood in an explicit historical context that considers these relationships. Here we examine two recently published comparative expression studies that used multiple pairwise comparison rather than phylogenetic approaches to investigate evolutionary patterns of gene expression. We find problems with the pairwise comparisons used in both studies that undermine their published conclusions. This is a concrete demonstration of the inadequacy of pairwise comparisons in comparative genomics studies, and indicates that it will be critical to adopt phylogenetic comparative methods in future analyses.

Introduction
------------

The focus of genomics research has quickly shifted from describing genome sequences to Functional Genomics (FG), the study of how genomes "work" using tools that measure functional attributes such as expression, chromatin state, and transcription initiation. FG, in turn, is now becoming more comparative- there is great interest in understanding how FG variation across species gives rise to a diversity of development, morphology, physiology, and other phenotypes<sup>1</sup>. Comparative Functional Genomics (CFG) analyses are also critical to transferring functional insight across species, and will grow in importance in coming years.

A rich theoretical and statistical methodology of phylogenetic comparative methods have been developed over the last three decades to address the statistical challenges and opportunities of comparisons across species \[2; Grafen:1989um; Chamberlain:2012vx; Garamszegi:2014ew; Pagel:1999gc\]. These have largely been applied to the evolution of morphological and ecological traits, but are just as relevant to CFG. Most CFG studies have abstained from phylogenetic approaches and instead heavily rely on pairwise comparisons (Fig. 1A) that do not account for the fact that evolutionary relationships explain much of the structure of variation across species. This leaves CFG studies susceptible to serious statistical errors and is a missed opportunity to ask questions that are only accessible in an explicit phylogenetic context.

One reason that CFG has not yet embraced phylogenetic approaches is that it has not yet been concretely demonstrated that pairwise and phylogenetic approaches can lead to different results in CFG. Although the value of phylogenetic approaches has been repeatedly shown in comparative analyses of other character data \[3; Ricklefs:1996wb\], this value is apparently not well known to the FG community since the field has until recently largely focused on within-species analyses. Many initial CFG studies have also been focused on only two species at a time, where the differences between phylogenetic and pairwise approaches are not as pronounced. As the number of species considered in each CFG study grows, the shortcomings of pairwise approaches will become far more acute.

Most CFG studies to date compare gene expression across species, often between distinct tissues or developmental time points. Gene expression has been a popular target of CFG studies because, with the advent of RNA-Seq, it is the most readily collected FG trait across diverse species. Here we reconsider two recent comparative analyses of gene expression data<sup>4,5</sup>.

Kryuchkova-Mostacci and Robinson-Rechavi (KMRR) 2016<sup>4</sup> integrated vertebrate expression datasets to test the ortholog conjecture - the hypothesis that orthologs tend of have more conserved attributes (expression in this case) than do paralogs<sup>6</sup>. Using pairwise comparisons (Fig. 1A), they found lower expression covariance between paralogs than between orthologs and interpreted this as strong support for the ortholog conjecture. Orthology and paralogy is annotated based on gene phylogenies, but these phylogenies are not used when making the expression comparisons.

The second CFG study we evaluate here is Levin *et al.*<sup>5</sup>. This study analyzed gene expression through the course of embryonic development for ten animal species, each from a different phylum. They concluded that animals from different phyla exhibit an "inverse hourglass" model for the evolution of gene expression, where there is more evolutionary variance in gene expression at a mid phase of development than there is at early and late phases (Fig. 2). This contrasts with the "hourglass" model previously proposed for closely related species<sup>7</sup>. Levin *et al.* conclude that this provides biological justification for the concept of phyla and may provide a definition of phyla. We previously described concerns with their interpretations of these results<sup>8</sup>. Here we directly address the analyses themselves by examining the structure of the pairwise comparisons.

![Figure Overview](Figure_overview.svg?raw=true)

> Figure 1 | Pairwise and phylogenetic comparative approaches. (a) Many comparative functional genomic studies across species rely on pairwise comparisons, where traits of each gene are compared to traits of every other gene. This leads to many more comparisons than unique observations, making each comparison non-independent. (b) Comparative phylogenetic methods, including phylogenetic independent contrasts<sup>2</sup>, make a smaller number of independent comparisons, where each contrast measures changes along different branches. Phylogenetic approaches are rarely used for functional genomics studies.

Results
-------

### KMRR Reanalysis

When we reanalyze the data with phylogenetic independent contrasts (Fig. 1B), we did not find increased evolutionary change in expression following duplication events (Fig. XX).

Of the 21124 trees that were parsed, 8947 passed taxon sampling criteria and 3739 were successfully time calibrated.

![](manuscript_files/figure-markdown_github/show_result-1.png)![](manuscript_files/figure-markdown_github/show_result-2.png)

    ## 
    ##  Wilcoxon rank sum test with continuity correction
    ## 
    ## data:  nodes_contrast %>% filter(D == "Y") %>% .$pic and nodes_contrast %>% filter(D == "N") %>% .$pic
    ## W = 119770000, p-value = 1
    ## alternative hypothesis: true location shift is greater than 0

There were 9581 duplication nodes and 31123 speciation nodes.

![](manuscript_files/figure-markdown_github/pairwise-1.png)

### Levin *et al.* reanalysis

![Figure Levin](levin_etal/Figure_levin.png?raw=true)

> Figure XXLevin | Distributions of pairwise similarity scores for each phase of development. Pairwise scores for the ctenophore are red. Wilcoxon test p-values for the significance of the differences between early-mid distributions and late-mid distributions are on the right. Model of variance, which is inversely related to similarity, is on the left. (a) The distributions as published. Low similarity (*i.e.*, high variance) in the mid phase of development was interpreted as support for an inverse hourglass model for the evolution of gene expression. The five least-similar mid phase scores were all from the ctenophore. Published KS p-values, based on duplicated data, are in parentheses. The inset ctenophore image is by S. Haddock from phylopic.org. (b) The distributions after the exclusion of the ctenophore. The early and mid phase distributions are not statistically distinct. This suggest a wine bottle model, with similar evolutionary variance at the early and mid phase and less at the late phase.

How changes in animal development relate to the evolution of animal diversity is a major question in evolutionary developmental biology (EvoDevo). To address this topic, Levin *et al.*<sup>5</sup> analyzed gene expression through the course of embryonic development for ten animal species, each from a different phylum. As their title ("The mid-developmental transition and the evolution of animal body plans") indicates, they arrived at two major conclusions. First, animal development is characterized by a well-defined mid-developmental transition. Second, this transition helps explain the evolution of features observed among distantly related animals. Specifically, they concluded that animals from different phyla exhibit an "inverse hourglass" model for the evolution of gene expression, where there is more evolutionary variance in gene expression at a mid phase of development than there is at early and late phases. Closely related animals have previously been described as having an hourglass model of gene expression, where evolutionary variance in expression is greater early and late in development than at the midpoint of development \[7; DomazetLoso:2010cn\]. Levin *et al.* conclude that this contrast between distantly and closely related animals provides biological justification for the concept of phyla and may provide a long-sought operational definition of phyla. We previously described some concerns with their interpretations of these results<sup>8</sup>.

Rather than support the inverse hourglass as a general pattern among distantly related species, our reanalyses of Levin *et al.*<sup>5</sup> indicate their existing data support the opposite conclusion - that the inverse hourglass is due to large differences specific to a single lineage, the ctenophore (comb jelly). Better understanding these differences will be of interest to future work, especially in light of current uncertainty regarding the phylogenetic placement of ctenophores and their unique biology<sup>9</sup>.

To understand our concerns with their analyses, it is helpful to first outline Levin *et al.*'s published methods and results. Although there are mature methods and tools for statistical analysis of character evolution<sup>10</sup> and gene expression<sup>11</sup>, Levin *et al.*<sup>5</sup> drew on neither of these very active areas of research and instead applied an *ad hoc* pairwise comparison of orthologous gene expression between species. They characterized each gene in each species as having expression that peaks in early, mid, or late temporal phase of development while the goodness of fit to these patterns was not considered, and alternative patterns were not evaluated. For each species pair, they then identified the orthologs shared by these species (shared orthologs vary from pair to pair). They then calculated a similarity score for each temporal phase for each species pair based on the fraction of genes that exhibited the same patterns in each species. The distributions of similarity scores are plotted in their [Figure 4d](http://www.nature.com/nature/journal/v531/n7596/fig_tab/nature16994_F4.html), and their Kolmogorov–Smirnov (KS) tests indicated that the early distribution and late distribution were each significantly different from mid distribution (P &lt; 10<sup>-6</sup> and P &lt; 10<sup>-12</sup>, respectively). This is the support they presented for the inverse hourglass model.

We began by examining the matrix of pairwise comparisons that their KS tests and Figure 4d are based on. As this figure shows (regenerated here as our Figure XXLevin a), there is not a strong distinction between these temporal phases - the distributions for the early, mid, and late distributions overlap considerably. The medians are close in value, and the range of mid phase includes the entire range of the early phase. Further inspection (Figure XXLevin a) reveals that the mid phase distribution has several outliers with very low similarity scores. We found that all five of the lowest values in the mid phase distribution are for pairwise comparisons that include the ctenophore (Figure XXLevin a). When the nine pairwise comparisons that include the ctenophore are removed, the differences between the early and mid phase distributions are greatly reduced (Figure XXLevin b).

We also found several problems with the statistical tests that were used to evaluate the inverse hourglass hypothesis. First, in the published analyses every data point was included twice because both reciprocal comparisons (which have the same values) were retained. For example, there is both a nematode to arthropod comparison and an arthropod to nematode comparison. As a consequence, there are 90 entries for the 45 pairwise comparisons, and by doubling the data the significance of the result appears much stronger than it actually is. After removing the duplicate values, the p values are far less significant, 0.002 for the early-mid comparison and on the order of 10<sup>-6</sup> for early-late. Second, the test they used (KS test) is not appropriate for the hypothesis they seek to evaluate. The KS test does not just evaluate whether one distribution is greater than the other, it also tests whether the shape of the distributions are the same. In addition, the samples in this dataset are matched (*i.e.*, for each pairwise comparison there is a early, mid, and late expression value), which the KS test does not take into account. The Wilcoxon test is instead appropriate in this case. After removing the duplicate scores, removing the ctenophore, and applying the Wilcoxon test, there is no significant difference between the early phase and mid phase distributions (P = 0.1428 for the early-mid comparison and P &lt; 10<sup>-5</sup> for the late-mid comparison), and the inverse hourglass turns into a wine bottle (Figure XXLevin b).

Our results highlight the importance of explicitly accounting for phylogenetic relationships when studying character evolution, including developmental<sup>12</sup> and functional genomic traits<sup>13</sup>. This is particularly true for evolutionary analyses of quantitative gene expression<sup>14</sup>. Pairwise comparisons result in the same evolutionary changes being counted multiple times in each species pair, as for the ctenophore comparisons that were mistaken for a global pattern here. This is a well understood property of pairwise comparisons that has been specifically addressed by phylogenetic comparative methods<sup>2</sup>. This particular case illustrates the shortcomings of *ad hoc* rank-based methods<sup>15</sup> and pairwise comparisons<sup>5</sup> for the study of the evolution of gene expression. Phylogenetic analyses of character evolution provide not only a way to avoid these problems, but a richer context for interpreting the biological implications of the results.

While demonstrate a common problem with pairwise comparisons in Levin *et al.* dataset, we did not perform a phylogenetic reanalysis of this study, as we did for the KMRR study. This is because the similarity metric computed in the pairwise comparisons of Levin *et al.* are based on different genes for different species pairs. This means that there is not a trait that can be mapped onto the tree, as KMRR's tau can be. A full phylogenetic reanalysis would of course be possible be using upstream analysis products to rederive a new expression summary statistic that was suitable for mapping onto a phylogenetic tree.

Discussion
----------

Some of the most widely used phylogenetic comparative methods \[1, 5\] are directly applicable to CFG data. There are also unique challenges that will need to be addressed at this new intersection, though. One of the greatest challenges is that most phylogenetic comparative methods have been developed to address problems with many more species (e.g., dozens or more) relative to the number of traits being examined (e.g., 2-5). In CFG analyses, there are often far fewer species (e.g., 3-10) because adding taxa is still expensive, but tens of thousands of traits. This creates challenges as the resulting covariance matrices are singular and, if not treated appropriately, imply many false correlations that are artefacts of project design. We outlined these challenges and potential solutions in the context of gene expression \[31\].

It is not enough to demonstrate the impact of phylogenetics on CFG analyses, these methods need to be made accessible to the FG community so they can be widely.

Most early phylogenetic comparative methods attempted to remove evolutionary signal to correct statistical tests for correlations between traits, while more recent methods tend to focus on testing hypotheses of evolutionary processes \[34\]. The application of this newer focus to pCFG provides an exciting opportunity to address long standing questions of broad interest, including the order of changes in FG traits and shifts in rates of evolution of one FG trait following changes in another trait.

A small number of CFG studies have employed some phylogenetic comparative approaches \[18–22\]. For instance, a phylogenetic ANOVA \[21\] of the evolution of gene expression improves statistical power and drastically reduces the rate of false positives relative to pairwise approaches.

Conclusions
-----------

The fact that the first two CFG studies we reanalyzed show serious problems with pairwise comparisons indicates that there likely to be similar problems in other CFG studies, and that future CFG studies will be compromised if they continue to use pairwise methods.

Methods
-------

### KMRR reanalysis

Based on their scripts from: <https://figshare.com/articles/Tissue-specificity_of_gene_expression_diverges_slowly_between_orthologs_and_rapidly_between_paralogs/3493010/2>

To replciate the published analysis, `cd` to `Data_used/Expression_data`, launch `R`, and run:

    source( "../Rscript.R" )

After running the analysis above, also obtain the `Compara.75.protein.nh.emf` gene trees from <ftp://ftp.ensembl.org/pub/release-75/emf/ensembl-compara/homologies/> and place them in the same directory as this file.

### Levin et al. reanalysis

Levin *et al.* helpfully provided data and clarification on methods. We obtained the matrix of pairwise scores that underlies their [Figure 4d](http://www.nature.com/nature/journal/v531/n7596/fig_tab/nature16994_F4.html) and confirmed we could reproduce their published results. We then removed duplicate rows, identified ctenophores as overrepresented among the low outliers in the mid-developmental transition column, and applied the Wilcoxon test in place of the Kolmogorov-Smirnov test. These data, our analysis code, and additional information are available in a git repository at <https://github.com/caseywdunn/levin2016>. This repository includes our analysis notebook at <https://rawgit.com/caseywdunn/levin2016/master/reanalyses.html>.

Ackowledgements
---------------

Thanks to

Supplementary Material
----------------------

References
----------

1. Wray, G. A. Genomics and the Evolution of Phenotypic Traits. *Annual Review of Ecology, Evolution, and Systematics* **44,** 51–72 (2013).

2. Felsenstein, J. Phylogenies and the Comparative Method. *American Naturalist* **125,** 1–15 (1985).

3. Chamberlain, S. A., Hovick, S. M. & Dibble, C. J. Does phylogeny matter? Assessing the impact of phylogenetic information in ecological meta-analysis. *Ecology …* (2012).

4. Kryuchkova-Mostacci, N. & Robinson-Rechavi, M. Tissue-Specificity of Gene Expression Diverges Slowly between Orthologs, and Rapidly between Paralogs. *PLoS Computational Biology* **12,** e1005274–13 (2016).

5. Levin, M. *et al.* The mid-developmental transition and the evolution of animal body plans. *Nature* **531,** 637–641 (2016).

6. Nehrt, N. L., Clark, W. T., Radivojac, P. & Hahn, M. W. Testing the Ortholog Conjecture with Comparative Functional Genomic Data from Mammals. *PLoS Computational Biology* **7,** e1002073 (2011).

7. Kalinka, A. T. *et al.* Gene expression divergence recapitulates the developmental hourglass model. *Nature* **468,** 811–814 (2010).

8. Hejnol, A. & Dunn, C. W. Animal Evolution: Are Phyla Real? *Current Biology* **26,** R424–R426 (2016).

9. Martindale, M. Q. & Henry, J. Q. in *Evolutionary developmental biology of invertebrates 6* (Springer Vienna, 2015).

10. *Modern Phylogenetic Comparative Methods and Their Application in Evolutionary Biology*. (Springer Berlin Heidelberg, 2014). doi:[10.1007/978-3-662-43550-2](https://doi.org/10.1007/978-3-662-43550-2)

11. Robinson, M. D., McCarthy, D. J. & Smyth, G. K. edgeR: a Bioconductor package for differential expression analysis of digital gene expression data. *Bioinformatics* **26,** 139–140 (2009).

12. Telford, M. J. & Budd, G. E. The place of phylogeny and cladistics in Evo-Devo research. *The International Journal of Developmental Biology* **47,** 479–490 (2003).

13. Hejnol, A. & Lowe, C. J. Embracing the comparative approach: how robust phylogenies and broader developmental sampling impacts the understanding of nervous system evolution. *Philosophical transactions of the Royal Society of London. Series B, Biological sciences* **370,** 20150045–20150045 (2015).

14. Dunn, C. W., Luo, X. & Wu, Z. Phylogenetic analysis of gene expression. *Integrative and Comparative Biology* **53,** 847–856 (2013).

15. Domazet-Lošo, T. & Tautz, D. A phylogenetically based transcriptome age index mirrors ontogenetic divergence patterns. *Nature* **468,** 815–818 (2010).
