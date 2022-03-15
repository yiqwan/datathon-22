library(dplyr)
library(ggplot2)

df = read.csv("google_playstore_external.csv")

# # Analysis # # 
df %>% group_by(Category) %>% filter(Category == "Social") %>% summarise(total = sum(Maximum.Installs)) 
df %>% filter(Developer.Id == "com.facebook.katana") 

# # # Editor choice # # #
df %>% group_by(Editors.Choice) %>% summarise(count = n())
df %>% summary
df %>% filter(Editors.Choice == 'True') %>% select(Installs, Rating, Category) %>% filter(Category == "Health & Fitness") %>% arrange(Category)
df %>% filter(Editors.Choice == 'True') %>% select(Installs, Rating, Category) %>% group_by(Installs) %>% summarise(avg_rating = mean(Rating)) %>% arrange(desc(avg_rating))
# Altho there are only 853 apps that are in the editors choice,
# But maybe it's worth displaying metrics about these apps
# All apps are at least 500k installs
# Some categories have lesser apps
# Can analyse the correlation with between the metrics

# # # Distributions of content rating # # #
df %>% group_by(Content.Rating) %>% select(Content.Rating) %>% summarise(count = n())
# 2 mil of apps are for everyone (a very large portion)
# Maybe we can analyse those that are of other categories

# # # Dstributions of rating # # #
df %>% group_by(Rating.Count) %>% select(Rating.Count) %>% summarise(count = n(), descending = TRUE)
df %>% group_by(Rating) %>% select(Rating) %>% summarise(count = n()) %>% arrange(desc(count))
# Ratings that are 0 have 0 rating count (means no one rated)
# There are 100k of 5 stars. Is it really a good metric? Feel like need to analyse 
# alongside with installs

# # # Developer Id # # #
df %>% group_by(Developer.Id) %>% select(Developer.Id) %>% summarise(count = n()) %>% arrange(desc(count))
df %>% filter(Developer.Id %>% is.na()) %>% summarise(count = n())
df %>% filter(Developer.Id == "") %>% summarise(count = n())
# no developer id is NA, but some (33) are empty

df %>% filter(Installs == "1,000,000,000+") %>% select(Installs, Developer.Id) %>% group_by(Developer.Id) %>% summarise(count = n())
# Can filter out the top 10 developers (metric = installations)

# # # Rating # # #
df %>% filter (Rating == 0 & Rating.Count == 0) %>% summarise(count = n())
df %>% filter (Installs == "1,000,000,000+") %>% select(Minimum.Installs, Maximum.Installs)
# Installs vary across different thresholds
# Using max install is more accurate, but using install can help categorise installation amounts


# # # Cleaning # # #
#df_reduced = df %>% select(App.Name, Category, Rating, Rating.Count, Installs, Free, Ad.Supported:Editors.Choice)
#df_reduced = df_reduced %>% filter(!(is.na(Rating) & is.na(Installs)))

df_re = df %>% filter(Currency == "USD") %>% filter(Rating != "" | Installs != "")
df_re = df_re %>% select(-Minimum.Installs, -Currency, -Minimum.Android, -(Developer.Website:Last.Updated), -Privacy.Policy, -Scraped.Time)
colnames(df_re) = c("App Name", "App Id", "Category", "Rating", "Rating Count", "Install Range", "Estimated Installs", "Free", "Price", "Size", "Developer Id", "Content Rating", "Ad Supported", "In-app Purchases", "Editors Choice") 
df_re %>% write.csv("play_store_cleaned.csv")

df_re %>% dim()
df_re %>% names()
df %>% dim()
df %>% names()
df_re %>% head(2)

df %>% group_by(Ad.Supported) %>% select(Ad.Supported) %>% summarise(count = n()) %>% arrange(desc(count))
df %>% group_by(In.App.Purchases) %>% select(In.App.Purchases) %>% summarise(count = n()) %>% arrange(desc(count))

# # Merging two frames # #

df = read.csv("play_store_cleaned.csv")
review = read.csv("review_clean_1.csv")
# review %>% filter(Sentiment == '')
review %>% names()
colnames(review)[2] = "App.Name"

combined = left_join(df, review, by = "App.Name")

# Testing whether Flashlight app merges perfectly
review %>% filter(App.Name == "Flashlight")
combined %>% names()
combined %>% head(2)
combined %>% filter(Sentiment != '') %>% select(App.Name, Translated_Review, Sentiment) %>% head()

# Change column names
combined = combined %>% select(-X.x, -X.y)

new_colnames = c("app_name", "app_id", "category", "rating", "rating_count", "install_range", "estimated_installs", "price", "size", "developer_id", "content_rating", "ad_supported", "in-app_purchases", "editors_choice", "review", "sentiment", "sentiment_polarity", "sentiment_subjectivity", "review_cleaned") 
new_colnames
colnames(combined) = new_colnames
combined %>% write.csv("play_store_review_merged.csv")


combined %>% names()
combined %>% head(1)
combined %>% dim()
# increased because there are numerous rows of the same app (with diff reviews)
