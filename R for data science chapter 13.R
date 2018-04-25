### chapter 13 Relational data:
### chapter 13.1 Introduction:
library(tidyverse)
#It's rare that a data analysis involves only a single table of data. Typically you have many tables of data, and you must combine them to answer the questions that you're interested in. Collectively, muliple tables of data are called relational data because it is the relations, not just the individual datasets, that are important.

#Relations are always defined between a pair of tables. All other relations are built up from this simple idea: the relations of three or more tables are always a property of the relations between each pair. Sometimes both elements of a pair can be the same table! This is needed if, for example, you have a table of people, and each person has a reference to their parents.

#To work with relational data you need verbs that work with pairs of tables. There are three families of verbs designed to work with relational data:
#	Mutating joins, which add new variables to one data frame from matching observations in another.
#	Filtering joins, which filter observations from one data frame based on whether or not they match an observationin the other table.
#	Set operations, which treat observations as if they were set elements.

#The most common place to find relational data is in a relational database management system, a term that encompasses almost all modern databases. Generall, dplyr is a little easier to use than SQL because dplyr is specialised to do data analysis: it makes common data analysis operations easier, at the expense of making it more difficult to do other things that aren't commonly needed for data analysis. 

### chapter 13.2 nycflights13:
library(nycflights13)
library(tidyverse)
#This chapter will use the airlines dataset within the nycflights13 package.

#In addition there are four different flights datasets in all:
	#airlines lets you look up the full carrier name from its abbreviated code.
airlines

	#airports gives information about each airport identified by the faa airport code:
airports

	#planes give you information about each plane, identified by its tailnum:
planes

	#weather gives the weather at each NYC airport for each hour.
weather

#For nycflights13: 
#	flights connects to planes via a single variable, tailnum.
#	flights connects to airlines through the carrier variable.
#	flights connects to airports in two ways: via the origin and dext variables.
#	flights connects to weather via origin (the location), and year, month, day, hour (the time). 

### Chapter 13.2.1 Exercises:
#1.)
# I believe that you would need to consult the weather, planes, and airports tables in order to draw the approximate route each plane flies from its origin to its desination because:
	#the weather table contains the origin data of each of the flights (which is the same data used in the flights dataset).
	#the planes dataset contains the tailnumbers of all the planes in the flights dataset hence helping us differentiate the origins from the weather dataset and the airport variables (which I'll get into soon). 
	# the airports dataset contains the coordinates of each airport which (I believe) can be used to extrapolate the relative destinations of each flight. 

#Will need to check these conclusions with the author's solutions: I myself believe that my conclusions on the datasets and variables that I will use to answer this question are dubious at best.

#Author's solution:
#flights table: origin and dest
#airports table: longitude and latitude variables
#we would merge the flights with airports twice: one to get the location of the origin airport, and once to get the location of the dest airport.

#2.) 
# to begin, the weather dataset contains the hourly meterological data for LGA, JFK, and EWR. The variables include:
	#origin: weather station, Named origin to faciliate merging with flights data.
	#year, month, day, hour: time of recording 
	#temp,dewp
	#humid
	#wind_dir, wind_speed, wind_gust
	#precip
	#pressure
	#visib
	#time_hour 

#the airports dataset contains the useful metadata about airports:
	#faa: FAA airport code
	#name: usual name of the airport 
	#lat, lon: location of the airport 
	#alt: altitude, in feet 
	#tz: timezone offset from GMT
	#dst
	#tzone
	
#Author's solution;
#The variable origin in weather is matched with faa in airports.

#3.) 
#Author's solution:
#year, month, day, hour, origin in weather would be matched to year, month, day, hour, dest in flight (though it should use the arrival date-time values for dest if possible).

#4.)
#author's solution:
#I would add a tble of special dates. The primary key would be date. It would match to the year, month, day columns of flights.

