FROM rocker/tidyverse

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