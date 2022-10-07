######################
#Alpha diversity
######################

SSU_alpha<- estimate_richness(SSU_biom_rr, measures = c("Observed", "Shannon", "InvSimpson"))
SSU_alpha<- merge(sample_data(SSU_biom_rr)[,c("Day", "Plot", "Treatment")], SSU_alpha, by = 0, all = TRUE)
colnames(SSU_alpha)[1]<- "SampleID"
SSU_alpha$Target<- rep("SSU", nrow(SSU_alpha))

ITS_alpha<- estimate_richness(ITS_biom_rr, measures = c("Observed", "Shannon", "InvSimpson"))
rownames(ITS_alpha)<- rownames(sample_data(ITS_biom_rr))
ITS_alpha<- merge(sample_data(ITS_biom_rr)[,c("Day", "Plot", "Treatment")], ITS_alpha, by = 0, all = TRUE)
colnames(ITS_alpha)[1]<- "SampleID"
ITS_alpha$Target<- rep("ITS", nrow(ITS_alpha))

CS_alpha<- estimate_richness(CS_biom_rr, measures = c("Observed", "Shannon", "InvSimpson"))
rownames(CS_alpha)<- rownames(sample_data(CS_biom_rr))
CS_alpha<- merge(sample_data(CS_biom_rr)[,c("Day", "Plot", "Treatment")], CS_alpha, by = 0, all = TRUE)
colnames(CS_alpha)[1]<- "SampleID"
CS_alpha$Target<- rep("CS", nrow(CS_alpha))

alpha_all<-rbind(SSU_alpha, ITS_alpha, CS_alpha)
alpha_all_melt<- melt(alpha_all, id = c("Target", "Plot", "Day", "Treatment", "SampleID"))

alpha_plot<- ggplot()+
  ggtitle("16S")+
  geom_boxplot(data = subset(alpha_all_melt, Target =="SSU"), aes(x = Day, y = value, color = Treatment), stat = "boxplot", position = "dodge",outlier.stroke = FALSE)+
  facet_grid(variable~Treatment, scales = "free_y")+
  theme(axis.text.x = element_text(size = 10),
        strip.text = element_text(size = 10),
        axis.text.y = element_text(size = 10),
        legend.position = "top",
        legend.direction = "horizontal",
        axis.title.x = element_text(size = 10),
        axis.title.y = element_text(size = 10), 
        legend.title = element_text(size = 12))

alpha_plot2<- ggplot()+
  ggtitle("ITS")+
  geom_boxplot(data = subset(alpha_all_melt, Target == "ITS"), aes(x = Day, y = value, color = Treatment), stat = "boxplot", position = "dodge",outlier.stroke = FALSE)+
  facet_grid(variable~Treatment, scales = "free_y")+
  theme(axis.text.x = element_text(size = 10),
        strip.text = element_text(size = 10),
        axis.text.y = element_text(size = 10),
        legend.position = "top",
        legend.direction = "horizontal",
        axis.title.x = element_text(size = 10),
        axis.title.y = element_text(size = 10), 
        legend.title = element_text(size = 12))

alpha_plot3<- ggplot()+
  ggtitle("CaptureSeq")+
  geom_boxplot(data = subset(alpha_all_melt, Target == "CS"), aes(x = Day, y = value, color = Treatment), stat = "boxplot", position = "dodge",outlier.stroke = FALSE)+
  facet_grid(variable~Treatment, scales = "free_y")+
  theme(axis.text.x = element_text(size = 10),
        strip.text = element_text(size = 10),
        axis.text.y = element_text(size = 10),
        legend.position = "top",
        legend.direction = "horizontal",
        axis.title.x = element_text(size = 10),
        axis.title.y = element_text(size = 10), 
        legend.title = element_text(size = 12))

alpha_legend <- get_legend(alpha_plot)
alpha_plot <- alpha_plot + theme(legend.position="none")
alpha_plot2 <- alpha_plot2 + theme(legend.position="none")
alpha_plot3 <- alpha_plot3 + theme(legend.position="none")

ppi<-600
png("~/R/Topp_antifungal/Figures/All_alpha_diversity.png", height=8*ppi, width=12*ppi, res=ppi)

grid.arrange(alpha_legend, arrangeGrob(alpha_plot, alpha_plot2, alpha_plot3, ncol = 3), nrow = 2, heights = c(0.2, 1), top = "Rarefied to 10,000 reads")

dev.off()

alpha_plot4<- ggplot()+
  ggtitle("16S")+
  geom_boxplot(data = subset(alpha_all_melt, Target == "SSU"), aes(x = 1, y = value, color = Treatment), stat = "boxplot", position = "dodge",outlier.stroke = FALSE)+
  facet_grid(variable~., scales = "free_y")+
  theme(axis.text.x = element_blank(),
        strip.text = element_text(size = 10),
        axis.text.y = element_text(size = 10),
        legend.position = "top",
        legend.direction = "horizontal",
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 10), 
        legend.title = element_text(size = 12),
        axis.ticks.x = element_blank())

