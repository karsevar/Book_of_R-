#### R for data science #####
## Data Visualization chapter 3 Section 2:
install.packages(tidyverse)
library(tidyverse)

##Interesting addition: If you need to be explicit about where a function (or dataset) coes from, all you need to do is use the special form package::function(). for example, ggplot2::ggplot() tells you explicitly that you're using the ggplot() function from the ggplot2 package.

#First step: do cars with larger engines use more fuel? What does the relationship between engine size and fuel efficiency look like? 
##From my experience with the mtcars dataset I have to say that the relationship between engine displacement and cylinder number is negatively coorelated to fuel efficiency. As for the additional assumption of the trending being linear, I have to say that most of the time a quadratic transformation is needed. Will need to see what the author says about these assumptions.

####3.2.1 The mpg data frame 
#GGplot2 contains a car dataframe called mpg. Interesting addition; a data frame is a rectangular collection of variables (in the columns) and observations (in the rows). mpg contains observations collected by the us environment protection agency in 38 models of cars.
#Interesting all of the observed data was collected from audi autombiles with varying values of displacement. Looking at the values right now another value that should be considered are the ages of the models of each car since an older automodile will clearly be less fuel efficient regardless of engine displacement as well as the addition of four wheel drive will also bring down fuel efficiency. 

dev.new()
ggplot(data=mpg) + geom_point(aes(x=displ,y=hwy))
#Important thing to keep in mind about this graph visualization, the author used highway mileage to illustrate fuel efficiency which is a very interesting touch. 
#Also it seems that when you use ggplot() for a simple graph like the one above you have to place the points in the geom_point() module of the function call for the console to even print the points on the device.

#Conclusion:
#The plot shows a negative relationship between engine size (displ) and fuel efficiency (hwy). In other words, cars with big engines use more fuel. Does this confirm or refute your hypothesis about fuel efficiency and engine size.

##Fun little experiment with the author's data set (since he did not create a graph that considered drive type and cylinder count)
mpg.flea$cyl <- as.factor(mpg$cyl)# Was forced to convert the cylinder count into a factor vector since the aesthetics mapping does not work with continuous variables.
ggplot(data=mpg.flea, aes(x=displ,y=hwy)) + geom_point(aes(shape=cyl,col=drv)) 

##Summary of ggplot():
#with ggplot2, you begin a plot with the function ggplot(). ggplot() creates a coordinate system that you can add layers to. the first argument of ggplot() is the dataset to use in the grapy. So ggplot(data=mpg) creates an empty graph.
#You complete your graph by adding one or more layers to ggplot(). geom_point() adds a layer of points to your plot, which creates a scatterplot. 
#Each geom function in ggplot2 takes a mapping argument. This defines how variables in your dataset are mapped to visual properties. The mapping argument is always paired with aes(), and the x and y arguments of aes() specify which variables to map to the x and ys axes. 

#Template:
#			ggplot(data= <data>) + 
#			<Geom_function>(mapping = aes(<Mapping>))

##3.2.4 Exercises
#1.)
ggplot(data=mpg) #As I suspected nothing was printed onto the device because I did not write the aesthetics mapping geom_point module within the call to ggplot().

#2.) 
nrow(mpg) #The data set has a total of 234 rows (or rather observations).
ncol(mpg) #The data set has a total of 11 columns (or rather categories).

#3.)
??mpg #As I suspected the drv category describes the drive wheels of the observed car. Meaning that there are a total of three different categories within this column (f, which means front wheel drive; r, which means rear wheel drive, and 4, which means 4 wheel drive). 

#4.)
ggplot(data=mpg) + geom_point(aes(x=cyl, y=hwy)) #I believe that this observation should be printed as a shape modifier variable or a boxplot. Will test this same line of code out as a boxplot.

mpg.flea$cyl# Neat the cylinder column is already coded as a factor.
ggplot(data=mpg.flea,aes(x=cyl,y=hwy)) + geom_boxplot()# Much better. As you can see I kept geom_boxplot() empty because I wanted to boxplot to have the same aesthetics mapping as the ggplot() module. 

#From the ggplot() geom_boxplot() documentation: Set of aesthetic mapping created by aes or aes. If specified and inherit.aes=TRUE (the default), it is combined with the default mapping at the top level of the plot. You must supply mapping if there is no plot mapping.

#5.)
mpg.flea$class
mpg.flea$drv
ggplot(data=mpg.flea, aes(x=drv, y=class)) + geom_point(aes(col="black"))# This plot is useless because the two variables are categorical not continuous and from a regression model standpoint there is no way that the driving wheels is an appropriate predictor of the vehicle class (or vice versa). Hence this graph can be considered completely useless from a data science (or rather statistical) point of view.

### 3.3 Aesthetic mappings:
ggplot(data=mpg.flea) + geom_point(aes(x=displ,y=hwy))

#On the upper bounds of the displacement portion of the graph there are five vehicles that have abnormally high highway gas mileage in relationship to their displacement. How can we explain these cars?

