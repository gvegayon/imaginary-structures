
# Placeholder with simple test
expect_equal(1 + 1, 2)

set.seed(331)
x <- matrix(sample.int(2, 9, replace = TRUE), ncol = 3) - 1L
diag(x) <- 0

# Perfect accuracy
graph <- new_barry_graph(list(x, x, x))
acc <- tie_level_accuracy(graph)
expect_true(all(unlist(
  acc[, -1],
  recursive = TRUE
  ) == 1))

# Sampling should always get the same
graphs0 <- sample_css_network(graph, acc, keep_baseline = FALSE)
graphs1 <- sample_css_network(graph, acc, keep_baseline = FALSE)
expect_equal(graphs0, graphs1)
expect_equal(graphs0[[1]], x, check.attributes = FALSE)
expect_equal(graphs0[[2]], x, check.attributes = FALSE)

# One of them is 50%
x50 <- x
x50[1, 2] <- 0
graph <- new_barry_graph(list(x, x50, x))

one50 <- structure(list(p_0_ego = c(1, 1), p_1_ego = c(0.5, 1), p_0_alter = c(1, 
1), p_1_alter = c(1, 1)), class = c("data.frame", "tie_level_accuracy"
), row.names = c(NA, -2L))

expect_equal(
  tie_level_accuracy(graph)[, -1],
  one50)

