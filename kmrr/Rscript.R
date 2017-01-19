#Used librarys
library("plyr") #function count
library("gplots") # for rich.colors
library("lattice") # most graphs
library("qvalue")

#Color used for graphes
my.col <- colorRampPalette(c("#FFFFFF", "black", "blue", "#FA8072","#00A2FF", "#00CC00", "#E0E0E0"))(7) #1:Backgroundcolor for all graphs, 2: Foregroundcolor for all graphs (E6E6E6), 3: Fill for histograms, 4: Red, for boxplots, 5: Blue, for boxplots, 6: Green, for boxplots, 7: Light gray


############
#Parameters#
############
###Set folders
	folder <- c("./")
	#setwd(folder)

###Choose organism and data set for analysis
organism <- "Hum" 
expDataSource <- "Fagerberg" 
add <- "" 
p <- "Tau"	

####Human
###Fagerberg - RNA-seq, downloaded ArrayExpress, 27 tissues
###Brawand - RNA-seq, Bgee processed, 8 tissues
###Bodymap - RNA-seq, Bgee processed, 16 tissues

####Mouse
###ENCODE - RNA-seq, self processed, 22 tissues
###Brawand - RNA-seq, Bgee processed, 6 tissues
###Keane - RNA-seq, Bgee processed, 6 tissues
###Merkin - RNA-seq, Bgee processed, 9 tissues

####Rat
###Merkin - RNA-seq, Bgee processed, 9 tissues

####Platypus
###Brawand - RNA-seq, Bgee processed, 6 tissues

####Macaca
###Brawand - RNA-seq, Bgee processed, 6 tissues
###Merkin - RNA-seq, Bgee processed, 9 tissues

####Opossum
###Brawand - RNA-seq, Bgee processed, 6 tissues

####Chicken
###Brawand - RNA-seq, Bgee processed, 6 tissues
###Merkin - RNA-seq, Bgee processed, 9 tissues

####Gorilla
###Brawand - RNA-seq, Bgee processed, 6 tissues

####Chimp
###Brawand - RNA-seq, Bgee processed, 6 tissues

####Frog
###Necsulea - RNA-seq, Bgee processed, 6 tissues

####Cow
###Merkin - RNA-seq, Bgee processed, 9 tissues

####Fly
###ENCODE - RNA-seq, downloaded ENCODE, 6 tissues


###+++###!
fTissueNames <- function(organism, dataSource)
{	
	if(organism == "Mus")
	{
		if (dataSource == "ENCODE"){
			tissuesNames <- c("cerebellum", "cortex", "heart", "kidney", "liver", "lung", "placenta", "smintestine", "spleen", "testis", "thymus", "adrenal", "bladder", "colon", "duodenum", "flobe", "gfat", "lgintestine", "mamgland", "ovary", "sfat", "stomach")			
		} else if (dataSource == "Brawand") {
			tissuesNames <- c("brain","cerebellum","heart","kidney","liver", "testis")
		} else if (dataSource == "Keane") {
			tissuesNames <- c("heart", "hcampus", "liver", "lung", "spleen", "thymus")
		} else if (expDataSource == "Merkin") {
			tissuesNames <- c("brain", "heart", "kidney", "testis", "liver", "lung", "muscle", "spleen", "colon")
		}
	}  else if (organism == "Hum") {
		if (dataSource == "Fagerberg") {
			tissuesNames <- c("colon","kidney", "liver", "pancreas", "lung", "prostate", "brain", "stomach", "spleen", "lymphnode", "appendix", "smint", "adrenal", "duodenum", "fat", "endometrium", "placenta", "testis", "gbladder", "ubladder", "thyroid", "esophagus", "heart", "skin", "ovary", "bonem", "sgland")			
		} else if (dataSource == "Brawand") {
			tissuesNames <- c("fcortex","pcortex","tlobe","cerebellum","heart","kidney","liver", "testis")	
		} else if (dataSource == "Bodymap") {
			tissuesNames <- c("fat", "adrenal", "kidney", "brain", "colon", "ovary", "heart", "leukocyte", "liver", "lung", "lymph", "prostate", "muscle", "testis", "mamgland", "thyroid")
		}  
	}	else if (organism == "Platypus" || organism == "Macaca" || organism == "Opossum" || organism=="Chicken" || organism == "Rat") {
		if (expDataSource == "Brawand") { 
			tissuesNames <- c("brain", "heart", "kidney", "testis", "cerebellum", "liver")
		} else if (expDataSource == "Merkin") {
			tissuesNames <- c("brain", "heart", "kidney", "testis", "liver", "lung", "muscle", "spleen", "colon")
		}
	}	else if (organism == "Gorilla" || organism == "Chimp") {
		tissuesNames <- c("brain", "heart", "kidney", "testis", "cerebellum", "liver")
	}	else if (organism == "Frog") {
		tissuesNames <- c("brain", "heart", "kidney", "testis", "liver", "fgonad")
	}	else if (organism == "Cow") {
		tissuesNames <- c("brain", "heart", "kidney", "testis", "liver", "lung", "muscle", "spleen", "colon")
	}	else if (organism == "Fly") {
		tissuesNames <- c("carcass", "digestion", "head", "ovary", "agland", "testis")
	}	
	return(tissuesNames)
}	
###***###***###

###+++###!
fTissuePrintNames <- function(organism, dataSource)
{	
	if(organism == "Mus") {
		if (dataSource == "ENCODE") {
			tissuesPrintNames <- c("Cerebellum", "Cortex", "Heart", "Kidney", "Liver", "Lung","Placenta","Small Intestine","Spleen","Testis", "Thymus", "Adrenal", "Bladder", "Colon", "Duodenum", "Frontal Lobe", "Genital Fat Pad", "Large Intestine", "Mammary Gland", "Ovary", "Subcutaneous Fat Pad", "Stomach") 
		} else if (dataSource == "Brawand") {
			tissuesPrintNames <- c("Brain", "Cerebellum", "Heart", "Kidney", "Liver", "Testis")
		} else if (dataSource == "Keane") {
			tissuesPrintNames <- c("Heart", "Hippocampus", "Liver", "Lung", "Spleen", "Thymus")
		} else if (expDataSource == "Merkin") {
			tissuesPrintNames <- c("Brain", "Heart", "Kidney", "Testis", "Liver", "Lung", "Muscle", "Spleen", "Colon")
		} 		
	}  else if (organism == "Hum") {
		if (dataSource == "Fagerberg") {
			tissuesPrintNames <- c("Colon","Kidney", "Liver", "Pancreas", "Lung", "Prostate", "Brain", "Stomach", "Spleen", "Lymph Node", "Appendix", "Small Intestine", "Adrenal", "Duodenum", "Fat", "Endometrium", "Placenta", "Testis", "Gall Bladder", "Urinary Bladder", "Thyroid", "Esophagus","Heart", "Skin", "Ovary", "Bone Marrow", "Salivary Gland")	
		} else if (dataSource == "Brawand") {
			tissuesPrintNames <- c("Frontal Cortex","Prefrontal Cortex","Temporal Lobe", "Cerebellum", "Heart", "Kidney", "Liver", "Testis")
		} else if (dataSource == "Bgee") {
			tissuesPrintNames <- c("Liver", "Kidney", "Testis", "Blood", "Lung", "Colon", "Hippocampus", "Cortex", "Placenta", "Spleen", "Ovary", "Muscle", "Salivary Gland", "Bone Marrow", "Skin", "Spinal Cord", "Thymus", "Adrenal", "Hypothalamus", "Pituitary Gland", "Duodenum", "Cerebellum")
		} else if (dataSource == "Bodymap") {
			tissuesPrintNames <- c("Fat", "Adrenal", "Kidney", "Brain", "Colon", "Ovary", "Heart", "Leukocyte", "Liver", "Lung", "Lymph Node", "Prostate", "Muscle", "Testis", "Mammary Gland", "Thyroid")
		}	
	}	else if (organism == "Platypus" || organism == "Macaca" || organism == "Opossum" || organism=="Chicken" || organism == "Rat") {
		if (expDataSource == "Brawand") { 
			tissuesPrintNames <- c("Brain", "Heart", "Kidney", "Testis", "Cerebellum", "Liver")
		} else if (expDataSource == "Merkin") {
			tissuesPrintNames <- c("Brain", "Heart", "Kidney", "Testis", "Liver", "Lung", "Muscle", "Spleen", "Colon")
		}
	}	else if (organism == "Gorilla" || organism == "Chimp") {
		tissuesPrintNames <- c("Brain", "Heart", "Kidney", "Testis", "Cerebellum", "Liver")
	}	else if (organism == "Frog") {
		tissuesPrintNames <- c("Brain", "Heart", "Kidney", "Testis", "Liver", "Female Gonad")
	}	else if (organism == "Cow") {
		tissuesPrintNames <- c("Brain", "Heart", "Kidney", "Testis", "Liver", "Lung", "Muscle", "Spleen", "Colon")
	}	else if (organism == "Fly") {
		tissuesPrintNames <- c("Carcass", "Digestive System", "Head", "Ovary", "Accessory Gland", "Testis")
	}
	return(tissuesPrintNames)
}	
###***###***###	
tissuesBrHNames <- c("fcortex", "cerebellum", "heart","kidney","liver", "testis")	
tissuesBrNames <- c("brain", "cerebellum", "heart", "kidney", "liver", "testis") 

############
#Input data#
############
fInputData <- function() #
{
		if (organism == "Mus") {
			if (expDataSource == "ENCODE") {
				orgExpression <- read.table(paste(folder,"EncodeCshlAdult8wksEnsV68RNAseqGene.txt",sep=""), sep="\t", header=TRUE)
			} else if (expDataSource == "Brawand") {
				orgExpression <- read.table(paste(folder,"Mus_musculus_RNA-Seq_RPKM_GSE30352_Tissues.txt",sep=""), sep="\t", header=TRUE)	
			} else if (expDataSource == "Keane") {
				orgExpression <- read.table(paste(folder,"Mus_musculus_RNA-Seq_RPKM_GSE30617_Tissues.txt",sep=""), sep="\t", header=TRUE)
			} else if (expDataSource == "Merkin") {
				orgExpression <- read.table(paste(folder,"Mus_musculus_RNA-Seq_RPKM_GSE41637_Tissues.txt",sep=""), sep="\t", header=TRUE)
			}				
		}  else if (organism == "Hum") {
			if (expDataSource == "Fagerberg") {
				orgExpression <- read.table(paste(folder, "ArrayExpressHumanAdultEnsV69RNAseq.txt",sep=""), sep="\t", header=TRUE) 
				colnames(orgExpression) <-lapply(colnames(orgExpression),function(x){x <- unlist(strsplit(toString(x), split='_', fixed=TRUE))[1]})
			} else if (expDataSource == "Brawand") {
				orgExpression <- read.table(paste(folder,"Homo_sapiens_RNA-Seq_RPKM_GSE30352_Tissues.txt",sep=""), sep="\t", header=TRUE)
			} else if (expDataSource == "Bodymap") {
				orgExpression <- read.table(paste(folder,"Homo_sapiens_RNA-Seq_RPKM_GSE30611_Tissues.txt",sep=""), sep="\t", header=TRUE)
			} 	
		}	else if (organism == "Rat") {
			if (expDataSource == "Merkin") {
				orgExpression <- read.table(paste(folder, "Rattus_norvegicus_RNA-Seq_RPKM_GSE41637_Tissues.txt",sep=""), sep="\t", header=TRUE) 
			}
		} else if (organism == "Platypus") {
			if (expDataSource == "Brawand") {
				orgExpression <- read.table(paste(folder, "Ornithorhynchus_anatinus_RNA-Seq_RPKM_GSE30352_Tissues", ".txt",sep=""), sep="\t", header=TRUE) 
			} 
		} else if (organism == "Opossum") {
			if (expDataSource == "Brawand") {
				orgExpression <- read.table(paste(folder, "Monodelphis_domestica_RNA-Seq_RPKM_GSE30352_Tissues.txt",sep=""), sep="\t", header=TRUE)
			} 
		} else if (organism == "Macaca") {
			if (expDataSource == "Brawand") { 
				orgExpression <- read.table(paste(folder, "Macaca_mulatta_RNA-Seq_RPKM_GSE30352_Tissues.txt",sep=""), sep="\t", header=TRUE) 
			} else if (expDataSource == "Merkin") {
				orgExpression <- read.table(paste(folder, "Macaca_mulatta_RNA-Seq_RPKM_GSE41637_Tissues.txt",sep=""), sep="\t", header=TRUE) 
			}
		} else if (organism == "Chicken") {
			if (expDataSource == "Brawand") { 
				orgExpression <- read.table(paste(folder, "Gallus_gallus_RNA-Seq_RPKM_GSE30352_Tissues.txt",sep=""), sep="\t", header=TRUE) 
			} else if (expDataSource == "Merkin") {
				orgExpression <- read.table(paste(folder, "Gallus_gallus_RNA-Seq_RPKM_GSE41637_Tissues.txt",sep=""), sep="\t", header=TRUE) 
			}
		} else if (organism == "Gorilla") {
			if (expDataSource == "Brawand") {
				orgExpression <- read.table(paste(folder, "Gorilla_gorilla_RNA-Seq_RPKM_GSE30352_Tissues.txt",sep=""), sep="\t", header=TRUE) 
			} 
		} else if (organism == "Chimp") {
			if (expDataSource == "Brawand") {
				orgExpression <- read.table(paste(folder, "Pan_troglodytes_RNA-Seq_RPKM_GSE30352_Tissues.txt",sep=""), sep="\t", header=TRUE) 
			} 
		} else if (organism == "Frog") {
			if (expDataSource == "Necsulea"){
				orgExpression <- read.table(paste(folder, "Xenopus_tropicalis_RNA-Seq_RPKM_GSE43520_Tissues.txt",sep=""), sep="\t", header=TRUE)
			}
		} else if (organism == "Cow") {
			if (expDataSource == "Merkin") {
				orgExpression <- read.table(paste(folder, "Bos_taurus_RNA-Seq_RPKM_GSE41637_Tissues.txt",sep=""), sep="\t", header=TRUE) 
			}
		} else if (organism == "Fly") {
			if (expDataSource == "ENCODE") {
				orgExpression <- read.table(paste(folder, organism,"ModENCODEtissues.txt",sep=""), sep="\t", header=TRUE) 
				orgExpression <- aggregate(. ~ Ensembl.Gene.ID, FUN="mean", data=orgExpression)
			}
		} 
return(orgExpression)
}
#######


###############
###Functions###				
###############

