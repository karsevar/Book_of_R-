### chapter 16 Date and times:
library(tidyverse)
library(lubridate)
library(nycflights13)

### 16.2 Creating date/times:
#Note %/% is integer division, divide and throw away the remainder. %% calculates the modulus (remainder of division). For example to test for an even number: x %% 2 == 0, or odd x %% 2 == 1. To get the thousands value of a number x %/% 1000

make_datetime_100 <- function(year, month, day, time) {
	make_datetime(year, month, day, time %/% 100, time %% 100)
}

flights_dt <- flights %>%
	filter(!is.na(dep_time), !is.na(arr_time)) %>%
	mutate(
		dep_time = make_datetime_100(year, month, day, dep_time),
		arr_time = make_datetime_100(year, month, day, arr_time),
		sched_dep_time = make_datetime_100(year, month, day, sched_dep_time), 
		sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
		) %>%
		select(origin, dest, ends_with("delay"), ends_with("time"))
		
flights_dt %>% head

#times are often stored as integers since a reference time, called epoch. The most epoch is the UNIX Epoch of January 1st, 1970 00:00:00. So, interally, times are stored as the number of days, seconds, or milliseconds, etc. since the 1970 01-01 00:00:00.000.

as_datetime(60*60*10)
as_date(365 * 10 + 2)
as_datetime(10*10*10)# Now I understand the each numerical value is a number of seconds and the function divides the seconds by 60 for minutes and then sixty afterwards for number of hours etc. 

#there are three types of date/time data that refer to an instant in time:
	#A date. tibbles print this as <date>.
	#A time within a day. Tibbles print this as <time>.
	#A date_time is a date plus a time: it uniquely identifies an instant in time (typically to the nearest second). Tibbles print this as <dttm>. Elsewhere in R these are called POSIXct.
	
#In this chapter we are only going to focus on dates and date-times as R doesn't have a native class for storing times. If you need one, you can use the hms package. 

#You should always use the simplest possible data type that works for your needs. That means if you can use a date instead of a date-time you should. Date-times are substantially more complicated because of the need to handle time zones, which we'll come back to at the end of the chapter.

#To get the current date or date-time you can use today() or now():
today()
now()

#Otherwise, there are three ways you're likely to create a date/time:
	#From a string.
	#From individual date-time components.
	#From an existing date/time object.
	
### chapter 16.2.1 From strings:
#Date/time data often comes as strings. You've seen one approach to parsing strings into date-times in date-times. Another approach is to use the helper provided by lubridate. They automatically work out the format once you specify the order of the component. To use them, identify the order in which year, month, and day appear in your dates, then arrange "y", "m" and "d" in the same order. That gives you the name of the lubridate function that will parse your date.

ymd("2017-01-31")
mdy("January 31st, 2017")
dmy("31-Jan-2017")

#These functions also take unquoted numbers. This is the most concise way to create a single date/time object, as you might need when filtering date/time data. ymd() is short and unambiguous:
ymd(20170131)

#ymd() and friends create dates. To create a date-time, add an underscore and one or more "h", "m", and "s" to the name of the parsing function:
ymd_hms("2017-01-31- 20:11:59")
mdy_hm("01/31/2017 08:01")

#You can also force the creation of a date-time from a date by supplying a timezone:
ymd(20170131, tz = "UTC")

### chapter 16.2.2 From individual components:
#Instead of a single string, sometimes you'll have the individual components of the date-time spread across multiple columns. This is what we have in the flights data:
flights %>%
	select(year, month, day, hour, minute)
	
#To create a date/time from this sort of input, use make_date() for dates, or make_datetime() for date-times:
flights %>%
	select(year, month, day, hour, minute) %>%
	mutate(departure= make_datetime(year, month, day, hour, minute))
	
#Let's do the same thing for each of the four time columns in flights. The times are represented in a slightly odd format, so we use modulus arithmetic to pull out the hour and minute components. Once I've created the date-time variables, I focus in on the variables we'll explore in the rest of the chapter:

make_datetime_100 <- function(year, month, day, time) {
	make_datetime(year, month, day, time %/% 100, time %% 100)
}

