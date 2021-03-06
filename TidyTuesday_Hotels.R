---
title: "TidyTuesday_10feb"
author: "Sil Aarts"
date: "2/9/2020"
output:
  pdf_document: default
  html_document:
    df_print: paged
  word: default
  word_document: default
---

```{r setup, echo=F, warnings=F, message=F }
#Load Libraries
library(tidyverse)
library(RColorBrewer)
library(paletteer)
library(cowplot)
library(ggtext)
library(extrafont)
library(magick)

#Read file
hotels <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-02-11/hotels.csv')

#Summary
unique(hotels$children)
summary(hotels$adr)

#Drop missing
hotels1 <- hotels%>%
  filter(!is.na(children))

#Select check-out
hotels2 <- hotels1 %>%
  filter(reservation_status=="Check-Out")

hotels2$children <- as.factor(hotels2$children)

#Make some colors
#Colors for bubbles
my_colors2 <- c("#005C75", "#00C9E1", "#FF7E87","#97062C", "white") 
```

```{r echo=F, warnings=F, message=F }
# Title
title <- ggplot(data.frame(x = 1:2, y = 1:10)) +
  labs(x = NULL, y = NULL,
       subtitle = "When exploring <b style='color:#FF9933'>HOTELS</b> we see that different meal options (i.e. BB= Bed &<br>Breakfast, HB= Half Board, FB= Full Board & Undefined/SC= Usually no meals)<br>are chosen when taking kids to a hotel.<br>In addition, the Average Daily Rate (ADR, defined by dividing the sum of all<br>lodging transactions by the total number of staying nights) gradually<br>increases per kid. When looking at special requests, they don't increase when<br>the number of kids increases.") +
 theme_minimal(10)+
  theme(
  text = element_text(family="mono"),
  plot.subtitle = element_markdown(color="white", size=25),
  plot.background = element_rect(fill = "black", color = "black"),
  panel.background = element_rect(fill = "black", color = "black"),
  panel.border = element_rect(fill = NA, color = NA),
  strip.background = element_rect(fill = NA, color = NA),
  legend.background = element_rect(fill = NA, color = NA),
  legend.key = element_rect(fill = NA, color = NA),
  plot.margin = margin(20, 20, 20, 20))
```


```{r echo=F, warnings=F, message=F }
p1 <- ggplot(hotels2, aes(children, meal)) + 
  geom_jitter(aes(colour=children), alpha=0.6, size=2)+
  scale_color_manual(values=my_colors2)+
  labs(x = "", y = "Type of meal(s) booked")+
  theme_classic()+
    theme(
    plot.title = element_markdown(color="white", size=38, hjust=0.5, vjust=0.7),
    axis.line.x = element_line(colour = "white", size=0.5, linetype='solid'),
    axis.title.x = element_text(size=18, family="mono", colour="white"),
    axis.text.x = element_text(size=15, family="mono", colour="white"),
    axis.text.y= element_blank(),
    legend.position="none", 
    panel.background = element_rect(fill = "black", color="black"),
    plot.background = element_rect(fill = "black", color="black"),
    strip.background = element_rect(fill = NA, color = NA),
    legend.key = element_rect(fill = NA, color = NA))+
  coord_flip()
```


```{r echo=F, warnings=F, message=F }
p3 <- ggplot(hotels2, aes(children, adr))+
  geom_boxplot(aes(color = children), width = 0.5, size = 0.8, fill="black", alpha=0.6)+
  scale_fill_manual(values = my_colors2) +
  labs(x="", y= "AVR", colour="KIDS")+
  scale_color_manual(values = my_colors2)+
  scale_y_continuous(position="right")+
  theme_classic()+
  theme(
    text = element_text(family="mono"),
    axis.title.y = element_text(size=18, family="mono", colour="white"),
    axis.text.x= element_blank(),
    axis.text.y = element_text(size=15, family="mono", colour="white"),
    legend.position="top", 
    legend.box = "horizontal",
    legend.background = element_rect(fill="black", size=0.5, linetype="solid", colour="black"),
    legend.text = element_text(colour="white", size=25),
    legend.title = element_text(colour="white", size=25),
    panel.background = element_rect(fill = "black", color="black"),
    plot.background = element_rect(fill = "black", color="black"),
    strip.background = element_rect(fill = NA, color = NA),
    legend.key = element_rect(fill = NA, color = NA))
```

```{r warnings=F, message=F }
# Title
title2 <- ggplot(data.frame(x = 1:2, y = 1:10)) +
  labs(x = NULL, y = NULL,
      title = "ARE WE BRINGING THE <b style='color:#00C9E1'>K</b><b style='color:#FF7E87'>I</b><b style='color:#00C9E1'>D</b><b style='color:#FF7E87'>S</b>?")+
 theme_minimal(10)+
  theme(
  text = element_text(family="mono"),
  plot.title = element_markdown(color="white", size=65, hjust=0.5),
  plot.background = element_rect(fill = "black", color = "black"),
  panel.background = element_rect(fill = "black", color = "black"),
  panel.border = element_rect(fill = NA, color = NA),
  strip.background = element_rect(fill = NA, color = NA),
  legend.background = element_rect(fill = NA, color = NA),
  legend.key = element_rect(fill = NA, color = NA),
  plot.margin = margin(20, 20, 20, 20))

```

```{r}
# Title
cap <- ggplot(data.frame(x = 1:2, y = 1:10)) +
  labs(x = NULL, y = NULL,
      caption = "Source: Antonio, Almeida & Nunes (2019) | Plot by <b style='color:#00C9E1'>@sil_aarts</b>")+
 theme_minimal(10)+
  theme(
  text = element_text(family="mono"),
  plot.caption = element_markdown(color="white", size=15, hjust=0.5),
  plot.background = element_rect(fill = "black", color = "black"),
  panel.background = element_rect(fill = "black", color = "black"),
  panel.border = element_rect(fill = NA, color = NA),
  strip.background = element_rect(fill = NA, color = NA),
  legend.background = element_rect(fill = NA, color = NA),
  legend.key = element_rect(fill = NA, color = NA))
```

```{r}
p4 <- ggplot(hotels2, aes(total_of_special_requests))+
  geom_bar(aes(fill=children), position = position_stack(reverse = TRUE))+
  labs(x="# of special requests", 
       y= "")+
  scale_fill_manual(values = my_colors2)+
  scale_x_continuous(breaks = c(0,1,2,3,4,5))+
  theme_classic()+
  theme(
    text = element_text(family="mono"),
    axis.line.x = element_line(colour = "white", size=0.5, linetype='solid'),
    axis.title.x = element_text(size=18, colour="white"),
    axis.text.y= element_text(size=15, colour="white"),
    axis.text.x= element_text(size=15, colour="white"),
    legend.position="none", 
    panel.background = element_rect(fill = "black", color="black"),
    plot.background = element_rect(fill = "black", color="black"),
    strip.background = element_rect(fill = NA, color = NA),
    legend.key = element_rect(fill = NA, color = NA))
```

```{r fig.width = 25, fig.height = 20}
#Combine plots
pf <-  plot_grid(p1, title, p4, nrow=3, rel_heights = c(10,4,10))

pf2 <- plot_grid(pf, p3, ncol=2, rel_heights = c(10,10), rel_widths = c(15,8))

pf3 <- plot_grid(title2, pf2, cap, nrow=3, rel_heights = c(1, 12, 0.3))
pf3
```