#Let's hypothesize that the cars are hybrids. One way to test this hyothesis is to look at the class value for each car. The class variable of the mpg dataset classifies cars into groups such as compact, midsized, and SUV. If the outlying points are hybrids, they should be classified as compact cars or perhaps, subcompact cars (keep in mind that these data was collected before hybrid suvs or trucks became popular). 

#Even with that said, the displacement numbers are just too high for them to be hybrids. Most likely they have cylinder deactivation built into the motor architecture. 

##coding aesthetics:
#You can add a third variable, like class, to the two dimensional scatter plot by mapping it to an aesthetic. An aesthetic is a visual property of the objects in your plot. Aesthetics include things like the size, the shape, or the color of your points. You can display a point in different ways by changing the values of its aesthetic properties. 

ggplot(data=mpg.flea) + geom_point(mapping= aes(x=displ, y=hwy, color=class))# Interesting the aes() function is actually placed with the mapping argument will need to remember this additional phrasing when using ggplot().
#As I suspected the five cars that had adnormally high displacements in relation to highway mileage were two seaters. This means that they were not hybrids or SUVs. In addition after running the code:
mpg$model[mpg$class=="2seater"]
#you can see that the five outliers were all corvettes (which comes with cylinder deactivation technology).

#A little side experiment on the differences between city fuel consumption and highway fuel consumption of each vehicle class type. It seems that the author was right partially that heighted aerodynamics and lower weight of sports cars correlates to higher fuel efficiency despite higher engine displacement. 
dev.new()
ggplot(data=mpg.flea) + geom_point(mapping = aes(x=displ, y=cty, color=class))

#Aesthetics mapping continued:
#To map an aesthetic to a variable, associate the name of the aesthetic to the name of the variable inside aes(). ggplot2 will automatically assign a unique level of the aesthetic to each unique value of the variable, a process known as scaling. 

ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y=hwy,size=class))# In this case, I assigned the class types of the vehicles to the size aesthetic mapping argument. The output was interesting since it said that using discrete variables for the size argument is not advised. Will need to find out what the console meant by this comment. 
#With that said though, using size this way is meaningless since the car class is not a continuous variable.

ggplot(data=mpg) + geom_point(mapping = aes(x=displ,y=hwy,alpha=class))# Interesting you can use the alpha argument in geom_point(). I thought that you can only use alpha for the geom_density() module. 
#After further study this makes perfect sense since we are modifying a point not a polygon (or rather a confidence field). Very interesting addition none the less.
ggplot(data=mpg) + geom_point(mapping = aes(x=displ,y=hwy,shape=class))
#Interesting, Suv was dropped from the legends list and the graph as a whole. The reason for this is ggplot2 will only use six shapes at a time, By default, additional groups will go unplotted when you use the shape aesthetic. 

#For each aesthetic, you use aes() to associate the name of the aesthetic with a variable to display. The aes() function gathers together each of the aesthetic mappings used by a layer and passes them to the layer's mapping argument. The syntax highlights a useful insight about x and y: the x and y locations of the point are themselves aesthetics, visual properties that you can map to variables to display information about the data. Once you map an aesthetic, ggplot2 takes care of the rest. It selects a reasonable scale to use with the aesthetic, and it constructs a legend that explains tha mapping between levels and values. For x and y locations of the point are themselves aesthetics and ggplot2 creates an axis line with tick marks and a label. 

ggplot(data=mpg) + geom_point(mapping = aes(x=displ,y=hwy),color="blue")# through this call you can make all of the points "blue". Will need to see the syntax of this argument though since I thought that you can't manipulate the colors of points out side of the aes() function call.

#Here, the color doesn't convey information about a variable, but only changes the appearance of the plot. to set an aesthetic manually, set the aesthetic by name as an argument of your geom function; it goes outside of the aes() function call. You'll need to pick a value that makes sense for that aesthetic:
#	The name of a color as a character string.
#	The size of a point in mm.
#	The shape of a point as a number (check table 3.1 for a very comprehensive list of shapes and their cooresponding numbers). There are 25 shapes in all: the hollow shapes are 0-14 and their borders are determined by color; the solid shapes 15-18 are filled with color; and filled shapes 21-24 have a border of color and are filled with fill.

## 3.3.1 Exercises:

#1.)
ggplot(data=mpg) + geom_point(mapping = aes(x=displ, y=hwy, color="blue"))#
#The reason why this call did not work in the realm of changing all of the points "blue" is because the argument color needs to be outside of the aes() function call. Hence the line:
ggplot(data=mpg) + geom_point(mapping =aes(x=displ,y=hwy), color="blue") 
#will be the proper way to write this graph. I believe that the color argument in the aes() function call is only for processing variables from the data.frame in the data argument.

#2.) 
??mpg
#To begin; the variables displacement, year, city mileage and highway mileage are all continuous variables. While the variables fuel type, class, model, cylinder, transmission, and manufacturer are all categorical variables. 

