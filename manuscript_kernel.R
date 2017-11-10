
## ----preliminaries, echo=FALSE, message=F, warning=F---------------------
	
	time_start = Sys.time()
	# The following should be installed from github with the specified 
	# devtools command. You will need to install devtools first.
	library( treeio ) # devtools::install_github("GuangchuangYu/treeio")
	library( ggtree ) # devtools::install_github("GuangchuangYu/ggtree")
	library( hutan ) # devtools::install_github("caseywdunn/hutan")

	# The rest can be installed from CRAN
	library( ape )
	library( digest )
	library( geiger )
	library( ggrepel )
	library( gridExtra )
	library( magrittr )
	library( foreach )
	library( doParallel )
	library( phytools )
	library( stringr )
	library( tidyverse )

	source( "functions.R" )	
	set.seed( 23456 )


	# Set system computational parameters
	cores = detectCores() - 1
	if ( cores < 1 ) {
		cores = 1
	}

	# Register parallel workers for %dopar%
	registerDoParallel( cores )
	
	# Name of the compara gene trees file. This was downloaded from 
	# ftp://ftp.ensembl.org/pub/release-75/emf/ensembl-compara/homologies/
	# and compressed with gz

	gene_tree_name = "Compara.75.protein.nhx.emf.gz"
	
	# Files produced by KMRR Rscript.R with Tau values and other expression statistics
	expression_file_names = c(
		"ChickenBrawandTScomparisonTable_9_6chPC.txt", 
		"ChimpBrawandTScomparisonTable_9_6cmPC.txt", 
		"GorillaBrawandTScomparisonTable_9_6gPC.txt", 
		"HumBrawandTScomparisonTable_9_6hPC.txt", 
		"MacacaBrawandTScomparisonTable_9_6mcPC.txt", 
		"MusBrawandTScomparisonTable_9_6mPC.txt", 
		"OpossumBrawandTScomparisonTable_9_6oPC.txt", 
		"PlatypusBrawandTScomparisonTable_9_6pPC.txt"
	)
	
	kmrr_directory = "kmrr/"
	expression_file_names %<>% paste( kmrr_directory, ., sep="" )
	gene_tree_name %<>% paste( kmrr_directory, ., sep="" )
	
	# The minimum number of genes with expression data that a gene needs to have to be considered
	min_genes_with_expression = 4
	

	# These clade dates are from the KMRR code, they got them from http://timetree.org/
	calibration_times = data.frame(
		age =
			c( 20, 92, 167, 9, 42, 74, 296, 535, 104, 937, 29, 722, 441, 65, 15, 1215, 
				414, 371, 162, 25, 74, 77, 86, 7 ), 
		clade = 
			c("Hominoidea", "Euarchontoglires", "Mammalia", "Homininae", 
				"Simiiformes", "Primates", "Amniota", "Vertebrata", "Eutheria", 
				"Bilateria", "Catarrhini", "Chordata", "Euteleostomi", 
				"Haplorrhini", "Hominidae", "Opisthokonta", "Sarcopterygii", 
				"Tetrapoda", "Theria", "Murinae", "Sciurognathi", "Rodentia", 
				"Glires", "Hominini"
		),
		stringsAsFactors=FALSE
	)
	
	# The calibration times used for speciation nodes
	focal_calibrations_clades = 
		c( "Hominini", "Homininae", "Catarrhini", "Euarchontoglires", "Theria", 
			"Mammalia", "Amniota" )
	
	
	# In simulation, the fold change in rate following duplication relative to speciation
	dup_adjust = 2


