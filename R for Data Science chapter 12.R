### Chapter 12 Tidy data:
### Chapter 12.1 Introduction:
#This chapter will talk about the tidy data organisation process.

###Chapter 12.2 Tidy Data:
library(tidyverse)

#There are three interrelated rules which make a dataset tidy:
#	Each variable must have its own column.
#	Each observation must have its own row
#	Each value must have its own cell.

#These three rules are interrelated because it's impossible to only satisfy two of the three. That interrelationship leads to an even simpler set of practical instructions:
#	1. Put each dataset in a tibble.
#	2. Put each variable in a column.

#Why ensure that your data is tidy? There are two main advantages:
#	1. There's a general advantage to picking one consistent way of storing data. If you have a consistent data structure, it's easier to learn the tools that work with it because they have an underlying uniformity.
#	2. There's a specific advantage to placing variables in columns because it allows R's vectorised nature to shine (Interestingly Tilman says that this nature is elemential wise computations). As you learned in muutate and summary functions, most built-in R functions work with vectors of values. That makes transforming tidy data feel particularly natural.

#(additional note) All of the packages designed by Wickham were created for computing with tidy data. Hence stick with this philosophy and data analysis will come effortlessly from your data.

# Tribble function practice:
table1 <- tribble(~country, ~year, ~cases, ~population, ~rate,
				"Afghanistan", 1999, 745, 19987071, 0.373,
				"Afghanistan", 2000, 2666, 20595360, 1.294,
				"Brazil", 1999, 37737, 172006362, 2.194,
				"Brazil", 2000, 80488, 174504898, 4.612,
				"China", 1999, 212258, 1272915272, 1.667,
				"China", 2000, 213766, 1280428583, 1.669) 
#Sweet Tribble() practice was a success. The table looks just like the one on chapter 12.2. 

#Wickham's Example on how to work with tidy data with the tidyverse package:
table %>% mutate(rate = cases/population * 10000)
table %>% count(year, wt = cases)
library(ggplot2)
ggplot(table, aes(year, cases)) + geom_line(aes(group = country), color = "grey50") + geom_point(aes(color = country))

#Experimenting with the count() function (since I didn't know that the wt argument in the count function can change the values being weighted.) 
library(nycflights13)
flights %>% count(dest, wt = dep_delay)# No way. I didn't know that I can use the count() function like this without the need of the group_by() function. Will need to see if this code really did organize the number of flights delayed within each destination. 
flights %>% count(tailnum, wt = arr_delay)# Now I understand the n values are actually minutes delayed not the number of planes that were delayed to depart. 
flights %>% count(dest, wt = is.na(dep_delay))# Now this line of code organizes the n values to show the amount of flights that were cancelled according to destination.
flights %>% count(dest, wt = dep_delay <= 0)
flights %>% count(dest, wt = dep_delay >= 0)# Neat I believe that I found the correct solutions for the couple of problems that I couldn't finish on section 1. Will need to go back to that section later on through my studies.

### chapter 12.2.1 Exercises:
#1.) 
# In table1 the variables are organized according to country, year, cases, and population. For the year column, the number of years only encompasses 1999 and 2000 (meaning that each country has it's own 1999 and 2000 dataset).

# In table2 the variables are organized according to country, year, type (in this case a factorized vector that spans between cases and population), and count (the values corresponding to the type category). I believe that this table goes against the tidy data philosophy because cases and population should have their own columns. 

# In table3 the variables are organized from country, year (which again changes from 1999 and 2000 per country, and interestingly enough rate (written as an unsimplified fraction that shows the number of cases as the numerator and the population as the denominator).

# In table4a the variables are organized according to country, the number of cases in 1999, and the number of cases in 2000. While table4b is organized by country, 1999 population, and 2000 population.

#2.) 
table2 <- tribble(~country, ~year, ~type, ~count,
				"Afghanistan", 1999, "cases", 745,
				"Afghanistan", 1999, "population", 19987071,
				"Afghanistan", 2000, "cases", 2666,
				"Afghanistan", 2000, "population", 20595360,
				"Brazil", 1999, "cases", 37737,
				"Brazil", 1999, "population", 172006362,
				"Brazil", 2000, "cases", 80488,
				"Brazil", 2000, "population", 174504898,
				"China", 1999, "cases", 212258,
				"China", 1999, "population", 1272915272,
				"China", 2000, "cases", 213766,
				"China", 2000, "population", 1280428583)

