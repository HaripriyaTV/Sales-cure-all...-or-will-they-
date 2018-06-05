#final insights from the prediction of sales

#finding the most important variables that affect the Item_Outlet_Sales
plot(varImp(rf_mod))

#calculating the percentage change in sales from the train set to test set
S1 <- median(BM_train$Item_Outlet_Sales)
S2 <- median(BM_submission$Item_Outlet_Sales)
percentage_change_in_sales <- (S1 - S2)/S2
percentage_change_in_sales
# -0.1428967