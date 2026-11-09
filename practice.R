ages <- c(23, 35, 41, 52)
mean(ages)
length(ages)

scores <- c(7, 8, NA)
mean(scores, na.rm = TRUE)

library(tibble)
tibble(a = 1)

tibble::tibble(a = 1)


# Table or make DF
library(tibble)
people <- tibble(
  name = c("Alex", "Sam", "Jo"),
  age = c(24, 31, 17),
  group = c("A", "B", "A")
)
people

cumsum(people$age)

#
library(dplyr)
adults = filter(people,age>18)
adults


adults <- people |>
  filter(age >= 18) |>
  mutate(age_next_year = age + 1)
adults


library(here)
here()
