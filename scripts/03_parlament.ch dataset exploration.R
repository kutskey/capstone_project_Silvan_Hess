#goal: check out this other dataset with data about parliamentary debates
#conclusion: i did not figure out how to get the data from the API

#clear work space
rm(list = ls())

# Load the necessary libraries
library(httr)
library(rvest)
library(tidyverse)

# URL for the /affairs/topics endpoint with HTML format
url <- "http://ws-old.parlament.ch/affairs/topics/?format=json"

# Send GET request to the URL
response <- GET(url)

#parse the response
response_parsed <- content(response, "text")
glimpse(response_parsed)

# Extract the HTML content from the response
html_content <- read_html(response_parsed)
glimpse(html_content)