cases_flea <- table2 %>% filter(type == "cases") %>% group_by(country, year) %>% summarise(cases = count)
population_flea <- table2 %>% filter(type =="population") %>% group_by(country, year) %>% summarise(population = count)
rate_flea <- cases_flea$cases / population_flea$population * 10000
rate_flea2 <- rep(rate_flea, each = 2)
table2[[5]] <- rate_flea2
table2 <- rename(table2, rate = V5)
table2# For me this attempt was a success only because the data set was a manageable size. If this dataset was over 20 rows in length I would have to use a different technique to get the same result. In any case, this wasn't really a bad solution to this problem.

table4a <- tribble(~country, ~`1999`, ~`2000`,
					"Afghanistan", 745, 2666,
					"Brazil", 37737, 80488,
					"China", 212258, 213766)
table4b <- tribble(~country, ~`1999`, ~`2000`,
					"Afghanistan", 19987071, 20595360,
					"Brazil", 172006362, 174504898,
					"China", 1272915272, 1280428583)
table4ab <- full_join(table4a, table4b)# this doesn't work because there is no descriptive label illustrating what value represents population and what value represents cases. 

table4a_1999 <- table4a %>% group_by(country) %>% summarise(cases = `1999`)
table4a_2000 <- table4a %>% group_by(country) %>% summarise(cases = `2000`)
table4b_1999 <- table4b %>% group_by(country) %>% summarise(population = `1999`)
table4b_2000 <- table4b %>% group_by(country) %>% summarise(population = `2000`)
rate_table1999 <- table4a_1999$cases/table4b_1999$population * 10000
rate_table2000 <- table4a_2000$cases/table4b_2000$population * 10000
table4a <- table4a %>% mutate(rate_1999 = rate_table1999, rate_2000 = rate_table2000)
table4b <- table4b %>% mutate(rate_1999 = rate_table1999, rate_2000 = rate_table2000)

#Failed Attempt:
table2 <- tribble(~country, ~year, ~type, ~count,
				"Afghanistan", 1999, "cases", 745,
				"Afghanistan", 1999, "population", 19987071,
				"Afghanistan", 2000, "cases", 2666,
				"Afghanistan", 2000, "population", 20595360,
				"Brazil", 1999, "cases", 37737,
				"Brazil", 1999, "population", 172006362,
				"Brazil", 2000, "cases", 80488,
				"Brazil", 2000, "population", 174504898,
				"China", 1999, "cases", 212258,
				"China", 1999, "population", 1272915272,
				"China", 2000, "cases", 213766,
				"China", 2000, "population", 1280428583)

cases_flea <- table2 %>% filter(type == "cases") %>% group_by(country, year) %>% summarise(cases = count)
population_flea <- table2 %>% filter(type =="population") %>% group_by(country, year) %>% summarise(population = count)
join_flea <- full_join(cases_flea, population_flea, na.rm=TRUE)
join_flea %>% group_by(country, year) %>% mutate(rate = cases/population * 10000, rm.na=TRUE) %>% select(country, year, cases, rate) # this line of code didn't work because the population and the cases values didn't make up their own columns and the joining function didn't really help matters. Will need to find out how to join the two objects that I created into one data frame without generating NA values.

#Interesting through only changing the full_join() function into inner_join() you can make this line of code work perfectly. There are no NA values in the data frame. 
join_flea <- full_join(cases_flea, population_flea, na.rm=TRUE)
join_flea %>% group_by(country, year) %>% mutate(rate = cases/population * 10000, rm.na=TRUE) %>% select(country, year, cases, rate)

# I believe that logistically the first problem (table2) was by far the hardest because I had to extract the cases and the population and place all of these values in their own vectors. I believe that the method that I used will not scale properly for larger datasets and because of that it's important to place the values for cases and population in columns of their own. 
# With that said though, I do admit that the table4a and table4b were hard to solve due to that fact that 1999 and 2000 were their own columns. 

#3.) 
table1 <- tribble(~country, ~year, ~cases, ~population, ~rate,
				"Afghanistan", 1999, 745, 19987071, 0.373,
				"Afghanistan", 2000, 2666, 20595360, 1.294,
				"Brazil", 1999, 37737, 172006362, 2.194,
				"Brazil", 2000, 80488, 174504898, 4.612,
				"China", 1999, 212258, 1272915272, 1.667,
				"China", 2000, 213766, 1280428583, 1.669) 

