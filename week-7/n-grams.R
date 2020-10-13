
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

#create ngrams

unigram <- function(x) NGramTokenizer(x, Weka_control(min=1, max=1))
bigram <- function(x) NGramTokenizer(x, Weka_control(min=2, max=2))
trigram <- function(x) NGramTokenizer(x, Weka_control(min=3, max=3))
quadgram <- function(x) NGramTokenizer(x, Weka_control(min=4, max=4))
quintgram <- function(x) NGramTokenizer(x, Weka_control(min=5, max=5))

unidtf <- TermDocumentMatrix(sample_corpus, control=list(tokenize=unigram))
bidtf <- TermDocumentMatrix(sample_corpus, control=list(tokenize=bigram))
tridtf <- TermDocumentMatrix(sample_corpus, control=list(tokenize=trigram))
quadtf <- TermDocumentMatrix(sample_corpus, control=list(tokenize=quadgram))
quinttf <-TermDocumentMatrix(sample_corpus, control=list(tokenize=quintgram))

uni_tf <- findFreqTerms(unidtf, lowfreq = 50 )
bi_tf <- findFreqTerms(bidtf, lowfreq = 50 )
tri_tf <- findFreqTerms(tridtf, lowfreq = 10 )
quad_tf <- findFreqTerms(quadtf, lowfreq = 10 )
quint_tf <- findFreqTerms(quinttf, lowfreq = 10 )

#unigram
uni_freq <- rowSums(as.matrix(unidtf[uni_tf, ]))
uni_freq <- data.frame(words=names(uni_freq), frequency=uni_freq)
head(uni_freq)

#bigram
bi_freq <- rowSums(as.matrix(bidtf[bi_tf, ]))
bi_freq <- data.frame(words=names(bi_freq), frequency=bi_freq)
head(bi_freq)

#trigrams

tri_freq <- rowSums(as.matrix(tridtf[tri_tf, ]))
tri_freq <- data.frame(words=names(tri_freq), frequency=tri_freq)
head(tri_freq)

#quadgrams
quad_freq <- rowSums(as.matrix(quadtf[quad_tf, ]))
quad_freq <- data.frame(words=names(quad_freq), frequency=quad_freq)
head(quad_freq)

#quintgrams
quint_freq <- rowSums(as.matrix(quinttf[quint_tf, ]))
quint_freq <- data.frame(words=names(quint_freq), frequency=quint_freq)
head(quint_freq)

# seperate words
#single words
uni_tf <- data.frame(uni_tf)
uni_words <- uni_tf %>%
        separate(uni_tf, c("word1"))
uni_words

#double words
bi_tf <- data.frame(bi_tf)
bi_words <- bi_tf %>%
        separate(bi_tf, c("word1","word2"), sep=" ")
bi_words

#three words
tri_tf <- data.frame(tri_tf)
tri_words <- tri_tf %>%
        separate(tri_tf, c("word1","word2", "word3"), sep=" ")
tri_words

#four words
quad_tf <- data.frame(quad_tf)
quad_words <- quad_tf %>%
        separate(quad_tf, c("word1","word2","word3","word4"), sep=" ")
quad_words

#five words
quint_tf <- data.frame(quint_tf)
quint_words <- quint_tf %>%
        separate(quint_tf, c("word1","word2","word3","word4","word5"), sep=" ")
quint_words

#save the data

saveRDS(uni_words , "./uni_words.rds")
saveRDS(bi_words , "./bi_words.rds")
saveRDS(tri_words , "./tri_words.rds")
saveRDS(quad_words , "./quad_words.rds")
saveRDS(quint_words , "./quint_words.rds")


sessionInfo()
