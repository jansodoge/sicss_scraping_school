

library(readxl)
library(tidyverse)
library(rjson)
library(kulife)
tour_de_france <- read_excel("sicss_scraping_school/mini_websites/raw_data_formats/tour_de_france.xlsx")


tour_de_france <- tour_de_france %>% 
  select(Year, 'Total distance (km)', 'Number of stages', Entrants, 
         Finishers, Winner, "Winner's Team", "Winner's Nationality"   )

json_tour_de_france <- toJSON(unname(split(tour_de_france, 1:nrow(tour_de_france))))

write(json_tour_de_france, "tour_de_france.json")


#to write XML file
write.xml(tour_de_france, file= "tour_de_france.xml")