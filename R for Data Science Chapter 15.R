### chapter 15 Factors:
### chapter 15.1 Introduction:
# In R, factors are used to work with categorical variables, variables that have a fixed and known set of possible values. They are also useful when you want to display character vectors in a non-alphabetical order.
#(it's important to keep in mind that base R automatically converts characters to factors).

### chapter 15.1.1 Prerequisites:
#For this chapter we will work with the forcats packages which provides a wide range of helpers for working with factors.
library(tidyverse)
library(forcats)

### chapter 15.2 Creating factors:
#Imagine that you have a variable that records month:
x1 <- c("Dec","Apr","Jan","Mar")

#Using a string to record this variable has two problems:
	#1. There are only twelve possible months, and there's nothing saving you from typos:
x2 <- c("Dec","Apr","Jam","Mar")

	#2. It doesn't sort in a useful way:
sort(x1)# As you can see the months in the object x1 were sorted according to alphabetical order. 

#You can fix both of these problems with a factor. To create a factor you must start by creating a list of the valid levels:
month_levels <- c(
	"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"
)
#Now you can create a factor:
y1 <- factor(x1, levels = month_levels)
y1

#And any values not in the set will be silently converted to NA:
y2 <- factor(x2, levels = month_levels)
y2
#Of you want a warning, you can use readr::parse_factor():
y2 <- parse_factor(x2, levels = month_levels)

#If you omit the levels, they'll be taken from the data in alphabetical order:
factor(x1)

#Sometimes you'd prefer that the order of the levels match the order of the first appearance in the data. You can do that when creating the factor by setting levels to unique(x), or after the fact, with fact_inorder():
f1 <- factor(x1, levels = unique(x1))
f1
f2 <- x1 %>% factor() %>% fct_inorder()
f2

#If you ever need to access the set of valid levels directly, you can do so with levels():
levels(f2)

### chapter 15.3 General Social Survey:
#For the rest of this chapter, we're going to focus on forcats::gss_cat. It's a sample of data from the general social survey, which is a long running us survey conducted by the independent research organization NORC at the University of Chicago. The survey has thousands of questions, so in gss_cat I've selected a handful that will illustrate some common challenges you'll encounter when working with factors:
gss_cat
??gss_cat

#When factors are stored in a tibble, you can't see their levels so easily. One way to see them is with count():
gss_cat %>%
	count(race) 

#Or we can view this same information through a barchart.
ggplot(data = gss_cat, aes(x = race)) + geom_bar()
#By default, ggplot2 will drop levels that don't have any values. You can force them to display with:
ggplot(gss_cat, aes(race)) + 
	geom_bar() +
	scale_x_discrete(drop = FALSE)
	
#These levels represent valid values that simply did not occur in this dataset. Unfortunately, dplyr doesn't yet have a drop option, but it will in the future.
#When working with factors, the two most common operations are changing the order of the levels, and changing the values of the levels. 

### chapter 15.3.1 Exercise:
#1.)
ggplot(data = gss_cat, aes(rincome)) + geom_bar()# The income brackets are actually continuous varibles and because of that an intelligent way to fix this problem is to create bins for each income variable. Will need to check to ggplot() chapter to brush up on binwidth programming for histograms and barplots.

ggplot(data = gss_cat, aes(rincome)) + geom_histogram(binwidth=5000)# Interesting. I take back my past assessment. the rincome is actually documented in the dataset as a discrete value in place of a continuous variable. 
gss_cat %>%
	count(rincome)
#There are a total of 16 different levels in all. The main question is how can I convert these income brackets into a more manageable number for ggplot() graphics?

#Author solution:
#In his assessment Wickham found that through only flipping the bar plot to the side through the coord_flip() command you can make the 16 levels readable.
ggplot(data = gss_cat, aes(rincome)) + geom_bar() + coord_flip()# this solution worked perfectly. 

#2.)
gss_cat %>%
	count(relig) 
gss_cat %>%
	count(partyid)
	
#Author's solution:
gss_cat %>%
	count(relig) %>%
	arrange(-n) %>%
	head(1)	
gss_cat %>%
	count(partyid) %>%
	arrange(-n) %>%
	head(1)
	

	
gss_cat %>% ggplot(aes(relig)) + geom_bar() + scale_x_discrete(drop = FALSE) + coord_flip()
gss_cat %>% ggplot(aes(denom)) + geom_bar() + scale_x_discrete(drop = FALSE) + coord_flip()
#Interesting. From what I can see the denom variable is used as more or less a subcategory for the major religions in the survey meaning the separation of demoninations with regards to christianity, buddhism, etc. 

#author's solution:
# From what I can see the denom category refers to protestant due to the amount of respondants replying protestant on the survey. 
levels(gss_cat$denom)
gss_cat %>%
	filter(!denom %in% c("No answer", "Other","Don't know","Not applicable","No denomination")) %>%
	count(relig)
	
