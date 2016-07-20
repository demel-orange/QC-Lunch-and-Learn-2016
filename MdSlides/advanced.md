% Advanced Programming

# Classes and Methods


```r
species.counts <- table(iris$Species)
print(species.counts)
```

```
## 
##     setosa versicolor  virginica 
##         50         50         50
```

```r
my.formula <- Petal.Length ~ Petal.Width
print(my.formula)
```

```
## Petal.Length ~ Petal.Width
```

```r
my.reg <- lm(my.formula, data = iris)
print(my.reg)
```

```
## 
## Call:
## lm(formula = my.formula, data = iris)
## 
## Coefficients:
## (Intercept)  Petal.Width  
##        1.08         2.23
```


- How does the `print` function know what to print in each of these cases?

# Classes and Methods

- `print` is actually a *generic method*
- A `print` function is actually defined for each of many different R *classes*
- Think of a class as an extension of data type
- You can define your own classes!


```r
class(species.counts)
```

```
## [1] "table"
```

```r
class(my.formula)
```

```
## [1] "formula"
```

```r
class(my.reg)
```

```
## [1] "lm"
```


# Generic Methods


```r
print
```

```
## function (x, ...) 
## UseMethod("print")
## <bytecode: 0x041342e0>
## <environment: namespace:base>
```

```r
print.lm
```

```
## function (x, digits = max(3L, getOption("digits") - 3L), ...) 
## {
##     cat("\nCall:\n", paste(deparse(x$call), sep = "\n", collapse = "\n"), 
##         "\n\n", sep = "")
##     if (length(coef(x))) {
##         cat("Coefficients:\n")
##         print.default(format(coef(x), digits = digits), print.gap = 2L, 
##             quote = FALSE)
##     }
##     else cat("No coefficients\n")
##     cat("\n")
##     invisible(x)
## }
## <bytecode: 0x02e8e96c>
## <environment: namespace:stats>
```


# Classes

- Some languages heavily emphasize classes, and, more broadly, object-oriented programming
- R is not like this
- In fact, R's class system is...complicated, with a long and twisted history
- You may encounter the terms *S3*, *S4*, and *reference classes* (or "R5"); these are R's three different class systems
- You will mostly encounter S3 classes, which are simple (good and bad)

# S3 Classes

- Say we have some simulation results that we want to save
- We also want to save the seed used to produce the results

```r
seed <- 123
set.seed(seed)
x <- rnorm(10)
my.sim <- list(seed = seed, draws = x)
class(my.sim)
```

```
## [1] "list"
```

```r
print(my.sim)
```

```
## $seed
## [1] 123
## 
## $draws
##  [1] -0.56048 -0.23018  1.55871  0.07051  0.12929  1.71506  0.46092
##  [8] -1.26506 -0.68685 -0.44566
```


# S3 Classes

- We could change the class!

```r
class(my.sim) <- "sim.res"
class(my.sim)
```

```
## [1] "sim.res"
```


# S3 Classes

- We could even define a print method for this class


```r
print.sim.res <- function(sim.res) {
    cat("Seed:", sim.res$seed, "\n")
    cat("Draws:\n")
    print(sim.res$draws)
}
print(my.sim)
```

```
## Seed: 123 
## Draws:
##  [1] -0.56048 -0.23018  1.55871  0.07051  0.12929  1.71506  0.46092
##  [8] -1.26506 -0.68685 -0.44566
```


# Attributes

- Alternatively, we could have stored the seed in an *attribute*


```r
my.draws <- x
attr(my.draws, "seed") <- seed
my.draws
```

```
##  [1] -0.56048 -0.23018  1.55871  0.07051  0.12929  1.71506  0.46092
##  [8] -1.26506 -0.68685 -0.44566
## attr(,"seed")
## [1] 123
```


# Examining structure


```r
str(my.sim)
```

```
## List of 2
##  $ seed : num 123
##  $ draws: num [1:10] -0.5605 -0.2302 1.5587 0.0705 0.1293 ...
##  - attr(*, "class")= chr "sim.res"
```

```r
str(my.draws)
```

```
##  atomic [1:10] -0.5605 -0.2302 1.5587 0.0705 0.1293 ...
##  - attr(*, "seed")= num 123
```


# Warnings and Errors

- Sometimes (or maybe often) things don't go smoothly


```r
1:10 + 1:3
```

```
## Warning: longer object length is not a multiple of shorter object length
```

```
##  [1]  2  4  6  5  7  9  8 10 12 11
```

```r
matrix(1:10, ncol = 2) %*% matrix(1:3, ncol = 3)
```

```
## Error: non-conformable arguments
```


- *Warnings* are displayed to the user, while *errors* also stop execution

# Generating warnings


```r
find.most.freq <- function(x) {
    counts <- table(x)
    names(counts)[which.max(counts)]
}
nums <- c(1, 2, 3, 4, 4, 4, 5, 5, 6)
find.most.freq(nums)
```

```
## [1] "4"
```

```r
nums <- c(nums, NA)
find.most.freq(nums)
```

```
## [1] "4"
```

- Should we say something about the NAs?

# Generating warnings


```r
find.most.freq <- function(x) {
    if (any(is.na(x))) {
        warning("x contains NA")
    }
    counts <- table(x)
    names(counts)[which.max(counts)]
}
find.most.freq(nums)
```

```
## Warning: x contains NA
```

```
## [1] "4"
```


# Generating errors


```r
find.most.freq <- function(x) {
    if (any(is.na(x))) {
        stop("x contains NA")
    }
    counts <- table(x)
    names(counts)[which.max(counts)]
}
find.most.freq(nums)
```

```
## Error: x contains NA
```


# Handling warnings

- Just pay attention! R is trying to tell you something important
- But if you have good reason to ignore the warning:

```r
suppressWarnings(1:10 + 1:3)
```

```
##  [1]  2  4  6  5  7  9  8 10 12 11
```


# Handling errors

- You can continue execution, essentially ignoring the error:

```r
try(matrix(1:10, ncol = 2) %*% matrix(1:3, ncol = 3))
```


- Or provide some sort of action to take in response:

```r
tryCatch(matrix(1:10, ncol = 2) %*% matrix(1:3, ncol = 3), error = function(e) print("Shouldn't have done that!"))
```

```
## [1] "Shouldn't have done that!"
```


# Debugging

- You can stop execution and enter the debugger by calling the `browser` function
- You can also debug an entire function by passing the function to `debug`
- It's possible to locate the source of an error by calling the `traceback` function
- Sometimes, it's easiest to tell R that you want to enter the debugger automatically when an error is thrown:

```r
options(error = recover)
```

