######
#Beta diversity

SSU_ordUF = ordinate(SSU_biom_rr, method = "PCoA", distance = "bray")

a<- plot_ordination(SSU_biom_rr, SSU_ordUF, color = "Treatment") + 
  geom_point(mapping = aes(shape = Day), size = 3) +
  scale_shape_discrete(name="Day")+
  ggtitle("16S - PCoA: Bray")+
  theme(legend.position = "top",
        legend.direction="horizontal")

SSU_ordUF_j = ordinate(SSU_biom_rr, method = "PCoA", distance = "jaccard", binary = TRUE)

b<- plot_ordination(SSU_biom_rr, SSU_ordUF_j, color = "Treatment") + 
  geom_point(mapping = aes(shape = Day), size = 3) +
  scale_shape_discrete(name="Day")+
  ggtitle("16S - PCoA: Jaccard")+
  theme(legend.position = "top",
        legend.direction="horizontal")

ITS_ordUF = ordinate(ITS_biom_rr, method = "PCoA", distance = "bray")

c<- plot_ordination(ITS_biom_rr, ITS_ordUF, color = "Treatment") + 
  geom_point(mapping = aes(shape = Day), size = 3) +
  scale_shape_discrete(name="Day")+
  ggtitle("ITS - PCoA: Bray")+
  theme(legend.position = "top",
        legend.direction="horizontal")

ITS_ordUF_j = ordinate(ITS_biom_rr, method = "PCoA", distance = "jaccard", binary = TRUE)

d<- plot_ordination(ITS_biom_rr, ITS_ordUF_j, color = "Treatment") + 
  geom_point(mapping = aes(shape = Day), size = 3) +
  scale_shape_discrete(name="Day")+
  ggtitle("ITS - PCoA: Jaccard")+
  theme(legend.position = "top",
        legend.direction="horizontal")

CS_ordUF = ordinate(CS_biom_rr, method = "PCoA", distance = "bray")

e<- plot_ordination(CS_biom_rr, CS_ordUF, color = "Treatment") + 
  geom_point(mapping = aes(shape = Day), size = 3) +
  scale_shape_discrete(name="Day")+
  ggtitle("CaptureSeq - PCoA: Bray")+
  theme(legend.position = "top",
        legend.direction="horizontal")

CS_ordUF_j = ordinate(CS_biom_rr, method = "PCoA", distance = "jaccard", binary = TRUE)

f<- plot_ordination(CS_biom_rr, CS_ordUF_j, color = "Treatment") + 
  geom_point(mapping = aes(shape = Day), size = 3) +
  scale_shape_discrete(name="Day")+
  ggtitle("CaptureSeq - PCoA: Jaccard")+
  theme(legend.position = "top",
        legend.direction="horizontal")


a_legend <- get_legend(a)
a <- a + theme(legend.position="none")
b <- b + theme(legend.position="none")
c <- c + theme(legend.position="none")
d <- d + theme(legend.position="none")
e <- e + theme(legend.position="none")
f <- f + theme(legend.position="none")


ppi<-600
png("~/R/Topp_antifungal/Figures/pcoa_beta_diversity.png", height=10*ppi, width=10*ppi, res=ppi)

grid.arrange(a_legend, arrangeGrob(e,f, ncol = 2),arrangeGrob(a,b, ncol = 2), arrangeGrob(c,d, ncol = 2), nrow = 4,heights = c(0.2,1,1, 1))

dev.off()

#######
#Permanova

#Permanova

SSU_d0_bray <- phyloseq::distance(subset_samples(SSU_biom_rr, Day == "0"), method = "bray")
SSU_d0_bray_df <- data.frame(sample_data(subset_samples(SSU_biom_rr, Day == "0")))
adonis(SSU_d0_bray ~ Treatment, data = SSU_d0_bray_df)

SSU_d7_bray <- phyloseq::distance(subset_samples(SSU_biom_rr, Day == "7"), method = "bray")
SSU_d7_bray_df <- data.frame(sample_data(subset_samples(SSU_biom_rr, Day == "7")))
adonis(SSU_d7_bray ~ Treatment, data = SSU_d7_bray_df)

