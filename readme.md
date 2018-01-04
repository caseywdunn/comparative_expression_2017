## Introduction

This repository contains files associated with our manuscript:

> Dunn, CW, F Zapata, C Munro, S Siebert, A Hejnol (2018) Pairwise comparisons across species are problematic when analyzing functional genomic data. PNAS. [doi:10.1073/pnas.1707515115](http://dx.doi.org/10.1073/pnas.1707515115).

It presents reanalyses of two previously published comparative gene expression studies:

> Levin M, Anavy L, Cole AG, Winter E, Mostov N, Khair S, Senderovich N, Kovalev E, Silver DH, Feder M, et al. 2016. The mid-developmental transition and the evolution of animal body plans. Nature 531: 637-641. [doi:10.1038/nature16994](http://dx.doi.org/10.1038/nature16994)

> Kryuchkova-Mostacci N, Robinson-Rechavi M: Tissue-Specificity of Gene Expression Diverges Slowly between Orthologs, and Rapidly between Paralogs. PLoS Computational Biology 2016, 12:e1005274–13. [doi:10.1371/journal.pcbi.1005274](http://dx.doi.org/10.1371/journal.pcbi.1005274)

The files in this repository include:

- [manuscript.pdf](./manuscript.pdf?raw=true) The rendered manuscript. It is the simplest way to view our manuscript, including the computed results and figures.

- [manuscript.rmd](./manuscript.rmd) The manuscript text and source code for presenting our analyses. It executes relatively quickly (a few minutes on a standard laptop) since computationally intensive analysis steps are all in manuscript_kernel.R .

- [manuscript_kernel.R](./manuscript_kernel.R) The heavy lifting on the more computationally intensive analyses. It needs to be executed before running manuscript.rmd to generate the file manuscript.RData with intermediate results.

- [functions.R](./functions.R) Custom functions required to run our analyses.

- [kmrr](./kmrr) The folder with the data and original code from Kryuchkova-Mostacci Robinson-Rechavi 2016, as well as the products of their code that are needed to run our analyses.

- [kmrr/Compara.75.protein.nhx.emf.gz](./kmrr/Compara.75.protein.nhx.emf.gz) The Compara gene tree file, from ftp://ftp.ensembl.org/pub/release-75/emf/ensembl-compara/homologies/

- [levin_etal](./levin_etal) The folder with data provided by the authors of Levin et al. 2016, as well as our annotations of their analysis and the code we used to explore their results ([reanalyses.rmd](./levin_etal/reanalyses.rmd)). The results of these analyses can be viewed at [reanalyses.md](./levin_etal/reanalyses.md).

## Rerunning our analyses

We run the analyses in a [Docker](https://gist.github.com/caseywdunn/34aac3d1993f9b3340496e9294239d3d) container with all the R dependencies needed by our code. Please see the [docker](./docker) folder for more information on building the docker image and running the container. Alternatively, you could run it directly on your computer after installing the dependencies yourself.

The manuscript is typically executed in two steps. First, run [manuscript_kernel.R](./manuscript_kernel.R). This code includes the most computationally intensive steps, and outputs the file `manuscript.RData` with intermediate results. Next, knit [manuscript.rmd](./manuscript.rmd). This reads in the intermediate results from `manuscript.RData`, formats them for presentation, and integrates them with the text in a combined document.

These two steps can be executed with:

    nohup Rscript manuscript_kernel.R &
    Rscript -e "library(rmarkdown); render('manuscript.rmd')"

The first step takes about an hour and a half in a docker container on an [Amazon Web Services EC2 m4.16xlarge instance](https://aws.amazon.com/ec2/instance-types/), which has 64 cores and 256 GB RAM. About 2GB RAM per core are required.

You can executed [manuscript_kernel.R](./manuscript_kernel.R) on a cluster or in the cloud, and then move the `manuscript.RData` to another computer (such as your laptop) to execute manuscript.rmd and generate the final pdf.

## Development

### Running tests

To run tests of the code, launch an R console from the root directory of this
repository and run:

    library( testthat )
    test_dir( "tests/testthat/" )

## Distribution

You can access this repository with the shortened url https://git.io/vDj9j
