# import data ----

#clear work space
rm(list = ls())

#load packages
library(jsonlite)
library(tidyverse)

#load the data
data <- fromJSON("data_orig/swiss_voting.json")

#turn json into df
df <- as.data.frame(data$items)