SSU_d30_bray <- phyloseq::distance(subset_samples(SSU_biom_rr, Day == "30"), method = "bray")
SSU_d30_bray_df <- data.frame(sample_data(subset_samples(SSU_biom_rr, Day == "30")))
adonis(SSU_d30_bray ~ Treatment, data = SSU_d30_bray_df)

SSU_t0_bray <- phyloseq::distance(subset_samples(SSU_biom_rr, Treatment == "0"), method = "bray")
SSU_t0_bray_df <- data.frame(sample_data(subset_samples(SSU_biom_rr, Treatment == "0")))
adonis(SSU_t0_bray ~ Day, data = SSU_t0_bray_df)

SSU_t0.1_bray <- phyloseq::distance(subset_samples(SSU_biom_rr, Treatment == "0.1"), method = "bray")
SSU_t0.1_bray_df <- data.frame(sample_data(subset_samples(SSU_biom_rr, Treatment == "0.1")))
adonis(SSU_t0.1_bray ~ Day, data = SSU_t0.1_bray_df)

SSU_t10_bray <- phyloseq::distance(subset_samples(SSU_biom_rr, Treatment == "10"), method = "bray")
SSU_t10_bray_df <- data.frame(sample_data(subset_samples(SSU_biom_rr, Treatment == "10")))
adonis(SSU_t10_bray ~ Day, data = SSU_t10_bray_df)

SSU_bray <- phyloseq::distance(SSU_biom_rr, method = "bray")
SSU_bray_df <- data.frame(sample_data(SSU_biom_rr))
adonis(SSU_bray ~ Day*Treatment, data = SSU_bray_df)

SSU_bray_adonis<- capture.output(adonis(SSU_d0_bray ~ Treatment, data = SSU_d0_bray_df),
                                 adonis(SSU_d7_bray ~ Treatment, data = SSU_d7_bray_df),
                                 adonis(SSU_d30_bray ~ Treatment, data = SSU_d30_bray_df),
                                 adonis(SSU_t0_bray ~ Day, data = SSU_t0_bray_df),
                                 adonis(SSU_t0.1_bray ~ Day, data = SSU_t0.1_bray_df),
                                 adonis(SSU_t10_bray ~ Day, data = SSU_t10_bray_df),
                                 file = "~/R/Grape/Figures/SSU_bray_adonis.txt")

ITS_d0_bray <- phyloseq::distance(subset_samples(ITS_biom_rr, Day == "0"), method = "bray")
ITS_d0_bray_df <- data.frame(sample_data(subset_samples(ITS_biom_rr, Day == "0")))
adonis(ITS_d0_bray ~ Treatment, data = ITS_d0_bray_df)

ITS_d7_bray <- phyloseq::distance(subset_samples(ITS_biom_rr, Day == "7"), method = "bray")
ITS_d7_bray_df <- data.frame(sample_data(subset_samples(ITS_biom_rr, Day == "7")))
adonis(ITS_d7_bray ~ Treatment, data = ITS_d7_bray_df)

ITS_d30_bray <- phyloseq::distance(subset_samples(ITS_biom_rr, Day == "30"), method = "bray")
ITS_d30_bray_df <- data.frame(sample_data(subset_samples(ITS_biom_rr, Day == "30")))
adonis(ITS_d30_bray ~ Treatment, data = ITS_d30_bray_df)

ITS_t0_bray <- phyloseq::distance(subset_samples(ITS_biom_rr, Treatment == "0"), method = "bray")
ITS_t0_bray_df <- data.frame(sample_data(subset_samples(ITS_biom_rr, Treatment == "0")))
adonis(ITS_t0_bray ~ Day, data = ITS_t0_bray_df)

ITS_t0.1_bray <- phyloseq::distance(subset_samples(ITS_biom_rr, Treatment == "0.1"), method = "bray")
ITS_t0.1_bray_df <- data.frame(sample_data(subset_samples(ITS_biom_rr, Treatment == "0.1")))
adonis(ITS_t0.1_bray ~ Day, data = ITS_t0.1_bray_df)

