# Boosting, Bagging and Stacking

install.packages("mlbench")
install.packages("caretEnsemble")
# Load libraries
library(mlbench)
library(caret)
library(caretEnsemble)

# Load the dataset
data(Ionosphere)
dataset <- Ionosphere
dataset <- dataset[,-2]
dataset$V1 <- as.numeric(as.character(dataset$V1))

head(dataset)

# Boosting
# Example of Boosting Algorithms

control <- trainControl(method="repeatedcv", number=10, repeats=3)
seed <- 7
metric <- "Accuracy"
# C5.0
set.seed(seed)
fit.c50 <- train(Class~., data=dataset, method="C5.0", metric=metric, trControl=control)
# Stochastic Gradient Boosting
set.seed(seed)
fit.gbm <- train(Class~., data=dataset, method="gbm", metric=metric, trControl=control, verbose=FALSE)
# summarize results
boosting_results <- resamples(list(c5.0=fit.c50, gbm=fit.gbm))
summary(boosting_results)
dotplot(boosting_results)

# Bagging Algorithms

# Example of Bagging algorithms
control <- trainControl(method="repeatedcv", number=10, repeats=3)
seed <- 7
metric <- "Accuracy"
# Bagged CART
set.seed(seed)
fit.treebag <- train(Class~., data=dataset, method="treebag", metric=metric, trControl=control)
# Random Forest
set.seed(seed)
fit.rf <- train(Class~., data=dataset, method="rf", metric=metric, trControl=control)
# summarize results
bagging_results <- resamples(list(treebag=fit.treebag, rf=fit.rf))
summary(bagging_results)
dotplot(bagging_results)


# Stacking Algorithms

# Example of Stacking algorithms
# create submodels
control <- trainControl(method="repeatedcv", number=10, repeats=3, savePredictions=TRUE, classProbs=TRUE)
algorithmList <- c('lda', 'rpart', 'glm', 'knn', 'svmRadial')
set.seed(seed)
models <- caretList(Class~., data=dataset, trControl=control, methodList=algorithmList)
results <- resamples(models)
summary(results)
dotplot(results)


# When we combine the predictions of different models using stacking, it is desirable that the predictions made by the sub-models have low correlation. This would suggest that the models are skillful but in different ways, allowing a new classifier to figure out how to get the best from each model for an improved score.

# If the predictions for the sub-models were highly corrected (>0.75) then they would be making the same or very similar predictions most of the time reducing the benefit of combining the predictions.

# correlation between results
modelCor(results)
splom(results)


# stack using glm
stackControl <- trainControl(method="repeatedcv", number=10, repeats=3, savePredictions=TRUE, classProbs=TRUE)
set.seed(seed)
stack.glm <- caretStack(models, method="glm", metric="Accuracy", trControl=stackControl)
print(stack.glm)


# stack using random forest
set.seed(seed)
stack.rf <- caretStack(models, method="rf", metric="Accuracy", trControl=stackControl)
print(stack.rf)

 
# A rf ensemble of 2 base models: lda, rpart, glm, knn, svmRadial

# Ensemble results:
  # Random Forest 

# 1053 samples
# 5 predictor
# 2 classes: 'bad', 'good' 

# No pre-processing
# Resampling: Cross-Validated (10 fold, repeated 3 times) 
# Summary of sample sizes: 948, 947, 948, 947, 949, 948, ... 
# Resampling results across tuning parameters:
  
#   mtry  Accuracy   Kappa      Accuracy SD  Kappa SD  
# 2     0.9626439  0.9179410  0.01777927   0.03936882
# 3     0.9623205  0.9172689  0.01858314   0.04115226
# 5     0.9591459  0.9106736  0.01938769   0.04260672

# Accuracy was used to select the optimal model using  the largest value.
# The final value used for the model was mtry = 2.


# https://www.r-bloggers.com/an-intro-to-ensemble-learning-in-r/ 

# INTRO TO ENSEMBLING IN R

# REFER THIS -- http://www.vikparuchuri.com/blog/build-your-own-bagging-function-in-r/

set.seed(10)
y<-c(1:1000)
x1<-c(1:1000)*runif(1000,min=0,max=2)
x2<-(c(1:1000)*runif(1000,min=0,max=2))^2
x3<-log(c(1:1000)*runif(1000,min=0,max=2))

lm_fit<-lm(y~x1+x2+x3)
summary(lm_fit)



set.seed(10)
all_data<-data.frame(y,x1,x2,x3)
positions <- sample(nrow(all_data),size=floor((nrow(all_data)/4)*3))
training<- all_data[positions,]
testing<- all_data[-positions,]

