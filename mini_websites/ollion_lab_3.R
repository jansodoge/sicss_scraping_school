####################################### DSSS19 - 3 ####################################
# Etienne Ollion (initially w/ J. Boelaert)
# Xpath and Extraction with structured languages

# Other commonly used packages for webscraping in R
# check hem out, there are many tutorials online!
library(rvest)
library(httr)


#Download the content of the page https://aviation-safety.net/database/, restructure it.
library(RCurl)
library(XML)
url <- "https://aviation-safety.net/database/"
page <- getURL(url)
tpage <- htmlParse(page)

## Let's work on the links
## How many (approximatively) links do you count on this page?
length(xpathSApply(tpage, "//a"))

## Extract the values that are hyperlinked
values <- xpathSApply(tpage, "//a", xmlValue)

## Extract the links themselves
link <- xpathSApply(tpage, "//a", xmlAttrs)

#What is the difference between what you did and this?
class_link <-xpathSApply(tpage, "//a/@href")

#Exercise: Plane Crash Database
##Download the page for 1950 http://planecrashinfo.com/1950/1950.htm
url <- 'http://planecrashinfo.com/1950/1950.htm'
page <- getURL(url)

getwd()
writeLines(page, paste0(getwd(),"/Labs/Lab 3/page.html"))# Go check it
tpage <- htmlParse(page)

#-----------------
# Going by columns
#-----------------
# Get Xpaths from selector gadget or similar browser extensions
# e.g. the table or a column of a table
# what does the paths have in common?
column1_row1 <- '//tr[1]/td[1]'
column1_row2 <- '//tr[2]/td[1]'

# Scrape the date
xpathSApply(tpage, "//td[1]", xmlValue)
date <- xpathSApply(tpage, "//td[1]", xmlValue)

# Scrape the location/operator
xpathSApply(tpage, "//td[2]", xmlValue)
location <- xpathSApply(tpage, "//td[2]", xmlValue)

# Scrape the Aircraft
xpathSApply(tpage, "//td[3]", xmlValue)
aircraft <- xpathSApply(tpage, "//td[3]", xmlValue)

#Bind them together
header <- c(date[1], location[1], aircraft[1])
df <- data.frame(date = date[-1], location = location[-1], aircraft = aircraft[-1])
names(df) <- header
head(df)

# When you notice that you are copying and pasteing code alot
# it usually means that you can create a fuction for what you
# are doing! Looks nicer and saves you time.
extract_colum_value <- function(page,
                                column_number,
                                remove_column_header = FALSE){
  xpath_string <- paste0('//td[',column_number,']')
  column_values <- xpathSApply(page, xpath_string, xmlValue)
  
  if(remove_column_header){
    column_values <- column_values[-1]
  }
  return(column_values)
}

date2 <- extract_colum_value(page = tpage, column_number = 1, remove_column_header = F)
date == date2

# Look out for tables with missing values - they can cause problems!
# However, XML is usually taking care of this for you (now).

##Going by rows
url2 <- "http://www.planecrashinfo.com/accidents.htm"
page <- getURL(url2)
writeLines(page, paste0(getwd(),"/Labs/Lab 3/page2.html"))# Go check it
tpage <- htmlParse(page)

###Select the information for the first node
date <- xpathSApply(tpage, "//td[1]")
node1 <- xpathSApply(tpage, "//tr[1]")[[1]] ## Note two differences here. 
### In this node, Extract the information for columns 1, 2, and 9

# airline
cell1 <- xpathSApply(node1, ".//td[1]", xmlValue)
# country
cell2 <- xpathSApply(node1, ".//td[2]", xmlValue)
# comments
cell9 <- xpathSApply(node1, ".//td[9]", xmlValue)

#Same thing for node 2
node2 <- xpathSApply(tpage, "//tr[2]")[[1]]
cell21 <- xpathSApply(node2, ".//td[1]", xmlValue)
cell22 <- xpathSApply(node2, ".//td[2]", xmlValue)
cell29 <- xpathSApply(node2, ".//td[9]", xmlValue)


#Same thing for node 3
node3 <- xpathSApply(tpage, "//tr[3]")[[1]]
cell31 <- xpathSApply(node3, ".//td[1]", xmlValue)
cell32 <- xpathSApply(node3, ".//td[2]", xmlValue)
cell39 <- xpathSApply(node3, ".//td[9]", xmlValue)


# Again, if you are copying and pasting code - write a function!
extract_info_per_row <- function(page, node_nr, column_numbers){
  node <-  xpathSApply(tpage, paste0("//tr[",node_nr,"]"))[[1]]
  
  cells <- c()
  for(i in 1:length(column_numbers)){
    cells[i] <- xpathSApply(node, paste0(".//td[",column_numbers[i],"]"), xmlValue)
  }
  
  return(cells)
  
}


row1_5 <- lapply(1:10, function(x) extract_info_per_row(page = tpage, 
                                                        node_nr = x, 
                                                        column_numbers = c(1,2,9)))
do.call(rbind, row1_5)

## Collect headlines on a newsmedia online
### Go to https://www.svt.se/nyheter/ekonomi/, scrape the content, restructure
mycurl <- getCurlHandle()
curlSetOpt(cookiejar= "~/Rcookies", curl = mycurl)
svt <- getURL("https://www.svt.se/nyheter/ekonomi/",
              useragent = "Mozilla/5.0 (Windows NT 6.3; WOW64; rv:43.0) Gecko/20100101, Firefox/43.0", 
              timeout = 60, 
              followlocation = TRUE,
              curl = mycurl)
tsvt <- htmlParse(svt)

## Find the node (tip: start at the second one)
node <- xpathSApply(tsvt, "//article[@class='nyh_teaser nyh_teaser--small lp_item3']")

### Get the title, and the subtitle
title <- xpathSApply(node[[1]], ".//span[@class= 'nyh_teaser__heading-title']", xmlValue)
subtitle <- xpathSApply(node[[1]], ".//span[@class= 'nyh_teaser__vignette']", xmlValue)


###Devise a strategy in case one of these elements is missing
if (length(title) == 0) {title <- NA}
if (length(subtitle) == 0) {subtitle <- NA}


# do it for all


########################### THE END ######################################################