### chapter 14 Strings:
### chapter 14.1 Introduction:
#The focus of this chapter will be on regular expressions, or regexps for short. Regular expressions are useful because strings usually contain unstructured or semi-structured data, and regexps are a concise language for describing patterns in strings. When you first look at a regexp, you'll think a cat walked across your keyboard, but as your understanding improves they will soon start to make sense.

#The main package that will be used in this chapter is stringr.
library(tidyverse)
library(stringr)

### chapter 14.2 String basics:
#You can create strings with either single quotes or double quotes. Unlike other languages, there is no difference in behaviour. 
string1 <- "This is a string"
string2 <- 'if I want to include a "quote" inside a string, I use single quotes'

#To include a literal single or double quote in a string you can use \ to escape it:
double_quote <- "\"" 
single_quote <- '\''
#That means if you want to include a literal backslash, you'll need to double it up: "\\". 
#Beware that the printed representation of a strin is not the same as string itself, because the printed representation shows the escapes. To see the raw contents of the string, use writeLines():
x <- c("\"", "\\")
x
writeLines(x)

#There are a handful of other special characters. The most common are "\n", newline and "\t", tab , but you can see the complete list by requesting help on " : ?'"', or ?"'". You'll also somethimes see strings like "\u00b5", this is a way to writing non-English characters that works on all platforms:

x <- "\u00b5"
x

#Muliple strings are often stored in a character vector, which you can create with c():
c("one","two","three")

### chapter 14.2.1 String length:
#In this section the author will mostly focus on the string management functions found in the stringr package in place of using the built in base R functions. These funcitons have more intuitive names, and all start with str_. For example, str_length() tells you the number of characters in a string:
str_length(c("a", "R for data science", NA)) 

#The common str_prefix is particularly usefult if you use RStudio, because typing str_ will triger autocomplete, allowing you to see all stringr functions:

### 14.2.2 Combining strings:
#To combine two or more strings, use str_c():
str_c("x","y")
str_c("x","y","z")

#Use the sep argument to control how the new combined string will be separated:
str_c("x","y", sep = ", ")

#Like most other functions in R, missing values are contagious. If you want them to print as "NA", use str_replace_na():
x <- c("abc", NA)
str_c("|-", x, "-|")
str_c("|-", str_replace_na(x), "-|")

#As shown above, str_c() is vectorised, and it automatically recycles shorter vectors to the same length as the longest:
str_c("prefix-", c("a","b","c"), "-suffix")

#Objects of length 0 are silently dropped. This is particularly useful in conjunction with if:
name <- "Hadley"
time_of_day <-"morning"
birthday <- TRUE

str_c(
	"Good ", time_of_day, " ", name, 
	if (birthday)" and Happy Birthday",
	"."
)
#Interesting this string shows that if a character vector is zero in the str_c() function that character vector is simply ignored.

#To collapse a vector of strings into a single string, use collapse:
str_c(c("x","y","z"), collapse = ", ")

### Chapter 14.2.3 Subsetting strings:
#You can extract parts of a string using str_sub(). As well as the string, str_sub() takes start and end arguments which give the inclusive position of the substring:

x <- c("apple","banana", "pear")
str_sub(x, 1,3) #This function call tells the console to print back the first to third characters in each string.

str_sub(x, -3, -1)#Through inputting negative values, the console prints the 3rd character to the last character in each string.

#Note that str_sub() won't fail if the string is too short: it will just return as much as possible:
str_sub("a", 1, 5)

#You can also use the assignment form of str_sub() to modify strings:
str_sub(x, 1, 1) <- str_to_upper(str_sub(x, 1, 1))
x# Interesting this line changed the first character on all three strings in object x into upper case characters. Very interesting. The author used the str_to_lower() variation to change the same characters into lower case values. 

str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))
x#Now the first characters were reverted back to lower case characters.

###Chapter 14.2.4 Locales:
#Above I used str_to_lower() to change the text to lower case. You can also use str_to_upper() and str_to_title(). However, changing case is more complicated than it might at first appear because different languages have different rules for changing case. You can pick which set of rules to use by specifying a locale.
str_to_upper(c("i","I"))
str_to_upper(c("i","I"), locale= "tr")
#The locale is specified as a ISO 639 language code which is a two or three letter abbreviation. 

#Another important operation that's affected by the locale is sorting. The base R order() and sort() functions sort strings using the current locale. If you want robust behavior across different computers, you may want to use str_sort() and str_order() which take an additional locale argument:
x <- c("apple", "eggplant","banana")
str_sort(x, locale = "en")# locale is set to english.
str_sort(x, locale = "haw")# locale is set to hawaiian.

### chapter 14.2.5 Exercises:
#1.)
??paste()# paste converts its arguments to character strings, and concatenates them (separating them by the string given by sep). If the arguments are vectors, they are concatenated term-by-term to give a character vector result. Note that paste() coerces NA character, the character missing value, to "NA" which may seem undesirable.
??paste0()# this function is almost the same as paste() except that if a value is specified for collapse, the values in the result are then concatenated into a single string, with elements being separated by the value of collapse. 

