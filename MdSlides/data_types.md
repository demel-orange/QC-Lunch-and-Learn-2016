% Data Types and Modes

# Modes

- R has a handful of simplified (in comparison to other languages, and to the true underlying data type) data types called *modes*
- Some important ones are numeric, logical, character, and factor

# Numeric

- The *numeric* mode handles numbers (integers and doubles)

```r
mode(1)
```

```
## [1] "numeric"
```

```r
mode(1e+05)
```

```
## [1] "numeric"
```

```r
mode(pi)
```

```
## [1] "numeric"
```


# Logical

- The *logical* mode handles true or false values (booleans, in other languages)

```r
mode(TRUE)
```

```
## [1] "logical"
```

```r
5 > 8
```

```
## [1] FALSE
```

```r
mode(5 > 8)
```

```
## [1] "logical"
```


# Character

- The *character* mode handles string data

```r
mode("John Doe")
```

```
## [1] "character"
```

```r
mode(as.character(9))
```

```
## [1] "character"
```


# Factor

- Sometimes you'll want to divide your data into categories
- The *factor* mode is useful here
- You're able to specify valid *levels* (categories) of the factor

```r
grade.levels <- c("A", "B", "C", "D", "F")
my.grades <- factor(c("A", "B", "B", "B", "F", "D", "A"), grade.levels)
my.grades
```

```
## [1] A B B B F D A
## Levels: A B C D F
```


# Handling missing data

- In many situations, you'll have missing data; how do you represent this?
- This is what *NA* is for

```r
ages <- c(26, NA, 23, 30)
is.na(ages)
```

```
## [1] FALSE  TRUE FALSE FALSE
```

```r
mean(ages)
```

```
## [1] NA
```

```r
mean(ages, na.rm = TRUE)
```

```
## [1] 26.33
```


# Comparing NAs


```r
4 + NA
```

```
## [1] NA
```

```r
5 > NA
```

```
## [1] NA
```