### chapters 13.3 Keys:
# The variables used to connect each pair of tables are called keys. A key is a variable (or set of variables) that uniquely identifies an observation. In simple cases, a single variable is sufficient to identify an observation. For example, each plane is uniquely identified byits tailnum. In other cases, multiple variables may be needed. For example, to identify an observation in weather you need five variables: year, month, day, hour, and origin. 

#There are two types of keys:
	#A primary key uniquely identifies an observation in its own table. For example, planes$tailnum is a primary key because it uniquely identifies each plane in the planes table.
	#A foreign key uniquely identifies an observation in another table. For example, the flights$tailnum is a foreign key because it appears in the flights table where it matches each flight to a unique plane.
	
#Once you've identified the primary keys in your tables, it's good practice to verify that they do indeed uniquely identify each observation. One way to do that is to count() the primary keys and look for entries where n is greater than one:
planes %>% 
	count(tailnum) %>%
	filter(n > 1)
	
weather %>%
	count(year, month, day, hour, origin) %>%
	filter(n > 1)
	
#Sometimes a table doesn't have an explicit primary key: each row is an observation, but no combination of variables reliably identifies it. For example, what's the primary key in the flights table? You might think it would be the date plus the flight or tail number, but either of those are unique:
flights %>% 
	count(year, month, day, flight) %>%
	filter(n > 1)
	
flights %>%
	count(year, month, day, tailnum) %>%
	filter(n > 1)
	
#If a table lacks a primary key, it's sometimes useful to add one with mutate() and row_number(). That makes it easier to match observations if you've done come filtering and want to check back in with the original data. This is called a surrogate key.

#A primary key and the corresponding foreign key in another table form a relation. Relations are typically one  to many. For example, each flight has one plane, but each plane has many flights. In other words, you'll occasionally see a 1 to 1 relationship. You can think of this as a special case of 1 to many. For example, in this data there's a many-to-many relationship between airlines and airports: each airline flies to many airports; each airport hosts many airlines.

#1.) 
flights %>% 
	count(year, month, day, flight) %>%
	mutate(key = row_number())
	#I believe this is what the author meant by making your own unique surrogate key for each observation in the flight dataset. Will need to check with the solutions if this is what Wickham meant in the book.
	
#2.)
#a.)
Lahman::Batting
Lahman::Batting %>% 
	count(playerID) %>%
	filter(n > 1)
#Interesting so only using playerID for the count function illustrations that there are multiple observations for each player. Which makes sense after looking through the dataset since playerID is matched with a yearID as wel. this means that the count in the code above tells me how many years the player was signed into a major league baseball team. 
#I believe that yearID in conjunction with playerID will make for the perfect primary key for this dataset.
Lahman::Batting %>%
	count(playerID, yearID) %>%
	filter(n > 1)
#that's really weird. These two observations together still recorded for than one observation. I believed that the response might have been a little different. Are the years split up by seasons perhaps?
??Lahman::Batting
#Interesting. It seems that in place of recording the year in seasons the recorders recorded the player's career in league appearances meaning that a player can hypothetically be recorded in the same year under a major league team and a tripple A team. 
Lahman::Batting %>%
	count(playerID, yearID, teamID) %>% 
	filter(n > 1)
#As assumed I am missing another variable that is keeping this line from becaming a primary key. 

#Author's solution:
#It seems that; as stated by Wickham that the combination of playerID with stint (the order of appearances within a season) will give rise to a primary key. Will look into this.
Lahman::Batting %>%
	count(playerID, yearID, stint) %>%
	filter(n > 1)

#b.)	
library(babynames)
babynames
??babynames

#Just a little experiment:
babynames::babynames %>%
	count(year) %>%
	filter(n > 1)
#Interestingly enough, I can't really work on this dataset because when ever I attempt to return back a value after using a pipe an error message is returned back to the console saying that comparison (6) is possible only for atomic and list types. 
# Will keep if this dataset can be manipulated in RStudio.
# Weird even RStudio can't deal with this dataset. Will look into this problem later. 
babynames %>% 
	count(year, name, sex) %>%
	filter(n > 1)