??str_c()
#I believe that str_c() is the most similar to both paste() and paste0() in that you can combine multiple character strings and through the sep argument you can tell the console to place special breaks between strings or combine them all together through using the collapse argument. 
#The str_c() handles NA values through ignoring them entirely.

#2.)
??str_c()
# All I can say is the sep argument (if assigned in the function call) separates the mutliple strings through special characters (a comma, semi-colon, space, etc) while the collapse argument combines all the character strings into one and (if assigned) prints a special character differentiating the past independent strings.

#3.) 
me <- c("Rudy I'm going to eat you!!")
str_length(me)
str_sub(me, 14, 14)
me2 <- c("flea", "pear", "hear", "flare", "fire")
str_length(me2)
str_sub(me2, 2,3)# If the character strings have an even number of characters it's only logical to print the two middle characters in each string.

#4.)
??str_wrap()# this is a wrapper around stri_wrap which implements the knuth plass paragraph wrapping algorithm. This function will mainly be used for large passages that you want to convert into organized paragraphs. Will need to test this function out on one of my comments.
#Also I think this function will work perfectly with online text mining will need to look into a couple of books to see if this is the case.

string_me <- "All I can say is the sep argument (if assigned in the function call) separates the mutliple strings through special characters (a comma, semi-colon, space, etc) while the collapse argument combines all the character strings into one and (if assigned) prints a special character differentiating the past independent strings."
writeLines(string_me)
str_wrap(string_me, width = 80, indent = 0, exdent = 0))
#Still can't really comprehend what this function does will need to experiment a little more with its functionality to get the jist of it. 

#5.)
??str_trim()# This function is used to trim whitespace from start and end of string. 
#The opposite of this function is called str_pad().

#6.)
#Author's solution:
str_commasep <- function(x, sep = ", ", last = ", and "){
	if(length(x) >1){
		str_c(str_c(x[-length(x)], collapse = sep), x[length(x)], sep = last)
		} else {
			x
	}
}
str_commasep("")
str_commasep("a")
str_commasep(c("a","b"))
str_commasep(c("a","b","c"))

### chapter 14.3 Matching patterns with regular expressions:
# Regexps are a very terse language that allow you to describe patterns in strings. 
#To learn regular expressions, we'll use str_View() and str_view_all(). These functions  take a character vector and a regular expression, and show you how they match. We'll start with very simple regular expressions and then gradually get more and more complicated. 

### Chapter 14.3.1 Basic matches:
#The simplest patterns match exact strings:
x <- c("apple", "banana", "pear")
str_view(x, "an")# really need to str_view() allows me to view the strings on the internet as they will be displayed to visitors of a webpage.
#Interesting is function can only match patterns in strings.

#The next step up in complexity is ., which matches any character (except a newline):
str_view(x, ".a.")

#But if "." matches any character, how do you match the character "."? You need to use an escape to tell the regular expression you want to match it exactly, not use its special behaviour. Like strings, regexps use the backslash, \, to escape special behaviour. So to match an ., you need the regexp \. . Unfortunately this creates a problem. We use strings to represent regular expressions, and \ is also used as an escape symbol in strings. So to create the regular expression \. we need the string "\\.".

dot <- "\\."
writeLines(dot)
str_view(c("abc","a.c","bef"), "a\\.c")# through the assignment of "a\\.c" the console returned back the "a.c" character string.

#If \ is used as an escape character in regular expressions, how do you match a literal \? Well you need to escape it, creating the regular expression \\. To create the regular expression, you need to use a string, which also needs to excape \. That means to match a literal \ you need to write "\\\\" --- you need four backslashes to match one.

x <- "a\\b"
writeLines(x)
str_view(x, "\\\\")

#In this book, I'll write regular expression as \. and strings that represent the regular expression as "\\.".

### chapter 14.3.1.1 Exercises:
#1.)
x <- "a\\b"
writeLines(x)
str_view(x, "\\\\") #Interesting if you only type in one \ or even three \\\ the console still believes that there should be more to the command. Hence all code that has less than four backslashes is instantly flagged as being incomplete. Will need to look into this behavior more. 

#When playing with this little scenerio more I found that two escape characters within the str_view() function call results in an error message, while one and three escape characters makes the console believe the string is incomplete. 

#2.)
x <- "\"\'\\ ?"
writeLines(x)
str_view(x, "\"\'\\\\ \\?")# Perfect this is the proper matching sequence for this particular character string.

#3.)
x <- ".bee.bee.bee"
writeLines(x)
str_view(x, "\..\..\..")
# I can't really get this line of code to work with the provided regular expression. Will need to go back to this exercise later on through my studies. 

#According to the author:
#It will match any patterns that are a dot followed by any character, repeated three times.

