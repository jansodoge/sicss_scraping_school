####################################### DSSS20 - 4 ####################################
# Etienne Ollion (initially w/ J. Boelaert)
# Loops & Storage

library(RCurl)
library(XML)

# Generate a vector of URLS
## Create a vetor of urls www.thepage.com/q?=1 to www.thepage.com/q?=100
base_path <- "www.thepage.com/q?="
paste0(base_path, 1:100)

##store it in an object called urls
urls <- paste0(base_path, 1:100)

## Create the vector of urls www.thepage.com/q?=1 to www.thepage.com/q?=100, by increment of 10
urls2 <- paste0(base_path, seq(from = 0, to = 100, by = 10))

## Create the vector of urls www.thepage.com/q?=1.htm to www.thepage.com/q?=100.htm
paste0(base_path, 1:100, ".htm")


# One real life example
## Free objects on craigslist San Francisco (http://sfbay.craigslist.org/search/zip)
myseq <- seq(from = 0, to = 1200, by = 120)
craig <- paste0("http://sfbay.craigslist.org/search/zip?s=", myseq)

##We have create a list of the pages we want to visit

## For loops
## Boucle for: 
## Write a loop that prints all numbers from 1 to 10 (print())
##Bonus: add a pause of 1 second between each (Sys.sleep())

for(i in 1:10){
  print(i)
}


########## For and storage
## for loop: 
## Collect and store the first 10 pages of Craigslist SF, free objects
## with a 1 second pause

myseq <- seq(from = 0, to = 1200, by = 120)
craig <- paste0("http://sfbay.craigslist.org/search/zip?s=", myseq)
res <- list()                        ## Creates an empty list
for(i in 1:10) {                    ## For in in 1:10 :
  cat("\rPage num.", i)              ##   Bonus: prints where you are
  
  ##   Stores the page i in the loop i
  res[[i]] <- getURL(craig[i],
                     useragent = "Mozilla/5.0 (Windows NT 6.3; WOW64; rv:43.0) Gecko/20100101, Firefox/43.0", 
                     timeout = 60, 
                     followlocation = TRUE)      
  Sys.sleep(1)                       ##   Goes to sleep for 1 second
}

# parse the page with html parse
tpages <- lapply(res, function(hello) htmlParse(hello))

tpages <- list()
for(i in 1:10) {        
  tpages[[i]] <- htmlParse(res[[i]])
}


# Atthe node level
## Collect headlines on a newsmedia online
### Go to https://www.svt.se/nyheter/ekonomi/, scrape the content, restructure
svt <- getURL("https://www.svt.se/nyheter/ekonomi/",
              useragent = "Mozilla/5.0 (Windows NT 6.3; WOW64; rv:43.0) Gecko/20100101, Firefox/43.0", 
              timeout = 60, 
              followlocation = TRUE)
tsvt <- htmlParse(svt)

## Generate a list of nodes (10)
nodes <- paste0("//article[@class='nyh_teaser nyh_teaser--small lp_item", 1:10, "']")

#Write a loop and collect the information
res <- list()                          ## Create an empty receptacle
for (i in 1:length(nodes)){                           ## Write a loop from 1:10 
  node <- xpathSApply(tsvt, nodes[i])
  
  
  ### Get the title, and the subtitle
  if(length(node)>0){
    title <- xpathSApply(node[[1]], ".//span[@class= 'nyh_teaser__heading-title']", xmlValue)
    subtitle <- xpathSApply(node[[1]], ".//span[@class= 'nyh_teaser__vignette']", xmlValue)
    
  } else {
    title <- NA
    subtitle <- NA
  }
  if (length(title) == 0) {title <- NA}
  if (length(subtitle) == 0) {subtitle <- NA}
  
  onenews <-  cbind(title, subtitle)  ## Bindtogether the title and subtitle
  res[[i]] <- onenews                ## Store your results
  print(i)                           ## Print where you are
}                                  ## Close your loop!

#Transform your list into a dataframe
df <- as.data.frame(do.call(rbind, res))
df
########################### THE END ######################################################
