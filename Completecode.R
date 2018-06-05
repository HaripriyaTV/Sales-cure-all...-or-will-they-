#loading required packages
library(data.table) #for loading in dataset
library(dplyr) #for data manipulation
library(ggplot2) #for data visualization
library(caret) #for modelling
library(xgboost) #for modelling xgboost
library(corrplot) #for plotting correlations
library(cowplot) #for combining plots

#loading data
BM_train <- fread("BMTrain.csv", na.strings = "")
BM_test <- fread("BMTest.csv", na.strings = "")

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

#renaming the categories of the feature Item_Fat_COntent
BM_combined$Item_Fat_Content [BM_combined$Item_Fat_Content == "LF"] = "Low Fat"
BM_combined$Item_Fat_Content [BM_combined$Item_Fat_Content == "low fat"] = "Low Fat"
BM_combined$Item_Fat_Content [BM_combined$Item_Fat_Content == "reg"] = "Regular"

#EDA
#Univariate Analysis
#visualizing the target variable
ggplot(BM_train) + geom_histogram(aes(BM_train$Item_Outlet_Sales),
                    bins = 50, fill = "orange") + xlab ("Item Outlet Sales")

#visualizing continuous independent variables
p1 <- ggplot(BM_combined) + geom_histogram(aes(BM_combined$Item_Weight),
                      binwidth = 0.5, fill = "orange") + xlab ("Item Weight")
p2 <- ggplot(BM_combined) + geom_histogram(aes(BM_combined$Item_Visibility), 
                        binwidth = 0.005, fill = "orange") + xlab ("Item Visibility")
p2
p3 <- ggplot(BM_combined) + geom_histogram(aes(BM_combined$Item_MRP), 
                      binwidth = 1, fill = "orange") + xlab ("Item MRP")
#combining the above three plots
plot_grid(p1, p2, p3, nrow = 1)

