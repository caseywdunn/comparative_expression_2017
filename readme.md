## Introduction

This respository contains files associated with our reanalysis of two
previously published comparative gene expression studies:

> Levin M, Anavy L, Cole AG, Winter E, Mostov N, Khair S, Senderovich N, Kovalev E, Silver DH, Feder M, et al. 2016. The mid-developmental transition and the evolution of animal body plans. Nature 531: 637-641. [doi:10.1038/nature16994](http://dx.doi.org/10.1038/nature16994)

> Kryuchkova-Mostacci N, Robinson-Rechavi M: Tissue-Specificity of Gene Expression Diverges Slowly between Orthologs, and Rapidly between Paralogs. PLoS Computational Biology 2016, 12:e1005274–13. [doi:10.1371/journal.pcbi.1005274](http://dx.doi.org/10.1371/journal.pcbi.1005274)

The files in this repository include:

- [manuscript.pdf](./manuscript.pdf?raw=true) The rendered manuscript. It is the simplest way to view our manuscript, including the computed results and figures.

- [manuscript.rmd](./manuscript.rmd) The manuscript text and source code for our reanalysis. This is the file we edited as we wrote the manuscript.

- [functions.R](./functions.R) Custom functions required to execute the manuscript.

- [kmrr](./kmrr) The folder with the data and original code from Kryuchkova-Mostacci Robinson-Rechavi 2016, as well as the products of this code that are needed to run our reanalyses.

- [levin_etal](./levin_etal) The folder with data provided by the authors of Levin et al. 2016, as well as our annotations of their analysis and the code we used to explore their results.

## Rerunning our analyses

To re-execute our manuscript, first download the gene tree file Compara.75.protein.nhx.emf.gz from ftp://ftp.ensembl.org/pub/release-75/emf/ensembl-compara/homologies/, place it in the `kmrr/` directory, and uncompress it as `Compara.75.protein.nhx.emf`. We left it out of this repo since it is quite large and archived elsewhere.

Then run `manuscript.rmd`, the source code for our manuscript, with the R package `knitr`. You can do this in RStudio by clicking the "knit" button. This will regenerate the manuscript, with all results and plots.

The `manuscript.rmd` file has all our code for running the KMRR reanalysis. The Levin analysis code, along with additional exploratory analyses not included in the manuscript, is in [reanalyses.rmd](./levin_etal/reanalyses.rmd). The results of these reanalyses can be viewed at [reanalyses.md](./levin_etal/reanalyses.md).

## Development

### Running tests

To run tests of the code, launch an R console from the root directory of this
repository and run:

    library( testthat )
    test_dir( "tests/testthat/" )
