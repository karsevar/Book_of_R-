### Chapter 7 Exploratory Data Analysis 
### Chapter 7 Introduction:
# This chapter will primarily be about Eploritory data analysis or rather EDA for short. EDA is an iterative cycle where you:
#	Generate questions about your data.
#	Search for answers by visualising, transforming, and modeling your data.
#	Use what you learn to refine your questions and or generate new questions.

#Data cleaning is just one application of EDA: you ask questions about whether your data meets your expectations or not. To do data cleaning, you'll need to deploy all the tools of EDA: visualisation, transformation, and modelling.

library(tidyverse)

###Chapter 7.2 Questions:
#Your goal during EDA is to develop an understanding of your data. The easiest way to do this is to use questions as tools to guide your intvestigation. When you ask a question, the question focuses your attention on a specific part of your dataset and helps you decide which graphs, models, or transformations to make. 

#(Very interesting point that the author makes about statistical inference and running data centric experiments) EDA is fundamentally a creative process. And like most creative processes, the key to asking quality questions is to generate a large quantity of questions. It is difficult to ask revealing questions at the start of your analysis because you do not know what insights are contained in your dataset. On the other hand, each new question that you ask will expose you to a new aspect of your data and increase your chance of making a discovery.You can quickly drill down into the most interesting parts of your data --- and develop a set of though-provoking questions--- if you follow up each question with a new question based on what you find.

#Two types of questions will always be useful for making discoveries within your data You can loosely word these questions as: 
#	What tpe of variation occurs within my variables?
#	What type of covariation occurs between my variables?
#These two question are what the author's analysis styles are based on. Hence it is important to remember them while I doing exploratory analysis. Very interesting questions none the less.

#Vocabulary to think about:
#	A variable is a quantity, quality, or property that you can measure.
#	A value is the state of a variable when you measure it. The value of a variable may change from measurement to measurement.
#	An observation is a set of measurements made under similar conditions (you usually make all of the measurements in an observation at the same time and on the same object). An observation will contain several values, each associated with a different variable. I'll sometimes refer to an observation as a data point.
#	Tabular data is a set of values, each associated with a variable and an observation. Tabular data is tidy if each value is placed in its own cell, each variable in its own column, and each observation in its own row.

### chapter 7.3 Variation:
#Variation is the tendency of the values of a variable to change from measurement to measurement. In addition continuous and categorical observations can all change in value with each observation. This is because each variable has its own pattern of variation, which can reveal interesting information. The best way to understand that pattern is to visualise the distribution of the variable's values.

###Chapter 7.3.1 Visualising distributions:
# How you visualise the distribution of a variable will depend on whether the variable is categorical or continuous. A variable is categorical if it can only take one of a small set of values. In R, categorical variables are usually saved as factors or character vectors. To examine the distribution of a categorical variable, use a bar chart:

ggplot(data=diamonds) + geom_bar(mapping=aes(x=cut)) #Interesting thing to keep in mind the geom_bar() is the bar chart geometric layer for ggplot2. The height of the bar chart displays how many observations occurred with each x value. 

#You can compute these values manually with dply::count():
diamonds %>% count(cut)# This creates of tibble of 5 rows and 3 columns which displays the same information as in the bar chart. Very interesting function.

#A variable is continuous if it can take any of an infinite set of ordered values. Numbers and data-times are two examples of continuous variables. To examine the distribution of a continuous variable, use a histogram (I really forgot all about using histograms).
ggplot(data=diamonds) + geom_histogram(mapping=aes(x=carat), binwidth=0.5) #Will need to keep this in mind for if I have to see the distribution characteristics of a continuous variable taking up the x axis. Will need to see what binwidth does and what the default for this argument is.
ggplot(data=diamonds) + geom_histogram(mapping=aes(carat), binwidth=1)# The bins a larger in this graphic hence making the number of bins that are displayed less. From 7 in the binwidth = 0.5 example this histogram only displays 4 in all. One thing to keep in mind is that having bins that are too large decreases one's ability to see small characteristic patterns in the data but making them too small will only confuse you into thinking that the data has no patterns (as illustrated by binwidth=0.25).
ggplot(data=diamonds) + geom_histogram(mapping=aes(carat), binwidth=0.15)# I believe that the binwidth argument is set to 0.15 in its default state.
ggplot(data=diamonds) + geom_histogram(mapping=aes(carat), binwidth=0.25)

#You can compute this by hand by combining dplyr::count() and ggplot2::cut_width():
diamonds %>% count(cut_width(carat, 0.5))# Neat this function does the cut() function's break argument for me. Very cool function to remember.

#A histogram divides the x-axis into equally spaced bins and then uses the height of a bar to display the number of observations that fall in each bin. In the graph above, the tallest bar shows that almost 30,000 observations have a carat value between 0.25 and 0.75, which are the left and right edges of the bar. 
#You can set the width of the intervals in a histogram with the binwidth argument, which is measureed in the unites of the x variable. You should always explore a variety of binwidths when working with histograms, as different binwidths can reveal different patterns. 
smaller <- diamonds %>% filter(carat<3)#Interesting way to use the pipe syntax.
ggplot(data=smaller, mapping = aes(x= carat)) + geom_histogram(binwidth=0.1)# The author was right when you change the bounds of the histogram I can really see interesting trends within the data. Will need to keep this method in mind.

