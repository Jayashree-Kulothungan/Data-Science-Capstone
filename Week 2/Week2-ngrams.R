# importing required packages
library(dplyr)
library(ggplot2)
library(stringi)
library(tm)
library(RWeka)
library(wordcloud)
library(ngram)
library(R.utils)
#importing data from text files
conn <- file("en_US.blogs.txt")
blogs_data <- readLines(conn, encoding="UTF-8", skipNul=TRUE)
close(conn)

file <- file("en_US.news.txt")
news_data <- readLines(conn, encoding="UTF-8", skipNul=TRUE)
close(conn)

file <- file("en_US.twitter.txt")
twitter_data <- readLines(conn, encoding="UTF-8", skipNul=TRUE)
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

##Data Cleaning
## Combine all data into test data frame

test_data <- c(sample(blogs_data ,length(blogs_data) * 0.005),
               sample(news_data, length(news_data) * 0.005),
               sample(twitter_data, length(twitter_data) * 0.005)
)
testdata <- iconv(test_data, "UTF-8", "ASCII", sub="")

sample_corpus <- VCorpus(VectorSource(testdata))
sample_corpus <- tm_map(sample_corpus, tolower)
sample_corpus <- tm_map(sample_corpus, stripWhitespace)
sample_corpus <- tm_map(sample_corpus, removePunctuation)
sample_corpus <- tm_map(sample_corpus, removeNumbers)
sample_corpus <- tm_map(sample_corpus, PlainTextDocument)

##creating N-grams for our data

unigram <- function(x) NGramTokenizer(x, Weka_control(min=1, max=1))
bigram <- function(x) NGramTokenizer(x, Weka_control(min=2, max=2))
trigram <- function(x) NGramTokenizer(x, Weka_control(min=3, max=3))

unidtf <- TermDocumentMatrix(sample_corpus, control=list(tokenize=unigram))
bidtf <- TermDocumentMatrix(sample_corpus, control=list(tokenize=bigram))
tridtf <- TermDocumentMatrix(sample_corpus, control=list(tokenize=trigram))

uni_tf <- findFreqTerms(unidtf, lowfreq = 50 )
bi_tf <- findFreqTerms(bidtf, lowfreq = 50 )
tri_tf <- findFreqTerms(tridtf, lowfreq = 10 )

uni_freq <- rowSums(as.matrix(unidtf[uni_tf, ]))
uni_freq <- data.frame(words=names(uni_freq), frequency=uni_freq)
head(uni_freq)

bi_freq <- rowSums(as.matrix(bidtf[bi_tf, ]))
bi_freq <- data.frame(words=names(bi_freq), frequency=bi_freq)
head(bi_freq)

tri_freq <- rowSums(as.matrix(tridtf[tri_tf, ]))
tri_freq <- data.frame(words=names(tri_freq), frequency=tri_freq)
head(tri_freq)

##Plotting N-gram Data
## plotting Bi-freq data using word cloud
wordcloud(words=bi_freq$words, freq=bi_freq$frequency, max.words=100, colors = brewer.pal(8, "Dark2"))

## plotting Uni-freq
plot_freq <- ggplot(data = uni_freq[order(-uni_freq$frequency),][1:15, ], aes(x = reorder(words, -frequency), y=frequency)) +
        geom_bar(stat="identity", fill="yellow") + 
        ggtitle("Top Unigram") + xlab("words") +  ylab("frequency")


plot_freq

##Plotting Tri- freq
plot_freq <- ggplot(data = tri_freq[order(-tri_freq$frequency),][1:15, ],
                    aes(x = reorder(words, -frequency), y=frequency)) +
        geom_bar(stat="identity", fill="pink") + 
        theme(axis.text.x = element_text(angle = 45)) + 
        ggtitle("Top Trigram") + xlab("words") +  ylab("frequency")

plot_freq
