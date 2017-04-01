# Installs manuscript dependencies

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
source("https://bioconductor.org/biocLite.R")
biocLite()

# From github
devtools::install_github( "GuangchuangYu/treeio" )
devtools::install_github( "GuangchuangYu/ggtree" )
devtools::install_github( "caseywdunn/hutan" )