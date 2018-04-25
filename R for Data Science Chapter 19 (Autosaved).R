### chapter 19:

### 19.1 Introduction:
#One of the best ways to improve your reach as a data scientist is to write functions. Functions allow you to automate common tasks in a more powerful and general way than copy-and-pasting. Writing a function has three big advantages over using copy-and-paste:
	#You can give a function an evocative name that makes your code easier to understand.
	#As requirements change, you only need to update code in one place, instead of many.
	#You eliminate the chance of making incidental mistakes when you copy and paste.
	
### 19.2 When should you write a function?
#You should consider writing a function whenever you've copied and pasted a block of code more than twice. 

df <- tibble::tibble(
	a = rnorm(10),
	b = rnorm(10),
	c = rnorm(10),
	d = rnorm(10)
)
df

df$a <- (df$a - min(df$a, na.rm = TRUE)) / (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE)) 

df$b <- (df$b - min(df$b, na.rm = TRUE)) / (max(df$b, na.rm = TRUE) - min(df$b, na.rm = TRUE)) 

df$c <- (df$c - min(df$c, na.rm = TRUE)) / (max(df$c, na.rm = TRUE) - min(df$c, na.rm = TRUE))

df$d <- (df$d - min(df$d, na.rm = TRUE)) / (max(df$d, na.rm = TRUE) - min(df$d, na.rm = TRUE))  

#You might be able to puzzle out that this rescales each column to have a range from 0 to 1. But did you spot the mistake? I made an error when copying and pasting the code for df$b: I forgot to change an a to a b. Extracting repeated code out into a function is a good idea because it prevents you from kaing this type of mistake.

#to write a function you need to firest analyse the code. How many inputs does it have?

(df$a - min(df$a, na.rm = TRUE)) /
	(max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
	
#This code only has one input: df$a. To make the inputs more clear, it's a good idea to rewrite the code using temporary variables with general names. Here this code only requires a single numeric vector, so I'll call it x:
x <- df$a 
(x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))

#There is some duplication in this code. We're computing the range of the data three times, but it makes sense to do it in one step:
rng <- range(x, na.rm = TRUE)
(x - rng[1]) / (rng[2] - rng[1]) 

#Pulling out intermediate calculations into named variables is a good practice because it makes it more clear what the code is doing. Now that I've simplified the code, and checked that it still works, I can turn it into a function.

rescale01 <- function(x) {
	rng <- range(x, na.rm = TRUE)
	(x - rng[1]) / (rng[2]- rng[1])
}
rescale01(c(0, 5, 10))

#there are three key steps to creating a new function:
	#You need to pick a name for the function. Here the author picked the name rescale01 since the function itself rescales the rnorm() values into the 0 to 1 scale.
	#You list the inputs, or arguments, to the function inside function. Here we have just one argument. If we  had more the call would look like function(x, y, z).
	#You place the code you have developed in body of the function, a { block that immediately follows function(...).
		
#Note the overall process: I only made the function after I'd figured out how to make it work with simple input. It's easier to start with working code and turn it into a function; it's harder to create a function and then try to make it work.

rescale01(c(-10, 0, 10))
rescale01(c(1, 2, 3, NA, 5))
#As you write more and more functions you'll eventually want to convert these informal, interactive tests into formal, automated tests. The process is called unit testing. 

#We can simplify the original example now that we have a function:
df$a <- rescale01(df$a)
df$b <- rescale01(df$b)
df$c <- rescale01(df$c)
df$d <- rescale01(df$d)

#Another advantage of functions is that if your requirements change, we only need to make the change in one place. For example, we might discover that some of our variables include infinite values, and rescale01() fails:
x <- c(1:10, Inf)
rescale01(x)

#Because we've extracted the code into a function, we only need to make the fix in one place:
rescale01 <- function(x) {
	rng <- range(x, na.rm = TRUE, finite = TRUE) 
	(x - rng[1]) / (rng[2] - rng[1])
}# Interesting will need to look into what finite = TRUE does to the range() function call. Will need to look at the range() function documentation.

rescale01(x)

#This is an important part of the do not repeat yourself principle. The more repetition you have in your code, the more places you need to remember to update when things change, and the more likely you are to create bugs over time.