#I believe that I may be wrong with considering years as a continuous variable but I will look into this over sight later on through my studies on the subject of statistical inference. 

#3.) How does the aesthetics mapping arguments shape, size, and color graph continuous variables? How does this differ in relation to graphing categorical variables with these same tools?

#Continuous variable experimentation:
ggplot(data=mpg) + geom_point(aes(x=displ, y=hwy, shape=cty))#It seems that shape aesthetic mapping argument doesn't work with continuous variables as the output was an error message saying that continuous variables can't be used with shape mapping aesthetic.
ggplot(data=mpg) + geom_point(aes(x=displ, y=hwy, color=cty))#This argument worked perfectly though since ggplot2 automatically mapped the continuous variable with a color spectrum. I really didn't know that ggplot2 could do this automatically. Very interesting development.
ggplot(data=mpg) + geom_point(aes(x=displ, y=hwy, size=cty))#I already knew that this argument would be able to take continuous variables since the console can change the size of the data point according to the value of the continuous variables. 

#the similarities between the color and size in the way they handled continuous variables are that ggplot2 created a spectrum of sizes and colors and fit the values within these spectrums. Again I didn't know that ggplot2 could do this automatically. 

#Categorical variable experimentation:
ggplot(data=mpg) + geom_point(aes(x=displ, y=hwy, shape=trans))
ggplot(data=mpg) + geom_point(aes(x=displ, y=hwy, size=trans))
ggplot(data=mpg) + geom_point(aes(x=displ, y=hwy, color=trans))
#Just as I suspected for categorical variables the ggplot2 function didn't have to create a spectrum or scale for the size and color arguments. The program just simply assigned a shape, color, or size to a particular categorical value and printed the resulting interpretations to the device.

#4.) 
ggplot(data=mpg) + geom_point(aes(x=displ, y=hwy, shape=class, color=class, size=class))#Interesting the mapping interface overlapped all of the aesthetics to each categorical value. Very interesting development.

#5.) 
ggplot(data=mpg) + geom_point(aes(x=displ, y=hwy, stroke=cty))# I believe that stroke is supposed to make a somewhat continuous line (or rather stroke) with all of the values. Hence the name stroke. Will need to look up the uses of this particular aesthetic argument though. 
??geom_point

#6.) 
ggplot(data=mpg) + geom_point(aes(x=displ, y=hwy, color=displ<5))# Interesting this actually worked. The output of this color argument creates a true or false response within the graphic. Meaning that the color is mapped according to whether a vehicle has an engine displacement above 5 liters or under 5 liters.

### 3.4 Common problems
#Sometimes you'll run the code and nother happens. Check the left-hand of your console: if it's a +, it means that R doesn't think you've typed a complete expression and it's waiting for you to finish it. In this case, it's usually easy to start from scratch again by pressing escape to abort processing the current command. You can get help about any R function by running ?function_name in the console.

### 3.5 Facets:
#One way to add additional variables is with aesthetics. Another way, particularly useful for categorical variables, is to split your plot into facets, subplots that each display one subset of the data. 

#to facet your plot by a single variable, use facet_wrap(). The first argument of facet_wrap() should be a formula, which you create with ~ followed by a variable name. The variable that you pass to facet_wrap() should be discrete.

ggplot(data=mpg) + geom_point(aes(x=displ, y=hwy)) + 
facet_wrap(~class,nrow=2)# Interesting this call splits the data according to the class of the vehicles. Each data scatterplot is divided into a 2 in each row kind of grid. Will need to see what happens if I split the vehicles with a difference categorical variable or change the nrow=2 argument into ncol=3.

#Experiment:
ggplot(data=mpg) + geom_point(aes(x=displ, y=hwy)) + 
facet_wrap(~trans,ncol=3)# This line of code actually worked perfectly. 

#to facet your plot on the combination of two variables, add facet_grid() to your plot call. The first argument of facet_grid() is also a formula. This time the formula should contain two variable names separated by a ~. 
ggplot(data=mpg) + geom_point(mapping = aes(x=displ, y=hwy)) +
facet_grid(drv~cyl) #Interesting this facet_grid() equation ordered the different scatterplots to feature the number of cylinders in relation to the driving wheels of the vehicle. Will need to see what happens if I change the facet_grid() argument to have cyl~drv instead of drv~cyl.

#Experiment:
ggplot(data=mpg) + geom_point(mapping = aes(x=displ, y=hwy)) + 
facet_grid(cyl~drv)# so through change the positioning of the cyl and drv variables you are telling the console to print the drive wheel variables on the rows and the cylinder numbers on the columns. 

#If you prefer to not facet in the rows or columns dimension, use a - instead of a variable name.
ggplot(data=mpg) + geom_point(mapping = aes(x=displ, y=hwy)) + facet_grid(.~drv)# this is for the column dimension. 
ggplot(data=mpg) + geom_point(mapping = aes(x=displ, y=hwy)) + facet_grid(drv~.)# this is for the row dimension.

