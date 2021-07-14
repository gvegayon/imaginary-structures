load("../data/krackhardt_css.RData")

# Building large blockdiag
bd <- ergmito::blockdiagonalize(c(list(advice_net), advice_nets))

el <- as.edgelist(bd)
write.csv(el, "data-raw/advice_nets.csv", row.names = FALSE)
