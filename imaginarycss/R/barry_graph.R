#' 
#' @export
new_barry_graph <- function(x, ...) UseMethod("new_barry_graph")

#' @export
#' @rdname new_barry_graph
new_barry_graph.matrix <- function(x, n, ...) {
  
  # Checking that size matches n
  if (diff(dim(x)) != 0L)
    stop("-x- must be a square matrix.", call. = FALSE)
  
  # This must be evenly able to divide
  N <- nrow(x)
  if (!N %% n)
    stop("The modulo between nrow(x) and n is not zero.", call. = FALSE)
  
  if (n < 1L)
    stop("-n- cannot less than 1L", call. = FALSE)
  
  edgelist <- which(x != 0L, arr.ind = TRUE) - 1L
  
  new_barry_graph_cpp(n, edgelist[, 1L], edgelist[, 2L])
  
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
  
  # Creating the edgelist
  new_barry_graph_cpp(n, edgelists[, 1], edgelists[, 2])
 
}

