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
