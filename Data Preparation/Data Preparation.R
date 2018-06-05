#data preparation

#missing value treatment

#checking for missing values

BM_data <- BM_combined[,-12]
dim(BM_data)
sapply(BM_data, FUN = function(x) sum(is.na(x)))
## Item_weight and Outlet_Size have missing values

#imputing the missing values in Item Weight based on Item Identifier
missing_index = which(is.na(BM_combined$Item_Weight))
for(i in missing_index){
  
  item = BM_combined$Item_Identifier[i]
  BM_combined$Item_Weight[i] = mean(BM_combined$Item_Weight[BM_combined$Item_Identifier == item], na.rm = T)
}

sum(is.na(BM_combined$Item_Weight))

#Replacing 0's in Item_Visibility variable
m1 <- ggplot(BM_combined) + geom_histogram(aes(Item_Visibility), bins = 100) +
  ggtitle("Before replacing 0's")

zero_index = which(BM_combined$Item_Visibility == 0)
for(i in zero_index){
  
  item = BM_combined$Item_Identifier[i]
  BM_combined$Item_Visibility[i] = mean(BM_combined$Item_Visibility[BM_combined$Item_Identifier == item], na.rm = T)
  
}
m2 <- ggplot(BM_combined) + geom_histogram(aes(Item_Visibility), bins = 100) +
  ggtitle("After replacing 0's")

#combining m1 and m2
plot_grid(m1, m2, nrow = 1)

#imputing the missing values in Outlet_Size based on Outlet_Identifier
na_index = which(is.na(BM_combined$Outlet_Size))
for(i in na_index){
  
  outlet = BM_combined$Outlet_Identifier[i]
  BM_combined$Outlet_Size[i] = mode(BM_combined$Outlet_Size[BM_combined$Outlet_Identifier == outlet])
  
}
sum(is.na(BM_combined$Outlet_Size))

#############################################################################################################################

#Feature Engineering

#classifying the Item Type feature into perishable and non-perishable categoreis
perishable = c("Breads", "Breakfast", "Dairy", "Fruits and Vegetables", "Meat", "Seafood")
non_perishable = c("Baking Goods", "Canned", "Frozen Foods", "Hard Drinks", "Health and Hygiene", "Household", "Soft Drinks")

#creating a new feature 'Item_Type_New'
BM_combined[,Item_Type_New := ifelse(Item_Type %in% perishable, "perishable",
                                     ifelse(Item_Type %in% non_perishable, "non perishable",
                                            "uncategorised"))]

#comparing Item_Type with the first two characters of Item_Identifiers
table(BM_combined$Item_Type, substr(BM_combined$Item_Identifier, 1, 2))

#creating new variable Item_Category based on above table
BM_combined[, Item_Category := substr(BM_combined$Item_Identifier, 1, 2)]
head(BM_combined$Item_Category)

#changing the attribute of non-consumable items in Item_Fat_Content based on Item_Category
BM_combined$Item_Fat_Content[BM_combined$Item_Category == "NC"] <- "non edible"

#creating a new feature about years of operation of outlet
BM_combined[, Outlet_Years := 2013 - Outlet_Establishment_Year]
BM_combined$Outlet_Establishment_Year <- as.factor(BM_combined$Outlet_Establishment_Year)

#creating a feature based on price per unit weight
BM_combined[, Price_Per_Unit_Wt := Item_MRP/Item_Weight]

#clustering MRP into fours bins (based on Item_MRP Vs Item_Outelet_Sales plot)
BM_combined[,Item_MRP_clusters := ifelse(Item_MRP < 69, "1st", 
                                         ifelse(Item_MRP >= 69 & Item_MRP < 136, "2nd",
                                                ifelse(Item_MRP >= 136 & Item_MRP < 203, "3rd", "4th")))]

###########################################################################################################################

#encoding categorical variables

#label encoding Outlet_Size and Outlet_Location_Type
BM_combined[, Outlet_Size_Encoded := ifelse(Outlet_Size == "Small", 0,
                                            ifelse(Outlet_Size == "Medium", 1,
                                                   2))]

View(BM_combined$Outlet_Size_Encoded)
BM_combined[,Outlet_Location_Type_Encoded := ifelse(Outlet_Location_Type == "Tier 3", 0,
                                                    ifelse(Outlet_Location_Type == "Tier 2", 1, 2))]

#removing the categorical variables that are encoded
BM_combined[, c("Outlet_Size", "Outlet_Location_Type") := NULL]

#one hot encoding of remaining categorical variables
ohe = dummyVars("~.", data = BM_combined[,-c("Item_Identifier", "Outlet_Establishment_Year", "Item_Type")], fullRank = T)
ohe_df = data.table(predict(ohe, BM_combined[,-c("Item_Identifier", "Outlet_Establishment_Year", "Item_Type")]))
BM_combined = cbind(BM_combined[,"Item_Identifier"], ohe_df)

################################################################################################################################

#PreProcessing data

#removing skewness
#applying log transformation on Item_Visibility and Price_Per_Unit_Wt
BM_combined[, Item_Visibility := log(Item_Visibility + 1)] #log + 1 to avoid division by zero
BM_combined[, Price_Per_Unit_Wt := log(Price_Per_Unit_Wt + 1)]

#scaling and centering numeric features
num_vars = which(sapply(BM_combined, is.numeric)) # index of numeric features
num_vars_names = names(num_vars)
BM_combined_numeric = BM_combined[,setdiff(num_vars_names, "Item_Outlet_Sales"), with = F]
prep_num = preProcess(BM_combined_numeric, method=c("center", "scale"))
BM_combined_numeric_norm = predict(prep_num, BM_combined_numeric)
BM_combined[,setdiff(num_vars_names, "Item_Outlet_Sales") := NULL] # removing numeric independent variables
BM_combined = cbind(BM_combined, BM_combined_numeric_norm)

#splitting the combined data to train and test sets
BM_train <- BM_combined[1 : nrow(BM_train)]
BM_test <- BM_combined[nrow(BM_train) + 1 : nrow(BM_combined)]
#removing the target variable from test set 
BM_test[, Item_Outlet_Sales := NULL]
View(BM_test)

###################################################################################################################################

#checking for correlated features in train dataset
BM_train_corr <- cor(BM_train[,-c("Item_Identifier")])
corrplot(BM_train_corr, method = "pie", type = "lower", tl.cex = 0.9)