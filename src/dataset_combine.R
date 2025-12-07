library(readr)
library(dplyr)

df1 <- read_csv("query.csv",show_col_types = FALSE)
df2 <- read_csv("query2.csv",show_col_types = FALSE)

combined <- bind_rows(df1,df2)
write_csv(combined, "usgs_data.csv")