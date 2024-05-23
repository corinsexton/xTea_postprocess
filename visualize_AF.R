
setwd("~/data1/corinne/benchmark_batch_effects/")


library(readr)
library(ggplot2)
library(dplyr)
library(ggsignif)
library(ggdist)
library(tidyr)
library(UpSetR)

library(caret) # sens and spec


te <- 'L1'
alu <- read_tsv(paste0("ALU_all_AF_merged.tsv"))
l1 <- read_tsv(paste0("L1_all_AF_merged.tsv"))
sva <- read_tsv(paste0("SVA_all_AF_merged.tsv"))

 save(alu,l1,sva, file = "merged_AF.RData")




#alu_long <- pivot_longer(alu,cols = c('pcawg_af','thyroid_broad_af','thyroid_novogene_af','lfs_light_af'))
#alu_long$value[is.na(alu_long$value)] <- 0
#
#alu_long$name <- factor(alu_long$name, labels = c("LFS Light et al\nn=22",
#                                                  "PCAWG EUR\nn=309",
#                                                  "Thyroid Broad\nn=98",
#                                                  "Thyroid Novogene\nn=30"))
#
#png(paste0('viz/',te,'_gnomad_af.png'),width = 1200,height = 750,res = 200)
#ggplot(alu_long,aes(x = gnomad_af,y = value,color = name)) +
#  geom_point(alpha = 0.3) +
#  facet_wrap(~name) +
#  labs(x = "gnomAD-SV NFE AF",
#       y = "Dataset AF",
#       title = paste0(te," Allele Frequencies")) +
#  geom_abline() +
#  theme_minimal() + theme(legend.position = 'none')
#dev.off()
#
#png(paste0('viz/',te,'_1kg_af.png'),width = 1200,height = 750,res = 200)
#ggplot(alu_long,aes(x = kg_af,y = value,color = name)) +
#  geom_point(alpha = 0.3) +
#  facet_wrap(~name) + geom_abline() +
#  labs(x = "1000 Genomes EUR AF",
#       y = "Dataset AF",
#       title = paste0(te," Allele Frequencies")) +
#  theme_minimal() + theme(legend.position = 'none')
#dev.off()
#
################# Presence/Absence > 0.5
#
#cutoff = seq(0,0.8,0.01)
#
#names_cutoff <- as.character(cutoff)
#
#
#not_in_gnomad <- data.frame(sapply(cutoff, function(x) {
#  c('pcawg' = sum(is.na(alu$gnomad_af) & alu$pcawg_af > x,na.rm = T),
#    'lfs_light' = sum(is.na(alu$gnomad_af) & alu$lfs_light_af > x,na.rm = T),
#    'thyroid_broad' = sum(is.na(alu$gnomad_af) & alu$thyroid_broad_af > x,na.rm = T),
#    'thyroid_novogene' = sum(is.na(alu$gnomad_af) & alu$thyroid_novogene_af > x,na.rm = T))
#}))
#
#colnames(not_in_gnomad) <- cutoff
#not_in_gnomad$dataset <- rownames(not_in_gnomad)
#
#not_in_gnomad_long <- pivot_longer(not_in_gnomad,cols = names_cutoff)
#
#not_in_gnomad_long$name <- as.numeric(not_in_gnomad_long$name)
#
#png(paste0('viz/',te,'_gnomad_not_present.png'),width = 1200,height = 750,res = 200)
#ggplot(not_in_gnomad_long,aes(y = value,x = name,color = dataset)) +
#  geom_line() + 
#  xlim(0,0.5) +
#  labs(y = "num insertions NOT in gnomAD",
#       x = "In dataset AF",
#       title = paste0(te," insertions not in gnomAD by dataset AF")) +
#  theme_minimal()
#dev.off()
#
### 1KG
#
#not_in_kg <- data.frame(sapply(cutoff, function(x) {
#  c('pcawg' = sum(is.na(alu$kg_af) & alu$pcawg_af > x,na.rm = T),
#    'lfs_light' = sum(is.na(alu$kg_af) & alu$lfs_light_af > x,na.rm = T),
#    'thyroid_broad' = sum(is.na(alu$kg_af) & alu$thyroid_broad_af > x,na.rm = T),
#    'thyroid_novogene' = sum(is.na(alu$kg_af) & alu$thyroid_novogene_af > x,na.rm = T))
#}))
#
#colnames(not_in_kg) <- cutoff
#not_in_kg$dataset <- rownames(not_in_kg)
#
#not_in_kg_long <- pivot_longer(not_in_kg,cols = names_cutoff)
#
#not_in_kg_long$name <- as.numeric(not_in_kg_long$name)
#
#png(paste0('viz/',te,'_1kg_not_present.png'),width = 900,height = 750,res = 200)
#ggplot(not_in_kg_long,aes(y = value,x = name,color = dataset)) +
#  geom_line() + 
#  xlim(0,0.1) +
#  labs(y = "num insertions NOT in 1KG",
#       x = "In dataset AF",
#       title = paste0(te," insertions not in 1KG by dataset AF")) +
#  theme_minimal()
#dev.off()
#
#
##############
#
#cutoff <- 0.5
#
#top500 <- alu %>% filter(gnomad_af > cutoff)
## sum(is.na(top500$thyroid_broad_af))
## sum(is.na(top500$thyroid_novogene_af))
## sum(is.na(top500$lfs_light_af))
#
#
#top500$pcawg_af[is.na(top500$pcawg_af)] <- 0
#top500$thyroid_broad_af[is.na(top500$thyroid_broad_af)] <- 0
#top500$lfs_light_af[is.na(top500$lfs_light_af)] <- 0
#top500$thyroid_novogene_af[is.na(top500$thyroid_novogene_af)] <- 0
#
#alu_long <- pivot_longer(top500,cols = c('pcawg_af','thyroid_novogene_af','thyroid_broad_af','gnomad_af','lfs_light_af'))
#
#diffs <- top500 %>% mutate(pcawg = pcawg_af / gnomad_af,
#                           broad = thyroid_broad_af / gnomad_af,
#                           novogene = thyroid_novogene_af / gnomad_af,
#                           lfs_light = lfs_light_af / gnomad_af)
#
#alu_long <- pivot_longer(diffs,cols = c('pcawg','broad','novogene','lfs_light'))
#
#alu_long$name <- factor(alu_long$name, levels = c('lfs_light','pcawg','broad','novogene'),
#                        labels = c("LFS Light et al\nn=22",
#                                   "PCAWG EUR\nn=309",
#                                   "Thyroid Broad\nn=98",
#                                   "Thyroid Novogene\nn=30"
#                        ))
#
#table(alu_long$name)
#
#alu_long$start <- factor(alu_long$start)
#
#png(paste0('viz/',te,'_gnomad_tophits.png'),width = 1300,height = 750,res = 200)
#ggplot(alu_long,aes(x = value,fill = name)) +
#  geom_histogram(binwidth = 0.05) + 
#  facet_wrap(~name) +
#  labs(y = "num insertions",
#       x = "dataset AF / gnomAD AF",
#       title = paste0("gnomAD-Top ", nrow(diffs), ' ',te," Differences in Allele Frequencies")) + geom_vline(xintercept = 1) +
#  theme_minimal() + theme(legend.position = 'none')
#dev.off()
#
#
## 1kg
#
#top500 <- alu %>% filter(kg_af > cutoff)
## sum(is.na(top500$thyroid_broad_af))
## sum(is.na(top500$thyroid_novogene_af))
## sum(is.na(top500$lfs_light_af))
#
#
#top500$pcawg_af[is.na(top500$pcawg_af)] <- 0
#top500$thyroid_broad_af[is.na(top500$thyroid_broad_af)] <- 0
#top500$lfs_light_af[is.na(top500$lfs_light_af)] <- 0
#top500$thyroid_novogene_af[is.na(top500$thyroid_novogene_af)] <- 0
#
## alu_long <- pivot_longer(top500,cols = c('pcawg_af','thyroid_novogene_af','thyroid_broad_af','gnomad_af','lfs_light_af'))
#
#diffs <- top500 %>% mutate(pcawg = pcawg_af / kg_af,
#                           broad = thyroid_broad_af / kg_af,
#                           novogene = thyroid_novogene_af / kg_af,
#                           lfs_light = lfs_light_af / kg_af)
#
#alu_long <- pivot_longer(diffs,cols = c('pcawg','broad','novogene','lfs_light'))
#
#alu_long$name <- factor(alu_long$name, levels = c('lfs_light','pcawg','broad','novogene'),
#                        labels = c("LFS Light et al\nn=22",
#                                   "PCAWG EUR\nn=309",
#                                   "Thyroid Broad\nn=98",
#                                   "Thyroid Novogene\nn=30"
#                        ))
#
#table(alu_long$name)
#
#alu_long$start <- factor(alu_long$start)
#
#png(paste0('viz/',te,'_1kg_tophits.png'),width = 1300,height = 750,res = 200)
#ggplot(alu_long,aes(x = value,fill = name)) +
#  geom_histogram(binwidth = 0.05) + 
#  facet_wrap(~name) +
#  labs(y = "num insertions",
#       x = "dataset AF / 1KG AF",
#       title = paste0("1KG-Top ", nrow(diffs), ' ',te," Differences in Allele Frequencies")) + geom_vline(xintercept = 1) +
#  theme_minimal() + theme(legend.position = 'none')
#dev.off()
#
#################
#
#top500 <- (alu %>% arrange(desc(gnomad_af))) %>% filter(gnomad_af > 0.5)
#
#top500$pcawg_af[is.na(top500$pcawg_af)] <- 0
#top500$thyroid_broad_af[is.na(top500$thyroid_broad_af)] <- 0
#top500$lfs_light_af[is.na(top500$lfs_light_af)] <- 0
#top500$thyroid_novogene_af[is.na(top500$thyroid_novogene_af)] <- 0
#
#diffs <- top500 %>% mutate(pcawg = pcawg_af - gnomad_af,
#                           broad = thyroid_broad_af -gnomad_af,
#                           novogene = thyroid_novogene_af -gnomad_af,
#                           lfs_light = lfs_light_af -gnomad_af)
#
#alu_long <- pivot_longer(diffs,cols = c('pcawg','broad','novogene','lfs_light'))
#
#alu_long$name <- factor(alu_long$name, levels = c('lfs_light','pcawg','broad','novogene'),
#                        labels = c("LFS Light et al\nn=22",
#                                   "PCAWG EUR\nn=309",
#                                   "Thyroid Broad\nn=98",
#                                   "Thyroid Novogene\nn=30"
#                                   ))
#
#table(alu_long$name)
#
#
#png(paste0('viz/',te,'_gnomad_diffs.png'),width = 1200,height = 750,res = 200)
#ggplot(alu_long,aes(x = name,y = value,fill = name)) +
#  stat_halfeye(adjust = 0.5, justification = 0, alpha = 0.5,
#               .width = 0, point_colour = NA) +
#  # geom_boxplot(width = 0.25,alpha = 1,outlier.size=0.5) + 
#  ylim(-1,1) + coord_flip() +
#labs(x = "Dataset",
#     y = "dataset AF - gnomAD AF",
#     title = paste0(te," Differences in Allele Frequencies")) +
#  # geom_signif(comparisons = list(c(1,4)),test = wilcox.test) +
#  theme_minimal() + theme(legend.position = 'none')
#dev.off()
#
#
#diffs <- top500 %>% mutate(pcawg = pcawg_af - kg_af,
#                           broad = thyroid_broad_af -kg_af,
#                           novogene = thyroid_novogene_af -kg_af,
#                           lfs_light = lfs_light_af -kg_af)
#
#alu_long <- pivot_longer(diffs,cols = c('pcawg','broad','novogene','lfs_light'))
#alu_long$name <- factor(alu_long$name, levels = c('lfs_light','pcawg','broad','novogene'),
#                        labels = c("LFS Light et al\nn=22",
#                                   "PCAWG EUR\nn=309",
#                                   "Thyroid Broad\nn=98",
#                                   "Thyroid Novogene\nn=30"
#                        ))
#
#png(paste0('viz/',te,'_kg_diffs.png'),width = 1200,height = 750,res = 200)
#ggplot(alu_long,aes(x = name,y = value,fill = name)) +
#  stat_halfeye(adjust = 0.5, justification = 0, alpha = 0.5,
#               .width = 0, point_colour = NA) +
#  geom_boxplot(width = 0.25,alpha = 1,outlier.size=0.5) + 
#  ylim(-1,1) + coord_flip() +
#  labs(x = "Dataset",
#       y = "dataset AF - 1kg AF",
#       title = paste0(te," Differences in Allele Frequencies")) +
#  # geom_signif(comparisons = list(c(2,4)),test = wilcox.test) +
#  theme_minimal() + theme(legend.position = 'none')
#dev.off()
#
#
################# UPSET PLOT
#
#library(ComplexUpset)
#te = 'ALU'
#alu <- read_tsv(paste0(te,"_all_AF_merged.tsv"))
#
#sets <- alu[,3:8]
#
#sets <- as.data.frame(ifelse(is.na(sets),0,1))
#
#dataset_names = c("1KG","gnomAD-SV","PCAWG","Thyroid (Broad)","Thyroid (Novogene)","LFS Light et al")
#colnames(sets) <- dataset_names
#
#png(paste0('viz/',te,'_upset.png'),width = 2000,height = 750,res = 200)
#upset(sets,dataset_names,name = paste0(te," insertion dataset"), min_size = 30,
#      sort_intersections="descending",
#      sort_sets=F,
#      sort_intersections_by=c('degree', 'cardinality'))
#dev.off()
#
#
#
#
#################
#
#
#
#get_prec_recall <- function(df, obs_var1, pred_var2, cutoff_af) {
#  # var1 -> database (truth)
#  # var2 -> dataset (in question)
#  small <- df %>% select(chr,start,obs_var1, pred_var2) %>% filter(UQ(sym(obs_var1)) >= cutoff_af | UQ(sym(pred_var2)) >= cutoff_af)
#  # small <- df %>% select(chr,start,obs_var1, pred_var2) %>% filter(UQ(sym(obs_var1)) >= cutoff_af)
#  
#  predicted <- ifelse(is.na(small[,3]),'missing','found')
#  observed <- ifelse(is.na(small[,4]),'missing','found')
#  
#  
#  m = table(predicted,observed)
#  conf_mat <- confusionMatrix(m)
#  
#  c("precision" = conf_mat$byClass[["Precision"]],"recall" = conf_mat$byClass[["Recall"]],"F1" = conf_mat$byClass[["F1"]])
#}
#
#df <- alu
#obs_var1 <- "gnomad_af"
#pred_var2 <- "pcawg_af"
#cutoff_af <- 0.8
#
#cutoffs <- c(0.03,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8)
## cutoffs <- c(0.2,0.3,0.4,0.5)
#
#df <- data.frame(t(sapply(cutoffs,FUN = function(x) {
#  get_prec_recall(alu,"gnomad_af","pcawg_af",x)
#})))
#df$af <- cutoffs
#df$dataset <- "pcawg_af"
#
#df_lfs <- data.frame(t(sapply(cutoffs,FUN = function(x) {
#  get_prec_recall(alu,"gnomad_af","lfs_light_af",x)
#})))
#df_lfs$af <- cutoffs
#df_lfs$dataset <- "lfs_light_af"
#
#total_df <- rbind.data.frame(df,df_lfs)
#
#
#df <- data.frame(t(sapply(cutoffs,FUN = function(x) {
#  get_prec_recall(alu,"gnomad_af","thyroid_novogene_af",x)
#})))
#df$af <- cutoffs
#df$dataset <- "thyroid_novogene_af"
#total_df <- rbind.data.frame(total_df,df)
#
#
#df <- data.frame(t(sapply(cutoffs,FUN = function(x) {
#  get_prec_recall(alu,"gnomad_af","thyroid_broad_af",x)
#})))
#df$af <- cutoffs
#df$dataset <- "thyroid_broad_af"
#total_df <- rbind.data.frame(total_df,df)
#
#plot_df <- pivot_longer(total_df,cols = c('precision','recall','F1'))
#
#ggplot(plot_df,aes(x = af, y = value,color = dataset)) +
#  geom_line() +
#  facet_wrap(~name,nrow = 3,scales= 'free') +
#  theme_minimal() +
#  labs(title = paste0(te, ' in gnomad-SV'))
#
#ggplot(plot_df[plot_df$name == 'precision',],aes(x = af, y = value,color = dataset)) +
#  geom_line() +
#  theme_minimal() +
#  labs(title = paste0(te, ' in gnomad-SV'))
#
#
#
#
