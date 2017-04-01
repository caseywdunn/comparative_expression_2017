# Installs manuscript dependencies
# 
# This installs all dependencies needed to run the 
# manuscript, as verified by running it in a 
# container based on the docker image 
# https://hub.docker.com/r/rocker/tidyverse/
#
# From CRAN
install.packages( 
	c(
		"devtools",
		"tidyverse",
		"magrittr",
		"stringr",
		"parallel",
		"ape",
		"digest",
		"gridExtra",
		"geiger",
		"phytools"
	) 
)

# From Bioconductor, needed for ggtree and treeio
source( "https://bioconductor.org/biocLite.R" )
biocLite()

# From github
devtools::install_github( "GuangchuangYu/treeio", quiet=TRUE )
devtools::install_github( "GuangchuangYu/ggtree", quiet=TRUE )
devtools::install_github( "caseywdunn/hutan", quiet=TRUE )