#If you wish to overlay multiple histograms in the same plot, I recommend using geom_freqpoly() instead ofgeom_histogram(). geom_freqpoly() performs the same calculation as geom_histogram(), but instead of displaying the counts with bars, uses lines instead. It's much easier to understand overlapping lines than bars. (Make sure to keep in mind that changing the alpha arugment for each histogram will most likely bring about the same functionality, but even with that said, the author is right, for a more professional histogram comparision device it's better to use the geom_freqpoly() function).
ggplot(data=smaller, mapping=aes(x=carat, color=cut)) + geom_freqpoly(binwidth=0.1)# I forgot that for ggplot2 all you need to do to create a histogram or point comparisions is to assign a variable to the color argument.

#The key to asking good follow-up questions will be to rely on your curiousity (what do you want to learn more about?) as well as your skepticism (how could this be misleading?).

###Chapter 7.3.2 Typical values:
#In both bar charts and histograms, tall bars show the common values of a variable, and shorter bars show less-common values. Places that do not have bars reveal values that were not seen in your data. To turn this information into useful questions, look for anything unexpected:
#	Which values are the most common? Why?
#	Which values are rare? Why? Does that match your expectations?
#	Can you see any unusual patterns? What might explain them?

#As an example, the histogram below suggests several interesting questions:
#	Why are there more diamonds at whole carats and common fractions of carats?
#	Why are there more diamonds slightly to the right of each peak than there are slightly to the left of each peak?
#	Why are there no diamonds bigger than 3 carats?
#(experiment) most likely the reason for there being more diamonds in common carat sizes, to the right of the histogram, and no bigger than 3 carats is because of the price being higher for lower carat examples (according to my observations in the book of R with Tilman Davies).
#Will look into this rational.
??diamonds
ggplot(data=smaller, mapping = aes(x=carat, color=price)) + geom_freqpoly(binwidth=0.1) 
ggplot(data=smaller, mapping=aes(x=price, y=carat)) + geom_point() #Well I guess that my observation was completely wrong. price is positively correlated to carat amount. Will need to selve this idea. Again though just like the author's observations, you can see a large amount of points taking up whole number carat denominations. In addition, most of the points are in the 1 carat range (just like what the histogram illustrated).

#The author's illustration and rational for these questions:
ggplot(data=smaller, aes(x=carat)) + geom_histogram(binwidth=0.01)

#clusters of similar values suggest that subgroups exist in your data. To understand the subgroups, ask:
#	How are the observations within each cluster similar to each other?
#	How are the observations in separate clusters different from each other?
#	How can you explain or describe the clusters?
#	Why might the appearance of clusters be misleading?

#Old faithful eruption bar graph. the eruption pattern follows a schedule of around 2 minute intervals for small eruptions and 4 to 5 minute intervals for larger eruptions and little inbetween.
ggplot(data = faithful, mapping = aes(x=eruptions)) + geom_histogram(binwidth=0.25)

### chapter 7.3.3 Unusual values:
#Experiment on the flights data set. It seems that I forgot all about the outlier concept when calculating the speed of each flight to see data entry errors. Will love to see if this is true.
speed.flea <- flights %>% group_by(flight) %>% mutate(speed = distance/(air_time/60)) 
ggplot(data=speed.flea, aes(x=distance, y= speed)) + geom_point()
ggplot(data=speed.flea, aes(x=speed)) + geom_histogram(binwidth=0.5)
small.speed <- speed.flea %>% filter(speed < 600)
ggplot(small.speed, aes(x=speed)) + geom_histogram(binwidth=0.50)
large.speed <- speed.flea %>% filter(speed > 500)
ggplot(large.speed, aes(x=speed)) + geom_histogram(binwidth=0.25)
#So this is what the author was trying to have me do with the data at the end of chapter 5. He wanted me to find the extreme outliers. Still not sure how he wanted me to proceed with this information though. very interesting none the less.

#Outliers are observations that are unusual; data points that don't seem to fit the pattern. Sometimes outliers are data entry errors; other times outliers suggest important new science. When you have a lot of data, outliers are sometimes difficult to see in a histogram. For example, take the distribution of the y variable from the diamonds dataset. The only evidence of outliers is the unusually wide limites on the x-axis.
ggplot(diamonds) + geom_histogram(mapping = aes(x=y), binwidth=0.5)
??diamonds # the y variable is the width of the diamond in mm (0 - 58.9).

#There are so many observations in the common bins that the rare bins are so short that you can't see them (although maybe if you stare intently at 0 you'll spot something). To make it easy to see the unusual values, we need to zoom to small values of the y-axis with coord_cartesian().
ggplot(diamonds) + geom_histogram(mapping = aes(x=y), binwidth=0.5) + coord_cartesian(ylim=c(0,50))# the author was right there was a number of observations that have a width almost as small as zero in the histogram. Don't know if this will be any use with analyzing real life data points though.

#(coord_cartesian() also has an xlim() argument for when you need to zoom into the x-axis. ggplot2 also has xlim() and ylim() functions that work slightly differenctly; they throw away the data outside the limits). 

#This allows us to see that there are three unusual values: 0, ~30, and ~60. We pluck them out with dplyr:
unusual <- diamonds %>% filter(y < 3 | y > 20) %>% select(price, x, y, z) %>% arrange(y)
unusual# Wow there are only 9 outliers that make up the flanks of 3 and 20 in all. I can really use this to answer the speed question in chapter 5.7.