### chapter 19.2.1 Practice:
#1.) 
	# Most like the na.rm = TRUE command is not a parameter within the function rescale01() is because na.rm = TRUE is an argument within the range() function call. Hence dividing TRUE from range() would only make the rescale01() function more complex or not work properly. In addition,I can say that the na.rm = TRUE argument can be changed into a parameter through changing the function into:
rescale02 <- function(x, ...){
	rng <- range(x, ...)
	(x - rng[1]) / (rng[2] - rng[1])
}
rescale02(x, na.rm = TRUE, finite = TRUE)
rescale02(x, na.rm = TRUE, finite = FALSE)
#This addition gives you further control over the range function without having to rewrite the rescale01() for more functionality (like changing the finite argument from its default to TRUE).

rescale02(c(1,2,3, NA, 5), na.rm = FALSE)
#the result is the NA value infecting the other four values in the function call. I really don't know the cause though. 

#2.)
rescaleinf <- function(x) {
	rng <- c(-Inf, Inf)
	(x - rng[1]) / (rng[2] - rng[1])
}
#I hope this is what the author had in mind for the solution.
rescaleinf(c(1, 2, 3))# this function call only produces NaN values will need to look into how to properly map 1 to Inf and 0 to -Inf.

#Author's solution:
rescaleInf <- function(x) {
	rng <- range(x, na.rm = TRUE, finite = TRUE)
	y <- (x - rng[1]) / (rng[2] - rng[1])
	y[y == -Inf] <- 0 
	y[y == Inf] <- 1
	y
}

rescaleInf(c(Inf, -Inf, 0:5, NA))
#Now I understand what the author wanted me to do, Wickham wanted me to rewrite all Inf and -Inf into the 0 to 1 scale and so the subsetting commands y[y == -Inf] <- 0 and y[y== Inf] <- 1 can be all considered puesdo-if statements. Honestly I have to say that this is a very creative solution.

#3.)
#code used to make the function:
x <- rnorm(50) #This line is only here to create random values.

mean(is.na(x))

x / sum(x, na.rm = TRUE)

sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE)

#attempt 1:
statsum <- function(x, ...) {
	meanna <- mean(is.na(x))
	sum <- x / sum(x, ...)
	sd <- sd(x, ...) / mean(x, ...)
	return(list(mean = meanna, sum = sum, standard = sd))
}

statsum(x, na.rm = TRUE)
#I'm not sure this is what the author had in mind since the function is still a little messy and I used a call that was taught in the Book of R by Tilman Davies, but as a means to display all of the values within the function call return() is really the only alternative.

#Illustration of statsum without the return() command:
statsum <- function(x, ...) {
	(meanna <- mean(is.na(x)))
	(sum <- x / sum(x, ...))
	(sd <- sd(x, ...) / mean(x, ...))
}

statsum(x, na.rm = TRUE)# Interesting through the parentheses method the last object (sd) was returned within the console. Will need to look into why the function behaved this way. 

#4.)
data <- read.csv("https://raw.githubusercontent.com/nicercode/nicercode.github.com.old/master/intro/data/seed_root_herbivores.csv")
data# Sweet this method actually worked! Will need to remember this alternative when importing data from the internet into my base R console.

mean(data$Height)
#The same value as the blog post. This means that this dataset is the same.

var(data$Height)#This is for the variance of the Height column.

length(data$Height)# this finds the size of the dataset or rather the amount of samples in the dataset. Or in other words this finds n.

#Formula for standard error:
#standard error = sqrt(variance / n )
sqrt(var(data$Height) / length(data$Height))
#The standard error for Height.

sqrt(var(data$Weight) / length(data$Weight))
#The standard error for Weight.

standard.error <- function(x) {
	sqrt(var(x)/length(x))
}

standard.error(data$Height)
standard.error(data$Weight)

#You can define variables within functions:
standard.error <- function(x) {
	v <- var(x)
	n <- length(n)
	sqrt(v/n)
}

#This case is more complicated, so we'll do it in pieces:
x <- data$Height 
n <- length(x)
(1/(n - 1))