### chapter 14.3.2 Anchors:
#By default, regular expressions will match any part of a string. It's often useful to anchor the regular expression so that it matches from the start or end of the string. YOu can use:
	# ^ to match the start of the string.
	#$ to match the end of the string.
	
x <- c("apple", "banana", "pear")
str_view(x, "^a")# as the book explaination said the first letter within the three object character string ("apple") was matched by this regulat expression call. 
str_view(x, "r$")# Now I understand the character needs to be written before the regular expression $. Will need to remember this little detail. 

#To force the regular expression to only match a complete string, anchor it with both ^ and $.
x <- c("apple pie", "apple", "apple cake")
str_view(x, "apple")# As suspected every string with the word apple was matched instantly through this function call.
str_view(x, "^apple$")# through this call you're telling the function to look for a character string that starts with apple and ends with apple. This means that "apple pie" and "apple cake" will be filtered out of the match.
str_view(x, "cake$")

#You can also match the boundary between words with \b. I don't often use this in R, but I will sometimes use it when I'm doing a search in RStudio when I want to find the name of the function that's a component of other functions. For example, I'll search for \bsum\b to avoid matching summarise, summary, rowsum and so on.

### chapter 14.3.2.1 Exercises:
#1.)
x <- "$^$"
str_view(x, "^\\$\\^\\$$")
# So all you need to do for the str_view() function call to recognize special characters is to encompasses the $ and ^ symbols with double backslashes. This is very interesting. 

#2.)
stringr::words
str_view(stringr::words, "^y.x$")# Interesting, it seems that I haven't thought of how to match words with their last character and first character yet. Also I'll need to look up how you can manipulate this matching function through carrying out character count. 
head(stringr::words)
??str_view()
x <- c("yix", "fix", "mix", "fish", "yax", "yaax")
str_view(x, "^y.x$")# Cool I actually stumbled upon the right answer. It seems that you can use the . symbol to separate the beginning character and the ending character of the regular expression. Will need to experiment if this regular expression is counting the number of characters as well.
str_view(x, "^y.x$")# Sweet the . symbol illustrates the number of characters the regular expression will be searching for as well. Very cool.
str_view(stringr::words, "^y.x$", match = TRUE)# there are not matches within the dataset stringr::words.

### chapter 14.3.3 Character classes and alternatives:
#There are a number of special patterns that match more than one character You've already seen ., which matches any character apart from a newline. There are four other useful tools:
	# \d: matches any digit
	#\s: matches any whitespace (space, tab, newline).
	# [abc]: matches a, b, or c
	# [^abc]: matches anything except a, b, or c.
	
# Remember, to create a regular expression containing \d or \s, you'll need to excape the \ for the string, so you'll type "\\d" and "\\s".
# you can use alternation to pick between one or more alternative patterns. For example, abc|d..f will match either "abc" or deaf. Note that the precedence for | is low, so that abc|xyz matches abc or xyz not abcyz or abxyz. Like with mathematical expressions, if precedence ever gets confusing, use parentheses to make it clear what you want.
str_view(c("grey","gray"), "gr(e|a)y")
str_view(c("grey","gray"), "gr(e|a)y")

### chapter 14.3.3.1 Exercises:
#1.)
flea <- c("ished", "pissed", "missed", "egged", "begged", "eeed")
str_view(flea, "^[aeiouy].[^aeiouy].ed$", match = TRUE)# I can't really get this line of code to work. Will need to see what regular expression the author used to answer this question. 
# Now I understand, the author wants me to create a series of regular expressions that fullfill each of the four criteria:
 
#a.
str_view(stringr::words, "^[aeiou]", match = TRUE)

#b.
str_view(stringr::words, "^[^aeiou]+$", match = TRUE)# this is the solution written by Wickham. In its explaination he said that the syntax +$ will be explained in the next chapter. From what I can see though is that without the modification of + before the ending syntax $ the console will only be able to match character strings with only one consonant in their structures.

#c.
str_view(stringr::words, "ed$", match = TRUE)
#author solution:
str_view(stringr::words, "^ed$|[^e]ed$", match = TRUE)# Now I see what I did wrong. The author wanted me to create a regular expression that would filter out all words that end with "eed" and display only the words the end with "ed". Will need to keep this solution in mind. Didn't know that you could use the [^] for other characters.

#d. 
str_view(stringr::words, "(ing|ise)$", match = TRUE)

#2.)
str_view(stringr::words, "^cie", match = TRUE)
str_view(stringr::words, "^c[aeiou][aeiou]", match = TRUE)
str_view(stringr::words, "^.ie", match = TRUE)
# this rule is correct according to the provided dataset stringr::words.

#author's solution:
str_view(stringr::words, "(cei|[^c]ie)", match = TRUE)
str_view(stringr::words, "(cie|[^c]ei)", match = TRUE)
# I messed up the this solution as well. I got overly fixated on words that start with c that I ignored the instances that c can occur within a word and still have an i before an e. As illustrated by the words society and science.

