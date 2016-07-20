# This script trains a Random Forest model based on the data,
# saves a sample submission, and plots the relative importance
# of the variables in making predictions

# Download 1_random_forest_r_submission.csv from the output below
# and submit it through https://www.kaggle.com/c/titanic-gettingStarted/submissions/attach
# to enter this getting started competition!

library(ggplot2)
library(randomForest)
library(h2o)
localH2O = h2o.init()


setwd("~/Desktop/Titanic")

set.seed(1)
train <- read.csv("input/train.csv", stringsAsFactors=FALSE)
test  <- read.csv("input/test.csv",  stringsAsFactors=FALSE)

#Clean data and transform to proper format. Add NA where there is a blank.

extractFeatures <- function(data) {
  features <- c("Pclass",
                "Age",
                "Sex",
                "Parch",
                "SibSp",
                "Fare",
                "Embarked")
  fea <- data[,features]
  fea$Age[is.na(fea$Age)] <- -1
  fea$Fare[is.na(fea$Fare)] <- median(fea$Fare, na.rm=TRUE)
  fea$Embarked[fea$Embarked==""] = "S"
  fea$Sex      <- as.factor(fea$Sex)
  fea$Embarked <- as.factor(fea$Embarked)
  return(fea)
}

#rf <- randomForest(extractFeatures(train), as.factor(train$Survived), ntree=1000, importance=TRUE)
#rf
#H2O##
dataframe <- extractFeatures(train)
dataframe$Survived <- as.factor(train$Survived)
h2o_tf <- as.h2o(dataframe)
rf <- h2o.randomForest(training_frame=h2o_tf, x=names(extractFeatures(train)), y="Survived",
                       ntrees = 1000, mtries = 7)

submission <- data.frame(PassengerId = test$PassengerId) 
pred_df <- extractFeatures(test) %>% as.h2o()
data <- h2o.predict(rf, pred_df)
submission$Survived <- as.data.frame(data)[,1]
write.csv(submission, file = "1_random_forest_r_submission.csv", row.names=FALSE)

######

submission <- data.frame(PassengerId = test$PassengerId)
submission$Survived <- predict(rf, extractFeatures(test))
write.csv(submission, file = "1_random_forest_r_submission.csv", row.names=FALSE)

imp <- importance(rf, type=1)
featureImportance <- data.frame(Feature=row.names(imp), Importance=imp[,1])

p <- ggplot(featureImportance, aes(x=reorder(Feature, Importance), y=Importance)) +
  geom_bar(stat="identity", fill="#53cfff") +
  coord_flip() + 
  theme_light(base_size=20) +
  xlab("") +
  ylab("Importance") + 
  ggtitle("Random Forest Feature Importance\n") +
  theme(plot.title=element_text(size=18))

ggsave("2_feature_importance.png", p)
h2o.shutdown(localH2O)
Y