#visualizing the categorical variables
#plot for item fat content
p4 <- ggplot(BM_combined %>% group_by(Item_Fat_Content) %>% summarise(Count = n())) +
  geom_bar(aes(Item_Fat_Content, Count), stat = "identity", fill = "deepskyblue1") +
  xlab("") +
  geom_label(aes(Item_Fat_Content, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Item Fat Content")
p4


#plot for item type
p5 <- ggplot(BM_combined %>% group_by(Item_Type) %>% summarise(Count = n())) +
      geom_bar(aes(Item_Type, Count), stat = "identity", fill = "deepskyblue1") +
      xlab("") +
      geom_label(aes(Item_Type, Count, label = Count), vjust = 0.5) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      ggtitle("Item Type")
p5

#plot for outlet identifier
p6 <- ggplot(BM_combined %>% group_by(Outlet_Identifier) %>% summarise(Count = n())) +
  geom_bar(aes(Outlet_Identifier, Count), stat = "identity", fill = "deepskyblue1") +
  xlab("") +
  geom_label(aes(Outlet_Identifier, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Outlet Identifier")
p6

#plot for outlet size
p7 <- ggplot(BM_combined %>% group_by(Outlet_Size) %>% summarise(Count = n())) +
  geom_bar(aes(Outlet_Size, Count), stat = "identity", fill = "deepskyblue1") +
  xlab("") +
  geom_label(aes(Outlet_Size, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Outlet Size")
p7

#plot for outlet establishment year
p8 <- ggplot(BM_combined %>% group_by(Outlet_Establishment_Year) %>% summarise(Count = n())) +
  geom_bar(aes(factor(Outlet_Establishment_Year), Count), stat = "identity", fill = "deepskyblue1") +
  xlab("") +
  geom_label(aes(factor(Outlet_Establishment_Year), Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 45)) +
  ggtitle("Outlet Establishment Year")
p8


#plot for outlet location type
p9 <- ggplot(BM_combined %>% group_by(Outlet_Location_Type) %>% summarise(Count = n())) +
  geom_bar(aes(Outlet_Location_Type, Count), stat = "identity", fill = "deepskyblue1") +
  xlab("") +
  geom_label(aes(Outlet_Location_Type, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Outlet Location Type")
p9


#plot for outlet type
p10 <- ggplot(BM_combined %>% group_by(Outlet_Type) %>% summarise(Count = n())) +
  geom_bar(aes(Outlet_Type, Count), stat = "identity", fill = "deepskyblue1") +
  xlab("") +
  geom_label(aes(Outlet_Type, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Outlet Type")
p10

#combining the above plots
plot_grid(p4, p6, ncol = 2)
plot_grid(p7, p8, ncol = 2)
plot_grid(p9, p10, ncol = 2)


#bivariate analysis

# extracting train data from the combined data
BM_train = BM_combined[1:nrow(BM_train)]

#target variable Vs independent continuous variable

#Item Weight Vs Item Outlet Sale
b1 <- ggplot(BM_train)+
      geom_point(aes(Item_Weight, Item_Outlet_Sales), colour = "salmon2", alpha = 0.3) +
      theme(axis.title = element_text(size = 8.5))
b1 

#Item Visibility Vs Item Outlet Sale
b2 <- ggplot(BM_train)+
  geom_point(aes(Item_Visibility, Item_Outlet_Sales), colour = "salmon2", alpha = 0.3) +
  theme(axis.title = element_text(size = 8.5))
b2 

#Item MRP Vs Item Outlet Sale
b3 <- ggplot(BM_train)+
  geom_point(aes(Item_MRP, Item_Outlet_Sales), colour = "salmon2", alpha = 0.3) +
  theme(axis.title = element_text(size = 8.5))
b3 

#combining above plots
second_row_2 = plot_grid(b2, b3, ncol = 2)
plot_grid(b1, second_row_2, nrow = 2)

#Target variable Vs Independent Categorical Variable
# Item_Type vs Item_Outlet_Sales
b4 = ggplot(BM_train) + 
  geom_violin(aes(Item_Type, Item_Outlet_Sales), fill = "tan3") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.text = element_text(size = 8.5),
        axis.title = element_text(size = 8.5))
b4

# Item_Fat_Content vs Item_Outlet_Sales
b5 = ggplot(BM_train) + 
  geom_violin(aes(Item_Fat_Content, Item_Outlet_Sales), fill = "tan3") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.text = element_text(size = 8.5),
        axis.title = element_text(size = 8.5))
b5

# Outlet_Identifier vs Item_Outlet_Sales
b6 = ggplot(BM_train) + 
  geom_violin(aes(Outlet_Identifier, Item_Outlet_Sales), fill = "tan3") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.text = element_text(size = 8),
        axis.title = element_text(size = 8.5))
b6

#combining the above two plots
plot_grid(b5, b6, ncol = 2)

#checking the distribution of outlet size
ggplot(BM_train) + geom_violin(aes(Outlet_Size, Item_Outlet_Sales), fill = "tan3")

# Target variable Vs remaining categorical variables
b7 = ggplot(BM_train) + geom_violin(aes(Outlet_Location_Type, Item_Outlet_Sales), fill = "tan3")
b8 = ggplot(BM_train) + geom_violin(aes(Outlet_Type, Item_Outlet_Sales), fill = "tan3") + theme(axis.text.x = element_text(angle = 45, hjust = 1))
plot_grid(b7, b8, ncol = 1)

#missing value treatment
#checking for missing values
ncol(BM_combined)

BM_data <- BM_combined[,-12]
dim(BM_data)

sapply(BM_data, FUN = function(x) sum(is.na(x)))

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
sapply(BM_combined, FUN = function(x) sum(is.na(x)))
View(BM_combined)

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
nrow(BM_train)

BM_test <- BM_combined[(nrow(BM_train) + 1) : nrow(BM_combined) ]

#removing the target variable from test set 
BM_test <- BM_test[, Item_Outlet_Sales := NULL]
dim(BM_test)

#checking for correlated features in train dataset
BM_train_corr <- cor(BM_train[,-c("Item_Identifier")])
corrplot(BM_train_corr, method = "pie", type = "lower", tl.cex = 0.9)

#splitting train data into train and validation set
train_data_split <- sample(2, nrow(BM_train), replace =TRUE, prob = c(0.75, 0.25))
new_BM_train <- BM_train[train_data_split == 1,]
BM_valid <- BM_train[train_data_split == 2,]

#modelling
#building linear model
lin_reg <- lm(Item_Outlet_Sales ~ ., data = new_BM_train[, -c("Item_Identifier")])
#making prediction on test data
lin_reg_pred <- predict(lin_reg, BM_valid[, -c("Item_Identifier")])
lin_reg_pred

#evaluating the model using rmse
rmse_lin_reg <- RMSE(lin_reg_pred, BM_valid$Item_Outlet_Sales, na.rm = FALSE)
rmse_lin_reg

#performing lasso regression
set.seed(1235)
my_control <- trainControl(method = "CV", number = 5)
Grid = expand.grid(alpha = 1, lambda = seq(0.001,0.1,by = 0.0002))

lasso_reg <- train(x = new_BM_train[, -c("Item_Identifier", "Item_Outlet_Sales")], y = new_BM_train$Item_Outlet_Sales,
                             method='glmnet', trControl= my_control, tuneGrid = Grid)
pred_lasso <- predict(lasso_reg, BM_valid[, -c("Item_Identifier")])

#evaluating lasso regression
rmse_lasso <- RMSE(pred_lasso, BM_valid$Item_Outlet_Sales, na.rm = FALSE)
rmse_lasso

#performing ridge regression
set.seed(1235)
my_control <- trainControl(method = "CV", number = 5)
Grid = expand.grid(alpha = 0, lambda = seq(0.001,0.1,by = 0.0002))

ridge_reg <- train(x = new_BM_train[, -c("Item_Identifier", "Item_Outlet_Sales")], y = new_BM_train$Item_Outlet_Sales,
                   method='glmnet', trControl= my_control, tuneGrid = Grid)
pred_ridge <- predict(ridge_reg, BM_valid[, -c("Item_Identifier")])

#evaluating ridge regression
rmse_ridge <- RMSE(pred_ridge, BM_valid$Item_Outlet_Sales, na.rm = FALSE)
rmse_ridge

#building random forest
set.seed(1237)
my_control = trainControl(method="cv", number=5) # 5-fold CV
tgrid = expand.grid(
  .mtry = sqrt(ncol(new_BM_train)),
  .splitrule = "variance",
  .min.node.size = c(10,15,20)
)
rf_mod = train(x = new_BM_train[, -c("Item_Identifier", "Item_Outlet_Sales")], 
               y = new_BM_train$Item_Outlet_Sales,
               method='ranger', 
               trControl= my_control, 
               tuneGrid = tgrid,
               num.trees = 400,
               importance = "permutation")

pred_rf <- predict(rf_mod, BM_valid[, -c("Item_Identifier")])
pred_rf

#evaluating the random forest model
rmse_rf <- RMSE(pred_rf, BM_valid$Item_Outlet_Sales, na.rm = FALSE)
rmse_rf

#variable imporatance
plot(varImp(rf_mod))

#modelling xgboost
param_list = list(
  
  objective = "reg:linear",
  eta=0.01,
  gamma = 1,
  max_depth=6,
  subsample=0.8,
  colsample_bytree=0.5
)
dtrain = xgb.DMatrix(data = as.matrix(new_BM_train[,-c("Item_Identifier", "Item_Outlet_Sales")]), label= new_BM_train$Item_Outlet_Sales)
dtest = xgb.DMatrix(data = as.matrix(BM_valid[,-c("Item_Identifier")]))

#xgboost crossvalidation
set.seed(112)
xgbcv = xgb.cv(params = param_list, 
               data = dtrain, 
               nrounds = 1000, 
               nfold = 5, 
               print_every_n = 10, 
               early_stopping_rounds = 30, 
               maximize = F)
#model training
xgb_model = xgb.train(data = dtrain, params = param_list, nrounds = 430)
pred_xgb_model <- predict(xgb_model, dtest)

#evaluating the model
rmse_xgb <- RMSE(pred_xgb_model, BM_valid$Item_Outlet_Sales, na.rm = FALSE)
rmse_xgb

#model selection and prediction on the test data
test_pred <- predict(rf_mod, newdata = BM_test)
test_pred

#creating the submisssion file to analytics vidhya
BM_submission <- fread("BMSample Submission.csv")
BM_submission$Item_Outlet_Sales <- test_pred
write.csv(BM_submission, "BM_Result.csv", row.names = FALSE)

#insights from the prediction of sales

#finding the most important variables that affect the Item_Outlet_Sales
plot(varImp(rf_mod))

#calculating the percentage change in sales from the train set to test set
S1 <- median(BM_train$Item_Outlet_Sales)
S2 <- median(BM_submission$Item_Outlet_Sales)
percentage_change_in_sales <- (S1 - S2)/S2
percentage_change_in_sales
# -0.1428967