table2 <- tribble(~country, ~year, ~type, ~count,
				"Afghanistan", 1999, "cases", 745,
				"Afghanistan", 1999, "population", 19987071,
				"Afghanistan", 2000, "cases", 2666,
				"Afghanistan", 2000, "population", 20595360,
				"Brazil", 1999, "cases", 37737,
				"Brazil", 1999, "population", 172006362,
				"Brazil", 2000, "cases", 80488,
				"Brazil", 2000, "population", 174504898,
				"China", 1999, "cases", 212258,
				"China", 1999, "population", 1272915272,
				"China", 2000, "cases", 213766,
				"China", 2000, "population", 1280428583)

table_cases <- table2 %>% group_by(country, year) %>% filter(type == "cases") 
ggplot(table_cases, aes(year,count)) + geom_line(aes(group = country), color = "grey50") + geom_point(aes(color = country))
# As you can see from the code above, the first thing that I had to do was create a new data frame that had only cases and no population values hence I used the filter() function to narrow the values down to cases only. 

### 12.3 Spreading and gathering:
#The principles of tidy data seem so obvious that you might wonder if you'll ever encounter a dataset that isn't tidy. Unforunately, however, most data that you wil encounter will be untidy. There are two main reasons:
#	1. Most people aren't familiar with the principles of tidy data, and it's hard to derive them yourself unless you spend a lot of time working with data.
#	2. Data is often organised to facilitate some use other than analysis. For example, data is often organised to make entry as easy as possible.

#The first step is always to figure out what the variables and observations are. The second step is to resolve one of two common problems:
#	1. One variable might be spread across multiple columns.
#	2. One observation might be scattered across multiple rows. 

#To fix these problems, you'll need the two most important functions in tidyr: gather() and spread().

### chapter 12.3.1 Gathering:
#A common problem is a dataset where some of the column names are not names of variables, but values of a variable. Take table4a :the column names 1999 and 2000 represent values of the year variable, and each row represents two observations, not one.
table4a
table4b
#So in other words, keep variables within the rows not the columns even if it makes the dataset look more manageable. In this cirrcumstance the variables 1999 and 2000 shoubel be documented down as responses not variables. 

#To tidy a dataset like this, we need to gather those columns into a new pair of variables. To describe that operation we need three parameters:
#	The set of columns that represent values, not variables. In this example, those are the columns 199 and 2000.
#	The name of the variable whose values form the column names. I call that the key, and here it is year.
#	The name of the variable whose values are spread over the cells. I call that value, and here it's the number of cases.

#Together these argument create the syntax within the gather function:
table4a %>% gather(`1999`, `2000`, key = "year", value = "cases")
#Neat this function transfered the values under the 1999 and 2000 columns into a newly created cases category while the year variable has been organized into a column category entiled year. Now I see that this function is very useful in tidying up datasets. 

#The columns to gather are specified with dply::select() style notation. Here there are only two columns, so we list them individually. Note that "1999" and "2000" are non-syntactic names (because they don't start with a letter) so we have to surround them in backticks. 

#In the final result, the gathering columns are dropped and we get new key and value columns. Otherwise, the relationships between the original variables are preserved. 

#We can see this same function on table4b with the alteration being the need to name value as population in place of cases.
table4b %>% gather(`1999`, `2000`, key = "year", value = "population")

#To combine the tidied versions of table4a and table4b into a single tibble, we need touse dplr::left_join().
tidy4a <- table4a %>% gather('1999', '2000', key ="years", value = "cases")
tidy4b <- table4b %>% gather(`1999`, `2000`, key = "years", value = "population")
left_join(tidy4a, tidy4b)

### chapter 12.3.2 Spreading:
#Spreading is the opposite of gathering. You use it when an observation is scattered across multiple rows. For example, take table2: an observation is a country in a year, but each observation is spread across two rows.

table2
#to tidy this up, we first analyse the representation in similar way to gather(). This time, however, we only need two parameters:
#	The column that contains variable names, the key column. Here, it's type.
#	The column that contains values forms multiple variables, the value column. Here it's count. 

#Once we've figured that out, we can use spread().
spread(table2, key = type, value = count)
# As you might have guessed from the common key and value arguments, spread() and gather() are complements. gather() makes wide tables narrower and longer; spread() makes long tables shorter and wider.

