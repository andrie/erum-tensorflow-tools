library(tfruns)
library(dplyr)

# Combinations: 1,259712
# Desired runs: 64
fraction <- 128 / 1259712
round(fraction, 6)

tfruns::tuning_run(
  "walking_flags.R",
  sample = fraction,
  flags = list(
    conv_1_filters = c(16, 32, 64),
    conv_1_kernel = c(8, 16, 32),
    conv_1_pooling = c(2, 4),
    conv_1_dropout = c(0.1, 0.2, 0.5),
    
    conv_2_filters = c(16, 32, 64),
    conv_2_kernel = c(8, 16, 32),
    conv_2_pooling = c(2, 4),
    conv_2_dropout = c(0.1, 0.2, 0.5),
    
    dense_1_nodes = c(32, 64, 128, 256),
    dense_1_dropout = c(0.1, 0.2, 0.5),
    
    dense_2_nodes = c(32, 64, 128, 256),
    dense_2_dropout = c(0.1, 0.2, 0.5),
    
    mini_batch_size = c(16, 32, 64)
  )
)

runs <- ls_runs() %>% 
  as_tibble()
runs
runs %>% View()
runs

runs <- ls_runs(order = "eval_acc") %>% 
  as_tibble()
runs

ls_runs(order = "eval_acc") %>%
  head(2) %>%
  tfruns::compare_runs()


runs[1, ] %>% view_run()
runs[2, ] %>% view_run()


runs %>% View()

ls_runs(order = "eval_acc") %>% 
  as_tibble() %>% 
  tail()


ls_runs(order = "eval_acc") %>% 
  head(2) %>% 
  tfruns::compare_runs()