lm_fit<-lm(y~x1+x2+x3,data=training)
predictions<-predict(lm_fit,newdata=testing)
error<-sqrt((sum((testing$y-predictions)^2))/nrow(testing))
error

#Dividing the data into training and testing sets and using a simple linear model to make predictions about the testing set yields a root mean squared error of 177.36.


library(foreach)
length_divisor<-6
iterations<-5000
predictions<-foreach(m=1:iterations,.combine=cbind) %do% {
  training_positions <- sample(nrow(training), size=floor((nrow(training)/length_divisor)))
  train_pos<-1:nrow(training) %in% training_positions
  lm_fit<-lm(y~x1+x2+x3,data=training[train_pos,])
  predict(lm_fit,newdata=testing)
}
predictions<-rowMeans(predictions)
error<-sqrt((sum((testing$y-predictions)^2))/nrow(testing))
error

library(randomForest)
rf_fit<-randomForest(y~x1+x2+x3,data=training,ntree=500)
predictions<-predict(rf_fit,newdata=testing)
error<-sqrt((sum((testing$y-predictions)^2))/nrow(testing))
error

# Note that a random forest already incorporates the idea of bagging into the basic algorithm, 
# so we will gain little to nothing by running a random forest through our bagging function.
# What we will do instead is this:
  
  
length_divisor<-6
iterations<-5000
predictions<-foreach(m=1:iterations,.combine=cbind) %do% {
  training_positions <- sample(nrow(training), size=floor((nrow(training)/length_divisor)))
  train_pos<-1:nrow(training) %in% training_positions
  lm_fit<-lm(y~x1+x2+x3,data=training[train_pos,])
  predict(lm_fit,newdata=testing)
}
lm_predictions<-rowMeans(predictions)

library(randomForest)
rf_fit<-randomForest(y~x1+x2+x3,data=training,ntree=500)
rf_predictions<-predict(rf_fit,newdata=testing)
predictions<-(lm_predictions+rf_predictions)/2
error<-sqrt((sum((testing$y-predictions)^2))/nrow(testing))
error


# Improving the Performance of Our Ensemble -- using a small ratio for linear model

predictions<-(lm_predictions+rf_predictions*9)/10
error<-sqrt((sum((testing$y-predictions)^2))/nrow(testing))
error

# Next, we replace the linear model with a support vector machine(svm) from the e1071 package, 
#which provides an R interface to libSVM. 
#A support vector machine is based on some complicated mathematics, 
#but is basically a stronger machine learning technique that can pick up nonlinear tendencies in the data,
#depending on what kind of kernel is used.

library(e1071)
svm_fit<-svm(y~x1+x2+x3,data=training)
svm_predictions<-predict(svm_fit,newdata=testing)
error<-sqrt((sum((testing$y-svm_predictions)^2))/nrow(testing))
error

# SVM Error rate is superior to RF -- less error that is

# Next we will try using the svm with our bagging function.

length_divisor<-6
iterations<-5000
predictions<-foreach(m=1:iterations,.combine=cbind) %do% {
  training_positions <- sample(nrow(training), size=floor((nrow(training)/length_divisor)))
  train_pos<-1:nrow(training) %in% training_positions
  svm_fit<-svm(y~x1+x2+x3,data=training[train_pos,])
  predict(svm_fit,newdata=testing)
}
svm2_predictions<-rowMeans(predictions)
error<-sqrt((sum((testing$y-svm2_predictions)^2))/nrow(testing))
error

# The error with 5000 iterations of an svm model is 141.14. 
# In this case, it appears that the svm performs better without bagging techniques. 
# It may be that there is too little data for it to be effective when used like this. 
# However, the time it takes an svm increases exponentially(I believe) with more observations, so sometimes various techniques, including reduction in the number of observations or features, will need to be performed to improve svm performance to tolerable levels. Going forward, we will use the results of the single svm for the rest of this article.


predictions<-(svm_predictions+rf_predictions)/2
error<-sqrt((sum((testing$y-predictions)^2))/nrow(testing))
error

# When we equally combine the svm predictions from the single model with the random forest predictions,
# we get an error rate of 128.8, which is superior to either the svm model alone, or the random forest model alone.


predictions<-(svm_predictions*2+rf_predictions)/3
error<-sqrt((sum((testing$y-predictions)^2))/nrow(testing))
error

# If we tweak the ratios to emphasize the stronger svm model, we lower our error to 128.34.