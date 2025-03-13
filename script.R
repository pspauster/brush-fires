library(tidyverse)
library(RSocrata)

#brush_fires <- read_csv(URLencode("https://data.cityofnewyork.us/resource/8m42-w767.csv?$query=incident_classification='Brush Fire'LIMIT 1000000"))

bf <- read_csv(URLencode("https://data.cityofnewyork.us/resource/8m42-w767.csv?$query=SELECT%0A%20%20%60starfire_incident_id%60%2C%0A%20%20%60incident_datetime%60%2C%0A%20%20%60alarm_box_borough%60%2C%0A%20%20%60alarm_box_number%60%2C%0A%20%20%60alarm_box_location%60%2C%0A%20%20%60incident_borough%60%2C%0A%20%20%60zipcode%60%2C%0A%20%20%60policeprecinct%60%2C%0A%20%20%60citycouncildistrict%60%2C%0A%20%20%60communitydistrict%60%2C%0A%20%20%60communityschooldistrict%60%2C%0A%20%20%60congressionaldistrict%60%2C%0A%20%20%60alarm_source_description_tx%60%2C%0A%20%20%60alarm_level_index_description%60%2C%0A%20%20%60highest_alarm_level%60%2C%0A%20%20%60incident_classification%60%2C%0A%20%20%60incident_classification_group%60%2C%0A%20%20%60dispatch_response_seconds_qy%60%2C%0A%20%20%60first_assignment_datetime%60%2C%0A%20%20%60first_activation_datetime%60%2C%0A%20%20%60first_on_scene_datetime%60%2C%0A%20%20%60incident_close_datetime%60%2C%0A%20%20%60valid_dispatch_rspns_time_indc%60%2C%0A%20%20%60valid_incident_rspns_time_indc%60%2C%0A%20%20%60incident_response_seconds_qy%60%2C%0A%20%20%60incident_travel_tm_seconds_qy%60%2C%0A%20%20%60engines_assigned_quantity%60%2C%0A%20%20%60ladders_assigned_quantity%60%2C%0A%20%20%60other_units_assigned_quantity%60%0AWHERE%20caseless_one_of(%60incident_classification%60%2C%20%22Brush%20Fire%22)"))

brush_fires <- read.socrata("https://data.cityofnewyork.us/resource/8m42-w767.csv?$where=incident_classification='Brush Fire'&$limit=100000")

brush_fires_clean <- brush_fires %>% 
  mutate(month = floor_date(incident_datetime, "month"),
         year = floor_date(incident_datetime, "year"))

brush_fires_monthly <- brush_fires_clean %>% 
  group_by(month) %>% 
  summarize(brush_fires = n()) %>% 
  mutate(month_name = month(month))

write_csv(brush_fires_monthly %>% 
            filter(month >= as.Date("2015-01-01")), "brush_fires_monthly.csv")

brush_fires_yearly <- brush_fires_clean %>% 
  group_by(year) %>% 
  summarize(brush_fires = n())

write_csv(brush_fires_yearly%>% 
            filter(year >= as.Date("2015-01-01")), "brush_fires_yearly.csv")

ggplot(brush_fires_monthly %>% 
         filter(month >= as.Date("2015-01-01")))+
  geom_col(mapping = aes(x=month, y=brush_fires))

ggplot(brush_fires_yearly)+
  geom_col(mapping = aes(x=year, y = brush_fires))

twentyfour_fires <- brush_fires_clean %>% 
  filter(incident_datetime >= "2024-01-01")

cd <- twentyfour_fires %>% 
  group_by(communitydistrict) %>% 
  summarize(fires = n())

write_csv(zips, "fires_by_zip_24.csv")
