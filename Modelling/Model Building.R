#model building

#splitting train data into train and validation set
train_data_split <- sample(2, nrow(BM_train), replace =TRUE, prob = c(0.75, 0.25))
new_BM_train <- BM_train[train_data_split == 1,]
BM_valid <- BM_train[train_data_split == 2,]

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

#evaluating the random forest model
rmse_rf <- RMSE(pred_rf, BM_valid$Item_Outlet_Sales, na.rm = FALSE)
rmse_rf

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
#random forest outperformed the other models
test_pred <- predict(rf_mod, newdata = BM_test)
test_pred

#creating the submisssion file to analytics vidhya
BM_submission <- fread("BMSample Submission.csv")
BM_submission$Item_Outlet_Sales <- test_pred
write.csv(BM_submission, "BM_Result.csv", row.names = FALSE)