#3.)
str_view(stringr::words, "q(u|[^u])", match = TRUE)
str_view(stringr::words, "q[^u]", match = TRUE)
# With this dataset, it's safe to assume that q always comes befor u. Or rather a q is always matched with a u.

#4.)
str_view(stringr::words, "(our|or)$", match = TRUE) # I have to admit that this algorithm is a little imperfect. But even with that said, it had a 4 out of 6 success rate. 

#5.)
telephone <- c("509-720-4080", "509701-0149", "509-7011806")
str_view(telephone, "\\d\\d\\d-\\d\\d\\d-\\d\\d\\d\\d")# this regular expression matches the all telephone numbers that are written in the United states style. This solution is mostly copied from the author's source code. 

### chapter 14.3.4 Repetition:
#The next step up in power involves controlling how many times a pattern matches:
	# ?: 0 or 1
	# +: 1 or more
	# *: 0 or more
	
x <- "1888 is the longest year in Roman numberals: MDCCCLXXXVIII"
str_view(x, "CC?")
str_view(x, "CC+")
str_view(x, 'C[LX]+')

#Note that the precedence of these operators is high, so you can write: colou?r to match either American or British spellings. That means most uses will need parentheses, like bana(na)+.

#You can also specify the number of matches precisely:
	# {n}: exactly n
	# {n,}: n or more
	#{,m}: at most m 
	#{n,m}: between n and m 
	
str_view(x, "C{2,}")
str_view(x, "C{2}")
str_view(x, "C{2,3}")
str_view(x, 'C[LX]+?')

### chapter 14.3.4.1 Exercises:
#1.)
x <- "1888 is the longest year in Roman numberals: MDCCCLXXXVIII"
str_view(x, "X+")
str_view(x, 'X{1,}')
# The X+ equivalent when using the {} syntax is X{1,} or X{2,}

str_view(x, "M?") 
str_view(x, 'V{,1}')# I can't really get this line of code to work but according to the author the syntax 'V{,1}' should actually work as the perfect equivalent.

str_view(x, "XX*")
str_view(x, 'X{2,3}')

#2.)
#a.
x <- "...."
x_flea <- "Toyota MR2"
str_view(x, "^.*$")
str_view(x_flea, "^.*$")#The author was right this regular expression can be used for every character string since the beginning ^. illustrates that it begins with a character that occurs zero or more times.

#b.
x_2 <- c("{masterofpuppets}", "the big short")

str_view(x_2, "\\{.+\\}")# this matches every character that's enclosed by brackets.

#c.
x_3 <- c("509-720-4080", "4000-30-20")
str_view(x_3, "\\d{4}-\\d{2}-\\d{2}")# Interestingly the author forgot to double up the backslashes. This regular expression can be used to find telephone numbers from a particular country.

#d.
x_4 <- "\\\\\\\\"
str_view(x_4, "\\\\{4}")
#most likely this regular expression is used to find expressions with four backslashes.

#3.)
#a.
str_view(stringr::words, "^[^aeiou]{3}", match = TRUE)# Cool I think this regular expression combination is the solution. The returned words seems to match up perfectly with the question's prompt.

#b.
str_view(stringr::words, "[aeiou]{3,}", match = TRUE)

#The longer way without the bracket syntax:
str_view(stringr::words, "[aeiou][aeiou][aeiou]+", match = TRUE)

#c
str_view(stringr::words, "([aeiou][^aeiou]){2,}", match = TRUE)# It's important to kepp in mind that just like a mathematical formula if you want a pairing regular expression to repeat itself put parentheses around it.

### chapter 14.3.5 Grouping and backreferences:
#Earlier, you learned about parentheses as a way to disambiguate complex expressions. They also define "groups" that you can refer to with backreferences, like \1, \2, etc. For example, the following regular expression finds all fruits that have a repeating pair of letters.

str_view(fruit, "(..)\\1", match = TRUE)

### chapter 14.3.5.1 Exercises:
#1.)
#Author's solutions:
#a.
#(.)\1\1: the same character appearing three times in a row

#b.
#experiment:
song <- c("abba", "opennepo")
str_view(song, "(.)(.)\\2\\1")
#A pair of characters followed by the same pair of characters in reversed order.

#c. 
characters <- c("baba", "pepepe", "fleaflea", "me")
str_view(characters, "(..)\\1")# Knew it. This regular expression is for two characters that repeat themselves once.

#d.
#"(.).\\1.\\1": A character followed by any character, the original character, any other character, the original character again.

#e.
#"(.)(.)(.).*\\3\\2\\1": Three characters followed by zero or more characters of any kind followed by the same three characters but in reverse order.

#2.)
#a.
str_view(stringr::words, "^(.).*\\1$", match = TRUE)# Now I understand what I was doing wrong. I had to tell the console that I was looking for a word that had a particular length. Through using the syntax .* you're telling the console to look for a word of zero to more letters in length.

#b.
str_view(stringr::words, "^(..).*\\1$", match = TRUE)# cool the last regular expression actually worked for this problem. All I had to do is change the ^(.) syntax into ^(..).

