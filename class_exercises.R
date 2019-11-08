
## start with libraries & tidyverse ----
library(tidyverse)
library(skimr)

## show how to determine where a function comes from
sob_limited_group_1 <- read_csv("01_data/sob_limited_group_1.csv")

## what do we see if we just type the dataframe name
sob_limited_group_1


## show ctrl click


skim(sob_limited_group_1)

sob_limited_group_1 %>%
  filter(stAbbr == "IA" & cropName == "CORN") %>%
  skim


sob_limited_group_1 %>%
  filter((stAbbr == "IA" & cropName == "CORN") |
           (stAbbr == "IL" & cropName == "SOYBEANS")) %>%
  skim



sob_limited_group_1 %>%
  filter((stAbbr == "IA" & cropName == "CORN") |
           (stAbbr == "IL" & cropName == "SOYBEANS")) %>%
  select(stAbbr, cropName) %>%
  distinct



sob_limited_group_1 %>%
  filter((stAbbr == "IA" & cropName == "CORN") |
           (stAbbr == "IL" & cropName == "SOYBEANS")) %>%
  group_by(stAbbr, cropName) 




sob_limited_group_1 %>%
  filter((stAbbr == "IA" & cropName == "CORN") |
           (stAbbr == "IL" & cropName == "SOYBEANS"))   %>%
  group_by(stAbbr, cropName) %>%
  summarize(prem = sum(prem))



sob_limited_group_1 %>%
  filter((stAbbr == "IA" & cropName == "CORN") |
           (stAbbr == "IL" & cropName == "SOYBEANS")) %>%
  group_by(year, stAbbr, cropName) %>%
  summarize(prem = sum(prem))



sob_limited_group_1 %>%
  filter((stAbbr == "IA" & cropName == "CORN") |
           (stAbbr == "IL" & cropName == "SOYBEANS")) %>%
  group_by(year, stAbbr, cropName) %>%
  summarize(prem = sum(prem)) %>%
  arrange(year, stAbbr)

sob_limited_group_1 %>%
  filter((stAbbr == "IA" & cropName == "CORN") |
           (stAbbr == "IL" & cropName == "SOYBEANS")) %>%
  group_by(year, stAbbr, cropName) %>%
  summarize(prem = sum(prem)) %>%
  arrange(stAbbr, year) %>% View

sob_limited_group_1 %>%
  filter((stAbbr == "IA" & cropName == "CORN") |
           (stAbbr == "IL" & cropName == "SOYBEANS")) %>%
  group_by(year, stAbbr, cropName) %>%
  summarize(prem = sum(prem)) %>%
  arrange(stAbbr, year) %>% 
  mutate(state_crop = paste(stAbbr, cropName)) 



sob_limited_group_1 %>%
  filter((stAbbr == "IA" & cropName == "CORN") |
           (stAbbr == "IL" & cropName == "SOYBEANS")) %>%
  group_by(year, stAbbr, cropName) %>%
  summarize(prem = sum(prem)) %>%
  arrange(stAbbr, year) %>% 
  mutate(state_crop = paste(stAbbr, cropName)) ->
  two_states_crops


## now let's install esquisse 
install.packages("esquisse")
library(esquisse)


ggplot(two_states_crops) +
  aes(x = year, y = prem, colour = state_crop) +
  geom_line(size = 1L) +
  scale_color_hue() +
  theme_minimal()

## gotchas with esquisse: have data preaggreaged.. this aint a pivot graph
## ggplot likes long data, we should too

## spend some time unpacking ggplot syntax

## ref https://r-graphics.org/chapter-line-graph



sob_limited_group_1 %>%
  group_by(year) %>%
  summarize(prem=sum(prem)) %>%
  tail


