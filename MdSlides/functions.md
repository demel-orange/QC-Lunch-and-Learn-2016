% Functions

# User-defined Functions

- To define your own function, use the *function* function:

```r
square <- function(x) x^2
square(5)
```

```
## [1] 25
```

```r
square(8)
```

```
## [1] 64
```


- Function definition is in the form function(arglist) expr

# Longer functions

- For longer functions (more than one line), the expression can be bracketed
- Even for shorter functions, this can make things more readable

```r
square <- function(x) {
    x^2
}
```


# Return values

- You can use the return function to explicitly return values

```r
square <- function(x) {
    return(x^2)
}
```

- Otherwise, the last evaluated expression is returned, as we've seen above

# Return values, continued

- Return is particularly useful for early exits

```r
square <- function(x) {
    if (!is.numeric(x)) {
        return(NaN)
    }
    x^2
}
square(6)
```

```
## [1] 36
```

```r
square("R")
```

```
## [1] NaN
```


# Multiple arguments

- Functions can, of course, operate on multiple arguments

```r
sum.of.squares <- function(x, y) {
    sum(x^2 + y^2)
}
sum.of.squares(5, 10)
```

```
## [1] 125
```

```r
sum.of.squares(x = 5, y = 10)
```

```
## [1] 125
```

```r
sum.of.squares(y = 10, x = 5)
```

```
## [1] 125
```


# Default values

- You can also specify default values for arguments

```r
sum.of.squares <- function(x, y = 0) {
    sum(x^2 + y^2)
}
sum.of.squares(5)
```

```
## [1] 25
```

```r
sum.of.squares(5, 0)
```

```
## [1] 25
```

```r
sum.of.squares(5, 10)
```

```
## [1] 125
```


# Variable scope

- Generally, variables created in functions only exist within that function,
even if they have the same name as an existing variable

```r
x <- 5
my.fun <- function() {
    x <- 25
}
my.fun()
x
```

```
## [1] 5
```


# Variable scope, continued

- However, it is possible to assign to variables in the outer environment

```r
x <- 5
my.fun <- function() {
    x <<- 25
}
my.fun()
x
```

```
## [1] 25
```

- But you generally shouldn't need to do this!
- The exact workings of this are actually somewhat complex

# Lexical scoping

- R uses *lexical scoping*
- Basically, a variable exists within a given environment but not outside of that environment
- The previous example covers most of what you *need* to know, but there's more to scoping

# Functions as objects

- Functions are actually objects themselves:

```r
my.fun <- function() 42
mode(my.fun)
```

```
## [1] "function"
```

- You can assign them:

```r
my.fun2 <- my.fun
```

- Or pass them around:

```r
call.fun <- function(x) x()
call.fun(my.fun)
```

```
## [1] 42
```


# Functions as objects

- You can even return a function from a function:

```r
make.normal.pdf <- function(mu, sigma) {
    function(x) dnorm(x, mu, sigma)
}
dmydist1 <- make.normal.pdf(10, 2)
dmydist2 <- make.normal.pdf(20, 1)
dmydist1(10)
```

```
## [1] 0.1995
```

```r
dnorm(10, 10, 2)
```

```
## [1] 0.1995
```

```r
dmydist2(10)
```

```
## [1] 7.695e-23
```

```r
dnorm(10, 20, 1)
```

```
## [1] 7.695e-23
```

- Note how the values of mu and sigma are "remembered"---a consequence of scope

# Vectorizing functions

- Arguments to functions might be vectors of length > 1

```r
sqrt(1:10)
```

```
##  [1] 1.000 1.414 1.732 2.000 2.236 2.449 2.646 2.828 3.000 3.162
```

- Often you don't need to explicitly account for this at all

```r
square <- function(x) x^2
square(1:10)
```

```
##  [1]   1   4   9  16  25  36  49  64  81 100
```

