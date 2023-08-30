#' Null distribution for Cognitive Imaginary Structures
#' @param graph A barry_graph object.
#' @param which_nets Integer vector. The networks to sample from.
#' @examples 
#' \dontrun{
#' taccuracy <- tie_level_accuracy(graph)
#' boxplot(taccuracy[,-1])
#' }
#' @export 
tie_level_accuracy <- function(
  graph,
  which_nets = NULL
  ) {

  # Error if graph is not barry_graph
  if (!inherits(graph, "barry_graph"))
    stop("The graph is not a barry_graph.", call. = FALSE)

  # Getting the edgelist
  elist <- barray_to_edgelist(graph)

  # And other graph attributes
  netsize   <- attr(graph, "netsize")
  endpoints <- attr(graph, "endpoints")
  nnets     <- length(endpoints)

  if (length(which_nets) == 0L)
    which_nets <- seq_len(nnets)
  else {
    if (any(which_nets < 1L) || any(which_nets > nnets))
      stop("The networks to sample from are not valid.", call. = FALSE)
  }
  
  # Generating the matrices
  # Since endpoints starts at 0, we need to correct
  endpoints <- endpoints + 1L
  from <- c(netsize + 1, endpoints)
  to   <- from + nnets


  # Generating the baseline graph
  elist0 <- elist[
    which((elist[, 1] <= netsize) & (elist[, 2] <= netsize)), ,
    drop = FALSE
  ]

  g_0 <- matrix(0L, nrow = netsize, ncol = netsize)
  g_0[elist0] <- 1L


  # Identifying 
  edgelist <- lapply(which_nets, function(i) {

    # Extracting edges
    eseq <- from[i]:to[i]

    e_i <- elist[
      which((elist[, 1] %in% eseq) & (elist[, 2] %in% eseq)),
      ,
      drop = FALSE] - from[i] + 1L

    # Creating the graph
    g_i <- matrix(0L, nrow = netsize, ncol = netsize)
    g_i[e_i] <- 1L

    # Computing the true positive rate
    p_1_alter <- g_0[-i, -i, drop = FALSE]
    p_1_alter <- which(p_1_alter == 1, arr.ind = TRUE)

    p_1_alter <- mean(g_i[-i, -i, drop=FALSE][p_1_alter] == 1)

    # The same but for 0
    p_0_alter <- g_0[-i, -i, drop = FALSE]
    p_0_alter <- which(p_0_alter == 0, arr.ind = TRUE)

    p_0_alter <- mean(g_i[-i, -i, drop=FALSE][p_0_alter] == 0)

    # Now only for i
    p_1_ego <- c(g_0[i,], g_0[, i])
    p_1_ego <- which(p_1_ego == 1)

    p_1_ego <- mean(
      c(g_i[i, ], g_i[, i])[p_1_ego] == 1
      )

    # The same but for 0
    p_0_ego <- c(g_0[i,], g_0[, i])
    p_0_ego <- which(p_0_ego == 0)

    p_0_ego <- mean(
      c(g_i[i, ], g_i[, i])[p_0_ego] == 0
      )


    data.frame(
      i         = i,
      p_1_alter = p_1_alter,
      p_0_alter = p_0_alter,
      p_1_ego   = p_1_ego,
      p_0_ego   = p_0_ego
    )


  })

  # Generating the samples
  do.call(rbind, edgelist)

}


