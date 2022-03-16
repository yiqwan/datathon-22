library(stringr)
library(dplyr)
df = read.csv("google_playstore_external_2.csv")
head(df)
# change to original
df2 = df %>% mutate(across(where(is.character), str_trim))
#df2 = df2 %>% arrange(desc(Estimated.Installs)) %>% filter(Estimated.Installs > 2^20) %>% group_by(Category) %>% summarise(count = n())
head(df2)
df = df2 %>% filter(Maximum.Installs > 1000)
dim(df)
gg<-subset(df, Rating!="" & Installs!="")
dim(gg)
gg<-subset(gg, Currency=="USD")
dim(gg)
head(gg)
gg1<-gg[-c(5,6,7,11,12,13,15,17,18,19,20,24)]
head(gg1)
gg2 = gg1 %>% mutate(Installs.In.1K = Maximum.Installs/1000)
head(gg2)
gg2<-gg2[-c(5)]
head(gg2)

dim(gg2)
gg3<-gg2[-c(8)]
head(gg3)
colnames(gg3) = c("App Name", "App Id", "Category", "Rating", "Free", "Price", "Developer Id", "Ad Supported", "In-app Purchases", "Editors Choice", "Installs In 1K")
head(gg3)

library(data.table)
fwrite(gg3, file="play_store_cleaned_top1k.csv", row.names=FALSE)

#gg3%>%filter(Price>0)%>%group_by(Category)%>%summarise(avg=mean(Price))%>%arrange(desc(avg))



#------playstore-right-join-review----------
df_review = read.csv("review_clean1.csv")
review_cleaned = df_review %>% filter(Translated_Review != "")
review_cleaned %>% dim()
review_cleaned%>%filter(App.Name=="Hexonia")
colnames(review_cleaned)[2] = "App.Name"
combined = right_join(df1, review_cleaned, by = "App.Name")
combined %>% head(2)
combined %>% dim()
combined %>% write.csv("play_store_0503_right_join_review.csv")

combined %>% filter(Estimated.Installs %>% is.na()) %>% summarise(count = n())
combined %>% filter(Rating == 0) %>% summarise(count = n()) 
combined %>% filter(Rating == 0) %>% head(2)
