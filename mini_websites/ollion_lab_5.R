####################################### DSSS20 - 5 ####################################
# Etienne Ollion (initially w/ J. Boelaert)
# Regular Expressions

## Miles Davis on allmusic.com
## ("http://www.allmusic.com/artist/miles-davis-mn0000423829/discography")

library(RCurl)
library(XML)
url <- 'http://www.allmusic.com/artist/miles-davis-mn0000423829/discography'
rawpage <- getURL(url,
                  followlocation = T)
cleanpage <- htmlParse(rawpage)


# alternative for Windows 10 users
library(httr)
rawpage2 <- GET(url)
cleanpage2 <- htmlParse(rawpage2)


##  1)  Extract informations about: year, title, label
##########
year <- xpathSApply(cleanpage2, "//td[@class='year']", xmlValue)
title <- xpathSApply(cleanpage2, "//td[@class='title']", xmlValue)
label <- xpathSApply(cleanpage2, "//td[@class='label']", xmlValue)

## Alternatively, tables can be extracted with readHTMLTable
table <- readHTMLTable(cleanpage)
str(table)
table <- table[[1]] # Why do this? 
table[,3:5]

##  2) Time to cleanup!

## Remove \n 
year <- gsub(pattern = "\\n", replacement = "", x = year) 
## Remove extra spaces
year <- gsub(pattern = " ", replacement = "", x = year)       
year <- gsub("^\\s+|\\s+$", "", year)  
year <- as.numeric(year)

## Remove \n 
title <- gsub("\\n", "", title)   

## Remove extra spaces
# We do not want to remove all spaces
title <- gsub("^\\s+|\\s+$", "", title) 

## Remove \n 
label <- gsub("\\n", "", label) 
## Remove extra spaces
label <- gsub("^\\s+|\\s+$", "", label)  

# copy and pasteing - try to make it into a function!
clean_string <- function(unclean_vector){
  res <- gsub("\\n", "", unclean_vector)   ## Remove \n 
  res <- gsub("^\\s+|\\s+$", "", res)  ## Remove extra spaces
  
  return(res)
}

year <- xpathSApply(cleanpage2, "//td[@class='year']", xmlValue)
year <- clean_string(unclean_vector = year)


## 3) Store them in a dataframe (difference with a matrix?)
miles <- data.frame(year, title, label, stringsAsFactors = F)
head(miles)

## 4) Only preserve those from Prestige
## Using grep, write a function that selects the right label
grep("Prestige", miles$label)    
## Using indexing, create a new dataset
df_prestige <- miles[grep("Prestige", miles$label), ] 

## 5) Keep titles that have Miles/miles in it (case does not matter)
## Using grep, write a function that selects the right label
grep("[Mm]iles", miles$title)    
## Using indexing, create a new dataset
dat <- miles[grep("[Mm]iles", miles$title), ] 
dim(dat)

miles[grep("[Tt]he", miles$title), ] 

## 6) Extract what comes after Miles in the title
gsub("^(.*[Mm]iles) (.*)", "\\2", dat$title)

## 6) Extract the first words that comes after Miles in the title
gsub("^(.*[Mm]iles) (\\w+|&).*", "\\2", dat$title)
gsub("^(.*[Mm]iles) ([a-zA-Z0-9&]+).*", "\\2", dat$title)

## 7) Extract what comes before Miles in the title
gsub("^(.*)[Mm]iles(.*)", "\\1", dat$title)
gsub("^(.*[Mm]iles) (.*)", "\\1", dat$title)



# more modern packages:
library(stringr)
library(stringi)

## 4) Only preserve those from Prestige
stri_detect(regex = 'Prestige', miles$label)
grep("[Mm]iles", miles$title)    


########################### THE END ######################################################