###3.5.1 Exercises:
#1.) What happens if you facet on a continuous variable?
ggplot(data=mpg) + geom_point(mapping = aes(x=displ, y=hwy)) + facet_grid(~cty)
#facet_grid() will be more or less able to facet continuous variable but the end result would be an impractical graph since the facets will be too small to discern any important statistic information. Hence in other words, facets are only useful when applied to categorical variables (as well as discrete variables).

#2.) 
ggplot(data=mpg) + geom_point(mapping= aes(x=displ, y= hwy)) + facet_grid(drv~cyl)
#The empty spaces illustrate that for particular number of cylinders some drive wheel configurations are not available. Meaning that for four cylinder vehicles there a large amount of four wheel drive and front wheel drive models but there are no rear wheel drive models in the sample. As for five cylinders, there are only front wheel drive configurations available in the sample (most likely these samples are volve station wagons. Interesting that they did not use the five cylinder Audi quattro).

#3.) 
ggplot(data=mpg) + geom_point(mapping= aes(x=displ, y= hwy)) + facet_grid(.~cyl)
#In this case, the columns were kept from being faceted. All of the facets were printed into the device in a row wise fashion.
dev.new()
ggplot(data=mpg) + geom_point(mapping= aes(x=displ, y= hwy)) + facet_grid(cyl~.)
#In this case, the rows were kept from being faceted. All of the facets were printed into the device in a column wise fashion.

#4.) 
ggplot(data=mpg) + geom_point(mapping= aes(x=displ, y= hwy)) + facet_wrap(~class, nrow=2)

#Experiment using the aesthetics map to plot the vehicle classes as point colors in place of different facets.
dev.new()
ggplot(data=mpg) + geom_point(mapping= aes(x=displ, y= hwy, color=class))
#From what I can see using the faceting function can help a person find particular trends in a specific category of a data set. This means that through faceting the data set mpg by the vehicle class you can explore different trends for 2seater vehicles, SUVs, Trucks, or even mid sized sedans while through the normal method of plotting all of these categories in one scatterplot keeps you from making these category specific assumptions. The disadvantages to this method is that in order to create a scalable regression model or rather a statistical inference you are forced to generalize between different categories and because of that the use of faceting might cause a data scientist to over fit his model.

#5.)
??"facet_wrap"
#nrow and ncol controls the number of rows and columns the facets are allowed to be printed on in the device. 
#The different layout control options include: 
#	scales: Which is fixed by default but can be set to free if one desires.
#	Shrink: If true, will shrink scales to fit output of statistics, not raw data. If false, will be range of raw data before statistical summary.
#	labeller: A funciton that takes one data frame of labels and returns a list or data frame of character vectors.
#	switch:: By default, the labels are displayed on the top and right of the plot. If x the top labels will be displayed to the bottom. If y, the right-hand side labels will be displayed to the left.
#	drop: If true, the default, all factor levels not used in the data will automatically be dropped. If false, all factor levels will be shown, regardless of whether or not they apear in the data.
#	dir: direction: either h for horizontal, the default, or v for vertical.
#	strip.position: By default, the labels are displayed on the top of the plot. Using strip.position it is possible to place the labels on either of the four sides by setting strip.position = c("top","bottom","left","right").

??facet_grid()
#A formula with the rows (of the tabular display) on the LHS and the columns (of the tabular display) on the RHS; the dot in the formula is used to indicate there should be no faceting on this dimension (either row or column). The formula can also be provided as a string instead of a classical formula object.

#6.) 
ggplot(data=mpg) + geom_point(mapping= aes(x=displ, y= hwy, color=class)) + facet_grid(class~cyl)

ggplot(data=mpg) + geom_point(mapping= aes(x=displ, y= hwy, color=class)) + facet_grid(cyl~class)
#I have no idea why one needs to place the variable with the most distinct levels in the columns place when calling facet_grid() will need to look into this later on through my studies.

### Chapter 3.6 Geometric Objects:
ggplot(data=mpg) + geom_point(mapping= aes(x=displ, y= hwy))
dev.new()
??"geom_point()"
ggplot(data=mpg, aes(x=displ, y= hwy)) + geom_point() + geom_smooth(method="loess", inherit.aes=FALSE)# Interesting I can't find a function that can remove the points from the graph. Will need to look up how I can carry this out. It seems that I was right the author used a loess probability densition function with a default scape parameter. 

#A geom is the geometrical object that a plot uses to represent data. People often describe plots by the type of geom that the plot uses. For example, bar charts use bar geoms, line charts line geoms, boxplots use boxplot geoms, and so on. Scatterplots break the trend: they use the point geom. As we see above, you can use different geoms to plot the same data. The plot on the left uses the point geom, and the plot on the right uses the smooth geom, a smooth line fitted to the data.

#To change the geom in your plot, change the geom function that you add to ggplot().

