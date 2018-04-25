### Chapter 8 Workflow: Projects:
### 8.1 What is real?
#As a beginning R user, it's ok to consider your environent real. However, in the long run, you'll be much 
#better off if you consider your R scripts as real. 

#With your R scripts, you can recreate the environment.
#There is a great pair of keyboard shortcuts that will work together to make sure you've 
#captured the important parts of your code in the editor.
# Press command/control + F10 to restart Rstudio
# press command/control + shift + S to rerun the current script.

getwd()

### Chapter 8.2 Where does your analysis live?
#R has a powerful notion of the working directory. this is where R looks for file that you ask it to load and where it will
#put any files that you ask it to save. Rstudio shows your current working directory
#at the top of the console.

#You can set the working directory from within R.
#setwd("/path/to/my/coolproject")

### Chapter 8.3 Paths and directories:
#Paths and directories area little complicated because there are two basic styles of paths: Mac/linux and Windows. There are three chief ways in which they differ:
# 1. The most important difference is how you separate the components of the path. Mac and Linux uses
#    slashes and windows uses backslashes R can work with either type (no matter what platform you're currently using), but unfortunately, backslashes
#    mean something special to R, and to get a single backslash in the path, you need to type two backslashes! So I recommend always using the linux/mac style
#    with forward slashes.
# 2. Absolute paths ( paths that point to the same place regardless of your working directory) look different. In Mac/Linux they start with a slash 
#    "/". You should never use absolute paths in your scripts, because they hinder sharing: no one else will have exactly the same directory as you.
# 3. The last minor difference is the place that ~ points to. ~ is a convenient shortcut to your home directory in Mac/Linux.

### Chapter 8.4 RStudio projects:
# R experts keep all the files associated with a project together -- input data, R scripts, analytical results, figures. This is such a wise and common 
# common practice that Rstudio has built-in support for this via projects.
# Let's make a project for you to use while you're working through the rest of this book. Click file > New Project, then: The following line had me create a working directory within my desktop (the working directory is called r4ds). 

# Inspect the folder associated with your project -- notice the .Rproj file. double click that file to re-open the project. Notice you get back to where you left off: it's the same working directory and command history, and all files you were working on are still open. Because you followed my instructions above, you will, however, have a completely fresh environment, guaranteeing that you're starting with a clean slate. 

#In summary, RStudio projects give you a solid workflow that will serve you well in the future:
#	Create an Rstudio project for each data analysis project.
#	Keep data files there; we'll talk about loading them in R in data import.
#	Keep scripts there; edit the, run them in bits or as a whole.
#	Save your outputs (plots and cleaned data) there.
#	Only ever use relative paths, not absolute paths.


