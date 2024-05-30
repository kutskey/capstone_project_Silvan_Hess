# load preprocessed data ----

# clear work space
rm(list = ls())

# load packages
library(tidyverse)

# load the data
load("data_prep/swiss_voting.RData")

# prepare filters for shiny app ----

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

# select variables for shiny app ----

#overview
glimpse(df)
head(df$categories, 10)
head(df$title, 1)

# only keep votes_yes, votes_no, canton, tags, question, question_en, title and date
df_selected <- df %>% select(votes_yes, votes_no, canton, tags, question, question_en, title, date)

# unnest variable title
unnested_df <- df_selected %>%
  unnest(cols = c(title))

# rename columns
renamed_df <- unnested_df %>%
  rename(
    title_de = de,
    title_en = en,
    title_fr = fr,
    question_de = question,
  )

# remove title_fr
renamed_df <- renamed_df %>%
  select(-title_fr)

# rename data frame to app_table and remove the other data frames
app_table <- renamed_df
rm(df_selected, unnested_df, renamed_df)

# save all the data ----

#create list of filters
filters <- list(
  cantons = cantons,
  tags = tags
)

# save the data
save(app_table, filters, file = "data_prep/app_data.RData")

