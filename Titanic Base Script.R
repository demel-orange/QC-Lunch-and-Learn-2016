
# This script trains a Random Forest model based on the data,
# saves a sample submission, and plots the relative importance
# of the variables in making predictions

# Download 1_random_forest_r_submission.csv from the output below
# and submit it through https://www.kaggle.com/c/titanic-gettingStarted/submissions/attach
# to enter this getting started competition!

library(ggplot2)
library(randomForest)

# setting a base working directory

setwd("~/hd_r_series/dm_slides/Titanic")


set.seed(1)
train <- read.csv("input/train.csv", stringsAsFactors=FALSE)
test  <- read.csv("input/test.csv",  stringsAsFactors=FALSE)

# Function to create feature set

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
  fea$Sex      <- as.factor(fea$Sex) # sex category as a factor 
  fea$Embarked <- as.factor(fea$Embarked) # sex category as a factor 
  return(fea)
}

rf <- randomForest(extractFeatures(train), as.factor(train$Survived), ntree=100, importance=TRUE)

# Now let's look at rf a little more closely


# attributes(rf)

# $names
# [1] "call"            "type"            "predicted"       "err.rate"        "confusion"
# [6] "votes"           "oob.times"       "classes"         "importance"      "importanceSD"
# [11] "localImportance" "proximity"       "ntree"           "mtry"            "forest"
# [16] "y"               "test"            "inbag"
# 
# $class
# [1] "randomForest"


# str(rf)

# List of 18
# $ call           : language randomForest(x = extractFeatures(train), y = as.factor(train$Survived), ntree = 100, importance = TRUE)
# $ type           : chr "classification"
# $ predicted      : Factor w/ 2 levels "0","1": 1 2 2 2 1 1 1 1 2 2 ...
# ..- attr(*, "names")= chr [1:891] "1" "2" "3" "4" ...
# $ err.rate       : num [1:100, 1:3] 0.209 0.215 0.224 0.229 0.224 ...
# ..- attr(*, "dimnames")=List of 2
# .. ..$ : NULL
# .. ..$ : chr [1:3] "OOB" "0" "1"
# $ confusion      : num [1:2, 1:3] 496 105 53 237 0.0965 ...
# ..- attr(*, "dimnames")=List of 2
# .. ..$ : chr [1:2] "0" "1"
# .. ..$ : chr [1:3] "0" "1" "class.error"
# $ votes          : matrix [1:891, 1:2] 0.8919 0 0.4884 0.0294 1 ...
# ..- attr(*, "dimnames")=List of 2
# .. ..$ : chr [1:891] "1" "2" "3" "4" ...
# .. ..$ : chr [1:2] "0" "1"
# ..- attr(*, "class")= chr [1:2] "matrix" "votes"
# $ oob.times      : num [1:891] 37 31 43 34 37 40 39 33 29 44 ...
# $ classes        : chr [1:2] "0" "1"
# $ importance     : num [1:7, 1:4] 0.0302 0.0152 0.1166 0.0349 0.0236 ...
# ..- attr(*, "dimnames")=List of 2
# .. ..$ : chr [1:7] "Pclass" "Age" "Sex" "Parch" ...
# .. ..$ : chr [1:4] "0" "1" "MeanDecreaseAccuracy" "MeanDecreaseGini"
# $ importanceSD   : num [1:7, 1:3] 0.00319 0.00252 0.00546 0.00403 0.00277 ...
# ..- attr(*, "dimnames")=List of 2
# .. ..$ : chr [1:7] "Pclass" "Age" "Sex" "Parch" ...
# .. ..$ : chr [1:3] "0" "1" "MeanDecreaseAccuracy"
# $ localImportance: NULL
# $ proximity      : NULL
# $ ntree          : num 100
# $ mtry           : num 2
# $ forest         :List of 14
# ..$ ndbigtree : int [1:100] 167 129 139 155 193 231 187 187 151 183 ...
# ..$ nodestatus: int [1:257, 1:100] 1 1 1 1 1 1 -1 1 1 1 ...
# ..$ bestvar   : int [1:257, 1:100] 6 3 5 5 2 3 0 6 5 2 ...
# ..$ treemap   : int [1:257, 1:2, 1:100] 2 4 6 8 10 12 0 14 16 18 ...
# ..$ nodepred  : int [1:257, 1:100] 0 0 0 0 0 0 1 0 0 0 ...
# ..$ xbestsplit: num [1:257, 1:100] 54 1 5.5 1.5 13 ...
# ..$ pid       : num [1:2] 1 1
# ..$ cutoff    : num [1:2] 0.5 0.5
# ..$ ncat      : Named int [1:7] 1 1 2 1 1 1 3
# .. ..- attr(*, "names")= chr [1:7] "Pclass" "Age" "Sex" "Parch" ...
# ..$ maxcat    : int 3
# ..$ nrnodes   : int 257
# ..$ ntree     : num 100
# ..$ nclass    : int 2
# ..$ xlevels   :List of 7
# .. ..$ Pclass  : num 0
# .. ..$ Age     : num 0
# .. ..$ Sex     : chr [1:2] "female" "male"
# .. ..$ Parch   : num 0
# .. ..$ SibSp   : num 0
# .. ..$ Fare    : num 0
# .. ..$ Embarked: chr [1:3] "C" "Q" "S"
# $ y              : Factor w/ 2 levels "0","1": 1 2 2 2 1 1 1 1 2 2 ...
# $ test           : NULL
# $ inbag          : NULL
# - attr(*, "class")= chr "randomForest"



submission <- data.frame(PassengerId = test$PassengerId) #creat a dataframe to capture survival predictions
submission$Survived <- predict(rf, extractFeatures(test)) #attach predictions
# write.csv(submission, file = "1_random_forest_r_submission.csv", row.names=FALSE)

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