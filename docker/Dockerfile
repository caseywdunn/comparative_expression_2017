FROM rocker/tidyverse

RUN R -e "source('https://bioconductor.org/biocLite.R')" \
  && install2.r --error \
    --deps TRUE \
    ggtree \ # bioconductor
    treeio \ # bioconductor
    ape \    # Rest are CRAN
    digest \
    geiger \
    ggrepel \
    gridExtra \
    magrittr \
    parallel \
    phytools \
    stringr \
    tidyverse \
  && Rscript -e "library(devtools); devtools::install_github('caseywdunn/hutan')"