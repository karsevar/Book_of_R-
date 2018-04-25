### Chapter 5 Data transformation:
# For this chapter we'll be using the dplyr package will need to look up the documentation for this package. 

### 5.1.1 Prerequisites:
library(nycflights13)
library(tidyverse)
#Take careful note of the conflicts message that's printed when you load the tidyverse. It tells you that dplyr overwrites ome functions in base R. If you want to use the base version of these functions after loading dplyr, you'll need to use their full names: stats::filter() and stats::lag().

### 5.1.2 nycflights13:
# To explore the basic data manipulation verbs of dplyr, we'll use nyclfights13::flights. This data frame contains all 336,776 flights that departed from New York City in 2013. 
??flights
flights # Keep in mind that this data frame prints a little differently from other data frames you might have used in the past: it only shows the first rows and all the columns that fit on one screen. (To see the whole dataset, you can run View(flights) which will open the dataset in the Rstudio viewer). It prints differently from other datasets because it's a tibble. Tibbles are like data.frames but slightly tweaked. You might have noticed the row of three letter abbreviations under the column names. these describe the type of each variable.
# int stands for integers, dbl stands for doubles, or real numbers, chr stands for character vectors, or strings, dttm stands for date-times (a date + a time).
# The three other common types of varibles that are not apart of the data set flights:
# lgl stands for logical, vectors that contain only true and false; fctr stands for factors, which R uses to represent categorical variables with fixed possible values; date stands for dates.

### 5.1.3 dplyr basics:
#dplyr functions:
# Pick observations by their values (filter()).
# Reorder the rows (arrange())
# Pick variables by their names (select())
# Create new variables with functions of existing variables (mutate())
# Collapse many values down to a single summary (summarise())

#these can all be used in conjunction with group_by() which changes the scope of each function from operating on the entire dataset to operating on it group-by-group. 

#These six functions provide the verbs for a language of data manipulation:
#	1. the first argument is a data frame.
#	2. The subsequent arguments describe what to do with the data frame, using the variable names (without quotes)
#	3. The result is a new data frame.

View(flights)# Note to self don't open large tibbles in the base R interface. The viewer for tibbles is the X quarz interface and the implementation for these data frames in the program is clunky at best. make sure to use Rstudio for all tibble viewing needs. 

### chapter 5.2 Filter rows with filter():
#filter() allows you to subset observations based on their values. The first argument is the name of the data frame. The second and subsequent arguments are the expressions that filter the data frame. For example, we can select all flights on January 1st with:
filter(flights,month==1, day==1)# this command work perfectly. Will need to see if this function works with normal data frames and not just tibbles.

#Data.frame experiment:
library(MASS)
mtcars
filter(mtcars,mpg>=25, hp<80)
mtcars[(mtcars$mpg>=25&mtcars$hp<80),]# The filter function method is very useful since through this syntax you don't have to disclose the data frame name and the column titles constantly throughout the call (this functionality is much like that of the base R graphics with that of the ggplot2 graphics and syntax). The main problem that I found is that the car names were not disclosed in the filter() function call while the normal R base subsetting syntax was able to print the car names. Will have to which if this over sight is not a trend with older none tibble data frames. In any case, this is a very good function and I will love to use it throughout my studies.

jan1 <- filter(flights, month==1,day==1) 
(jan1 <- filter(flights, month==1, day==1))# Again through this method you can 1. print the result on your console without having to call the object and 2. save the data frame in an object for future operations and explorations.

###Chapter 5.2.1 Comparisons:
#To use filtering effectively, you have to know how to select the observations that you want using the comparison operators. R provides the standard suite: >, >=, <, != and ==. 
#There's a problem you might encounter when using ==:floating point numbers. 
#Illustration of the problem:
sqrt(2) ^2 ==2
1/49 *49 ==1
#Interestingly the answers for both problems is false . This is because of the finite precision arithmetic. So remember that every number you see is an approximation. Instead of relying on == use near().
near(sqrt(2)^2, 2)
near(1/49*49, 1)
#The results for both is true.

### 5.2.2 Logical operators:
#Multiple arguments to filter() are combined with and: every expression must be true in order for a row to be included in the output. For other types of combinations, you'll need to use Boolean operators yourself: & is and, | is or, ! is not. 

#This following code uses the boolean or symbol to find all flights that departed in November or December:
filter(flights, month==11| month==12) #Of course the | symbol is the or boolean sign and month numeric values 11 and 12 are November and December respectively.

#The order of operations doesn't work like English. You can't write filter(flights, month ==11| 12), which you might literally translate into finds all flights that departed in November and December. Instead it finds all months that equal 11|12, an expression that evaluates to true. In a numeric context, true becomes one, so this finds all flights in January, not November or December. Will need to test this problem out.

filter(flights, month==11|12)# Fascinating, he was right. Will need to test this or statement outside of the filter function.
11|12# Interesting the or statement assessed the two numeric values as true which means in the context of the month==11|12 statement, the computer believed that the 11|12 call was a mathematical formula and not a call to the months November and December.

# A useful short-hand for this problem is x %in% y. This will select every row where x is one of the values in y. We could use it to rewrite the code above.
nov_dec <- filter(flights, month %in% c(11,12))
nov_dec# The result was the same as the filter(flight, month==11|month==12) function call. Will need to look into the syntax later on. This in statement tooks very much like that of python. 

#Sometimes you can simplify complicated subsetting by remembering De Morgan's law: !(x & y) is the same as !x | !y and !(x|y) is the same as !x&!y.

