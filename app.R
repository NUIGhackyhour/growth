library(ggplot2)
library(tidyr)

nt <- 10
set.seed(12345)
dat <- data.frame(
  t=seq(1, 100, 10),
  bug1=sort(rnorm(n=nt, 1)),
  bug2=sort(rnorm(n=nt, 1)),
  bug3=sort(rnorm(n=nt, 1))
)

tdat <- dat %>% gather(sample, value, -t)
ggplot(tdat, aes(x=t, y=value, color=sample)) + geom_point() 