#Example code:
ggplot(data=mpg) + geom_point(mapping= aes(x=displ, y=hwy))
dev.new()
ggplot(data=mpg) + geom_smooth(mapping = aes(x=displ, y=hwy))#Interesting through this line of code you can recreate the image in the book. The points are not plotted onto the graphic through this method. It seems that method="loess" is the default for this geometrical layer. Will need to look into this in the documentation. 

##geom_smooth() documentation:
??"geom_smooth()"
# Interesting when the method is not disclosed in the geometric layer call. the function is set to auto meaning that the program will pick the appropriate method according to its sample size. Since the sample size is only 243 I believe that the program used the "loess" method on the data set. Will need to look into this.

#You can set the linetype of a line in the geom_smooth() geometric layer through the argument line type in the aesthetics function.
#Example of this feature:
ggplot(data=mpg) + geom_smooth(mapping = aes(x=displ, y=hwy, linetype=drv))# the result of this line of code is that the console created different loess linear models for each drive wheel type in the data set. Hence meaning that four wheel drive, front wheel drive, and rear wheel drive vehicles have their own specific loess linear model. Very interesting I didn't know that you can use the aesthetics mapping function in the geom_smooth() geometric layer. 
#Through writing linetype=drv you are telling the console to map line types to the drive wheel configuration of the vehicle.

##Author's explaination:
#Here geom_smooth() separates the cars into three lines based on their drivetrain configuration. One line describes all of the points with a 4 value, one line describes all of the points with a f value, and on line describes all of the points with an r value. 

#chapter 3.6.1 colored representation reproduction:
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point(aes(color=drv)) + geom_smooth(aes(linetype=drv, color=drv))# Neat this is an exact reproduction of the graphic in the book. Very interesting though since I didn't know that you had to put the variables for x and y in the initial geometrical layer call (ggplot()). Through doing this little modification this line of code works perfectly.

#Neat the author gives you a cheat sheet of all of the geometrical layers one can place in a ggplot() function call. Here is the link: http://rstudio.com/cheatsheets 

#Many geoms, like geom_smooth(), use a single geometric object to display multiple rows of data. For these geoms, you can set the group aesthetic to a categorical variable to draw multiple object. ggplot2 will draw a separate object for each unique value of the grouping variable. In practice, ggplot2 will automatically group the data for these geoms whenever you map an aesthetic to a discrete variable. It is convenient to rely on this feature because the group aesthetic by itself does not add a legend or distinguishing features to the geoms. 

gg1 <- ggplot(data=mpg) + geom_smooth(mapping=aes(x=displ,y=hwy))
gg2 <- ggplot(data=mpg) + geom_smooth(mapping=aes(x=displ,y=hwy, group=drv))
gg3 <- ggplot(data=mpg) + geom_smooth(mapping=aes(x=displ,y=hwy,color=drv), show.legend=FALSE)
library(gridExtra)
grid.arrange(gg1,gg2,gg3)

##the author's answer to displaying multiple geom functions in one device through the use of ggplot2:
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy)) + geom_smooth(mapping = aes(x=displ,y=hwy))

##Or you could use this line of code instead:
dev.new()
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point() + geom_smooth()
#these two plots are completely identical. 

##Interesting the author finds out about this deficiency and uses the same fix as me:
#You can avoid the repetition of writing the variables in each geom function through just passing a set of mappings to ggplot(). The ggplot2 console will treat these mappings as global mappings that apply to each geom in the graph. 
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point() + geom_smooth()# As I said, interesting same solution.

#If you place mappings in a geom function, ggplot2 will treat them as local mappings for the layer. It will use these mappings to extend or overwrite the global mappings for that layer only. This makes it possible to display different aesthetics in different layers. 
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point(mapping = aes(color=class)) + geom_smooth()

#You can use the same idea to specify different data for each layer. here, our smooth line displays just a subset of the mpg dataset, the subcompact cars. The local data argument in geom_smooth() overrides the global data argument in ggplot() for that layer only.
library(tidyverse)
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point(aes(color=class)) + geom_smooth(data=filter(mpg,class=="subcompact"), se=FALSE)# Perfect this line of cade did not work at the beginning but after loading tidyverse through the call library(tidyverse) this line worked perfectly.
#One addition to keep in mind, the argument se in the geom_smooth function call is actually an argument that tells the console to show the confidence levels or not. The default is se=TRUE.

## chapter 3.6 Exercises:
#1.) 
#	I will use an area chart as a means to draw a line chart. Honestly though I really don't know if this is the right answer, will need to look this up.

#2.)	
#	I believe that this line of code will create a scatterplot that displays the displacement value of the vehicles in the data set by the highway mileage. In addition, all of the points will be colored according to the drivetrain configuration of each vehicle and a loess line will be drawn on the davice without the confidence intervals.

ggplot(data=mpg, mapping = aes(x=displ, y=hwy, color=drv)) + geom_point() + geom_smooth(se=FALSE)
#I was correct about the color of the points and that the loess line will have no confidence intervals attached to it. The main thing that I got wrong is that I forgot to say that there will be separate lines illustrating the vehicles' drivetrain configuration.