## ----load_trees, echo=FALSE, cache=TRUE, message=F, warning=F------------

	# Read in the tree file as a vector of strings, one per line
	lines = readLines( gene_tree_name )

	# Isolate strings that are trees
	# These start with (
	tree_lines = lines[ grepl( "^\\(", lines, perl = TRUE ) ]

	# Parse each string to a treeio::treedata object, adding a label column 
	# for node names
	gene_trees = foreach( tree_line=tree_lines ) %dopar%
		parse_gene_trees( tree_line )
	
	# Uncomment for development to look at a subset of gene trees
	# gene_trees = gene_trees[1:100]
	
	n_gene_trees = length( gene_trees )
	
	# Parse the tree annotations, these are lines that start with SEQ
	# These have the species names, which are not in the trees themselves
	tip_annotations = 
		lines[ grepl( "^SEQ", lines, perl = TRUE ) ] %>%	# Get lines that start with SEQ
	  str_replace( " \\(\\d+ of \\d+\\)", "" ) %>%      # Remove instances of '(1 of 2)' and '(2 of 2)'
	  str_replace( "(([^ ]+ ){8})([^ ]+) ([^ ]+)", "\\1\\3_\\4" ) %>%      # Get rid of spaces in last field of some entries
		str_c( collapse="\n" ) %>%												# Combine them into one string
		read_delim( delim=" ", col_names = FALSE ) %>% 		# Read string as tibble
		select( 2, 8 ) %>%																# Select the columns with species and gene ID
		rename( Ensembl.Gene.ID = X8 ) %>%
		rename( species = X2 )
	
	# Remove the large string objects to free up memory
	rm( lines )
	rm( tree_lines )
	

## ----load_expression, echo=FALSE, message=F, warning=F-------------------

	# Read the expression data for each species and combine into a single tibble,
	# adding the species names from tip_annotations
	expression = 
		lapply(
			expression_file_names, 
			read.table, 
			stringsAsFactors=FALSE, 
			header=TRUE
		) %>%
		bind_rows() %>%
		left_join( tip_annotations, by="Ensembl.Gene.ID" )

	# Free up memory
	rm( tip_annotations )


## ----add_expression_to_trees, echo=FALSE, cache=TRUE, message=F, warning=F----

	# Annotate each tree by joining the corresponding expression data to the 
	# @data object. This maps the expression data to the tree tips

	add_expression_to_tree = function( tree ){
		tree@data %<>% 
			left_join( expression, by = c( "G" = "Ensembl.Gene.ID" ) )
		return( tree )
	}
	gene_trees_annotated = foreach( tree=gene_trees ) %dopar% 
		add_expression_to_tree( tree )


	# Free up memory
	rm( gene_trees )

	# Remove tips from the trees that do not have expression data
	gene_trees_pruned = foreach( tree=gene_trees_annotated ) %dopar% 
		drop_empty_tips( tree, min_genes_with_expression=min_genes_with_expression )

	
	# Free up memory
	rm( gene_trees_annotated )

	# Remove trees with less than min_genes_with_expression tips with expression data
	gene_trees_pruned = gene_trees_pruned[ ! is.na( gene_trees_pruned ) ]
	
	n_removed_for_no_speciation = length( gene_trees_pruned )
	
	# Remove trees with no speciation events
	gene_trees_pruned = gene_trees_pruned[ unlist( lapply( gene_trees_pruned, get_n_speciation ) ) > 0 ]
	
	n_removed_for_no_speciation = n_removed_for_no_speciation - length( gene_trees_pruned )
	
	# fix clade names
	gene_trees_pruned = lapply( gene_trees_pruned, fix_hominini )


## ----calibrate_trees, echo=FALSE, cache=TRUE, message=F, warning=F-------

	# Time calibrate all speciation nodes to the same years
	gene_trees_calibrated = calibrate_trees( gene_trees_pruned, calibration_times, model="correlated" )
	
	save.image("manuscript_checkpoint_calibrate_trees.RData")

## ----estimate_tau_model, cache=TRUE, echo=FALSE, warning=FALSE, message=FALSE----
	# Estimate model parameters and add them to the tree objects
	# This takes a while, so do it once here and reuse the values as needed
	
	gene_trees_calibrated = 
		foreach( nhx=gene_trees_calibrated ) %dopar% add_model_parameters( nhx )

## ----trees_to_contrasts, cache=TRUE, echo=FALSE, message=F, warning=F----

	# Calculate the contrasts from the trees and associated expression data
	gene_trees_pic = add_pics_to_trees( gene_trees_calibrated )

	# Collect all the contrasts in a single tibble
	nodes_contrast = summarize_contrasts( gene_trees_pic )
	
	# Collect all the tree statistics in a single tibble
	tree_summary = summarize_trees( gene_trees_pic )
	
	# Test if the mean rank of duplication pics is greater than speciation pics
	wilcox_test_result = wilcox_oc( nodes_contrast )

	save.image("manuscript_checkpoint_contrasts.RData")

