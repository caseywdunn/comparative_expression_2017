FROM rocker/tidyverse

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libtiff-devel


RUN install2.r --error \
    --deps TRUE \
    -r 'http://cran.rstudio.com' \
    -r 'http://www.bioconductor.org/packages/release/bioc' \
    ggtree \
    treeio \
    ape \
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