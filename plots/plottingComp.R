library(ggplot2)
library(tidyverse)
args <- commandArgs(trailingOnly = TRUE)
df<-read.csv(args[1])
df <- df %>% mutate(Servidor="ams")
df2<-read.csv(args[2])
df2 <- df2 %>% mutate(Servidor="mist")
df_total <- bind_rows(df, df2)
df_pivotado <- pivot_longer(df_total, cols=starts_with("i"), names_to="intento", values_to="recursos") 
df_summary <- df_pivotado %>% group_by(n,var,Servidor) %>% summarise(mean=mean(recursos), sd=sd(recursos))
cpu <- df_summary %>% filter(var=="cpu")
ram <- df_summary %>% filter(var=="ram")

pdf(args[3],width=5,height=3)
ggplot(data=cpu,
       aes(
       x=factor(n),
       y=mean)) +
       geom_line(aes(group=Servidor)) +
       geom_point(aes(group=Servidor, shape=Servidor)) +
       labs(y="Valores medios de uso de CPU (m)",x="Número de clientes") +
       theme(
            axis.text.x = element_text(color="black"),
            axis.text.y = element_text(color="black"),
            panel.grid.major = element_line(color = 'black', size = 0.1),
            panel.grid.minor = element_line(color = '#665c54', linetype = 'dotted'),
            plot.margin = margin(c(15,15,15,15)),
            panel.background = element_rect(colour="#282828"),
            strip.background = element_rect(color="#282828", fill="#d8a657"))


pdf(args[4],width=5,height=3)
ggplot(data=ram,
       aes(
       x=factor(n),
       y=mean)) +
       geom_line(aes(group=Servidor)) +
       geom_point(aes(group=Servidor, shape=Servidor)) +
       labs(y="Valores medios de uso de RAM (MiB)",x="Número de clientes") +
       theme(
            axis.text.x = element_text(color="black"),
            axis.text.y = element_text(color="black"),
            panel.grid.major = element_line(color = 'black', size = 0.1),
            panel.grid.minor = element_line(color = '#665c54', linetype = 'dotted'),
            plot.margin = margin(c(15,15,15,15)),
            panel.background = element_rect(colour="#282828"),
            strip.background = element_rect(color="#282828", fill="#d8a657"))