## ----ascertainment, cache=TRUE, echo=FALSE, warning=FALSE, message=FALSE----

	# Examine by node age

	max_speciation_age = 
		nodes_contrast %>% 
		filter( D=="N" ) %>%
		select( node_age ) %>%
		max( na.rm=TRUE )
	
	nodes_contrast_filtered_age = 
		nodes_contrast %>% 
		filter( node_age <= max_speciation_age )
	
	wilcox_filtered_age = wilcox_oc( nodes_contrast_filtered_age )

	# Examine by expected variance, ie branch length
	var_exp_max = 
		nodes_contrast %>% 
		filter( D=="N" ) %>%
		select( var_exp ) %>%
		max( na.rm=TRUE )

	var_exp_min = 
		nodes_contrast %>% 
		filter( D=="N" ) %>%
		select( var_exp ) %>%
		min( na.rm=TRUE )

	nodes_contrast_filtered_var = 
		nodes_contrast %>% 
		filter ( ( var_exp >= var_exp_min ) & ( var_exp <= var_exp_max ) )
	
	wilcox_filtered_var = wilcox_oc( nodes_contrast_filtered_var )

	

## ----pairwise, echo=FALSE, cache=TRUE, message=F, warning=F--------------

	# Build a tibble of all pairwise comparisons between tips
	pairwise_summary = foreach( tree=gene_trees_pic ) %dopar% 
		get_pairwise_summary( tree ) 
	
	pairwise_summary %<>% bind_rows()
	
	# Calculate some summary statistics 
	ortholog_r = 
		pairwise_summary %>% 
		filter( D=="N" ) %$% 
		cor.test( tau_a, tau_b ) 
	
	paralog_r = 
		pairwise_summary %>% 
		filter( D=="Y" ) %$% 
		cor.test( tau_a, tau_b )
	
	paralog_subset_r = 
		pairwise_summary %>% 
		filter( D=="Y" ) %>% 
		filter( node_age <= max_speciation_age ) %$% 
		cor.test( tau_a, tau_b )
	
	ortholog_distance_mean = 
		pairwise_summary %>% 
		filter( D=="N" ) %>% 
		.[["distance"]] %>% 
		mean()
	
	paralog_distance_mean = 
		pairwise_summary %>% 
		filter( D=="Y" ) %>% 
		.[["distance"]] %>% 
		mean()
	
	save.image("manuscript_checkpoint_pairwise.RData")

	

## ----simulations_null, cache=TRUE, echo=FALSE, warning=FALSE, message=FALSE----

	# Replace the actual Tau values with simulated Tau values, using the parameters 
	# estimated for each tree
	gene_trees_sim_null = foreach( tree=gene_trees_calibrated ) %dopar% 
		sim_tau( tree )
	
	# Perform contrasts 
	gene_trees_sim_null %<>% add_pics_to_trees()
	nodes_sim_null_contrast = gene_trees_sim_null %>% summarize_contrasts()
	
	# Calculate pairwise comparisons
	pairwise_sim_null_summary = foreach( tree=gene_trees_sim_null ) %dopar% 
		get_pairwise_summary( tree )
	
	# Calculate some summary statistics 
	ortholog_r_sim_null = 
		pairwise_sim_null_summary %>% 
		filter( D=="N" ) %$% 
		cor.test( tau_a, tau_b ) 
	
	paralog_r_sim_null = 
		pairwise_sim_null_summary %>% 
		filter( D=="Y" ) %$% 
		cor.test( tau_a, tau_b )


## ----simulations_oc, cache=TRUE, echo=FALSE, warning=FALSE, message=FALSE----

	# Replace the actual Tau values with simulated Tau values
	gene_trees_sim_oc = foreach( tree=gene_trees_calibrated ) %dopar% 
		sim_tau( tree, dup_adjust=dup_adjust )

	# Perform contrasts 
	gene_trees_sim_oc %<>% add_pics_to_trees()
	nodes_sim_oc_contrast = gene_trees_sim_oc %>% summarize_contrasts()
	
	# Calculate pairwise comparisons 
	pairwise_sim_oc_summary = foreach( tree=gene_trees_sim_oc ) %dopar% 
		get_pairwise_summary( tree )

	pairwise_sim_oc_summary %<>% bind_rows()

	# Calculate some summary statistics
	ortholog_r_sim_oc = 
		pairwise_sim_oc_summary %>% 
		filter( D=="N" ) %$% 
		cor.test( tau_a, tau_b ) 
	
	paralog_r_sim_oc = 
		pairwise_sim_oc_summary %>% 
		filter( D=="Y" ) %$% 
		cor.test( tau_a, tau_b ) 

	save.image("manuscript_checkpoint_calibrate_simulations.RData")

