library(ggplot2)
library(tidyverse)
args <- commandArgs(trailingOnly = TRUE)
pdf(args[2],width=5,height=3)
df<-read.csv(args[1])
df_pivotado <- pivot_longer(df, cols=starts_with("i"), names_to="intento", values_to="recursos") 
df_summary <- df_pivotado %>% group_by(n,var) %>% summarise(mean=mean(recursos), sd=sd(recursos))
var.labs <- c("CPU (m)","RAM (MiB)")
names(var.labs) <- c("cpu","ram")
ggplot(data=df_summary, 
       aes(
           x=factor(n),
           y=mean)) +
       geom_col(fill="#665c54", colour="#282828") +
       geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), colour="#cc241d") +
       facet_grid(.~var, scales="free", labeller = labeller(var = var.labs)) +
       coord_flip() +
       labs(y="Valores medios de uso de recursos",x="Número de clientes") +
       theme(
            axis.text.x = element_text(color="black"),
            axis.text.y = element_text(color="black"),
            panel.grid.major = element_line(color = 'black', size = 0.1),
            panel.grid.minor = element_line(color = '#665c54', linetype = 'dotted'),
            plot.margin = margin(c(15,15,15,15)),
            panel.background = element_rect(colour="#282828"),
            strip.background = element_rect(color="#282828", fill="#d8a657"))
