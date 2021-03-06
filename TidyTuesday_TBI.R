---
title: "TidyTuesday_24maart"
author: "Sil Aarts"
date: "3/24/2020"
---
  
#Load Libraries
library(tidyverse)
library(RColorBrewer)
library(paletteer)
library(cowplot)
library(ggtext)
library(extrafont)
library(magick)
library(showtext)
library(showtextdb)
library(harrypotter)
library(glue)
library(ggforce)

#Read file
tbi <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-03-24/tbi_age.csv')

#Summary
unique(tbi$age_group)

#Drop missing
tbi1 <- tbi %>%
  filter(age_group == "25-34" & type== "Deaths")

#Change name
tbi1$injury_mechanism[5] <- "Intentional Selfharm"

#Make some fonts!
#Choose font
font_add_google("Exo", "B")
showtext_auto()

#Make some colours
colors <- c("#605672","#A261A5","#0080CB","#0080CB","#008A88","#8290E0","#BDA5AD")

#GGplot: donut
p <- ggplot(tbi1, aes(x=2, y=number_est, fill=type)) +
  geom_bar(stat= "identity", width = 1, fill=colors, alpha=0.7) +
  scale_fill_manual(values = colors)+
  xlim(c(1, 3)) +
  geom_mark_circle(aes(y = 1000, filter = str_detect(injury_mechanism, "Motor Vehicle Crashes"), label = glue("{number_est} people"), description = glue("{injury_mechanism}")), label.fill=  "wheat2", label.buffer = unit(30, "mm"), label.family = c("mono"), expand = unit(2, "mm"), con.type="elbow") +
  geom_mark_circle(aes(y = 4000, filter = str_detect(injury_mechanism, "Intentional Selfharm"), label = glue("{number_est} people"), description = glue("{injury_mechanism}")),  label.fill=  "wheat2", label.buffer = unit(30, "mm"), label.family = c("mono"), expand = unit(2, "mm"), con.type="elbow") + 
  geom_mark_circle(aes(y = 5700, filter = str_detect(injury_mechanism, "Assault"), label = glue("{number_est} people"), description = glue("{injury_mechanism}")), label.fill=  "wheat2", label.buffer = unit(30, "mm"), label.family = c("mono"), expand = unit(2, "mm"), con.type="elbow")+
  theme(panel.grid=element_blank()) +
  theme(axis.text=element_blank()) +
  theme(axis.ticks=element_blank()) +
  labs(title="Brain Injury Awareness Month", 
      subtitle= "Types of Traumatic Brain Injury Among People aged 25 to 34 Resulting in Deaths (2014)",
      caption= "Source: CDC Traumatic Brain Injury Report | Plot by @sil_aarts")+
theme_void()+
  theme(
    text = element_text(family="B"),
    plot.title = element_text(size=22, face="bold", hjust=0.5),
    plot.subtitle= element_text(size=11, hjust=0.5),
    plot.caption = element_text(size=10),
    #axis.title.x = element_text(size=18, colour="white"),
    #axis.text.y= element_text(size=15, colour="white"),
    #axis.text.x= element_text(size=15, colour="white"),
    legend.position="none", 
    panel.background = element_rect(fill = "wheat2", color="wheat2"),
    plot.background = element_rect(fill = "wheat2", color="wheat2"),
    strip.background = element_rect(fill = NA, color = NA),
    legend.key = element_rect(fill = NA, color = NA))+
  coord_polar(theta="y") 

#Run quartz for showtext
quartz()

#Run it!
p