#A little experimention with the number before moving on:
ggplot(diamonds) + geom_histogram(aes(y, fill=cut), binwidth=0.25) + coord_cartesian(xlim=c(0,10)) # Now I Understand what the author is trying to do. He's cutting out the y values 3 through 10 as a means to plot the outliers more effectively. I think I might want to do the same with my speed.flea data sets displaying the speed value for each flight in the flights data set. Very useful idea.

# The y variable measures one of the three dimensions of these diamonds, in mm. We know that diamonds can't have a widthof 0 mm, so these values must be incorrect. We might also suspect that measurements of 32 mm and 59mm are implausible: those diamonds are over an inch long, but don't cost hundreds of thousands of dollars. It's good practice to repeat your analysis with and without the outliers. If they have minimal effect on the results, and you can't figure out why they're there, it's reasonable to replace them with missing values, and move on. However, if they have a substantial effect on your results, you shouldn't drop them without justification. You'll need to figure out what caused them and disclose that you removied them in your write-up.

### Chapter 7.3.4 Exercises:
#Little experiment on the y, x, and z coordinates within the diamonds data set.
library(rgl)
??plot3d()
plot3d(x=diamonds$x, y=diamonds$y, z=diamonds$z)#This is funny. The diamonds didn't plot exactly the way I hoped. I really need to brush up on my three dimensional plots and four dimensional objects.

#1.)
library(gridExtra)
flea <- ggplot(diamonds, aes(x=x)) + geom_histogram(binwidth=0.1) + coord_cartesian(xlim=c(3,10))
flea_2 <- ggplot(diamonds, aes(x=y)) + geom_histogram(binwidth=0.1) + coord_cartesian(xlim=c(0,20))
flea_3 <- ggplot(diamonds, aes(x=z)) +geom_histogram(binwidth=0.1) + coord_cartesian(xlim=c(0,10))
grid.arrange(flea, flea_2, flea_3)

dev.new()
flea <- ggplot(diamonds, aes(x=x)) + geom_histogram(binwidth=0.25) 
flea_2 <- ggplot(diamonds, aes(x=y)) + geom_histogram(binwidth=0.25) 
flea_3 <- ggplot(diamonds, aes(x=z)) +geom_histogram(binwidth=0.25) 
grid.arrange(flea, flea_2, flea_3)
??diamonds 
#According to the documentation the x variable is the length of the diamond in mm, the y variable is the width of the diamond in mm, and the z variable is the depth of the diamond again in mm.
#From what I can see between the x, y, and z variables; the x (length) variable has the least amount of variation and the y (width) variable has the most amount of variation. Again this must be measurement and recording errors on the part of the peopl who compiled this data set since depth and width are very hard variables to measure out. Other then the variations between variables I really can't put into words other interesting differences between them. Will need to come back to this question once I get enough exposure with analyzing data sets and individual variables.

#2.)
ggplot(data = diamonds, mapping = aes(x=price, y=carat)) + geom_point()
diamonds %>% count(cut_width(price, 50))# Now I understand, since the price is recoded in whole numbers it is only understandable that the binwidths should be inputted into the console as large whole numbers too. Will first test out a binwidth of 50 then I will go up in increments of 50.
ggplot(data=diamonds, mapping = aes(x=price)) + geom_histogram(binwidth=50)# Making the binwidth 50 seems to have worked remarkably. Will need to move up by 50 dollars more. Interestingly I don't see that much variation, this might be because the binwidth is just not big enough yet.
ggplot(data=diamonds, mapping = aes(x=price)) + geom_histogram(binwidth=150) + coord_cartesian(xlim=c(0,5000))# From what I can see with this graph most of the count is concentrated between 250 dollars and 1,250 dollars. Very interesting trend. I will need to find out about the quality and the carats of these highly popular diamonds. In addition, the distributes dips a little in the 1,500 dollar mark.
#With all of that said, only a few people buy diamonds over 5,000 dollars.

#3.) 
diamonds %>% filter(carat == 0.99)
diamonds %>% filter(carat == 1)
diamonds %>% filter(carat== 0.99 | carat == 1) %>% ggplot(aes(x=carat)) + geom_bar()# this isn't a very good graphic representation, but (regardless of that fact) what this graphic is telling us is that the number of 0.99 carat diamonds are very small compared to 1 carat diamonds. 
#Most likely 0.99 carat diamonds are created because of weighting errors between the instruments tasked with weighing diamonds and humans documenting the carats into their catelogs.

#4.) 
ggplot(diamonds, aes(x=carat)) + geom_histogram()# It seems if you don't set the binwidth manually the binwidth is automatically set to 30 thus meaning that continuous variables whose values are smaller than 1 are not plotted onto the device.
ggplot(diamonds, aes(x=carat)) + geom_histogram(binwidth=0.25) + coord_cartesian(xlim=c(0,4), ylim=c(0,10000))
ggplot(diamonds, aes(x=carat)) + geom_histogram(binwidth=0.25) + xlim(0,3) + ylim(0,10000)
#the difference between coord_cartesian() and xlim() and ylim() is that with the former rows are not removed when the plot is trimmed and narrowed down on the y and x-axes while the latter functions actually removes rows from the data set that fall outside of the graph. Will need to keep these differences in mind. 

### Chapter 7.4 Missing Values:
#If you've encountered unusual values in your dataset, and simply want to move on to the rest of your analysis, you have two options:
#	1.) Drop the entire row with the strange values:
diamonds2 <- diamonds %>% filter(between(y,3,20)) #I don't recommend this option because just because one measurement is invalid, doesn't mean all the measurements are. Additionally, if you have low quality data, by time that you've applied this approach to every variable you might find that you don't have any data left.