flights_dt <- flights %>%
	filter(!is.na(dep_time), !is.na(arr_time)) %>%
	mutate(
		dep_time = make_datetime_100(year, month, day, dep_time),
		arr_time = make_datetime_100(year, month, day, arr_time),
		sched_dep_time = make_datetime_100(year, month, day, sched_dep_time), 
		sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
		) %>%
		select(origin, dest, ends_with("delay"), ends_with("time"))
		
flights_dt %>% head

#Now I understand the make_datetime_100() function that the author created was designed to split the hour and minute values for the arr_time, dep_time, sched_dep_time, and sched_arr_time categories into actual minutes and hours mobulus division (using the syntax %% for remainders and %/% for whole integers). The author knew that the console thinks that the time values are recognized as whole numbers that go up to the hundredths place and so dividing each time value by 100 will be the best move. 

#With this data, I can visualise the distribution of departure times across the year:
flights_dt %>%
	ggplot(aes(dep_time)) + 
	geom_freqpoly(binwidth = 86400) #Since there are 86400 seconds in one day.

#Or within a single day:
flights_dt %>%
	filter(dep_time < ymd(20130102)) %>%
	ggplot(aes(dep_time)) + 
	geom_freqpoly(binwidth = 600) # 600 seconds in 10 minutes
	
#Note that when you use data-times in a numeric context (like in a histogram), 1 means 1 second, so binwidth of 86400 means one day. For dates, 1 means 1 day.

### chapter 16.2.3 From other types:
# You may want to switch between a date-time and a date. That'sthe job of as_datetime() and as_date():
as_datetime(today())
as_date(now())

#Sometimes you'll get date/times as numeric offsets from the "Unix Epoch", 1970-01-01. If the offset is in seconds , use as_datetime(); if it's in days, use as_date().
as_datetime(60*60*10)
as_date(365 * 10 + 2)

### chapter 16.2.4 Exercises:
#1.)
ymd(c("2010-10-10", "bananas"))# the result was the console prints a warning message saying that "one format failed to parse." Thus meaning the this function can only parse through objects that the package deems as dates and times. The ymd() function signifier illustrates that the package is looking for an object (or rather objects in this case) that is organized from year, month, and day. 

#2.)
??today()# According to the documentation the tzone argument is a character vector specifying which time zone you would like to find the current date of. tzone defaults to the sytem time zone set on you computer. In other words, you can look at different times around the world through setting tzone to different character vector values.

#3.)
d1 <- "January 1, 2010"
mdy(d1)
d2 <- "2015-Mar-07"
ymd(d2)
d3 <- "06-Jun-2017"
dmy(d3)
d4 <- c("August 19 (2015)", "July 1 (2015)")
mdy(d4)
d5 <- "12/30/14"
mdy(d5)

### chapter 16.3 Date-time components:
#Now that you know how to get date-time data into R's date-time structures, let's explore what you can do with them. This section will focus on the accessor functions that let you get and set individual components. The next section will look at how arithmetic works with date-times.

### chapter 16.3.1 Getting components:
#You can pull out individual parts of the date with the accessor functions year(), month(), mday() (day of the month), yday() (day of the year), wday(day of the week), hour(), minute(), and second().
datetime <- ymd_hms("2016-07-08 12:34:56")
year(datetime)
month(datetime)
mday(datetime)
yday(datetime)
wday(datetime)

#For month() and wday() you can set label = TRUE to return the abbreviated name of the month or day of the week. Set abbr = FALSE to return the full name.
month(datetime, label = TRUE)
wday(datetime, label = TRUE, abbr = FALSE)

#We can use wday() to see that more flights depart during the week than on the weekend:
flights_dt %>%
	mutate(wday= wday(dep_time, label = TRUE)) %>%
	ggplot(aes(x = wday)) + 
	geom_bar()
	
#There's an interesting pattern if we look at the average departure delay by minute within the hour. It looks like flights leaving in minutes 20-30 and 50-60 have much lower delays than the rest of the hour!
flights_dt %>%
	mutate(minute = minute(dep_time)) %>%
	group_by(minute) %>%
	summarise(
		avg_delay = mean(arr_delay, na.rm = TRUE),
		n = n()) %>%
	ggplot(aes(minute, avg_delay)) +
		geom_line()
		
