### chapter 17 Introduction:
#Writing code is similar in many ways to writing prose. One parallel which I find particularly useful is that in both cases rewriting is the key to clarity. The first expression of your ideas is unlikely to be particularly clear, and you may need to rewrite multiple times. After solving a data analysis challenge, it's often worth looking at your code and thinking about whether or not it's obvious what you've done.

### chapter 18 Pipes:
### chapter 18.1 Introduction:
#Pipes are a powerful tool for clearly expressing a sequence of multiple operations. So far, you've been using them without knowing how they work, or what the alternatives are. This chapter will primarily be focused on pipe structure and the scenarios where pipe should be used and shouldn't be used.

# The pipe, %>%, comes from the magrittr package by stefan Milton Bache.
library(magrittr)

### chapter 18.2 Piping alternatives:
#The point of the pipe is to help you write code in a way that is easier to read and understand. To see why the pipe is so useful, we're going to explore a number of ways of writing the same code. 
#poem used for this interactive example:
##Little bunny Foo Foo
##Went hopping through the forest
##Scooping up the field mice
##And bopping them on the head

#We'll start by defining an object to represent little bunny Foo Foo:
foo_foo <- little_bunny()
#And we'll use a function for each key verb: hop(), scoop(), and bop().

### 18.2.1 Intermediate steps:
#The simplest way is to save each step as a new object. Much like the code that I wrote with Tilman Davies book of R.

foo_foo_1 <- hop(foo_foo, through = forest)
foo_foo_2 <- scoop(foo_foo_1, up = field_mice)
foo_foo_3 <- bop(foo_foo_2, on = head)

#The main downside of this form is that it forces you to name each intermediate element. If there are natural names, this is a good idea, and you should do it. But many times, like this in this example, there aren't natural names, and you add numeric suffixes to make the anmes unique. That leads to two problems:
	#1. The code is cluttered with unimportant names.
	#2. You have to carefully increment the suffix on each line.
	
#memory alocation with R using the pipe and regular save and iterate data structures:
diamonds <- ggplot2::diamonds
diamonds2 <- diamonds %>%
	mutate(price_per_carat = price / carat) 
	
pryr::object_size(diamonds)
pryr::object_size(diamonds2)
pryr::object_size(diamonds, diamonds2)

#Pryr::object_size() gives the memory occupied by all of its arguments. The result seems counterintuitive at first:
	#Since diamonds and diamonds2 together take up the same space as diamonds2 by itself.
	
#How can that work? Well, diamonds2 has 10 columns in common with diamonds: there's no need to duplicate all that data, so the two data frames have variables in common . These variables will only get copied if you modify one of them. In the following example, we modify a single value in diamonds$carat. That means the carat variable can no longer by shared between the two data frames, and a copy must be made. The size of each data frame is unchanged, but the collective size increases:

diamonds$carat[1] <- NA
pryr::object_size(diamonds)
pryr::object_size(diamonds2)
pryr::object_size(diamonds, diamonds2)

#(Note that we use pryr::object_size and not pryr::object.size() since the latter can only takes a single ojbect so it can't compute how data is shared across multiple objects).

### chapter 18.2.2 Overwrite the original:
#Instead of creating intermediate objects at each step, we could overwrite the original object:
foo_foo <- hop(foo_foo, through = forest)
foo_foo <- scoop(foo_foo, up = field_mice)
foo_foo <- bop(foo_foo, on = head)

#This is less typing (and less thinking), so you're less likely to make mistakes. However, there are two problems:
	#1. Debugging is painful.
	#2. The repetition of the object being transformed obscures what's changing on each line.
	
### chapter 18.2.3 Function composition:
#another approach is to abandon assignment and just string the funciton calls together:
bop(
	scoop(
		hop(foo_foo, through = forest),
		up = field_mice
		),
		on = head
	)
	
#Here the disabvantage is that you have to read from inside-out, from right to left, and that the arguments end up spread far apart (evocateively called the dagwood problem). In short, this code is hard for a human to consume.