#Despite that though, I believe that this is the right answer for this dataset.

#c.)
library(nasaweather)
#Little experiment:
atmos %>% 
	count(lat, long) %>%
	filter(n > 1) 
#Just as I suspected, there are more than 1 observation for each longitude and latitude observation. Each location seems to be split by the year and month. 

atmos %>%
	count(lat, long, year, month) %>%
	filter(n > 1)
#The perfect line of code that illustrates the primary key of this dataset.

#d.)
library(fueleconomy)
??vehicles
vehicles %>%
	count(model) %>%
	filter(1 < n)
# Just as I suspected there is more than one observation for the models in the dataset. I believe that id (the unique EPA identifier) will be the best candidate for the primary key. 
vehicles %>%
	count(id) %>%
	filter(n > 1)
#That is indeed the case. 

#e.)
diamonds
??diamonds

#A little experiment:
diamonds %>%
	count(carat) %>% 
	filter( n > 1)
#As I would assume, the continuous properties of the observations' carat values are in such a small bounds that it is only natural that there are diamonds with duplicate carat values. I wonder if I can use another continuous variable to fulfill the task of being a primary key for the dataset.

diamonds %>%
	count(depth) %>%
	filter(n > 1)
diamonds %>%
	count(x, y, z) %>%
	filter(n > 1) 
diamonds %>%
	count(x,y,z,depth,table,carat,price) %>%
	filter(n > 1)
# All of these variations didn't translate into primary keys. 

#Author's Solution:
#Wickham discrovered the same thing and so he created his own surrogate key. 
diamonds %>%
	mutate(key = row_number())
	
#3.)
#Will come back to this question.

### Chapter 13.4 Mutating joins:
# The first tool we'll look at for combining a pair of tables is the mutating join. A mutating join allows you to combine variables from two tables. It first matches observations by their keys, then copies across variables from one table to the other.
#Like mutate(), the join functions add variables to the right, so if you have a lot of variables alread, the new variables won't be printed out. 

library(nycflights13)
flights2 <- flights %>%
	select(year:day, hour, origin, dest, tailnum, carrier)
	
#Imagine you want to add the full airline name to the flights2 data. You can combine the airlines and flights2 dataframes with left_join():
flights2 %>%
	select(-origin, -dest) %>%
	left_join(airlines, by = "carrier") 

#the result of joining airlines to flights2 is an additional variable: name. This is why I call this type of join a mutating join. In this case, you could have got to the same place using mutate() and R's base subsetting:
flights2 %>%
	select(-origin, -dest) %>%
	mutate(name = airlines$name[match(carrier, airlines$carrier)])
	
#But this is hard to generalise when you need to match multiple variables and takes a close reading to figure out the overall intent.

### Chapter 13.4.1 Understanding joins:
#Representation on how joins work:
x <- tribble( 
	~key, ~val_x,
	1, "x1",
	2, "x2", 
	3, "x3"
)

y <- tribble(
	~key, ~val_y,
	1, "y1", 
	2, "y2",
	4, "y4"
)

# A join is a way of connecting each row in x to zero, one, or more rows in y. The following diagram shows each potential match as an intersection of a pair of lines.
#(If you look closely, you might notice that we've switched the order of the key and value columns in x. This is to emphasise the joins match based on the key; the value is just carried along for the ride).
#In an actual join, matches will be indicated with dots. The number of dots = the number of matches = the number of rows in the output.

### chapter 13.4.2 Inner join:
#The simplest type of join is the inner join. An inner join matches pairs of observations whenever their keys are equal.
#The output of an inner join is a new data frame that contains the key, the x values, and the y values. We use by to tell dplyr which variables is the key:
x %>%
	inner_join(y, by = "key")# The function skipped keys 3 and 4 because these places were not shared by the two tibbles.
	