#3.) 
ggplot(data=mpg, mapping = aes(x=displ, y=hwy, color=drv)) + geom_point(show.legend=FALSE) + geom_smooth(se=FALSE, show.legend=FALSE) 
# the argument show.legend= FALSE tells the console to remove the legend in either the linear model or the points. I believe that the auther used this tool as a means to save space since he clearly used a facet.wrap() function call to combine the three plots into one device. Hence removing the legend saves quite a bit of space.

#4.)
ggplot(data=mpg, mapping = aes(x=displ, y=hwy, color=drv)) + geom_point() + geom_smooth(se=TRUE)
dev.set(3)
ggplot(data=mpg, mapping = aes(x=displ, y=hwy, color=drv)) + geom_point() + geom_smooth(se=FALSE)
# As you can see after running these two lines the se argument in the geom_smooth layer tells the console whether to print the confidence intervals with the loess line or ignore the confidence intervals altogether.

#5.) 
ggplot(data=mpg, mapping = aes(x=displ, y=hwy)) + geom_point() + geom_smooth()
dev.set(4)
ggplot() + geom_point(data=mpg, mapping = aes(x=displ, y=hwy)) + geom_smooth(data=mpg, mapping = aes(x=displ, y=hwy))
# I believe that both of these ggplot() command calls will create identical scatterplots because they are both using the same variables and data set. In other words, through typing the data= mpg, aes(x=displ, y=hwy) arguments in each geometric layer you are practically doing the same thing that ggplot() will do with the information, which is it will pass all of these commands to each geom function in the command call. 

#6.)
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_smooth(se= FALSE) + geom_point()
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_smooth(data=filter(mpg,drv=="f"),se= FALSE, show.legend=FALSE) + geom_smooth(data=filter(mpg,drv=="4"), se=FALSE, show.legend=FALSE) + geom_smooth(data=filter(mpg,drv=="r"), se=FALSE, show.legend=FALSE) + geom_point()
# I can't seem make the three loess lines the same color. Will need to look into what I'm doing wrong. 
# I take that back I found a perfect run around. Not really sure if this solution is what the auther had in mind but it seems to work perfectly. 
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_smooth(aes(color=drv),se= FALSE) + geom_point(aes(color=drv))
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_smooth(se=FALSE) + geom_point(aes(color=drv))
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_smooth(aes(linetype=drv),se= FALSE) + geom_point(aes(color=drv))
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point(aes(fill=drv), shape=21, color="white", size=10)

### 3.7 Statistical Transformations:
#Consider a basic bar chart, as drawn with geom_bar(). The following chart displays the total number of diamonds in the diamonds dataset, grouped by cut. The diamonds dataset comes in ggplot2 and contains information about ~54,000 diamonds, including the price, carat, color, clarity, and cut of each diamond.
ggplot(data=diamonds) + geom_bar(mapping=aes(x=cut))

#On the x-axis, the chart displays cut, a variable from diamonds. On the y-axis, it displays count. bar charts calculate new values to plot:
#	bar charts, histograms, and frequency polygons bin your data and then plot bin counts, the number of point that fall in each bin.
#	smoothers fit a model to your data and then plot predictions from the model.
#	Boxplots compute a robust summary of the distribution and then display a specially formatted box.

#The algorithm used to calculate new values for a graph is called a stat, short for statistical transformation. The process requires the use of geom_bar().
#You can learn which stat a geom uses by inspecting the default value for the stat argument. For example, geom_bar() shows that the default value for stat is count, which means that geom_bar() uses stat_count(). stat_count() is documented on the same page as geom_bar(), and if you scroll down you can find a section called "computed variables". That describes how it computes two new variables: count and prop. 
??"geom_bar()" 
??"stat_count()"# It seems that I can't log onto the help file for stat_count(). Will need to check if my console is in working order before preceeding through the chapter. The console is working, I believe this means that there is no documentation interestingly for stat_count() or rather that the documentation is connected with geom_bar() somehow. 

#You can generally use geoms and stats interchangeably. For example, you can recreate the previous plot using stat_count() instead of geom_bar()
ggplot(data=diamonds) + stat_count(mapping=aes(x=cut))# Interesting so this means that stat_count() shares the same functionality with geom_bar().

#this works because every geom has a default stat; and every stat has a default geom. This means that you can typically use geoms without worrying about the underlying statistical transformation. There are three reasons you might need to use a stat explicitly:
#	1. You might want tooverride the default stat. In the code below, I change the stat of geom_bar() from count to identity. This lets me map the height of the bars to the raw values of a y variable. Unfortunately when people talk about bar charts casually, they might be referring to this type of bar chart, where the height of the bar is already present in the data, or the previous bar chart where the height of the bar is generated by counting rows.
demo <- tribble(
~cut,~freq,
"Fair",1610,
"Good",4906,
"Very Good",	12083,
"Premium",13791,
"Ideal",	21551
)
# For more documentation on tribbles look at the following link: https://cran.r-project.org/web/packages/tibble/tibble.pdf
dev.new()
ggplot(data=demo) + geom_bar(mapping = aes(x=cut, y=freq),stat= "identity")