#	2.) Instead, I recommend replacing the unusual values with missing values. The easiest wayt to do this is to use mutate() to replace the varialbe with a modified copy . You can use the ifelse() function to replace unusualy values with NA:
diamonds2 <- diamonds %>% mutate(y=ifelse(y < 3 | y > 20, NA, y))
#ifelse() has three arguments. the first arugment test should be a logical vector. The result will contain the value of the second argument, yes, when test is TRUE, and the value of the third argument, no, when it is false.

#Like R, ggplot2 subscribes to the philosophy that missing values should never silently go missing. It's not obvious where you should plot missing values, so ggplot2 doesn't include them in the plot,but it does warn that they've been removed.
ggplot(data = diamonds2, mapping = aes(x = x, y= y)) + geom_point()# according to this graphic there is a positive coorelation between longer lengths and longer widths. Will need to look into the p-value for this anomally. 
??diamonds 

#To suppress that warnin, set na.rm=TRUE:
ggplot(data=diamonds2, mapping = aes(x=x, y=y)) + geom_point(na.rm=TRUE)

#Other times you want to understand what makes observations with missing values different to observations with recorded values. 

#Example using nycflights13::flights, missing values within the dep_time variable. Hence this example will compare the scheduled departure times for cancelled and non-cancelled times. You can do this by making a new variable with is.na().
nycflights13::flights %>% 
mutate(
cancelled = is.na(dep_time),
sched_hour = sched_dep_time %/% 100,
sched_min = sched_dep_time %% 100,
sched_dep_time = sched_hour + sched_min / 60
) %>% 
ggplot(mapping = aes(sched_dep_time )) + geom_freqpoly(mapping = aes(color=cancelled), binwidth=1/4)
#Howeverthis plot is't great because there are many more non-cancelled flights than cancelled flights. In the next section we'll explore some techniques for improving this comparison. 

### chapter 7.4.1 Exercises:
#1.) 
# According to the documentation of the geom_histogram() function. A na.rm argument is set by default to FALSE meaning that the NA values will be ignored in the graphic but a warning message will be printed on to the console telling the user how many values are being ignored. If the na.rm argument is set to TRUE the warning message will not be printed to the console.
# According to the documentation geom_box() has the same na.rm argument as geom_histogram() and both of them have the same default and functionality. Will need to look at how these two functions print NA values though. According to both of their documentation they all ignore NA values. 

flights %>% filter(is.na(dep_time))
ggplot(flights) + geom_histogram(aes(x=dep_delay), binwidth=1)
ggplot(flights) + geom_boxplot(aes(x=carrier, y=dep_delay))# Now I understand the geom_boxplot() removes all the rows that contain NA values and geom_histogram() does the same thing with NA values. Will need to find out what the author meant by there being a difference between these two function.

#2.) 
??mean()
# According to the documentation na.rm is a logical value indicating whether NA values should be stripped before the computation proceeds. 
??sum()
# According to the documentation na.rm is a logical argument that asks whether missing values (including NaN) should be removed before following through with the computation. 

### chapter 7.5 Covariation:
# Covariation is the tendency for the values of two or more variables to vary together in a related way. The best way to spot covariation is to visualise the relationship between two or more variables. 

### chapter 7.5.1 A categorical and continuous variable:
#It's common to want to explore the distribution of a continuous variable broken down by a categorical variable, as in the previous frequency polygon. The default appearance of geom_freqpoly() is not that useful for that sort of comparison because the height is given by the count. 

#This following example explores how the price of a diamond varies with its quality:
ggplot(data= diamonds, mapping = aes(x = price)) + geom_freqpoly(mapping = aes(color=cut), binwidth=500) #As you can see the variation in sizes between the five distributions makes it hard to see  particular patterns hidden in the data. 

ggplot(diamonds) + geom_bar(mapping = aes(x=cut))

#To make the comparison easier we need to swap what is displayed on the y-axis. Instead of displaying count, we'll display density, which is the count standardised so that the area under each frequency polygon is one.
ggplot(data = diamonds, mapping = aes(x = price, y =..density..)) + geom_freqpoly(mapping = aes(color=cut), binwidth=500)
#There'ssomething rather surprising about this plot - it appears that fair diamonds have the highest average price. But maybe that's because frequency polygons are a little hard to interpret.

#Another alternative to display the distribution of a continuous variable broken down by a categorical variable is the boxplot. A boxplot is a type of visual shorthad for a distribution of values that is popular among statisticians. Each boxplot consists of:
#	A box that stretches from the 25th percentile of the distribution to the 75th percentile, a distance known as the interquartile range. In the middle of the box is a line that displays the median of the distribution. These three lines give you a sense of the spread of the distribution and whether or not the distribution is symmetric about the median or skewed to one side.
#	Visual points that display observations that fall more than 1.5 times the IQR from either edge of the box. These outlying points are unusual so are plotted individually.
#	A line (or whisker) that extends from each end of the box and goes to the farthest non-outlier point in the distribution.

#This following line creates a boxplot() that graphs price  according to cut. 
ggplot(data = diamonds, mapping = aes(y=price, x=cut)) + geom_boxplot()# really neat. This graphic does show that the diamonds with a fair rating are being sold over their logical retail price while the diamonds with a good and ideal rating are being under priced. Very interesting observation.
#We see much less information about the distribution, but the boxplots are much more compact so we can more easily compare them (and fit more on one plot). It supports the counterintuitive finding that better quality diamonds are cheaper on average.

