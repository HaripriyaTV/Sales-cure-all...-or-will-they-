#checking for the dimensions
dim(BM_train)
dim(BM_test)

#features of data
names(BM_train)
names(BM_test)

#structure of the data
str(BM_train)
str(BM_test)

#combining training and test sets for exploration
BM_test[ , Item_Outlet_Sales := NA]
BM_combined <- rbind(BM_train, BM_test)
dim(BM_combined)

#the feature Item_Fat_Content contains similar factors named differently
#renaming the  similar categories of the feature Item_Fat_COntent into a common name
BM_combined$Item_Fat_Content [BM_combined$Item_Fat_Content == "LF"] = "Low Fat"
BM_combined$Item_Fat_Content [BM_combined$Item_Fat_Content == "low fat"] = "Low Fat"
BM_combined$Item_Fat_Content [BM_combined$Item_Fat_Content == "reg"] = "Regular"
