# importing required packages
library(dplyr)
library(ggplot2)
library(stringi)
library(tm)
library(RWeka)
library(wordcloud)
library(ngram)
library(R.utils)
library(tidyr)

# importing data from text files
conn <- file("en_US.blogs.txt")
blogs_data <- readLines(conn, encoding="UTF-8", skipNul=TRUE)
blogs_data <-data.frame(blogs_data)
close(conn)

file <- file("en_US.news.txt")
news_data <- readLines(conn, encoding="UTF-8", skipNul=TRUE)
news_data <- data.frame(news_data)
close(conn)

file <- file("en_US.twitter.txt")
twitter_data <- readLines(conn, encoding="UTF-8", skipNul=TRUE)
twitter_data <- data.frame(twitter_data)
close(conn)