#cut is an ordered factor: fair is worse than good, which is worse than very good and so on (this is because cut in the diamonds data set is actually a factor data structure). Many categorical variables don't have such an intrinsic order, so you might want to reorder them to ake a more informative display. One way to do that is with the reorder() function (and also the as.factor() function).

#The following example uses the mpg dataset from ggplot2 and plots the class on the x axis and hwy mileage on the y axis. 
ggplot(data= mpg, aes(x=class, y = hwy)) + geom_boxplot()

#To mamke the trend easier to see, we can reorder class based on the median value of hwy:
ggplot(data = mpg) + geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy))# Interesting, I thing that the reorder() function reordered the vehicle class according to its highway mileage median value.  

#If you have long variable names, geom_boxplot() will work better if you flip it 90 degrees. You can do that with coord_flip().
ggplot(data = mpg) + geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) + coord_flip()

#1.) 
flight.flea <- flights %>% mutate(
cancelled = is.na(dep_time),
sched_hour = sched_dep_time %/% 100,
sched_min = sched_dep_time %% 100,
sched_dep_time = sched_hour + sched_min / 60
) 

flight.flea %>% ggplot(mapping = aes(x = cancelled)) + geom_bar()# I'm not really sure that this plot is what the author had in mind.

flight.flea %>% ggplot(mapping = aes(x = sched_dep_time, y = ..density..)) + geom_freqpoly(aes(color = cancelled))# Now I understand, the author wanted me to create a density plot so that the instances of cancelled flights does not overshadow the occurance of not cancelled flights. Again just like what the author said earlier, this is the best representation of the covariance of cancelled flights and not cancelled flights.

#2.) I have a feeling that color and clarity might have a lot to do with why fair diamond cuts are more expensive than good, very good, and ideal diamond cuts. Will look into this hypothesis.
ggplot(data = diamonds) + geom_boxplot(aes(x = cut, y = price))
ggplot(data = diamonds) + geom_point(aes(x=carat, y = price, color = cut))
ggplot(data = diamonds) + geom_freqpoly(aes(x=price, color=clarity))
ggplot(data = diamonds) + geom_boxplot(aes(x = clarity, y=price))

#How about size and weight?
#Carat analysis:
ggplot(data = diamonds) + geom_point(aes(x = carat, y = price))
ggplot(data = diamonds) + geom_histogram(aes(x = carat, fill = cut), alpha = 0.30)
ggplot(data = diamonds) + geom_boxplot(aes(x = cut, y = carat, fill = clarity))
ggplot(data = diamonds) + geom_boxplot(aes(x = clarity, y = price, fill = cut))
#Size analysis:
#length (x):
ggplot(data = diamonds) + geom_point(aes(x = x, y = price))
ggplot(data = diamonds) + geom_point(aes(x = z, y = price))
ggplot(data = diamonds) + geom_point(aes(x = y, y = price))
dev.new()
ggplot(data = diamonds) + geom_boxplot(aes(x = cut, y = x, fill = color))
ggplot(data = diamonds) + geom_boxplot(aes(x = cut, y = carat))
ggplot(data = diamonds) + geom_boxplot(aes(x = color, y = price))
summary(lm(price~cut+carat, data = diamonds))

#Conclusion:
# Most likely the interplay between cut and carat is the main reason why fair diamonds are more expensive (usually) than those with more superior cuts. According to this graphic:
 ggplot(data=diamonds) + geom_point(aes(x = carat, y = price)) # you can see that increased carat value increases a diamond's price exponentially and that (in addition) according to this graphic:
 ggplot(data= diamonds) + geom_boxplot(aes(x = cut, y = carat)) # you can see that on average fair diamonds have the most carats. 
 
# This observation is further illustrated by the regression model:
summary(lm(price~cut + carat, data = diamonds)) #where the p-value was assessed at 2.2 e-16 (which is well below any significance level) and the R_squared value 0.8565 (meaning that this model predicts 85.6 percent of the model's movement hypothetically of course).  
 
 #3.)
library(ggstance)
??ggstance
ggplot(data = diamonds) + geom_boxploth(aes(x = cut, y = carat), stat = "boxploth")
# I can't really create a normal boxplot using this function the console says that the position = dodgev argument requires non-overlapping y intervals. Will need to look into this same argument for the normal geom_boxplot() because it had no problem plotting this same graphic. 
# Interesting according to the documentation the position argument for the geom_boxplot() is "dodge" meaning that overlap between y intervals is allowed. Will need to see if changing the position argument in geom_boxploth() will make this line of code printable.

ggplot(data = diamonds) + geom_boxploth(aes(y = cut, x = carat), stat = "boxploth")# the warning message is gon, but I still can't make the console graph these values as a boxplot. Will need to look into other arguments that will help me do this.
#Now I understand what I'm doing wrong, I'm writing this graphic as if it's vertical. The only modification I have to do is write cut as the y axis and carat as the x axis. 
#This revelation worked perfectly. 

#Normal geom_boxplot horizontal transformation:
ggplot(data = diamonds) + geom_boxplot(aes(x = cut, y = carat)) + coord_flip()

#The differences between coord_flip() and geom_boxploth() are that for the latter position is set to "dodgev" by default while the former the argument is set to "dodge". As for how the axes are graphed; for the former, the x axis is the categorical variable and the y axis is the continuous variable while the latter is graphed the exact opposite.

