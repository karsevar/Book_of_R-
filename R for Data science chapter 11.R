### chapter 11 Data import:
### chapter 11.1 Introduction:
### chapter 11.1.1 Prerequisites:
#This chapter will focus on data importation through the readr package which is contained in the tidyverse package.
library(tidyverse)

### Chapter Getting Started:
#Most readr's functions are concerned with turning flat files into data frames:
#	read_csv() reads comma delimited files, read_csv2() reads semicolon separated files, read_tsv() reads tab delimited files and read_delim() reads in files with any delimiter.
#	read_fwf() reads fixed width files. YOu can specify fields either by their widths with fwf_widths() or their position with fwf_positions(). read_table() reads a common variation tixed width files where columns are separated by white space.
#	read_log() reads apache style log files. (but also check out wbreadr which is built on top of read_log() and provides many more helpful tools).

#These functions all have similar syntax: once you've masted one,you can use the others with ease. Not only are csv files one of the most common forms of data storage, but once you understand read_csv(), you can easily apply your knowledge to all the other functions in readr.

#The first argument to read_csv() is the most important: it's the path to the file to read.
heights <- read_csv("data/heights.csv")
#When you run read_csv() it prints out a column specification that gives the name and type of each column. YOu can also supply an inline csv file. this is useful for experimenting with readr and for creating reporducible examples to share with others.