#This is also clear in a scatter plot of relig vs denom where the points are proportional to the size of the number of answers.
gss_cat %>%
	count(relig, denom) %>%
	ggplot(aes(x = relig, y = denom, size = n)) + geom_point() + theme(axis.text.x = element_text(angle = 90))
#Interesting solution. I really need to brush up on my ggplot() functions and command calls. It's very much embarrassing that my answer was completely wrong.

### chapter 15.4 Modifying factor order:
#It's often useful to change the order of the factor levels in a visualisation. For example, imagine you want to explore the average number of hours spent watching TV per day across the religions:
relig_summary <- gss_cat %>%
	group_by(relig) %>%
	summarise(
		age = mean(age, na.rm = TRUE),
		tvhours = mean(tvhours, na.rm = TRUE),
		n = n()
)

ggplot(relig_summary, aes(tvhours, relig)) + geom_point()

#It is difficult to interpret this plot because there's no overall pattern. We can improve it by reordering the levels of relig using fct_reorder(). fct_reorder() three arguments:
	#f, the factor whose levels you want to modify.
	#x, a numeric vector that you want to use to reorder the levels.
	#optionally, fun, a function that's used if there are multiple values of x for each value of f. The default value is median.

ggplot(relig_summary, aes(tvhours, fct_reorder(relig, tvhours))) + geom_point()

#Reordering religion makes it much easier to see the people in the "Don't know" category match much more TV, and Hinduism and other eastern religions watch much less.

#As you start making more complicated transformations, I'd recommonend moving them out of aes() and into a separate mutate() step. For example, you could rewrite the plot:
relig_summary %>%
	mutate(relig = fct_reorder(relig, tvhours)) %>%
	ggplot(aes(tvhours, relig)) +
	geom_point()
	
#What if we create a similar pot looking how average age varies across reported income level?
rincome_summary <- gss_cat %>%
	group_by(rincome) %>%
	summarise(
		age = mean(age, na.rm = TRUE),
		tvhours = mean(tvhours, na.rm = TRUE),
		n = n()
)
ggplot(rincome_summary, aes(age, fct_reorder(rincome, age))) + geom_point()

#Here, arbitrarily reordering the levels isn't a good idea! That's because rincome already has a principled order that we shouldn't mess with. Reserve fct_reorder() for factors whose levels are arbitrarily ordered.

#However, it does make sense to pull "Not applicable" to the front with the other special levels. You can use fct_relevel(). It takes a factor, f, and then any number of levels that you want to move to the front of the line.
ggplot(rincome_summary, aes(age, fct_relevel(rincome, "Not applicable"))) +
	geom_point() 
	
#Why do you think the average age for "not applicable is so high?
	#The age of the "not applicable" category is useful when you are coloring the lines on a plot. fct_reorder2() reorders the factor by the y values associated with the largest x values. This makes the plot easier to read because the line colors line up with the legend.
	
by_age <- gss_cat %>%
	filter(!is.na(age)) %>%
	group_by(age, marital) %>%
	count() %>%
	mutate(prop = n / sum(n))# Interesting I can't really get the line of code that transfers the each n value into a proportion using the mutate() function call and the sum() function call. Will need to look into what the problem is.
# Will most likely have to skip this exercise. I really don't know what's wrong with this line of code and why it can't calculate the proportions of n.

ggplot(by_age, aes(age, prop, color = marital)) + geom_line(na.rm = TRUE)

ggplot(by_age, aes(age, prop, color = fct_reorder2(marital, age, prop))) + 
	geom_line() + 
	labs(color = "marital")

#Finally, for bar plots, you can use fct_infreq() to order levels in increasing frequency: this is the simplest type of reordering because it doesn't need any extra variables. You may want to combine with fct_rev().
gss_cat %>%
	mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
	ggplot(aes(marital)) +
	geom_bar()
	
### chapter 15.4.1 Exercises:
#1.)
relig_summary_median <- gss_cat %>% 
	group_by(relig) %>%
	summarise(
		age = mean(age, na.rm = TRUE),
		tvhours = median(tvhours, na.rm = TRUE),
		n = n()
)

ggplot(relig_summary_median, aes(tvhours, relig)) + geom_point()

relig_summary_mean <- gss_cat %>% 
	group_by(relig) %>%
	summarise(
		age = mean(age, na.rm = TRUE),
		tvhours = mean(tvhours, na.rm = TRUE),
		n = n()
)

ggplot(relig_summary_mean, aes(tvhours, relig)) + geom_point()

gss_cat %>%
	filter(!is.na(tvhours)) %>%
	group_by(relig) %>%
	summarise(
		min = quantile(tvhours, 0.1),
		quarter = quantile(tvhours, 0.25),
		median = median(tvhours),
		max = quantile(tvhours, 0.9))
#The author is right the variation between the minimum value and the maximum value for the "Don't Know" category are completely skewed by the maximum value of 14.2 while the other categories don't have as much variation. I believe that either a proportion or a plot that displays the median in place of the mean for each category might be the perfect fix for this problem.
#From what you can see with the ggplots above the "Don't know" category actually has a median of 1 while all the other categories (except for the other eastern) has a median of 2. 