#	2. You might want to override the default mapping from transformed variables to aesthetics . For example, you might want to display a bar chart of proportion, rather than count:
ggplot(data=diamonds) + geom_bar(mapping = aes(x=cut, y=..prop.., group=1))

#	3. You might want to draw greater attention to the statistical transformation in your code. For example, you might use stat_summary(), which summarises the y values for each unique x value, to draw attention to the summary that you're computing: 
ggplot(data=diamonds) + stat_summary(
mapping = aes(x=cut, y=depth),
fun.ymin = min,
fun.ymax = max,
fun.y = median
)
#Now I understand this is a ggplot2 equivalent to the base R graphic quantile function. Very neat addition.

###Chapter 3.7 Exercises:
#1.)
??"stat_summary()"
#According to the documentation the default geom that is attached to stat_summary() are called geom_histogram() and geom_freqpoly. 
ggplot(data=diamonds) + geom_histogram(mapping = aes(x=cut, y=depth), fun.ymin= min, fun.ymax=max, fun.y = median)# It seems that geom_histogram can't process the functions fun.ymin, fun.ymax and fun.y = median. I believe that the geom geom_freqpoly will be able to plot these parameters. Will need to see why histogram can't print these parameters later on through my studies.

ggplot(data=diamonds) + geom_freqpoly(mapping = aes(x=cut, y=depth), fun.ymin= min, fun.ymax=max, fun.y = median)# seems like both of these geometric parameters can't process the functions fun.ymax, fun.ymin, and fun.y = median. Will need to look up a possible solution to this problem. 

ggplot(data=diamonds) + geom_boxplot(mapping = aes(x=cut, y=depth))# It seems that this is the closest I can get to the author's representation at this point. Will need to look into how I can modify geom_boxplot() to fit my needs. 

#2.) 
??"geom_col()"
#Documentation summary: There are two types of bar charts: geom_bar makes the height of the bar proportional to the number of case in eachgroup (or if the weight aethetic is supplied, the sum of weights). If you want the heights of the bars to represent values in the data use geom_col instead.
ggplot(data=diamonds) + geom_bar(mapping = aes(x=cut, y=depth))#Interesting so you can't use the y aesthetic with this function but you can use the y aesthetic with the function geom_col() because the function creates its own weighting values with the inputted data from the y axis. geom_bar uses stat_count by default: it counts the number of cases at each x position. geom_col uses stat_identity: it leaves the data as is.
 
ggplot(data=diamonds) + geom_col(mapping = aes(x=cut, y=depth))	

#4.) 
??"stat_smooth"
#Geom_smooth(): Aids the eye in seeing patterns in the presence of overplotting. geom_smooth and stat_smooth are effectively alieases: they both use the same arguments. Use geom_smooth unless you want to display the results with a non-standard geom.
# From what I can remember after using this function multiple times in Tilman Davies' Book of R you can control the behavior of geom_smooth extensively through the arguments method, formula, se, na.rm, show.legend, span, fullrange, and level. The rest are very much the same among all the other geom layers. 

#5.) 
ggplot(data=diamonds) + geom_bar(mapping= aes(x=cut, y=..prop..,group=1))
dev.set(3)
ggplot(data=diamonds) + geom_bar(mapping=aes(x=cut,y=..prop..,fill=color, group=1))	
#Now I understand, the group=1 modifier makes the console chart the variables as a proportion instead of count.

### Chapter 3.8 Position adjustments:
#You can color a bar chart using either the color aesthetic or more usefully fill:
ggplot(data=diamonds) + geom_bar(mapping =aes(x=cut, color=cut))
ggplot(data=diamonds) + geom_bar(mapping = aes(cut, fill=cut))

#Note what happens if you amp the fill aesthetic to another variable, like clarity: the bars are automatically stacked. Each colored rectangle represents a combination of cut and clarity.
ggplot(data=diamonds) + geom_bar(mapping=aes(x=cut,fill=clarity))

#The stacking is performed automatically by the position adjustment specified by the position argument. If you don't want a stacked bar chart, you can use one of three other options: "identity", "dodge", and "fill".
#	Position = "identity" will place each object esactly where it falls in the context of the graph. This is not very useful fr bars, because it overlaps them. To see that overlapping we either need to make the bars slightly transparent by setting alpha to a small value. or completely transparent by setting fill = NA.
ggplot(data=diamonds) + geom_bar(mapping=aes(x=cut,fill=clarity), alpha = 0.30, position="identity")
ggplot(data=diamonds) + geom_bar(mapping=aes(x=cut, color=clarity), fill=NA, position = "identity")

#	Position = fill works like stacking, but makes each set of staked bars the same height. this makes it easier to compare proportions acreoss groups. 
ggplot(data=diamonds) + geom_bar(mapping=aes(x=cut,fill=clarity), position="fill")

