library(tidyverse)
library(stringr)
library(dplyr)
library(ngram)
library(tidyr)

# load data
 
uni_words <- readRDS("./uni_words.rds")
bi_words <- readRDS("./bi_words.rds")
tri_words <- readRDS("./tri_words.rds")
quad_words <- readRDS("./quad_words.rds")
quint_words <- readRDS("./quint_words.rds")

# identify matches

bigram <- function(input){
                num <- length(input)
                filter(bi_words,
                       word1==input[num]) %>%
                        add_count(word2, sort = TRUE) %>%
                        filter(row_number() == 1L) %>%
                        select(num_range("word",2)) %>%
                        as.character() -> out
                ifelse(out == "character(0)", "?" , return(out))
                        
}

trigram <- function(input){
        num <- length(input)
        filter(tri_words, 
               word1==input[num-1], 
               word2==input[num])  %>% 
                add_count(word3, sort = TRUE) %>%
                filter(row_number() == 1L) %>%
                select(num_range("word", 3)) %>%
                as.character() -> out
        ifelse(out=="character(0)", bigram(input), return(out))
}

quadgram <- function(input){
        num <- length(input)
        filter(quad_words, 
               word1==input[num-2], 
               word2==input[num-1], 
               word3==input[num])  %>% 
                add_count(word4, sort = TRUE) %>%
                filter(row_number() == 1L) %>%
                select(num_range("word", 4)) %>%
                as.character() -> out
        ifelse(out=="character(0)", trigram(input), return(out))
}
quintgram <- function(input){
        num <- length(input)
        filter(quint_words, 
               word1==input[num-3],
               word2==input[num-2], 
               word3==input[num-1], 
               word4==input[num])  %>% 
                top_n(1, n) %>%
                filter(row_number() == 1L) %>%
                select(num_range("word", 5)) %>%
                as.character() -> out
        ifelse(out=="character(0)", quadgram(input), return(out))
}

# main function 

ngrams <- function(input){
        # Create a dataframe
        input <- data.frame(text = input)
        # Clean the Inpput
        replace_reg <- "[^[:alpha:][:space:]]*"
        input <- input %>%
                mutate(text = str_replace_all(text, replace_reg, ""))
        # Find word count, separate words, lower case
        input_count <- str_count(input, boundary("word"))
        input_words <- unlist(str_split(input, boundary("word")))
        input_words <- tolower(input_words)
        # Call the matching functions
        out <- ifelse(input_count == 1, bigram(input_words), 
                      ifelse (input_count == 2, trigram(input_words), quadgram(input_words)))
        # Output
        return(out)
}

input <- "at the end"
ngrams(input)
