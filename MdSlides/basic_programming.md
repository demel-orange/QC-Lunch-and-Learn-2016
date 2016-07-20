% Basic Programming

# Simulation

- R makes simulating random numbers very easy. For example, from a standard normal:

```r
rnorm(5)
```

```
## [1]  1.5220  0.3320 -0.9270  0.2638  1.1510
```

- Or, say $X \sim \mathcal{N}\left(12, 4\right)$:

```r
x <- rnorm(1e+06, 12, 2)
mean(x)
```

```
## [1] 12
```

```r
var(x)
```

```
## [1] 4.002
```

- Note that R parameterizes the normal in terms of the standard deviation

# PDF
-PDF of our example:

```r
dnorm(10, 12, 2)
```

```
## [1] 0.121
```

```r
dnorm(12, 12, 2)
```

```
## [1] 0.1995
```

```r
dnorm(Inf, 12, 2)
```

```
## [1] 0
```


# CDF and Quantile Function
- CDF:

```r
pnorm(10, 12, 2)
```

```
## [1] 0.1587
```

```r
pnorm(12, 12, 2)
```

```
## [1] 0.5
```

```r
pnorm(Inf, 12, 2)
```

```
## [1] 1
```

- Quantile function:

```r
qnorm(0.16, 12, 2)
```

```
## [1] 10.01
```

```r
qnorm(0.5, 12, 2)
```

```
## [1] 12
```

```r
qnorm(1, 12, 2)
```

```
## [1] Inf
```


# Distributions

- Type `?Distributions` in R for a list of distributions built-in to R
- Don't see what you need? Try checking CRAN!

# Control Structures

# Coding Practices

- Sometimes you'll just use R interactively, or for very quick scripts
- Other times, you may write longer, more complicated scripts
- It's important to follow some basic best practices so that your code is reliable and can be easily revisited later on

# Best Practices

1. Favor simple, readable solutions
2. Don't repeat yourself
3. Don't re-invent the wheel

# Favor simple, readable solutions

# Don't repeat yourself

# Don't reinvent the wheel