#The second term is harder. We want the difference between all the x values and the mean:
m <- mean(x)
x - m
#Then we want to square those differences:
(x - m) ^ 2
#and compute the sum:
sum((x - m) ^2)
#Putting both halves together, the variance is:
(1/(n - 1)) * sum((x - m) ^ 2)
#Which agrees with R's variance function:
var(x)

#We can then define our function, using the pieces that we wrote above:
variance <- function(x) {
	n <- length(x)
	m <- mean(x)
	(1/(n - 1)) * sum((x - m) ^ 2)
}

variance(data$Height)
var(data$Height)
variance(data$Weight)
var(data$Weight)

#Author's solution on the skewness function:
skewness <- function(x) {
	n <- length(x)
	v <- var(x)
	m <- mean(x)
	third.moment <- (1 / (n - 2)) * sum((x - m) ^ 3)
	third.moment/(var(x)^(3/2))
}
skewness(data$Height)

#5.)
library(tidyverse)

data_flea <- c(1:10, rep(NA, 4), rnorm(20))
subset(data_flea, is.na(data_flea))
data_flea[subset(data_flea, is.na(data_flea))]
#This command has the same response as the command above. Will need to see if I can create a function call that is less crude. 

#Now I understand what I'm doing wrong. My function is a little too complicated for the problem at hand:
y <- c(1:10, rep(NA, 4), rnorm(20))

x <- c(rep(NA, 4), 1:10, rnorm(20))

is.na(y)
sum(is.na(y))
#Interesting these commands work perfectly with identifying the NA values and counting them.The use of sum() as a counting function is especially inspired.

is.na(y & x)
sum(is.na(y & x))#Interesting I didn't know that the and syntax would work in this particular case. Will need to look into this. 
is.na(y | x) #Interesting that the or syntax didn't work with identifying the NA values in both of the vectors.It must be cased by the is.na() function.

both.na <- function(x, y) {
	sum(is.na(x & y))
}

both.na(x, y)

#6.)
#Author's solution:
#The function is_directory checks whether the path in x is a directory. The function is_readable checks whether the path in x is readable, meaning that the file exists and the user has permission to open it. These functions are useful even though they are short because their names make it much clearer what the code is doing.

### chapter 19.3 Functions are for humans and computers:
#The name of a function is import. Ideally,the name of your function will be short, but clearly evoke what the function does. That's hard! But it's better to be clear than short, as RStudio's autocomplete makes it easy to type long names.
#Generally, function names should be verbs, and arguments should be nouns. There are some exceptions: nouns are ok if the function computes a very well known noun, or accessing some property of an object. A good sign that a noun might be a better choice is if you're using very broad verb like get, compute, calculate, or determine.

#If your function name is composed of multiple words, I recommend using snake_case, where each lowercase word is separated by an underscore. camelCase is a popular alternative. It doesn't really matter which one you pick, the important thing is to be consistent: pick one or the other and stick with it.

#If you have a family of functions that do similar things, make sure they have consistent names and arguments. Use a common prefix to indicate that they are connected. That's bettern than a common suffix because autocomplete allows you to type the prefix and see all the members of the family (Only in RStudio).
input_select()
input_checkbox()
input_text() 
#The common signifier needs to be at the front. 

#A good example of this design is the stringr package: if you don't remember exactly which function you need, you can type str_ and jog your memory.
#Where possible, avoid overriding existing functions and variables. It's impossible to do in general because so many good names are already taken by other packages, but avoiding the most common names from base R will avoid confusion.

#Use comments, lines starting with X, to explain the why of your code. You generally should avoid comments that explain the what or the how. If you can't understand what the code does from reading it, you should think about how to rewrite it to be more clear. Do you need to add some intermediat variables with useful names? Do you need to break out a subcomponent of a large function so you can name it? However, your code can never capture the reasoning behind your decision: why did you choose this approach instad of an alternative? What else did you try that didn't work? It's a great idea to capture that sort of thinking in a comment.

#Another important use of comments is to break up your file into easy to read chucks. Use long lines of _ and = to make it easy to spot the breaks.

### chapter 19.3.1 Exercises:
#1. 
f1 <- function(string, prefix) {
	substr(string, 1, nchar(prefix)) == prefix
}