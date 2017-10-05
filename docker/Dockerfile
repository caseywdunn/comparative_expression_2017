FROM rocker/tidyverse

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  libfftw3-dev \
  libtiff5-dev \
  libglu1-mesa-dev \
  lmodern \
  texlive-latex-extra \
  texlive-fonts-recommended


RUN install2.r --error \
    --deps TRUE \
    -r 'http://cran.rstudio.com' \
    -r 'http://www.bioconductor.org/packages/release/bioc' \
    ggtree \
    treeio \
    ape \
    geiger \
    ggrepel \
    phytools \
  && Rscript -e "library(devtools); devtools::install_github('caseywdunn/hutan')"