#The most important property of an inner join is that unmatched rows are not included in the result. this means that generally inner joins are usually not appropriate for use in analysis because it's too easy to lose observations.

###Chapter 13.4.3 Outer joins:
#An inner join keeps observations that appear in both tables. An outer join keeps observations that appear in at least one of the tables. There are three types of outer joins:
	#A left join keeps all observations in x.
	#A right join keeps all observations in y.
	#A full join keeps all observations in x and y.

#these joins work by adding an additional virtual observation to each table. this observation has a key that always matches (if no other key matches), and a value filled with NA. 

### chapter 13.4.4 Duplicate keys:
#So far all the diagrams have assumed that the keys are unique. But that's not always the case. This section explains what happens when the keys are not unique. There are two possibilities:
	#1.) One table has duplicate keys. This is useful when you want to add in additional information as there is typically a one-to-many relationship 

#representation of this fact through code: (notice that in x the key is foreign and in y the key column is foreign).
x <- tribble(
	~key, ~val_x,
	1, "x1", 
	2, "x2",
	2, "x3",
	1, "x4"
)

y <- tribble(
	~key, ~val_y,
	1, "y1",
	2, "y2"
)
left_join(x, y, by = "key")# In this case the values of val_y were repeated once 
right_join(x, y, by = "key")

	#2.) Both tables have duplicate keys. This is usually an error because in neither table do the keys uniquely identify an observation. When you join duplicated keys, you get all possible combinations , the cartesian product.
x <- tribble(
	~key, ~val_x, 
	1, "x1",
	2, "x2",
	2, "x3",
	3, "x4"
)

y <- tribble(
	~key, ~val_y,
	1, "y1",
	2, "y2",
	2, "y3",
	3, "y4"
)

left_join(x, y, by = "key")

### Chapter 13.4.5 Defining the key column:
# So far, the pairs of tables have always been joined by a single variable, and that variable has the same name in both tables. That constraint was encoded by by = "key". You can use other values for by to connect the tables in other ways:
	#The default, by = NULL, uses all variables that appear in both tables, the so called natural join. For example, the flights and weather tables match on their comon variables: year, month, da, hour, and origin.
flights2 %>%
	left_join(weather)
	
	#a Character vector, by = "x". This is like a natural join, but uses only some of the common variables. For example, flights and planes have year variables, but they mean different things so we only want to join by tailnum.
flights2 %>%
	left_join(planes, by = "tailnum")
	
	#A named character vector: by = c("a","b"). This will match variable a in table x to variable b in table y. The variables from x will be used in the output.

#For example, if we want to draw a map we need to combine the flights data with the airports data which contains the location (lat and long) of each airport. Each flight has an origin and destination airport, so we need to specify which one we want to join to:
flights2 %>% 
	left_join(airports, c("dest" = "faa")) 
	
flights2 %>%
	left_join(airports, c("origin" = "faa"))

### Chapter 13.4.6 Exercises:
#1.)
destination <- flights %>% 
	group_by(dest) %>% summarise(average = mean(dep_delay, na.rm=TRUE)) %>% inner_join(airports, by = c(dest = "faa"))

destination %>%
	ggplot(aes(lon, lat, color = dest, size = average)) +
	borders("state") + 
	geom_point() + 
	coord_quickmap()
	
destination %>%
	ggplot(aes(lon, lat, color = average)) +
	borders("state") + 
	geom_point() + 
	coord_quickmap()
#Part of the solution was found by the author. Will need to brush up a little on my join function. I didn't really know that I could use inner_join() for this problem. 

ggplot() + borders("state") + coord_quickmap()# Interesting, this line of code creates a default image of the united states without the need for statial coordinates.

#2.)
origin <- flights %>% inner_join(airports, by = c(dest = "faa")) %>% inner_join(airports, by = c(origin = "faa"))

origin2 <- flights %>% left_join(airports, by = c(dest = "faa")) %>% left_join(airports, by = c(origin = "faa"))
#I believe that left_join() is the best way to go about combining these two datasets. Will need to again look into the join() functions yet again.

