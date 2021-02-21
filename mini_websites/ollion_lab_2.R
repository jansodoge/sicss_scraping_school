####################################### DSSS19 - 2 ####################################
# Etienne Ollion (initially w/ J. Boelaert)
## Install packages (once and for all)
install.packages(c("RCurl", "XML"))

#Load packages (every time)
library(RCurl)
library(XML)

## Go and visit this page with your browser : 
# http://www.perdu.com

## Build your first browser to collect the content
url <- 'http://www.perdu.com'
getURL(url)

## store the result in an object called 'rawpage'
rawpage <- getURL(url)

## If you wish to see what you have downloaded, use writeLines()
writeLines(rawpage, paste0(getwd(),'/Labs/Lab 2/rawpage.html'))

## Restructure the content using HtmlParse()
tpage <- htmlParse(rawpage) # parse simple

## Collect and restructure the following page: https://liu.se/en/employee/etiol53
url2 <-"https://liu.se/en/employee/etiol53"
rawpage <- getURL(url2)
tpage <- htmlParse(rawpage)

##This is not always so easy
url3 <- 'http://jourdan.ens.fr/~eollion/cours'
rawpage <- getURL(url3)
tpage <- htmlParse(rawpage)
tpage

## "301 Moved Permanently" => followlocation
## We need to build a better crawler
rawpage <- getURL(url3, 
                  followlocation = TRUE)
tpage <- htmlParse(rawpage)
tpage

## "An Error Occurred Setting Your User Cookie" 
# => Accept cookies
url4 <-  'https://www.nrcresearchpress.com/journal/cjfas'
rawpage <- getURL(url4, 
                  followlocation = TRUE)
tpage <- htmlParse(rawpage)
tpage

mycurl <- getCurlHandle()
curlSetOpt(cookiejar= "~/Rcookies", curl = mycurl)
rawpage <- getURL(url4, 
                  followlocation= TRUE, 
                  curl = mycurl)
tpage <- htmlParse(rawpage)
tpage

# IF you are using Mac, you might get this error:
# Error in function (type, msg, asError = TRUE)  : 
# SSLRead() return error -9806
# then try: brew install --with-openssl curl in the terminal (you need Homebrew installed)

## A full crawler (cookies, followlocation, useragent, timeout) -- Recommanded
mycurl <- getCurlHandle()
curlSetOpt(cookiejar= "~/Rcookies", curl = mycurl)
rawpage <- getURL("http://data.hypotheses.org", 
                  curl= mycurl,
                  useragent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36",
                  timeout = 60, 
                  followlocation = TRUE)
writeLines(rawpage, paste0(getwd(),"/Labs/Lab 2/page.html"))
tpage <- htmlParse(rawpage)

############ Exercises
#1. Download : http://jourdan.ens.fr/~eollion/cours/
#2. Save it on your hard drive, open it as an html file
#3. Restructure the content
#4. Can you find a website on which this won't work?


########################### THE END ######################################################