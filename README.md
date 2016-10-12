# CrimeDataAnalysis
Repo for INRUG experiments using crime data.

INRUG members are working on a project to see what sort of conclusions can be drawn from public GIS and crime data from Spokane Washington.

The data can be found at https://static.spokanecity.org/download/gistransfer/pubdata/Crime.zip 

Supporting data can be found at https://my.spokanecity.org/opendata/gis/data/

There is also a website called "CrimeWatch" that seems to have  a lot of data, but we do not know if it is accessible right now (or if we even need it).

The NACJD [National Archive of Criminal Justice Data](https://www.icpsr.umich.edu/icpsrweb/NACJD/NIBRS/) maintains copies of NIBRS data files from 2010-2014. However, only a few agencies in Spokane County submit the incident-level NIBRS data.  

 - ["Does the NACJD include Spokane data?"](/NACJD_validation/README.md)
 - [https://www.icpsr.umich.edu/icpsrweb/NACJD/series/128](https://www.icpsr.umich.edu/icpsrweb/NACJD/series/128)
 
 


### Questions

Some possible questions with the dataset we agreed on include:

- Looking at Crime in zipcodes over time, does crime get worse before it get better?
- Do we have legit sample sizes?
- Do we have the granularity we will need to develop hypotheses?
- What is the relationship between crime rate and marijuana legalization?
- Are there distance (spatial) effects with crime rate and dispensaries?
- What effect does building and population growth have on crime in different zipcodes (gentrification)?
- Can we build an effect parameter that might inform more accurate taxation on companies regarding indirect community costs of building and growth?
- Is response time to an incident predictable?
- How is a communities demographics related to crime types and rates?
- What are crime rate trends over time? Are they stable?
- How predictable are crime rates at specific periods of time (by month)?
- Can we do some sort of time series analysis (ie ARIMA)
 

## Getting Started

__First, make sure you fork the project on Github__

Clone the project in RStudio. After you make your additions and changes, make sure to push them back to your repository. 

When you are ready to share something with the group, send a 'Pull Request' in Github to Joe, who will merge your changes with the original project. We can then update our 'forked' repos from the original project. 

If you need help getting RStudio and git installed, the  [Using Version Control with RStudio](https://support.rstudio.com/hc/en-us/articles/200532077-Version-Control-with-Git-and-SVN) tutorial will help.

## Using sub-folders

In order to keep things organized, please create a sub-folder for each analysis or sub-project. These will hold all the R scripts,  .Rmarkdown files and any other rendered reports used in your analysis. The final analysis should be rendered as an html_document within each sub-folder.

Data files should be kept in a `/Data` folder under the repository's top folder. This will facilitate using the same data files. The `/Data` folder and contents are listed in the .gitignore file, which prevents them from appearing in the GitHub repository. 

## Publishing an HTML report

The project has a web site located at [https://JoeDumoulin.github.io/CrimeDataAnalysis/](https://JoeDumoulin.github.io/CrimeDataAnalysis/). The site pages are built using the new `render_site()` functionality in RStudio Preview (1.0+). More information is available on the [R Markdown Websites page.](http://rmarkdown.rstudio.com/rmarkdown_websites.html)

Links to your analysis can be added to the project page by:

1. Adding a link yourself. Just edit the 'Index.Rmd' file located in the repository root folder. Then use the `render_site()` function to re-build the index.html file. Send a pull request to Joe to merge your changes. This requires RStudio 1.0+ or higher. 

2. [Posting an issue](https://github.com/JoeDumoulin/CrimeDataAnalysis/issues) to the main project repository. One of the team members with a newer version of RStudio can then add the link for you. 