### Chapter12.3.3 Exercises:
#1.) 
stocks <- tibble(
	year = c(2015, 2015, 2016, 2016),
	half = c( 1, 2, 1, 2),
	return = c(1.88, 0.59, 0.92, 0.17)
)
# This representation reminds me that tibble() can be set up the same way as data.frame(). Will need to remember this detail.
stocks #the object was returned perfectly within the console. 
stocks %>% 
	spread(year, return) %>%
	gather("year", "return", `2015`: `2016`)
# Both spread and gather are not perfectly symmetrical because spread works to widen the data frame through making a response into a variable much like what happened in stocks %>% spread(year, return). The result of this line of code is a data frame very much like the one seen in table4a and table4b. This function is very useful in cleaning up datasets that have an observation that is scattered across multiple rows like with table2 (where population and cases are all scattered throughout the dataset and the data scientist had to repeat the columns country and year two times each). While gather is used to lengthen the responses in the dataset at the cost of reducing the amount of variables.

#2.)
table4a %>% gather(1999, 2000, key = "year", value = "cases")

table4a %>% gather(`1999`, `2000`, key = "year", value = "cases") # Just as I suspected the lack of backslashes around the 1999 and 2000 numeric values cased the console to be unable to read the line of code. Through inputting `1999` and `2000` into the gather() function the problem was fixed.

#3.) 
people <- tribble(
	~name, ~key, ~value,
	"Phillip Woods", "age", 45,
	"Phillip Woods", "height", 186,
	"Phillip Woods2", "age", 50,
	"Jessica Cordero", "age", 37,
	"Jessica Cordero", "height", 156
)
# To begin; from a coding perspective this line of code was perfectly written, the only problem I can see is that the key variable is very much confused in that it's recording botht the age and the height of the respondants. I believe that spread will very much fix this confusion. 
spread(people, key = key, value = value)
# Now I understand what Wickham was talking about when he said the line of code was broken. It seems that if one of the respondants' names are the same the spread() function will automatically think that the entries are duplicates and as a result an error will be printed onto the console. The is really a bad characteristic of the spread and gather functions, will need to look into their documentation to see how I can disable this automatic check.
??spread()
??tribble()

# According to the author's solution I was supposed to create another variable illustrating the amount of times the observation is recoded. So instead of Phillip Woods2 you have to put 2 for the second instance of Phillip Woods in the dataset. 

people <- tribble( 
	~name, ~key, ~value, ~observation,
	"Phillip Woods", "age", 45, 1,
	"Phillip Woods", "height", 186, 1,
	"Phillip Woods", "age", 50, 2,
	"Jessica Cordero", "age", 37, 1,
	"Jessica Cordero", "height", 156, 1
)
spread(people, value = value, key = key)# Neat the extra category for the number of observations actually worked. 

#4.) 
preg <- tribble(
	~pregnant, ~male, ~female,
	"yes", NA, 10,
	"no", 20, 12
)
preg
preg %>% gather("gender", "count", "male" : "female")# This line worked perfectly. The main thing to remember is to create two different columns for this dataset the first one for the variables that you want to transform into observations (in this case male and female) and the second column for the values under the variables that you are transforming (namely in this case the count column).

### 12.4 Separating and uniting:
#So far you've learned how to tidy table2 and table4, but not table2 and table4, but not table3. table3 has a different problem: we have one column (rate) that contains two variables (cases and population). To fix this problem, we'll need that separate() function. You'll also learn about the complement of separate(): unite(), which you use if a single variable is spread across multiple columns.

### 12.4.1 Separate:
#separate() pulls apart one column into multiple columns, by splitting whereever a separator character appears. Take table3:
table3
#The rate column contains both cases and population variables, and we need to split it into two variables. separate() takes the name of the column to separate, and the names of the columns toseparate into.

table3 %>% 
	separate(rate, into = c("cases", "population"))
# Interesting the separate() function identified the / separator automatically and thus separated the two variable into the respected columns of cases and population. Will need to see if this function will still work if the separators are different symbols. 

#By default, separate() will split values wherever it sees a non-alphanumeric character. For example, in the code above, separate() split the values of rate at the forward slash characters. If you wish to use a specific character to separate a column, you can pass the character to the sep argument of separate(). 

table3 %>% 
	separate(rate, into = c("cases","population"), sep ="/")	
	
