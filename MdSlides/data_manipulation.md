% Data Manipulation
% with the iris dataset


# Motivation

Consider the `iris` dataset.

```r
head(iris)
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          5.1         3.5          1.4         0.2  setosa
## 2          4.9         3.0          1.4         0.2  setosa
## 3          4.7         3.2          1.3         0.2  setosa
## 4          4.6         3.1          1.5         0.2  setosa
## 5          5.0         3.6          1.4         0.2  setosa
## 6          5.4         3.9          1.7         0.4  setosa
```


# Motivation

We can produce a basic summary of the dataset with `summary`:

```r
summary(iris)
```

```
##   Sepal.Length   Sepal.Width    Petal.Length   Petal.Width 
##  Min.   :4.30   Min.   :2.00   Min.   :1.00   Min.   :0.1  
##  1st Qu.:5.10   1st Qu.:2.80   1st Qu.:1.60   1st Qu.:0.3  
##  Median :5.80   Median :3.00   Median :4.35   Median :1.3  
##  Mean   :5.84   Mean   :3.06   Mean   :3.76   Mean   :1.2  
##  3rd Qu.:6.40   3rd Qu.:3.30   3rd Qu.:5.10   3rd Qu.:1.8  
##  Max.   :7.90   Max.   :4.40   Max.   :6.90   Max.   :2.5  
##        Species  
##  setosa    :50  
##  versicolor:50  
##  virginica :50  
##                 
##                 
## 
```

But what if this particular summary doesn't suit us? What if we're interested in, for example, additional quantiles for the numeric variables? Or what if we want to produce a histogram for each variable?

# A repetitive solution
We could perform operations manually on each variable:



```r
mean.sepal.length <- mean(iris$Sepal.Length)
sepal.length.lower <- quantile(iris$Sepal.Length, 0.05)
sepal.length.upper <- quantile(iris$Sepal.Length, 0.95)
qplot(Sepal.Length, data = iris, binwidth = 0.2)
```

![](figure/unnamed-chunk-4.png) 

Etc.

# A slightly better solution
But what if we later need to tweak the histogram? Or change the quantiles? We'd have to do this multiple times! A better solution would be to define a function that performs all the needed operations on a parameter. For example:


```r
calc.mean.and.quantiles <- function(x) {
    c(mean = mean(x), quantile(x, 0.05), quantile(x, 0.95))
}
calc.mean.and.quantiles(iris$Sepal.Length)
```

```
##  mean    5%   95% 
## 5.843 4.600 7.255
```

```r
calc.mean.and.quantiles(iris$Sepal.Width)
```

```
##  mean    5%   95% 
## 3.057 2.345 3.800
```


This works fine for small datasets, but what if we don't even know the variable names? Or what if there are too many?

# A more general solution

The data is currently in *wide* form, with a column for each variable. We can put it in *long* form, with a column for variable names and another column for values. The best library for this is `reshape2`.


```r
library(reshape2)
iris.long <- melt(iris, "Species")
head(iris.long)
```

```
##   Species     variable value
## 1  setosa Sepal.Length   5.1
## 2  setosa Sepal.Length   4.9
## 3  setosa Sepal.Length   4.7
## 4  setosa Sepal.Length   4.6
## 5  setosa Sepal.Length   5.0
## 6  setosa Sepal.Length   5.4
```


# Immediate payoff


```r
qplot(value, data = iris.long, binwidth = 0.2) + facet_wrap(~variable)
```

![](figure/unnamed-chunk-7.png) 


# Immediate payoff


```r
qplot(value, data = iris.long, binwidth = 0.2) + facet_grid(Species ~ variable)
```

![](figure/unnamed-chunk-8.png) 

How many lines would this take if another method were used?

# Summary statistics


```r
tapply(iris.long$value, iris.long$variable, function(x) {
    c(mean = mean(x), quantile(x, 0.05), quantile(x, 0.95))
})
```

```
## $Sepal.Length
##  mean    5%   95% 
## 5.843 4.600 7.255 
## 
## $Sepal.Width
##  mean    5%   95% 
## 3.057 2.345 3.800 
## 
## $Petal.Length
##  mean    5%   95% 
## 3.758 1.300 6.100 
## 
## $Petal.Width
##  mean    5%   95% 
## 1.199 0.200 2.300
```


# Summary Statistics with plyr


```r
library(plyr)
ddply(iris.long, .(variable), function(x) {
    c(mean = mean(x$value), quantile(x$value, 0.05), quantile(x$value, 0.95))
})
```

```
##       variable  mean    5%   95%
## 1 Sepal.Length 5.843 4.600 7.255
## 2  Sepal.Width 3.057 2.345 3.800
## 3 Petal.Length 3.758 1.300 6.100
## 4  Petal.Width 1.199 0.200 2.300
```


# Summary Statistics with plyr


```r
ddply(iris.long, .(variable), summarize, mean = mean(value), lower = quantile(value, 
    0.05), upper = quantile(value, 0.95))
```

```
##       variable  mean lower upper
## 1 Sepal.Length 5.843 4.600 7.255
## 2  Sepal.Width 3.057 2.345 3.800
## 3 Petal.Length 3.758 1.300 6.100
## 4  Petal.Width 1.199 0.200 2.300
```


# Summary Statistics with plyr


```r
ddply(iris.long, .(variable, Species), summarize, mean = mean(value), lower = quantile(value, 
    0.05), upper = quantile(value, 0.95))
```

```
##        variable    Species  mean lower upper
## 1  Sepal.Length     setosa 5.006 4.400 5.610
## 2  Sepal.Length versicolor 5.936 5.045 6.755
## 3  Sepal.Length  virginica 6.588 5.745 7.700
## 4   Sepal.Width     setosa 3.428 3.000 4.055
## 5   Sepal.Width versicolor 2.770 2.245 3.200
## 6   Sepal.Width  virginica 2.974 2.500 3.510
## 7  Petal.Length     setosa 1.462 1.200 1.700
## 8  Petal.Length versicolor 4.260 3.390 4.900
## 9  Petal.Length  virginica 5.552 4.845 6.655
## 10  Petal.Width     setosa 0.246 0.100 0.400
## 11  Petal.Width versicolor 1.326 1.000 1.600
## 12  Petal.Width  virginica 2.026 1.545 2.455
```