#Interestingly, if we look at the scheduled departure time we don't see such a strong pattern.
sched_dep <- flights_dt %>%
	mutate(minute = minute(sched_dep_time)) %>%
	group_by(minute) %>%
	summarise(
		avg_delay = mean(arr_delay, na.rm = TRUE),
		n = n()) 

ggplot(sched_dep, aes(minute, avg_delay)) + geom_line()

#So why do we see that pattern with a acutal departure times? Well, like much data collected by humans, there's a strong bias towards flights leaving at "nice" departure times. Always be alert for this sort of pattern whenever you work with data that involves human judgement.
ggplot(sched_dep, aes(minute, n)) + geom_line()

### chapter 16.3.2 Rounding:
#An alternative approach to plotting individual components is to round the date to a nearby unit of time, with floor_date(), round_date(), and ceiling_date(). Each function takes a vector of dates to adjust and then the name of the unit round down (floor), round up (ceiling), or round to. This, for example, allows us to plot the number of flights per week.

flights_dt %>%
	count(week = floor_date(dep_time, "week")) %>%
	ggplot(aes(week, n)) + geom_line()
	
### chapter 16.3.3 Setting components:
#You can also use each accessor function to set the components of a date/time:
(datetime <- ymd_hms("2016-07-08 12:34:56"))
year(datetime) <- 2020
datetime
month(datetime) <- 01
datetime
hour(datetime) <- hour(datetime) + 1
datetime 
#Interesting through the commands hour(), month(), year(), and day() you can change the components within a date time R structured string. This command seems just like the base R replace() and which() functions.

#Alternatively, rather than modifying in place, you can create a new date-time with update(). This also allows you to set multiple values at once.
update(datetime, year = 2020, month = 2, mday = 2, hour = 2)

#If values are too big, they will roll over:
ymd("2015-02-01") %>%
	update(mday = 30)
	
ymd("2015-02-01") %>%
	update(hour = 400)
	
flights_dt %>%
	mutate(dep_hour = update(dep_time, yday = 1)) %>%
	ggplot(aes(dep_hour)) + 
		geom_freqpoly(binwidth = 300)
		
#Setting larger components of a date to a constant is a powerful technique that allows you to explore patterns in the smaller components.

### chapter 16.3.4 Exercise:
#1.)
make_datetime_100 <- function(year, month, day, time) {
	make_datetime(year, month, day, time %/% 100, time %% 100)
}

flights_dt <- flights %>%
	filter(!is.na(dep_time), !is.na(arr_time)) %>%
	mutate(
		dep_time = make_datetime_100(year, month, day, dep_time),
		arr_time = make_datetime_100(year, month, day, arr_time),
		sched_dep_time = make_datetime_100(year, month, day, sched_dep_time), 
		sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
		) %>%
		select(origin, dest, ends_with("delay"), ends_with("time"))

# Sadly I can't really think of a possible answer for this problem. Will really need to brush up on everything in this book. 

#Author's solution:
flights_dt %>%
	mutate(time = hour(dep_time) * 100 + minute(dep_time), mon = as.factor(month(dep_time))) %>%
	ggplot(aes(x = time, group = mon, color = mon)) + geom_freqpoly(binwidth = 100)
# This initial code plots the data according to month of the year.

#Now I understand what he did. Through creating the pipe mutate(time = hour(dep_time) * 100 + minute(dep_time) the author is converting the dep_time category back into displaying hours with minutes as one value without breaks. And the pipe as.factor(month(dep_time)) converts the months of the year into a factor data structure that can be used as a aesthetics map for the freqpoly() graphic. 

#This will look better if everything is normalized within groups. The reason that February is lower is that there are fewer days and thus fewer flights.

flights_dt %>%
	mutate(time = hour(dep_time) * 100 + minute(dep_time), mon = as.factor(month(dep_time))) %>%
	ggplot(aes(x = time, y = ..density.., group = mon, color = mon)) + geom_freqpoly(binwidth = 100)
	
#2.)
flights_me <- flights_dt %>%
	mutate(depart = hour(dep_time) * 100 + minute(dep_time), schedule_dep = hour(sched_dep_time) *100 + minute(sched_dep_time), sched_mon = as.factor(month(sched_dep_time)), dep_mon = as.factor(month(sched_dep_time)), delay_mon = as.factor(month(dep_delay))) 