filter(flights, !(arr_delay>120 | dep_delay> 120))
filter(flights, arr_delay <= 120, dep_delay<= 120) 

### 5.2.3 Missing values:
#One important feature of R that can make comparison tricky are missing values, or NAs (not availables). NA represents an unknown value so missing values are contagious: almost any operation involving an unknown value will also be unknown.
NA > 5
10 ==NA
NA + 10
NA/2
NA==NA
x <- NA
Y <- NA
Y == x# All of these operations bring about NAs. 

#identity operator that tells you whether a value is an NA or not.
is.na(x)# the result was of course true.

#filter() only includes rows where the condition is true; it excludes both false and NA values. If you want to preserve missing values, ask for them explicitly.
df <- tibble(x=c(1,NA, 3))
filter(df, x>1)# Interestingly the console read df as being length 1 by 1
filter(df, is.na(x)| x>1)# In this case it read df as being length 2 by 1, will need to look more into the tibble documentation to understand their indexing syntax. 

### 5.2.4 Exercises:
#1.) 
#a.) 
filter(flights, !(arr_delay<120))
filter(flights, arr_delay>=120)
#Looks like both lines of code worked. 

#b.) 
View(flights)
Houston <- filter(flights, dest=="IAH"|dest=="HOU")
View(Houston)# According to the Xquartz viewer, this line of code worked perfectly. Pretty neat that filter() works this well.

#c.) 
filter(flights, carrier %in% c("UA","DL","AA"))# This line of code seems to have worked perfectly. Will need to see if I can create the same data structure using base R programming.

#d.) 
filter(flights, month %in% c(7,8,9))

#e.) 
flea.me <- filter(flights, dep_time<=sched_dep_time&arr_delay>120)
View(flea.me)# I believe that this code is exactly what the author had in mind. Interesting that I can put together two row types into one boolean operation. Pretty interesting.

#e.) Were delayed by at least an hour, but made up over 30 minutes in flight. Will need to look into the solution.

#f.) 
filter(flights, dep_time %in% c(24,1,2,3,4,5,6)) #Will need to look into how I can fix this code a little more to include minutes (or rather in the author's words) be inclusive within each hour.

#2.) 
??between()# This is the shortcut for x>= left & x <= right, implemented efficiently in c++ for local values, and translated to the appropriate SQL for remote tables. 
#Diagram of the function:
#	between(x, left, right) 
??flights
filter(flights, dep_time <2400 & dep_time<=600)
flights$dep_time >=2400 & flights$dep_time<=600# Interesting this subsetting line of code worked but the output was all false responses, which is a bit odd. Will need to look into what I'm doing wrong with this experiment on question 1 part f. 
flights[flights$dep_time >=2400 & flights$dep_time<=600,]#Interesting when using the flights call as a data.frame in the subsetting base R syntax the response data frame only results in NA values. This must be because tibbles are not compatible with base R syntax (or rather base R subsetting techniques). I believe that these NA values are actually the TRUE values that I'm looking for. Will need to see how I can transform this tibble into a data frame.

filter(flights, dep_time <2400 & dep_time<=600)# Now I understand what I did wrong I wrote the greater than symbol away from the 2400 value instead of towards it. This tells the computer to look into values that are less than 2400 hence leading to 600. With that said though, I still can't code the inclusive value in 2400 and 600 only the hours between thems two time frames. 

#Experiment using the between() function call
filter(flights, between(dep_time,2400,600))
between(flights$dep_time,600,2400)# Not really sure if this is the correct answer though. Will need to look into how to properly implement this function. Whether to create a function call by itself like the line of code above or with the function filter like the first line of code in the experiment. It seems that both experiments give rise to unsensical results. 

filter(flights, between(dep_time,600,2400))# It seems that this method is the most intuitive to implement but the only problem is that the values within the 2400 hour mark is cut off as a means for mathematical accuracy. Will need to find a way to include these values. Now I understand these between() function gives me the opposite values of what I'm trying to obtain.
flea.me <- filter(flights, between(dep_time,600,2400))
filter(flights, dep_time!=between(dep_time,600,2400))
filter(flights, dep_time %in% c(2400 & between(100,600)))
#Now I see what the problem is there are no flights leaving the airport after midnight. which means that the code should stop at 2400. 
flea.me <- filter(flights, 100 <= dep_time & 600>=dep_time)
flea.me2 <- filter(flights, 2400==dep_time)

#3.)
View(filter(flights, is.na(dep_time)))# The other rows that are missing for these data entries are dep_delay, arr_time and arr_delay. I believe these rows illustrate that the people compiling the values for the survey didn't count a total of 8,255 flights during the survey and (as a result) these NA values infected all of the variables that rely on this information (like dep_delay and arr_delay). 

#4.)
NA ^ 0# I believe that this value is not printed as NA on the console because mathematically anything to the power of 0 is one.
NA | TRUE# This boolean operation used the or statement to print the TRUE result to the console in place of a NA because that is primarily how or boolean statements work in the computer langauge.
FALSE&NA# Much like the or statement above, the and boolean statement favors the FALSE in place of the NA value because you're giving the computer a choice between something that has a value (0 = FALSE) to something that has no value (NA).
NA * 0# I believe that using NA values in normal arithmetic computations will only give rise to a resulting NA. Hence it is a smart idea to create programs that isolates NAs and zeros so that they don't taint your computations.

### chapter 5.3 Arrange rows with arrange()

#arrange() works similarly to filter() except that instead of selecting rows, it changes their order. It takes a data frame and a set of column names (or more complicated expressions) to order by. If you provide more than on column name, each additional column will be used to break ties in the values of preceding columns.
arrange(flights, year,month,day)

