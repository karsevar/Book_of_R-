### Chapter 4 Workflow: Basics ###

#geom_linerange experiments:
j <- ggplot(data=diamonds, mapping=aes(x=cut, y=depth)) 
j + geom_linerange(aes(fun.ymin=min, fun.ymax=min))
j + stat_summary(fun.ymin=min, fun.ymax=max, fun.y=median)
ggplot(data=diamonds, aes(x=interaction(depth)))

##Chapter 4.1 Coding basics:
#Using R as a calculator (I wonder if he wil talk about R"s ability for elemental computations):
200 * 30
(59 + 73 + 2) / 3
sin(pi/2)

#You can create an object using the symbols <- in place of = which is common practice in other higher level languages.
x <- 3*4

#All R statements where you create objects, assignment statements, have the same form:
#object diagram: object_name <- value 

#When reading that code say "object name gets value" in your head.
#You will make lots of assignments and <- is a pain to type. Don't be lazy and use =: it will work, but it will cause confusion later. Instead, use Rstudio's keyboard shortcut: alt+-(minus sign). Also it is good practice to use spaces in between the object name and the <- symbol as well as the symbol and the value.

##4.2 What's in a name:
#Object names must start with a letter, and can only contain letters, numbers, _ and .. You want your object names to be descriptive, so you'll need a convention for multiple words. I recommend snake_case here you separate lowercase words with _.
x <- 3*4
x
this_is_a_really_long_name <- 2.5

#Seems that the command, control, up keyboard short cut does not work for this program. The book states that the keyboard short cut only works on R studio. very interesting addition though will need to look into R studio just for fun.

r_rock <- 2^3
r_rocks
R_rock
#these last two commands are just an illustration that R is very much case sensitive. There's an implied contract between you and R: It will do the tedious computation for you, but in return, you much be completely precise in your instructions. Typos matter. Case matters.

### 4.3 Calling functions:
#Function diagram:
#	function_name(arg1 = val1, arg2 = val2, ...)

# R studio commands:
#Type se and hit tab. A popup shows you possible completions. Specify seq() by typing more (a "q") to disambiguate, or by using the up arrow or down arrow keys. Notice the floating tooltip that pops up, reminding you of the funciton's arguments and purpose. If you want more help, press F1 to get all the details in the help tab in the lower right pane. Press TAB once more when you've selected the function you want. Rstudio will add matching opening (() and closing ()) parenthese for you. Type the arguments 1,10 and hit return.

seq(1,10)# the default for the by argument for this function is set to 1. 
x <- "hollo world"
# Quotation marks the parenthese much always come in a pair. Rstudio does its best to help you, but it's still possible to mess up and end up with a mismatch. If it happens, R will how you the continuation character "+".

# The + tells you that R is waiting for more input; it doesn"t think you're done yet. Usually that means you've forgotten either a " or a ). Either add the missing pair, or press Escape to abort the expression and try again.

#Interesting you can shorten the act of checking each object by printing out the contents by simply encompassing the object call with parentheses. This command prints the object's contents for you automatically. 
(y = seq(10,100, by=0.5))# This command works perfectly with the base R program.

### Chapter 4.4 Exercises:
#1.) 
#	From what I can see the second command had a 1 in the object call in place of the i in the initial object call and creation. And because of that the console didn't know what object you were looking for in the command. 

#2.)
#Incorrect example:
library(tidyverse)
ggplot(dota=mpg) + geom_point(mapping = aes(displ, y=hwy))
fliter(mpg, cyl=8)
filter(diamond, carat>3)

#Correct command calls:
ggplot(data=mpg) + geom_point(mapping=aes(displ,y=hwy))
filter(mpg, cyl==8)# Interesting using the filter method was way simplier than creating a subsetting command encompassed by brackets for the which base R function. Will need to remember this particular function for my later projects.
filter(diamonds, carat>3)

#Experiments on using subsetting commands to get the same results:
mpg[(mpg$cyl==8),]# the result where the same as the counterpart up above.
diamonds[(diamonds$carat>3),]# Again this command came back with the same response as earlier. Very interesting will need to look into the differences and similarities between base R commands and the filter() function.

#3.)
 #Interesting the alt shift command keyboard short cut creates the apple symbol on my console when I use the base R console program. Very interesting, I believe that the author wants me to use Rstudio for this particular exercise.

#Rstudio experiment:
#Neat Rstudio works on my computer. will need to test out its capabilities. The author was right I can use the built-in functionality to finish and look up R functions while I'm typing them. Very interesting. Neat through typing the keyboard short cut alt shift k I get to bring up all the keyboard commands on my mac os system.  