flights_depart <- flights_me %>% 
	ggplot(aes(x = depart, y = ..density.., group = dep_mon, color = dep_mon)) + geom_freqpoly(binwidth =100)
	
flights_schedule <- flights_me %>%
	ggplot(aes(x = schedule_dep, y = ..density.., group = sched_mon, color = sched_mon)) + geom_freqpoly(binwidth = 100)

flights_delay <- flights_me %>% ggplot(aes(x = dep_delay, y = ..density.., group = delay_mon, color = delay_mon)) + geom_freqpoly(binwidth = 100)

library(gridExtra)
grid.arrange(flights_schedule, flights_depart)

#I believe that this solution is not what the author had in mind. Will need to look into the author's solutions. Again I really need to brush up on the contents of this text book.

#Author solution:
flights_dt %>%
	mutate(dep_time_ = sched_dep_time + dep_delay * 60) %>%
	filter(dep_time_ != dep_time) %>%
	select(dep_time_, dep_time, sched_dep_time, dep_delay)
#There exist discrepencies. It looks like there are mistakes in the dates. These are flights in which the actual departure time is on the next day relative to the scheduled depart time.We forgot to account for this when creating the date-times. The code would have had to check if the departure time is less than the scheduled departure time. Alternatively, simply adding the delay time is more robust because it will automatically account for crossing into the next day.

#3.)
flights_dt %>%
	group_by(origin, dest) %>%
	mutate(departure_time = hour(dep_time) * 60 + minute(dep_time), arrival_time = hour(arr_time) * 60 + minute(arr_time), air_time_alpha = arrival_time - departure_time, duration = air_time - air_time_alpha) %>% summarise(mean_duration = mean(air_time_alpha, na.rm = TRUE))
# Neat this solution was actually correct except for the fact that the author obtained the difference between flight duration and airtime through subtracting airtime by flight duration.
	
flights_dt %>%
	group_by(origin) %>%
	mutate(departure_time = hour(dep_time) * 60 + minute(dep_time), arrival_time = hour(arr_time) * 60 + minute(arr_time), air_time_alpha = arrival_time - departure_time, duration = air_time - air_time_alpha) %>% summarise(mean_duration = mean(air_time_alpha, na.rm = TRUE))
	
flights_dt %>%
	group_by(dest) %>%
	mutate(departure_time = hour(dep_time) * 60 + minute(dep_time), arrival_time = hour(arr_time) * 60 + minute(arr_time), air_time_alpha = arrival_time - departure_time, duration = air_time - air_time_alpha) %>% summarise(mean_duration = mean(air_time_alpha, na.rm = TRUE))
	
#Author's solution:
flights_dt %>%
	mutate(flight_duration = as.numeric(arr_time - dep_time), 
		air_time_mins = air_time,
		diff = flight_duration - air_time_mins) %>%
	select(origin, dest, flight_duration, air_time_mins, diff)
	
#4.)
#author's solution:
#Use sched_dep_time because that is the relevant matric for someone scheduling a flight. Also, using dep_time will always bias delays to later in the day since delays will push flights later:
flights_dt %>%
	mutate(sched_dep_hour = hour(sched_dep_time)) %>%
	group_by(sched_dep_hour) %>%
	summarise(dep_delay = mean(dep_delay)) %>%
	ggplot(aes(y= dep_delay, x = sched_dep_hour)) + 
	geom_point() +
	geom_smooth()
#I can't believe that I didn't think of this method. This is very simplistic and easy to implement with the knowledge that I already have about data science and the dplyr package.

#Now that I know the answer, I can now calculate the mean(delay) with the dep_time only:
flights_dt %>%
	mutate(dep_hour = hour(dep_time)) %>%
	group_by(dep_hour) %>%
	summarise(dep_delay = mean(dep_delay)) %>% 
	ggplot(aes(y = dep_delay, x = dep_hour)) + geom_point() + geom_smooth()
#This code creates a very odd curve for the data that was inputted. Unlike what the author said about using the departure time in place of the scheduled departure time, the curve actually shows that the departure delays were more prominent earlier in the day. Will need to see if the code is correct.