# position = dodge places overlapping objects directly beside one another. this makes it easier to compare individual values.
ggplot(data=diamonds) + geom_bar(mapping=aes(x=cut,fill=clarity), position="dodge")

##Another method that can be used to enrich the experience of using a scatterplot is the position="jitter" function which tells the console to place a specific amount of noise between values meaning that plots won't mask each other as readily. 
ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y = hwy), position="jitter")
#ggplot2 comes with a short hand for this method which is called geom_jitter.

###chapter 3.8 Exercises:
#1.) 
ggplot(data=mpg, mapping= aes(x=cty, y=hwy)) + geom_point(position="jitter")# Most likely the main problem is that the grqphic might have too much overlap between points thus making the amount of samples look relatively small according to the graph. Hence good fix for this problem is to use the position="jitter" method call.

#2.) 
??geom_jitter
#the amount of jitter between the points through this method can be changed by inputting the width (for horizontal jitter) and height (vertical jitter) variables. The default values are set to 40% percent respectively.

#3.) 
??geom_count()
#This is a variant of geom_point that counts the number of observations at each location, then maps the count to point area. If useful when you have discrete data and overplotting.
ggplot(data=mpg, mapping= aes(x=cty, y=hwy)) + geom_count(position="jitter")# Cool so in other words, this geometric layer counts the amount of times a value falls into a particular position in a chart and changes the size of the scatterplot point accordingly. Very useful in seeing the amount of points in one particular place. It's more scientific than the geom_jitter option (which is just for aesthetics).
??geom_jitter()
ggplot(data=mpg, mapping= aes(x=cty, y=hwy)) + geom_jitter()

#4.) 
??geom_boxplot()
#the defualt position value is "dodge for geom_boxplot(). Will need to look into this.
ggplot(data=mpg, mapping= aes(x=class, y=cty)) + geom_boxplot(position="dodge", aes(fill=class))
ggplot(data=mpg, mapping=aes(x=cty, y=hwy)) + geom_boxplot(position="dodge",alpha=0.5,aes(fill=class))

### 3.9 Coordinates systems:
#The default coordiate system is the cartesian coordinate system where the x and y positions act independently to determine the location of each point.there are a number of other coordinate systems that are occasionally helpful.

#	coord_flig() switches the x and y axes. this is useful, if you want horizontal boxplots. It's also useful for long labels: it's hard to get them to fit without overlapping on the x-axis.
ggplot(data=mpg, mapping = aes(x=class,y=hwy)) + geom_boxplot()
ggplot(data=mpg, mapping=aes(x=class, y=hwy)) + geom_boxplot() + coord_flip()

#	coord_quickmap() sets the aspect ratio correctly for maps. This is very important it you're plotting spatial data with ggplot2.
library("maps")
nz <- map_data("nz")
ggplot(nz, aes(long,lat,group=group)) + geom_polygon(fill="white",color="black")
ggplot(nz, aes(long,lat,group=group)) + geom_polygon(fill="white", color="black") + coord_quickmap()	

#	coord_polar() uses polar coordinates. Polar coordinates reveal an interesting connection between a bar chart and a Coxcomb chart:
bar <- ggplot(data=diamonds) + geom_bar(
mapping= aes (x=cut, fill=cut),
show.legend=FALSE,
width=1) +
theme(aspect.ratio=1) + labs(x=NULL, y=NULL) 

bar + coord_flip()
bar+ coord_polar()

### chapter 3.9 Exercises:
#1.) 
gg.me <- ggplot(data=diamonds) + geom_bar(mapping=aes(x=cut, fill=clarity), position="fill")
gg.me + coord_polar()

#2.) the labs() module creates the labels for the x and y axes of the chart you are creating with ggplot() much like the base graphic's legend() function call.

#3.)
??coord_quickmap()# Projects a portion of the arth, which is approximately spherical, onto a flat 2D plane using any projection defined by the mapproj package. Map projections do not, in general, preserve straight lines, so this requires considerable computation. coord_quickmap is a quick approximation that does preserve straight lines. It works best for smaller areas closer to the equator.
??coord_map()

#4.) 
ggplot(data=mpg, mapping=aes(x=cty, y=hwy)) + geom_point() + geom_abline() + coord_fixed(ratio=0.5)
??coord_fixed()# No idea about the significance of this function in relation to the entire linear model. I find it very interesting none the less since at the beginning of the graphic it says that 10 cty miles is equivalent to 11 cty miles. Will need to look into this model later. Must be a way to create a simplistic linear regression model.
pred <- lm(data=mpg, hwy~cty)
summary(pred)
pred2 <- predict(pred, newdata=data.frame(cty=c(seq(1,100, length.out=50))), interval="prediction", level=0.95)
ggplot(data=mpg, mapping=aes(x=cty, y=hwy)) + geom_point() + geom_abline(aes(pred))# Will need to findout how this geometric function works later on through my studies.
