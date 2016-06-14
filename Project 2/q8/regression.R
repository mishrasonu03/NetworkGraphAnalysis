not.installed <- function(pkg) !is.element(pkg, installed.packages()[,1])

if (not.installed("AppliedPredictiveModeling")) { 
    install.packages("AppliedPredictiveModeling", repos="http://cran.us.r-project.org")  
    library(AppliedPredictiveModeling)
    for (chapter in c(2,3,4,6,7,8,10, 11,12,13,14,16,17,19))  getPackages(chapter, repos="http://cran.us.r-project.org")
}

library(AppliedPredictiveModeling)
library(caret)
library(kernlab)
library(e1071)
library(ggplot2)
library(mice)
library(RANN)
library(missForest)

cat("Reading training data part 1...\n")
train_set_1 = read.table("regre_data.csv", sep = ",", header=TRUE)
train_y = train_set_1[, c(1, ncol(train_set_1))]
train_set_2 = train_set_1[, -ncol(train_set_1)]

preProc = preProcess(train_set_2[, -1])
train_set_3 = predict(preProc, train_set_2)
train_set_4 <- merge(train_set_3, train_y)
head(train_set_4)

cat("Reading test data part 2...\n")
train_set_5 = read.table("regre_d.csv", sep = ",", header=TRUE) 
head(train_set_5)

cat("Finalizing train data...\n")
train_set <- merge(train_set_5, train_set_4)
trainData = train_set[, -1]

cat("Reading test data...\n")
test_set_1 = read.table("q8.csv", sep = ",", header=TRUE) 
test_set_2 = predict(preProc, test_set_1)
extra <- setdiff(names(train_set_5), names(test_set_2))
test_set_2[, extra] <- 0
head(test_set)

lrFit <- train(r~., data=trainData, method = "lm", preProc=c("center", "scale"),
                trControl=trainControl(method="repeatedcv", repeats=1), verbose = FALSE)
lrFit
lrPred <- predict(lrFit, test_set_2)

pcaFit <- train(r~., data=trainData, method = "lm", preProc=c("pca"),
                trControl=trainControl(method="repeatedcv", repeats=1), verbose = FALSE)
pcaFit
pcaPred <- predict(pcaFit, test_set_2)

cubistFit <- train(r~., data=trainData, method = "cubist", preProc=c("center", "scale"),
                trControl=trainControl(method="repeatedcv", repeats=1), verbose = FALSE)
cubistFit
cubistPred <- predict(cubistFit, test_set_2)

rbfSvmFit <- train(r~., data=trainData, method = "svmRadial", preProc=c("center", "scale"),
             tunelength = 8, trControl=trainControl(method="repeatedcv", repeats=1), verbose = FALSE)
rbfSvmFit
rbfPred <- predict(rbfFit, test_set_2)

rfFit <- train(r~., data=trainData[, 94:100], method = "rf", preProc=c("center", "scale"),
             trControl=trainControl(method="repeatedcv", repeats=1), verbose = FALSE)
rfFit
rfPred <- predict(rfFit, test_set_2)

gbmFit <- train(r~., data=train_set_1, method = "gbm", preProc=c("center", "scale"),
                 trControl=trainControl(method="repeatedcv", repeats=1), verbose = FALSE)
gbmFit
gbmPred <- predict(gbmFit, test_set_1)

polSvmFit <- train(r~., data=trainData, method = "svmPoly", preProc=c("center", "scale"),
                 trControl=trainControl(method="repeatedcv", repeats=1), verbose = FALSE) 
polSvmFit
polPred <- predict(polFit, test_set_2)