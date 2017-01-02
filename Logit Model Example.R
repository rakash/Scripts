
setwd("D:/Analytics/custfile_training/4. Logistic Regression")



# Read in the dataset
file = 'customers.csv'
custfile <- read.csv(file)


# Look at structure
str(custfile)

# Load the library caTools
library(caTools)

# Randomly split the data into custfile_training and custfile_testing sets
set.seed(1000)

split = sample.split(custfile$LikelytoQuit, SplitRatio = 0.70)
#### LikelytoQuit will be a variable in your dataset where your company provides that information that the customer has already quit (past data)


# Split up the data using subset
custfile_train = subset(custfile, split==TRUE)
custfile_test = subset(custfile, split==FALSE)

################### MODEL 1 -  Logistic Regression Model
model1 = glm(LoanApproval ~ var1+var2+var3+...., 
                  data = custfile_train, family='binomial')
summary(model1)
#### Take down AIC value (for comparisons of different model)

#### What is training data predictions?
Predict_train = predict(model1,type='response')

#### Compare the predictions to company provided value of $LikelytoQuit in two ways
#### Plot it... Two colours will appear... one is customers who quit and the other is didn't quit  
plot(Predict_train,col=custfile_train$LikelytoQuit,cex=.5)

#### or simply table it. This gives you the truth table
truth_table_train = table(custfile_train$LikelytoQuit,Predict_train>.5)
#### 0.5 is a threshold that you use. You can try with either .4,.5 or .6 and see which model is better for both training and testing

truth_table_train
Accuracy = sum(diag(truth_table_train))/sum(truth_table_train)
Accuracy

########### Let us test the model with test data
Predict_test = predict(model1,type='response',newdata=custfile_test)

#### Plot it... Two colours will appear... one is customers who quit and the other is didn't quit  
plot(Predict_test,col=custfile_test$LikelytoQuit,cex=.5)

#### or simply table it. This gives you the truth table
truth_table_test = table(custfile_test$LikelytoQuit,Predict_test>.5)
#### 0.5 is a threshold that you use. You can try with either .4,.5 or .6 and see which model is better for both training and testing

truth_table_test
Accuracy = sum(diag(truth_table_test))/sum(truth_table_test)
Accuracy

###################### MODEL - 1 ENDS HERE ########## 



################### MODEL 2 -  Logistic Regression Model - Change variables in GLM Model
model1 = glm(LoanApproval ~ var1+var2+var3+...., 
                  data = custfile_train, family='binomial')
summary(model1)
#### Take down AIC value (for comparisons of different model)

#### What is training data predictions?
Predict_train = predict(model1,type='response')

#### Compare the predictions to company provided value of $LikelytoQuit in two ways
#### Plot it... Two colours will appear... one is customers who quit and the other is didn't quit  
plot(Predict_train,col=custfile_train$LikelytoQuit,cex=.5)

#### or simply table it. This gives you the truth table
truth_table_train = table(custfile_train$LikelytoQuit,Predict_train>.5)
#### 0.5 is a threshold that you use. You can try with either .4,.5 or .6 and see which model is better for both training and testing

truth_table_train
Accuracy = sum(diag(truth_table_train))/sum(truth_table_train)
Accuracy

########### Let us test the model with test data
Predict_test = predict(model1,type='response',newdata=custfile_test)

#### Plot it... Two colours will appear... one is customers who quit and the other is didn't quit  
plot(Predict_test,col=custfile_test$LikelytoQuit,cex=.5)

#### or simply table it. This gives you the truth table
truth_table_test = table(custfile_test$LikelytoQuit,Predict_test>.5)
#### 0.5 is a threshold that you use. You can try with either .4,.5 or .6 and see which model is better for both training and testing

truth_table_test
Accuracy = sum(diag(truth_table_test))/sum(truth_table_test)
Accuracy

###################### MODEL - 2 ENDS HERE ########## 