###+++###
#Function requires data frame with expression values
#Mean values between replicates are calculated
fReplicateMean <- function(x, source, organism, names)
{
if (source == "Brawand") {
	if (organism == "Hum") {
		x$Averaged.RPKM.fcortex <- rowMeans(x[,regexpr("frontal.cortex",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.pcortex <- rowMeans(x[,regexpr("prefront.cortex",colnames(x))>0])
		x$Averaged.RPKM.tlobe <- x[,regexpr("temporal.lobe",colnames(x))>0]	
		x$Averaged.RPKM.cerebellum <- rowMeans(x[,regexpr("cerebellum",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.heart <- rowMeans(x[,regexpr("heart",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.kidney <- rowMeans(x[,regexpr("kidney",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.liver <- rowMeans(x[,regexpr("liver",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.testis <- rowMeans(x[,regexpr("testis",colnames(x))>0], na.rm=TRUE, dim=1)
		x <- x[,c("Ensembl.Gene.ID", names)]
	} else if (organism == "Mus"){
		x$Averaged.RPKM.brain <- rowMeans(x[,regexpr("brain",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.cerebellum <- rowMeans(x[,regexpr("cerebellum",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.heart <- rowMeans(x[,regexpr("heart",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.kidney <- rowMeans(x[,regexpr("kidney",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.liver <- rowMeans(x[,regexpr("liver",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.testis <- rowMeans(x[,regexpr("testis",colnames(x))>0], na.rm=TRUE, dim=1)
		x <- x[,c("Ensembl.Gene.ID", names)]
	}	else if (organism == "Platypus" || organism == "Macaca" || organism == "Opossum" || organism == "Chicken"){
		x$Averaged.RPKM.brain <- rowMeans(x[,regexpr("brain",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.cerebellum <- rowMeans(x[,regexpr("cerebellum",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.heart <- rowMeans(x[,regexpr("heart",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.kidney <- rowMeans(x[,regexpr("kidney",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.liver <- rowMeans(x[,regexpr("liver",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.testis <- rowMeans(x[,regexpr("testis",colnames(x))>0], na.rm=TRUE, dim=1)
		x <- x[,c("Ensembl.Gene.ID", names)]
	}	else if(organism == "Gorilla" ||  organism == "Chimp"){
		x$Averaged.RPKM.brain <- rowMeans(x[,regexpr("cortex",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.cerebellum <- rowMeans(x[,regexpr("cerebellum",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.heart <- rowMeans(x[,regexpr("heart",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.kidney <- rowMeans(x[,regexpr("kidney",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.liver <- rowMeans(x[,regexpr("liver",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.testis <- x[,regexpr("testis",colnames(x))>0]	
		x <- x[,c("Ensembl.Gene.ID", names)]
	} 
} else if (source == "ENCODE"){
	if (organism == "Mus") {
		x$Averaged.RPKM.cerebellum <- rowMeans(x[,regexpr("Cbellum",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.cortex <- rowMeans(x[,regexpr("Cortex",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.heart <- rowMeans(x[,regexpr("Heart",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.kidney <- rowMeans(x[,regexpr("Kidney",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.liver <- rowMeans(x[,regexpr("Liver",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.lung <- rowMeans(x[,regexpr("Lung",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.placenta <- rowMeans(x[,regexpr("Plac",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.smintestine <- rowMeans(x[,regexpr("Smint",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.spleen <- rowMeans(x[,regexpr("Spleen",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.testis <- rowMeans(x[,regexpr("Testis",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.thymus <- rowMeans(x[,regexpr("Thymus",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.adrenal <- rowMeans(x[,regexpr("Adrenal",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.bladder <- rowMeans(x[,regexpr("Bladder",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.colon <- rowMeans(x[,regexpr("Colon",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.duodenum <- rowMeans(x[,regexpr("Duod",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.flobe <- rowMeans(x[,regexpr("Flobe",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.gfat <- rowMeans(x[,regexpr("Gfat",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.lgintestine <- rowMeans(x[,regexpr("Lgint",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.mamgland <- rowMeans(x[,regexpr("Mamg",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.ovary <- rowMeans(x[,regexpr("Ovary",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.sfat <- rowMeans(x[,regexpr("Sfat",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.stomach <- rowMeans(x[,regexpr("Stom",colnames(x))>0], na.rm=TRUE, dim=1)
		x <- x[,c("Ensembl.Gene.ID", names)]
	} else if (organism == "Fly") {
		x$Averaged.RPKM.carcass <- x[,regexpr("carcass",colnames(x))>0]
		x$Averaged.RPKM.digestion <- x[,regexpr("digestive",colnames(x))>0]
		x$Averaged.RPKM.head <- rowMeans(x[,regexpr("head",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.ovary <- rowMeans(x[,regexpr("ovar",colnames(x))>0], na.rm=TRUE, dim=1)
		x$Averaged.RPKM.agland <- x[,regexpr("Gland",colnames(x))>0]
		x$Averaged.RPKM.testis <- x[,regexpr("test",colnames(x))>0]	
		x <- x[,c("Ensembl.Gene.ID", names)]
	}
} else if (source == "Fagerberg") {
	x$Averaged.RPKM.colon <- rowMeans(x[,regexpr("colon",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.kidney <- rowMeans(x[,regexpr("kidney",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.liver <- rowMeans(x[,regexpr("liver",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.pancreas <- rowMeans(x[,regexpr("pancreas",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.lung <- rowMeans(x[,regexpr("lung",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.prostate <- rowMeans(x[,regexpr("prostate",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.brain <- rowMeans(x[,regexpr("brain",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.stomach <- rowMeans(x[,regexpr("stomach",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.spleen <- rowMeans(x[,regexpr("spleen",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.lymphnode <- rowMeans(x[,regexpr("lymphnode",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.appendix <- rowMeans(x[,regexpr("appendix",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.smint <- rowMeans(x[,regexpr("smallintestine",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.adrenal <- rowMeans(x[,regexpr("adrenal",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.duodenum <- rowMeans(x[,regexpr("duodenum",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.fat <- rowMeans(x[,regexpr("fat",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.endometrium <- rowMeans(x[,regexpr("endometrium",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.placenta <- rowMeans(x[,regexpr("placenta",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.testis <- rowMeans(x[,regexpr("testis",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.gbladder <- rowMeans(x[,regexpr("gallbladder",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.ubladder <- rowMeans(x[,regexpr("urinarybladde",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.thyroid <- rowMeans(x[,regexpr("thyroid",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.esophagus <- rowMeans(x[,regexpr("esophagus",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.heart <- rowMeans(x[,regexpr("heart",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.skin <- rowMeans(x[,regexpr("skin",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.ovary <- rowMeans(x[,regexpr("ovary",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.bonem <- rowMeans(x[,regexpr("bonem",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.sgland <- rowMeans(x[,regexpr("salivarygland",colnames(x))>0], na.rm=TRUE, dim=1)
	x <- x[,c("Ensembl.Gene.ID", names)]
} else if (source == "Bodymap") {
	x$Averaged.RPKM.fat <- rowMeans(x[,regexpr("adipose",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.adrenal <- rowMeans(x[,regexpr("adrenal",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.kidney <- rowMeans(x[,regexpr("kidney",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.brain <- rowMeans(x[,regexpr("brain",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.colon <- rowMeans(x[,regexpr("colon",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.ovary <- rowMeans(x[,regexpr("female.gonad",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.heart <- rowMeans(x[,regexpr("heart",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.leukocyte <- rowMeans(x[,regexpr("leukocyte",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.liver <- rowMeans(x[,regexpr("liver",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.lung <- rowMeans(x[,regexpr("lung",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.lymph <- rowMeans(x[,regexpr("lymph",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.prostate <- rowMeans(x[,regexpr("prostate",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.muscle <- rowMeans(x[,regexpr("muscle",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.testis <- rowMeans(x[,regexpr("testis",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.mamgland <- rowMeans(x[,regexpr("mammary",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.thyroid <- rowMeans(x[,regexpr("thyroid",colnames(x))>0], na.rm=TRUE, dim=1)
	x <- x[,c("Ensembl.Gene.ID", names)]
} else if(source == "Keane") {
	x$Averaged.RPKM.heart <- rowMeans(x[,regexpr("heart",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.hcampus <- rowMeans(x[,regexpr("Ammon",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.liver <- rowMeans(x[,regexpr("liver",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.lung <- rowMeans(x[,regexpr("lung",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.spleen <- rowMeans(x[,regexpr("spleen",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.thymus <- rowMeans(x[,regexpr("thymus",colnames(x))>0], na.rm=TRUE, dim=1)
	x <- x[,c("Ensembl.Gene.ID", names)] 
} else if(source == "Necsulea") {
	x$Averaged.RPKM.brain <- rowMeans(x[,regexpr("brain",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.heart <- rowMeans(x[,regexpr("heart",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.kidney <- rowMeans(x[,regexpr("mesonephros",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.testis <- rowMeans(x[,regexpr("testis",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.liver <- rowMeans(x[,regexpr("liver",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.fgonad <- rowMeans(x[,regexpr("female.gonad",colnames(x))>0], na.rm=TRUE, dim=1)
	x <- x[,c("Ensembl.Gene.ID", names)] 
} else if(source == "Merkin") {
	x$Averaged.RPKM.brain <- rowMeans(x[,regexpr("brain",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.heart <- rowMeans(x[,regexpr("heart",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.kidney <- rowMeans(x[,regexpr("kidney",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.testis <- rowMeans(x[,regexpr("testis",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.liver <- rowMeans(x[,regexpr("liver",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.lung <- rowMeans(x[,regexpr("lung",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.muscle <- rowMeans(x[,regexpr("muscle",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.spleen <- rowMeans(x[,regexpr("spleen",colnames(x))>0], na.rm=TRUE, dim=1)
	x$Averaged.RPKM.colon <- rowMeans(x[,regexpr("colon",colnames(x))>0], na.rm=TRUE, dim=1)
	x <- x[,c("Ensembl.Gene.ID", names)] 
}   
return(x)
}
###***###***###

###+++###
#Function require a vector with expression of one gene in different tissues.
#Mean value per gene is calculated
fmean <- function(x)
{
	 	if(!all(is.na(x))) {
	 		res <- mean(x, na.rm=TRUE)
	 	} else {
	 		res <- NA
	 	}
	 	return(res)
	}
###***###***###	

###+++###
#Function require a vector with expression of one gene in different tissues.
#Max value per gene is calculated.
fmax <- function(x)
{
	 	if(!all(is.na(x))) {
	 		res <- max(x, na.rm=TRUE)
	 	} else {
	 		res <- NA
	 	}
	 	return(res)
	}
###***###***###	

###+++###
#Function require a vector with expression of one gene in different tissues.
#If expression for one tissue is not known, gene specificity for this gene is NA
#Minimum 2 tissues
fTau <- function(x)
{
	if(all(!is.na(x))) {
 		if(min(x, na.rm=TRUE) >= 0) {
 			if(max(x)!=0) {
 				x <- (1-(x/max(x)))
 				res <- sum(x, na.rm=TRUE)
 				res <- res/(length(x)-1)
 			} else {
 				res <- 0
 			}
 		} else {
 		res <- NA
 		#print("Expression values have to be positive!")
 		} 
 	} else {
 		res <- NA
 		#print("No data for this gene avalable.")
 	} 
 	return(res)
}
###***###***###

###+++###
#Function require a data frame with expression data and 
#Function give back a vector with the tissue with highest expression
fTissue <- function(x)
{
	if(!all(is.na(x))) {
		x[,-1] <- t(apply(x[,-1], c(1), function(x){x <- ifelse(x==max(x),1,0)}))
		x$Organ <- apply(x[,-1], c(1), function(x){x <- which(x>0)})
		x$Organ.Number <- sapply(x$Organ, function(x){x <- as.numeric(x[1])})
		names <- gsub("Averaged.RPKM.", "", colnames(x[,-1]))
		x$Organ.Name <- names[x$Organ.Number]
		res <- x$Organ.Name		
 	} else {
 		res <- NA
 		print("No data avalable.")
 	}
  	return(res)
}
###***###***###

###+++###
#Function prepare the data for further analysis. 
#orgExpression = data set, rpkm = cutt-off, add = number of tissues, tNames = tissues to use
#Normalisation, calculating replicate mean, sorting out not expressed genes
#Calculating Tau, maximal and mean
#Only genes with Ensembl IDs are used, or for Drosophila FlyBase IDs
fTS <- function(orgExpression, rpkm, add, tNames)
{	
	orgExpression <- orgExpression[regexpr("ENS", orgExpression$Ensembl.Gene.ID)>0 | regexpr("FBgn", orgExpression$Ensembl.Gene.ID)>0 | regexpr("PPAG", orgExpression$Ensembl.Gene.ID)>0, ]
	orgExpression <- na.omit(orgExpression)
	
	x <- orgExpression[,c(-1)]
	x[x < rpkm] <- 1
	orgExpression[,c(-1)] <- log2(x)
	rpkm <- log2(rpkm)
	
	orgExpression <- fReplicateMean(orgExpression, expDataSource, organism, paste("Averaged.RPKM.",tissuesNames, sep=""))
	orgExpression$Max <- apply(orgExpression[,c(-1)], c(1), fmax)
	orgExpression <- orgExpression[orgExpression$Max > rpkm,]
	orgExpression <- orgExpression[,c(-length(colnames(orgExpression)))]
	
	orgExpression <- orgExpression[,c("Ensembl.Gene.ID", paste("Averaged.RPKM.", tNames,sep="")) ]
	nTissues <- length(tNames)
	tissuesNames <- tNames

	print(paste("Analysis done on", nTissues, "tissue:", sep=" "))
	print(tissuesNames)

	orgExpression$Tau <- apply(orgExpression[,c(paste("Averaged.RPKM.", tissuesNames[1:nTissues], sep=""))], 1, fTau)
	orgExpression$Mean <- apply(orgExpression[,c(paste("Averaged.RPKM.", tissuesNames[1:nTissues], sep=""))], 1, fmean)
	orgExpression$Max <- apply(orgExpression[,c(paste("Averaged.RPKM.", tissuesNames[1:nTissues], sep=""))], 1, fmax)

	print(summary(orgExpression))
	
	write.table(orgExpression, file=paste(folder, organism, expDataSource,"TScomparisonTable_9_",  add,".txt",sep=""), row.names = FALSE, col.names=TRUE, quote = FALSE)
}
###***###***###

###+++###
#Function to calculate and draw correlation between conserved orthologs
#Select orthologs between all organisms
#organisms = used organisms #datasets = used data sets #add = number of tissues #textPos = text position in smoothScatter, orth= file with orthology, same order as in organisms
#Human ID should be in the first column of othologs file
fCorOrth <- function(organisms, datasets, add, textPos, orth, extra) 
{
	x <- read.table(paste(folder, organisms[1], datasets[1], "TScomparisonTable_9_", add[1],".txt", sep=""), header = TRUE, sep=" ")
	x <- x[,c("Ensembl.Gene.ID", "Tau")]	
	colnames(x) <- c("Ensembl.Gene.ID", paste(add[1], "Tau", sep="."))
	for (n in 2:length(organisms)){
		x2 <- read.table(paste(folder, organisms[n], datasets[n], "TScomparisonTable_9_",  add[n], ".txt", sep=""), header = TRUE, sep=" ")
		x2 <- x2[,c("Ensembl.Gene.ID", "Tau")]	
		colnames(x2) <- c(paste(organisms[n], ".Ensembl.Gene.ID", sep=""), paste(add[n], "Tau", sep="."))
		if(!(colnames(x2)[1] %in% colnames(x))) {
			orthologs <- read.table(paste(folder, orth[n-1], ".txt", sep=""), header = TRUE, sep=",")
			orthologs <- orthologs[regexpr("one2one", orthologs$Homology.Type)>0, ]
			orthologs <- orthologs[,c(1,2)]
			x <- merge(orthologs, x, by=c("Ensembl.Gene.ID"))
		}
		x <- merge(x, x2, by=c(paste(organisms[n],".Ensembl.Gene.ID", sep="")))	
		}
	write.table(x, file=paste(folder, organisms[1], datasets[1], "TableOrthologs_",  length(organisms), extra,"GeneIDs",".txt",sep=""), row.names = FALSE, col.names=TRUE, quote = FALSE, sep="\t")	
	x <- x[,regexpr("Tau",colnames(x))>0]	
	write.table(x, file=paste(folder, organisms[1], datasets[1], "TableOrthologs_",  length(organisms), extra,"",".txt",sep=""), row.names = FALSE, col.names=TRUE, quote = FALSE, sep="\t")	
	
	xp <- data.frame(Organisms=NA, Value=NA, Parameter=NA, Genes=NA, Tissues=NA)
	for (n in 2:length(organisms)) {
		v <- cor(x[,1],x[,n], method="pearson")
		xp <- rbind(xp,data.frame(Organisms=organisms[n], Value=as.numeric(v), Parameter="Ortholog", Genes=length(x[,1]), Tissues=gsub("[^0-9]*", "",add[n])))
	}
	xp <- xp[-1,]
	write.table(xp, file=paste(folder, organisms[1], datasets[1],"TauComparisonTable_",  length(organisms), extra,"_pearson",".txt",sep=""), row.names = FALSE, col.names=TRUE, quote = FALSE, sep="\t")

	dev.new(height=12, width=16)
	par(mfrow=c(4,5), cex.main=2.5, cex.axis=1.2, cex.lab=1.4, bg=my.col[1], fg=my.col[2], col.axis=my.col[2], col.lab=my.col[2], col.main=my.col[2])
	
	for(i in 2:length(organisms)) {
		smoothScatter(x[,paste(add[1],".", "Tau", sep="")], x[,paste(add[i],".", "Tau", sep="")],  xlab=paste("Tau", " in ", add[1], " ",organisms[1], " tissues",sep=""), 			ylab=paste("Tau", " in ", add[i], " ",organisms[i]," tissues",sep=""), nrpoint=Inf, cex=1, nbin=100, xlim=c(0,1), ylim=c(0,1))
		c <- cor(x[,paste(add[1], ".", "Tau", sep="")], x[,paste(add[i], ".", "Tau", sep="")], method="pearson")
		c <- round(c, digits=2)
		text(x=textPos[1], y=(textPos[2]+0.05), pos=2, cex=1.2,labels=paste("   R = ", c,sep=""), col="red", font=2)
	}
	title(paste("Correlation between tissue-specificity in ", length(organisms), " organisms", sep=""), outer=TRUE, line=-2)
	dev.copy2pdf(device=quartz, file=paste(folder, organisms[1], datasets[1], "TScomp_ScatPlot_9_", length(organisms),"organisms", extra,".pdf", sep=""),onefile=TRUE)
		dev.off()
}	
###***###***###

###+++###
#Function to calculate and draw correlation between orthologs
#Select orthologs between organisms pairweis, separataly for each couple
#organisms = used organisms #datasets = used data sets #add=number of tissues #textPos = text position in smoothScatter, orth= file with orthology, same order as in organisms
#Human ID should be in the first column of othologs file
fCorOrthG <- function(organisms, datasets, add, textPos, orth, extra) 
{
	x <- read.table(paste(folder, organisms[1], datasets[1], "TScomparisonTable_9_", add[1],".txt", sep=""), header = TRUE, sep=" ")

	x <- x[,c("Ensembl.Gene.ID", "Tau")]	
	colnames(x) <- c("Ensembl.Gene.ID", paste(add[1], "Tau", sep="."))
		xs <- data.frame(Organisms=NA, Value=NA, Parameter=NA, Genes=NA, Tissues=NA)
	xp <- data.frame(Organisms=NA, Value=NA, Parameter=NA, Genes=NA, Tissues=NA)

			dev.new(height=12, width=16)
			par(mfrow=c(4,5), cex.main=2.5, cex.axis=1.2, cex.lab=1.4, bg=my.col[1], fg=my.col[2], col.axis=my.col[2], col.lab=my.col[2], col.main=my.col[2])

	for (n in 2:length(organisms)){
		x2 <- read.table(paste(folder, organisms[n], datasets[n], "TScomparisonTable_9_",  add[n], ".txt", sep=""), header = TRUE, sep=" ")
		
		x2 <- x2[,c("Ensembl.Gene.ID", "Tau")]	
		colnames(x2) <- c(paste(organisms[n], ".Ensembl.Gene.ID", sep=""), paste(add[n], "Tau", sep="."))
	
		orthologs <- read.table(paste(folder, orth[n-1], ".txt", sep=""), header = TRUE, sep=",")
		orthologs <- orthologs[regexpr("one2one", orthologs$Homology.Type)>0, ]
		orthologs <- orthologs[,c(1,2)]
		x3 <- merge(orthologs, x, by=c("Ensembl.Gene.ID"))
		x3 <- merge(x3, x2, by=c(paste(organisms[n],".Ensembl.Gene.ID", sep="")))	
		x3 <- x3[,regexpr("Tau",colnames(x3))>0]		
		
		v <- cor(x3[,1],x3[,2], method="spearman")
		xs <- rbind(xs,data.frame(Organisms=organisms[n], Value=as.numeric(v), Parameter="Ortholog", Genes=length(x3[,1]), Tissues=gsub("[^0-9]*", "",add[n]) ))
		v <- cor(x3[,1],x3[,2], method="pearson")
		xp <- rbind(xp,data.frame(Organisms=organisms[n], Value=as.numeric(v), Parameter="Ortholog", Genes=length(x3[,1]), Tissues=gsub("[^0-9]*", "",add[n])))
		
			smoothScatter(x3[,1], x3[,2],  xlab=paste("Tau", " in ", add[1], " ",organisms[1], " tissues",sep=""), 			ylab=paste("Tau", " in ", add[n], " ",organisms[n]," tissues",sep=""), nrpoint=Inf, cex=1, nbin=100, xlim=c(0,1), ylim=c(0,1))
			c <- cor(x3[,1], x3[,2], method="pearson")
			c <- round(c, digits=2)
			text(x=textPos[1], y=(textPos[2]+0.05), pos=2, cex=1.2,labels=paste("   R = ", c,sep=""), col="red", font=2)
	}
	xs <- xs[-1,]
	xp <- xp[-1,]
	
	write.table(xs, file=paste(folder, organisms[1], datasets[1],"TauComparisonTable_",  length(organisms), extra,"_spearman",".txt",sep=""), row.names = FALSE, col.names=TRUE, quote = FALSE, sep="\t")
	write.table(xp, file=paste(folder, organisms[1], datasets[1],"TauComparisonTable_",  length(organisms), extra,"_pearson",".txt",sep=""), row.names = FALSE, col.names=TRUE, quote = FALSE, sep="\t")

			title(paste("Correlation between tissue-specificity in ", length(organisms), " organisms", sep=""), outer=TRUE, line=-2)
			dev.copy2pdf(device=quartz, file=paste(folder, organisms[1], datasets[1], "TScomp_ScatPlot_9_", length(organisms),"organisms", extra,".pdf", sep=""),onefile=TRUE)
			dev.off()

}	
###***###***###

###+++###
#Function to calculate and draw correlation between paralogs
#organism = used organism #dataset = used data set #add = number of tissues #textPos = text position in smoothScatter
fCorPar <- function(organism, dataset, add, textPos, extra) 
{
	x <- read.table(paste(folder, organism, dataset, "TScomparisonTable_9_", add,".txt", sep=""), header = TRUE, sep=" ")
	
	x <- x[,c("Ensembl.Gene.ID", "Tau", "Max")]	
	
	#paralogs <- read.table(paste(folder, par, ".txt", sep=""), header = TRUE, sep="\t")
	#paralogs <- paralogs[paralogs$Paralogs.Number==1, ]
	#colnames(paralogs) <- c("Ensembl.Gene.ID", "Paralog.Ensembl.Gene.ID", "Paralog.Number", "Ancestor")
	
	# paralogs$Years <- paralogs$Ancestor
	# levels(paralogs$Years) <- list("5"="Homo sapiens", "20"="Hominoidea", "92"="Euarchontoglires", "167"="Mammalia", "8"="Homininae", "42"="Simiiformes",
# "74"="Primates", "296"="Amniota", "535"="Vertebrata", "104"="Eutheria", "937"="Bilateria", "29"="Catarrhini", "722"="Chordata", "441"="Euteleostomi",
# "65"="Haplorrhini", "15"="Hominidae", "1215"="Opisthokonta", "414"="Sarcopterygii", "371"="Tetrapoda", "162"="Theria")

	# #Choose youngest paralogs
	# paralogs$Years <- as.numeric(as.character(paralogs$Years))
	# temp <- aggregate(cbind(Years)~Ensembl.Gene.ID, FUN="min", data=paralogs)
	# paralogs <- merge(temp, paralogs, by=c("Ensembl.Gene.ID", "Years"), sort=FALSE)

	# paralogs <- paralogs[order(paralogs$Years),]

	# summary(paralogs)
	# #head(paralogs)
	# paralogs <- paralogs[which((paralogs$Ensembl.Gene.ID%in%paralogs$Paralog.Ensembl.Gene.ID)), ] # In both colums
	# paralogs <- paralogs[which(as.numeric(substr(paralogs$Ensembl.Gene.ID,5,15)) < as.numeric(substr(paralogs$Paralog.Ensembl.Gene.ID,5,15))),]
	# length(unique(paralogs$Ensembl.Gene.ID))
	# summary(paralogs)
	# paralogs <- paralogs[,c("Ensembl.Gene.ID", "Paralog.Ensembl.Gene.ID", "Ancestor")]
	#paralogs <- fYoungestParalog(paralogs)
	
	#write.table(paralogs, file=paste(folder, organism, "ParalogsYoungestCouple", "", "EnsV75",".txt",sep=""), row.names = FALSE, col.names=TRUE, quote = FALSE, sep="\t")
	
	paralogs <- read.table(paste(folder, organism, "ParalogsYoungestCouple", "", "EnsV75", ".txt", sep=""), header = TRUE, sep="\t")
	
	paralogs <- merge(paralogs, x, by=c("Ensembl.Gene.ID"), sort=FALSE)
	colnames(x) <- c("Paralog.Ensembl.Gene.ID", paste("Tau",".Paralog",sep=""), "Max.Paralog")
	paralogs <- merge(paralogs, x, by=c("Paralog.Ensembl.Gene.ID"), sort=FALSE)
	print(summary(paralogs))

	if (extra == "same") { 
		names <- read.table(paste(folder,  organism, "OrthologsFrogEnsV75", ".txt", sep=""), header = TRUE, sep=",")
		names <- names[regexpr("ortholog", names$Homology.Type)>0,]
		names <- unique(names)
		summary(names)
		names <- names$Ensembl.Gene.ID
		temp <- paralogs[paralogs$Paralog.Ensembl.Gene.ID %in% names,]
		temp2 <- paralogs[paralogs$Ensembl.Gene.ID %in% names,]
		paralogs <- rbind(temp, temp2)
		paralogs <- unique(paralogs)
		summary(paralogs)
	}
	
	paralogs <- paralogs[,c("Ancestor", "Tau", paste("Tau",".Paralog",sep=""), "Max", "Max.Paralog")]
	
	paralogs[,6] <- apply(paralogs[,2:5], 1,function(x){x <- ifelse(x[3]>x[4], x[1], x[2])})
	paralogs[,7] <- apply(paralogs[,2:5], 1,function(x){x <- ifelse(x[3]>x[4], x[2], x[1])})
	temp <- paralogs[,c(1,6,7)]
	
	colnames(temp) <- colnames(paralogs[,c(1,2,3)])
	paralogs <- temp
	
	write.table(paralogs, file=paste(folder, organism, dataset,"TableParalogs_",  add, extra,".txt",sep=""), row.names = FALSE, col.names=TRUE, quote = FALSE, sep="\t")
	
	xs <- data.frame(Organisms=NA, Value=NA, Parameter=NA, Genes=NA, Tissues=NA)
	xp <- data.frame(Organisms=NA, Value=NA, Parameter=NA, Genes=NA, Tissues=NA)
	for (n in levels(paralogs$Ancestor)) {
		x <- paralogs[regexpr(n,paralogs$Ancestor) > 0,]
		v <- cor(x[,p],x[,paste(p,".Paralog",sep="")], method="spearman")
		xs <- rbind(xs,data.frame(Organisms=n, Value=as.numeric(v), Parameter="Paralog", Genes=length(x$Ancestor), Tissues=gsub("[^0-9]*", "",add)))
		v <- cor(x[,"Tau"],x[,paste("Tau",".Paralog",sep="")], method="pearson")
		xp <- rbind(xp,data.frame(Organisms=n, Value=as.numeric(v), Parameter="Paralog", Genes=length(x$Ancestor), Tissues=gsub("[^0-9]*", "",add)))
	}
	xs <- xs[-1,]
	xp <- xp[-1,]
	write.table(xs, file=paste(folder, organism, dataset,"TauComparisonTable_",  add, extra,"_paralogs", "_spearman", ".txt",sep=""), row.names = FALSE, col.names=TRUE, quote = FALSE, sep="\t")
	write.table(xp, file=paste(folder, organism, dataset,"TauComparisonTable_",  add, extra,"_paralogs", "_pearson", ".txt",sep=""), row.names = FALSE, col.names=TRUE, quote = FALSE, sep="\t")

	temp <- count(paralogs, "Ancestor")
	tempLevels <-  read.table(paste(folder, organism, "AncestorDifference", ".txt", sep=""), header = TRUE, sep="\t")
	colnames(tempLevels) <- c("Ancestor", "Age")
	tempLevels <- merge(tempLevels, temp, by="Ancestor")
	tempLevels <- tempLevels[order(tempLevels$Age),]

	paralogsLevels <- tempLevels[tempLevels$freq>1,1]

 	dev.new(height=12, width=16)
	par(mfrow=c(4,5), cex.main=2.5, cex.axis=1.2, cex.lab=1.4, bg=my.col[1], fg=my.col[2], col.axis=my.col[2], col.lab=my.col[2], col.main=my.col[2])
	
		for(n in paralogsLevels) {
		smoothScatter(paralogs[regexpr(n,paralogs$Ancestor) > 0, "Tau"], paralogs[regexpr(n,paralogs$Ancestor) > 0, paste("Tau",".Paralog",sep="")],  xlab=paste("Tau", " in ", " ", n,sep=""), 			ylab=paste("Paralog ", "Tau", " in ", " ", n,sep=""), nrpoint=Inf, cex=1, nbin=100, xlim=c(0,1), ylim=c(0,1))
		c <- cor(paralogs[regexpr(n,paralogs$Ancestor) > 0, "Tau"], paralogs[regexpr(n,paralogs$Ancestor) > 0, paste("Tau",".Paralog",sep="")], method="pearson")
		c <- round(c, digits=2)
		text(x=textPos[1], y=(textPos[2]+0.05), pos=2, cex=1.2,labels=paste("   R = ", c,sep=""), col="red", font=2)
	}
	title(paste("Correlation between tissue-specificity in ", organism, " in ", add, " tissues", sep=""), outer=TRUE, line=-2)
	dev.copy2pdf(device=quartz, file=paste(folder, organism, dataset, "TScomp_ScatPlot_paralog_", add, extra,"organism.pdf", sep=""),onefile=TRUE)#,paper="A4r"
		dev.off()
					
		x2t <- paralogs[,c(2,1)]
		x2t2 <- paralogs[,c(3,1)]
		colnames(x2t2) <- colnames(x2t)
		xp <- rbind(x2t, x2t2)
		paralogsLevels <- tempLevels[tempLevels$freq>20,1] #20 is treshold to avoid classes with few genes 
		xp <- xp[xp$Ancestor %in% paralogsLevels,]
		xp$Ancestor <- factor(xp$Ancestor, levels=paralogsLevels)
		
		#ANOVA 
		m <- lm(xp$Tau ~ xp$Ancestor)
		summary(m)
		print(anova(m))
		###

		dev.new(height=8, width=16)
			trellis.par.set(list(background=list(col=my.col[1]), add.text=list(col=my.col[2], cex=1.5),axis.line=list(col=my.col[2]), axis.text=list(col=my.col[2], 		cex=1.2), 	par.main.text=list(col=my.col[2], cex=1.5, font=2), par.xlab.text=list(col=my.col[2], cex=1.2, font=2), par.ylab.text=list(col=my.col[2], cex=1.2, font=2), plot.line=list(col=my.col[2]), dot.line=list(lwd=1, lty=2, col="#4B4B4B"))) #trellis.par.get()
		
		print(bwplot(xp[,1]~xp[,2], ylab="Tau", main="Human Tau of Paralogs",horizontal=FALSE, 
		col = c("#C6C6C6EE"),##00BFFF
		fill=c("#FF0000FF"), ##,"#0000FFEE"
		panel = function(x,y,..., box.ratio, col, pch){
			panel.violin(x=x,y=y,...,  cut = 0, varwidth = TRUE, box.ratio = box.ratio*10, col=col)
			panel.bwplot(x=x,y=y, ..., varwidth = TRUE , notch=TRUE ,box.ratio = box.ratio,  pch='|')
			},
			par.settings = list(box.rectangle=list(col=my.col[2], lwd=2), plot.symbol = list(pch='.', cex = 0.1, col=my.col[2]), box.umbrella=list(col=my.col[2])), scales=list(x=list(rot=30))))
			
		dev.copy2pdf(device=quartz, file=paste(folder, organism, dataset, "Tau", "ParalogsBoxPlot", add, extra,".pdf", sep=""),onefile=TRUE)
			dev.off()
}	
###***###***###

###+++###
#Function to draw correlations of tissue-specificity between species
#dataOrth = table with correlations between orthologs, #dataPar = table with correlations between paralogs, #organism = main organism
fSpeciesOP <- function(dataOrth, dataPar, organism, add, correlation) 
{
		dataOrthAge <- read.table(paste(folder, organism,"AgeDifference",".txt", sep=""), header = TRUE, sep=" ")
		dataOrthAge <- merge(dataOrthAge, dataOrth, by="Organisms", all.y=T)
		dataOrthAge <- dataOrthAge[c("Organisms", "Age", "Value", "Parameter", "Tissues")]
		
		colnames(dataOrthAge) <- c("Organisms", "Age", "Value", "Parameter", "Size")
		dataParAge <- read.table(paste(folder, organism,"AncestorDifference",".txt", sep=""), header = TRUE, sep="\t")
		dataParAge <- merge(dataParAge, dataPar, by="Organisms", all.y=T)
		dataParAge <- dataParAge[c("Organisms", "Age", "Value", "Parameter", "Genes")]
		colnames(dataParAge) <- c("Organisms", "Age", "Value", "Parameter", "Size")
		
		dataOrthPar <- rbind(dataOrthAge, dataParAge)
		dataOrthPar <- dataOrthPar[order(dataOrthPar$Age),]
		
		dataOrthPar <- na.omit(dataOrthPar)
		
		cP <- lm(dataOrthPar[dataOrthPar$Parameter=="Paralog", "Value"] ~ dataOrthPar[dataOrthPar$Parameter=="Paralog", "Age"], weights = dataOrthPar[dataOrthPar$Parameter=="Paralog", "Size"])
		cPlab <- paste("slope: ", round(coef(cP)[2], digits=6), sep="")

		cO <- lm(dataOrthPar[dataOrthPar$Parameter=="Ortholog", "Value"] ~ dataOrthPar[dataOrthPar$Parameter=="Ortholog", "Age"], weights = dataOrthPar[dataOrthPar$Parameter=="Ortholog", "Size"])
		cOlab <- paste("slope: ", round(coef(cO)[2], digits=6), sep="")
				
		cPlog <- lm(dataOrthPar[dataOrthPar$Parameter=="Paralog", "Value"] ~ dataOrthPar[dataOrthPar$Parameter=="Paralog", "Age"] + log10(dataOrthPar[dataOrthPar$Parameter=="Paralog", "Age"]), weights = dataOrthPar[dataOrthPar$Parameter=="Paralog", "Size"])
		cPloglab <- paste("slope: ", round(coef(cPlog)[2], digits=6), sep="")

		cOlog <- lm(dataOrthPar[dataOrthPar$Parameter=="Ortholog", "Value"] ~ dataOrthPar[dataOrthPar$Parameter=="Ortholog", "Age"] + log10(dataOrthPar[dataOrthPar$Parameter=="Ortholog", "Age"]), weights = dataOrthPar[dataOrthPar$Parameter=="Ortholog", "Size"])
		cOloglab <- paste("slope: ", round(coef(cOlog)[2], digits=6), sep="")
 
 capture.output(cat(" "), file=paste(folder, correlation, "ComparisonSpecies_withParalogs_", add, ".txt", sep="")) 
 
		capture.output(cat("ANOVA for Orthologs: linear vs. log slope"), append=TRUE, file=paste(folder, correlation, "ComparisonSpecies_withParalogs_", add, ".txt", sep="")) 
		capture.output(cat("\n\n", cOlab , " vs. ", cOloglab, "\n\n"), append=TRUE, file=paste(folder, correlation, "ComparisonSpecies_withParalogs_", add, ".txt", sep="")) 
		capture.output(anova(cO, cOlog), append=TRUE, file=paste(folder, correlation, "ComparisonSpecies_withParalogs_", add, ".txt", sep="")) 
			pValue_vector <- rbind(pValue_vector, anova(cO, cOlog)[6][2,1])
		 capture.output(cat("\n"), append=TRUE, file=paste(folder, correlation, "ComparisonSpecies_withParalogs_", add, ".txt", sep="")) 
	
		capture.output(cat("ANOVA for Orthologs: is slope different from 0 \n"), append=TRUE, file=paste(folder, correlation, "ComparisonSpecies_withParalogs_", add, ".txt", sep="")) 
		capture.output(anova(cO), append=TRUE, file=paste(folder, correlation,"ComparisonSpecies_withParalogs_", add, ".txt", sep="")) 
			pValue_vector <- rbind(pValue_vector, anova(cO)[5][1,1])
	 	capture.output(cat("\n_____________________\n\n"), append=TRUE, file=paste(folder, correlation, "ComparisonSpecies_withParalogs_", add, ".txt", sep="")) 

		
		capture.output(cat("ANOVA for Paralogs: linear vs. log slope"), append=TRUE, file=paste(folder, correlation, "ComparisonSpecies_withParalogs_", add, ".txt", sep="")) 
		capture.output(cat("\n\n", cPlab , " vs. ", cPloglab, "\n\n"), append=TRUE, file=paste(folder, correlation, "ComparisonSpecies_withParalogs_", add, ".txt", sep=""))
		capture.output(anova(cP, cPlog), append=TRUE, file=paste(folder, correlation, "ComparisonSpecies_withParalogs_", add, ".txt", sep="")) 
			pValue_vector <- rbind(pValue_vector, anova(cP, cPlog)[6][2,1])
		capture.output(cat("\n"), append=TRUE, file=paste(folder, correlation, "ComparisonSpecies_withParalogs_", add, ".txt", sep="")) 
		 
		capture.output(cat("ANOVA for Paralogs: is slope different from 0 \n"), append=TRUE, file=paste(folder, correlation, "ComparisonSpecies_withParalogs_", add, ".txt", sep="")) 
		capture.output(anova(cP), append=TRUE, file=paste(folder, correlation, "ComparisonSpecies_withParalogs_", add, ".txt", sep="")) 
			pValue_vector <- rbind(pValue_vector, anova(cP)[5][1,1])
		 capture.output(cat("\n"), append=TRUE, file=paste(folder, correlation, "ComparisonSpecies_withParalogs_", add, ".txt", sep="")) 
		 
		print(paste("Orthologs slope:", cOlab,sep=" "))
		#print(anova(cO))
		#print(anova(cO, cOlog))
		print(paste("Paralogs slope:", cPlab,sep=" "))
		#print(anova(cP))
		print(paste("Paralogs slope:", cPloglab,sep=" "))
		#print(anova(cPlog))
		#print(anova(cP, cPlog))
		
		dataOrthPar$Original.Size <- dataOrthPar$Size
		dataOrthPar$Size <- log(dataOrthPar$Size)
		dataOrthPar[dataOrthPar$Parameter=="Ortholog","Size"] <- dataOrthPar[dataOrthPar$Parameter=="Ortholog","Size"]*1.6
			
		levels(dataOrthPar$Organisms) <- list("Human"="Hum", "Gorilla"="Gorilla", "Chimpanzee"="Chimp","Macaca"="Macaca", "Mouse"="Mus", "Rat"="Rat", "Cow"="Cow", "Opossum"="Opossum", "Platypus"="Platypus", "Chicken"="Chicken", "Frog"="Frog", "Fly"="Fly", "Homo sapiens"="Homo sapiens", "Hominoidea"="Hominoidea", "Euarchontoglires"="Euarchontoglires", "Mammalia"="Mammalia", "Homininae"="Homininae", "Simiiformes"="Simiiformes", "Primates"="Primates", "Amniota"="Amniota", "Vertebrata"="Vertebrata", "Eutheria"="Eutheria", "Bilateria"="Bilateria", "Catarrhini"="Catarrhini", "Chordata"="Chordata", "Euteleostomi"="Euteleostomi", "Haplorrhini"="Haplorrhini", "Hominidae"="Hominidae", "Opisthokonta"="Opisthokonta", "Sarcopterygii"="Sarcopterygii", "Tetrapoda"="Tetrapoda", "Theria"="Theria", "Mus musculus"="Mus musculus", "Murinae"="Murinae", "Sciurognathi"="Sciurognathi", "Rodentia"="Rodentia", "Glires"="Glires")
					
	theme.novpadding <-
   	list(layout.heights =
        list(top.padding = 2, main.key.padding = 3, key.axis.padding = 6,
 	    axis.xlab.padding = 12, xlab.key.padding = 0, key.sub.padding = 0, bottom.padding = 3),
        layout.widths = list(left.padding = 3, key.ylab.padding = 0, ylab.axis.padding = 1,
 	    axis.key.padding = 0, right.padding = 1))
 	    		
		dev.new(height=10, width=16)	
		palette(rev(rich.colors(2)))
		trellis.par.set(list(background=list(col=my.col[1]), add.text=list(col=my.col[2], cex=1.5),axis.line=list(col=my.col[2]), axis.text=list(col=my.col[2], 		cex=1.2), 	par.main.text=list(col=my.col[2], cex=1.5, font=2), par.xlab.text=list(col=my.col[2], cex=1.2, font=2), par.ylab.text=list(col=my.col[2], cex=1.2, font=2), plot.line=list(col=my.col[2]), dot.line=list(lwd=1, lty=2, col="#4B4B4B"))) #trellis.par.get()
	 	    
	axis.Age <- function(side, ...)
	{
		switch(side,
		bottom = {
		prettyP <- dataOrthPar[dataOrthPar$Parameter=="Paralog", "Age"]
		labP <- paste(dataOrthPar[dataOrthPar$Parameter=="Paralog", "Organisms"], sep="")
		panel.axis(side = side, outside = TRUE, at = prettyP, labels = labP, rot=35, text.cex=1.2, text.font=2, text.col="#0000FFEE", check.overlap=TRUE)
		},
		top = {
		prettyO <- dataOrthPar[dataOrthPar$Parameter=="Ortholog", "Age"]
		labO <- paste(dataOrthPar[dataOrthPar$Parameter=="Ortholog", "Organisms"], sep="")
		panel.axis(side = side, outside = TRUE, at = prettyO, labels = labO, rot=35, text.cex=1.2, text.font=2, text.col="#FF0000FF", check.overlap=TRUE)
		},
		axis.default(side = side, ...))
	}
		print(with(dataOrthPar, xyplot(as.numeric(Value) ~ as.numeric(Age), ylim=c(-0.2,1),
		panel = function(x, y, ..., subscripts) {
			cex <- Size[subscripts]
			print(cex)
			col <- c("#FF000088", "#0000FF99")[Parameter[subscripts]]
			pch <- c(19,20)[Parameter[subscripts]]
			panel.xyplot(x, y, col=col, cex=cex, pch=pch, ...)
		},
		key=list(space="right",  font=2, points=list(pch=c(rep(19, 19),rep(20, 11)), cex=c(rep(0,3),0,0,0,log(5)*1.5,0,log(10)*1.5,0,log(20)*1.5,rep(0,7),0,0,0,log(10)*0.9,4,log(100)*0.9,4,log(1000)*0.9)), text=list(c(rep("",3),"Orthologs", "# of tissues", "", "5", "","10", "","20", rep("",7), "Paralogs", "# of genes","","10", "","100", "","1000")),col=c(rep("#FF000000",3),rep("#FF0000FF",2), "#FF000000", rep(c("#FF000088", "#FF000000"),3), rep("#0000FF00",6),rep("#0000FFEE", 2), "#0000FF00",rep(c("#0000FF99", "#0000FF00"),3)), rep=F), xlab=paste("Divergence time from ", dataOrthPar$Organisms[1], sep=""), ylab=paste(correlation, " correlation, ", expression(R), sep=" "), main=paste("Correlation of tissue specificity with phylogenetic distance", sep=""), scales=list(x=list(cex=1), y=list(cex=1.2, font=2, at=seq(-0.2,1,length.out=13), labels=c(seq(-0.2,1,0.1)))), axis=axis.Age, par.settings = theme.novpadding)))
	
		dev.copy2pdf(device=quartz, file=paste(folder, correlation,"CorrelationComparisonSpecies", "_", "withParalogs", add, ".pdf", sep=""),onefile=TRUE)#,paper="A4r"
		dev.off()

	print(dataOrthPar)
return(pValue_vector)
}
###***###***###

###+++###
#Coding is not optimal, can take 5 min to run
#Function to sort from the list of paralogs only youngest paralogs.
#Without repeats, each paralog is only once presented after sorting
##p = data frame of paralog couples. Columns to have: "Ensembl.Gene.ID", "Paralog.Ensembl.Gene.ID", "Paralog.Number", "Ancestor"
fYoungestParalog <- function(paralogs) 
{	
	paralogs$Years <- paralogs$Ancestor
	levels(paralogs$Years) <- list("5"="Homo sapiens", "20"="Hominoidea", "92"="Euarchontoglires", "167"="Mammalia", "8"="Homininae", "42"="Simiiformes",
	"74"="Primates", "296"="Amniota", "535"="Vertebrata", "104"="Eutheria", "937"="Bilateria", "29"="Catarrhini", "722"="Chordata", "441"="Euteleostomi",
	"65"="Haplorrhini", "15"="Hominidae", "1215"="Opisthokonta", "414"="Sarcopterygii", "371"="Tetrapoda", "162"="Theria", "5"="Mus musculus", "25"="Murinae", "74"="Sciurognathi", "77"="Rodentia", "86"="Glires")

	paralogs$Years <- as.numeric(as.character(paralogs$Years))
	temp <- aggregate(cbind(Years)~Ensembl.Gene.ID, FUN="min", data=paralogs)
	paralogs <- merge(temp, paralogs, by=c("Ensembl.Gene.ID", "Years"), sort=FALSE)

	cols=c(1,3)
	Nparalogs <- paralogs[ , cols]
	for (i in 1:nrow(paralogs))
	{
		Nparalogs[i,] <- sort(paralogs[i,cols])
	}

	paralogs <- paralogs[!duplicated(Nparalogs),]

	paralogs <- paralogs[order(paralogs$Years),]

	Nparalogs <- paralogs[1, ]
	for (i in 2:nrow(paralogs))
	{
		if(!(paralogs[i,3] %in% Nparalogs[,1] | paralogs[i,3] %in% Nparalogs[ ,3] | paralogs[i,1] %in% Nparalogs[ ,3])) {
			Nparalogs <- rbind(Nparalogs, paralogs[i, ])
		}
	}

	paralogs <- Nparalogs
	paralogs <- paralogs[,c("Ensembl.Gene.ID", "Paralog.Ensembl.Gene.ID", "Ancestor")]
	print(summary(paralogs))
	print(length(unique(paralogs$Ensembl.Gene.ID)))
		
	return(paralogs)
}
###***###***###

###+++###
#Function to make boxplot of orthologs and paralogs difference in tissues.
#specCoeff = Cut-off for tau, organism = reference organism, dataset = reference dataset, add = tissues number, organisms, datatsets, adds, orth, adInfo
fOrganDifference <- function(specCoeff, organism, dataset, add, organisms, datasets, adds, orth, adInfo) 
{
	#paralogs <- read.table(paste(folder, organism, "ParalogsCountsAncestorEnsV75", ".txt",sep=""), header = T, sep="\t")

	#Take only couple of paralogs of each age, descurd if more then 2
	#paralogs <- paralogs[paralogs$Paralogs.Number==1, ]
	#colnames(paralogs) <- c("Ensembl.Gene.ID", "Paralog.Ensembl.Gene.ID", "Paralog.Number", "Ancestor")
	#paralogs <- fYoungestParalog(paralogs)
	
	paralogs <- read.table(paste(folder, organism, "ParalogsYoungestCouple", "", "EnsV75", ".txt", sep=""), header = TRUE, sep="\t")
	
	expr <- read.table(paste(folder, organism, dataset, "TScomparisonTable_9_",  add, ".txt", sep=""), header = TRUE, sep=" ")
		
	expr <- expr[expr[,"Tau"] > specCoeff,] #Specific genes only, according to needed coefficient	
	expr <- expr[,c(1,grep("Averaged.RPKM.",colnames(expr)))] #take only expression values
	colnames(expr) <- gsub("Averaged.RPKM.", "", colnames(expr))

	expr[,-1] <- t(apply(expr[,-1], c(1), function(x){x <- ifelse(x == max(x), 1, 0)})) #chouse only one tissue
	
	expr$Organ <- apply(expr[,-1], c(1), function(x){x <- which(x>0)})
	
	names <- gsub("Averaged.RPKM.", "", colnames(expr[,-1]))
	expr$Organ.Name <- names[expr$Organ]
	expr <- expr[c("Ensembl.Gene.ID", "Organ", "Organ.Name")]
	
	e.paralogs <- merge(paralogs, expr, by=c("Ensembl.Gene.ID"))
	colnames(e.paralogs) <- c("Ensembl.Gene.ID.1", "Ensembl.Gene.ID", "Ancestor", "Organs", "Organs.Names")
	e.paralogs <- merge(e.paralogs, expr, by=c("Ensembl.Gene.ID"))
	colnames(e.paralogs) <- c("Ensembl.Gene.ID", "Paralog.Ensembl.Gene.ID","Ancestor", "Organs", "Organs.Names", "Paralog.Organs", "Paralog.Organs.Names")

	e.paralogs$Organs.Diff <- e.paralogs$Organs-e.paralogs$Paralog.Organs
	e.paralogs$Organs.Diff <- ifelse(e.paralogs$Organs.Diff == 0, 0, 1)
	e.paralogs$Organs.Sim <- 1-e.paralogs$Organs.Diff

	e.par.gl <- e.paralogs[e.paralogs$Organs.Sim>0,c(1,2,3,5)]	
	write.table(e.par.gl, file=paste(folder, organism, dataset,"ParalogsGeneListSameOrg", specCoeff, "Tau", adInfo,".txt",sep=""), row.names = FALSE, col.names=TRUE, quote = FALSE, sep="\t")
	
	e.par.gl <- e.paralogs[e.paralogs$Organs.Diff>0, c(1,2,3,5,7)]	
	write.table(e.par.gl, file=paste(folder, organism, dataset,"ParalogsGeneListDiffOrg", specCoeff, "Tau", adInfo,".txt",sep=""), row.names = FALSE, col.names=TRUE, quote = FALSE, sep="\t")
	
	e.paralogs <- e.paralogs[,-1]
	e.paralogs <- e.paralogs[,-1]
	e.par.diff <- aggregate(Organs.Diff ~ Ancestor, FUN="sum", data=e.paralogs)
	e.par.diff$Sort <- "VaryP"
	e.par.sim <- aggregate(Organs.Sim ~ Ancestor, FUN="sum", data=e.paralogs)
	e.par.sim$Sort <- "SameP"
	colnames(e.par.sim) <- colnames(e.par.diff)
	e.par <- rbind(e.par.diff, e.par.sim)
	e.par$op <- "AParalog"

	e.par$Years <- e.par$Ancestor
	levels(e.par$Years) <- list("5"="Homo sapiens", "20"="Hominoidea", "92"="Euarchontoglires", "167"="Mammalia", "8"="Homininae", "42"="Simiiformes",
	"74"="Primates", "296"="Amniota", "535"="Vertebrata", "104"="Eutheria", "937"="Bilateria", "29"="Catarrhini", "722"="Chordata", "441"="Euteleostomi",
	"65"="Haplorrhini", "15"="Hominidae", "1215"="Opisthokonta", "414"="Sarcopterygii", "371"="Tetrapoda", "162"="Theria")

	write.table(e.par, file=paste(folder, organism, "ParalogsOrganAncestralDifference", specCoeff, "Tau", adInfo, ".txt",sep=""), row.names = FALSE, col.names=TRUE, quote = FALSE, sep="\t")

	x <- read.table(paste(folder, organisms[1], datasets[1], "TScomparisonTable_9_", adds[1],".txt", sep=""), header = TRUE, sep=" ")
	x <- x[x[,"Tau"]>specCoeff,] #Specific genes only
				
	x$Organ <- fTissue(x[,c(1,grep("Averaged.RPKM.", colnames(x)))])
	
	x <- x[,c("Ensembl.Gene.ID", "Organ")]	
	colnames(x) <- c("Ensembl.Gene.ID", paste(adds[1], "Tissue", sep="."))
	x2 <- read.table(paste(folder, organisms[2], datasets[2], "TScomparisonTable_9_",  adds[2], ".txt", sep=""), header = TRUE, sep=" ")
	x2 <- x2[x2[,"Tau"]>specCoeff,]#Specific genes only
	
	x2$Organ <- fTissue(x2[,c(1,grep("Averaged.RPKM.", colnames(x2)))])
	x2 <- x2[,c("Ensembl.Gene.ID", "Organ")]	
	
	colnames(x2) <- c(paste(organisms[2], ".Ensembl.Gene.ID", sep=""), paste(adds[2], "Tissue", sep="."))
	
	orthologs <- read.table(paste(folder, orth[1], ".txt", sep=""), header = TRUE, sep=",")
	orthologs <- orthologs[regexpr("one2one", orthologs$Homology.Type)>0, ]
	orthologs <- orthologs[,c(1,2)]
	x.orth <- merge(orthologs, x, by=c("Ensembl.Gene.ID"))
	x.orth <- merge(x.orth, x2, by=c(paste(organisms[2],".Ensembl.Gene.ID", sep="")))	
	x.orth <- x.orth[,c(3,4)]
	colnames(x.orth) <- c("Tissue", "Ortholog.Tissue")
	x.orth$Ancestor <- organisms[2]
	for (n in 3:length(organisms)){
		x2 <- read.table(paste(folder, organisms[n], datasets[n], "TScomparisonTable_9_",  adds[n], ".txt", sep=""), header = TRUE, sep=" ")
		x2 <- x2[x2[,"Tau"]>specCoeff,]#Specific genes only
				
		x2$Organ <- fTissue(x2[,c(1,grep("Averaged.RPKM.", colnames(x2)))])
		x2 <- x2[,c("Ensembl.Gene.ID", "Organ")]	
		
		colnames(x2) <- c(paste(organisms[n], ".Ensembl.Gene.ID", sep=""), paste(adds[n], "Tissue", sep="."))
		orthologs <- read.table(paste(folder, orth[n-1], ".txt", sep=""), header = TRUE, sep=",")
		orthologs <- orthologs[regexpr("one2one", orthologs$Homology.Type)>0, ]
		orthologs <- orthologs[,c(1,2)]
		x3 <- merge(orthologs, x, by=c("Ensembl.Gene.ID"))
		x3 <- merge(x3, x2, by=c(paste(organisms[n],".Ensembl.Gene.ID", sep="")))
		x3 <- x3[,c(3,4)]
		colnames(x3) <- c("Tissue", "Ortholog.Tissue")
		x3$Ancestor <- organisms[n]
		x.orth <- rbind(x.orth, x3)
		}
	x.orth <- na.omit(x.orth)
	summary(x.orth)
	write.table(x.orth, file=paste(folder, organisms[1],"OrthologswithOrgansSpec", specCoeff, adInfo,".txt",sep=""), row.names = FALSE, col.names=TRUE, quote = FALSE, sep="\t")

	e.orthologs <- read.table(paste(folder, organisms[1], "OrthologswithOrgansSpec", specCoeff, adInfo,".txt", sep=""), header = TRUE, sep="\t") 

	levels(e.orthologs$Tissue) <- list("brain"="brain", "brain"="cerebellum", "heart"="heart", "kidney"="kidney", "liver"="liver", "testis"="testis")
	levels(e.orthologs$Ortholog.Tissue) <- list("brain"="brain", "brain"="cerebellum", "heart"="heart", "kidney"="kidney", "liver"="liver", "testis"="testis")

	e.orthologs$Organs.Diff <- ifelse(as.character(e.orthologs$Tissue) == as.character(e.orthologs$Ortholog.Tissue), 0, 1)
	e.orthologs$Organs.Diff <- ifelse(e.orthologs$Organs.Diff == 0, 0, 1)
	e.orthologs$Organs.Sim <- 1-e.orthologs$Organs.Diff

	e.orth.diff <- aggregate(Organs.Diff ~ Ancestor, FUN="sum", data=e.orthologs)
	e.orth.diff$Sort <- "Vary"
	e.orth.sim <- aggregate(Organs.Sim ~ Ancestor, FUN="sum", data=e.orthologs)
	e.orth.sim$Sort <- "Same"
	colnames(e.orth.sim) <- colnames(e.orth.diff)
	e.orth <- rbind(e.orth.diff, e.orth.sim)
	e.orth$op <- "Ortholog"

	e.orth$Years <- e.orth$Ancestor
	levels(e.orth$Years) <- list("91"="Mus", "220"="Platypus", "176"="Opossum", "325"="Chicken", "30"="Macaca", "9"="Gorilla", "97"="Cow", "361"="Frog", "91"="Rat", "5"="Hum", "910"="Fly")
	write.table(e.orth, file=paste(folder, organisms[1], "OrthologsOrganAncestralDifference", specCoeff, "Tau", adInfo,".txt",sep=""), row.names = FALSE, col.names=TRUE, quote = FALSE, sep="\t")

	e.orth <- rbind(e.orth,e.par)

	e.orth$Years <- as.numeric(as.character(e.orth$Years))
	e.orth <- e.orth[order(e.orth$Years),]

	e.orth[e.orth$op=="Ortholog", "Organs.Diff"] <- - e.orth[e.orth$op=="Ortholog", "Organs.Diff"]/10
	e.orth$row <- rep(1:(length(e.orth$op)/2), each=2)		
		
	dev.new(height=10, width=16)
	trellis.par.set(list(background=list(col=my.col[1]), add.text=list(col=my.col[2], cex=1.5), axis.line=list(col=my.col[2]), axis.text=list(col=my.col[2], cex=1.2, font=2), 	par.main.text=list(col=my.col[2], cex=1.5), par.xlab.text=list(col=my.col[2], cex=1.3, font=2), par.ylab.text=list(col=my.col[2], cex=1.3, font=2), plot.line=list(col=my.col[2]), dot.line=list(lwd=1, lty=2, col="#4B4B4B"), strip.background=list(col=my.col[1]))) #trellis.par.get()
	
	theme.novpadding <-
   		list(layout.heights =
    	    list(top.padding = 2, main.key.padding = 6, key.axis.padding = 0,
 	 	   axis.xlab.padding = 2, xlab.key.padding = 0, key.sub.padding = 0, bottom.padding = 3),
     	   layout.widths = list(left.padding = 2, key.ylab.padding = 0,
 	  	  ylab.axis.padding = 13, axis.key.padding = 0, right.padding = 22))

	axis.Age <- function(side, ...)
		{
			switch(side,
			right = {
			prettyP <- e.orth[e.orth$op=="AParalog" & e.orth$Sort=="SameP", "row"]
			labP <- paste(e.orth[e.orth$op=="AParalog" & e.orth$Sort=="SameP", "Ancestor"], sep="")
			panel.axis(side = side, outside = TRUE, at = prettyP, labels = labP, rot=0, text.cex=1.2, text.font=2, text.col="#0000FFEE", check.overlap=TRUE)},
			left = {
			prettyO <- e.orth[e.orth$op=="Ortholog" & e.orth$Sort=="Same", "row"]
			labO <- paste(e.orth[e.orth$op=="Ortholog" & e.orth$Sort=="Same", "Ancestor"], sep="")
			panel.axis(side = side, outside = TRUE, at = prettyO, labels = labO, rot=0, text.cex=1.2, text.font=2, text.col="#FF0000FF", check.overlap=TRUE)
			},
			axis.default(side = side, ...))
		}
	palette(c("black", "transparent"))
	print(barchart(as.numeric(e.orth[,"Years"])~e.orth[,"Organs.Diff"] , groups=e.orth[,"Sort"], stack=TRUE, horizontal=TRUE, main="Difference of tissue specificity with phylogenetic distance", xlab="Number of genes", ylab="Phylogenetic distance", col=c("#FF0000EE", "#0000FFEE", "#FF000066", "#0000FF66"), scales=list(y=list(rot=0, labels=unique(e.orth$Years), tck=c(1,0)), x=list( at=seq(-1000,1000, by=100), labels=c(seq(10000,0, by=-1000), seq(100,1000, by=100)),tck=c(1,0))), border=c("transparent"), box.ratio=5, axis=axis.Age, par.settings = theme.novpadding,
	panel=function(...){
		panel.barchart(...)
		tmp <- list(...)
		tmp <- data.frame(x=tmp$x, y=tmp$y)
		tmp2 <- ddply(tmp, .(y), 
					function(x){
						data.frame(x, l=rev(x$x)/sum(x$x))})
		tmp3 <- ddply(tmp2, .(y), 
					function(x){
						data.frame(x, c=rev(ifelse(x$x>40 | x$x<(-20),1,2)))})
		df <- ddply(tmp3, .(y), 
					function(x){
						data.frame(x, pos=cumsum(rev(x$x))-rev(x$x)/2)})
		panel.text(x=df$pos, y=df$y,
					label=sprintf("%.02f", df$l),
					cex=0.8, col=df$c)}))

print(e.orth)
	temp <- e.orth[e.orth$op=="Ortholog", ]
	c <- sum(temp[temp$Sort=="Same","Organs.Diff"])/sum(temp[,"Organs.Diff"])
	c <- round(c, digits=2)
	c <- c*100
	
	temp <- e.orth[e.orth$op=="AParalog", ]
	cP <- sum(temp[temp$Sort=="SameP","Organs.Diff"])/sum(temp[,"Organs.Diff"])
	cP <- round(cP, digits=2)
	cP <- cP*100
	
	temp <- e.orth[e.orth$op=="AParalog", ]
	temp <- temp[temp$row<20,]
	cPc <- sum(temp[temp$Sort=="SameP","Organs.Diff"])/sum(temp[,"Organs.Diff"])
	cPc <- round(cPc, digits=2)
	cPc <- cPc*100

	trellis.focus("toplevel")
	panel.text(0.32, 0.88, "Orthologs", cex=1.2, font=2, col="#FF0000EE")
	panel.text(0.45, 0.92, "Same tissues", cex=1.2, font=2, col="#FF0000EE")
	panel.text(0.45, 0.92, "_________________________", cex=1.2, font=2, col="#FF0000EE")
	panel.text(0.22, 0.92, "Different tissues", cex=1.2, font=2, col="#FF000066")
	panel.text(0.22, 0.92, "______________________", cex=1.2, font=2, col="#FF000066")

	panel.text(0.59, 0.92, "Same tissues", cex=1.2, font=2, col="#0000FFEE")
	panel.text(0.59, 0.92, "____________", cex=1.2, font=2, col="#0000FFEE")
	panel.text(0.74, 0.92, "Different tissues", cex=1.2, font=2, col="#0000FF66")
	panel.text(0.74, 0.92, "_____________________", cex=1.2, font=2, col="#0000FF66")
	panel.text(0.72, 0.88, "Paralogs", cex=1.2, font=2, col="#0000FFEE")

	panel.arrows(x0=0.06, x1=0.06, y0=0.1, y1=0.895, angle=15, lty=1, lwd=2)
	panel.text(0.054,0.075, "Mya", cex=1.2, font=2, col="#000000FF")
	panel.text(0.05,0.10, "0", cex=1.2, font=2, col="#000000FF")
	panel.text(0.046,0.20, "15", cex=1.2, font=2, col="#000000FF")
	panel.text(0.046,0.40, "74", cex=1.2, font=2, col="#000000FF")
	panel.text(0.043,0.49, "104", cex=1.2, font=2, col="#000000FF")
	panel.text(0.043,0.665, "325", cex=1.2, font=2, col="#000000FF")
	panel.text(0.042,0.80, "535", cex=1.2, font=2, col="#000000FF")
	panel.text(0.038,0.89, "1215", cex=1.2, font=2, col="#000000FF")
	
	panel.text(0.45,0.84, paste(c, "%", sep=""), cex=1.0, font=2, col="#FF0000EE")
	panel.text(0.23,0.84, paste(100-c, "%", sep=""), cex=1.0, font=2, col="#FF000066")
	
	panel.text(0.70,0.70, paste( "All: ", sep=""), cex=1.0, font=2, col="#0000FFEE")
	panel.text(0.78,0.70, paste(cP, "%", sep=""), cex=1.0, font=2, col="#0000FFEE")
	panel.text(0.85,0.70, paste(100-cP, "%", sep=""), cex=1.0, font=2, col="#0000FF66")
	panel.text(0.70,0.65, paste("Up to Tetrapoda", sep=""), cex=1.0, font=2, col="#0000FFEE")
	panel.text(0.78,0.65, paste(cPc, "%", sep=""), cex=1.0, font=2, col="#0000FFEE")
	panel.text(0.85,0.65, paste(100-cPc, "%", sep=""), cex=1.0, font=2, col="#0000FF66")

	trellis.unfocus()

	dev.copy2pdf(device=quartz, file=paste(folder, "OrthologsParalogsBarChart", "Tau", specCoeff, dataset, adInfo,".pdf", sep=""),onefile=TRUE)
	dev.off()

}
###***###***###

###+++###
#Choose only subset of genes based on the provided list, according to extra
fGeneChoice <- function(organism, dataset, add, extra)
{
	x <- read.table(paste(folder, organism, dataset, "TScomparisonTable_9_", add,".txt", sep=""), header = TRUE, sep=" ")
	genes <- read.table(paste(folder, organism, extra, "EnsV75", ".txt",sep=""), header = T, sep=",")
	x <- x[which(x$Ensembl.Gene.ID %in% genes$Ensembl.Gene.ID),]
	print(summary(x))
	n <- length(x[,1])
	
	write.table(x, file=paste(folder, organism, dataset, "TScomparisonTable_9_",  add, extra, ".txt",sep=""), row.names = FALSE, col.names=TRUE, quote = FALSE)	
	return(n)	
}
###***###***###

###+++###
#Function to calculate ANOVA
fAnova <- function(organism, dataset, add1, add2, extra)
{
	temp1 <- read.csv(paste(organism, dataset, "TauComparisonTable_", add1, "_pearson",".txt", sep=""), header=TRUE, sep="\t")
	temp2 <- read.csv(paste(organism, dataset, "TauComparisonTable_", add2, "_pearson", ".txt", sep=""), header=TRUE, sep="\t")
	a <- data.frame(tau = c(temp1$Value, temp2$Value), group = c(paste(temp1$Parameter, sep=""), paste(temp2$Parameter, extra, sep=" ")))

	m <- lm(a$tau ~ a$group)
	#suppressWarnings(boxplot(a$tau ~ a$group, notch=TRUE))
	return(anova(m))
} 
###***###***###

###+++###
#Function to compare paralogs with ancestral ortholog
fParAge <- function(organisms, datasets, adds, age,extra) 
{
	x <- read.table(paste(folder, organisms[1], datasets[1], "TScomparisonTable_9_", adds[1],".txt", sep=""), header = TRUE, sep=" ")
	x <- x[,c("Ensembl.Gene.ID", "Tau", "Max")]	

	paralogs <- read.table(paste(folder, organisms[1], "ParalogsYoungestCouple", "", "EnsV75", ".txt", sep=""), header = TRUE, sep="\t")
			
	paralogs <- merge(paralogs, x, by=c("Ensembl.Gene.ID"), sort=FALSE)
	colnames(x) <- c("Paralog.Ensembl.Gene.ID", paste("Tau",".Paralog",sep=""), "Max.Paralog")
	paralogs <- merge(paralogs, x, by=c("Paralog.Ensembl.Gene.ID"), sort=FALSE)
	print(summary(paralogs))
	
	paralogs[,8] <- apply(paralogs[,1:7], 1,function(x){x <- ifelse(as.numeric(x[5])>as.numeric(x[7]), x[2], x[1])})
	paralogs[,9] <- apply(paralogs[,1:7], 1,function(x){x <- ifelse(as.numeric(x[5])>as.numeric(x[7]), x[1], x[2])})
	paralogs[,10] <- apply(paralogs[,1:7], 1,function(x){x <- ifelse(as.numeric(x[5])>as.numeric(x[7]), as.numeric(x[4]), as.numeric(x[6]))})
	paralogs[,11] <- apply(paralogs[,1:7], 1,function(x){x <- ifelse(as.numeric(x[5])>as.numeric(x[7]), as.numeric(x[6]), as.numeric(x[4]))})
	temp <- paralogs[,c(8, 9, 3, 10,11)]
	colnames(temp) <- c( "Ensembl.Gene.ID", "Paralog.Ensembl.Gene.ID", "Ancestor", "Tau", "Tau.Paralog" )
	
	paralogs <- temp
		
	dev.new(height=12, width=16)
	trellis.par.set(list(background=list(col=my.col[1]), add.text=list(col=my.col[2], cex=1.5),axis.line=list(col=my.col[2]), axis.text=list(col=my.col[2], 		cex=1.2), 	par.main.text=list(col=my.col[2], cex=1.5, font=2), par.xlab.text=list(col=my.col[2], cex=1.2, font=2), par.ylab.text=list(col=my.col[2], cex=1.2, font=2), plot.line=list(col=my.col[2]), dot.line=list(lwd=1, lty=2, col="#4B4B4B"))) #trellis.par.get()

	t <- paralogs
	
	xp <- data.frame(Organisms=NA, Value=NA, Genes=NA, Tau=NA,Parameter=NA)
	j <- 1
	k <- 1
	for(i in c(2:length(organisms))){
		orthologs <- read.table(paste(folder,  organisms[1],"Orthologs", organisms[i], "EnsV75", ".txt", sep=""), header = TRUE, sep=",")
		orthologs <- orthologs[regexpr("one2many", orthologs$Homology.Type)>0,]
		orthologs <- unique(orthologs)
		summary(orthologs)
		colnames(orthologs) <- c("Ensembl.Gene.ID", "Orth.Ensembl.Gene.ID", "Homology.Type")
	
		idHum <- orthologs$Ensembl.Gene.ID
		
		temp <- paralogs[paralogs$Ensembl.Gene.ID %in% idHum,]
		temp <- merge(temp, orthologs, by="Ensembl.Gene.ID")
		x2 <- read.table(paste(folder, organisms[i], datasets[i], "TScomparisonTable_9_", adds[i],".txt", sep=""), header = TRUE, sep=" ")
		x2 <- x2[,c("Ensembl.Gene.ID", "Tau")]	
		colnames(x2) <- c("Orth.Ensembl.Gene.ID", "Tau.Orth")
		temp <- merge(temp, x2, by="Orth.Ensembl.Gene.ID")
			temp2 <- as.data.frame(table(temp$Ensembl.Gene.ID))
			temp2 <- temp2[temp2$Freq==1,]
			temp <- temp[temp$Ensembl.Gene.ID %in% temp2$Var1, ]
		paralogs <- temp[,c("Tau.Orth", "Tau", "Tau.Paralog", "Ancestor")]
		
		summary(paralogs, 20)
		
		paralogs <- paralogs[paralogs$Ancestor %in% age[[i-1]], ]
		print(summary(paralogs))
		
		v <- cor(paralogs[,1], paralogs[,2], method="pearson")
		xp <- rbind(xp,data.frame(Organisms=organisms[i], Value=as.numeric(v), Genes=length(paralogs[,1]),  Tau=mean(paralogs[,2]), Parameter="Parent"))
		v <- cor(paralogs[,1], paralogs[,3], method="pearson")
		xp <- rbind(xp,data.frame(Organisms=organisms[i], Value=as.numeric(v), Genes=length(paralogs[,1]), Tau=mean(paralogs[,3]), Parameter="Child"))
			
		temp <- paralogs[,c(1,2)]
		temp[,3] <- "Parent"
		temp2 <- paralogs[,c(1,3)]
		temp2[,3] <- "Child"
		colnames(temp2) <- c("Tau.Orth", "Tau", "V3")
		x <- rbind(temp, temp2)
	
		paralogs <- t
	
		c <- cor(x[x$V3=="Parent", 1], x[x$V3=="Parent", 2], method="pearson")
		cP <- round(c, digits=2)
		c <- cor(x[x$V3=="Child", 1], x[x$V3=="Child", 2], method="pearson")
		cC <- round(c, digits=2)

 		a <- (xyplot(x[,2]~x[,1], group=x[,3],ylab="", xlab=organisms[i], main="",horizontal=FALSE, 
		col = c("#FFA500AA", "#0000CCAA"), pch=c(16,16), cex=c(0.9,0.9),
		panel = function(x, y, ...) {
			panel.xyplot(x, y,  ...)
			panel.text(0.85,0.09, paste("R = ", cP, sep=""), cex=1, col="#0000CCDD", font=2)
			panel.text(0.85,0.06, paste("R = ", cC, sep=""), cex=1, col="#FFA500EE", font=2)
		} ,par.settings = list(plot.symbol = list(cex = 1)), scales=list(x=list(rot=30))
		))
		print(a, split=c(j,k,3,2), more=TRUE)
		if(j < 3){
			j <- j+1
		} else {
			j <- 1
			k <- k+1
		}			
	}
	print(NA, split=c(3,2,3,2), more=FALSE)	
		
	dev.copy2pdf(device=quartz, file=paste(folder, organisms[1], "", "Tau", "12species_ParalogsParentChild", extra,"Outgroup.pdf", sep=""),onefile=TRUE)#,paper="A4r"
	dev.off()	
	xp <- xp[-1,]
	
	write.table(xp, file=paste(folder, organisms[1], datasets[1],"TauComparisonTable_",  extra,"_parOP", "_pearson", ".txt",sep=""), row.names = FALSE, col.names=TRUE, quote = FALSE, sep="\t")
		
}
###***###***###	


################################
####Preparation of data sets####

#RPKM: sometimes RPKM sometimes FPKM depending on the source of data
rpkm <- 1
gene_number <- data.frame(organism=NA, number=NA)

###For Mouse ENCODE
organism <- "Mus"
expDataSource <- "ENCODE"
tissuesNames <- fTissueNames (organism, expDataSource)
tissuesPrintNames <- fTissuePrintNames (organism, expDataSource)
nTissues <- length(tissuesNames)
orgExpression <- fInputData()
fTS(orgExpression, 1, "22", tissuesNames)
n <- fGeneChoice("Mus", "ENCODE", "22", "PC")
gene_number <- rbind(gene_number, data.frame(organism="Mus_ENCODE", number=n))

fTS(orgExpression, 1, "21T", tissuesNames[grep("testis", tissuesNames, invert=TRUE)])
n <- fGeneChoice("Mus", "ENCODE", "21T", "PC")


###For Mouse Brawand
organism <- "Mus"
expDataSource <- "Brawand"
tissuesNames <- fTissueNames (organism, expDataSource)
tissuesPrintNames <- fTissuePrintNames (organism, expDataSource)
nTissues <- length(tissuesNames)
orgExpression <- fInputData()
fTS(orgExpression, 1, "6m", tissuesNames)
n <- fGeneChoice("Mus", "Brawand", "6m", "PC")
gene_number <- rbind(gene_number, data.frame(organism="Mus_Brawand", number=n))

fTS(orgExpression, 1, "5mT", tissuesNames[grep("testis", tissuesNames, invert=TRUE)]) 
n <- fGeneChoice("Mus", "Brawand", "5mT", "PC")
	
###For Mouse Keane
organism <- "Mus"
expDataSource <- "Keane"
tissuesNames <- fTissueNames (organism, expDataSource)
tissuesPrintNames <- fTissuePrintNames (organism, expDataSource)
nTissues <- length(tissuesNames)
orgExpression <- fInputData()
fTS(orgExpression, 1, "6mK", tissuesNames) 
n <- fGeneChoice("Mus", "Keane", "6mK", "PC")
gene_number <- rbind(gene_number, data.frame(organism="Mus_Keane", number=n))

###For Mouse Merkin
organism <- "Mus"
expDataSource <- "Merkin"
tissuesNames <- fTissueNames (organism, expDataSource)
tissuesPrintNames <- fTissuePrintNames (organism, expDataSource)
nTissues <- length(tissuesNames)
orgExpression <- fInputData()
fTS(orgExpression, 1, "9mM", tissuesNames) 
n <- fGeneChoice("Mus", "Merkin", "9mM", "PC") 
gene_number <- rbind(gene_number, data.frame(organism="Mus_Merkin", number=n))

fTS(orgExpression, 1, "8mMT", tissuesNames[grep("testis", tissuesNames, invert=TRUE)]) 
n <- fGeneChoice("Mus", "Merkin", "8mMT", "PC")
	
	
###For Human Fagerberg
organism <- "Hum"
expDataSource <- "Fagerberg"
tissuesNames <- fTissueNames (organism, expDataSource)
tissuesPrintNames <- fTissuePrintNames (organism, expDataSource)
nTissues <- length(tissuesNames)
orgExpression <- fInputData()
fTS(orgExpression, 1, "27", tissuesNames)
n <- fGeneChoice("Hum", "Fagerberg", "27", "PC") 
gene_number <- rbind(gene_number, data.frame(organism="Hum_Fagerberg", number=n))

fTS(orgExpression, 1, "26T", tissuesNames[grep("testis", tissuesNames, invert=TRUE)]) 
n <- fGeneChoice("Hum", "Fagerberg", "26T", "PC")


###For Human Brawand
organism <- "Hum"
expDataSource <- "Brawand"
tissuesNames <- fTissueNames (organism, expDataSource)
tissuesPrintNames <- fTissuePrintNames (organism, expDataSource)
nTissues <- length(tissuesNames)
orgExpression <- fInputData()
fTS(orgExpression, 1, "8", tissuesNames) 
n <- fGeneChoice("Hum", "Brawand", "8", "PC") 
gene_number <- rbind(gene_number, data.frame(organism="Hum_Brawand", number=n))

fTS(orgExpression, 1, "6h", tissuesBrHNames)		
n <- fGeneChoice("Hum", "Brawand", "6h", "PC")
	
fTS(orgExpression, 1, "5hT", tissuesBrHNames[grep("testis", tissuesBrHNames, invert=TRUE)]) 
n <- fGeneChoice("Hum", "Brawand", "5hT", "PC")
	
	
###For Human Bodymap
organism <- "Hum"
expDataSource <- "Bodymap"
tissuesNames <- fTissueNames (organism, expDataSource)
tissuesPrintNames <- fTissuePrintNames (organism, expDataSource)
nTissues <- length(tissuesNames)
orgExpression <- fInputData()
fTS(orgExpression, 1, "16h", tissuesNames) 
n <- fGeneChoice("Hum", "Bodymap", "16h", "PC")
gene_number <- rbind(gene_number, data.frame(organism="Hum_Bodymap", number=n))

fTS(orgExpression, 1, "15hT", tissuesNames[grep("testis", tissuesNames, invert=TRUE)]) 
n <- fGeneChoice("Hum", "Bodymap", "15hT", "PC")


###For Platypus Brawand
organism <- "Platypus"
expDataSource <- "Brawand"
tissuesNames <- fTissueNames (organism, expDataSource)
tissuesPrintNames <- fTissuePrintNames (organism, expDataSource)
nTissues <- length(tissuesNames)
orgExpression <- fInputData()
fTS(orgExpression, 1, "6p", tissuesNames)
n <- fGeneChoice("Platypus", "Brawand", "6p", "PC")
gene_number <- rbind(gene_number, data.frame(organism="Platypus_Brawand", number=n))

fTS(orgExpression, 1, "5pT", tissuesNames[grep("testis", tissuesNames, invert=TRUE)]) 
n <- fGeneChoice("Platypus", "Brawand", "5pT", "PC")


###For Macaca Brawand
organism <- "Macaca"
expDataSource <- "Brawand"
tissuesNames <- fTissueNames (organism, expDataSource)
tissuesPrintNames <- fTissuePrintNames (organism, expDataSource)
nTissues <- length(tissuesNames)
orgExpression <- fInputData()
fTS(orgExpression, 1, "6mc", tissuesNames) 
n <- fGeneChoice("Macaca", "Brawand", "6mc", "PC") 
gene_number <- rbind(gene_number, data.frame(organism="Macaca_Brawand", number=n))

fTS(orgExpression, 1, "5mcT", tissuesNames[grep("testis", tissuesNames, invert=TRUE)])
n <- fGeneChoice("Macaca", "Brawand", "5mcT", "PC")


###For Macaca Merkin
organism <- "Macaca"
expDataSource <- "Merkin"
tissuesNames <- fTissueNames (organism, expDataSource)
tissuesPrintNames <- fTissuePrintNames (organism, expDataSource)
nTissues <- length(tissuesNames)
orgExpression <- fInputData()
fTS(orgExpression, 1, "9mcM", tissuesNames) 
n <- fGeneChoice("Macaca", "Merkin", "9mcM", "PC")
gene_number <- rbind(gene_number, data.frame(organism="Macaca_Merkin", number=n))

fTS(orgExpression, 1, "8mcMT", tissuesNames[grep("testis", tissuesNames, invert=TRUE)]) 
n <- fGeneChoice("Macaca", "Merkin", "8mcMT", "PC")


###For Opossum Brawand
organism <- "Opossum"
expDataSource <- "Brawand"
tissuesNames <- fTissueNames (organism, expDataSource)
tissuesPrintNames <- fTissuePrintNames (organism, expDataSource)
nTissues <- length(tissuesNames)
orgExpression <- fInputData()
fTS(orgExpression, 1, "6o", tissuesNames)	
n <- fGeneChoice("Opossum", "Brawand", "6o", "PC") 
gene_number <- rbind(gene_number, data.frame(organism="Opossum_Brawand", number=n))

fTS(orgExpression, 1, "5oT", tissuesNames[grep("testis", tissuesNames, invert=TRUE)]) 
n <- fGeneChoice("Opossum", "Brawand", "5oT", "PC")


###For Chicken Brawand
organism <- "Chicken"
expDataSource <- "Brawand"
tissuesNames <- fTissueNames (organism, expDataSource)
tissuesPrintNames <- fTissuePrintNames (organism, expDataSource)
nTissues <- length(tissuesNames)
orgExpression <- fInputData()
fTS(orgExpression, 1, "6ch", tissuesNames)	
n <- fGeneChoice("Chicken", "Brawand", "6ch", "PC") 
gene_number <- rbind(gene_number, data.frame(organism="Chicken_Brawand", number=n))

fTS(orgExpression, 1, "5chT", tissuesNames[grep("testis", tissuesNames, invert=TRUE)]) 
n <- fGeneChoice("Chicken", "Brawand", "5chT", "PC")
	
	
###For Chicken Merkin
organism <- "Chicken"
expDataSource <- "Merkin"
tissuesNames <- fTissueNames (organism, expDataSource)
tissuesPrintNames <- fTissuePrintNames (organism, expDataSource)
orgExpression <- fInputData()
fTS(orgExpression, 1, "9chM", tissuesNames) 
n <- fGeneChoice("Chicken", "Merkin", "9chM", "PC") 
gene_number <- rbind(gene_number, data.frame(organism="Chicken_Merkin", number=n))

fTS(orgExpression, 1, "8chMT", tissuesNames[grep("testis", tissuesNames, invert=TRUE)]) 
n <- fGeneChoice("Chicken", "Merkin", "8chMT", "PC")
	
	
###For Gorilla Brawand
organism <- "Gorilla"
expDataSource <- "Brawand"
tissuesNames <- fTissueNames (organism, expDataSource)
tissuesPrintNames <- fTissuePrintNames (organism, expDataSource)
nTissues <- length(tissuesNames)
orgExpression <- fInputData()
fTS(orgExpression, 1, "6g", tissuesNames) 
n <- fGeneChoice("Gorilla", "Brawand", "6g", "PC") 
gene_number <- rbind(gene_number, data.frame(organism="Gorilla_Brawand", number=n))

fTS(orgExpression, 1, "5gT", tissuesNames[grep("testis", tissuesNames, invert=TRUE)]) 
n <- fGeneChoice("Gorilla", "Brawand", "5gT", "PC")


###For Chimp Brawand
organism <- "Chimp"
expDataSource <- "Brawand"
tissuesNames <- fTissueNames (organism, expDataSource)
tissuesPrintNames <- fTissuePrintNames (organism, expDataSource)
nTissues <- length(tissuesNames)
orgExpression <- fInputData()
fTS(orgExpression, 1, "6cm", tissuesNames) 
n <- fGeneChoice("Chimp", "Brawand", "6cm", "PC") 
gene_number <- rbind(gene_number, data.frame(organism="Chimp_Brawand", number=n))

fTS(orgExpression, 1, "5cmT", tissuesNames[grep("testis", tissuesNames, invert=TRUE)]) 
n <- fGeneChoice("Chimp", "Brawand", "5cmT", "PC")


###For Frog Necsulea
organism <- "Frog"
expDataSource <- "Necsulea"
tissuesNames <- fTissueNames (organism, expDataSource)
tissuesPrintNames <- fTissuePrintNames (organism, expDataSource)
nTissues <- length(tissuesNames)
orgExpression <- fInputData()
fTS(orgExpression, 1, "6f", tissuesNames) 
n <- fGeneChoice("Frog", "Necsulea", "6f", "PC") 
gene_number <- rbind(gene_number, data.frame(organism="Frog_Necsulea", number=n))

fTS(orgExpression, 1, "5fT", tissuesNames[grep("testis", tissuesNames, invert=TRUE)]) 
n <- fGeneChoice("Frog", "Necsulea", "5fT", "PC")
	
	
###For Cow Merkin
organism <- "Cow"
expDataSource <- "Merkin"
tissuesNames <- fTissueNames (organism, expDataSource)
tissuesPrintNames <- fTissuePrintNames (organism, expDataSource)
nTissues <- length(tissuesNames)
orgExpression <- fInputData()
fTS(orgExpression, 1, "9co", tissuesNames) 
n <- fGeneChoice("Cow", "Merkin", "9co", "PC") 
gene_number <- rbind(gene_number, data.frame(organism="Cow_Merkin", number=n))

fTS(orgExpression, 1, "8coT", tissuesNames[grep("testis", tissuesNames, invert=TRUE)]) 
n <- fGeneChoice("Cow", "Merkin", "8coT", "PC")


###For Rat Merkin
organism <- "Rat"
expDataSource <- "Merkin"
tissuesNames <- fTissueNames (organism, expDataSource)
tissuesPrintNames <- fTissuePrintNames (organism, expDataSource)
orgExpression <- fInputData()
fTS(orgExpression, 1, "9rM", tissuesNames) 
n <- fGeneChoice("Rat", "Merkin", "9rM", "PC") 
gene_number <- rbind(gene_number, data.frame(organism="Rat_Merkin", number=n))

fTS(orgExpression, 1, "8rMT", tissuesNames[grep("testis", tissuesNames, invert=TRUE)]) 
n <- fGeneChoice("Rat", "Merkin", "8rMT", "PC")


###For Fly ENCODE
organism <- "Fly"
expDataSource <- "ENCODE"
tissuesNames <- fTissueNames (organism, expDataSource)
tissuesPrintNames <- fTissuePrintNames (organism, expDataSource)
nTissues <- length(tissuesNames)
orgExpression <- fInputData()
fTS(orgExpression, 1, "6fl", tissuesNames) 
n <- fGeneChoice("Fly", "ENCODE", "6fl", "PC") 
gene_number <- rbind(gene_number, data.frame(organism="Fly_ENCODE", number=n))

fTS(orgExpression, 1, "5flT", tissuesNames[grep("testis", tissuesNames, invert=TRUE)]) 
n <- fGeneChoice("Fly", "ENCODE", "5flT", "PC")
	
gene_number

	
##################
#Age distance used
#Human - Platypus 167.4 Mya (220.2 Mya)
#Human - Mouse 92.3 Mya (91.0 Mya)
#Human - Opossum 162.6 Mya (176.1 Mya)
#Human - Chicken 296.0 Mya (324.5 Mya)
#Human - Macaca 29 Mya (29.6 Mya)
#Human - Gorilla 8.8 Mya (...)
#Human - Frog 371.2 Mya (361.2 Mya)
#Human - Cow 94.2 Mya (97.4 Mya)
#Human - Rat 92.3 Mya (91.0 Mya)
#Human - Fly 782.7 Mya (910.0 Mya)
#Human - Chimpanzee 6.6 Mya (6.2 Mya)
###################


######################################
####Choose only genes on autosomes####

fGeneChoice("Hum", "Fagerberg", "27PC", "Autosome") 
fGeneChoice("Hum", "Brawand", "8PC", "Autosome") 
fGeneChoice("Hum", "Bodymap", "16hPC", "Autosome") 
fGeneChoice("Mus", "ENCODE", "22PC", "Autosome") 
fGeneChoice("Mus", "Brawand", "6mPC", "Autosome") 
fGeneChoice("Mus", "Keane", "6mKPC", "Autosome") 
fGeneChoice("Mus", "Merkin", "9mMPC", "Autosome") 
fGeneChoice("Platypus", "Brawand", "6pPC", "Autosome") 
fGeneChoice("Macaca", "Brawand", "6mcPC", "Autosome") 
fGeneChoice("Macaca", "Merkin", "9mcMPC", "Autosome") 
fGeneChoice("Opossum", "Brawand", "6oPC", "Autosome") 
fGeneChoice("Chicken", "Merkin", "9chMPC", "Autosome") 
fGeneChoice("Chicken", "Brawand", "6chPC", "Autosome")
fGeneChoice("Gorilla", "Brawand", "6gPC", "Autosome")
fGeneChoice("Chimp", "Brawand", "6cmPC", "Autosome")
fGeneChoice("Cow", "Merkin", "9coPC", "Autosome")
fGeneChoice("Rat", "Merkin", "9rMPC", "Autosome")
#fGeneChoice("Frog", "Necsulea", "6fPC", "Autosome") #No frog, Autosoms not known
fGeneChoice("Fly", "ENCODE", "6flPC", "Autosome") 


########################################################
####Correlation of Tau in organism between orthologs####

###On Fagerberg data set
	##18 data sets, same orthologs, to the Frog
	fCorOrth(c("Hum", "Hum", "Hum", "Mus", "Mus", "Mus",  "Mus", "Platypus", "Macaca", "Macaca", "Opossum", "Chicken", "Chicken","Gorilla", "Chimp", "Cow", "Frog", "Rat"), c("Fagerberg", "Brawand", "Bodymap", "ENCODE", "Brawand", "Keane", "Merkin","Brawand", "Brawand", "Merkin","Brawand", "Merkin", "Brawand","Brawand", "Brawand", "Merkin", "Necsulea", "Merkin"), c("27PC", "8PC", "16hPC", "22PC", "6mPC", "6mKPC", "9mMPC", "6pPC",  "6mcPC", "9mcMPC", "6oPC", "9chMPC",      "6chPC",  "6gPC", "6cmPC", "9coPC", "6fPC", "9rMPC"), c(0.95,0.05), c("HumOrthologsHumEnsV75", "HumOrthologsHumEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsPlatypusEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsOpossumEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsGorillaEnsV75", "HumOrthologsChimpEnsV75", "HumOrthologsCowEnsV75", "HumOrthologsFrogEnsV75", "HumOrthologsRatEnsV75"), "FrsameO") 
	
	##All 19 data sets
	fCorOrthG(c("Hum",       "Hum",     "Hum",     "Mus",    "Mus",     "Mus",   "Mus", "Platypus", "Macaca", "Macaca", "Opossum", "Chicken", "Chicken","Gorilla", "Chimp", "Cow", "Frog",    "Rat",    "Fly"), 	c("Fagerberg", "Brawand", "Bodymap", "ENCODE", "Brawand", "Keane", "Merkin","Brawand", "Brawand", "Merkin","Brawand", "Merkin", "Brawand","Brawand", "Brawand", "Merkin", "Necsulea",  "Merkin", "ENCODE"), c("27PC",        "8PC",      "16hPC",      "22PC",     "6mPC",      "6mKPC",    "9mMPC",   "6pPC",      "6mcPC",    "9mcMPC",   "6oPC",    "9chMPC",      "6chPC",     "6gPC",     "6cmPC",    "9coPC", "6fPC",      "9rMPC",     "6flPC"), c(0.95,0.05), c("HumOrthologsHumEnsV75", "HumOrthologsHumEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsPlatypusEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsOpossumEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsGorillaEnsV75", "HumOrthologsChimpEnsV75", "HumOrthologsCowEnsV75", "HumOrthologsFrogEnsV75", "HumOrthologsRatEnsV75", "HumOrthologsFlyEnsV75"), "F") 
	
	##18 data sets, without Fly
	fCorOrthG(c("Hum",       "Hum",     "Hum",     "Mus",    "Mus",     "Mus",   "Mus", "Platypus", "Macaca", "Macaca", "Opossum", "Chicken", "Chicken","Gorilla", "Chimp", "Cow", "Frog",    "Rat"), 	c("Fagerberg", "Brawand", "Bodymap", "ENCODE", "Brawand", "Keane", "Merkin","Brawand", "Brawand", "Merkin","Brawand", "Merkin", "Brawand","Brawand", "Brawand", "Merkin", "Necsulea",  "Merkin"), c("27PC",        "8PC",      "16hPC",      "22PC",     "6mPC",      "6mKPC",    "9mMPC",   "6pPC",      "6mcPC",    "9mcMPC",   "6oPC",    "9chMPC",      "6chPC",     "6gPC",     "6cmPC",    "9coPC", "6fPC",      "9rMPC"), c(0.95,0.05), c("HumOrthologsHumEnsV75", "HumOrthologsHumEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsPlatypusEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsOpossumEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsGorillaEnsV75", "HumOrthologsChimpEnsV75", "HumOrthologsCowEnsV75", "HumOrthologsFrogEnsV75", "HumOrthologsRatEnsV75"), "wF") 

	##19 data sets, Tau calculated without testis specific genes
	fCorOrthG(c("Hum",       "Hum",     "Hum",     "Mus",    "Mus",     "Mus",   "Mus", "Platypus", "Macaca", "Macaca", "Opossum", "Chicken", "Chicken","Gorilla", "Chimp", "Cow", "Frog",    "Rat", "Fly"), 	c("Fagerberg", "Brawand", "Bodymap", "ENCODE", "Brawand", "Keane", "Merkin","Brawand", "Brawand", "Merkin","Brawand", "Merkin", "Brawand","Brawand", "Brawand", "Merkin", "Necsulea",  "Merkin", "ENCODE"), c("26TPC",  "5hTPC", "15hTPC",        "21TPC",  "5mTPC",  "6mKPC", "8mMTPC", "5pTPC",  "5mcTPC", "8mcMTPC", "5oTPC",    "8chMTPC", "5chTPC", "5gTPC",  "5cmTPC",  "8coTPC", "5fTPC",       "8rMTPC", "5flTPC"), c(0.95,0.05), c("HumOrthologsHumEnsV75", "HumOrthologsHumEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsPlatypusEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsOpossumEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsGorillaEnsV75", "HumOrthologsChimpEnsV75", "HumOrthologsCowEnsV75", "HumOrthologsFrogEnsV75", "HumOrthologsRatEnsV75", "HumOrthologsFlyEnsV75"), "testis")
	
	##18 data sets, without Frog. Only genes on autosomes
fCorOrthG(c("Hum",       "Hum",     "Hum",     "Mus",    "Mus",     "Mus",   "Mus", "Platypus", "Macaca", "Macaca", "Opossum", "Chicken", "Chicken","Gorilla", "Chimp", "Cow", "Rat",    "Fly"), 	c("Fagerberg", "Brawand", "Bodymap", "ENCODE", "Brawand", "Keane", "Merkin","Brawand", "Brawand", "Merkin","Brawand", "Merkin", "Brawand","Brawand", "Brawand", "Merkin",  "Merkin", "ENCODE"), c("27PCAutosome",        "8PCAutosome",      "16hPCAutosome",      "22PCAutosome",     "6mPCAutosome",      "6mKPCAutosome",    "9mMPCAutosome",   "6pPCAutosome",      "6mcPCAutosome",    "9mcMPCAutosome",   "6oPCAutosome",    "9chMPCAutosome",      "6chPCAutosome",     "6gPCAutosome",     "6cmPCAutosome",    "9coPCAutosome", "9rMPCAutosome",     "6flPCAutosome"), c(0.95,0.05), c("HumOrthologsHumEnsV75", "HumOrthologsHumEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsPlatypusEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsOpossumEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsGorillaEnsV75", "HumOrthologsChimpEnsV75", "HumOrthologsCowEnsV75", "HumOrthologsRatEnsV75", "HumOrthologsFlyEnsV75"), "FAutosome") 
	
###On Badymap data set	
	##All 19 data sets
	fCorOrthG(c("Hum",       "Hum",     "Hum",     "Mus",    "Mus",     "Mus",   "Mus", "Platypus", "Macaca", "Macaca", "Opossum", "Chicken", "Chicken","Gorilla", "Chimp", "Cow", "Frog",    "Rat",    "Fly"), 	c("Bodymap", "Brawand", "Fagerberg", "ENCODE", "Brawand", "Keane", "Merkin","Brawand", "Brawand", "Merkin","Brawand", "Merkin", "Brawand","Brawand", "Brawand", "Merkin", "Necsulea",  "Merkin", "ENCODE"), c("16hPC",        "8PC",      "27PC",      "22PC",     "6mPC",      "6mKPC",    "9mMPC",   "6pPC",      "6mcPC",    "9mcMPC",   "6oPC",    "9chMPC",      "6chPC",     "6gPC",     "6cmPC",    "9coPC", "6fPC",       "9rMPC",     "6flPC"), c(0.95,0.05), c("HumOrthologsHumEnsV75", "HumOrthologsHumEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsPlatypusEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsOpossumEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsGorillaEnsV75", "HumOrthologsChimpEnsV75", "HumOrthologsCowEnsV75", "HumOrthologsFrogEnsV75", "HumOrthologsRatEnsV75",  "HumOrthologsFlyEnsV75"), "F") 
	
	##18 data sets, same orthologs, to the Frog
	fCorOrth(c("Hum",       "Hum",     "Hum",     "Mus",    "Mus",     "Mus",   "Mus", "Platypus", "Macaca", "Macaca", "Opossum", "Chicken", "Chicken","Gorilla", "Chimp", "Cow", "Frog",    "Rat"), 	c("Bodymap", "Brawand", "Fagerberg", "ENCODE", "Brawand", "Keane", "Merkin","Brawand", "Brawand", "Merkin","Brawand", "Merkin", "Brawand","Brawand", "Brawand", "Merkin", "Necsulea",  "Merkin"), c("16hPC",        "8PC",      "27PC",      "22PC",     "6mPC",      "6mKPC",    "9mMPC",   "6pPC",      "6mcPC",    "9mcMPC",   "6oPC",    "9chMPC",      "6chPC",     "6gPC",     "6cmPC",    "9coPC", "6fPC",     "9rMPC"), c(0.95,0.05), c("HumOrthologsHumEnsV75", "HumOrthologsHumEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsPlatypusEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsOpossumEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsGorillaEnsV75", "HumOrthologsChimpEnsV75", "HumOrthologsCowEnsV75", "HumOrthologsFrogEnsV75", "HumOrthologsRatEnsV75"), "FrsameO")
	
	##19 data sets, Tau calculated without testis specific genes
	fCorOrthG(c("Hum", "Hum", "Hum", "Mus", "Mus", "Mus", "Mus", "Platypus", "Macaca", "Macaca", "Opossum", "Chicken", "Chicken","Gorilla", "Chimp", "Cow", "Frog", "Rat", "Fly"), c("Bodymap", "Brawand", "Fagerberg", "ENCODE", "Brawand", "Keane", "Merkin","Brawand", "Brawand", "Merkin","Brawand", "Merkin", "Brawand","Brawand", "Brawand", "Merkin", "Necsulea",  "Merkin", "ENCODE"), c("15hTPC",  "5hTPC", "26TPC", "21TPC",  "5mTPC",  "6mKPC", "8mMTPC", "5pTPC",  "5mcTPC", "8mcMTPC", "5oTPC", "8chMTPC", "5chTPC", "5gTPC",  "5cmTPC",  "8coTPC", "5fTPC", "8rMTPC", "5flTPC"), c(0.95,0.05), c("HumOrthologsHumEnsV75", "HumOrthologsHumEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsPlatypusEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsOpossumEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsGorillaEnsV75", "HumOrthologsChimpEnsV75", "HumOrthologsCowEnsV75", "HumOrthologsFrogEnsV75", "HumOrthologsRatEnsV75", "HumOrthologsFlyEnsV75"), "testis")
	
	##18 data sets, without Frog. Only genes on autosomes
	fCorOrthG(c("Hum", "Hum", "Hum", "Mus", "Mus", "Mus", "Mus", "Platypus", "Macaca", "Macaca", "Opossum", "Chicken", "Chicken","Gorilla", "Chimp", "Cow",   "Rat",  "Fly"), 	c("Bodymap", "Brawand", "Fagerberg", "ENCODE", "Brawand", "Keane", "Merkin","Brawand", "Brawand", "Merkin","Brawand", "Merkin", "Brawand","Brawand", "Brawand", "Merkin",  "Merkin", "ENCODE"), c("16hPCAutosome", "8PCAutosome", "27PCAutosome", "22PCAutosome", "6mPCAutosome", "6mKPCAutosome", "9mMPCAutosome", "6pPCAutosome", "6mcPCAutosome", "9mcMPCAutosome", "6oPCAutosome","9chMPCAutosome", "6chPCAutosome", "6gPCAutosome", "6cmPCAutosome", "9coPCAutosome",  "9rMPCAutosome", "6flPCAutosome"), c(0.95,0.05), c("HumOrthologsHumEnsV75", "HumOrthologsHumEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsPlatypusEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsOpossumEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsGorillaEnsV75", "HumOrthologsChimpEnsV75", "HumOrthologsCowEnsV75", "HumOrthologsRatEnsV75",  "HumOrthologsFlyEnsV75"), "FAutosome")
	
###On mouse data set	

	##All 19 data sets
fCorOrthG(c("Mus", "Hum", "Hum", "Hum", "Mus", "Mus", "Mus", "Platypus", "Macaca", "Macaca", "Opossum", "Chicken", "Chicken","Gorilla", "Chimp", "Cow", "Frog", "Rat", "Fly"), 	c("ENCODE", "Brawand", "Bodymap", "Fagerberg", "Brawand", "Keane", "Merkin","Brawand", "Brawand", "Merkin","Brawand", "Merkin", "Brawand","Brawand", "Brawand", "Merkin", "Necsulea", "Merkin", "ENCODE"), c("22PC", "8PC", "16hPC", "27PC", "6mPC", "6mKPC", "9mMPC", "6pPC", "6mcPC", "9mcMPC", "6oPC", "9chMPC", "6chPC", "6gPC", "6cmPC", "9coPC", "6fPC", "9rMPC", "6flPC"), c(0.95,0.05), c("MusOrthologsHumEnsV75", "MusOrthologsHumEnsV75", "MusOrthologsHumEnsV75", "MusOrthologsMusEnsV75", "MusOrthologsMusEnsV75", "MusOrthologsMusEnsV75", "MusOrthologsPlatypusEnsV75", "MusOrthologsMacacaEnsV75", "MusOrthologsMacacaEnsV75", "MusOrthologsOpossumEnsV75", "MusOrthologsChickenEnsV75", "MusOrthologsChickenEnsV75", "MusOrthologsGorillaEnsV75", "MusOrthologsChimpEnsV75", "MusOrthologsCowEnsV75", "MusOrthologsFrogEnsV75", "MusOrthologsRatEnsV75",  "MusOrthologsFlyEnsV75"), "F")

	##19 data sets, Tau calculated without testis specific genes
	fCorOrthG(c("Mus", "Hum", "Hum", "Hum", "Mus", "Mus", "Mus", "Platypus", "Macaca", "Macaca", "Opossum", "Chicken", "Chicken","Gorilla", "Chimp", "Cow", "Frog", "Rat", "Fly"), c("ENCODE", "Brawand", "Bodymap", "Fagerberg", "Brawand", "Keane", "Merkin","Brawand", "Brawand", "Merkin","Brawand", "Merkin", "Brawand","Brawand", "Brawand", "Merkin", "Necsulea",  "Merkin", "ENCODE"), c("21TPC", "5hTPC", "15hTPC", "26TPC", "5mTPC", "6mKPC", "8mMTPC", "5pTPC",  "5mcTPC", "8mcMTPC", "5oTPC", "8chMTPC", "5chTPC", "5gTPC", "5cmTPC", "8coTPC", "5fTPC", "8rMTPC", "5flTPC"), c(0.95,0.05), c("MusOrthologsHumEnsV75", "MusOrthologsHumEnsV75", "MusOrthologsHumEnsV75", "MusOrthologsMusEnsV75", "MusOrthologsMusEnsV75", "MusOrthologsMusEnsV75", "MusOrthologsPlatypusEnsV75", "MusOrthologsMacacaEnsV75", "MusOrthologsMacacaEnsV75", "MusOrthologsOpossumEnsV75", "MusOrthologsChickenEnsV75", "MusOrthologsChickenEnsV75", "MusOrthologsGorillaEnsV75", "MusOrthologsChimpEnsV75", "MusOrthologsCowEnsV75", "MusOrthologsFrogEnsV75", "MusOrthologsRatEnsV75", "MusOrthologsFlyEnsV75"), "testis") 
	
	##18 data sets, same orthologs, to the Frog
	fCorOrth(c("Mus", "Hum", "Hum", "Hum", "Mus", "Mus", "Mus", "Platypus", "Macaca", "Macaca", "Opossum", "Chicken", "Chicken","Gorilla", "Chimp", "Cow", "Frog", "Rat"), c("ENCODE", "Brawand", "Bodymap", "Fagerberg", "Brawand", "Keane", "Merkin","Brawand", "Brawand", "Merkin","Brawand", "Merkin", "Brawand","Brawand", "Brawand", "Merkin", "Necsulea",  "Merkin"), c("22PC", "8PC", "16hPC", "27PC", "6mPC", "6mKPC", "9mMPC", "6pPC", "6mcPC", "9mcMPC", "6oPC", "9chMPC", "6chPC", "6gPC", "6cmPC", "9coPC", "6fPC", "9rMPC"), c(0.95,0.05), c("MusOrthologsHumEnsV75", "MusOrthologsHumEnsV75", "MusOrthologsHumEnsV75", "MusOrthologsMusEnsV75", "MusOrthologsMusEnsV75", "MusOrthologsMusEnsV75", "MusOrthologsPlatypusEnsV75", "MusOrthologsMacacaEnsV75", "MusOrthologsMacacaEnsV75", "MusOrthologsOpossumEnsV75", "MusOrthologsChickenEnsV75", "MusOrthologsChickenEnsV75", "MusOrthologsGorillaEnsV75", "MusOrthologsChimpEnsV75", "MusOrthologsCowEnsV75", "MusOrthologsFrogEnsV75", "MusOrthologsRatEnsV75"), "FrsameO")

	##18 data sets, without Frog.Only genes on autosomes
	fCorOrthG(c("Mus", "Hum", "Hum", "Hum", "Mus", "Mus", "Mus", "Platypus", "Macaca", "Macaca", "Opossum", "Chicken", "Chicken", "Gorilla", "Chimp", "Cow", "Rat", "Fly"), c("ENCODE", "Brawand", "Bodymap", "Fagerberg", "Brawand", "Keane", "Merkin", "Brawand", "Brawand", "Merkin", "Brawand", "Merkin", "Brawand", "Brawand", "Brawand", "Merkin", "Merkin", "ENCODE"), c("22PC", "8PC", "16hPC", "27PC", "6mPC", "6mKPC", "9mMPC", "6pPC", "6mcPC", "9mcMPC", "6oPC", "9chMPC", "6chPC",     "6gPC", "6cmPC", "9coPC", "9rMPC", "6flPC"), c(0.95,0.05), c("MusOrthologsHumEnsV75", "MusOrthologsHumEnsV75", "MusOrthologsHumEnsV75", "MusOrthologsMusEnsV75", "MusOrthologsMusEnsV75", "MusOrthologsMusEnsV75", "MusOrthologsPlatypusEnsV75", "MusOrthologsMacacaEnsV75", "MusOrthologsMacacaEnsV75", "MusOrthologsOpossumEnsV75", "MusOrthologsChickenEnsV75", "MusOrthologsChickenEnsV75", "MusOrthologsGorillaEnsV75", "MusOrthologsChimpEnsV75", "MusOrthologsCowEnsV75", "MusOrthologsRatEnsV75", "MusOrthologsFlyEnsV75"), "FAutosome")


#######################################################
####Correlation of Tau in organism between paralogs####

###All paralogs
fCorPar(c("Hum"),c("Fagerberg"), c("27PC"), c(0.95,0.05), "") 
fCorPar(c("Hum"),c("Bodymap"), c("16hPC"), c(0.95,0.05), "")
fCorPar(c("Mus"), c("ENCODE"), c("22PC"), c(0.95,0.05), "") 

###Tissue-specificity calculated without testis
fCorPar(c("Hum"),c("Fagerberg"), c("26TPC"), c(0.95,0.05), "testis") 
fCorPar(c("Hum"),c("Bodymap"), c("15hTPC"), c(0.95,0.05), "testis") 
fCorPar(c("Mus"), c("ENCODE"), c("21TPC"), c(0.95,0.05), "testis")

###Without genes on sex-chromosomes
fCorPar(c("Hum"),c("Fagerberg"), c("27PCAutosome"), c(0.95,0.05), "")
fCorPar(c("Hum"),c("Bodymap"), c("16hPCAutosome"), c(0.95,0.05), "")
fCorPar(c("Mus"), c("ENCODE"), c("22PCAutosome"), c(0.95,0.05), "")

###Paralogs with ortholog in frog
fCorPar(c("Hum"),c("Fagerberg"), c("27PC"), c(0.95,0.05), "same")
fCorPar(c("Hum"),c("Bodymap"), c("16hPC"), c(0.95,0.05), "same")
fCorPar(c("Mus"), c("ENCODE"), c("22PC"), c(0.95,0.05), "same") 


############################################################		
####Orthologs/paralogs correlation with divergenece time####

pValue_vector <- data.frame(pValue=NA)
###On Fagerberg data set
	
	##All orthologs/paralogs
	data <- read.table(paste(folder, "HumFagerbergTauComparisonTable_19F_pearson",".txt", sep=""), header = TRUE, sep="\t")
	data2 <- read.table(paste(folder, "HumFagerbergTauComparisonTable_27PC_paralogs_pearson",".txt", sep=""), header = TRUE, sep="\t")
	pValue_vector <- fSpeciesOP(data, data2, "Hum", "19F", "Pearson")
	
	##All orthologs/paralogs; spearman correlation
	data <- read.table(paste(folder, "HumFagerbergTauComparisonTable_19F_spearman",".txt", sep=""), header = TRUE, sep="\t")
	data2 <- read.table(paste(folder, "HumFagerbergTauComparisonTable_27PC_paralogs_spearman",".txt", sep=""), header = TRUE, sep="\t")
	pValue_vector <- fSpeciesOP(data, data2, "Hum", "19F", "Spearman")

	##All organisms without fly
	data <- read.table(paste(folder, "HumFagerbergTauComparisonTable_18wF_pearson",".txt", sep=""), header = TRUE, sep="\t")
	data2 <- read.table(paste(folder, "HumFagerbergTauComparisonTable_27PC_paralogs_pearson",".txt", sep=""), header = TRUE, sep="\t")
	pValue_vector <- fSpeciesOP(data, data2, "Hum", "18wF", "Pearson")

	##Conserved orthologs to frog. Paralogs, that have ortholog to frog
	data <- read.table(paste(folder, "HumFagerbergTauComparisonTable_18FrsameO_pearson",".txt", sep=""), header = TRUE, sep="\t")
	data2 <- read.table(paste(folder, "HumFagerbergTauComparisonTable_27PCsame_paralogs_pearson",".txt", sep=""), header = TRUE, sep="\t")
	pValue_vector <- fSpeciesOP(data, data2, "Hum", "18Frsame", "Pearson")

	##Tissue-specificity calculated without testis
	data <- read.table(paste(folder, "HumFagerbergTauComparisonTable_19testis_pearson",".txt", sep=""), header = TRUE, sep="\t")
	data2 <- read.table(paste(folder, "HumFagerbergTauComparisonTable_26TPCtestis_paralogs_pearson",".txt", sep=""), header = TRUE, sep="\t")
	pValue_vector <- fSpeciesOP(data, data2, "Hum", "19testis", "Pearson")
	
	##Without genes on sex-chromosomes
	data <- read.table(paste(folder, "HumFagerbergTauComparisonTable_18FAutosome_pearson",".txt", sep=""), header = TRUE, sep="\t") #TO
	data2 <- read.table(paste(folder, "HumFagerbergTauComparisonTable_27PCAutosome_paralogs_pearson",".txt", sep=""), header = TRUE, sep="\t") #TO
	pValue_vector <- fSpeciesOP(data, data2, "Hum", "18FAutosome", "Pearson")

###On Bodymap data set

	##All orthologs/paralogs
	data <- read.table(paste(folder, "HumBodymapTauComparisonTable_19F_pearson",".txt", sep=""), header = TRUE, sep="\t")
	data2 <- read.table(paste(folder, "HumBodymapTauComparisonTable_16hPC_paralogs_pearson",".txt", sep=""), header = TRUE, sep="\t")
	pValue_vector <- fSpeciesOP(data, data2, "Hum", "19FBodymap", "Pearson")

	##Conserved orthologs to frog. Paralogs, that have ortholog to frog
	data <- read.table(paste(folder, "HumBodymapTauComparisonTable_18FrsameO_pearson",".txt", sep=""), header = TRUE, sep="\t")
	data2 <- read.table(paste(folder, "HumBodymapTauComparisonTable_16hPCsame_paralogs_pearson",".txt", sep=""), header = TRUE, sep="\t")
	pValue_vector <- fSpeciesOP(data, data2, "Hum", "18Bsame", "Pearson")

	##Tissue-specificity calculated without testis
	data <- read.table(paste(folder, "HumBodymapTauComparisonTable_19testis_pearson",".txt", sep=""), header = TRUE, sep="\t")
	data2 <- read.table(paste(folder, "HumBodymapTauComparisonTable_15hTPCtestis_paralogs_pearson",".txt", sep=""), header = TRUE, sep="\t")
	pValue_vector <- fSpeciesOP(data, data2, "Hum", "19Btestis", "Pearson")

	##Without genes on sex-chromosomes
	data <- read.table(paste(folder, "HumBodymapTauComparisonTable_18FAutosome_pearson",".txt", sep=""), header = TRUE, sep="\t")
	data2 <- read.table(paste(folder, "HumBodymapTauComparisonTable_16hPCAutosome_paralogs_pearson",".txt", sep=""), header = TRUE, sep="\t")
	pValue_vector <- fSpeciesOP(data, data2, "Hum", "18BAutosome", "Pearson")

###On mouse data set

	##All orthologs/paralogs
	data <- read.table(paste(folder, "MusENCODETauComparisonTable_19F_pearson",".txt", sep=""), header = TRUE, sep="\t") #TO
	data2 <- read.table(paste(folder, "MusENCODETauComparisonTable_22PC_paralogs_pearson",".txt", sep=""), header = TRUE, sep="\t") 
	pValue_vector <- fSpeciesOP(data, data2, "Mus", "19Fmus", "Pearson") 

	##Conserved orthologs to frog. Paralogs, that have ortholog to frog
	data <- read.table(paste(folder, "MusENCODETauComparisonTable_18FrsameO_pearson",".txt", sep=""), header = TRUE, sep="\t") 
	data2 <- read.table(paste(folder, "MusENCODETauComparisonTable_22PCsame_paralogs_pearson",".txt", sep=""), header = TRUE, sep="\t") 
pValue_vector <- fSpeciesOP(data, data2, "Mus", "18FrsameMus", "Pearson") 

	##Tissue-specificity calculated without testis
	data <- read.table(paste(folder, "MusENCODETauComparisonTable_19testis_pearson",".txt", sep=""), header = TRUE, sep="\t") #TO
	data2 <- read.table(paste(folder, "MusENCODETauComparisonTable_21TPCtestis_paralogs_pearson",".txt", sep=""), header = TRUE, sep="\t")
	pValue_vector <- fSpeciesOP(data, data2, "Mus", "19Mtestis", "Pearson")

	##Without genes on sex-chromosomes
	data <- read.table(paste(folder, "MusENCODETauComparisonTable_18FAutosome_pearson",".txt", sep=""), header = TRUE, sep="\t") 
	data2 <- read.table(paste(folder, "MusENCODETauComparisonTable_22PCAutosome_paralogs_pearson",".txt", sep=""), header = TRUE, sep="\t")
	pValue_vector <- fSpeciesOP(data, data2, "Mus", "18FMAutosome", "Pearson") 


##################################################################
####Barchart with orthologs/paralogs difference between organs####

###Cut-off 0.3###

	##All orthologs/paralogs
	fOrganDifference(0.3, "Hum", "Brawand", "6h", c("Hum", "Mus", "Platypus", "Macaca", "Opossum", "Chicken", "Gorilla"), c("Brawand", "Brawand", "Brawand", "Brawand", "Brawand", "Brawand", "Brawand"), c("6hPC", "6mPC", "6pPC", "6mcPC", "6oPC", "6chPC", "6gPC"), c("HumOrthologsMusEnsV75", "HumOrthologsPlatypusEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsOpossumEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsGorillaEnsV75"), "")

	#Tissue-specificity calculated without testis
	fOrganDifference(0.3, "Hum", "Brawand", "5hT", c("Hum", "Mus", "Platypus", "Macaca", "Opossum", "Chicken", "Gorilla"), c("Brawand", "Brawand", "Brawand", "Brawand", "Brawand", "Brawand", "Brawand"), c("5hTPC", "5mTPC", "5pTPC", "5mcTPC", "5oTPC", "5chTPC", "5gTPC"), c("HumOrthologsMusEnsV75", "HumOrthologsPlatypusEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsOpossumEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsGorillaEnsV75"), "testis")

###Cut-off 0.8###

	#All orthologs/paralogs
	fOrganDifference(0.8, "Hum", "Brawand", "6h", c("Hum", "Mus", "Platypus", "Macaca", "Opossum", "Chicken", "Gorilla"), c("Brawand", "Brawand", "Brawand", "Brawand", "Brawand", "Brawand", "Brawand"), c("6hPC", "6mPC", "6pPC", "6mcPC", "6oPC", "6chPC", "6gPC"), c("HumOrthologsMusEnsV75", "HumOrthologsPlatypusEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsOpossumEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsGorillaEnsV75"), "") 

	#Tissue specificity calculated without testis
	fOrganDifference(0.8, "Hum", "Brawand", "5hT", c("Hum", "Mus", "Platypus", "Macaca", "Opossum", "Chicken", "Gorilla"), c("Brawand", "Brawand", "Brawand", "Brawand", "Brawand", "Brawand", "Brawand"), c("5hTPC", "5mTPC", "5pTPC", "5mcTPC", "5oTPC", "5chTPC", "5gTPC"), c("HumOrthologsMusEnsV75", "HumOrthologsPlatypusEnsV75", "HumOrthologsMacacaEnsV75", "HumOrthologsOpossumEnsV75", "HumOrthologsChickenEnsV75", "HumOrthologsGorillaEnsV75"), "testis")


########################
####Paralog question####

fParAge(c("Hum", "Chimp", "Macaca", "Opossum", "Platypus", "Frog", "Fly"), c("Fagerberg", "Brawand", "Merkin", "Brawand", "Brawand", "Necsulea", "ENCODE"), c("27PC", "6cmPC", "9mcMPC", "6oPC", "6pPC", "6fPC", "6flPC"), list("Homo sapiens",  c("Homininae", "Hominidae", "Hominoidea", "Catarrhini"), c("Primates", "Haplorrhini", "Simiformes", "Euarchontoglires", "Eutheria"), c("Theria", "Mammalia"), "Amniota", c("Chordata")), "paper")


###################
####ANOVA tests####
	capture.output(cat("\n Orthologs with vs. without Fly: "), file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Hum", "Fagerberg", "19F", "18wF", "")
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
	
	capture.output(cat("\n \n ________________________________ \n \n"), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep=""))	

	
	capture.output(cat("\n Orthologs vs. paralogs: "), append=TRUE,  file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Hum", "Fagerberg", "19F", "27PC_paralogs", "") #Orthologs vs. paralogs 
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
	
	capture.output(cat("\n \n \n Orthologs: all vs. conserved: "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Hum", "Fagerberg", "19F", "18FrsameO", "conserved") #Orthologs: all vs. conserved
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
	
	capture.output(cat("\n \n \n Orthologs vs. paralogs, on Bodymap: "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Hum", "Bodymap", "19F", "16hPC_paralogs", "") #Orthologs vs. paralogs, on Bodymap 
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
	
	capture.output(cat("\n \n \n Orthologs on Bodymap: all vs. conserved: "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Hum", "Bodymap", "19F", "18FrsameO", "conserved") #Orthologs on Bodymap: all vs. conserved
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
		
	capture.output(cat("\n \n \n Orthologs vs. paralogs, on mouse : "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Mus", "ENCODE", "19F", "22PC_paralogs", "") #Orthologs vs. paralogs, on mouse 
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
		
	capture.output(cat("\n \n \n Orthologs on mouse: all vs. conserved: "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Mus", "ENCODE", "19F", "18FrsameO", "conserved") #Orthologs: all vs. conserved
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])

	capture.output(cat("\n \n ________________________________ \n \n"), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep=""))


	capture.output(cat("\n \n \n Orthologs vs. paralogs without testis: "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Hum", "Fagerberg", "19testis", "26TPCtestis_paralogs", "") #Orthologs vs. paralogs without testis
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
		
	capture.output(cat("\n \n \n Orthologs: all vs. without testis: "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Hum", "Fagerberg", "19F", "19testis", "testis") #Orthologs: all vs. without testis
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
		
	capture.output(cat("\n \n \n Paralogs: all vs. without testis: "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Hum", "Fagerberg", "27PC_paralogs", "26TPCtestis_paralogs", "testis") #Paralogs: all vs. without testis
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
		
	capture.output(cat("\n----------------------"), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep=""))


	capture.output(cat("\n \n \n Orthologs vs. paralogs, on Bodymap without testis: "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Hum", "Bodymap", "19testis", "15hTPCtestis_paralogs", "") #Orthologs vs. paralogs, on Bodymap without testis
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
		
	capture.output(cat("\n \n \n Orthologs on Bodymap: all vs. without testis: "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Hum", "Bodymap", "19F", "19testis", "testis") #Orthologs on Bodymap: all vs. without testis
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
		
	capture.output(cat("\n \n \n Paralogs on Bodymap: all vs. without testis: "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Hum", "Bodymap", "16hPC_paralogs", "15hTPCtestis_paralogs", "testis") #Paralogs on Bodymap: all vs. without testis
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
		
	capture.output(cat("\n----------------------"), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep=""))	
	
	
	capture.output(cat("\n \n \n Orthologs vs. paralogs, on mouse without testis: "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Mus", "ENCODE", "19testis", "21TPCtestis_paralogs", "") #Orthologs vs. paralogs, on mouse without testis 
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
		
	capture.output(cat("\n \n \n Orthologs on mouse: all vs. without testis: "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Mus", "ENCODE", "19F", "19testis", "testis") #Orthologs on mouse: all vs. without testis
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
		
	capture.output(cat("\n \n \n Paralogs on mouse: all vs. without testis: "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Mus", "ENCODE", "22PC_paralogs", "21TPCtestis_paralogs", "testis") #Paralogs on mouse: all vs. without testis
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
		
	capture.output(cat("\n \n ________________________________ \n \n"), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep=""))


	capture.output(cat("\n \n \n Orthologs vs. paralogs, autosomes: "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Hum", "Fagerberg", "18FAutosome", "27PCAutosome_paralogs", "") #Orthologs vs. paralogs, autosomes 
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
		
	capture.output(cat("\n \n \n Orthologs: all vs. autosomes: "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Hum", "Fagerberg", "19F", "18FAutosome", "autosome") #Orthologs: all vs. autosomes
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
		
	capture.output(cat("\n \n \n Paralogs: all vs autosomes: "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Hum", "Fagerberg", "27PC_paralogs", "27PCAutosome_paralogs", "autosome") #Paralogs: all vs autosomes 
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
		
	capture.output(cat("\n----------------------"), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep=""))	
	
	
	capture.output(cat("\n \n \n Orthologs vs. paralogs, autosomes: "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Hum", "Bodymap", "18FAutosome", "16hPCAutosome_paralogs", "") #Orthologs vs. paralogs, on Bodymap without testis
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
		
	capture.output(cat("\n \n \n Orthologs on Bodymap: all vs. autosomes: "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Hum", "Bodymap", "19F", "18FAutosome", "autosome") #Orthologs on Bodymap: all vs. without testis
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
		
	capture.output(cat("\n \n \n Paralogs on Bodymap: all vs. autosomes: "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Hum", "Bodymap", "16hPC_paralogs", "16hPCautosome_paralogs", "autosome") #Paralogs on Bodymap: all vs. without testis
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
		
	capture.output(cat("\n----------------------"), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep=""))


	capture.output(cat("\n \n \n Orthologs vs. paralogs, on mouse autosomes : "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Mus", "ENCODE", "18FAutosome", "22PCAutosome_paralogs", "") #Orthologs vs. paralogs, on mouse without testis 
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
		
	capture.output(cat("\n \n \n Orthologs on mouse: all vs. autosomes: "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Mus", "ENCODE", "19F", "18FAutosome", "autosome") #Orthologs on mouse: all vs. without testis
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])
		
	capture.output(cat("\n \n \n Paralogs on mouse: all vs. autosomes: "), append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
	a <- fAnova("Mus", "ENCODE", "22PC_paralogs", "22PCAutosome_paralogs", "autosome") #Paralogs on mouse: all vs. without testis
	capture.output(a, append=TRUE, file=paste(folder, "ANOVA_tests", ".txt", sep="")) 
		pValue_vector <- rbind(pValue_vector, a[5][1,1])

pValue_vector <- pValue_vector[-1,]
pValue_vector

length(pValue_vector)

q_test <- qvalue(c(pValue_vector,0.0137))
test <- data.frame(q = q_test$qvalues, p=q_test$pvalues)
plot(test$q, test$p)
test$s <- test$q<0.01
testF <- test[test$s==FALSE,]
testF[order(testF$q),]

testT <- test[test$s==TRUE,]
testT[order(testT$q),]


##############################
####Orthologs vs. Paralogs####

x1 <- read.table(paste(folder, "HumFagerbergTableOrthologs_18FrsameO",".txt", sep=""), header = TRUE, sep="\t")
x2 <- read.table(paste(folder, "HumFagerbergTableParalogs_27PC", ".txt", sep=""), header = TRUE, sep="\t")

xp <- x1[,1:2]
xp[,2] <- "Orthologs"
colnames(xp) <- c("Tau", "Homologs")
x2t <- x2[,c(2,1)]
x2t2 <- x2[,c(3,1)]
colnames(x2t2) <- colnames(x2t)
x2t <- rbind(x2t, x2t2)
x2t[,2] <- "Paralogs"
colnames(x2t) <- c("Tau", "Homologs")

xp <- rbind(xp, x2t)
summary(xp)

#ANOVA on Tau differance between Orthologs and Paralogs
m <- lm(xp$Tau ~ xp$Homologs)
summary(m)
anova(m)
###

	dev.new(height=8, width=8)
	trellis.par.set(list(background=list(col=my.col[1]), add.text=list(col=my.col[2], cex=1.5),axis.line=list(col=my.col[2]), axis.text=list(col=my.col[2], 		cex=1.2), 	par.main.text=list(col=my.col[2], cex=1.5, font=2), par.xlab.text=list(col=my.col[2], cex=1.2, font=2), par.ylab.text=list(col=my.col[2], cex=1.2, font=2), plot.line=list(col=my.col[2]), dot.line=list(lwd=1, lty=2, col="#4B4B4B"))) #trellis.par.get()
	

	bwplot(xp[,1]~xp[,2], ylab="Tau", main="Human Tau of Orthologs and Paralogs",horizontal=FALSE, 
	col = c("#C6C6C6EE"),##00BFFF
	fill=c("#FF0000FF","#0000FFEE"),
	panel = function(x,y,..., box.ratio, col, pch){
		panel.violin(x=x,y=y,...,  cut = 0, varwidth = TRUE, box.ratio = box.ratio, col=col)
		panel.bwplot(x=x,y=y, ..., varwidth = TRUE , notch=TRUE ,box.ratio = .1,  pch='|')
		},
		par.settings = list(box.rectangle=list(col=my.col[2], lwd=2), plot.symbol = list(pch='.', cex = 0.1, col=my.col[2]), box.umbrella=list(col=my.col[2])), scales=list(x=list(rot=30)))
		
	dev.copy2pdf(device=quartz, file=paste(folder, "Hum", "Fagerberg", "Tau", "OrthFrog_Par27", ".pdf", sep=""),onefile=TRUE)#,paper="A4r"
		dev.off()


##########################
####Orthologs Question####

temp1 <- read.csv("HumFagerbergTableOrthologs_18FrsameO.txt", header=TRUE, sep="\t")[,1]
temp2 <- read.csv("HumFagerbergTableOrthologs_18FrdiffOGeneIDs.txt", header=TRUE, sep="\t")[,2]

xp <- data.frame(Tau=c(temp1,temp2), Group=c(rep("conserved",length(temp1)), rep("others",length(temp2))))
summary(xp)
		
		#ANOVA on Tau differance between Orthologs and Paralogs
		m <- lm(xp$Tau ~ xp$Group)
		summary(m)
		anova(m)
		###

		dev.new(height=8, width=16)
			trellis.par.set(list(background=list(col=my.col[1]), add.text=list(col=my.col[2], cex=1.5),axis.line=list(col=my.col[2]), axis.text=list(col=my.col[2], 		cex=1.2), 	par.main.text=list(col=my.col[2], cex=1.5, font=2), par.xlab.text=list(col=my.col[2], cex=1.2, font=2), par.ylab.text=list(col=my.col[2], cex=1.2, font=2), plot.line=list(col=my.col[2]), dot.line=list(lwd=1, lty=2, col="#4B4B4B"))) #trellis.par.get()
		
	
		bwplot(xp[,1]~xp[,2], ylab="Tau", main="Human Tau of Orthologs",horizontal=FALSE, 
		col = c("#C6C6C6EE"),##00BFFF
		fill=c("#FF0000FF"), ##,"#0000FFEE"
		panel = function(x,y,..., box.ratio, col, pch){
			panel.violin(x=x,y=y,...,  cut = 0, varwidth = TRUE, box.ratio = box.ratio*10, col=col)
			panel.bwplot(x=x,y=y, ..., varwidth = TRUE , notch=TRUE ,box.ratio = box.ratio,  pch='|')
			},
			par.settings = list(box.rectangle=list(col=my.col[2], lwd=2), plot.symbol = list(pch='.', cex = 0.1, col=my.col[2]), box.umbrella=list(col=my.col[2])), scales=list(x=list(rot=30)))
			
		dev.copy2pdf(device=quartz, file=paste(folder, "Hum", "Fagerberg", "Tau", "OrthologsBoxPlot",  ".pdf", sep=""),onefile=TRUE)#,paper="A4r"
			#dev.off()
	
	
###########################################
####Examples for orthologs and paralogs####

#########
#orthologs

p <- "Tau"
organism <- c("Hum")
dataset <- c("Fagerberg")
add <- c("27PC")
textPos <- c(0.95,0.05)
extra <- "paper"


	x <- read.table(paste(folder, organism, dataset, "TScomparisonTable_9_", add,".txt", sep=""), header = TRUE, sep=" ")
	
	x <- x[,c("Ensembl.Gene.ID", p, "Max")]	
		
	paralogs <- read.table(paste(folder, organism, "ParalogsYoungestCouple", "", "EnsV75", ".txt", sep=""), header = TRUE, sep="\t")
	
	paralogs <- merge(paralogs, x, by=c("Ensembl.Gene.ID"), sort=FALSE)
	colnames(x) <- c("Paralog.Ensembl.Gene.ID", paste(p,".Paralog",sep=""), "Max.Paralog")
	paralogs <- merge(paralogs, x, by=c("Paralog.Ensembl.Gene.ID"), sort=FALSE)
	print(summary(paralogs))
	
	paralogs <- paralogs[,c("Ancestor", p, paste(p,".Paralog",sep=""), "Max", "Max.Paralog")]
	
	paralogs[,6] <- apply(paralogs[,2:5], 1,function(x){x <- ifelse(x[3]>x[4], x[1], x[2])})
	paralogs[,7] <- apply(paralogs[,2:5], 1,function(x){x <- ifelse(x[3]>x[4], x[2], x[1])})
	temp <- paralogs[,c(1,6,7)]
	
	colnames(temp) <- colnames(paralogs[,c(1,2,3)])
	paralogs <- temp
	
	paralogs <- paralogs[paralogs$Ancestor %in% c("Homo sapiens", "Eutheria", "Euteleostomi", "Bilateria"),]
	
	levels(paralogs$Ancestor) <- list("Homo sapiens"="Homo sapiens", "Eutheria"="Eutheria", "Bilateria"="Bilateria", "Euteleostomi"="Euteleostomi")

	xp <- data.frame(Organisms=NA, Value=NA, Parameter=NA, Genes=NA, Tissues=NA)
	for (n in levels(paralogs$Ancestor)) {
		x <- paralogs[regexpr(n,paralogs$Ancestor) > 0,]
		v <- cor(x[,p],x[,paste(p,".Paralog",sep="")], method="pearson")
		xp <- rbind(xp,data.frame(Organisms=n, Value=as.numeric(v), Parameter="Paralog", Genes=length(x$Ancestor), Tissues=gsub("[^0-9]*", "",add)))
	}
	
	xp <- xp[-1,]
	temp <- count(paralogs, "Ancestor")
	tempLevels <-  read.table(paste(folder, organism, "AncestorDifference", ".txt", sep=""), header = TRUE, sep="\t")
	colnames(tempLevels) <- c("Ancestor", "Age")
	tempLevels <- merge(tempLevels, temp, by="Ancestor")
	tempLevels <- tempLevels[order(tempLevels$Age),]

	paralogsLevels <- tempLevels[tempLevels$freq>1,1]

 	dev.new(height=4, width=16)
	par(mfrow=c(1,4), cex.main=2.5, cex.axis=1.2, cex.lab=1.4, bg=my.col[1], fg=my.col[2], col.axis=my.col[2], col.lab=my.col[2], col.main=my.col[2])
	
		for(n in paralogsLevels) {
		smoothScatter(paralogs[regexpr(n,paralogs$Ancestor) > 0, p], paralogs[regexpr(n,paralogs$Ancestor) > 0, paste(p,".Paralog",sep="")],  xlab=paste(p, " in ", "", n, sep=""), 			ylab=paste("Paralog ", p, " in ", "", n, sep=""), nrpoint=Inf, cex=1, nbin=100, xlim=c(0,1), ylim=c(0,1))
		
		c <- cor(paralogs[regexpr(n,paralogs$Ancestor) > 0, p], paralogs[regexpr(n,paralogs$Ancestor) > 0, paste(p,".Paralog",sep="")], method="pearson")
		c <- round(c, digits=2)
		text(x=textPos[1], y=(textPos[2]-0.05), pos=2, cex=1.2,labels=paste("   R = ", c,sep=""), col="red", font=2)
	}
	title(paste("Correlation between tissue-specificity in ", "human", " in ", "27", " tissues", sep=""), outer=TRUE, line=-2)
	
	dev.copy2pdf(device=quartz, file=paste(folder, organism, dataset, "TScomp_ScatPlot_paralog_", add, extra,"organism.pdf", sep=""),onefile=TRUE)#,paper="A4r"
		#dev.off()		

###################
################
#paralogs

 p <- "Tau"
 organisms <- c("Hum", "Chimp", "Mus", "Frog", "Fly")
 datasets <- c("Fagerberg", "Brawand", "ENCODE", "Necsulea", "ENCODE")
 add <-	c("27PC", "6cmPC", "22PC", "6fPC", "6flPC")
 textPos <-	c(0.95,0.05)
 orth <- c("HumOrthologsChimpEnsV75", "HumOrthologsMusEnsV75", "HumOrthologsFrogEnsV75", "HumOrthologsFlyEnsV75")
 extra <- "paper"

	x <- read.table(paste(folder, organisms[1], datasets[1], "TScomparisonTable_9_", add[1],".txt", sep=""), header = TRUE, sep=" ")
	
	x <- x[,c("Ensembl.Gene.ID", p)]	
	colnames(x) <- c("Ensembl.Gene.ID", paste(add[1], p, sep="."))
	xp <- data.frame(Organisms=NA, Value=NA, Parameter=NA, Genes=NA, Tissues=NA)

	dev.new(height=4, width=16)
	par(mfrow=c(1, 4), cex.main=2.5, cex.axis=1.2, cex.lab=1.4, bg=my.col[1], fg=my.col[2], col.axis=my.col[2], col.lab=my.col[2], col.main=my.col[2])
	
	ytext <- c("6 chimpanzee", "22 mouse", "6 frog", "6 fly")

	for (n in 2:length(organisms)){
		x2 <- read.table(paste(folder, organisms[n], datasets[n], "TScomparisonTable_9_",  add[n], ".txt", sep=""), header = TRUE, sep=" ")

		x2 <- x2[,c("Ensembl.Gene.ID", p)]	
		colnames(x2) <- c(paste(organisms[n], ".Ensembl.Gene.ID", sep=""), paste(add[n], p, sep="."))
	
		orthologs <- read.table(paste(folder, orth[n-1], ".txt", sep=""), header = TRUE, sep=",")
		orthologs <- orthologs[regexpr("one2one", orthologs$Homology.Type)>0, ]
		orthologs <- orthologs[,c(1,2)]
		x3 <- merge(orthologs, x, by=c("Ensembl.Gene.ID"))
		x3 <- merge(x3, x2, by=c(paste(organisms[n],".Ensembl.Gene.ID", sep="")))	
		x3 <- x3[,regexpr(p,colnames(x3))>0]		
		
		v <- cor(x3[,1],x3[,2], method="pearson")
		xp <- rbind(xp,data.frame(Organisms=organisms[n], Value=as.numeric(v), Parameter="Ortholog", Genes=length(x3[,1]), Tissues=gsub("[^0-9]*", "",add[n])))
		
			smoothScatter(x3[,1], x3[,2],  xlab=paste(p, " in 27 human tissues",sep=""), ylab=paste( p, " in ", ytext[n-1], " tissues",sep=""), nrpoint=Inf, cex=1, nbin=100, xlim=c(0,1), ylim=c(0,1))
			c <- cor(x3[,1], x3[,2], method="pearson")
			c <- round(c, digits=2)
			text(x=textPos[1], y=(textPos[2]+0.05), pos=2, cex=1.2,labels=paste("   R = ", c,sep=""), col="red", font=2)
	}
	xp <- xp[-1,]

			title(paste("Correlation between tissue-specificity in ", length(organisms)-1, " organisms", sep=""), outer=TRUE, line=-2)
			dev.copy2pdf(device=quartz, file=paste(folder, organisms[1], datasets[1], "TScomp_ScatPlot_9_", length(organisms),"organisms", extra,".pdf", sep=""),onefile=TRUE)
			#dev.off()


##########################
####Orthologs question####
organisms <- c("Hum", "Chimp", "Macaca", "Opossum", "Platypus", "Frog", "Fly")
datasets <- c("Fagerberg", "Brawand", "Merkin", "Brawand", "Brawand", "Necsulea", "ENCODE")
adds <- c("27PC", "6cmPC", "9mcMPC", "6oPC", "6pPC", "6fPC", "6flPC")
age <- list("Homo sapiens",  c("Homininae", "Hominidae", "Hominoidea", "Catarrhini"), c("Primates", "Haplorrhini", "Simiformes", "Euarchontoglires", "Eutheria"), c("Theria", "Mammalia"), "Amniota", c("Chordata"))
extra <- "paper"

	x <- read.table(paste(folder, organisms[1], datasets[1], "TScomparisonTable_9_", adds[1],".txt", sep=""), header = TRUE, sep=" ")
	x <- x[,c("Ensembl.Gene.ID", "Tau", "Max")]	

	paralogs <- read.table(paste(folder, organisms[1], "ParalogsYoungestCouple", "", "EnsV75", ".txt", sep=""), header = TRUE, sep="\t")
			
	paralogs <- merge(paralogs, x, by=c("Ensembl.Gene.ID"), sort=FALSE)
	colnames(x) <- c("Paralog.Ensembl.Gene.ID", paste(p,".Paralog",sep=""), "Max.Paralog")
	paralogs <- merge(paralogs, x, by=c("Paralog.Ensembl.Gene.ID"), sort=FALSE)
	print(summary(paralogs))
	
	paralogs[,8] <- apply(paralogs[,1:7], 1,function(x){x <- ifelse(as.numeric(x[5])>as.numeric(x[7]), x[2], x[1])})
	paralogs[,9] <- apply(paralogs[,1:7], 1,function(x){x <- ifelse(as.numeric(x[5])>as.numeric(x[7]), x[1], x[2])})
	paralogs[,10] <- apply(paralogs[,1:7], 1,function(x){x <- ifelse(as.numeric(x[5])>as.numeric(x[7]), as.numeric(x[4]), as.numeric(x[6]))})
	paralogs[,11] <- apply(paralogs[,1:7], 1,function(x){x <- ifelse(as.numeric(x[5])>as.numeric(x[7]), as.numeric(x[6]), as.numeric(x[4]))})
	temp <- paralogs[,c(8, 9, 3, 10,11)]
	colnames(temp) <- c( "Ensembl.Gene.ID", "Paralog.Ensembl.Gene.ID", "Ancestor", "Tau", "Tau.Paralog" )
	
	paralogs <- temp
		
	dev.new(height=12, width=16)
	trellis.par.set(list(background=list(col=my.col[1]), add.text=list(col=my.col[2], cex=1.5),axis.line=list(col=my.col[2]), axis.text=list(col=my.col[2], 		cex=1.2), 	par.main.text=list(col=my.col[2], cex=1.5, font=2), par.xlab.text=list(col=my.col[2], cex=1.2, font=2), par.ylab.text=list(col=my.col[2], cex=1.2, font=2), plot.line=list(col=my.col[2]), dot.line=list(lwd=1, lty=2, col="#4B4B4B"))) #trellis.par.get()

	t <- paralogs
	
	xp <- data.frame(Organisms=NA, Value=NA, Genes=NA, Tau=NA,Parameter=NA)
	j <- 1
	k <- 1
	for(i in c(2:length(organisms))){
		orthologs <- read.table(paste(folder,  organisms[1],"Orthologs", organisms[i], "EnsV75", ".txt", sep=""), header = TRUE, sep=",")
		orthologs <- orthologs[regexpr("one2many", orthologs$Homology.Type)>0,]
		orthologs <- unique(orthologs)
		summary(orthologs)
		colnames(orthologs) <- c("Ensembl.Gene.ID", "Orth.Ensembl.Gene.ID", "Homology.Type")
	
		idHum <- orthologs$Ensembl.Gene.ID
		
		temp <- paralogs[paralogs$Ensembl.Gene.ID %in% idHum,]
		temp <- merge(temp, orthologs, by="Ensembl.Gene.ID")
		x2 <- read.table(paste(folder, organisms[i], datasets[i], "TScomparisonTable_9_", adds[i],".txt", sep=""), header = TRUE, sep=" ")
		x2 <- x2[,c("Ensembl.Gene.ID", "Tau")]	
		colnames(x2) <- c("Orth.Ensembl.Gene.ID", "Tau.Orth")
		temp <- merge(temp, x2, by="Orth.Ensembl.Gene.ID")
			temp2 <- as.data.frame(table(temp$Ensembl.Gene.ID))
			temp2 <- temp2[temp2$Freq==1,]
			temp <- temp[temp$Ensembl.Gene.ID %in% temp2$Var1, ]
		paralogs <- temp[,c("Tau.Orth", "Tau", "Tau.Paralog", "Ancestor")]
		
		summary(paralogs, 20)
		
		paralogs <- paralogs[paralogs$Ancestor %in% age[[i-1]], ]
		print(summary(paralogs))
		
		v <- cor(paralogs[,1], paralogs[,2], method="pearson")
		xp <- rbind(xp,data.frame(Organisms=organisms[i], Value=as.numeric(v), Genes=length(paralogs[,1]),  Tau=mean(paralogs[,2]), Parameter="Parent"))
		v <- cor(paralogs[,1], paralogs[,3], method="pearson")
		xp <- rbind(xp,data.frame(Organisms=organisms[i], Value=as.numeric(v), Genes=length(paralogs[,1]), Tau=mean(paralogs[,3]), Parameter="Child"))
			
		temp <- paralogs[,c(1,2)]
		temp[,3] <- "Parent"
		temp2 <- paralogs[,c(1,3)]
		temp2[,3] <- "Child"
		colnames(temp2) <- c("Tau.Orth", "Tau", "V3")
		x <- rbind(temp, temp2)
	
		paralogs <- t
	
		c <- cor(x[x$V3=="Parent", 1], x[x$V3=="Parent", 2], method="pearson")
		cP <- round(c, digits=2)
		c <- cor(x[x$V3=="Child", 1], x[x$V3=="Child", 2], method="pearson")
		cC <- round(c, digits=2)

	tempX2 <- x2
	tempX <- x
	
	tempX2$group <- "All"
	tempX$group <- "Duplicated"
	tempX2 <- tempX2[,c("Tau.Orth", "group")]
	tempX <- tempX[,c("Tau.Orth", "group")]
	x3 <- rbind(tempX, tempX2)
	
	b <- bwplot(x3[,1]~x3[,2], ylab="Tau", main=paste(organisms[i], ": ", length(x3[x3$group=="All",1]), " vs. ", length(x3[x3$group=="Duplicated",1]),sep=""),horizontal=FALSE, 
	col = c("#C6C6C6EE"),##00BFFF
	fill=c("#FF0000FF","#0000FFEE"),
	panel = function(x,y,..., box.ratio, col, pch){
		panel.violin(x=x,y=y,...,  cut = 0, varwidth = FALSE, box.ratio = box.ratio, col=col)
		panel.bwplot(x=x,y=y, ..., varwidth = FALSE , notch=TRUE ,box.ratio = .1,  pch='|')
		},
		par.settings = list(box.rectangle=list(col=my.col[2], lwd=2), plot.symbol = list(pch='.', cex = 0.1, col=my.col[2]), box.umbrella=list(col=my.col[2])), scales=list(x=list(rot=30)))
		

	m <- lm(x3$Tau.Orth ~ x3$group)
	print(anova(m))
	###
 		print(b, split=c(j,k,3,2), more=TRUE)
		if(j < 3){
			j <- j+1
		} else {
			j <- 1
			k <- k+1
		}					
	}
	print(NA, split=c(3,2,3,2), more=FALSE)	
		
	dev.copy2pdf(device=quartz, file=paste(folder, organisms[1], "", "Tau", "Orthologs", extra,"Outgroup.pdf", sep=""),onefile=TRUE)#,paper="A4r"
	dev.off()	


#####################################
#####################################
#####################################