### chapter 18.2.4 Use th pipe:
#Finally, we can use the pipe:
foo_foo %>%
	hop(through = forest) %>%
	scoop(up = field_mouse) %>%
	bop(on = head)
	
# This is my favourite form, because if focuses on verbs, not nouns. You can read this series of function compositions like it's a set of imperitive actions. 

#The pipe works by performing a lexical transformation: behind the scenes, magrittr reassembles the code in the pipe to a form that works by overwriting an intermediate object. When reassemables the code in the pipe to a form that works by overwriting an intermediate object. When you run a pipe like the one above, magrittr does something like this:
my_pipe <- function(.) {
	. <- hop(., through = forest)
	. <- scoop(., up = field_mice)
	bop(x, on = head)
}
my_pipe(foo_foo)

#this measnt that the pipe won't work for two classes of functions:
	#1. Functions that use the current environment. For example, assign() will create a new variable with the given name in the current environment:
assign("x", 10)
x
"x" %>% assign(100)
x

#The use of assign with the pipe does not work because it assigns it to a temporary environment used by %>%. If you do want to use assign with the pipe, you must be explicit about the environment.

env <- environment()
"x" %>% assign(100, envir = env)
x
#Other functions with this problem include get() and load()

	#2. Functions that use lazy evaluation. In R, function arguments are only computed when the function uses them, not prior to calling the function. The pipe computes easch element in turn, so you can't rely on this behavior.
	
#One place that this is a problem is tryCatch(), which lets you capture and handle errors:
tryCatch(stop("!"), error = function(e) "An error")

stop("!") %>%
	tryCatch(error = function(e) "An error")
	
#there are a relatively wide class of functions with this bhavior, including try(), suppressMassage(), and suppressWarnings() in base R.

### Chapter 18.3 When not to use the pipe:
#Pipes are most useful for rewriting a fairly short linear sequence of operations. I think you should reach for another tool when:
	# Your pipes are longer than ten steps. In that case, create intermediate objects with meaningful names. That will make debugging easier, because you can more easily check the intermediate results, and it makes it easier to understand your code, because the variable names can help communicate intent.
	#You have multiple inputs or outputs. If there isn't one primary object being transformed, but two or more objects being combined together, don't use the pipe.
	#You are starting to think about a directed graph with a complex dependency structure. Pipes are fundamentally linear and expressing complex relationships with them will typically yield confusing code.
	
### chapter 18.4 Other tools from magrittr:
#However, there are some other useful tools inside magrittr that you might want to try out:

	# When working with more complex pipes, it's sometimes useful to call a function for its side-effects. Maybe you want to print out the current object, or plot it, or save it to disk. Many times, such functions don't return anything, effectively terminating the pipe.
#To work around this problem, you can use the tee pipe. %T>% works like %>% except that it returns the left hand side instead of the right-hand side. It's called tee because it's like a literal T-shaped pipe.

rnorm(100) %>%
	matrix(ncol = 2) %>%
	plot() %>%
	str()# That's weird the plot() command actually worked perfectly but the str() command only printed a NULL value. I guess you don't need the tee pipe to create a plot in the middle of a pipe command.
	
rnorm(100) %>%
	matrix(ncol = 2) %T>%
	plot() %>%
	str()# interesting, this command printed the str() function as well as the plot() graphic from the pipe. I believe that the T pipe is needed because the plot() command naturally exits the pipe and hence str() is not carried out.
	
	# If you're working with functions that don't have a data frame based API (you pass them individual vectors, not a data frame and expressions to be evaluated in the context of that data frame), you might find %$% useful. It explodes out the variables in a data frame so that you can refer to them explicitly. This is useful when working with many functions in base R:
mtcars %$%
	cor(disp, mpg)
	
# For assignment magrittr provides the %<>% operator which allows you to replace code like:
mtcars <- matcars %>%
	transform(cyl = cyl *2)
#with:
mtcars %<>% transform(cyl = cyl *2)
	
	