#4.) 
library(lvplot)
ggplot(data = diamonds) + geom_lv(aes(x = cut, y = price)) 
ggplot(data = diamonds) + geom_boxplot(aes(x =cut, y = price)) # Really neat function, but I will have to study the arguments a little more before I can use this geom_lv() method correctly.
 
5.) 
dev.new()
ggplot(data = diamonds) + geom_violin(aes(x = cut, y = carat))# Pretty cool. Will need to find out what the variance in the base shapes of the violins represent.
# According to the documentation, a violin plot is a compacct display of a continuous distribution. It is a blend of geom_boxplot and geom_density: a violin plot is a mirrored density plot displayed in the same way as a boxplot. 

ggplot(data = diamonds) + geom_histogram(aes(x = carat), binwidth = 0.5, position = "dodge") + facet_wrap(~cut)
ggplot(data = diamonds) + geom_freqpoly(aes(x= carat, y = ..density.., color = cut))
# Now I understand, the geom_violin() layer allows you to view a categorical variable's density within the data set according to a continuous variable scale (which in this case is carat). This layer can very much be conceptualized as:
ggplot(data = diamonds) + geom_freqpoly(aes(x = carat, y = ..density.., color = cut)) + facet_wrap(~cut)
#except you don't have to input y = ..density.. and facet_wrap(~cut) into the layer call. This is very useful if you want to look into the density of your data without having to do some extra typing.

#6.) 
#Large data set representation:
ggplot(data = diamonds) + geom_jitter(aes(x = clarity, y = carat))

#Small data set representation:
ggplot(data = mtcars) + geom_jitter(aes(x = cyl, y = mpg))
# The author is right. This layer is perfect for smaller data sets. It has the same structure as a bar plot but still you can make out interesting trends within the continuous variable (which the points are graphed on).

