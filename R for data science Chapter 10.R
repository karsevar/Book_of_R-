### chapter 10 Tibbles:
### Chapter 10.1 Introduction:
# Tibbles are data frames, but they tweak some older behaviors to make life a little easier. Here we will describe the tibble package, which provides opinioned data frames that make working in the tidyverse a little asier. 

#If this chapter leaves you wanting to learn more about tibbles, you might enjoy vignette("tibble")

### chapter 10.1.1 Prerequisites:
library(tidyverse)

### chapter 10.2 Creating tibbles:
#Almost all of the functions that you'll use in this bookproduce tibbles, as tibbles are one of the unifying features of the tidyverse. Most other R prackages use regular data frames, so you might want to coerce a data frame to a tibble. You can do that with as_tibble().

iris #This is the iris flower data frame from the base R package. Will be interesting to see what wickham will do with this data frame. Oh and the data structure of this object is just a base data.frame. It hasn't been converted to a tibble yet.
as.tibble(iris)# Since the tibble data structure is within the tidyverse package make sure to call the tidyverse through the command library(tidyverse). It's important to keep in mind that Wickham instinctively writes all his as commands with an underscore while Davies writes his with a period. Both ways work in the R concole so no need to worry about that syntax in this case.

#You can create a new tibble from individual vectors with tibble(). Tibble() will automatically recycle inputs of length 1, and allows you to refer to variables that you just created, as shown below:
tibble(
	x = 1:5,
	y = 1,
	z = x ^ 2 + y
)# Interesting you don't have to use the string command c() when you construct a tibble() will keep this development in mind. It seems that tibbles are filled by default by row in place of by columm. Will need to test out how this is different from a normal data.frame().

data.frame(x=c(1:5), y=1, z = c(x ^ 2 + y))# Interesting unlike tibbles data.frames can't recognize objects within their own structure calls. 
data.frame(x = c(1:5), y = 1, z = c((1:5 ^ 2) + 1))# Interesting, the categories of x and y are the same as the tibble but the integers within the z category are completely different. It seems that the data.frame() command ignored by call to calculate x ^ 2 + y, will need to look into the reason for this.

#If you're already familiar with data.frame(), note that tibble() does much less: it never changes the type of the inputs, it never changes the names of variables and it never creates row names.
#It's possible for a tibble to have column names that are not valid R variable names, aka non-syntactic names. For example, they migh not start with a letter, or they might contain unusual characters like a space. To refer to these variables, you need to surround them with backticks, `:

tb <- tibble(
	`:)` = "smile",
	` ` = "space",
	`2000` = "number"
)
tb

#Another way to create a tibble is with tribble(), short for transposed tibble. tribble() is customised for data entry in code: column headings are defined by formulas (they start with ~), and entries are separated by commas. This makes it possible to lay out small amounts of data in easy to read form.
tribble(
	~x, ~y, ~z,
	#-|---|---- Wickham says that he usually writes this annotation when ever he calls tribbles as a means to help him differentiate between column names and the content within each column.
	"a", 2, 3.6,
	"b", 1, 8.5
)

### chapter 10.3.1 Printing:
#Tibbles have a refined print method that shows only the first 10 rows, and all the columns that fit on screen. this makes it much easier to work with large data. In addtion to its name, each column reports its type, a nice feature borrowed from str().
tibble(
	a = lubridate::now() + runif(1e3) * 86400,
	b = lubridate::today() + runif(1e3) *30, 
	c = 1:1e3,
	d = runif(1e3),
	e = sample(letters, 1e3, replace = TRUE)
)

# Tibbles are designed so that you don't accidentally overwhelm your console when you print large data frames. But sometimes you need more output than the default display. there are a few options that can help. 
# First you can explicitly print() the data frame and contol the number of rows (n) and the width of the display. width = Inf will display all columns.
nycflights13::flights %>% print(n = 10, width = Inf)# again n controls the number of entries printed onto the console (the rows so to speak) and the width controls the amount of columns printed onto the console. 

#You can also control the default print behavior by setting options:
#	options(tibble.print_max = n, tibble.print_min = m): if more than m rows, print only n rows. Use options(dplyr.print_min = Inf) to always show all rows.
#	Use options(tibble.width = Inf) to always print all columns, regardless of the width of the screen.