#The desc() function is used to re-order the tibble by a column in descending order:
arrange(flights, desc(arr_delay))# this line of code orders the entries in the tibble by arrival delays from greatest to least.

#Missing values are always sorted in the end:
df <- tibble(x=c(5,2,NA))
df
arrange(df, x)

### Chapter 5.3.1 Exercises:

#1.)
arrange(flights, desc(is.na(arr_delay)))# This line worked perfectly. Will need to see if leaving the is.na() argument blank will use the element wise properties of R to find all the NA values in every column. 

#Experiment:
arrange(flights, desc(is.na()))# Seems like this alternative didn't work. 
arrange(flights, desc(is.na(dep_time,arr_time)))# the result for this line was an error message because the is.na() function can only take one argument at a time. Every interesting, I believe that an implicit loop will work perfectly for this problem.
arrange(flights, desc(is.na(dep_time)|is.na(arr_time)))

#2.) 
arrange(flights, desc(arr_delay))
arrange(flights, desc(arr_delay) & dep_time)# This line of code finds the flights that arrived the latest as well as the flights that have the earliest departure times in the same sample.  

#3.) 
??flights 
View(arrange(flights, air_time, desc(distance)))# this line of code rearranges the tibble into displaying the flights with the least air time by the farthest distance. Will need to see if writing the two variables backwards will change the results.
View(arrange(flights, desc(distance), air_time))# Just as I suspected when you rearrange the two variables, the priority of the sorting function changes. Hence in this case the flights are ordered by the farthest distance and the lowest air time. 
#This means that the fastest flight in the lineup is very much subjective to how far the flight had to travel. You can very much write a line that says arrange(flights, air_time) but this only displays the flights that traveled the least amount of miles and as such this isn't the best way to measure speed of the plane or the pilot.

#4.) 
arrange(flights, distance)
arrange(flights, desc(distance))

###chapter 5.4 Select columns with select()
#It's not uncommon to get datasets with hundreds or even thousands of variables. In this case, the first challenge is often narrowing in on the variables you're actually interested in. select() allows you to rapidly zoom in on a useful subset using operations based on the names of the variables.

select(flights, year, month, day)# This creates a data frame that displays the year, month and day columns in the flights data set.
select(flights, year:day)# this tells the console to display the columns from year to day. This line of code isn't really a good example of this. Here is a better example using the dep_time:arr_time argument.
select(flights, dep_time:arr_time)# this tells the console to display the columns in between dep_time and arr_time.
select(flights, -(year:day))# this is telling the console to disregard the columns in between year and day. This is very much the same as base R subsetting with numeric or string characters.

#There are a number of helper functions you can use within select():
#starts_with("abc"): matches names that bagin with "abc".
#ends_with("xyz"): matches names that end with "xyz".
#contains("ijk"): matches names that contain "ijk"
#matches ("(.)\\1"): selects variables that match a regular expression. This one matches any variable that contain repeated characters. You'll learn more about regular expressions in strings.
#num_range("x", 1:3): matches x1, x2, and x3.

#Select() can be used to renmae variables, but it's rarely useful because it drops all of the variables not explicitly mentioned. Instead, use rename(), which is a variant of select() that keeps all the variables that aren't explicitly mentioned.
View(rename(flights, tail_nam=tailnum))# So this changes the variable label that was once tailnum to tail_num. Very interesting.

#Another option is to use select() in conjunction with the everything() helper. This is useful if you have a handful of variables you'd like to more to the start of the data frame.
select(flights, time_hour,air_time, everything())# Through this command call you are telling the console to print the variables time_hour and air_time at the beginning of the tibble flights. Will need to look into the applications of this

### chapter 5.4.1 Exercises:
#1.) 
select(flights, dep_time, dep_delay, arr_time, arr_delay)

#2.)
select(flights, dep_time, dep_time, arr_time)# Repeated variables are ignored by the function and the repeated variable is only printed once in the console.

#3.)
??one_of() # variables in character vector. 
# I believe this argument can transform the character vector c("year","month","day","dep_delay","arr_delay") into five variables in the flights data set.

vars <- c("year","month","day","dep_delay","arr_delay")
select(flights, one_of(vars))# This worked just as I suspected the character strings in vars were transformed into variables in the flights data set.

#4.)
select(flights, contains("TIME"))
??select()# It seems that this line of code worked perfectly the contains("TIME") argument told the console to look for variables that have the phrase "time" within them. I believe that the author wanted me to be surprised about the console running the code successfully (since the phrase "TIME" was written in all caps). 
#The reason for the contains("TIME") argument working is because the argument within the contains function (ignore.case) is set automatically to TRUE. Through setting the argument ignore.case to FALSE will make this line not function as expected.
select(flights, contains(ignore.case=FALSE, "TIME"))
#As expected the result was zero columns in the fligths tibble containing the phrase "TIME".

### Chapter 5.5 Add new variables with mutate():
#Besides selecting sets of existing columns, it's often useful to add new columns that are functions of existing columns. That's the job of mutate(). mutate() always adds new columns at the end of your dataset so we'll start by creating a norrower dataset so we can see the new variables. Remember that when you're in Rstudio, the easiest way to see all the columns is View().
flights_sml <- select(flights, year:day, ends_with("delay"), distance, air_time)
mutate(flights_sml, gain=arr_delay - dep_delay, speed = distance/air_time * 60)# very neat function will need to play with this more later on in my studies. I can see that the applications for this functions are numerious. Very good addition to my tool set.