library(ggbeeswarm)
??ggbeeswarm
ggplot(data = diamonds) + geom_quasirandom(aes(x = clarity, y = carat))
ggplot(data = mtcars) + geom_quasirandom(aes(x = cyl, y = mpg)) #this is way easier to read than the graphic created through geom_jitter() likely I have to change the jitter value to something more conservative (meaning that the points are straying a little too far from their respective categories). 
dev.new()
ggplot(data = diamonds) + geom_violin(aes(x = clarity, y = carat)
??geom_quasirandom()
# According to the documentation: The quasirandom geom is a convenient means to offset points within categories to reduce overplotting. In other words, it made the plot created intitially with the data from diamonds into a partially legible graphic.  
# Other layers in this package include: geom_beeswarm.

### Chapter 7.5.2 Two categorical variables:
#To visualise the covariation between categorical variables, you'll need to count the number of observations for each combination. One way to do that is to rely on the built-in geom_count():
ggplot(data = diamonds) + geom_count(mapping = aes(x = cut, y = color))
#The size of each circle in the plot displays how many observations occurred at each combination of values. Covariation will appear as a strong correlation between specific x values and specific y values. 

#Another approach is to compute the count with dplyr:
diamonds %>% count(color, cut)
#Then visualise with geom_tile() and the fill aesthetic:
diamonds %>% count(color, cut)  %>% ggplot(mapping = aes(x = color, y = cut)) + geom_tile(mapping = aes(fill = n))#Nead the geom_tile() layer is very much like the contour function in the base R program package will need to see the similarities.

#If the categorical variables are unordered, you might want to use the seriation package to simultaneously reorder the rows and columns in order to more clearly reveal interesting patterns. For larger plots, you might want to try the d3heatmap or heatmaply packages, which create interactive plots (will need to see if these packages run off of the same syntax as the rgl package).

### Chapter 7.5.2.1 Exercises:
##1.)
diamonds %>% group_by(color, cut) %>% count(color, cut)#It seems that the count() function is uneffected by the group_by() function will need to experiment a little more to find out how to implement group_by() in conjunction with count() more effectively.

#Experiment: I believe that changing the order of the variables in the group_by() function and the variable labeled in count() will effectively change the values that the count data set displays.  
diamonds %>% group_by(color, cut) %>% count(color)
diamonds %>% group_by(cut, color) %>% count(cut)#Interestingly these two lines create the same data frame.
#These lines answer the first part of the exercise where the author wants me to create a data frame that displays diamond count distributed by color within cut.

diamonds %>% group_by(color, cut) %>% count(cut)# this line changed the data frame's ordering back to displaying diamond count distributed by cut on color (just like in the example from the book). Will need to see if this is what the author had in mind for this part's solution. 

#Now I understand, the author wants me to most likely create a graphic representation that illustrates different distribution characteristics in the diamonds data set.
library(seriation)
??seriation
me.man <- as.data.frame(diamonds %>% count(color, cut))
me.flea <- diamonds %>% count(color, cut)

#Can't seems to get any of these function to work properly will need to research a little more on seriation to see what I'm missing in these lines of code. Or even what seriation plots are supposed to look like.
me.flea %>% ser_dist(x = color, y = cut)
bertinplot(x = me.man)

#count() documentation:
#wt: (optional) if omitted, will count the number of rows. If specified, will performa a weighted tally by summing the non-missing values of variable wt. This argument is automatically quoted and later evaluated in the context of the data frame.
#sort: If true will sort output in descending order of n.
diamonds %>% count(color, cut)
diamonds %>% count(color, cut, sort = TRUE)
#In all honesty I can't really find an alternative to how I should scale these variables in a more intuitive manner. Will need to go back to this question once I gain more experience.

##2.) 
library(nycflights13)
flights %>% group_by(dest, year, month) %>% summarise(dep_mean = mean(dep_delay, na.rm=TRUE)) %>% ggplot() + geom_tile(aes(x = dest, y = month, fill = dep_mean))

# Attempt 1. Seems that I should most likely use filter first and in addition I think in place of group_by() I should try out the nuew function count() to assess for the presence of delays.
# I found out what I did wrong. I forgot to tell the console the fill the graphic with the mean dep_delay values and to initiate ggplot2 through a call to ggplot(). The resulting plot looks very jumbled. Will try to fix the image a little bit through using differenct grouping funcitons within the pipe code. 

flights %>% group_by(dest, month) %>% summarise(dep_mean = mean(dep_delay, na.rm=TRUE)) %>% ggplot() + geom_tile(aes(x = month, y = dest, fill = dep_mean))
flights %>% filter(!is.na(dep_delay) | !is.na(arr_delay)) %>% group_by(dest, month) %>% summarise(dep_mean = mean(dep_delay)) %>% ggplot() + geom_tile(aes(x = dest, y=month, fill = dep_mean))
??geom_tile()
#At this moment this is the closest I can get with this plot. I believe the first thing that needs to be done in making it more intuitive is to order the destinations in an alphabetical order code so that all the destinations are not jumbled in one side of the contour plot. And the color key is a little confused, meaning that there needs to be a gradient in the contour plot (this is where a palette will come into play). Other then that I can't really thing of anymore improvements. It seems that I'm unequal to the task of plotting multiple categorical variable plots. I really need more practice in this part of R programming and statistical visualization.

##3.)
diamonds %>% count(cut, color) %>% ggplot() + geom_tile(aes(x = color, y = cut, fill = n))
diamonds %>% count(cut, color) %>% ggplot() + geom_tile(aes(x = cut, y = color, fill = n))# In this case I will have to disagree with the author because for this contour plot I have to say that the aes(x = cut, y color) aesthetic distribution is the best way to go in conceptualizing the differences between the two categorical over the count of diamonds in the sample because through this method the gradient is easier to spot with this set up for diamond cut. But, with that said, I have to say that I aggree with the author for the most part that it will be advantages to put the color categorical variable along the x axis (because of the better screen horizontal real estate on modern cumpters and that as such the color categorical variable just has more categories). 
diamonds %>% ggplot() + geom_count(aes(x = cut, y = color))
diamonds %>% ggplot() + geom_count(aes(x = color, y = cut))# In this case I agree with the author completely  because again the more screen real estate on the x axis is better for categorical variables with more values. 

### chapter 7.5.3 Two continuous variables:
#You've already seen one great way to visualise the covariation between two continuous variables: draw a scatterplot with geom_point(). You can see covariation as a pattern in the points. For example, you can see an exponential relationship between the carat size and price of a diamond.
ggplot(data = diamonds) + geom_point(mapping =aes(x = carat, y = price))# again this is just like my scatterplot in my diamond data set regression model and couple of chapters before.

#scatterplots become less useful as the size of your dataset grows, because points begin to overplot, and pile up into areas of uniform black. You've already seen on way to fix the problem: using the alpha aesthetic to add transparency.
ggplot(data = diamonds) + geom_point(mapping = aes(x = carat, y = price), alpha = 1/100)#this is really an interesting technique will need to remember this for my future datasets.

#But using transparency can be challenging for very large datasets. Another solution is to use bin. Previously you used geom_histogram() and geom_freqpoly() to bin in one dimension. Now you'll learn how to use geom_bin2d() and goem_hex() to bin in two dimensions. geom_bin2d() and geom_hex() divide the coordinate plane into 2d bins and then use a fill color to display how many points fall into each bin. Geom_bin2d() creates rectangular bins. geom_hex() creates hexabonal bins. You will need to install the hexbin package to us geom_hex().

ggplot(data = diamonds) + geom_bin2d(mapping = aes(x = carat, y= price))# So in other words, this is a contour plot except that it is plotted onto a graphic with two continuous variables making up the x and y axes. While the gradient is graphed onto the graphic through diamond count. 
library(hexbin)
ggplot(data = diamonds) + geom_hex(mapping = aes(x = carat, y = price))

#Another option is to bin one continuous variable so it acts like a categorical variable. Then you can use one of the techniques for visualising the combination of a categorical and a continuous variable that you learned about. For example, you could bin carat and then for each group, display a boxplot:
ggplot(data = diamonds, mapping = aes(x = carat, y = price)) + geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)))

# cut_width(x width), as used above, divides x into bins of width. By default, boxplots look roughly the same (apart from number of outliers) regardless of how many observations there are, so it's differicult to tell that each boxplot summarises a different number of points. One way to show that is to make the width of the boxplot proportional to the number of points with varwidth = TRUE.

#Another approach is to display approximately the same number of points in each bin. That's the job of cut_number().
ggplot(data = diamonds) + geom_boxplot(mapping = aes(group =cut_number(carat, 20), x = carat, y = price))

### Chapter 7.3.1 Exercises:
#1.) 
??geom_freqpoly()