read_csv("a, b, c
1,2,3
4,5,6") 
#In both cases read_csv() uses the first line of the data for the column names, which is a very common convention. There are two cases where you want to tweak this behavior. 
#	1. Sometimes there are a few lines of metadata at the top of the file. You can use skip = n to skip the first n lines; or use comment = "#" to drop all lines that start with #.
read_csv("The first line of metadata 
	The second line of metadata 
	x,y,z
	1,2,3", skip = 2)
#Through this command you told the console to skip the first two statements and print the x,y,z line as the column names and the 1,2,3 as the column contents. Very interesting will need to look into this function a little more.

read_csv("# A comment I want to skip
x,y,z
1,2,3", comment = "#")
# Interesting both of these commands do almost the same things except that this one tells the console to ignore any line that has the symbol "#" within it. 

#	2. The data might not have column names. You can use col_names = FALSE to tell read_csv() not to treat the first row as headings, and instead label them sequentially from x1 to xn. 
read_csv("1,2,3\n4,5,6", col_names = FALSE)
#("\n" is a convenient shortcut for adding a new line. You'll learn more about it and other types of string escape in string basics).
# In addition, it seems that the col_names argument is set to a default of x1 to xn (meaning that the column names, if not specified, are printed as x1, x2, x3, etc.).
read_csv("1,2,3\n4,5,6", col_names = c("x","y","z"))

#Another option that commonly needs tweaking is na: this specifies the value (or values) that are used to represent missing values in your file:
read_csv("a,b,c\n1,2,.", na = ".")
#This is all you need to know to read ~75 percent of CSV files that you'll encounter in practice. You can also easily adapt what you've learned to read tab separated files with read_tsv() and fixed width files with read_fwf(). 

### chapter 11.2.1 Compared to base R:
#If you have used R before, you might wonder why we're not using read.csv(). there are a few good reasons to favour readr functions over the base equivalents.
#	They are typically much faster than their base equivalents. Long running jobs have a progress bar, so you can see what's happening. If you're looking for raw speed, try data.table::fread(). It doesn't fit quite so well into the tidy verse, but it can be quite a bit faster.
#	They produce tibbles, they don't convert character vectors to facts, use row names, or munge the column names. These are common sources of frustration with the base R functions.
#	They are more reporducible. Base r functions inherit some behavior from your operating system and environment variables, so import code that works on your computer might not work on someone else's.

###chapter 11.2.2 Exercises:
#1.) 
# I believe that read_delim() is the best readr function to use in a situation where I have to read a file into the R console where the delimiting characters are |. Will need to test this out.
read_delim("a|b|c|d\ne|f|g|h", delim="|", col_names=FALSE)# Just as I suspected read_delim() was the right choice in this situation.

#2.) 
??read_csv()
??read_tsv()
# they both have the arguments:
#	delim, quote (single character used in quote strings), col_names (either true, false or a character vector of column names. If True, the first row of the input will be used as the column names, and will not be included in the data frame. If False, column names will be generated automatically:x1 to xn), col_types, locale, na (character vector of strings to use for missing values, Set this option to character() to indicate no missing values), quoted_na (should missing values inside quotes be treated as missing values or strings), n_max (Maximum number of records to read), guess_max, progress (Display a progress bar). 

#3.) 
??read_fwf()
# The most important arguments for this readr function are file ( of course), na (character vector of strings to use for missing values), comment (A string used to identify comments), n_max (the Maximum number of records to read), col_names, n (Number of lines the tokenizer will read to determine file structure), widths (width of each field). 

#4.) 
read_csv("x,y\n1,'a,b'")
??read_delim()
read_delim("x,y\n1,'a,b'", delim = ",", quote = "'")# Neat, modifying first the delim argument to "," and then the quote argument to "'" actually fixed the problem perfectly. 

#5.) 
read_csv("a,b\n1,2,3\n4,5,6")# most likely you have to either make the first column a little larger if you want the initial a,b statement to work as the column names or set the col_names argument to FALSE. Will test out the latter correction just for fun.
read_csv("a,b\n1,2,3\n4,5,6", col_names = FALSE)# Interesting the console still ignored the 3 and the 6 in this line of code because (most likely) it didn't fit into the tibble's dimensions. Will need to look into what the problem is. I believe that the only way to fix this problem is to rewrite the file argument as "a,b\n1,2\n3,4\n5,6".

read_csv("a,b,c\n1,2\n1,2,3,4")# the problem area is that the three columns don't have the same amount of rows

read_csv("a,b\n\"1")# I have no idea why for one there is an extra backslash after the escape command \n or why 1 is in quotion makes.

read_csv("a,b\n1,2\na,b") # Interestingly enough I don't see any problems in this line of code. Will need to confirm this with the author's solutions guide.

read_csv("a;b\n1;3")# there are two ways to fix this problem. One is to change the function call from a read_csv() to a read_csv2() which recognizes semicolons as delimiters. Two change the read_csv() function to read_delim() and set the delim argument to ";". 


### Chapter 11.3 Parsing a vector:
# Before we get into the details of how readr reads files from disk, we need to take a little detour to talk about the parse_*() functions. These functions take a character vector and return a more specialised vector like a logical, integer, or date:
str(parse_logical(c("TRUE","FALSE","NA")))
str(parse_integer(c("1","2","3")))
str(parse_date(c("2010-01-01","1979-10-14")))#This function will most likely become very important once I move onto making my own data sets or rather start collecting my own data. 

#Like all functions in the tidyverse, the parse_*() functions are uniform: the first argument is a character vector parse, and the na argument specifies which strings should be treated as missing. 
parse_integer(c("1","231",".","456"), na= ".")

#If parsing fails, you'll get a warning:
x <- parse_integer(c("123","345","abc","123.45"))
#Since in this case the "abc" is a character string and the "123.45" value is a floating point number the parse_integer() function did not work. The resulting output was the last two values being assessed as NA values.

#If there are many parsing failures, you'l need to use problems() to get the complete set. This returns a tibble, which you can then manipulate with dplyr.
problems(x)

#Using parsers is mostly a matter of understanding what's available and how they deal with different types of inputs (again much like the read_csv() series and section ago). There are eight important parsers:
#	parse_logical() and parse_integer() parse logicals and integers respectively. There's basically nothing that can go wrong with these parsers so I won't describe them here further. 
#	parse_double() is a strict numeric parser, and parse_number() is a flexible numeric parser. These are more complicated than you might expect because different parts of the world write number in different ways. 
#	parse_character() seems so simple that it shouldn't be necessary. But one complication makes it quite important: character encodings. 
#	parse_factor() create factors, the data structure that R uses to represent categorical variables with fixed and known values.
#	parse_datetime(), parse_date(), and parse_time() allow you to parse various date and time specifications. Can be fairly complicated due to the large amount of ways researchers can write (or rather document) dates in their data sets.

### chapter 11.3.1 Numbers:
#It seems like it should be straightforward to parse a number, but three problems make it tricky:
#	1. People write numbers differently in different parts of the world. For example, some countries use . in between the integer and the fractional parts of a real number while others use .
#	2. Numbers are often surrounded by other characters that provide some context, like $1000 or 10%.
#	3. Numbers often contain grouping characters to make them easier to read like 100,000, these characters are documented differently in other parts of the world. 

#To address the problem of decimal marker between fractional and whole numbers, readr has the notion of local. When parsing numbers, the most important option is the character you use for the decimal mark. You can override the default value of . by creating a new locale and setting the decimal_mark argument.
parse_double("1.23")
parse_double("1,23", locale = locale(decimal_mark=","))
#readr's default locale is us centric, because generally R is us-centric. An alternative approach would be to try and guess the defaults from your operating system. This is hard to do well, and, more importantly, makes your code fragile.

#parse_number() addresses the problem of special characters at the beginning or the end of a numeric value. This is particularly useful for currencies and percentages, but also works to extract numbers embedded in text.
parse_number("$100")
parse_number("20%")
parse_number("It cost $123.45")
#Interesting without having to input any additional arguments the parse_number() function automatically ignores all special characters at the beginning or the end of numeric values. 

#As for the problem with grouping characters like the comas in the value 200,000; the combination of parse_number() and the locale as parse_number() will ignore the grouping mark:
parse_number("$123,456,789")# Interestingly the value was not converted into scientific notation which was the case in the book. Must be a discrepency between base R and R studio.
parse_number("$123.456.789", locale = locale(grouping_mark = ".")) 
parse_number("123'456'789", locale = locale(grouping_mark = "'"))

### chapter 11.3.2 Strings:
# In R, we can get at the underlying representation of a string using charToRaw() 
charToRaw("Hadley")
# Each hexadecimal number represents a byte of information: 48 is H, 61 is a, and so on. The mapping from hexadecimal number to character is called the encoding, and in this case the encoding is called ASCII.
#readr uses UTF-8 everywhere: it assumes your data is UTF-8 encoded when you read it, and always uses it when writing.This is a good default, but will fail for data produced by older systems that don't understand UTF-8. If this happens to you, your strings will look weird when you print them.

X1 <- "El Ni\xf1o was particularly bad this year"
X2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"
parse_character(X1, locale = locale(encoding = "Latin1"))# No way the spanish n (which is the same for the word manana in spanish) can be written in the Latin1 code of \xf.
parse_character(X2, locale = locale(encoding = "Shift-JIS"))# this code spelled out hello in japanese through the "Shift-JIS" encoding method. Very interesting.

# How do you find the correct encoding? If you're lucky, it'll be included somewhere in the data documentation. Unfortunately, that's rarely the case, so readr provides guess_encoding() to help you figure it out. 
guess_encoding(charToRaw(X1))
guess_encoding(charToRaw(X2))
#The first argument to guess_encoding() can either be a path to a file, or, as in this case, a raw vector (useful if the strings are already in R). 

### chapter 11.3.3 Factors:
# R uses factor to represent categorical variables that have a known set of possible values. Give parse_factor() a vector of known levels to generate a warning whenever an unexpected value is present.
fruit <- c("apple","banana")
parse_factor(c("apple","banana","bananana"), levels = fruit)
#But if you have many problematic entries, it's often easier to leave as character vectors and then use the tools you'll learn about in strings and factors to clean them up.

### chapter 11.3.4 Dates, date-times, and times:
#You pick between three parsers depending on whether you want a date (the number of days since 1970-01-01), a date-time (the number of seconds since midnight 1970-01-01), or a time (the number of seconds since midnight). When called without any additional arguments:
#	parse_datetime() expects a ISO8601 date_time. ISO8601 is an international standard in which the components of a date are organized from biggest to smallest: year, month, day, hour, minute, second.
parse_datetime("2010-10-01T2010")
parse_datetime("20101001")

#	parse_date() expects a four digit year, a - or /, the month, a - or /, then the day:
parse_date("2010-10-01")

#	parse_time() expects the hour, :, minutes, optional : and seconds, and an optional am/pm specifier:
library(hms)
parse_time("01:10 am")
parse_time("20:10:01")
#the author was forced to use the time parse_*() function in place of the base R alternative because base R doesn't have a function that can compete with hms's functionality.

#You can supply your own date-time format, built up of the following places:
#Year:
# %Y (4 digits)
# %y (2 digits)

# Month:
# %m ( two digits)
# %b (abbreviated name, like jan).
# %B (full name, "january")

# Day:
# %d (two digits)
# %e (optional leading space)

# time:
# %H 0-23 hour
# %I (0-12, must be used with %p)
# %p (pm and am indicator)
# %M (minutes)
# %S (integer seconds)
# %OS (real time)
# %Z (time zone, make sure to add no abbreviations).
# %z (as offset from UTC)

# Non-digit:
# %. (skips one non digit character)
# %* (skips any number of non-digits)

parse_date("01/02/15", "%m/%d/%y")
parse_date("01/02/15", "%d/%m/%y")
parse_date("01/02/15", "%y/%m/%d")
# If you're using %b or %B with non-English month names, you'll need to set the lang argument to locale(). See the list of built-in languages in date_names_langs().

parse_date("1 janvier 2015","%d %B %Y", locale = locale("fr"))

### chapter 11.3.5 Exercises:
#1.) 
??locale()
# A locale object tries to capture all the defaults that can vary between countries. You set the locale in once, and the details are automatically passed on down to the columns parsers.
# The most important arguments in this function are:
#	date_names (character representations of day and month name).
#	date_format, time_format (Default date and time formats)
#	decimal_mark, grouping_mark (symbols used to indicate the decimal place, and to chunk larger numbers. Decimal mark can only be , or ..)
#	tz (Default tz. this is used both for input (if the time zone isn't present in individual strings), and for output (to control the default display). The default is to use UTC, a time zone that does not use daylight savings time (DST) and hence is typically most useful for data)
#	asciify (should diacritics be stripped from date names and converted to ASCII? This is useful if you're dealing with ASCII data where the correct spellings have been lost).

#2.)
#a.) Setting the decimal_mark and grouping_mark to the same character experiment:
parse_number("123,123.45", locale = locale(decimal_mark = ",", grouping_mark = ","))
#The result was an error saying that the grouping mark and the decimal mark must be different.

#b.) Setting the decimal mark to the default of grouping mark (","):
parse_number("123,123.45", locale = locale(decimal_mark = ","))# For a value that already has a decimal point at the end of the number, the console becomes confused to prints an error as a result. Will see if this is correct after I modify the floating point number a little more.
#Now I understand what I did wrong. I used parse_double() in place of parse_number(). The result of this experiment was 123.12345, meaning that the last decimal point was ignored in place of the coma. 
parse_double("123,455", locale = locale(decimal_mark = ","))# It worked in this case. I believe that the decimal mark can be set to "," if there are no grouping "," symbols within the actual integer or floating point number. 
parse_number("123,455", locale = locale(decimal_mark = ","))

#c.) Setting the grouping mark to ".":
parse_double("1.230", locale = locale(grouping_mark = "."))
parse_number("1.456.678", locale = locale(grouping_mark = "."))
# the result is that the grouping_mark = "." command takes presidence over the default decimal_mark parameter.

#3.) 
??locale()
# The date_format and time_format arguments sets the formats in which the date and times in the data set are read into the console.

# date format experimentation:
locale() #Interesting you can just input the function call without any alternations to see the default variables within the arguments. 
??parse_time()
parse_date("01 01 2010", "%d %m %Y", locale = locale("ko"))
parse_date("23/mai/1979", "%d/%B/%Y", locale = locale("german"))# It seems that I can't log onto the date_names_locales help file to see all the language code names. Will need to find other documentation on this subject. This is very interesting none the less. It seems that I will have to hold off on using german language examples for parse_date() 
date_names_lang("ga")
date_names_lang("fi")
date_names_lang("de")# Sweet found the german language code.
parse_date("23/mai/1979", "%d/%B/%Y", locale = locale("de"))# Cool this worked like a charm. I think I can modify the tz argument too with the function parse_datetime().
parse_datetime("23/Juni/1945T2010", "%d/%B/%YT%H%M", locale = locale("de",tz = "UTC"))# Neat this line worked perfectly will need to find out how to create time zones though. I was forced to stick with the default (UTC) for the line to work. 
??date_names_lang()

#4.) 
??locale
locale(date_names = "de", date_format = "$AD", time_format = "%AT", decimal_mark = ",", grouping_mark = ".", tz = "UTC")# I really couldn't change the time format at all because I still don't know how to manipulate the tz argument in the locale function call. 

#5.) 
#The difference between read_csv and read_csv2 is the former reads coma sparated data sets while the latter reads semi colon separated data sets.

#7.)
d1 <- "January 1, 2010"
parse_date(d1, "%B%e, %Y")# there we go. The right way to go about this problem is to not space the month and the day away from one another and use the format code %e for the day (since the day is written as one number with a space). As for the day and the year; a coma followed by a space worked perfectly.

d2 <- "2015-Mar-07"
parse_date(d2, "%Y-%b-%d")
d3 <- "06-Jun-2017"
parse_date(d3, "%d-%b-%Y")
d4 <- c("August 19 (2015)", "July 1 (2015)")
parse_date(d4, "%B %d (%Y)")
d5 <- "12/30/14"
parse_date(d5, "%m/%d/%y")
t1 <- "1705"
parse_date(t1, "%Y")
#Not really sure if the response for this line of code was actually the answer Wickham had in mind. Will need to go make to this question later on through my studies.
t2 <- "11:15:10.12 PM"
parse_datetime(t2, "%m:%d:%y.%I %p")# Now I understand. There needs to be spacing between the hour and the pm and am indicator value. 

### chapter 11.4.1 Strategy:
#readr uses a heuristic to figure out the type of each column: it reads the first 1000 rows and uses some moderately conservative) heuristics to figure out the type of each column. You can emulate this process with a character vector using guess_parser(), which returns readr's best guess, and parse_guess() which uses that guess to parse the column.
guess_parser("2010-10-01")
guess_parser("15:01")
guess_parser(c("TRUE","FALSE"))
guess_parser(c("1","5","9"))
guess_parser(c("12,352,561"))

#The heuristic tries each of the following types: stopping when it finds a match:
#	logical: contains only "F", "T", "FALSE", or "TRUE".
#	Integer: contains only numeric character (and -)
#	double: contains only valid doubles (including numbers like 4.5e-05).
#	number: contains valid doubles with the grouping mark inside.
#	time: matches the default time_format
#	date: matches the default data_format 
#	date-time: any ISO8601 date.
#If none of these rules apply, then the column will stay as a vector of strings.

### Chapter 11.4.2 Problems:
# These defaults don't always work for larger files. there are two basic problems:
#	1. The first thousant rows might be a special case, and readr guesses a type that is not sufficiently general. For example, you might have a column of doubles that only contains integers in the first 1000 rows.
#	2. The column might contain a lot of missing values. If the first 1000 rows contain only NA s, readr will guess that it's a character vector, whereas you probably want to parse it as something more specific.

#An illustration of these problems:
challenge <- read_csv(readr_example("challenge.csv"))
#There are two printed outputs: the column specification generated by looking at the first 1000 rows, and the first five parsing failures. It's always a good idea to explicitly pull out the problems(), so you can explore them in more depth.
problems(challenge)

#A good strategy is to work column by column until there are no problems remaining. Here we can see that there are a lot of parsing problems with the x column - there are trailing characters after the integer value. That suggests we need to use a double parser instead.

#to fix the call, start by copying and pasting the column specification into your original call:
#Which is:
challenge <- read_csv(
	readr_example("challenge.csv"),
	col_types = cols(
		x = col_integer(),
		y = col_character()
		)
	)
	
#And modify the x column:
challenge <- read_csv(
	readr_example("challenge.csv"),
	col_types = cols(
		x = col_double(),
		y = col_character()
	)
)
#That fixes the first problem, but if we look at the last few rows, you'll see that their dates are stored in a character vector:
tail(challenge)

#you can fix that by specifying that y is a date column:
challenge <- read_csv(
	readr_example("challenge.csv"),
	col_types = cols(
		x = col_double(),
		y = col_date()
		)
	)
tail(challenge)

#Every parse_xyz() function has a corresponding col_xyz() function. You use parse_xyz() when the data is in a character vector in R already; you use col_xyz() when you want to tell readr how to load the data.
#I highly recommend always supplying col_types, building up from the print-out provided by readr. This ensures that you have a consistent and reproducible data import script. I you rely on the default guesses and your data changes, readr will continue to read it in. If you want to be really strict, use stop_for_problems(): that will throw an error and stop your script if there are any parsing problems.

### chapter 11.4.3 other strategies:
# there are a few other general strategies to help you parse files:
#	In the previous example, we just got unlucky: if we look at just one more row than the default, we can correctly parse in one shot:
challenge2 <- read_csv(readr_example("challenge.csv"), guess_max = 1001)

#	Sometimes it's easier to diagnose problems if you just read in all the columns as character vectors:
challenge2 <- read_csv(readr_example("challenge.csv"), 
	col_types = cols(.default = col_character())
)
#This is particularly useful in conjunction with type_convert(), which applies the parsing heuristics to the character columns in a data frame.
df <- tribble(
~x, ~y,
"1", "1.21",
"2","2.32",
"3","4.56"
)
df
type_convert(df)

#	If you're reading a very large file, you might want to set n_max to a smallish number like 10,000 or 100,000. That will accelerate your iterations while you eliminate common problems.
#	If you're having major parsing problems, sometimes it's easier to just read into a character vector of lines with read_lines(), or even a character vector of length 1 with read_file(). Then you can use the string parsing skills you'll learn later to parse more exotic formats.

### chapter 11.5 Writing to a file:
#readr also comes with two useful functions for writing data back to disk: write_csv() and write_tsv(). Both functions increase the chances of the output file being read back in correctly by:
#	Always encoding strings in UTF-8 
#	Saving dates and data-times in ISO8601 format so they are easily parsed elsewhere.

#If you want to export a csv file to Excel, use write_excel_csv() -- this writes a special character (a byte order mark) at the start of the file which tells excel that you're using the UTF-8 encoding.

#The most important arguments are x (the data frame to save), and path (the location to save it). You can also specify how missing values are written with na, and if you want to append to an existing file.
write_csv(challenge, "challenge.csv")# Interesting the table was saved into rworks. I guess rworks is my default directory for base R scripts and saved objects.
#Note that the type information is lost when you save to csv.
challenge
write_csv(challenge, "challenge-2.csv")
read_csv("challenge-2.csv")

#this makes CSVs a little unreliable for catching interim results--- you need to recreate the column specification every time you load in. There are two alternatives:
#	write_rds() and read_rds() are uniform wrappers around the base functions readRDS() and saveRDS(). these store data in R's custom binary format called RDS.
write_rds(challenge, "challenge.rds")
read_rds("challenge.rds")

#	The feather package implements a fast binary file format that can be shared across programming languages:
library(feather)
write_feather(challenge, "challenge.feather")
read_feather("challenge.feather")
#Feather tends to be faster than RDS and is usable outside of R. RDS supports list columns; feather currently does not. 