# Look carefully at the column types: you'll notice that the case and population columns are labeled as characters. This is the default behaviour in separate(): it leaves the type of the column as is. Here, however, it's not very useful as those really are numbers. We can ask separate() to try and convert to better types using convert = TRUE:
table3 %>% 
	separate(rate, into = c("cases", "population"), convert = TRUE)# Neat just like what the author said, the columns created from the separate() function were converted to integers. 
	
#You can also pass a vector of integers to sep. separate() will integret the integers as positions to split at. Positive values start at 1 on the far-left of the strings; negative value start at -1 on the far right of the strings. When using integers to sepatate strings, the length of sep should be one less than the number of names in into.
#The code below will separate the year values by the century and by the year in the tens place. 
table3 %>%
	separate(year, into = c("century", "year"), sep = 2)# In other words, the sep = 2 told the console to cut the year values in half. 

# Lets try out a little experiment on the same table and variables:
table5 <- table3 %>% 
	separate(year, into = c("thousand", "hundreds", "tens", "ones"), sep = 1)# Knew this line wouldn't working because the sep = 1 argument told the console that I will onl separate the value by the one's place or the thousands place. Will test this theory. 
table3 %>% 
	separate(year, into = c("thousand", "year"), sep = 1)
# Interesting the thousands place was separated from the year value. So the sep argument moves from left to right.

### chapter 12.4.2 Unite:
#Unite() is the inverse of separate(): it combines multiple columns into a single column. 

#We can use unite() to rejoin the century and year columns that we created in the last example. unite() takes a data frame, the name of the new variable to create, and a set of columns to combine, again specified in dply::select() style.
table5 %>% 
	unite(new, century, year)

#In this case we also need to use the sep argument. The default will place an underscore (_) between the values from different columns. Here we don't want any separator so we use "".
table5 %>%
	unite(new, century, year, sep = "")
	
### chapter 12.4.3 Exercises:
#.1) 
??separate()
# The extra argument (if sep is a character vector) controls what happens when there are too many pieces. There are three valid options: 
#	warn (the default): emit a warning and drop extra values:
#	"drop": drop any extra values without a warning.
#	"merge": only splits at most length(into) times.

# The fill argument (if again sep is a character vector) controls what happens when there are not enough pieces. There are three valid options:
#	"warn" (the default): emit a warning and fill from the right.
#	"right": fill with missing values on the right
#	"left": will with missing values on the left.