#Author's solution:
ggplot(data = diamonds, mapping =aes( x= price, color = cut_width(carat, 0.3))) + geom_freqpoly()
#Very interesting that he used the color argument to create a bin argument as well as to side skirt the deficiency of geom_freqpoly() in that it does not accept a y axis argument (only an x axis argument). 
ggplot(data = diamonds, mapping = aes(x = price)) + geom_freqpoly(mapping = aes(color = cut_number(carat, 20)))
ggplot(data = diamonds, mapping = aes(x = price, y = ..density.., color = cut_width(carat, 0.3))) + geom_freqpoly()
ggplot(data = diamonds, mapping = aes(x = price, y = ..density.., color = cut_number(carat, 20))) + geom_freqpoly()
#From what I can see, when you use the geom_freqpoly() geometric layer in this capacity it's important to keep in mind that there is no y argument in the function and because of that you have to use the color argument to fill in for this deficiency. In considering to use cut_width and cut_number you have to think about the scale (or rather the amount of bins) of your graphic and whether to use y = ..density.. or keep the funtion call in the y = ..count.. default.

#2.) 
ggplot(data = diamonds, mapping = aes(y = carat, x = cut_number(price, 30))) + geom_boxplot() + coord_flip() + xlab("price")# part of this solution was proposed by the author. Very interesting solution none the less.

#3.)
ggplot(data = diamonds, mapping = aes(x = x, y = price)) + geom_point()
??diamonds # According to the graphic above you can see that the size of a diamond (in length mm) is positively correlated to the price. Will need to look into with another graphic representation.
ggplot(data = diamonds, mapping = aes(x = cut_number(price, 30), y = x)) + geom_boxplot() + coord_flip() 
# According to this graphic there is a noticeable increase in price with every millimeter increase in length. Very interesting. Will need to see if this holds up with depth and width. 
# Width:
ggplot(data = diamonds, mapping = aes(x = cut_number(price, 30), y = y)) + geom_boxplot() + coord_flip()
#Interesting, though the variation in width does not seemingly change that much throughout the dataset, you can still see a very large increase of price with an increase in width. With that said, I believe that length is the best measure for diamond size and price.
#depth:
ggplot(data = diamonds, mapping = aes(x = cut_number(price, 30), y = z)) + geom_boxplot() + coord_flip()
#the same result as width hence again length is the best predictor value for diamond size in this scenario.

#The author's solution:
#The distribution of very large diamonds is more variable. I'm not surprised, since I had a very weak prior about diamond prices. Ex, post, I would reason that above a certain size other factors such as cut, clarity, color play more of a role in the price. 
#This is a very good point. Will need to rethink the way I analyze data.

#4.) 
ggplot(data = diamonds, mapping = aes(x = price, y = carat, group = cut_number(price, 10))) + geom_boxplot() +coord_flip() + facet_wrap(~cut)
#This might be a little confusing to look at. Will try out the author's solution where he used scatterplot with a set alpha value.
ggplot(data = diamonds, mapping = aes(x = price, y = carat)) + geom_point(alpha = 1/100) + facet_wrap(~cut)

#A little idea. Will work on this line of code a little more.
ggplot(data = diamonds, mapping = aes(x = price, y = carat)) + geom_hex(aes(fill= x)) + facet_wrap(~cut)

#5.)
ggplot(data = diamonds) + geom_point(mapping = aes(x = x, y = y)) + coord_cartesian(xlim = c(4,11), ylim = c(4,11))
#this is because scatterplots are more suited to showing outlier data entries while bin plot are more suited to generalizing the data according to a particular variable (like the boxplots above), median and mean, etc. In other words, scatterplots give the data more freedom to express their values, though this usually comes at the cost of not knowing what the data is displaying.

### chapter 7.6 Patterns and models:
#Patterns in your data provide clues about relationships. If a systematic relationship exists between two variables it will appear as a pattern in the data. If you spot a pattern, ask yourself:
#	Could this patter be due to coincidence?
#	How can you describe the relationship implied by the pattern?
#	How strong is the relationship implied by the pattern?
#	What other variables might affect the relationship?
#	Does the relationship change if you look at individual subgroups of the data?

#A scatterplot of old faithful eruption lengths versus the wait time between eruptions shows a pattern: longer wait times are associated with longer eruptions. The scatterplot also displays the two clusters that we noticed above.
ggplot(data = faithful) + geom_point(mapping = aes(x = eruptions, y = waiting))

#Patterns provide one of the most useful tools for data scienctists because they reveal covariation. If you think of variation as a phenomenon that creates uncertainty, covariation is a phenomenon that reduces it. If two variables covary, you can use the values of one variable to make better predictions about the values of the second. If the covariation is due to a causal relationship, then you can use the value of one variable to control the value of the second.

#The following code fits a model that predicts price from carat and then computes the residuals (the difference between the predicted value and the actual value). The residuals give us a view of the price of the diamond, once the effect of carat has been removed.
library(modelr)
mod <- lm(log(price) ~ log(carat), data = diamonds)
diamonds2 <- diamonds %>% add_residuals(mod) %>% mutate(resid = exp(resid))
ggplot(data = diamonds2) + geom_point(mapping = aes(x = carat, y = resid))
#Once you've removed the strong relationship between carat and price, you can see what you expect in the relationship between cut and price: relative to their size, better quality diamonds are more expensive.

ggplot(data = diamonds2) + geom_boxplot(mapping = aes(x = cut, y = resid))

### chapter 7.7 ggplot2 calls:
#So far we've been very explicit, which is helpful when you ar learning. Typically the first one or two arguments to a funciton are so important that you should know them by heart. The first two arguments to ggplot() are data and mapping, and the first two arguments to aes() and x and y. 

#Shorta hand illustration:
ggplot(faithful, aes(eruptions)) + geom_freqpoly(binwidth= 0.25)

 
 