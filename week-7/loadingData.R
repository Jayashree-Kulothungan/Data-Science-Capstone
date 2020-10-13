# importing required packages
library(dplyr)
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

##Basic Summary of data

#"en_US.blogs.txt"

head(blogs_data)
Lines <- length(blogs_data) 
Size <- gsub(' ',' ' , object.size(blogs_data))
wordCount <- wordcount(blogs_data, sep=" ", count.function = sum)
data <- data.frame(FileName = "en_US.blogs.txt" , 
                   FileSize = Size,
                   WordCount = wordCount,
                   Lines = Lines)

data

#"en_US.news.txt"
head(news_data)
Lines <- length(news_data) 
Size <- gsub(' ',' ' , object.size(news_data))
wordCount <- wordcount(news_data, sep=" ", count.function = sum)
data <- data.frame(FileName = "en_US.news.txt" , 
                   FileSize = Size,
                   WordCount = wordCount,
                   Lines = Lines)
data

#"en_US.twitter.txt"
head(twitter_data)
Lines <- length(twitter_data) 
Size <- gsub(' ',' ' , object.size(twitter_data))
wordCount <- wordcount(twitter_data, sep=" ", count.function = sum)
data <- data.frame(FileName = "en_US.blogs.txt" , 
                   FileSize = Size,
                   WordCount = wordCount,
                   Lines = Lines)
data

# create data samples
set.seed(12345)

test_data <- c(sample(blogs_data ,length(blogs_data) * 0.005),
               sample(news_data, length(news_data) * 0.005),
               sample(twitter_data, length(twitter_data) * 0.005)
)
# clean sample data

testdata <- iconv(test_data, "UTF-8", "ASCII", sub="")

sample_corpus <- VCorpus(VectorSource(testdata))
sample_corpus <- tm_map(sample_corpus, tolower)
sample_corpus <- tm_map(sample_corpus, stripWhitespace)
sample_corpus <- tm_map(sample_corpus, removePunctuation)
sample_corpus <- tm_map(sample_corpus, removeNumbers)
sample_corpus <- tm_map(sample_corpus, PlainTextDocument)