ITS_t10_bray <- phyloseq::distance(subset_samples(ITS_biom_rr, Treatment == "10"), method = "bray")
ITS_t10_bray_df <- data.frame(sample_data(subset_samples(ITS_biom_rr, Treatment == "10")))
adonis(ITS_t10_bray ~ Day, data = ITS_t10_bray_df)

ITS_bray <- phyloseq::distance(ITS_biom_rr, method = "bray")
ITS_bray_df <- data.frame(sample_data(ITS_biom_rr))
adonis(ITS_bray ~ Day*Treatment, data = ITS_bray_df)

ITS_bray_adonis<- capture.output(adonis(ITS_d0_bray ~ Treatment, data = ITS_d0_bray_df),
                                 adonis(ITS_d7_bray ~ Treatment, data = ITS_d7_bray_df),
                                 adonis(ITS_d30_bray ~ Treatment, data = ITS_d30_bray_df),
                                 adonis(ITS_t0_bray ~ Day, data = ITS_t0_bray_df),
                                 adonis(ITS_t0.1_bray ~ Day, data = ITS_t0.1_bray_df),
                                 adonis(ITS_t10_bray ~ Day, data = ITS_t10_bray_df),
                                 file = "~/R/Grape/Figures/ITS_bray_adonis.txt")

CS_d0_bray <- phyloseq::distance(subset_samples(CS_biom_rr, Day == "0"), method = "bray")
CS_d0_bray_df <- data.frame(sample_data(subset_samples(CS_biom_rr, Day == "0")))
adonis(CS_d0_bray ~ Treatment, data = CS_d0_bray_df)

CS_d7_bray <- phyloseq::distance(subset_samples(CS_biom_rr, Day == "7"), method = "bray")
CS_d7_bray_df <- data.frame(sample_data(subset_samples(CS_biom_rr, Day == "7")))
adonis(CS_d7_bray ~ Treatment, data = CS_d7_bray_df)

CS_d30_bray <- phyloseq::distance(subset_samples(CS_biom_rr, Day == "30"), method = "bray")
CS_d30_bray_df <- data.frame(sample_data(subset_samples(CS_biom_rr, Day == "30")))
adonis(CS_d30_bray ~ Treatment, data = CS_d30_bray_df)

CS_t0_bray <- phyloseq::distance(subset_samples(CS_biom_rr, Treatment == "0"), method = "bray")
CS_t0_bray_df <- data.frame(sample_data(subset_samples(CS_biom_rr, Treatment == "0")))
adonis(CS_t0_bray ~ Day, data = CS_t0_bray_df)

CS_t0.1_bray <- phyloseq::distance(subset_samples(CS_biom_rr, Treatment == "0.1"), method = "bray")
CS_t0.1_bray_df <- data.frame(sample_data(subset_samples(CS_biom_rr, Treatment == "0.1")))
adonis(CS_t0.1_bray ~ Day, data = CS_t0.1_bray_df)

CS_t10_bray <- phyloseq::distance(subset_samples(CS_biom_rr, Treatment == "10"), method = "bray")
CS_t10_bray_df <- data.frame(sample_data(subset_samples(CS_biom_rr, Treatment == "10")))
adonis(CS_t10_bray ~ Day, data = CS_t10_bray_df)

CS_bray <- phyloseq::distance(CS_biom_rr, method = "bray")
CS_bray_df <- data.frame(sample_data(CS_biom_rr))
adonis(CS_bray ~ Day*Treatment, data = CS_bray_df)

CS_bray_adonis<- capture.output(adonis(CS_d0_bray ~ Treatment, data = CS_d0_bray_df),
                                 adonis(CS_d7_bray ~ Treatment, data = CS_d7_bray_df),
                                 adonis(CS_d30_bray ~ Treatment, data = CS_d30_bray_df),
                                 adonis(CS_t0_bray ~ Day, data = CS_t0_bray_df),
                                 adonis(CS_t0.1_bray ~ Day, data = CS_t0.1_bray_df),
                                 adonis(CS_t10_bray ~ Day, data = CS_t10_bray_df),
                                 file = "~/R/Grape/Figures/CS_bray_adonis.txt")