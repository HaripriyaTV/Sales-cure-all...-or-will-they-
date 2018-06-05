#EDA
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