tibble( x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% separate(x, c("one","two","three"), extra = "drop")
# Just like what the documentation said, there was no warning message that it drop the "g" value from the tibble.
tibble( x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% separate(x, c("one","two","three"), extra = "merge")
#the merge argument combined the f place if g. The two values are separated by a coma (this seems to be the default setting. Will need to check if this is correct).
 
tibble( x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% separate(x, c("one","two","three"), extra = "merge", sep = "/")# the response for this line of code was an error it seems that there really is no way to customize the symbol separating f and g through the separate() function call.

tibble( x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% separate(x, c("one","two","three", "four"))
tibble( x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% separate(x, c("one","two","three", "four"), fill = "right")
tibble( x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% separate(x, c("one","two","three", "four"), fill = "left")
# The fill argument is almost the exact opposite of the extra argument in that it tells the console to fill the result separation tribble with NA values on the right or the left. The default is to fill the tibble with NA values on the right side.


#2.) 
??unite()
??separate()
# The documentation for the remove argument says that if it's set to true, the input column will be removed from the output data frame. Will need to see what this means in practice. 
tibble( x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% separate(x, c("one","two","three", "four"), fill = "right", remove = FALSE)
#Now I understand, you will only set this argument to false if you want to create another column that displays all of the values in each row of the data frame. Very interesting. 

#3.)
??separate()
??extract()
# the author's answer:
#The function extract uses a regular expression to find groups and split into columns. In unite it is unambigous since it is may columns to one, and once the columns are specified, there is only one way to do it, the only choice is the sep. In separate, it is one to many, and there are multiple ways to split the character string. 

### Chapter 12.5 Missing values:
#Changing the representation of a dataset brings up an important subtlety of missing values. Surprisingly, a value can be mssing in one of two possible ways:
#	Explicitly, flagged with NA.
#	Implicitly, simply not present in the data.

stocks <- tibble(
	year = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
	qtr =c(1,2,3,4,2,3,4),
	return = c(1.88, 0.59, 0.35, NA, 0.92, 0.17, 2.66)
)

#There are twomissing values in this dataset:
#	The return for the fourth quarter of 2015 is explicitly missing, because the cell where its value should be instead contains NA.
#	The return for the first quarter of 2016 is implicitly missing, because it simply does not appear in the dataset.

#The way that a dataset is represented can make implicit values explicit. For example, we can make the implicit missing value explicit by putting years in the columns:
stocks %>% 
	spread(year, return)

#Because these explicit mssing values may not be important in other representations of the data, you can set na.rm = TRUE in gather() to turn explicit missing values implicit:
stocks %>% 
	spread(year, return) %>% 
	gather(year, return, `2015` : `2016`, na.rm = TRUE)
#Interesting, setting the na.rm argument to TRUE in the gather() function call removed the 2015 fourth quarter and the 2016 first quarter from the resulting dataset.

# Another important tool for making missing values explicit in tidy data is complete().
stocks %>%
	complete(year, qtr)

# complete() takes a set of columns, and finds all unique combinations. It then ensures the original dataset contains all those values, filling in explicit NAs where necessary.
#There's one other important tool that you should know for working with missing values. Sometimes when a data source has primarily been used for data entry, missing values indicate that the previous value should be carred forward.

treatment <- tribble(
	~person, ~ treatment, ~response,
	"Derrick Whitmore", 1, 7,
	NA, 2, 10,
	NA, 3, 9,
	"Katherine Burke", 1, 4
)

#You can fill in these missing values with fill(). It takes a set of columns where you want missing values to be replaced by the most recent non-missing value (sometimes called last observation carried forward).
treatment %>%
	fill(person)
	
### chapter 12.5.1 Exercise:
#1.) 
??complete()
#The documentation says that for complete() the fill argument is used in conjunction with a named list that for each variable supplies a single value to use instead of NA for missing combinations.
#Illustration:
stocks %>% complete(year, qtr, fill = list(person))# I really don't know how to manipulate fill at this point will most likely need to read more documentation on these functions.

??spread()
#As for spread(), documentation says that if set, missing values will be replaced with this valu. Note that there are two types of missingness in the input: explicit missing values, and implicit missing values, rows that simply aren't present. Both types of missing value will be replaced by fill.

#2.)
??fill()
#The direction argument is used to manipulate the direction in which the missing values are filled. Currently either "down" or "up". 

### Chapter 12.6 Case study:
# Cumulative chapter review using the tidyr::who dataset (which documents tuberculosis cases broken down by year, country, age, gender, and diagnosis method). 
who
#This is a very typical real-life example dataset. It contains redundant columns, odd variable codes, and many missing values. In short, who is messy, and we'll need multiple steps to tidy it. Like dplyr, tidyr is designed so that each function does on thing well. That means in real-life situations you'll usually need to string together multiple verbs into a pipeline.

# The best place to start is almost always to gather together the columns that are not variables. Let's have a look at what we've got:
#	It looks like country, iso2, and iso3 are three variables that redundantly specify the country.
#	Year is clearly also a variable.
#	We don't know what all the other columns are yet, but given the structure in the varialbe names (new_sp_m014, new_ep_m014, new_ep_f014) these are likely to be values, not variables. 

# so we need to gather together all the columns from new_sp_m014 to newrel_f65. We don't know what those values represent yet, so we'll give them the generic name "key". We know the cells represent the count of cases, so we'll use the variable cases. There are a lot of missing values in the current representation, so for now we'll use na.rm just so we can focus on the values that are present. 

who1 <-  who %>% 
	gather(new_sp_m014:newrel_f65, key = "key", value = "cases", na.rm = TRUE)
who1# Interesting this one command shrunk the dataset from having 60 columns to having only 6 columns.

#We can get some hint of the structure of the values in the new key column by counting them:
who1 %>%
	count(key)
	
#The data set tells us:
#	The first three letters of each column denote whether the column contains new or old cases of TB. In this dataset, each column contains new cases.
#	The next two letters describe the type of TB 
		#rel stands for cases of relapse
		#ep stands for cases of extrapulmonary TB
		#sn stands for cases of pulmonary TB that could not be diagnosed by a pulmonary smear (smear negative).
		#sp stands for cases of pulmonary TB that could be diagnosed be a pulmonary smear (smear positive).
#	The sixth letter gives the sex of TB patients. The dataset groups cases by males (m) and females (f).
#	The remaining numbers gives the age group. The dataset groups cases into seven age groups.

# We need to make a minor fix to the format of the column names: unfortunately the names are slightly inconsistent because instead of new_rel we have newrel. With the str_replace() function we can replace all entries with newrel with the new phrase new_rel.

who2 <- who1 %>%
	mutate(key = stringr::str_replace(key, "newrel", "new_rel"))
who2

# We can separate the values in each code with two passes of separate(). The first pass will split the codes at each underscore. 
who3 <- who2 %>%
	separate(key, c("new", "type","sexage"), sep = "_")
who3

#Then we might as well drop the new column because it's constant in this dataset. While we're dropping columns, let's drop iso2 and iso3 since they're redundant.
who3 %>% count(new)
who4 <- who3 %>% 
	select(-new, -iso2, -iso3)

#Next we'll separate sexage into sex and age by splitting after the first character:
who5 <- who4 %>% 
	separate(sexage, c("sex","age"), sep= 1)
who5

# This typically isn't how you'd work interactively. Instead, you'd gradually build up a complex pipe:
who %>%
	gather(code, value , new_sp_m014:newrel_f65, na.rm=TRUE) %>%
	mutate(code = stringr::str_replace(code, "newrel", "new_rel")) %>%
	separate(code, c("new","var","sexage")) %>%
	select(-new, -iso2, -iso3) %>%
	separate(sexage, c("sex","age"), sep = 1)
	
### chapter 12.6.1 Exercises:
#1.) 
who %>%
	gather(code, value , new_sp_m014:newrel_f65, na.rm=FALSE) %>%
	mutate(code = stringr::str_replace(code, "newrel", "new_rel")) %>%
	separate(code, c("new","var","sexage")) %>%
	select(-new, -iso2, -iso3) %>%
	separate(sexage, c("sex","age"), sep = 1)
	
# Most likely, in this case, the explicit missing values and zero have completely different meanings in this dataset since a zero in value in a particular row illustrates that there are zero cases of TB for that age group in that country. While the NA values, that show up quite frequently throughout the dataset, show that the surveyers couldn't find any documentation for a specific age group in a specific country. Hence the NA shows their lack of information for that particular row. 
#As for the first question pertaining to the reasonability of deleting all rows with NA values, I believe that it was a very intelligent move since the NA values very much get in the way of data wrangling and data analysis. But when drawing conclusions from the data it is good practice to remember that out of 405,430 rows in the dataset there were only 76,036 with any values.

#2.)
#data wrangling example without the use of mutate(code = stringr::str_replace(code, "newrel", "new_rel")):
who %>%
	gather(code, value , new_sp_m014:newrel_f65, na.rm=TRUE) %>%
	separate(code, c("new","var","sexage")) %>%
	select(-new, -iso2, -iso3) %>%
	separate(sexage, c("sex","age"), sep = 1)
	
#Interesting, the console printed out a warning message saying that there are too few values at 2580 locations starting in 73467. Will need to see that effect of this through the RStudio View() function.
#Now I understand the newrel values had to be replaced with new_rel as a means to use the separate() function on all the data entries and separate the characters that represent the age group from the characters that separate the gender.

#3.)
??who
#According to the documentation iso2 and iso3 represent the 2 and 3 letter ISO country codes. And so Wickham was very much when he deleted these two values from the dataset due to redundancy.

#4.)
who5 %>% group_by(country, year, sex) %>% count(cases)
who5 %>% group_by(country) %>% summarize(total = sum(cases))
who5 %>% group_by(country, sex) %>% summarize(total = sum(cases)) %>% ggplot() + geom_bar(mapping = aes(x = country, y = total, fill = sex), stat = "identity")
#This visualization isn't the best way to illustrate the data. Will need to see what the author's solution is.

#Wickham's solution:
who5 %>%
	group_by(country, year, sex) %>%
	filter(year > 1995) %>% 
	summarize(cases =sum(cases)) %>%
	unite(country_sex, country, sex, remove = FALSE) %>%
	ggplot(aes(x = year, y = cases, group = country_sex, color = sex)) + geom_line()
#This still isn't a very good representation of the data. Will need to come back to this problem once I get more knowledge of the pipe and brush up a little on my functions with tidyr.

who5 %>% unite(country_sex, country, sex, remove = FALSE)
??aes()