#5.)
flights_dt %>%
	mutate(sched_dep_day = as.factor(wday(sched_dep_time))) %>%
	group_by(sched_dep_day) %>%
	summarise(dep_delay = mean(dep_delay)) %>% 
	ggplot(aes(x = dep_delay, y = ..density.., group = sched_dep_day, color = sched_dep_day)) + geom_freqpoly(binwidth = 0.1)
# I guess this code was a little too ambitious for this problem and my current skills. The central idea around this solution is to create a freqpoly graphic illustrating the density of delays for each day of the week. I believe that I will have to create or find a better x axis variable for this graphic.
#Perhaps if I create the same sched_dep_hour for each day in the question 4 data set.
flights_dt %>%
 	mutate(sched_dep_day = as.factor(wday(sched_dep_time)), sched_dep_hour = hour(sched_dep_time)) %>%
 	group_by(sched_dep_day, sched_dep_hour) %>%
 	summarise(dep_delay = mean(dep_delay)) %>%
 	ggplot(aes(x = sched_dep_hour, y = dep_delay)) + geom_boxplot() + facet_grid(~sched_dep_day)
#I believe that this graphic is a better solution for this problem. According to the boxplot Sunday, Tuesday, and Saturday are the best days to fly. 

#Experiment splitting the days of the week with facet_wrap() and using geom_point() and geom_smooth() to create their own departure delay curves:
flights_dt %>%
 	mutate(sched_dep_day = as.factor(wday(sched_dep_time)), sched_dep_hour = hour(sched_dep_time)) %>%
 	group_by(sched_dep_day, sched_dep_hour) %>%
 	summarise(dep_delay = mean(dep_delay)) %>%
 	ggplot(aes(x = sched_dep_hour, y = dep_delay)) + geom_point() + geom_smooth() + facet_wrap(~sched_dep_day)

#This solution is a little more simplistic than the one displayed above. According to this graphic Tuesday is the best day to schedule a flight. But still the confidence intervals are a little too large  for me to make a any definitive conclusions.   
 flights_dt %>%
 	mutate(sched_dep_day = wday(sched_dep_time)) %>%
 	group_by(sched_dep_day) %>%
 	summarise(dep_delay = mean(dep_delay)) %>%
 	ggplot(aes(y = dep_delay, x = sched_dep_day)) + geom_point() + geom_smooth()

#Author solution:
flights_dt %>%
	mutate(dow = wday(sched_dep_time)) %>%
	group_by(dow) %>%
	summarise(dep_delay = mean(dep_delay), 
		arr_delay = mean(arr_delay, na.rm = TRUE))
#In retrospect, this is a better solution. It's embarrassing that I didn't think of the solution in this context. 

#6.)
sched_dep <- flights_dt %>%
	mutate(minute = minute(sched_dep_time)) %>%
	group_by(minute) %>%
	summarise(
		avg_delay = mean(arr_delay, na.rm = TRUE), 
		n = n())
		
diamonds %>%
	group_by(carat) %>%
	summarise(
		n = n()) %>%
	ggplot(aes(carat, n), xlim = 3) + 
		geom_line()

#Author solution:
#I really can't believe that I didn't think of making a historgram or a density chart for this problem. Using the density geometric layer is the best way to go about concluding whether this distribution illustrates human bias or is randomly distributed.	
diamonds %>%
	ggplot(aes(carat)) +
	geom_density()
	
#In both, carat and sched_dep_time there are abnormally large numbers of values that are at nice human numbers. In sched_dep_time it is at 00 and 30 minutes. In carats, it is at 0, 1/3. 1/2, 2/3.
ggplot(diamonds, aes(x = carat %% 1)) +
	geom_histogram(binwidth = 0.01)
	
#In scheduled departure times it is 00 and 30 minutes, and minutes ending in 0 and 5.
ggplot(flights_dt, aes(x = minute(sched_dep_time))) + 
	geom_histogram(binwidth = 1)
	
#7.)
flights_dt %>%
	mutate(early = dep_delay < 0,
	minute = minute(sched_dep_time)) %>%
	group_by(minute) %>%
	summarise(early = mean(early)) %>%
	ggplot(aes(x = minute, y = early)) +
	geom_point()
	
