df = read.csv("play_store_0503_reduced.csv")
# change to original
df2 = df %>% mutate(across(where(is.character), str_trim))
#df2 = df2 %>% arrange(desc(Estimated.Installs)) %>% filter(Estimated.Installs > 2^20) %>% group_by(Category) %>% summarise(count = n())
df = df2 %>% filter(Estimated.Installs > 1000000)

df2 = df2 %>% select(-X)
df2 = df2 %>% mutate(Installs.In.1K = Estimated.Installs/1000)
df2 %>% head()
df2 %>% dim()
colnames(df2) = c("App Name", "App Id", "Category", "Rating", "Install Range", "Total Installs", "Price", "Developer Id", "Ad Supported", "In-app Purchases", "Editors Choice", "Installs In 1K") 
df2 %>% write.csv("play_store_1503_top_apps.csv")