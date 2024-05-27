#goal: find out if there is a possibilty to get enough data to do a regression analysis on referendums/initiatives on climate change
#conclusion: there are 199 referendums/initiatives on climate change or the environment in general, which is not enough to do a regression analysis.
#

#get overview over the categories ----

#create a list of all the tags
all_tags <- data$items$tags

#turn list into vector
all_tags <- unlist(all_tags)

#remove duplicates
all_tags <- unique(all_tags)

#sort alphabatically
all_tags <- sort(all_tags)

#turn into df
all_tags <- as.data.frame(all_tags)


#subset the data to only include the categories we are interested in ----

#create a list of categories to filter by
filter_categories <- c(
  "Energy",
  "Energy policy",
  "Environment",
  "Environment and living space",
  "Environmental policy",
  "Forestry",
  "Hydro-electric power",
  "Nuclear energy",
  "Oil and gas",
  "Protection of nature and cultural heritage",
  "Soil",
  "Soil protection",
  "Waste",
  "Water pollution control"
)

#turn json into df
df <- as.data.frame(data$items)

#filter the data
filtered_df <- df[grepl(filter_categories, df$tags, ignore.case = TRUE),]

#ckeck if filtered_df is actually a data frame
class(filtered_df) 



#export titles of the filtered data ----

#export the titles
titles <- filtered_df$title$de
write.csv(titles, "data_prep/titles.csv")

#get some facts about the data and plot it out####

#oldest and newest referendum/initiative
min(filtered_df$date)
max(filtered_df$date)

df <- filtered_df

# Ensure the date column is in Date format
df <- df %>%
  mutate(date = as.Date(date, format = "%Y-%m-%d"))
glimpse(df$date)

# create new variable for year
df <- df %>%
  mutate(year = as.numeric(format(date, "%Y")))
glimpse(df$year)

# plot out number of referendums/initiatives per year
df %>%
  group_by(year) %>%
  summarise(n = n()) %>%
  ggplot(aes(x = year, y = n)) +
  geom_line() +
  geom_point() +
  labs(title = "Number of referendums/initiatives per year",
       x = "Year",
       y = "Number of referendums/initiatives") +
  theme_minimal()