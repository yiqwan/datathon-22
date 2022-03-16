library(data.table)
library(dplyr)
library(ggplot2)
df1 = read.csv("ggplaydata5.csv")
head(df1)
df2<-df1[-c(1,5,6,9,10,12,13,14)]
head(df2)
appCount<-df2%>%group_by(Developer.Id)%>%summarise(App.count=n())
df2%>%filter(Editors.Choice=="True")%>%group_by(Developer.Id)%>%summarise(Editors.Choice.count=n())%>%arrange(desc(Editors.Choice.count))
hey=read.csv("google_playstore_external_2.csv")
hey%>%filter(Developer.Id=="Google LLC" & Editors.Choice=="True")
eccount<-df2%>%filter(Editors.Choice=="True")%>%group_by(Developer.Id)%>%summarise(Editors.Choice.count=n())
head(eccount)
com1<-left_join(appCount, eccount, by="Developer.Id")
head(com1)
com1[is.na(com1)] <- 0
head(com1)
head(df)
df<-df[-c(2,3)]
head(df)
com2<-left_join(df2, com1, by="Developer.Id")
head(com2)
com3<-com2[-c(5,7)]
head(com3)
com3<-com3%>%mutate(install.in.1k=Estimated.Installs/1000)
head(com3)
com4<-com3[-(4)]
head(com4)
com5<-left_join(df11,com1,by="Developer.Id")
head(com5)
com5<-com5%>%mutate(install.in.1k=Maximum.Installs/1000)
head(com5)
com5<-com5[-c(3)]
fwrite(com5, file="Developers_with_Emails_Count1.csv", row.names=FALSE)