#c.
str_view(stringr::words, "(.).*\\1.*\\1+", match = TRUE)# I think this is actually the right regular expression. Will need to check with the author's solutions. 

#author's solution:
#"(.).*\\1.*\\1": cool he has the same solution as me.

### chapter 14.4 Tools:
#Now that you've learned the basics of regular expressions, it's time to learn how to apply them to real problems. In this section you'll learn a wide array of stringr functions that let you:
	#Determine which strings match a pattern.
	#Find the positions of matches.
	#Extract the conten of matches.
	#Replace matches with new values.
	#Split the string based on a match.
	
#Instead of creating one complex regular expression, it's often easier to write a series of simpler regexps. If you get stuck trying to create a single regexp that solves your problem, take a step back and think if you could break the problem down into smaller pieces, solving each challenge before moving onto the next one.

### chapter 14.4.1 Detect Matches:
#To determine if a character vector matches a pattern, use str_detect(). It returns a logical vector the same length as the input.
#This function sounds very much like which() except for character vectors.
x <- c("apple","banana","pear")
str_detect(x, "e")

#Remember that when you use a logical vector in a numeric context, FALSE becomes 0 and true becomes 1. That makes sum() and mean() useful if you want to answer questions about matches across a larger vector:
sum(str_detect(words, "^t"))# This command counts the number of words in the words dataset that start with t.
mean(str_detect(words, "[aeiou]$"))# This line asks for the proportion of common words the end with a vowel.

#When you have complex logical conditions it's often easier to combine multiple str_detect() calls with logical operators, rather than trying to create a single regular expression. 

#The following example are two ways to find all words that don't contain any vowels:

no_vowels_1 <- !str_detect(words, "[aeiou]")
no_vowels_2 <- str_detect(words, "^[^aeiou]+$")
identical(no_vowels_1, no_vowels_2)

#the results are identical, but I think the first approach is significantly easier to understand. If your regular expression gets overly complicated, try breaking it up into smaller pieces, giving each piece a name, and then combining the pieces with logical operations.

#A common use of str_detect() is to select the elements that match a pattern. You can do this with logical subsetting, or the convenient str_subset() wrapper :
words[str_detect(words, "x$")]# This is used the as way as which().
str_subset(words, "x$")
# Both methods have the same results.

df <- tibble(
	word = words,
	i = seq_along(word)
)
df %>%
	filter(str_detect(words, "x$"))
# Will need to look into the documentation of seq_along().

# A variatio on str_detect() is str_count(): rather than a simple yes or no, it tells you how many matches there are in a string:
x <- c("apple","banana","pear")
str_count(x, "a")

#This command results in the average number of vowels that are used for each word in the words dataset.
mean(str_count(words, "[aeiou]"))

#It's natural to use str_count() with mutate():
df %>%
	mutate(
		vowels = str_count(word, "[aeiou]"),
		consonants = str_count(word, "[^aeiou]")
)

#Note that matches never overlap. For example, in "abababa", how many times will the pattern "aba" match? Regular expressions say two, not three:
str_count("abababa", "aba")
str_view_all("abababa", "aba")

#Note the use of str_view_all(). As you'll shortly learn, many stringr functions come in pairs: one function works with a single match, and the other works with all matches. The second function will have the suffix _all.

### chapter 14.4.2 Exercises:
#1.)
#a.
#Using the regular expression and str_view() function:
x <- c("xxx","xeo","mex","xme", "xmas", "flex")
str_view(x, "^x.*x$", match = TRUE)
str_view(words, "^x | x$", match = TRUE)# Interesting it seems that str_view() doesn't work with this regular expression. Will need to look into why this is the case.
str_view(x, "^x", match = TRUE)
str_view(x, "x$", match = TRUE)
# It seems that I can't find the right regular express that can find a word that begins with an x or ends with an x. 

#Using two regular expression and str_detect():
words[str_detect(words, "^x|x$")]

start_with <- str_detect(words, "^x")
end_with <- str_detect(words, "x$")
words[end_with|start_with]# Cool solution. Most of this code was from the author's solutions.

#b.
words[str_detect(words, "^[aeiou].*[^aeiou]$")]

#Using two regular expressions and str_detect()
start_with <- str_detect(words, "^[aeiou]")
end_with <- str_detect(words, "[^aeiou]$")
words[start_with|end_with]
# this line of code doesn't work with the question prompt since the author wants me to find the words the start with a vowel and end with a consenent.
# In this case, splitting the regular expression into two phrases will be harder than just simply creating an all encompassing regular expression.

# the author's solution for this problem:
start_with <- str_detect(words, "^[aeiou]")
end_with <- str_detect(words, "[^aeiou]$")
words[start_with&end_with]# In other words, all I had to do was change the or syntax (|) into an and (&).

