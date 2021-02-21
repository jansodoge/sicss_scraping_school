####################################
# Extra
## If you want to know more about headless browsers, look here (section:"Selenium")
##https://cbail.github.io/textasdata/screenscraping/rmarkdown/Screenscraping_in_R.html

# Works with chrome, firefox, phantomjs

library(RSelenium)

# Initialize. If it works, a browser opens up
# Sensitive to the browser version and verion of Rselenium!
remDr <- rsDriver(verbose = T,
                  remoteServerAddr = "localhost",
                  port = 4443L,
                  browser=c("firefox"))
# pick client
rm <- remDr$client

# check if it did work
rm$getStatus()

# Navigate to a webpage
rm$navigate("http://www.google.com") 

# navigate to another webpage
rm$navigate("http://www.blocket.se") 
rm$getCurrentUrl()

# click "accept"
rm$findElement(using = "xpath", 
               '//*[@id="accept-ufti"]')$clickElement()

# go back/forward
rm$goBack()
rm$getCurrentUrl()
rm$goForward()
rm$goBack()

# Uses xpath to locate areas on the page (search bar)
webElem <- rm$findElement(using = 'xpath', '//input[@name = "q"]')
webElem$sendKeysToElement(list("computational social sience", key = "enter"))
rm$getCurrentUrl()

## go back and search for new term
rm$goBack() 
webElem <- rm$findElement(using = 'xpath', '//input[@name = "q"]')
webElem$sendKeysToElement(list("corona", key = "enter"))
rm$getCurrentUrl()

## Gets source code (then you can use classic methods)
page <- unlist(rm$getPageSource()) 
rm$close()

rm(remDr)
rm(rm)
gc()


## If you want to know more about headless browsers, look here (section:"Selenium")
##https://cbail.github.io/textasdata/screenscraping/rmarkdown/Screenscraping_in_R.html