#3.)
flight_flea <- flights %>% 	
	inner_join(planes, by = "tailnum")
flights

flight_me <- flights %>%
	left_join(planes, by = "tailnum")
#Yet again I believe the left_join() will be the perfect join() function in this situation since all the rows were preserved through using this method and when I used the inner_join() function some of the rows were lost.
flight_me %>% group_by(tailnum) %>%
	mutate(average_dep = mean(dep_delay, na.rm =TRUE), average_arr = mean(arr_delay, na.rm = TRUE)) %>% select(tailnum, year.y, average_arr, average_dep) %>% ggplot(aes(x = year.y, y = average_arr)) + geom_point()
#This is pretty interesting, but the problem with these graphs is that they don't scale. Meaning that I can't discern any new information from them except the fact that their are more departure and arrival delays for newer airplanes than older ones. But will need to do more exploritory analysis to see if this is actually the case. Perhaps the reason for this is that simply there are more new airplanes in the air than older ones. Hence inflating the statistics of their unreliability.
	
flight_me %>% 
	group_by(year.y) %>% 
	mutate(average_dep = mean(dep_delay, na.rm =TRUE), average_arr = mean(arr_delay, na.rm = TRUE)) %>%
	select(tailnum, year.y, average_arr, average_dep) %>% ggplot(aes(x = year.y, y = average_dep)) + geom_point() + geom_line()

flight_me %>% 
	group_by(year.y) %>% 
	mutate(average_dep = mean(dep_delay, na.rm =TRUE), average_arr = mean(arr_delay, na.rm = TRUE)) %>%
	select(tailnum, year.y, average_arr, average_dep) %>% 
	ggplot(aes(x = year.y)) + geom_freqpoly()

#Interestingly enough the author actually used inner_join() in conjunction with plans %>% mutate(age = 2013 - year) before he calculated the departure and arrival delay averages. The end result was a graph that looked exactly like mine except age is graphed in ascending order for his solution while mine is graphed in descending order.
#His conclusion was that age has nothing to do with a plane's rate of delays.

#just a little subsetting exercise:
flight_me %>%
	count(tailnum) %>%
	filter(n > 1)
flight_me %>%
	filter(tailnum == "D942DN")

#4.)
#primary key exploration:
flights %>% 
	count(year, month, day, hour) %>%
	filter(n > 1)
??weather
??flights
#After looking at the documentation it seems that matching these two datasets with the variable time_hour will work perfectly. 

flights %>%
	left_join(weather, by = "time_hour") %>%
	filter(visib < 5) %>% select(time_hour, flight, dep_delay, arr_delay)

flight_join <- flights %>% 
	left_join(weather, by = "time_hour") %>% 
	filter(dep_delay >= quantile(dep_delay, 0.90, na.rm = TRUE)) %>% select(flight, dep_delay, time_hour, temp, humid, wind_dir, wind_speed, wind_gust, precip, visib)

#Author's solution:
flight_join <- flights %>% 
inner_join(weather, by =c("origin" = "origin",
							"year" = "year",
							"month" = "month",
							"day" = "day",
							"hour" = "hour"))
							
#5.)
library(viridis)
library(viridisLite)
flights %>% 
	filter(year == 2013, month == 6, day == 13) %>%
	group_by(dest) %>%
	summarise(delay = mean(arr_delay, na.rm = TRUE)) %>%
	inner_join(airports, by = c("dest" = "faa")) %>%
	ggplot(aes(y = lat, x = lon, size = delay, color = delay)) + 
	borders("state") +
	geom_point() + 
	coord_quickmap() + 
	scale_color_viridis()