#c.
#The author's solution:
pattern <-
	cross(rerun(5, c("a","e","i","o","u")),
	.filter = function(...){
		x <- as.character(unlist(list(...)))
		length(x) != length(unique(x))
	}) %>%
	map_chr(~str_c(unlist(.x), collapse = ".*")) %>%
	str_c(collapse = "|")
# Interestingly I had to use cross in place of cross_n() because of a warning message saying that cross_n() is depreciated.

str_subset(words, pattern)

words[str_detect(words, "a") &
		str_detect(words, "e") &
		str_detect(words, "i") &
		str_detect(words, "o") &
		str_detect(words, "u")]
# Interesting solution will need to learn more about str_detect() and the stringr tools functionality in order to make this thought process second nature.

### chapter 14.4.3 Extract matches:
# To extract the actual text of a match, use str_extract(). To show that off, we're going to need more complicated examples. For this next couple of examples the author will use the dataset called the havard sentences, which were designed to test VIOP systems. You can access this dataset through the call stringr::sentences:
length(sentences)
head(sentences)

#Imageine we want to find all sentences that contain a colour. We first create a vector of color names, and then turn it into a single regular expression:
colors <- c("red","orange","yellow","green","blue","purple")
color_match <- str_c(colors, collapse = "|")
color_match
#Now we can select the sentences that contain a color, and then extract the color to figure out which one it is:

has_color <- str_subset(sentences, color_match)
matches <- str_extract(has_color, color_match)
head(matches)

#Note that str_extract() only extracts the first match. We can see that most easily by first selecting all the sentences that have more than 1 match.
more <- sentences[str_count(sentences, color_match) > 1]
str_view_all(more, color_match)

# This is a common pattern for stringr functions, because working with a single match allows yo to use simpler data structures. To get all matches, use str_extract_all(). It returns a list:
str_extract_all(more, color_match)

# If you use simplify = TRUE, str_extract_all() will return a matrix with short matches expanded to the same length as the longest.

x <- c("a","a b","a b c")
str_extract_all(x, "[a-z]", simplify = TRUE)

### chapter 14.4.3.1 Exercise:
#1.)
colors <- c("\\bred|orange|yellow|green|blue|purple\\b")
has_color <- str_subset(sentences, colors)
matches <- str_extract(has_color, colors)
more <-sentences[str_count(sentences, colors) > 1]
str_view_all(more, colors)
str_extract_all(more, colors)
str_extract_all(more, colors, simplify = TRUE)

#From what I can see these code commands actually worked. With that said though, I believe that the colors regular expression should have been written as "\\b(red|orange|yellow|green|blue|purple)\\b". Interesting though that the \\b syntax can be used to illustrate how the regular expression will be matched (as either a component within a phrase or a phrase by itself). Will need to see if this syntax was introduced during the earlier sections.		
#Interesting it seems that this command was not introduced at all during the preceeding sections.

#2.)
#a.
first_word <- str_subset(sentences, "^[A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z]*\\b")
matches <- str_extract(sentences, "^[A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Za|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z]*\\b")

#Little experiment:
matches <- str_extract(sentences, "^[A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z].*\\w") 
#In all honesty I don't know if this code actually worked, but I have a feeling that there should be a litte more to this question or rather the regex that I need to create.

#According to the author, you need to tell R what a word is instead of illustrating the different variations of upper case letters. Like what my solution entailed. The main problem with my solution is that the console is only printing the first letter of each sentence and not the first word. Will need to test out different regular expressions to see how I can fix this problem.

#author's solution:
str_extract(sentences, "[a-zA-X]+") %>% head()

#Nead after looking over the author's solution I found that the only thing I had to do was illustrate to the console the lowercase letters within each word. Very interesting solution.

#b.
str_extract(sentences, "[a-z]+ing") 
more_ing <- sentences[str_count(sentences, "[a+z]+ing") >= 1]
str_extract_all(more_ing, "[a-z]+ing")# Interesting according to the result of this command, the sentences dataset only has one ing word per sentence. Will need to see if this line of code is what the author had in mind. 

#Experiment: using the idea with the color example in order to clean up my results.
has_ing <- str_subset(sentences, "[a-z]+ing")
matches <- str_extract(has_ing, "[a-z]+ing")
matches# Perfect this really does clean everything up.
str_view_all(has_ing, "[a-z]+ing")
#Now I see my code messed up on a couple of these sentences. Narrowing down words that only have ing in the middle of their structures. Will need to thing of a way to narrow done that matches a little more. perhaps adding a \\b at the end of the regular expression will fix this problem.

has_ing <- str_subset(sentences, "[a-z]+ing\\b")
matches <- str_extract(has_ing, "[a-z]+ing\\b")
matches
str_view_all(has_ing, "[a-z]+ing\\b")# this modification worked perfectly. 

#c.
plural <- str_subset(sentences, "[a-z]+s\\b") %>% str_extract("[a-z]+s\\b")# The main problem I can see with this regular expression is that words that aren't plural variations are included within the resulting list. Will need to find a way to narrow down the search.
str_view_all(sentences, "[a-z]+s\\b")