#But if grouped in 10 minutes intervals, there is a higher proportion of early flights during those minutes.
flights_dt %>%
	mutate(early = dep_delay <0, 
	minute = minute(sched_dep_time) %% 10) %>%
	group_by(minute) %>%
	summarise(early = mean(early)) %>%
	ggplot(aes(x = minute, y = early)) + 
	geom_point() + geom_line()

### chapter 16.4 Times spans:
#Along the way, you'll learn about three important classes that represent time spans:
	#duration, which represent an exact number of seconds.
	#periods, which represent human units like weeks and months.
	#intervals, which represent a starting and ending point.
	
### chapter 16.4.1 Durations:
#In R, when you subtract two dates, you get a difftime object:
h_age <- today() - ymd(19791014)
h_age

#A difftime class object records a time span of seconds, minutes, hours, days, or weeks. This ambiguity can make difftimes a little painful to work with, so lubridate provides an alternative which always uses seconds: the duration.

as.duration(h_age)

#Durations come with a bunch of convenient constructors:
dseconds(15)
dminutes(10)
dhours(c(12, 24))
ddays(0:5)
dweeks(3)
dyears(1)

#Durations always record the time span in seconds. Larger units are created by converting minutes, hours, days, weeks, and years to seconds at the standard rate (60 seconds in a minute, 60 minutes in an hour, 24 hours in a day, 7 days in a week, 365 days in a year). 

#You can add and multiply durations:
2 * dyears(1)
dyears(1) + dweeks(12) + dhours(15)

#You can add and subtract durations to and from days:
tomorrow <- today() + ddays(1)
last_year <- today() - dyears(1)

#However, because durations represent an exact number of seconds, sometimes you might get an unexpected result:
one_pm <- ymd_hms("2016-03-12 13:00:00", tz = "America/New_York")
one_pm
one_pm + ddays(1)
#Why is one day after 1 pm on March 2, 2 pm on March 13? If you look carefully at the date you might also notice that the time zones have changed. Because of DST, March 12 only has 23 hours, so if add a full days worth of seconds we end up with a different time.

### chapter 16.4.2 Periods:
#To solve this problem, lubridate provides periods. Periods are time spans but don't have a fixed length in seconds, instead they work with human times, like days and months. That allows them to work in more intuitive ways:
one_pm 
one_pm + days(1)

#Like durations, periods can be created with a number of friendly contructor functions:
seconds(15)
minutes(10)
hours(c(12,24))
days(7)
months(1:6)
weeks(3)
years(1)

#You can add and multiply periods:
10 * (months(6) + days(1))
days(50) + hours(25) + minutes(2)

#And of course, add them to dates. Compared to durations, periods are more likely to do what you exprect:
ymd("2016-01-01") + dyears(1)
ymd("2016-01-01") + years(1)

#Daylight Savings Time:
one_pm + ddays(1)
one_pm + days(1)

#Let's use periods to fix an oddity related to our flight dates. some planes appear to have arrived at their destination before they departed from New York City.
flights_dt %>%
	filter(arr_time < dep_time)
	
#These are overnight flights. We used the same date information for both the departure and the arrival times, but these flights arrived on the following day. We can fix this by adding days(1) to the arrival time of each overnight flight.

flights_dt <- flights_dt %>%
	mutate(
		overnight = arr_time < dep_time,
		arr_time = arr_time + days(overnight * 1),
		sched_arr_time = sched_arr_time + days(overnight * 1)
) 

#Now all of our flights obey the laws of physics:
flights_dt %>%
	filter(overnight, arr_time < dep_time)
	
### chapter 16.4.3 Intervals:
#It's obvious what dyears(1) / ddays(365) should return: one, because durations are always represented by a number of seconds, and a duration of a year is defined as 365 days worth of seconds.

#what should years(1) / days(1) return? Well, if the year was 2015 it should return 365, but if it was 2016, it should return 366! There's not quite enough information for lubridate to give a single clear answer. What if does instead is give an estimate, with a warning:
years(1) / days(1)

#If you want a more accurate measurement, you'll have to use an interval. An interval is a duration with a starting point: that makes it precise so you can determine exactly how long it is:
next_year <- today() + years(1)
(today() %--% next_year) / ddays(1)