## ----phylogenetic_signal, cache=TRUE, echo=FALSE, warning=FALSE, message=FALSE----

	k_thresh = quantile( tree_summary$K, na.rm=TRUE )[3] # third quantile is the median
	k_percentile = names(k_thresh)
	genes_pass_k = tree_summary$gene[ tree_summary$K > k_thresh ]

	nodes_contrast_filtered_k = 
		nodes_contrast %>% 
			filter( gene %in% genes_pass_k )
	
	wilcox_test_result_k = wilcox_oc( nodes_contrast_filtered_k )


## ----model_selection, cache=TRUE, echo=FALSE, warning=FALSE, message=FALSE----

	dAIC_thresh = 2
	AIC_min = pmin( tree_summary$aic_bm, tree_summary$aic_ou )
	tree_summary$dAIC = tree_summary$aic_ou - tree_summary$aic_bm
	tree_summary$dAIC_bm = tree_summary$aic_bm - AIC_min
	tree_summary$dAIC_ou = tree_summary$aic_ou - AIC_min
	genes_pass_bm = tree_summary$gene[ tree_summary$dAIC_bm < dAIC_thresh ]
	genes_pass_ou = tree_summary$gene[ tree_summary$dAIC_ou < dAIC_thresh ]

	nodes_contrast_filtered_bm = 
		nodes_contrast %>% 
			filter( gene %in% genes_pass_bm )
	
	wilcox_test_result_bm = wilcox_oc( nodes_contrast_filtered_bm )


## ----model_ou, cache=TRUE, echo=FALSE, warning=FALSE, message=FALSE------

	# Get the trees that pass AIC criteria for OU
	gene_trees_pic_digests = lapply( gene_trees_pic, digest )
	gene_trees_pic_ou = gene_trees_pic[ gene_trees_pic_digests %in% genes_pass_ou ]

	# Replace the BM pics with OU pics
	gene_trees_pic_ou %<>% add_pics_to_trees( model_method="OU" )
	nodes_ou_contrast = gene_trees_pic_ou %>% summarize_contrasts()
	wilcox_ou = wilcox_oc( nodes_ou_contrast )

	save.image("manuscript_checkpoint_models.RData")


## ----calibration_sensitivity, cache=TRUE, echo=FALSE, warning=FALSE, message=FALSE----

	noised_replicate_n = 10
	sd_fraction = 0.2
	
	calibration_times_focal = 
		calibration_times %>%
		filter( clade %in% focal_calibrations_clades ) %>%
		arrange( age )
	
	noised_dates = 
		replicate( 
			noised_replicate_n, 
			add_noise_calibration_times( calibration_times_focal, sd_fraction ),
			simplify = FALSE
		)

	nodes_contrast_noised_list = lapply(
		noised_dates,
		function( x ){
			gene_trees_pruned %>% 
				calibrate_trees( x, model="correlated" ) %>% 
				add_pics_to_trees() %>% 
				summarize_contrasts()
		}
	)
	
	p_noised = lapply( nodes_contrast_noised_list, wilcox_oc )


## ----Fig_S3             -------------------------------------------------
	x = calibration_times$age[calibration_times$clade == "Hominini"]
	gene_trees_extended = foreach( tree=gene_trees_calibrated ) %dopar% 
		extend_nhx( tree, x=x )

	gene_trees_extended %<>% add_pics_to_trees()
	nodes_extended_contrast = gene_trees_extended %>% summarize_contrasts()

	pairwise_extended_summary = foreach( tree=gene_trees_extended ) %dopar% 
		get_pairwise_summary( tree )

	pairwise_extended_summary %<>% bind_rows()

## ----session_summary, echo=FALSE, comment=NA-----------------------------
	session_info_kernel = sessionInfo()
	system_time_kernel = Sys.time()

	commit_kernel = system("git log | head -n 1", intern=TRUE) %>% str_replace("commit ", "")

## ----wrap_up, echo=FALSE-------------------------------------------------
	save.image("manuscript.RData")

	time_stop = Sys.time()
	time_run = time_stop - time_start