alpha_plot5<- ggplot()+
  ggtitle("ITS")+
  geom_boxplot(data = subset(alpha_all_melt, Target == "ITS"), aes(x = 1, y = value, color = Treatment), stat = "boxplot", position = "dodge",outlier.stroke = FALSE)+
  facet_grid(variable~., scales = "free_y")+
  theme(axis.text.x = element_blank(),
        strip.text = element_text(size = 10),
        axis.text.y = element_text(size = 10),
        legend.position = "top",
        legend.direction = "horizontal",
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 10), 
        legend.title = element_text(size = 12),
        axis.ticks.x = element_blank())

alpha_plot6<- ggplot()+
  ggtitle("Captureseq")+
  geom_boxplot(data = subset(alpha_all_melt, Target == "CS"), aes(x = 1, y = value, color = Treatment), stat = "boxplot", position = "dodge",outlier.stroke = FALSE)+
  facet_grid(variable~., scales = "free_y")+
  theme(axis.text.x = element_blank(),
        strip.text = element_text(size = 10),
        axis.text.y = element_text(size = 10),
        legend.position = "top",
        legend.direction = "horizontal",
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 10), 
        legend.title = element_text(size = 12),
        axis.ticks.x = element_blank())



alpha_legend2 <- get_legend(alpha_plot4)
alpha_plot4 <- alpha_plot4 + theme(legend.position="none")
alpha_plot5 <- alpha_plot5 + theme(legend.position="none")
alpha_plot6 <- alpha_plot6 + theme(legend.position="none")

ppi<-600
png("~/R/Topp_antifungal/Figures/merged_alpha_diversity.png", height=6*ppi, width=6*ppi, res=ppi)

grid.arrange(alpha_legend2, arrangeGrob(alpha_plot4, alpha_plot5, alpha_plot6, ncol = 3), nrow = 2, heights = c(0.2, 1), top = "Rarefied to 10,000 reads")

dev.off()

#Kruskal Wallis

SSU_richness<- estimate_richness(SSU_biom_rr, measures = c("Observed", "InvSimpson", "Shannon"))
SSU_richness<- merge(SSU_richness, sample_data(SSU_biom_rr), by = 0, all = TRUE)
SSU_richness$Trt_Day<- paste(SSU_richness$Treatment, SSU_richness$Day, sep = "_")

ITS_richness<- estimate_richness(ITS_biom_rr, measures = c("Observed", "InvSimpson", "Shannon"))
ITS_richness<- merge(ITS_richness, sample_data(ITS_biom_rr), by = 0, all = TRUE)
ITS_richness$Trt_Day<- paste(ITS_richness$Treatment, ITS_richness$Day, sep = "_")

CS_richness<- estimate_richness(CS_biom_rr, measures = c("Observed", "InvSimpson", "Shannon"))
CS_richness<- merge(CS_richness, sample_data(CS_biom_rr), by = 0, all = TRUE)
CS_richness$Trt_Day<- paste(CS_richness$Treatment, CS_richness$Day, sep = "_")

SSU_shannon<- pairwise.wilcox.test(SSU_richness$Shannon, SSU_richness$Treatment, p.adjust.method = "BH")
SSU_obs<- pairwise.wilcox.test(SSU_richness$Observed, SSU_richness$Treatment, p.adjust.method = "BH")
SSU_invsimp<- pairwise.wilcox.test(SSU_richness$InvSimpson, SSU_richness$Treatment, p.adjust.method = "BH")

ITS_shannon<- pairwise.wilcox.test(ITS_richness$Shannon, ITS_richness$Treatment, p.adjust.method = "BH")
ITS_obs<- pairwise.wilcox.test(ITS_richness$Observed, ITS_richness$Treatment, p.adjust.method = "BH")
ITS_invsimp<- pairwise.wilcox.test(ITS_richness$InvSimpson, ITS_richness$Treatment, p.adjust.method = "BH")

CS_shannon<- pairwise.wilcox.test(CS_richness$Shannon, CS_richness$Treatment, p.adjust.method = "BH")
CS_obs<- pairwise.wilcox.test(CS_richness$Observed, CS_richness$Treatment, p.adjust.method = "BH")
CS_invsimp<- pairwise.wilcox.test(CS_richness$InvSimpson, CS_richness$Treatment, p.adjust.method = "BH")



#############
#Make a spreadsheet with alpha diversity metrics

alpha_diversity<- estimate_richness(biom_rr, split = TRUE, measures = c("Observed", "Shannon", "InvSimpson"))
alpha_diversity<- merge(as(sample_data(biom_rr), "matrix"), alpha_diversity, by = 0, all = TRUE)
alpha_diversity<-subset(alpha_diversity, select = -c(InputFileName, Date, Sample_Number))
colnames(alpha_diversity)[1:2]<- c("SampleID","Sampling")
write.table(alpha_diversity, file = "~/R/Helgason/StDenis_all/Figures/alpha_diversity.txt", quote = FALSE, sep = "\t", row.names = FALSE)


