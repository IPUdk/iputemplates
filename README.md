# IPU Latex Templates #

## Feature Description ##

* The work started in April 2015 with the ipureport class that is based on the scrartcl class.


## Installation ##

* On Linux and Unix/Mac, unzip or copy the bundle to `~/texmf/` or the system-wide installation path.
* On Windows, unzip the bundle to any location and open MiKTeX settings to add location to root folders.

## FAQ and Troubleshooting ## 

IPU uses Arial as main font. If you would like to use it too, you might have to install it. 
Including `\usepackage{uarial}` gives you URW's Arial font and should work out of the box. 
If you have any problems with the package, http://www.tug.org/fonts/getnonfreefonts/ might 
help you. Remember to set `\renewcommand{\familydefault}{\sfdefault}` to switch to 
sans-serif fonts. 

Arial was created as a clone of Helvetica, which part of most Latex distributions. If you do 
not select anything, the classes from the templates will use Helvetica as standard font. Most 
people will not notice the difference and those who do might appreciate this choice. 



 