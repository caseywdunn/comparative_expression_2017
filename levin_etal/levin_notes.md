
# Notes on Levin *et al* 2016

This document includes excerpts from [Levin *et al*](http://dx.doi.org/10.1038/nature16994) and my notes on these excerpts. The intent is to make sure I understand their methods and results, and to make clarifications as needed.

> Text that appears in this format is reproduced directly from the Levin *et al* manuscript. *Emphasis is added by me to highlight some text.*

My own comments are interdigitated with their text.

## Main text

> To compare gene expression across these species, we delineated 11,139 orthologous protein families, with each orthologous family having representatives from an average of six species.

In each pairwise comparison between two species, only the orthologs shared by those species were considered (this is confirmed by the authors).

> To systematically compare gene expression across species, we computed the correlation across orthologous gene expression throughout development for each pair of species. 

Question: What is this correlation between? For example, are X and Y the phases (eg 1=early,2=mid,3=late) for each shared ortholog?

Author answer: "This is a correlation between the vectors from the expression matrices defined as described in the Methods section ‘developmental gene expression profiles’; i.e. X and Y are not the phases but the actual gene expression values."

> To systematically compare gene expression across species, we computed the correlation across orthologous gene expression throughout development for each pair of species. For example, comparison of tardigrade and annelid embryonic transcriptomes revealed two conserved phases of expression in these two species—early and late—separated by a sharp mid-developmental transition (P<10<sup>−10</sup>, Kolmogorov–Smirnov test, Fig. 3, inset; Extended Data Fig. 3). 

Question: How was this test done, ie what is being compared? 


>  Overall, the dual-phase pattern holds for most pairwise species comparisons, with the exception of 9 out of 45 (Extended Data Fig. 3), and is robust to the parameters used for constructing the sliding window expression profiles and to possible biases in the embryo sampling (Extended Data Fig. 4a, b).


> Finally, *we measured the extent of evolutionary change within the two conserved phases and the mid-developmental transition by determining whether orthologues annotated for a particular temporal category in one species are also annotated to the same temporal category in another species*. Figure 4c shows an example of this analysis for D. melanogaster and C. elegans. For 4,395 orthologues delineated between these two species, the early phase, mid-developmental transition, and the late phase expression account for 51%, 14%, and 35% of the C. elegans orthologues, respectively. A total of 28% of the orthologues are annotated to the early phase in both C. elegans and D. melanogaster, while by chance only 22% are expected given the fraction of genes in each category across the species (Fig. 4c). In contrast, 3% were expected to be conserved at the mid-developmental transition at random, and 3% were observed. 

Question: How did you calculate the numbers that are expected by chance?

Author answer: "The expectation that both orthologs are of the same phase is the product of the frequency of the phase in species 1 and the frequency of the phase in species 2."

> The log-odds ratios between observed and expected for the early phase and the mid-developmental transition between C. elegans and D. melanogaster are thus 0.35 and 0, respectively. Comparing the log-odds ratios across the three temporal categories for each of the 45 pairs of the ten species, we found that the mid-developmental transition profiles are significantly less conserved than the early and late phase expression (Fig. 4d, P < 10−6 compared with the early phase and P < 10−12 with the late phase, Kolmogorov–Smirnov test). 

> Our results are consistent with an inverse hourglass model for metazoan body plans (Fig. 4e) in which the molecular components that comprise early and late embryogenesis are more conserved, and the signalling pathways and transcription factors acting within the mid- developmental transition are variable across major animal lineages (Fig. 4a, b). Interestingly, the model summarizing comparisons made within a phylum, where gene expression differences across species are minimal at the phylotypic period, has an inverse pattern23. Consequently, a ‘phylum’ may be defined as a set of species sharing the same signals and transcription factor networks during the mid-developmental transition. As a result, transcriptional variance will have an hourglass shape within the phylum, and the inverse is seen when comparing species across phyla (Fig. 4e). A non-phylum lower taxon would not meet these criteria since an hourglass pattern of similarities would be observed both within the taxon and across more distant species. Should this transcriptomic definition hold, evidence will be provided for the usefulness of ‘phylum’ as a biological classification. It may also suggest the delineation of new phyla, as well as the collapsing of previously distinct ones, requiring validation by zoological studies. 

## Figures

### Figure 2

Many of the genes that have high expression early also have high expression late (i.e., red, blue, red). This profile was not considered, however, as each gene was fitted to being high in early, mid, or late.

### Figure 3

Question: How were the genes ordered in these plots?

### Extended Data Figure 2

Question: What are the axes in Extended Data Figure 2 a?

### Extended Data Figure 3

> For each pair of species a series of Kolmogorov–Smirnov
tests are shown. Each test compares the intra-phase to the inter-
phase correlations

> The yellow boxes indicate those species comparisons where there is significant statistical evidence for the dual- phase pattern (higher significance for the middle tests).

So the 9 blue boxes are the insignificant comparisons. They are:

    C. elegans       - H. dujardini
    P. dumerilii     - D. melanogaster
    S. polychroa     - S. purpuratus
    H. dujardini     - S. purpuratus
    H. dujardini     - N. vectensis
    S. purpuratus    - A. queenslandica
    N. vectensis     - A. queenslandica
    H. dujardini     - M. leidyi
    A. queenslandica - M. leidyi

Had a quick look in R:

    x = c("C. elegans", "H. dujardini", "P. dumerilii", "D. melanogaster", "S. polychroa", "S. purpuratus", "H. dujardini", "S. purpuratus", "H. dujardini", "N. vectensis", "S. purpuratus", "A. queenslandica", "N. vectensis", "A. queenslandica", "H. dujardini", "M. leidyi", "A. queenslandica", "M. leidyi")
    
    
    as.matrix(table(x))
                     [,1]
    A. queenslandica    3
    C. elegans          1
    D. melanogaster     1
    H. dujardini        4
    M. leidyi           2
    N. vectensis        2
    P. dumerilii        1
    S. polychroa        1
    S. purpuratus       3

So H. dujardini, A. queenslandica, and S. purpuratus have the fewest significant tests.


## Methods

>**CEL-Seq initial analysis pipeline**
>
>Transcript abundances were obtained from the sequencing data using custom scripts organized into a multistep paralleled computational pipeline. Briefly, after trimming and filtering, the paired-end reads were demultiplexed based on the first eight bases of the first read. For each sample, reads were mapped to a reference genome or transcriptome using bowtie2 version 2.2.3 (ref. 46) with default parameters and counted using htseq-count<sup>47</sup> to generate read counts. Samples were filtered to include only samples with at least 500,000 reads and in additions ERCC spike-in information was also used to filter out samples with low correlation coefficients (<0.65) to the known concentration or with high (>0.3) spike-in to gene read count ratio. Read counts were then normalized by dividing by the total number of counted reads and multiplying by 10<sup>6</sup>. Because CEL-Seq retains only the 3' end of the transcript, *this procedure yields the estimated gene expression levels in transcripts per million (tpm)* without transcript length normalization. In this work, we compare the transcripts per million developmental profiles for different genes and across orthologues, and such comparisons are generally robust to overall RNA content changes.
>
>**De novo transcriptome assembly with stranding and 3' anchoring**
>
>A de novo transcriptome was generated for S. polychroa, P. dumerilii and H. dujardinii. Since we had at our disposal CEL-Seq reads, in addition to the RNA-Seq reads, our strategy was to exploit the stranded and 3'-biased nature of CEL-Seq. The Trinity software<sup>48</sup> was used to generate, for each of the three species, two de novo transcriptome assemblies: (1) single-end CEL-Seq reads were used to generate a 3' biased stranded transcriptome, and (2) the CEL-Seq reads were combined with paired-end RNA-seq reads were used to generate a combined transcriptome. For the CEL-Seq 3' assembly, we ran Trinity using the single-end mode with 'SS_lib_type' parameter set to 'F'. For the combined assembly we ran Trinity using the paired-end mode with default parameters. The two resulting transcriptomes were then used to generate a single 3' anchored stranded transcriptome. For each transcript (contig) in the first set, we identified the corresponding transcripts in the second set using BLAST<sup>49</sup>. Of those identified, we selected the transcript with the highest alignment score and used the strand information of the transcript in the first set to generate a stranded transcript (Extended Data Fig. 1). Genes with alternative 3'-ends may be represented as distinct genes in this set, in those rare cases when the CEL-Seq contigs do not overlap. The generated set of transcripts was further filtered to contain only transcripts with a predicted protein using the Trinotate pipeline that is a part of the Trinity software<sup>48</sup>. PFAM domains<sup>50</sup> were then identified using HMMER<sup>51</sup>.
>
>**Gene Ontology and PFAM**
>
>GO annotations for each transcriptome were generated using Trinotate (http://trinotate.github.io/). Specifically, transcripts were searched against Uniprot sequences (comprising SwissProt and Trembl invertebrate, vertebrate, mammal, rodents and human data, clustered to 90% identity). GO and PFAM identifiers were then extracted from Uniprot accessions.
>
>**Delineation of orthologous clusters**
>
>*OrthoMCL<sup>52</sup> was used to delineate orthologous clusters from the ten proteomes of the ten species* using the following parameters: "percentMatchCutoff" was set to 24, "evalueExponentCutoff" was set to −5, and the MCL parameters were "–abc -I 1.5". *In the case of multiple genes in an orthology cluster for a particular species, the one with the highest fold-change was selected as the representative.* We found similar results if the representative is selected randomly among the inparalogues.
>
>**Developmental gene expression profiles**
>
>*Each time-course was initially ordered using BLIND—an automated method for determining the developmental order of transcriptomic samples<sup>13</sup> (Extended Data Fig. 2a).* 

[BLIND](http://dev.biologists.org/content/141/5/1161) orders samples based on expression. From the BLIND manuscript: "BLIND is thus useful in establishing the temporal order of samples within large datasets and is of particular relevance to the study of organisms with asynchronous development and when morphological staging is difficult."

>These profiles were smoothed using a moving average calculation with span parameter set to 3. *In order to compare profiles of equal lengths, for each species we reduced the time-course to twenty sliding windows using the following method. We defined the size of the window such that there is only overlap between every two consecutive windows. For each window, the average expression was calculated for each gene across the included embryos. For each time-course, dynamic genes were defined as those with minimum expression of 10 transcripts per million and at least a twofold change.* 

Question: Are only the dynamic genes considered further? The text isn't clear on this. Specifically, is Figure 4 and associated analyses based only on dynamic genes?

Author answer: "The set of dynamic genes is used for some of supplementary analyses relating to figure 3. They are not used in the Figure 4 analyses."

> *Standardized expression was used in analysis where noted: to generate a standardized expression, the mean expression value was subtracted from each expression value and the results were divided by the standard deviation.* To generate the phasegrams shown in Fig. 2 we first standardized the log10 profiles by subtracting the mean and dividing by the standard deviation. We next computed the first two principal components of this expression data; since the profiles were standardized, the genes form a circle. The genes are then sorted according to their angle from the origin in this space. *A gene expression profile was mapped to a temporal phase (early, transition, or late) by computing the correlation with the three idealized profiles shown in [Extended Data Fig. 5](http://www.nature.com/nature/journal/v531/n7596/fig_tab/nature16994_SF5.html) and assigning it to the pattern exhibiting the highest correlation and thus best match.*

These three profiles correspond to peak early, peak mid, and peak late. Other profiles, eg genes that peak early and late but have lower mid expression, are not considered. 

Question: Were genes that strongly deviated from these three profiles excluded? Was there any test of fit or significance of change in expression that was considered? This question relates to the one above about which analyses the "dynamic gene" filter was applied to.

Author answer: "To classify a gene to the three phases strongly deviating genes were not excluded and no goodness of fit test was made."

>
>**Mid-developmental transition detection**
>
>The transition period for each species was computed based upon the transcriptome similarities with the transcriptomes of the other species, shown in Fig. 3. The twenty transcriptomes were clustered using hierarchical clustering based upon the Euclidean distances among their profiles of correlations with the profiles of all other species. *The two deepest clusters were then identified and the precise temporal window separating them was set as the mid-developmental transition period.*

Questions: Did these two clusters always correspond to an early and late phase? Was goodnes of fit to two clusters evaluated (e.g. were attenpts made to fit the data to more or fewer clusters)?

The abstract states "We find that in all ten species, development comprises the coupling of early and late phases of conserved gene expression". It appears, though, that the data were fitted to this pattern without considering alternative hypotheses.


>
>**Gene Ontology (GO) enrichment analysis**
>
>A temporal phase was assigned to each orthologous group by annotating it to its most represented phase. The C. elegans Gene Ontology annotation was used on the C. elegans orthologues. Enrichment was computed using the hypergeometric distribution. In order to avoid retrieving enrichments due to the same set of genes we carried out serial enrichments as follows. The most enriched gene ontology group was noted, its genes removed from the set, and enrichment search was repeated to detect additional Gene Ontology terms. For the signalling pathways shown in Fig. 4b, the following gene ontology terms were used: 'Wnt signalling pathway', 'Notch signalling pathway', 'hedgehog receptor activity', 'epidermal growth factor receptor signalling pathway', 'transforming growth factor beta receptor signalling pathway', 'MAPK cascade', 'G-protein coupled receptor activity'. For this analysis, we searched for enrichment up to three windows before and after the inferred transition, and kept the most significant P value for each pathway (hypergeometric distribution).
>
>**PFAM signatures**
>
>For each of 5,745 PFAMs, we computed an enrichment profile throughout time, and for each species, as follows. For each of the twenty expression windows of the matrix of standardized log10 expression values of the dynamic genes, we marked genes with expression above 0.5 as expressed. We then calculated the fraction of the genes within this set that contain genes annotated to the PFAM domain. A temporal phase was annotated using supervised clustering using the same approach shown in Extended Data Fig. 5. For the transcription factor families shown in Fig. 4d the following PFAMs were used: 'Homeobox domain', 'GATA zinc finger', 'Ligand-binding domain of nuclear hormone receptor', 'Helix–loop–helix DNA-binding domain', 'bZIP transcription factor', 'Zinc finger, C4 type (two domains)', 'Zinc finger, C2H2 type', and 'T-box'. 

Correction: The authors indicate this is a typo - this text is relevant to figures 4a and 4b, not 4d.

>For this analysis, we searched for enrichment up to three windows before and after the inferred transition, and kept the most significant P value for each TF family (hypergeometric distribution).