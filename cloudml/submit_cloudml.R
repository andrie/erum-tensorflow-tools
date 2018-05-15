# devtools::install_github("rstudio/cloudml")
# cloudml::gcloud_install()
# cloudml::gcloud_init()

# Then navigate to the CloudML console:
# https://console.cloud.google.com/mlengine/


library(here)

setwd(here("cloudml"))

library(cloudml)
library(dplyr)

# Upload the data to storage bucket using storage browser
# https://console.cloud.google.com/storage/browser
# Also see instructions at
# https://tensorflow.rstudio.com/tools/cloudml/articles/storage.html


cloudml_train("walking_cloudml.R", collect = TRUE, config = "tuning.yml")

trials <- job_trials() %>% 
  as_tibble() %>% 
  select(-one_of("hyperparameters.data_dir"))
trials
View(trials)

trials_clean <- job_trials() %>% 
  as_tibble() %>% 
  select(-one_of("hyperparameters.data_dir"))
  mutate_at(vars(starts_with("hyperParameters")), round, 2) %>% 
  rename_all(~sub("finalMetric.", "", .)) %>% 
  rename_all(~sub("hyperparameters.", "", .)) %>% 
  select(-c(trainingStep)) %>% 
  arrange(desc(objectiveValue))

trials_clean

library(ggplot2)
trials_clean %>% 
  ggplot(aes(x = trialId, y = objectiveValue)) +
  geom_point() +
  stat_smooth(method = "lm") +
  theme_bw(20)

job_collect(trials = "best")

# cloudml_train("mnist_cnn_cloudml.R", collect = TRUE, config = "tuning_2.yml")