#Author's solution:
summary(gss_cat[["tvhours"]])
gss_cat %>%
	filter(!is.na(tvhours)) %>%
	ggplot(aes(x=tvhours)) + 
	geom_histogram(binwidth = 1)
	
### chapter 15.5 modifying factor levels:
#More powerful than changing the orders of the levels is changing their values. This allows you to clarify labels for publication, and collapse levels for high-level displays. The most general and powerful tool is fct_recode(). It allows you to recode, or change, the value of each level. 
gss_cat %>%
	count(partyid)
	
#The levels are terse and inconsistent. Let's tweak them to be longer and use a parallel construction.
gss_cat %>%
	mutate(partyid = fct_recode(partyid,
		"Republican, strong" = "Strong republican",
		"Republican, weak" = "Not str republican",
		"Independent, near rep" = "Ind,near rep",
		"Independent, near dem" = "Ind,near dem", 
		"Democrat, weak" = "Not str democrat",
		"Democrat, strong" = "Strong democrat"
)) %>%
count(partyid)

#fct_recode() will leave levels that aren't explicitly mentioned as is, and will warn you if you accidentally refer to a level that doesn't exist.
#To combine groups, you can assign multiple old levels to the same new level:
gss_cat %>%
	mutate(partyid = fct_recode(partyid,
		"Republican, strong" = "Strong republican", 
		"Republican, weak" = "Not str republican",
		"Independent, near rep" = "Ind,near rep",
		"Independent, near dem" = "Ind,near dem",
		"Democrat, strong" = "Strong democrat",
		"Democrate, weak" = "Not str democrat",
		"Other" = "No answer",
		"Other" = "Don't know",
		"Other" = "Other party"
)) %>%
count(partyid)

#You must use this technique with care: if you group together categories that are truly different you will ned up with misleading results.
#If you want to collapse a lot of levels, fct_collapse() is a useful variant of fct_recode(). For eachnew variable, you can provide a vector of old levels:
gss_cat %>%
	mutate(partyid = fct_collapse(partyid,
		other = c("No answer", "Don't know", "Other party"),
		rep = c("Strong republican", "Not str republican"),
		ind = c("Ind,near rep", "Independent", "Ind,near dem"),
		dem = c("Not str democrat", "Strong democrat")
)) %>%
count(partyid)

#sometimes you just want to lump together all the small groups to make a plot or table simpler. That's the job of fct_lump():
gss_cat %>%
	mutate(relig = fct_lump(relig)) %>%
	count(relig)
	
#The default behaviour is to progressively lump together the smallest groups, ensuring that the aggregate is still the smallest group. In this case it's not very helpful: it is true that the majority of Americans in this survey are protestant, but we've probably over collapsed.
#Instead, we can use the n parameter to specify how many groups (excluding other) we want to keep:
gss_cat %>%
	mutate(relig = fct_lump(relig, n = 10)) %>%
	count(relig, sort = TRUE) %>%
	print(n = Inf)

### chapter 15.5.1 Exercises:
#1.)
gss_cat %>%
	group_by(year) %>%
	mutate(partyid = fct_collapse(partyid,
		other = c("No answer", "Don't know", "Other party"),
		rep = c("Strong republican", "Not str republican"),
		ind = c("Ind,near rep", "Independent", "Ind,near dem"),
		dem = c("Not str democrat", "Strong democrat")
)) %>% 
	count(partyid) %>%
	ggplot(mapping = aes(year, n, color = partyid)) + geom_point() + geom_line()
	
party_me <- gss_cat %>%
	group_by(year) %>%
	mutate(partyid = fct_collapse(partyid,
		other = c("No answer", "Don't know", "Other party"),
		rep = c("Strong republican", "Not str republican"),
		ind = c("Ind,near rep", "Independent", "Ind,near dem"),
		dem = c("Not str democrat", "Strong democrat")
))

party_me %>% ggplot(aes(year, n)) + geom_bar() + facet_wrap(~partyid)# It seems that I can't make this solution into a bar graph. Again I'll have to brush up on the ggplot2 functionality and different geometric layer arguments.

#2.)
gss_cat %>%
	count(rincome)
	
gss_cat %>%
	mutate(rincome = fct_lump(rincome)) %>%
	count(rincome) #Seems like this function didn't work at all. Perhaps I need to use my own discretion.
	
#How about we make categorical levels that increase by increments of 5000.
gss_cat %>%
	mutate(rincome = fct_collapse(rincome, 
		"Lt to $4999" = c("Lt $1000", "$1000 to 2999", "$3000 to 3999", "$4000 to 4999"),
		"$5000 to $9999" = c("$5000 to 5999", "$6000 to 6999", "$7000 to 7999", "$8000 to 9999")
)) %>%
	count(rincome)
	
