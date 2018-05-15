library(keras)
library(tfruns)
FLAGS <- tfruns::flags(
  flag_integer("conv_1_filters", 16),
  flag_integer("conv_1_kernel", 32),
  flag_integer("conv_1_pooling", 2),
  flag_numeric("conv_1_dropout", 0.25),
  
  flag_integer("conv_2_filters", 32),
  flag_integer("conv_2_kernel", 16),
  flag_integer("conv_2_pooling", 2),
  flag_numeric("conv_2_dropout", 0.25),
  
  flag_integer("dense_1_nodes", 64),
  flag_numeric("dense_1_dropout", 0.25),
  
  flag_integer("dense_2_nodes", 64),
  flag_numeric("dense_2_dropout", 0.25),
  
  flag_numeric("mini_batch_size", 32)
)


# Load the test data
x_walk <- readRDS("data/x_walk.rds")
y_walk <- readRDS("data/y_walk.rds")

# Define the model
model <- keras_model_sequential() %>%
  
  # first convolution
  layer_conv_1d(
    input_shape = c(260, 3),
    filters = FLAGS$conv_1_filters, 
    kernel_size = FLAGS$conv_1_kernel,
    activation = "relu"
  ) %>%
  layer_max_pooling_1d(pool_size = FLAGS$conv_1_pooling) %>%
  layer_dropout(FLAGS$conv_1_dropout) %>% 
  
  # second convolution
  layer_conv_1d(
    filters = FLAGS$conv_1_filters, 
    kernel_size = FLAGS$conv_1_kernel,
    activation = "relu"
    ) %>%
  layer_max_pooling_1d(pool_size = FLAGS$conv_2_pooling) %>%
  layer_dropout(FLAGS$conv_2_dropout) %>% 
  
  # flatten
  layer_flatten() %>%
  
  # fully connected
  layer_dense(units = FLAGS$dense_1_nodes, activation = "relu") %>%
  layer_dropout(FLAGS$dense_1_dropout) %>% 
  
  layer_dense(units = FLAGS$dense_2_nodes, activation = "relu") %>%
  layer_dropout(FLAGS$dense_2_dropout) %>% 
  
  layer_dense(units = 15, activation = "softmax")

model



# Compile
model %>%
  compile(
    loss = "categorical_crossentropy",
    optimizer = "adam",
    metrics = c("accuracy")
  )

# Run
history <- model %>% 
  fit(
    x_walk$train,
    y_walk$train,
    epochs = 25,
    batch_size = 64,
    validation_split = 0.2,
    verbose = 1
)

# Evaluate
model %>%
  evaluate(x_walk$test, y_walk$test, verbose = 0)
