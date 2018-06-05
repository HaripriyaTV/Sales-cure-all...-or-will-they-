## Bivariate Analysis

### Initial Insights from the Analysis

Here the independent variables with respect to the target variable are explored. The objective is to discover hidden relationships between
the independent variable and the target variable and use those findings in missing data imputation and feature engineering.

#### Target Variable Vs Independent Numeric Variables

![target vs continuous](https://user-images.githubusercontent.com/39884389/40958643-a44b92d2-68b7-11e8-9193-057ab8fdd4df.jpeg)

#### Observations

- Item_Outlet_Sales is spread well across the entire range of the Item_Weight without any obvious pattern.
- In Item_Visibility vs Item_Outlet_Sales, there is a string of points at Item_Visibility = 0.0 which seems strange as item visibility 
cannot be completely zero. This issue is dealt in the later stage.
- In the third plot of Item_MRP vs Item_Outlet_Sales, there are 4 segments of prices that can be used in feature engineering to create
a new variable.

#### Target Variable vs Independent Categorical Variables

The categorical variables with respect to Item_Outlet_Sales are visualized. The distribution of the target variable across all the 
categories of each of the categorical variable is checked.

The violin plots are used here, as they show the full distribution of the data. The width of a violin plot at a particular level indicates 
the concentration or density of data at that level. The height of a violin tells us about the range of the target variable values.

![target vs item type](https://user-images.githubusercontent.com/39884389/40959456-5d5f8de4-68ba-11e8-9557-3f9994b5a5f5.jpeg)
![item fat outlet identifier](https://user-images.githubusercontent.com/39884389/40959464-62829e92-68ba-11e8-83aa-52b02fc45264.jpeg)

#### Observations

- Distribution of Item_Outlet_Sales across the categories of Item_Type is not very distinct and same is the case with Item_Fat_Content.
- The distribution for OUT010 and OUT019 categories of Outlet_Identifier are quite similar and very much different from the rest of the 
categories of Outlet_Identifier.

#### Checking the distribution of Outlet_Size

In the univariate analysis, it was found that there are empty values in Outlet_Size variable. The distribution of the target
variable across Outlet_Size is checked here.

![target vs outlet size](https://user-images.githubusercontent.com/39884389/40959707-2070a57a-68bb-11e8-829f-b258fd8d2e97.jpeg)

#### Observation

The distribution of ‘Small’ Outlet_Size is almost identical to the distribution of the NA category of Outlet_Size. 
The NAs in Outlet_Size can be substituted with ‘Small’. But the NAs are later substituted with predicted categories based on Outlet_Identifier.

#### Visualizing Other Categorical Variables with Target Variable

![outlet type location type](https://user-images.githubusercontent.com/39884389/40960004-040221f6-68bc-11e8-8a01-8de4b5031436.jpeg)

#### Observations

- Tier 1 and Tier 3 locations of Outlet_Location_Type look similar.
- In the Outlet_Type plot, Grocery Store has most of its data points around the lower sales values as compared to the other categories.
