# load preprocessed data ----

# clear work space
rm(list = ls())

# load packages
library(tidyverse)

# load the data
load("data_prep/swiss_voting.RData")

# prepare data for shiny app ----

# overview
glimpse(df)

## cantons ----

# delete missing values in cantons
df <- df %>% filter(!is.na(canton))

# create a list of all possible cantons
cantons <- df$canton %>% unique()

# sort alphabetically
cantons <- sort(cantons)

#print out object type of cantons
class(cantons)

## tags ----

# create a list of all possible tags
tags <- df$tags %>% unique()

# create a character vector of all tags
tags <- unlist(tags)

# delete double entries
tags <- unique(tags)

# sort alphabetically
tags <- sort(tags)
