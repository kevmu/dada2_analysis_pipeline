#=======================================
#Get Things imported and set up
#=======================================  

#Set working directory to Topp-soil-ITS folder
setwd("~/R/Topp-soil-ITS/")
#Get Pakages that are needed
library(ggplot2)
library(reshape)
library(vegan)
library(grid)
library(gridExtra)
library(scales)
library(phyloseq)
library(multcomp)
library(reshape2)
library(dplyr)
library(Hmisc)
library(devtools)
library(tidyr)
library(ggrepel)
library(tidyverse)
library(ggpubr)
library(rstatix)
library(emmeans)
library(tidyr)

BiocManager::install("phyloseq")
######################################################
#Phyloseq
######################################################

#Custom functions

get_legend<-function(myggplot){
  tmp <- ggplot_gtable(ggplot_build(myggplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)
}

veganotu <- function(physeq) {
  require("vegan")
  OTU <- otu_table(physeq)
  if (taxa_are_rows(OTU)) {
    OTU <- t(OTU)
  }
  return(as(OTU, "matrix"))
}

ITS_biom <- import_biom(BIOMfilename = "~/R/Topp-soil-ITS/Data/ITS_phyloseq.biom")
sample_names(ITS_biom)<- gsub("-","_",sample_names(ITS_biom))
sample_names(ITS_biom)<- paste("Topp",sample_names(ITS_biom),sep = "")

sample_variables(ITS_biom)
sample_names(ITS_biom)
sample_sums(ITS_biom)
sample_data(ITS_biom)

#SSU_biom <- import_biom(BIOMfilename = "~/R/Topp_antifungal/Data/16S_phyloseq.biom")
#sample_names(SSU_biom)

#CS_biom<- import_biom(BIOMfilename = "~/R/Topp_antifungal/Data/CS_phyloseq.biom")
#sample_names(CS_biom)
#sample_names(CS_biom)<- gsub("-","_",sample_names(CS_biom))
#sample_names(CS_biom)<- paste("Topp",sample_names(CS_biom),sep = "")

colnames(tax_table(ITS_biom))<- c("Kingdom","Phylum","Class","Order","Family","Genus","Species")
#colnames(tax_table(SSU_biom))<- c("Kingdom","Phylum","Class","Order","Family","Genus","Species")
#colnames(tax_table(CS_biom))<- c("Kingdom","Phylum","Class","Order","Family","Genus","Species")

#sample_data(SSU_biom)$Day <- factor(sample_data(SSU_biom)$Day, 
                                    levels = c("0" = "0","7" = "7","30" = "30"))
#sample_data(SSU_biom)$Plot <- factor(sample_data(SSU_biom)$Plot, 
                                    levels = c("1" = "1","4" = "4","82" = "82","6" = "6","22" = "22","50" = "50",
                                               "66" = "66","73" = "73","75" = "75"))
#sample_data(SSU_biom)$Treatment <- factor(sample_data(SSU_biom)$Treatment, 
                                          levels = c("0" = "0","0.1" = "0.1","10" = "10", "NTC" = "NTC"))

sample_data(ITS_biom)$Day <- factor(sample_data(ITS_biom)$Day, 
                                    levels = c("D0" = "D0","D7" = "D7","D30" = "D30"))
sample_data(ITS_biom)$Plot <- factor(sample_data(ITS_biom)$Plot, 
                                     levels = c("1" = "1","4" = "4","82" = "82","6" = "6","22" = "22","50" = "50",
                                                "66" = "66","73" = "73","75" = "75"))
sample_data(ITS_biom)$Treatment <- factor(sample_data(ITS_biom)$Treatment, 
                                          levels = c("0" = "0","0.1" = "0.1","10" = "10", "NTC" = "NTC"))

#sample_data(CS_biom)$Day <- factor(sample_data(CS_biom)$Day, 
                                        levels = c("0" = "0","7" = "7","30" = "30"))
#sample_data(CS_biom)$Plot <- factor(sample_data(CS_biom)$Plot, 
                                         levels = c("1" = "1","4" = "4","82" = "82","6" = "6","22" = "22","50" = "50",
                                                    "66" = "66","73" = "73","75" = "75"))
#sample_data(CS_biom)$Treatment <- factor(sample_data(CS_biom)$Treatment, 
                                              levels = c("0" = "0","0.1" = "0.1","10" = "10", "NTC" = "NTC"))


#sample_sums(SSU_biom)
#SSU_biom_rr<- rarefy_even_depth(SSU_biom, sample.size = 10000,replace = FALSE, trimOTUs = TRUE, rngseed = 711)

sample_sums(ITS_biom)
ITS_biom_rr<- rarefy_even_depth(ITS_biom, sample.size = 18485,replace = FALSE, trimOTUs = TRUE, rngseed = 711)

#CS_biom_rr<- subset_taxa(CS_biom, Kingdom != "Unassigned")
#sample_sums(CS_biom_rr)
#CS_biom_rr<- rarefy_even_depth(CS_biom_rr, sample.size = 10000,replace = FALSE, trimOTUs = TRUE, rngseed = 711)




################
#CaptureSeq individual Domains

CS_kingdom<- as.data.frame(t(as(otu_table(tax_glom(CS_biom_rr, "Kingdom")), "matrix")))
colnames(CS_kingdom)<-as.data.frame(as(tax_table(tax_glom(CS_biom_rr, "Kingdom")), "matrix"))$Kingdom
CS_kingdom <- CS_kingdom/rowSums(CS_kingdom)
CS_kingdom <- merge(CS_kingdom, sample_data(CS_biom_rr)[,c("Plot","Day","Treatment")], by = 0, all = TRUE)
colnames(CS_kingdom)[1]<- "SampleID"
CS_kingdom<- melt(CS_kingdom, id = c("SampleID","Plot","Day","Treatment"))
CS_kingdom$Plot<- as.factor(CS_kingdom$Plot)
CS_kingdom$Day<- as.factor(CS_kingdom$Day)
CS_kingdom$Treatment<- as.factor(CS_kingdom$Treatment)
CS_kingdom_agg<- aggregate(value~Day+Treatment+variable,CS_kingdom, mean)
CS_kingdom_agg_sd<- aggregate(value~Day+Treatment+variable,CS_kingdom, sd)
CS_kingdom_agg$sd<- CS_kingdom_agg_sd$value
CS_kingdom_agg$value[CS_kingdom_agg$value == 0] <- NA

ppi<-600
png("~/R/Topp_antifungal/Figures/Kingdom.png", height=5*ppi, width=5*ppi, res=ppi)


ggplot()+
  geom_bar(data = CS_kingdom_agg, aes(x=Day, y = value, fill = Treatment), stat = "identity", position = "dodge")+
  geom_errorbar(data = CS_kingdom_agg, aes(x=Day, ymin = value-sd, ymax = value+sd, group = Treatment), stat = "identity", position = "dodge")+
  ylab("Mean Relative abundance")+
  facet_grid(variable~., scales = "free_y")+
  theme_bw()+
  theme(strip.text = element_text(size = 10),
        axis.text = element_text(size = 10),
        legend.position = "top",
        legend.direction = "horizontal",
        axis.title = element_text(size = 10), 
        legend.title = element_text(size = 12),
        strip.background = element_blank())

dev.off()





















