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

# select variables for shiny app ----

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

# create a df of the tags and their counts ----

# create a list of all the tags
tags <- df$tags

#unlist the tags
tags <- unlist(tags)

# Calculate the unique character strings
unique_chars <- unique(tags)

# Step 3: Count the occurrences of each unique character string
char_counts <- table(tags)

# Step 4: Create a dataframe with the unique character strings and their counts
tags_df <- data.frame(Character = names(char_counts), Count = as.integer(char_counts))

# sort biggest to smallest count
tags_df <- tags_df[order(-tags_df$Count), ]

# save all the data ----

#create list of filters
filters <- list(
  cantons = cantons
)

# save the data
save(app_table, filters, tags_df, file = "shiny/app_data.RData")

