library(tidyverse)
library(nycflights13)

not_cancelled <- flights %>% filter(!is.na(dep_delay), !is.na(arr_delay))
not_cancelled %>% group_by(year, month, day) %>% summarise(mean= mean(dep_delay))
#Interesting note, make sure to include the library() functions in the beginning of
#if you're planning on sharing your projects. But make sure to never 
#include install.packages() and setwd() because it can change a person's 
#settings.

3 == NA # Interesting the R studio code has flagged this syntax as being
# a potential problem. Really this is way more helpful than the base
# R program.

### Chapter 8.1 

