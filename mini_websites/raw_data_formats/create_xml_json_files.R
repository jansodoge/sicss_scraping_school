

library(readxl)
library(tidyverse)
tour_de_france <- read_excel("sicss_scraping_school/mini_websites/raw_data_formats/tour_de_france.xlsx")


tour_de_france <- tour_de_france %>% 
  select(Year, 'Total distance (km)', 'Number of stages', Entrants, 
         Finishers, Winner, "Winner's Team", "Winner's Nationality"   )