#author's solution:
unique(unlist(str_extract_all(sentences, "\\b[A-Za-z]{3,}s\\b"))) %>% head()
#Pretty cool solution.

### chapter 14.4.4 Grouped matches:
#Earlier in this chapter we talked about the use of parentheses for clarifyng precedence and for backreferences when matching. You can alse use parentheses to extract parts of a complex match. For example, imagine we want to extract nouns from the sentences. As a heuristic, we'll look for any word that comes after "a" or "the". Defining a "word" in a regular expression is a little tricky, so here I use a simple approximation: sequence of at least one character that isn't a space.

noun <- "(a|the) ([^ ]+)"
has_noun <- sentences %>%
	str_subset(noun) %>%
	head(10)
has_noun %>%
	str_extract(noun)
	
#str_extract() gives us the complete match; str_match() gives each individual component. Instead of a character vector, it returns a matrix, with one column for the complete match followed by one column for each group.
has_noun %>%
	str_match(noun)
	
#(unsurprisingly, our heuristic for detecting nouns is poor, and alos picks up adjectives like smooth and parked).

#If your data is in a tibble, it's often easier to use tidy::extract(). It works like str_match(), but requires you to name the matches, which are then placed in new columns.

tibble( sentence = sentences) %>%
	tidyr::extract(
		sentence, c("article", "noun"), "(a|the) ([^ ]+)", remove = FALSE
)

#Like str_extract(), if you want all matches for each string, you'll need str_match_all().
tibble( sentence = sentences) %>%
	tidyr::extract(
		sentence, c("article", "noun"), "(a|the) ([^ ]+)", remove = TRUE
)# Interesting the remove = TRUE command tells the console to remove the original charcter vector that contained the matched components (which in this case are the article and noun).

### chapter 10.4.4.1 Exercises:
#1.)
any_number <- "(one|two|three|four|five|six|seven|eight|nine|ten) ([^ ]+)"# Part of this idea was from the author's solutions for this particular problem. 
has_number <- sentences %>%
	str_subset(any_number) %>%
	head(10)
has_number %>%
	str_extract(any_number)
has_number %>%
	str_match(any_number)
	
#original soltution attempt:
any_number_b <- "(\\d+) ([^ ]+)"
has_number <- sentences %>%
	str_subset(any_number_b) %>%
	head(10)
has_number %>%
	str_extract(any_number_b)
#Now I understand, this regular expression ("(\\d+) ([^ ]+)") failed to return values because the numbers were written within every sentence as character strings (or rather words) in place of numeric characters. Hence this regular expression would have been perfect if some of the numbers were written as numeric values in the sentences dataset. 

#2.)
contractions <- "([A-Za-z]+)'([a-z]+)"
has_contraction <- sentences %>%
	str_subset(contractions) 
	
has_contraction %>%
	str_extract(contractions)
has_contraction %>%
	str_match(contractions)
	
#author's solution:
contraction <- "([A-Za-z]+)'([a-z]+)"
sentences %>%
	`[` (str_detect(sentences, contraction)) %>% str_extract(contraction)
	
### 14.4.5 Replacing matches:
#str_replace() and str_replace_all() allow you to replace matches with new strings. The simplest use is to replace a pattern with a fixed string:
x <- c("apple","pear","banana")
str_replace(x, "[aeiou]", "-")# This function only allows you to replace the character that conforms to the first match of the regular expression.
str_replace_all(x, "[aeiou]", "-")# This function replaces all characters that match with the regular expression.

#With str_replace_all() you can perform multiple replacements by supplying a named vector:
x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))

#Instead of replacing with a fixed string you can use backreferences to insert components of the match. In the following code, I flip the order of the second and third words.
sentences %>%
	str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2") %>%
	head(10)
	
### chapter 14.4.5.1 Exercises:
#1.)
backslashes <- c("\\user\\mason\\place\\me", "\\people\\eat\\my\\good\\pickle")
str_replace(backslashes, "\\\\", "/")
str_replace_all(backslashes, "\\\\", "/")

#2.)
??str_to_lower()
sentences %>%
	str_replace("^[A-Z]",) %>%
	head(10)
#Saddly I can't really think of a solution for this problem will need to go back to this problem later in my studies.

#Experiment:
me_flea <- sentences[str_replace(sentences, "^A", "a") |
		str_replace(sentences, "^B", "b") |
		str_replace(sentences, "^C", "c") |
		str_replace(sentences, "^T","t") |
		str_replace(sentences, "^G", "g") |
		str_replace(sentences, "^I", "i") |
		str_replace(sentences, "^R","r") |
		str_replace(sentences, "^F", "f")]# Seems that this function didn't work properly and also this solution seems overly complicated. Again, I will need to see where the author keeps his solution for this problem.
		
#3.)
sentences %>%
	str_replace("([^ ]+) .+ ([^ ]+)", "\\1 \\2")
	
