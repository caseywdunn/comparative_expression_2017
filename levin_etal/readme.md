# Levin *et al* 2016 reanalyses

by [Casey W. Dunn](http://dunnlab.org/)

This repository contains information, data, and code for reanalyses based on Levin *et al*. 2016:

> Levin M, Anavy L, Cole AG, Winter E, Mostov N, Khair S, Senderovich N, Kovalev E, Silver DH, Feder M, et al. 2016. The mid-developmental transition and the evolution of animal body plans. Nature 531: 637-641. [doi:10.1038/nature16994](http://dx.doi.org/10.1038/nature16994)

The reanalyses presented here are motivated in part by concerns that my colleague Andi Hejnol and I raised regarding the Levin *et al*. paper:

> Hejnol A, Dunn CW, 2016. Animal Evolution: Are Phyla Real? Current Biology 26:R424-R426. [doi:10.1016/j.cub.2016.03.058](http://dx.doi.org/10.1016/j.cub.2016.03.058)

The authors of Levin *et al*. have been very helpful providing data and clarification on methods.

The goals of these reanalyses are to make sure that I understand the methods of the published Levin *et al*. study by showing that I can successfully reproduce their results, and then to extend these analyses to assess specific methodological concerns.

## Repository contents

This repository includes the following files:

- [communication_arising.md](./communication_arising.md), the draft of the manuscript we plan to submit.

- [reanalyses.html](https://rawgit.com/caseywdunn/levin2016/master/reanalyses.html), the notebook containing our analyses.

- [reanalyses.rmd](./reanalyses.rmd), an executable document containing the code and notes on my reanalyses. 

- [levin_notes.md](./levin_notes.md), notes on relevant excerpts from the Levin *et al*. manuscript.

Original files from the authors are in `data_original`:

- `Figure 4c data.xlsx`. Author description: "1. In the 'orthology' spreadsheet, every row is a gene family across the species (columns). The number corresponds to the index in the 'gene names' spreadsheet. 2. For each gene family you can retrieve the time of expression (early, mid-, late) by using the 'mode of expression' spreadsheet' where again the rows are the orthology familes."

- `Figure 4d data.xlsx`. Author description: "the underlying data used to generate the boxplots in figure 4D"

Derivative files that I made (eg, exporting as text, removing duplicate rows) are in `data_processed`:

- `Figure_4c_mode.txt`. From the "Mode of expression" sheet of `Figure 4c data.xlsx`. Orthology column (which is redundant with row number) and legend removed. 

- `Figure_4c_orthology.txt`. From the "Orthology" sheet of `Figure 4c data.xlsx`. Orthology family column (which is redundant with row number) and legend removed.

- `Figure_4d_data_full.txt`. TSV export of `Figure 4d data.xlsx`.

- `Figure_4d_data.txt`. From `Figure_4d_data_full.txt`, with duplicate pairwise comparison rows removed.

## Results of Levin *et al* 2016

The central results and conclusions of Levin *et al*. 2016 are:

- "...we found that the mid-developmental transition profiles are significantly less conserved than the early and late phase expression (Fig. 4d, P < 10<sup>-6</sup> compared with the early phase and P < 10<sup>-12</sup> with the late phase, Kolmogorov-Smirnov test)."

- "Consequently, a 'phylum' may be defined as a set of species sharing the same signals and transcription factor networks during the mid-developmental transition. As a result, transcriptional variance will have an hourglass shape within the phylum, and the inverse is seen when comparing species across phyla (Fig. 4e)."

- "This work also provides an operational definition for a phylum" (from the editor's summary)

The taxon sampling of Levin *et al*. was insufficient to test whether developmental expression could be used to define phyla (see [Hejnol and Dunn 2016](http://dx.doi.org/10.1016/j.cub.2016.03.058)). The focus of the analyses I present here is therefore to examine support for their conclusion that "mid-developmental transition profiles are significantly less conserved than the early and late phase expression".