mutate(flights_sml,gain=arr_delay-dep_delay, hours=air_time/60, gain_per_hour= gain/hours)# Again this functions makes computations within data frames so much easier. 

#If you only want to keep the new variables use transmute():
transmute(flights, gain=arr_delay-dep_delay, hours=air_time/60, gain_per_hour= gain/hours)

### Chapter 5.5.1 Useful creation functions:
#There are many functions for creating new variables that you can use with mutate(). The key property is that the function much be vectorised: it must take a vector of values as input, return a vector with the same number of values as output. There's no way to list every possible function that you might use, but fhere's a selection of functions that are fequently useful:
#	Arithmetic operators: +, -, *, /, ^. These are all vectorised, using the so called "recycling rules". Arithmetic operators are also useful in conjunction with the aggregate functions you'll learn about later. For example, x / sum(x) calculates the proportion of a total, and y - mean(y) computes the difference from the mean.
#	Modular arithmetic: %/% (integer division) and %% (remainder), where x == y * (x %/% y) + (x %% y). Modular arithmetic is a handy tool because it allows you to break integers up into pieces.

#Example 1:
transmute(flights, dep_time, hour = dep_time %/% 100, minute= dep_time %% 100)# I will need to look into how this integer division and remainder operator works. Very interesting addition.

#	Logs: log(), log2(), log10(). Logarithms are an increadibly useful fransformation for dealing with data that ranges across multiple orders of magnitude. They also convert multiplicative relationships to additive, a feature we'll come back to in modelling. All else being equal, I recommend using log2() because it's easy to interpret: a difference of 1 on the log scale corresponds to doubling on the original scale and a difference of -1 corresponds to halving.

#	offsets: lead() and lag() allow you to refer to leading or lagging values. This allows you to compute running differences (x - lag(x)) or find when values change (x != lag(x)). They are most useful in conjunction with group_by().
#Example 2:
(x <- 1:10)
lag(x)
lead(x)

#	Cumulative and rolling aggregates: R provides functions for running sums, products, mins and maxes: cumsum(), cumprod(), cummin(), cummax(). And dplyr provides cummean() for cumulative means. 
#Example 3:
x
cumsum(x)
cummean(x)

#	Logical comparisons, <, <=, >, >=,!=.

#	Ranking: there are a number of ranking functions, but you should start with min_rank(). It does the most usual type of ranking. the default gives smallest values the small ranks; use desc() to give the largest values the smallest ranks
#Example 4:
y <- c(1,2,2,NA,3,4) 
min_rank(y)
min_rank(desc(y))
#If min_rank() doesn't do what you need, look at the variants row_number(), dense_rank(), percent_rank(), cume_dist(), ntile().
row_number(y)
dense_rank(y)
percent_rank(y)
cume_dist(y)

###Chapter 5.5.2 Exercises:
#1.)
transmute(flights, after_midnight_dep=(dep_time%/%100) *(60) + (dep_time%%100), after_midnight_sched_dep= (sched_dep_time%/%100) *(60) + (sched_dep_time%%100))

#2.)
transmute(flights, air_time,  arr_time-dep_time)# I believe that the representation of arr_time - dep_time is split into hours and minutes and air_time is calculated in minutes only. In addition, arr_time and dep_time arguments are all arranged according to the present time of the airport. One way that this problem can be fixed is to convert the arr_time and the dep_times into minutes away from midnight.
transmute(flights, air_time, dep_arr = ((arr_time%/%100) * (60) + (arr_time%%100)) - ((dep_time%/%100) * (60) + (dep_time%%100)))
select(flights, dep_time, arr_time)

#3.)
select(flights, dep_time, sched_dep_time, dep_delay)# The dep_delay seems to be calculated from finding the difference between the dep_time and the sched_dep_time. Hence departure delay is calculated through the equation:
 transmute(flights, dep_delay = dep_time - sched_dep_time) # In retrospect this equation is unfinished because I forgot that the times are documented as hours and minutes after midnight. To make this equation work you will need to turn the dep_time and sched_dep_times into minutes and then turn them back into hours and minutes.
 
 #4.)
 ??min_rank()# Interesting this function only works with vectors will need to look into an alternative that works on tibbles or data frames.
 flights.flea <- select(flights, dep_delay, arr_delay)
 flights.flea
 min_rank(as.vector(flights.flea))
 min_rank(as.vector(desc(flights$arr_delay)))# Now I understand the only way to do this exercise is to just simply arrange() them through the arrange function.
 
