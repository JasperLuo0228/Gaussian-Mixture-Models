# clustering_dbscan.R

library(dbscan)
library(ggplot2)
library(dplyr)

# Load Data

df <- read.csv("data/usgs_data.csv")

# Keep only needed columns
df_clean <- df %>%
  select(longitude, latitude, depth, mag) %>%
  na.omit()
cat("Loaded", nrow(df_clean), "earthquake records.\n")

# Standardization

X <- scale(df_clean[, c("longitude", "latitude", "depth", "mag")])

# kNN Distance Plot 

kNNdistplot(X, k = 4)
abline(h = 0.25, col = "darkred", lty = 2)
png("figures/dbscan_kNN_distance_plot.png", width = 1200, height = 800)
kNNdistplot(X, k = 4)
abline(h = 0.25, col = "darkred", lty = 2)
dev.off()

cat("kNN distance plot saved: figures/dbscan_kNN_distance_plot.png\n")

# Fit DBSCAN

eps_value <- 0.3   # change this based on the kNN plot!!
minPts_value <- 10

cat("Running DBSCAN with eps =", eps_value,
    "and minPts =", minPts_value, "\n")

db <- dbscan(X, eps = eps_value, minPts = minPts_value)

df_clean$cluster <- as.factor(db$cluster)

cat("DBSCAN produced", length(unique(db$cluster)), "clusters.\n")

# Visualization

p <- ggplot(df_clean, aes(x = longitude, y = latitude, color = cluster)) +
  geom_point(alpha = 0.7, size = 1.2) +
  scale_color_discrete(name = "Cluster") +
  theme_minimal() +
  ggtitle(paste("DBSCAN Earthquake Clustering (eps =", eps_value, ", minPts =", minPts_value, ")"))

ggsave("figures/earthquake_dbscan_clusters.png",
       p, width = 7, height = 5)
cat("Cluster plot saved: figures/earthquake_dbscan_clusters.png\n")


cat("DBSCAN clustering finished. Output saved to figures/.\n")