### Chapter 13.4.7 other implementations:
#base::merge() can perform all four types of mutating join:
inner_join(x, y) / merge(x, y) 
left_join(x, y) / merge(x, y, all.x = TRUE)
right_join(x, y) / merge(x, y, all.y = TRUE)
full_join(x, y) / merge(x, y, all.x = TRUE, all.y = TRUE)
#The advantages of the specific dplyr verbs is that they more clearly convey the intent of your code: the difference between the joins is really important by conceealed in the arguments of merge(). dplyr's joins are considerably faster and don't mess with the order of rows.

#Interesting additional similarities between SQL and dplyr:
inner_join(x, y, by = "z") / SELECT * FROM x INNER JOIN y USING (Z) 
#Very interesting, but at this moment looking at SQL syntax is extraneous at best will look into this section later on through my studies.
#Interesting addition: Joining different variables between the tables uses slightly different syntax in SQL. As this syntax suggests, SQL supports a wider range of join types than dplyr because you can connect the tables using constraints other than equality (called non-equijoins).

###Chapter 13.5 Filtering joins:
#Filtering joins match observations in the same way as mutating joins, but affect the observations not the variables. There are two types:
	#semi_join(x, y): keeps all observations in x that have a match in y.
	#anti_join(x, y): drops all observations in x that have a match in y.
	
#Semi_joins are useful for matching filtered summary tables back to the original rows. For example, image you've found the top ten most popular destinations:
top_dest <- flights %>% 
	count(dest, sort = TRUE) %>%
	head(10)# Addiitonally head() is used to obtain the top values within a particular data frame while tail() is the exact opposite of head().
top_dest

#Now you want to find each flight that wen to one of those destinations. You could construct a filter yourself:
flights %>%
	filter(dest %in% top_dest$dest)
#Will need to brush up on my filter command. I forgot how that you can use %in% within the filter() function call. And that this argument is very much like using the which() function within a data frame subsetting command.

#But it's difficult to extend that approach to multiple variables. For example, imagine that you'd found the 10 days with highest average delays. How would you construct the filter statement that used year, month, and day to match it back to flights?

#Instead you can use a semi_join(), which connects the two tables like a mutating join, but instead of adding new columns,only keeps the rows in x that have a match in y:
flights %>%
	semi_join(top_dest)
	
#The inverse of a semi_join() is an anti_join(). An anti_join() keeps the rows that don't have a match:
#anti_joins are useful for diagnosing join mismatches. For example, when connecting flights and planes, you might be interested to know that there are many flights that don't have a match in planes:

flights %>%
	anti_join(planes, by = "tailnum") %>%
	count(tailnum, sort = TRUE) 
	
### chapter 13.5.1 Exercises:
#1.)
flights %>% 
	anti_join(planes, by = "tailnum") %>%
	count(carrier, sort = TRUE)
flights %>% 
	semi_join(planes, by = "tailnum") %>%
	count(carrier, sort = TRUE)
flights %>%
	anti_join(planes, by = "tailnum") %>%
	count(dest, sort = TRUE)
#Very interesting when you explore the significance (or rather the cause) of a plane not having a recorded tail number. After combining the flights and planes datasets using both the semi_join() and the anti_join() functions I found a curious correlation between planes originating from LGA and JFK and not having recorded tail numbers in the dataset. Will need to see if this is what the author had in mind about the cause. In any case I will have to look into the planes dataset to see if there are any other possible causes. 
#Also another finding is that particular carriers are mostly to blame for this oversight but after looking into the numbers I believe that this isn't the case.

flights %>%
	filter(is.na(tailnum)) %>%
	count(origin, sort = TRUE)
flights %>% 
	filter(is.na(tailnum)) %>%
	count(carrier, sort =TRUE)
#I believe that the origin airports LGA, JFK, and EWR are the main causes of the tail number being miss recorded and missing from the flights dataset. Again will need to see if this was the author's conclusion as well.

#It seems that I was incorrect about this conclusion. According to the author the carriers AA and MQ don't report tail numbers.

#2.)
flight_flea <- flights %>% 
	count(tailnum, sort = TRUE) %>% 
	filter(n >= 100)
