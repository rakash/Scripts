# DATASET - https://docs.google.com/spreadsheets/d/1PR5StHxg2jlMCb4IUilGSEwhylXn-3q3EJucSaVolCU/edit#gid=0

setwd ("C:/Users/akar/Desktop/Personal/hackathons")

getwd()

data <- read.csv("Big mart data.csv")

str(data)

#1. Scatter Plot

#When to use: Scatter Plot is used to see the relationship between two continuous variables.

library(ggplot2)       #   // ggplot2 is an R library for visualizations train.
ggplot(data, aes(Item_Visibility, Item_MRP)) + geom_point() + scale_x_continuous("Item Visibility", breaks = seq(0,0.35,0.05))+ scale_y_continuous("Item MRP", breaks = seq(0,270,by = 30))+ theme_bw() 

# Adding a 3rd variable

ggplot(data, aes(Item_Visibility, Item_MRP)) + geom_point(aes(color = Item_Type)) + 
  scale_x_continuous("Item Visibility", breaks = seq(0,0.35,0.05))+
  scale_y_continuous("Item MRP", breaks = seq(0,270,by = 30))+
  theme_bw() + labs(title="Scatterplot")

# separate category wise chart for Item type:

ggplot(data, aes(Item_Visibility, Item_MRP)) + geom_point(aes(color = Item_Type)) + 
  scale_x_continuous("Item Visibility", breaks = seq(0,0.35,0.05))+
  scale_y_continuous("Item MRP", breaks = seq(0,270,by = 30))+ 
  theme_bw() + labs(title="Scatterplot") + facet_wrap( ~ Item_Type)


#2. Histogram

#When to use: Histogram is used to plot continuous variable. It breaks the data into bins and shows frequency distribution of these bins. We can always change the bin size and see the effect it has on visualization.

ggplot(data, aes(Item_MRP)) + geom_histogram(binwidth = 2)+
  scale_x_continuous("Item MRP", breaks = seq(0,270,by = 30))+
  scale_y_continuous("Count", breaks = seq(0,200,by = 20))+
  labs(title = "Histogram")


#3. Bar & Stack Bar Chart

#When to use: Bar charts are recommended when you want to plot a categorical variable or a combination of continuous and categorical variable.

ggplot(data, aes(Outlet_Establishment_Year)) + geom_bar(fill = "red")+theme_bw()+
  scale_x_continuous("Establishment Year", breaks = seq(1985,2010)) + 
  scale_y_continuous("Count", breaks = seq(0,1500,150)) +
  coord_flip()+ labs(title = "Bar Chart") + theme_gray()

#  remove coord_flip() parameter to get the above bar chart vertically

#To know item weights (continuous variable) on basis of Outlet Type (categorical variable) on single bar chart, use following code:
ggplot(data, aes(Item_Type, Item_Weight)) + geom_bar(stat = "identity", fill = "darkblue") 
+ scale_x_discrete("Outlet Type")
+ scale_y_continuous("Item Weight", breaks = seq(0,15000, by = 500))
+ theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) + labs(title = "Bar Chart")

# Stacked bar chart 

# Stacked bar chart is an advanced version of bar chart, used for visualizing a combination of categorical variables.

# From our dataset, if we want to know the count of outlets on basis of categorical variables like its type (Outlet Type) and location (Outlet Location Type) both, stack chart will visualize the scenario in most useful manner.

ggplot(data, aes(Outlet_Location_Type, fill = Outlet_Type)) + geom_bar()+
  labs(title = "Stacked Bar Chart", x = "Outlet Location Type", y = "Count of Outlets")

#4. Box Plot

# When to use: Box Plots are used to plot a combination of categorical and continuous variables. This plot is useful for visualizing the spread of the data and detect outliers. It shows five statistically significant numbers- the minimum, the 25th percentile, the median, the 75th percentile and the maximum.

# From our dataset, if we want to identify each outlet's detailed item sales including minimum, maximum & median numbers, box plot can be helpful. In addition, it also gives values of outliers of item sales for each outlet as shown in below chart.

ggplot(data, aes(Outlet_Identifier, Item_Outlet_Sales)) + geom_boxplot(fill = "red")+
  scale_y_continuous("Item Outlet Sales", breaks= seq(0,15000, by=500))+
  labs(title = "Box Plot", x = "Outlet Identifier")

#5. Area Chart

#When to use: Area chart is used to show continuity across a variable or data set. 
# It is very much same as line chart and is commonly used for time series plots. 
#Alternatively, it is also used to plot continuous variables and analyze the underlying trends.

ggplot(data, aes(Item_Outlet_Sales)) + geom_area(stat = "bin", bins = 30, fill = "steelblue")
+ scale_x_continuous(breaks = seq(0,11000,1000))+ labs(title = "Area Chart", x = "Item Outlet Sales", y = "Count") 



#6. Heat Map

#When to use: Heat Map uses intensity (density) of colors to display relationship between two or three or many variables in a two dimensional image. It allows you to explore two dimensions as the axis and the third dimension by intensity of color.

#From our dataset, if we want to know cost of each item on every outlet, we can plot heatmap as shown below using three variables Item MRP, Outlet Identifier & Item Type from our mart dataset.

# The dark portion indicates Item MRP is close 50. The brighter portion indicates Item MRP is close to 250.

ggplot(data, aes(Outlet_Identifier, Item_Type))+
  geom_raster(aes(fill = Item_MRP))+
  labs(title ="Heat Map", x = "Outlet Identifier", y = "Item Type")+
  scale_fill_continuous(name = "Item MRP")


#7. Correlogram
#When to use: Correlogram is used to test the level of co-relation among the variable available in the data set. The cells of the matrix can be shaded or colored to show the co-relation value.

#Darker the color, higher the co-relation between variables. Positive co-relations are displayed in blue and negative correlations in red color. Color intensity is proportional to the co-relation value.

#From our dataset, let's check co-relation between Item cost, weight, visibility along with Outlet establishment year and Outlet sales from below plot.

#In our example, we can see that Item cost & Outlet sales are positively correlated while Item weight & its visibility are negatively correlated.


install.packages("corrgram")
library(corrgram)

corrgram(data, order=NULL, panel=panel.shade, text.panel=panel.txt,
         main="Correlogram")

