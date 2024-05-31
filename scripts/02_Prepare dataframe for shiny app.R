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

# create table of dates + titles + results ----

#overview
glimpse(df)
head(df$categories, 10)
head(df$title, 1)

# only keep most important variables
df_selected <- df %>% select(canton, date, title, result)

# unnest variable title
unnested_df <- df_selected %>%
  unnest(cols = c(title))

# rename columns
renamed_df <- unnested_df %>%
  rename(
    Titel = de,
    title_en = en,
    title_fr = fr,
    Datum = date,
    Resultat = result
  )

# remove title_fr and tile_fr
renamed_df <- renamed_df %>%
  select(-title_fr, -title_en)

#rename df and remove the rest
app_table <- renamed_df
rm(df_selected, unnested_df, renamed_df)

# translate results into german
app_table <- app_table %>%
  mutate(Resultat = if_else(Resultat == "Yes", "angenommen", Resultat))
app_table <- app_table %>%
  mutate(Resultat = if_else(Resultat == "No", "abgelehnt", Resultat))

stop()

# create table of tags + count----

# create a list of all the tags grouped by canton
tags_by_canton <- df %>% group_by(canton) %>% summarise(tags = list(tags))

# turn the lists in tags_by_canton$tags into a character vector
tags_by_canton$tags <- lapply(tags_by_canton$tags, unlist)

# Unnest the tags column
data_unnested <- tags_by_canton %>%
  unnest(tags)

# Count the occurrences of each unique character string within each canton
data_counts <- data_unnested %>%
  group_by(canton, tags) %>%
  summarise(count = n(), .groups = 'drop')

# Sort by canton and count (largest to smallest)
tags_df <- data_counts %>%
  arrange(canton, desc(count))

# save all the data ----

#create list of filters
filters <- list(
  cantons = cantons
)

# save the data
save(app_table, filters, tags_df, file = "shiny/app_data.RData")