#To find out how many periods fall into an interval, you need to use integer division;
(today() %--% next_year) %/% days(1)

### chapter 16.4.5 Exercises:
#1.)
dyears(1) + dweeks(12) + dhours(15)
years(1) + weeks(12) + hours(15)
??dmonths()
??months()
#To begin, the dmonth() function should be used as a computer duration counting method, but the problem with this method is that it's counter intuitive for humans as illustrated by the example: 
one_pm <- ymd_hms("2016-03-12 13:00:00", tz = "America/New_York")
one_pm 
one_pm + ddays(1)
one_pm + days(1)
# through this example you can see that the ddays() example illustrates that the value from one_pm + ddays(1) moved a calendar day and an hour while the example one_pm + days(1) only moved in calendar days (as expected). Both examples are corrected, but sometimes it's important to use the periods functions for human read calendar data and use the duration function for computer calculations. 

#I take back this solution; I have to say that the reason for there being no duration function for months and a period months() function is because months are purely a human construct that has no mathematical barring. Because of that duration function notation omits month functions from its syntax.

#2.)
flights_dt <- flights_dt %>%
	mutate(
		overnight = arr_time < dep_time,
		arr_time = arr_time + days(overnight * 1),
		sched_arr_time = sched_arr_time + days(overnight * 1)
)
#Author solution:
#Overnight is equal to TRUE and FALSE. So if it is an overnight flight, this becomes 1 day, and if not, then overnight = 0, and no days are added to the date.

#3.)
#A vector of the first day of the month for every month in 2015:
ymd("2015-01-01") + months(0:11)

#To get the vector of the first day of the month for this year, we first need to figure out what this year is, and get January 1st of it. I can do that by taking today() and truncating it to the year using floor_date():
floor_date(today(), unit = "year") + months(0:11)

#4.)
bbirth <- function(bday) {
	(bday %--% today()) %/% years(1)
}
bbirth(ydm("1992-02-01"))

#5.)
(today() %--% (today() + years(1))) / months(1)
#Author solution:
#It appears to work. Today is a date. Today + 1 year is a valid endpoint for an interval. And months is period that is defined in this period.

###Chapter 16.5 Time zones:
#The first challenge is that everyday names of time zones tend to be ambiguous. For example, if you're American you're probably familiar with EST, or Eastern Standard Time. However, both Autralia and Canada also have EST! To aviod confusion, R uses the international standard IANA time zones. These use a consistent naming scheme "/", typically in the form "<continent>/<city>" (there are a few exceptions because not every country lies on a continent). 

Sys.timezone()# That's interesting R doesn't know my current timezone. I think I might have to fix this problem.

length(OlsonNames())
head(OlsonNames())# This command gives me all the times zones recorded on R.

#In R, the time zone is an attribute of the date-time that only controls printing. For example, these three objects represent the same instant in time.
(x1 <- ymd_hms("2015-06-01 12:00:00", tz = "America/New_York"))
(x2 <- ymd_hms("2015-06-01 18:00:00", tz = "Europe/Copenhagen"))
(x3 <- ymd_hms("2015-06-02 04:00:00", tz = "Pacific/Auckland"))

#You can verify that they're the same time using subtraction:
x1 - x2
x1 - x3# these lines return a zero second printout on the console.

#Unless otherwise specified, lubridate always uses UTC. UTC is the standard time zone used by the scientific community and roughly equivalent to its predecessor GMT (Greenwich Mean Time, this is much like the prime marigian which is also in Greenwich). It does not have DST, which makes a convenient representation for computation. Operations that combine date-times, like c(), will often drop the time zone. In that case, the date-times will display in your local time zone.
x4 <- c(x1, x2, x3)
x4

#You can change the time zone in two ways:
	#Keep the instant in time the same, and change how it's displayed. Use this when the instant is correct, but you want a more natural display.
x4a <- with_tz(x4, tzone = "Australia/Lord_Howe")
x4a
x4a-x4

#(This also illustrates another challenge of times zones: they're not all integer hour offsets).

	#Change the underlying instant in time.Use this when you have an instant that has been labelled with the incorrect time zone, and you need to fix it. 
x4b <- force_tz(x4, tzone = "Australia/Lord_Howe")
x4b


