## Model Building

The train dataset was segmented into two separate datasets – a training dataset and a validation dataset using a 75:25 ratio.
The split between training and validation datasets was done randomly. The training set was used to fit the following predictive models.

- Linear Regression
- Lasso Regression
- Ridge Regression
- Random Forest
- XGBoost

These models were designed to predict the Item_Outlet_Sales. Having built the above models, the validation dataset was then used to 
estimate the prediction error associated with each model. The evaluation metric chosen was **Root Mean Square Value (RMSE)**.
The RMSE value forms the basis for selecting the preferred model. 

The RMSE obtained for each of the model is,

| Model | RMSE |
|-------| ------|
| Linear Regression | 1117.641 |
| Lasso Regression | 1117.448 |
| Ridge Regression | 1121.007 |
| Random Forest | 1081.801 |
| XGBoost | 2050.684 |

Thus Random Forest has outperformed other models.

Hence Random Forest is chosen for predicting the Item_Outlet_Sales upon test data set.