#departure delay ranking:
arrange(flights, desc(dep_delay)
arrange(flights, dep_delay)
#Arrival delay ranking:
arrange(flights, desc(arr_delay))
arrange(flights, arr_delay)

#5.)
1:3 + 1:10# It repeated the values in the first numerical string to fit with the length of the second numerical strings. This is called recycling and the R elemential computation functionality.

#6.) 
# the trigonometric functions for R are cos(), sin(), tan(), acos(), asin(), atan(), atan2(), cospi(), sinpi(), tanpi(), and most likely the log() function series.


### Chapter 5.6 Grouped summaries with summarise():
#The last key verb is summarise(). It collapses a data frame to a single row:
summarise(flights, delay=mean(dep_delay, na.rm=TRUE))

#summarise() is not terribly useful unless we pair with group_by(). This changes the unit of analysis from the complete dataset to individual groups. Then, when you use the dplyr verbs on the grouped data frame they'll be automatically applied 'by group'. For example, it we applied exactly the same code to a data frame grouped by date, we get the average delay per date.
by_day <- group_by(flights, year, month, day)
summarize(by_day, delay=mean(dep_delay, na.rm=TRUE))
#together group_by() and summarise() provide one of the tools that you'll use most commonly when working with dplyr: grouped summaries. 

###Chapter 5.6.1 combining multiple operations with the pipe:
by_dest <- group_by(flights, dest)
delay <- summarise(by_dest, count=n(),dist=mean(distance, na.rm=TRUE), delay=mean(arr_delay,na.rm=TRUE))
delay <- filter(delay, count > 20, dest != "HNL")
ggplot(data=delay, mapping = aes(x=dist, y=delay)) + geom_point(aes(size=count), alpha = 1/3) + geom_smooth(se= FALSE)
#there are three steps to prepare this data:
#	Group flights by destination.
#	Summarise to compute distance, average delay, and number of flights.
#	Filter to remove noisy points and Honolulu airport, which is almost twice as far away as the next closest airport.

#there's another way to tackle this same problem with the pipe, %>%:
delays <- flights %>% 
group_by(dest) %>% 
summarise( count=n(), dist = mean(distance, na.rm=TRUE), delay = mean(arr_delay, na.rm=TRUE)) %>%
filter(count > 20, dest !="HNL")
#This focuses on the transformations, not what's being transformed, which makes the code easier to read, You can read it as a series of imperative statements: group, then summarise, then filter. As suggested by this reading, a good way to pronounce %>% when reading code is then. Behind the scenes, x %>% f(y) turns into f(x,y), and x %>% f(y) %>% g(z) turns into g(f(x,y), z) and so on. You can use the pipe to rewrite multiple operations in a way that you can read left-to-right, top-to-bottom.

###Chapter 5.6.2 Missing values:
#You may have wondered about the na.rm=TRUE argumen. this example show what happens if you don't set this argument. 
flights %>% group_by(year,month,day) %>% summarise(mean(dep_delay))
#The end result is that the mean summarise function outputs NA values as well. That's because aggregation functions obey the usual rule of missing values: if there's any missing value in the input, the output will be a missing value. Fortunately, all aggregation functions have an na.rm argument which removes the missing values prior to computation.
flights %>% group_by(year,month,day) %>% summarise(mean = mean(dep_delay, na.rm=TRUE))# through setting the na.rm argument the mean values are all printed to the console. This is very interesting.

#In this case, where missing values represent cancelled flights, we could also tackle the problem by first removing the cancelled flights and saving the resulting tibble.
not_cancelled <- flights %>% filter(!is.na(dep_delay), !is.na(arr_delay))
not_cancelled %>% group_by(year,month,day) %>% summarise(mean=mean(dep_delay))

###Chapter 5.6.3 Counts:
#Whenever you do any aggregation, it's always a good idea to include either a count (n()), or a count of non-missing values (sum(!is.na(x))). That way you can check that you're not drawing conclusions based on very small amounts of data. 

#The following code finds the flights that have the highest delays.
delays <- not_cancelled %>% group_by(tailnum) %>% summarise(delay=mean(arr_delay))
ggplot(data=delays, mapping =aes(x=delay)) + geom_freqpoly(binwidth=10)

#We can get more insight if we draw a scatterplot of number of flights vs. average delay:
delays <- not_cancelled %>% group_by(tailnum) %>% summarise(delay=mean(arr_delay, na.rm=TRUE), n=n())
ggplot(data=delays, mapping=aes(x=n, y=delay)) + geom_point(alpha=1/10)
#The line of code writes a scatterplot that maps the number of flights according to the amount of time they were delayed. Very interesting but I have to admit that I don't understand how that code works as of yet. The main point of confusion is the calculating the mean of the delay times for all the flights. Will need to experiment a little more to understand what I'm not really understanding.

#Not surprisingly, there is much greater variation in the average delay when there are few flights. The shape of this plot is very characteristic: whenever you plot a mean (or other summary) vs. group size, you'll see that the variation decreases as the sample size increases. When looking at this sort of plot, it's often useful to filter out the groups with the smallest numbers of observations, so you can see more of the pattern and less of the extreme variation in the smallest groups. this is what the following code does, as well as showing you a handy patter for integrating ggplot2 into dplyr flows. 

delays %>% filter(n>25) %>% ggplot(mapping=aes(x=n, y=delay)) + geom_point(alpha=1/10)

#There's another common variation of this type of pattern. Let's look at how the average performance of batters in baseball is related to the number of times they're at bat. Here I use data from the Lahman package to compute the batting average (number of hits / number of attempts) of every major league baseball player.
#When I plot the skill of the batter (measured by the batting average, ba) against the number of opportunities to hit the ball (measured by at bat, ab). You see:
#	As above, the variation in our aggregate decreases as we get more data points.
#	There's a positive correlation between skill (ba) and opportunities to hit the ball (ab). this is because teams contol who gets to play, and obviously they'll pick their best player. 
#(additional) Curious though that the author only looks at the batting average and the at bat amount to look at the worth of a player. Though increased numbers of at bats might cause a player's batting average to increase, how will this increase affect the player's on base percentage. 

library(Lahman)
??Batting
batman <- as.tibble(Batting)
batmanners <- batman %>% group_by(playerID) %>% #One thing to note, the group_by() function arranges the tibble by alphabetical order. Hence the first player that will be averaged is abercda01. 
summarise(ba = sum(H, na.rm=TRUE) / sum(AB, na.rm=TRUE), ab = sum(AB,na.rm=TRUE))
batmanners %>% filter(ab > 100) %>% ggplot(mapping = aes(x=ab, y=ba)) + geom_point() + geom_smooth(se=FALSE) + labs(x="At Bats", y="Batting Average")

#(Little explorations of the Batting data frame):
arrange(Batting, desc(AB))

#This also has important implications for ranking. If you naively sort on desc(ba), the people with the best batting averages are clearlylucky, not skilled.
batmanners %>% arrange(desc(ba))

### Chapter 5.6.4 Useful summary functions:
#R provides many other useful summary functions:
#	Measures of location: we've used mean(x), but median(x) is also useful. The mean is the sum divided by the length; the median is a value where 50 percent of x is above it, and 50 percent is below it. It's sometimes useful to combine aggregation with logical subsetting. 

not_cancelled %>% group_by(year, month, day) %>% summarise(avg_delay1 = mean(arr_delay), avg_delay2 = mean(arr_delay[arr_delay>0]))
#Interesting for the avg_delay2 the author used a subsetting argument to narrow down the arr_delay column into only showing values that have over 0 minutes. I really didn't know that I can use subsetting statements on the same variables or matrix columns will need to look into this functionality later on through my studies.  

#	Measures of spread: sd(x), IQR(x), mad(x). the mean squared deviation, or standard deviation or sd for short, is the standard measure of spread. The interquartile range IRQ() and median absolute deviation mad(x) are robust equivalents that maybe more useful if you have outliers.
not_cancelled %>% group_by(dest) %>% summarise(distance_sd = sd(distance)) %>% arrange(desc(distance_sd))

#	Measures of rank: min(x), quantile(x, 0.25), max(). Quantiles are a generalisation of the median. For example, quantile(x, 0.25) will find a value of x that is greater than 25% of the values, and less than the remaining 75%.
not_cancelled %>% group_by(year,month,day) %>% summarise(first = min(dep_time), last = max(dep_time))

#	Measures of position: first(x), nth(x, 2), last(x). these work similarly to x[1], x[2], and x[length(x)] but let you set a default value if that position does not exist.
not_cancelled %>% group_by(year, month, day) %>% summarise(first_dep=first(dep_time), last_dep= last(dep_time))
#These functions are complementary to filtering on ranks. Filtering gives you all variables, with each observation in a separate row:
not_cancelled %>% group_by(year, month, day) %>% mutate(r= min_rank(desc(dep_time))) %>% filter(r %in% range(r))

#	Counts: you've seen n(), which takes no arguments, and returns the size of the current group. To count the number of non-missing values, use sum(!is.na(x)). To count the number of distinct (unique) values, use n_distinct(x).
#The following code will find which distinations have the most carriers.
not_cancelled %>% group_by(dest) %>% summarize(carriers = n_distinct(carrier)) %>% arrange(desc(carriers))

#counts are so useful that dplyr provides a simple helper if all you want is a count:
not_cancelled %>% count(dest)

#You can optionally provide a weight variable. For example, you could use this to count (sum) the total number of miles a plane flew.
not_cancelled %>% count(tailnum, wt=distance)

#	Counts and proportions of logical values: sum(x>10), mean(y==0). When used with numeric functions, TRUE is converted to 1 and FALSE to 0. This makes sum() and mean() very useful: sum(x) gives the number of TRUEs in x, and mean(x) gives the proportion.
not_cancelled %>% group_by(year, month, day) %>% summarise(n_early = sum(dep_time < 500))

not_cancelled %>% group_by(year, month, day) %>% summarise(hour_perc = mean(arr_delay > 60))
#This line finds the proportion of flights that are delayed by more than an hour.

### Chapter 5.6.5 Grouping by multiple variables:
#When you group by multiple variables, each summary peels off one level of the grouping. That makes it easy to progressively roll up a dataset.
daily <- group_by(flights, year, month, day) 
(per_day <- summarise(daily, flights=n()))
(per_month <- summarise(per_day, flights = sum(flights)))
(per_year <- summarise(per_month, flights = sum(flights)))
#Be careful when progressively rolling up summaries: it's ok for sums and counts, but you need to think about weighting means and variances, and it's not possible to do it exactly for rank-based statistics like the median. The sum of groupwise sums is the overall sum, but the median of groupwise medians is not the overall median.

###Chapter 5.6.6 Ungrouping 
#If you need to remove grouping, and return to operations on ungrouped data, use ungroup().
daily %>% ungroup() %>% summarise(flights = n())
daily %>% group_by(year, month, day) %>% summarise(flights=n())

### Chapter 5.6 Exercises:
#1.)
#a.) 
not_cancelled %>% group_by(tailnum) %>% count(pick = quantile(dep_delay,0.5)==15, sort=TRUE)
not_cancelled %>% group_by(tailnum) %>% filter(quantile(dep_delay,0.5)==15 & quantile(arr_delay,0.5)==15)
#b.)
not_cancelled %>% group_by(tailnum) %>% summarise(max(arr_delay)==10)
not_cancelled %>% group_by(tailnum) %>% filter(quantile(arr_delay,1)==10)
#c.)
not_cancelled %>% group_by(tailnum) %>% filter(quantile(dep_delay,0.5)==30 & quantile(arr_delay, 0.5)==30)
#d.)
not_cancelled %>% group_by(tailnum) %>% filter(quantile(arr_delay, 0.99)<=0 & quantile(dep_delay,0.01)==120)
#2.) 
not_cancelled %>% count(dest)
not_cancelled %>% count(tailnum, wt=distance)

#Attempt code:
not_cancelled %>% group_by(dest) %>% summarise(sum = n())# It seems that the author wanted me to create a line of code that didn't really on the count() function but still found the amount of flights that flew to each particular airport in the year 2013. Knowing this I used the group_by() function to group the tibble by the destination and I used to summarize() function in conjunction with n() (the counter argument). 
not_cancelled %>% group_by(tailnum) %>% summarise(sum = sum(distance))# I knew that the initial code was used to find the amount of miles an airplane flew when arriving at the NYC airport. And so I used the tailnumber of the airplane as the grouping criterion and used the sum() function to find the total distance traveled by all airplanes. 

#3.) 
flights[is.na(dep_delay) | is.na(arr_delay)]
flights$dep_delay
flights$arr_delay
#I believe that dep_delay is the most important column for seeing which flights were cancelled because if a flight will not leave the airport there wouldn't of course be a departure delay value next to it. And also arr_delay is a little misleading since in forecasting which flights are cancelled or are not cancelled an airplane an arrive into the airport only to be grounded due to unforeseen mechanical problems. 

#4.)
group_by(flights, year, month, day) %>% summarise(cancelled = sum(is.na(dep_delay)))
group_by(flights, year, month, day) %>% count(is.na(dep_delay))
#Pretty neat, both of these lines work perfectly. Really the pipe functions are very functional with this kind of work. I can't really comprehend how many steps I would have to do in order to create these values.

#5.) 
flights %>% group_by(carrier, dest) %>% summarise(n())
flights %>% group_by(carrier) %>% summarise(cancellations= sum(is.na(dep_delay)))
flights %>% group_by(dest) %>% summarise(cancellations = sum(is.na(dep_delay)))
flights %>% group_by(carrier) %>% summarise(departures = max(dep_delay, na.rm=TRUE))

#The best code I can write on this subject.
View(flights %>% group_by(origin, carrier) %>% summarise(departure_delay=max(dep_delay, na.rm=TRUE)))
#I believe that it's impossible to differentiate between a poor performing carrier and a poor performing airport because there really isn't a way to separate the two variables from the current data. I think that further data will need to be collected on airport and carrier performance. With that said though, carrier performance can very much be discerned within the data (flight cancellations and arrival and departure delay times that reach into the upper quartiles) but still the variables of weather interferance, airport traffic, runway length and number, etc can very much influence these numbers. 

#6.) 
??count()
#The documentation says that if the sort argument is set to TRUE the function will arrange the values in descending order of n (or rather the length of the tibble or data frame in rows). The default for the sort argument is FALSE.

### Chapter 5.7 Grouped mutates (and filters)
#Grouping is most useful in conjuction with summarise(), but you can also do convenient operations with mutate() and filter()
#Find the worst members of each group.
flights_sml <- select(flights, year, month, day, dep_delay, arr_delay, distance, air_time) 
flights_sml %>% group_by(year, month, day) %>% filter(rank(desc(arr_delay)) <10) 

#Find all groups bigger than a threshold:
popular_dests <- flights %>% group_by(dest) %>% filter(n()>365)
popular_dests

#Standardise to compute per group metrics:
popular_dests %>% filter(arr_delay > 0)  %>% mutate(prop_delay = arr_delay / sum(arr_delay)) %>% select(year:day, dest, arr_delay, prop_delay)

#A grouped filter is a grouped mutate followed by an ungrouped filter. I generally avoid them except for quick and dirty manipulations.
#Functions that work most naturally in grouped mutates and filters are known as window functions (vs. the summary functions used for summaries). Look into the vignette("window-functions") to learn more about the functionality of window functions.

### chapter 5.7 Exercises:
#1.) 
flights %>% group_by(dest) %>% filter(n() > 365) %>% filter(arr_delay > 0) %>% mutate(prop_dest = arr_delay/sum(arr_delay)) %>% select(year:day, dest, arr_delay, prop_dest)# Interestingly whne you still have the grouped pipe within this ungrouped latter argument the result is very much the same except for the fact that the prop_delay values are all printed within extremely high decimal places. Will need to look into if this is what the author meant by this question later on through my studies.

#2.) 
not_cancelled %>% group_by(tailnum) %>% filter(mean(arr_delay) > 300) %>% mutate(mean = mean(arr_delay)) %>% select(year:day, tailnum, mean)# Interestingly I'm not really sure if this tail number has the worst on-schedule record because with just running the code without the select() call you can see that the arr_delay for this particular airplane is 320. I'm not really sure if this is the averaged number that was obtained from combining all the instances of N844MH or if this was only one occurance. 
max(not_cancelled$arr_delay)# Interestingly after running this line I'm greeted with a value of 1272. does this include the airplane N844MH or is my syntax ignoring a plane that has an extremely high arrival delay record. Will need to look into this.

not_cancelled %>% group_by(tailnum) %>% filter(sum(arr_delay)) %>% mutate(sum_delay = sum(arr_delay)) %>% select(year:day, tailnum, sum_delay, arr_delay)# The arr_delay variable will be used to see if these values are automatically averaged by the console. After running this line I found that there are no sum arr_delay values that are over 50000 minutes in the data set. Will need to decrease the value a little more.

not_cancelled %>% group_by(tailnum) %>% filter(sum(arr_delay) >4000) %>% mutate(sum_delay = sum(arr_delay), mean_delay= mean(arr_delay)) %>% select(year:day, tailnum, sum_delay, mean_delay)# Pretty neat, through this line I can see the sum arrival delay values of all the airplanes coming into the NYC airport according to tail number. It seems that the more I run this code the more I'm seeing that the second line was more or less correct since the object of this exercise is to find the tail number with the highest mean arival value. I believe that taking out the year:day variables will help fix the clutter of my analysis.
flight_flea <- not_cancelled %>% group_by(tailnum) %>% filter(sum(arr_delay) >4000) %>% mutate(sum_delay = sum(arr_delay), mean_delay= mean(arr_delay)) %>% select(tailnum, sum_delay, mean_delay)

flight_flea %>% arrange(tailnum, desc(mean_delay))#Interesting insight,but still not sure if this code is actually the right answer for this excerise. 
not_cancelled %>% group_by(tailnum) %>% mutate(mean_delay=mean(arr_delay)) %>% select(tailnum, mean_delay) %>% arrange(desc(mean_delay))# I believe that I have the value. This is the right code for this exercise. 
flights %>% group_by(tailnum) %>% mutate(mean_delay = mean(arr_delay)) %>% select(tailnum, mean_delay) %>% arrange(desc(mean_delay))# the same values check out with the flights data set. So the conclusion of the not_cancelled data set being tampered with is false.

#3.)
flights %>% group_by(year, month, day, dep_time) %>% filter(mean(dep_delay) <= 0) %>% mutate(delay_mean = mean(dep_delay)) %>% select(year:dep_time, delay_mean) # I believe that I going in the right direction with this line, but I need to find out how to narrow down the resulting data frame. In other words, I need to code this data frame in such a way that extremely negative values are the only ones being printed.

flights %>% group_by(year, month, day, dep_time) %>% filter(mean(dep_delay) < -40) %>% mutate(delay_mean = mean(dep_delay), number = n()) %>% select(year:dep_time, delay_mean, number)

not_cancelled %>% group_by(year, month, day, dep_time) %>% filter(mean(dep_delay) > 0) %>% mutate(delay_mean = mean(dep_delay)) %>% select(year:dep_time, delay_mean) %>% arrange(desc(delay_mean)) %>% ggplot(aes(x=dep_time, y=delay_mean)) + geom_point()# Interestingly according to this chart the best times to leave is between 1:00 a.m. to about 4:50 a.m. Will need to see if these values are correct though. The problem with this exercise is that there are too many data points wot consider since I'm looking through thousands of data points.

not_cancelled %>% group_by(year, month, day, dep_time) %>% mutate(delay_mean = mean(dep_delay)) %>% select(year:dep_time, delay_mean) %>% arrange(delay_mean) %>% ggplot(aes(x=dep_time, y=delay_mean)) + geom_point() # Now I understand what I did wrong with my first code attempt. I only looked for one day where the average delay for a particular time frame was adnormally high. With this graph I'm looking through all the noise and I found a noticeable trend between 1 and 5 where there are no delays. But the problem with this analysis is that there are no negative outliers either. Will need to find out how I can expand on this graph to include lower values. 
#With that said though, the more conventional times that a passenger can leave is around 4:50 and 7:00 a.m. but again I might have to change the way I'm writing this code a little.

#4.) 
dest_flea <- not_cancelled %>% group_by(dest) %>%  mutate(arr_sum = sum(arr_delay), dep_sum = sum(dep_delay)) 
not_cancelled %>% group_by(dest) %>%  mutate(arr_sum = sum(arr_delay), dep_sum = sum(dep_delay)) %>% select(dest, arrr_sum, dep_sum) 
dest_flea %>% mutate(prop_arr = arr_delay / arr_sum, prop_dep = dep_delay/dep_sum) %>% select(dest, prop_arr, prop_dep, flight, arr_delay, dep_delay) #The math checks out. It seems that these solutions are the correct answers for this particular problem. 

#5.) 
not_cancelled %>% group_by(flight) %>% summarise(lag(dep_delay))# Don't understand how I'm supposed to conduct this problem will go back to this problem set later on through my studies.

#6.)
not_cancelled %>% group_by(dest) %>% mutate(speed = distance/(air_time/60)) %>% select(flight, dest, speed) %>% arrange(desc(speed))
not_cancelled %>% group_by(dest) %>% filter(distance < )# Again I'm not really sure about how this problem is supposed to be carried out. Will need to move onto the other problem Or rather work on this problem later on.

#7.) 
not_cancelled %>% group_by(dest) %>% filter(carrier>=2) %>% select(dest, carrier)# Note really sure if this line of code actually worked in narrowing the destinations that are serviced by more than one carrier. 
not_cancelled %>% group_by(dest) %>% count(carrier) %>% filter(carrier>1)# Still not sure if this line of code actually worked in answering this question.
not_cancelled %>% group_by(dest) %>% filter(carrier>1) %>% summarise(carriers =n_distinct(carrier)) #Interestingly this line of code was exactly what I was looking for but the main problem is that the filter() function failed to filter through the data frame taking out the airports that don't have more than one carrier.
not_cancelled %>% group_by(dest) %>% summarise(carriers = n_distinct(carrier)) %>% filter(carriers > 1)# this is exactly what the exercise expected. 

#8.)
not_cancelled %>% group_by(tailnum) %>% filter(!arr_delay > 60) %>% mutate(flights = n_distinct(flight)) %>% select(tailnum, flights) #Not really sure if this solution is really the correct answer for this problem. Most likely this solution did remove the flights that went over one hour (arrival delay) but still the tail numbers of these planes that did have the delayed flights most likely showed up again in the new data set (since not every one of their flights were delayed by more than one hour for the enirety of 2013). Most likely the best way to solve this problem is with an implicate loop. Will need to look into the solution for this problem.
not_cancelled %>% filter(!arr_delay >60) %>% group_by(tailnum) %>% summarise(flights= n_distinct(flight))# believe that this is the best I could do with my current proficiency with the R programming language.




   