sentences %>%
	str_replace("")
#In all honesty I can't find the solutions for this section of chapter 14 and I can't really think of any good ideas about how to answer these question. Will need to go back to these question later on.

### chapter 14.4.6 splitting:
#use str_split() to split a string up into pieces. For example, we could split sentences into words:
sentences %>%
	head(5) %>%
	str_split(" ")
	
#Because each component might contain a different number of pieces, this returns a list. If you're working with a length-1 vector, the easiest thing is to just extract the first element of the list.
"a|b|c|d" %>%
	str_split("\\|") %>%
	.[[1]]
	
#Otherwise, like the other stringr functions that return a list, you can use simplify = TRUE to return a matrix.
sentences %>%
	head(5) %>%
	str_split(" ", simplify = TRUE)
	
#You can also request a maximum number of pieces:
fields <- c("name: hadley", "country: NZ", "Age: 35")
fields %>% str_split(":", n = 2, simplify = TRUE)

#Instead of splitting up strings by patterns, you can also split up by character, line, sentence and word boundary()s.
x <- "This is a sentence. This is another sentence."
str_view_all(x, boundary("word"))
str_split(x, " ")[[1]]
str_split(x, boundary("word"))[[1]]

### chapter 14.4.6.1 Exercises:
#1.)
string_me <- "apple, pears, and bananas"
str_split(string_me, " ")[[1]]

#2.)
str_split(string_me, boundary("word"))[[1]]
#splitting by boundary("word") splits on punctionuation and not just whitespace.

#3.)
str_splite(string_me, "")[[1]]
#author's solution:
str_split("ab. cd|agt", "")[[1]]
#It splits the string into individual characters.

### chapter 14.4.7 Find matches:
#str_locate() and str_locate_all() give you the starting and ending of each match. These are particularly useful when none of the other functions does exactly what you want. You can use str_locate() to find the matching pattern, str_sub() to extract and modify them.

###chapter 14.5 other types of pattern:
#when you use a pattern that's a string, it's automatically wrapped into a call to regex()
str_view(fruit, "nana") #This is short hand for:
str_view(fruit, regex("nana"))

#You can use the other arguments of regex() to control details of the match:
	#ignore_case = TRUE allows characters to match either their uppercase or lowercase forms. This always uses the current locale.
bananas <- c("banana", "Banana", "BANANA")
str_view(bananas, "banana")
str_view(bananas, regex("banana", ignore_case = TRUE))
	#multiline = TRUE allows ^ and $ to match the start and end of each line rather than the start and end of the complete string.
x <- "Line 1\nLine 2\nLine 3"
str_extract_all(x, "^Line")[[1]]
str_extract_all(x, regex("^Line", multiline = TRUE))[[1]] 
	
	#comments = TRUE allows you to use comments and white space to make complex regular expressions more understandable. Space are ignored, as is everything after #. To match a literal space, you'll need to escape it: "\\".

	#dotall = TRUE allows . to match everything, including \n.
	
#There are three other functions you can use instead of regex():

	#fixed(): matches exactly the specified sequence of bytes. It ignores all special regular expressions and operates at a very low level. This allows you to avoid complex escaping and can be much faster than regular expressions. The following microbenchmark shows that it's about 3x faster for a simple example.
library("microbenchmark")
microbenchmark::microbenchmark(
	fixed = str_detect(sentences, fixed("the")),
	regex = str_detect(sentences, "the"),
	times = 20
)

	#coll(): compare strings using standard collation rules. This is useful for doing case insensitive matching. Note that coll() takes a locale parameter that controls which rules are used for comparing characters. Unfortunately different parts of the world use different rules.

#both fixed() and regex() have ignore_case arguments, but they do not allow you to pick the locale: they use the default locale. You can see what that is with the following code, more on stringi later.
stringi::stri_locale_info()

#the downside of coll() is speed; because the rules for recognising which characters are the same are complicated, coll() is relatively slow compared to regex() and fixed().

	#As you saw with str_split() you can use boundary() to match boundaries. You can also use it with the other functions:
x <- "This is a sentence"
str_view_all(x, boundary("word"))

### chapter 10.5.1 Exercises:
#1.)
str_subset(c("a\\b", "ab"), "\\\\")
str_subset(c("a\\b", "ab"), fixed("\\"))

#2.)
str_extract_all(sentences, boundary("word")) %>%
	unlist() %>%
	str_to_lower() %>%
	tibble() %>%
	set_names("words") %>%
	group_by(words) %>%
	count(sort = TRUE) %>%
	head(10)
	
###chapter 14.6 other uses of regular expresssions:
# there are two useful function in base R that also use regular expressions:
	#apropos() searches all objects available from the global environment. This is useful if you can't quite remember the name of the function.
apropos("replace")

	#dir() lists all the files in a directory. The pattern argument takes a regular expression and only returns file names that match the pattern. For example, you can find all the R markdown files in the current directory with:
head(dir(pattern = "\\.Rmd$"))

