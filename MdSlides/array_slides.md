% Just a quick draft of some array slides
% In Markdown now so I can get something down
% Will transfer to PowerPoint or whatever

# Vector dimensions

- In R, vectors are *dimensionless*

```r
x <- 1:10
dim(x)  # Will return NULL
```

```
## NULL
```

- Do not confuse them with column and row vectors in linear algebra; they are neither
  - (But they *can* be cast into one-row or one-column matrices)
  
# Matrices by assigning dimensions

- We can convert a vector to a matrix by assigning dimensions

```r
x <- 1:10
dim(x) <- c(5, 2)  # 5 rows, 2 columns
x
```

```
##      [,1] [,2]
## [1,]    1    6
## [2,]    2    7
## [3,]    3    8
## [4,]    4    9
## [5,]    5   10
```

```r
class(x)
```

```
## [1] "matrix"
```

- Note that the matrix was filled one column at a time
- (In R, matrices are stored in column-major order)

# Matrices, more directly

- We can also create a matrix more directly (a better way, in most cases)

```r
A <- matrix(1:10, nrow = 5, ncol = 2)
A
```

```
##      [,1] [,2]
## [1,]    1    6
## [2,]    2    7
## [3,]    3    8
## [4,]    4    9
## [5,]    5   10
```

- Alternatively, we could fill the matrix by row

```r
B <- matrix(1:10, nrow = 5, ncol = 2, byrow = TRUE)
B
```

```
##      [,1] [,2]
## [1,]    1    2
## [2,]    3    4
## [3,]    5    6
## [4,]    7    8
## [5,]    9   10
```


# Diagonal matrices


```r
A <- matrix(c(1, 0, 0, 0, 1, 0, 0, 0, 1), 3, 3)
A
```

```
##      [,1] [,2] [,3]
## [1,]    1    0    0
## [2,]    0    1    0
## [3,]    0    0    1
```

A better way:

```r
B <- diag(1, 3, 3)
B
```

```
##      [,1] [,2] [,3]
## [1,]    1    0    0
## [2,]    0    1    0
## [3,]    0    0    1
```


# Matrix multiplication

- The \* operator is *not* for matrix multiplication
- It is for scalar multiplication (element by element)

```r
I2 <- diag(1, 2, 2)
A <- matrix(1:4, 2, 2)
I2 * A
```

```
##      [,1] [,2]
## [1,]    1    0
## [2,]    0    4
```

- Use %*% instead

```r
I2 %*% A
```

```
##      [,1] [,2]
## [1,]    1    3
## [2,]    2    4
```

- Unless you really do want \*

```r
3 * I2
```

```
##      [,1] [,2]
## [1,]    3    0
## [2,]    0    3
```


# Accessing elements

- To get the $(i, j)$ element of a matrix, use A[i, j], e.g.:

```r
A
```

```
##      [,1] [,2]
## [1,]    1    3
## [2,]    2    4
```

```r
A[2, 1]
```

```
## [1] 2
```

- [i] will work as if the matrix were simply a vector

```r
A[3]
```

```
## [1] 3
```

```r
as.vector(A)
```

```
## [1] 1 2 3 4
```


# Accessing elements

- Sometimes this is what you want!

```r
i <- A > 2
i
```

```
##       [,1] [,2]
## [1,] FALSE TRUE
## [2,] FALSE TRUE
```

```r
A[i]
```

```
## [1] 3 4
```

- Or, more directly

```r
A[A > 2]
```

```
## [1] 3 4
```


# Accessing elements

- Sometimes you'll want an entire row

```r
A[1, ]
```

```
## [1] 1 3
```

- Or an entire column

```r
A[, 2]
```

```
## [1] 3 4
```


# Operations across dimensions

- R uses the term *matrix* for two-dimensional data structures, but don't think of them as simply for linear algebra
- Often, you will have data that is naturally in two dimensions, and you'll want to apply some sort of operation across the rows or columns

# Operations across dimensions

- For example, consider 3 drinking water systems that have sampled for a contaminant
- Each system takes 4 samples
- You could organize this into three separate vectors

```r
samples1 <- c(0, 0, 2, 0)
samples2 <- c(0, 0, 0, 0)
samples3 <- c(1, 1, 0, 1)
```

- But a matrix is far, far better

```r
samples <- matrix(c(samples1, samples2, samples3), 3, 4, byrow = TRUE)
samples
```

```
##      [,1] [,2] [,3] [,4]
## [1,]    0    0    2    0
## [2,]    0    0    0    0
## [3,]    1    1    0    1
```


# Operations across dimensions

- Now say we want the sum of the results for each system
- Instead of summing the rows individually...

```r
sum(samples[1, ])
```

```
## [1] 2
```

```r
sum(samples[2, ])
```

```
## [1] 0
```

```r
sum(samples[3, ])
```

```
## [1] 3
```


# Operations across dimensions

- ...you can use the apply function to apply the sum function to each row

```r
apply(samples, 1, sum)
```

```
## [1] 2 0 3
```

- The 1 is the dimension to sum over---here, the rows, but we could also use 2 for columns
- Say we wanted to take the mean for each point in time (i.e., for each column)

```r
apply(samples, 2, mean)
```

```
## [1] 0.3333 0.3333 0.6667 0.3333
```


# Operations across dimensions

- Folks with programming backgrounds might understand this with a for loop:

```r
result <- vector("numeric", 3)  # A vector of length 3 for the results
for (row in 1:nrow(samples)) {
    result[row] <- sum(samples[row, ])
}
result
```

```
## [1] 2 0 3
```

- Or even:

```r
result <- vector("numeric", 3)
for (row in 1:nrow(samples)) {
    for (col in 1:ncol(samples)) {
        result[row] <- result[row] + samples[row, col]
    }
}
result
```

```
## [1] 2 0 3
```

- But you usually shouldn't do this! (Plus, isn't it ugly?)

# Modes
- Matrices are not limited to numeric and integer modes
- You can have, for example, a character matrix:

```r
x <- matrix(month.name, 3, 4)
x
```

```
##      [,1]       [,2]    [,3]        [,4]      
## [1,] "January"  "April" "July"      "October" 
## [2,] "February" "May"   "August"    "November"
## [3,] "March"    "June"  "September" "December"
```


# Arrays

- Why limit ourselves to two dimensions?
- In R, a matrix is a special case of an *array*, which can have many dimensions
- Arrays are quite powerful and allow calculations to be performed quickly
