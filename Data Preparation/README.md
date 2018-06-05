## Data Preparation

***Missing Value Treatment - Feature Engineering - Encoding Categorical Variables - PreProcessing Data***

### Missing Value Treatment

Missing data can have a severe impact on building predictive models because the missing values might contain some vital 
information which could help in making better predictions. So, it becomes imperative to carry out missing data imputation.

#### Imputing Missing Value

We had missing values in Item_Weight and Outlet_Size.
The **Item_Weight missing values** are imputed with **mean weight** based on the Item_Identifier variable.
The **Outlet_Size missing values** are imputed with **mode size** based on the Outlet_Identifier variable.

#### Replacing 0’s in Item_Visibility variable

The zeroes in Item_Visibility variable are replaced with Item_Identifier wise mean values of Item_Visibility.

The histogram of Item_Visibility before and after replacing zero respectively, is given below.

![mv](https://user-images.githubusercontent.com/39884389/40961324-df58b492-68bf-11e8-9b9c-909a9c9252f1.jpeg)

Thus, the right histogram shows that the issue of zero item visibility is resolved.

### Feature Engineering

The following new features which might help improving the model performance are created based on existing features.

- ***Item_Type_new:*** The elements of **Item_Type** are classified into categories of **perishable** and **non_perishable** and made 
into a new feature.
- ***Item_category:*** **Item_Type** is compared with the **first 2 characters of Item_Identifier**, i.e., ‘DR’, ‘FD’, and ‘NC’.
These identifiers most probably stand for **drinks, food** and **non-consumable.** Based on these identifiers, the Item_Type
is categorized and created as a new feature.
- ***Outlet_Years:*** This variable tells about **years of operation for outlets** which is created by subtracting the Outlet_Establishment_Year
from 2013(the year of data collection).
- ***Price_Per_Unit_Wt:*** Item_MRP/Item_Weight
- ***Item_MRP_clusters:*** This is a **binned feature for Item_MRP**. Earlier in the Item_MRP vs Item_Outlet_Sales plot, it was found that
Item_MRP was spread across in 4 chunks. A label to each of these chunks is assigned and is used as a new variable.

### Encoding Categorical Variables

- Outlet_Size and Outlet_Location_Type are **label encoded** as they are ordinal variables.
- For the rest other categorical variables, each category is converted into a new binary column (1/0) by **one hot encoding**.

### PreProcessing Data

The data is dealt with the skewness and standardizing of the numerical variables.

#### Removing Skewness

The variables Item_Visibility and Price_Per_Unit_Ut are highly skewed. So, their skewness were treated with the help of log transformation.

#### Standardizing numeric predictors

The numeric variables are scaled and centeres to make them have a mean of zero, standard deviation of one and scale of 0 to 1. Scaling and centering
is required for linear regression models.

#### Checking for correlated variables

The correlated features of train dataset is examined. Correlation varies from -1 to 1.

**negative correlation:** < 0 and >= -1;
**positive correlation:** > 0 and <= 1;
**no correlation:** 0.

It is not desirable to have correlated features while using linear regressions.

The correlation plot above shows correlation between all the possible pairs of variables in the data. The correlation between any two variables is represented by a pie. 
A blueish pie indicates positive correlation and reddish pie indicates negative correlation. The magnitude of the correlation is denoted by the area covered by the pie.

![corrplot](https://user-images.githubusercontent.com/39884389/40963950-7d54659a-68c7-11e8-899f-aeb3b37160ac.jpeg)

Variables price_per_unit_wt and Item_Weight are highly correlated as the former one was created from the latter.
Similarly price_per_unit_wt and Item_MRP are highly correlated for the same reason.

