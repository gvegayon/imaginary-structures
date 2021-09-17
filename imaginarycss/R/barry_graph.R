#' Binary Array Graph
#' @param x Either a matrix or a list of matrices.
#' @param ... Currently ignored. 
#' @export
new_barry_graph <- function(x, ...) UseMethod("new_barry_graph")

#' @export
#' @param n Integer. The size of the original network.
#' @details
#' When `x` is a matrix, it is assumed that it will be a block
#' diagonal matrix, with the first block corresponding to the reference
#' (true) network. 
#' 
#' If `x` is a list, the first matrix is assumed to be the reference
#' (true) network.
#' 
#' @rdname new_barry_graph
new_barry_graph.matrix <- function(x, n, ...) {
  
  # Checking that size matches n
  if (diff(dim(x)) != 0L)
    stop("-x- must be a square matrix.", call. = FALSE)
  
  # This must be evenly able to divide
  N <- nrow(x)
  if (N %% n)
    stop("The modulo between nrow(x) and n is not zero.", call. = FALSE)
  
  if (n < 1L)
    stop("-n- cannot less than 1L", call. = FALSE)
  
  # Identifying the endpoints
  n_nets    <- N %/% n 
  endpoints <- cumsum(rep(n, times = n_nets - 1L)) + n
  
  edgelist <- which(x != 0L, arr.ind = TRUE) - 1L
  
  new_barry_graph_cpp(N, edgelist[, 1L], edgelist[, 2L], n, endpoints)
  
}

#' @export
#' @rdname new_barry_graph
new_barry_graph.list <- function(x, ...) {
  
  # Checking all have the same size
  n <- unique(as.vector(sapply(x, dim)))
  if (length(n) != 1L)
    stop("All matrices in -x- should be of the same length.", call. = FALSE)
  
  # Should be of length n
  if (n < 1L)
    stop(
      "The size of the adjacency matrices in -x- should be at least 2L.",
      call. = FALSE
      )
  
  edgelists <- lapply(x, function(x.) {
    which(x. != 0L, arr.ind = TRUE)
  })
  
  # Adjusting indices
  for (i in seq_along(edgelists))
    edgelists[[i]] <- (edgelists[[i]] - 1L) + (i - 1L) * n
  
  edgelists <- do.call(cbind, edgelists)
  
  # Identifying the endpoints
  n_nets    <- length(x)
  endpoints <- cumsum(rep(n, times = n_nets - 1L)) + n
  
  # Creating the edgelist
  new_barry_graph_cpp(n * n_nets, edgelists[, 1], edgelists[, 2], n, endpoints)
 
}