#Check package?tibble for more information.

#the final option is to use the RStudio viewer to see a scrollable representation of the entire data set.
nycflights13::flights %>% 
View()

### chapter 10.3.2 Subsetting:
#So far all the tools you've learned have worked with complete data drames. If you want to pull out a single variable, you need some new tools, $ and [[]] can both extract by name or position within a tibble() and a base data.frame().

df <- tibble(
	x = runif(5),
	y = rnorm(5)
)

df$x
df[["x"]]
df[[1]]
# Neat, tibbles use the same subsetting syntax as basic data.frames().

#To use these in a pipe, you'll need to use the special placeholder .:
df %>% .$x
df %>% .[["x"]]

#Compared to a data.frame, tibbles are more strict: they never do partial matching, and they will generate a warning if the column you are trying to access does not exist. 

### Chapter 10.4 Interacting with older code:
#Some older functions don't work with tibbles. If you encounter one of these functions, use as.data.frame() to turn a tibble back to a data.frame:
class(as.data.frame(tb))
#The main reason that some older functions don't work with tibble is the [ function. We don't use [ much in this book because dplyr::filter() and dplyr::select() allow you to solve the same problems with clearer code. with base R data frames, [ sometimes returns a data frame, and sometimes returns a vector. With tibbles, [ always returns another tibble. 

### chapter 10.5 Exercises:
#1.) 
#	You can tell that an object is a tibble through the class command in the R console or through just simply printing the object onto the console itself. If the object is in fact a tibble the output will display the data type within each column and the number of columns and rows withheld at the bottom of the printed object. 
# Illustration:
mtcars #This data set is obviously a data.frame() since all of the contents are printed onto the console and the data types are not printed next to each column.
as.tibble(mtcars) # After converting the data.frame() mtcars into a tibble you can see that 10 of the 32 rows were printed onto the console as a means to not overwhelm the base r terminal. 

#2.) 
df <- data.frame(abc = 1, xyz = "a")
df&x
df[, "xyz"]
df[,c("abc","xyz")]
df[c("abc","xyz"),]

dt <- tibble(
	abc = 1,
	xyz = "a"
)
dt$x
dt[,"xyz"]
# Subsetting with data.frame() can be a little confusioning in that you have to constantly keep in mind the subsetting principle of objectname[row, column]. this is useful if you are looking for a specific value in that you can type:
mtcars$cyl[mtcars$qsec < 16]
mtcars[mtcars$qsec < 16,]
#but these subsetting techniques can becoming convoluted. Will need to look into how to do these same subsetting commands with tibble. Perhaps this same thing can be carried out through the filter() command call, will need to look into this.

#3.)
var <- "mpg"
me <- tibble( 
	var = "mpg",
	flea = "me",
	flea2 = "bee"
)

me$var
me[["var"]]
me[[1]]
#these are all the different ways that you can extract a value from a column category in a tibble.

#4.) 
annoying <- tibble(
	`1`= 1:10,
	`2` = `1` * 2 + rnorm(length(`1`))
)

#a.)
annoying[[1]]
annoying[[2]]

#b.)
annoying %>% ggplot(aes(x = "1" , y = "2")) + geom_point() 
ggplot(data = annoying, aes(x = `1`, y = `2`)) + geom_point()# Now I understand you need to `` symbols for this command call to work. Will need to keep this in mind and see if I can see a different syntax to get the same results. 

#c.) 
annoying[["3"]] <- annoying[[1]] / annoying[[2]]
annoying

#d.) 
annoying <- rename(annoying, one = `1`, two = `2`, three = `3`)
annoying 

#5.) 
??enframe()
#It converts named atomic vectors or lists to two-column data frames. For unnamed vectors, the natural sequence is used as name column. deframe() converts two-column data frames to a named vector or list, using the first column as name and the second column as value. 

#6.) 
options(tibble.print_max = 20, tibble.print_min = 13) 
as.tibble(mtcars)
#As a suspected the tibble.print_min argument in the options function controls the amount of rows that will be printed onto the console with every call of tibble. 



 