flights %>% 
	count(flight, sort = TRUE) %>%
	filter(n > 1)
flights %>% 
	count(tailnum, sort = TRUE) %>%
	filter(n > 1)
planes %>%
	semi_join(flight_flea, by = c("tailnum"))

#Author's solution:
planes_gt100 <- 
	filter(flights) %>%
	group_by(tailnum) %>%
	count() %>%
	filter(n > 100) 
#Weird I didn't know thatyou can access a dataset through only invoking filter(). Will need to look into this functionality.
flights %>%
	semi_join(planes_gt100, by = "tailnum")
	
#3.)
library(fueleconomy)
??vehicles
??common 
common %>% left_join(vehicles, by = c(model = "id"))

common %>%
	count(model) %>%
	filter(n > 1)
#Interesting just like with babynames I can't seem to use this function properly again the console says that comparison (6) is possible only for atomic and list types. Again will need to look into this error. I hope this does not become a constant problem.

vehicles %>% 
	count(make) %>%
	filter(n > 1)# Oddly enought this line of code worked perfectly and because of that I found that id can be used as a primary key just like in the last section's exercise.
	
glimpse(fueleconomy::vehicles)
glimpse(fueleconomy::common)
fueleconomy::vehicles %>%
	semi_join(fueleconomy::common, by = c("make", "model"))
	
#4.) 
# It seems that the author doesn't have a solution for this problem. Will most likely go make to this problem later on through my studies. 

#5.) 
anti_join(flights, airports, by = c("dest" = "faa"))
anti_join(airports,flights, by = c("faa" = "dest"))

#Author's solution:
anti_join(flights, airports, by = c("dest" = "faa"))# are flights that go to an airport that is not in FAA list of destinations, likely foreign airports.

anti_join(airports, flights,by = c("faa" = "dest"))# are US airports that don't have a flight in the data, meaning that there were no flights to that airport from New York in 2013.

#6.) 
flights %>%
	group_by(tailnum, carrier) %>%
	count() %>%
	filter(n() > 1) %>%
	select(tailnum) %>%
	distinct()
	
### chapter 13.6 Join Problems:
#The data you've been working with in this chapter has been cleaned up so that you'll have as few problems as possible. Your own data is unlikely to be so nice, so there are a few things that you should do with your data to make your joins go smoothly.
	#1. Start by identifying the variables that form the primary key in each table. You should usually do this based on your understanding of the data, not empirically by looking for a combination of variables that give a unique identifier. If you just look for variables without thinking about what they mean, you might get unlucky and find a combination that's unique in your current data but the relationship might not be true in general.
	
# For example, the altitude and longitude identify each airport, but they are not good identifiers!
airports %>% count(alt, lon) %>% filter(n > 1)

	#2. Check that none of the variables in the primary key are missing. If a value is missing then it can't identify an observation.
	
	#3. Check that your foreign keys match primary keys in another table. The best way to do this is with an anti_join(). It's common for keys not to match because of data entry errors. Fixing these is often a lot of work.
	
#BE aware that simply checking the number of rows before and after the join is not sufficient to ensure that your join has gone smoothly. If you have an inner join with duplicate keys in both tables, you might get unlucky as the number of dropped rows might exactly equal the number of duplicated rows.

### chapter13.7 Set operations:
#The final type of two-table verb are the set operations. they are occasionally useful when you want to break a single complex filter into simpler pieces. All these operations work with a complete row, comparing values and every variable. These expect the x and y inputs to have the same variables, and treat the observations like sets:
	#intersect(x, y): return only observations in both x and y.
	#union(x, y): return unique observations in x and y.
	#setdiff(x, y): return observations in x, but not in y. 
	
df1 <- tribble( 
	~x, ~y, 
	1, 1,
	2, 1
)

df2 <- tribble(
	~x, ~y, 
	 1, 1,
	 1, 2
)

intersect(df1, df2)
union(df1, df2)
setdiff(df1, df2)
setdiff(df2, df1)