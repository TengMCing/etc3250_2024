# week 2 ------------------------------------------------------------------

library(tidyverse)
library(tidymodels)

# Q5.

pred_data <- read_csv("https://raw.githubusercontent.com/numbats/iml/master/data/tutorial_pred_data.csv") |>
  mutate(true = factor(true))

# a.

table(pred_data$true)

# b.

# Get a confusion matrix.
this_conf <- pred_data %>%
  mutate(pred = ifelse(adelie > chinstrap, "Adelie", "Chinstrap")) %>%
  mutate(pred = factor(pred)) %>%
  conf_mat(true, pred) %>%
  
  # The result is a list, the actual confusion table is stored in `table`.
  # We can transpose the table to make "Truth" as columns. 
  {t(.$table)}

this_conf

# Add a column for accuracy.
# We can bind a column to the original matrix, 
# since the correct cases are all diagonal elements, we can use them to divide
# by the row sum.
this_conf_with_acc <- cbind(this_conf, diag(this_conf) / rowSums(this_conf))


# We then need to properly name the table.
# The first dimension name vector is for rows.
# The second dimension name vector is for columns.
dimnames(this_conf_with_acc) <- list(Truth = c("Adelie", "Chinstrap"),
                                     Prediction = c("Adelie", "Chinstrap", "Accuracy"))
this_conf_with_acc
