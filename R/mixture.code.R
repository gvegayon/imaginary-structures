#bbnam.mix - Fit a multi-informant BBNAM with graph mixture priors
#
#See Butts (2014) for details on the modeling framework and
#assumptions, including the definition of the beta-Binomial
#and Dirichlet-categorical graph priors.
#
#CTB, 3/8/20
#
#Arguments:
#    dat: Input networks to be analyzed.  This may be supplied in any
#         reasonable form, but must be reducible to an array of
#         dimension m x n x n, where n is |V(G)|, the first dimension
#         indexes the observer (or information source), the second
#         indexes the sender of the relation, and the third dimension
#         indexes the recipient of the relation.  (E.g.,
#         dat[i,j,k]==1 implies that i observed j sending the
#         relation in question to k.)  Note that only dichotomous data
#         is supported at present, and missing values are permitted;
#         the data collection pattern, however, is assumed to be
#         ignorable, and hence the posterior draws are implicitly
#         conditional on the observation pattern.  (Note: to estimate
#         self-report and proxy report error rates separately, 
#         provide two entries for each informant, one in which the
#         informant's own row and column are set as missing, and
#         another in which every entry other than those in the
#         informant's own row and column are set as missing.  This
#         will both treat self and proxy reports separately and
#         estimate distinct false positive and false negative rates
#         for the self and proxy reports produced by each informant.)
#
# nprior: Network prior hyperparameters.  This should be a vector of
#         length 2 (for beta-Bernoulli graphs) or length 3 (for
#         Dirichlet-categorical graphs) containing the hyperparameters
#         for the graph mixture distribution.  For the beta-Binomial
#         model, these can be thought of as the alpha and beta parameters
#         for a beta hyperprior distribution on the expected graph
#         density.  For the Dirichlet-categorical model, these can be
#         thought as the three concentration parameters governing a
#         three-dimensional Dirichlet distribution over the expected
#         rates of incidence for mutual, asymmetric, and null dyads
#         (respectively) in the network prior.  In particular, note
#         that choosing c(0.5,0.5) or c(0.5,0.5,0.5) will employ the
#         Jeffreys hyperprior for each respective case; this is the
#         default.
#
#emprior: Parameters for the (Beta) false negative prior; these should
#         be in the form of an (alpha,beta) pair for the pooled model,
#         and of an n x 2 matrix of (alpha,beta) pairs for the actor
#         model (or something which can be coerced to this form). If no
#         emprior is given, a weakly informative prior (1,11) will be
#         assumed; note that this may be inappropriate, as described
#         below.  Missing values are not allowed.
#
#epprior: Parameters for the (Beta) false positive prior; these should
#         be in the form of an (alpha,beta) pair for the pooled model,
#         and of an n x 2 matrix of (alpha,beta) pairs for the actor
#         model (or something which can be coerced to this form). If no
#         epprior is given, a weakly informative prior (1,11) will be
#         assumed; note that this may be inappropriate, as described
#         below.  Missing values are not allowed.
#
#   diag: Boolean indicating whether loops (matrix diagonals) should be
#         counted as data.
#
#   mode: A string indicating whether the data in question forms a
#         "graph" or a "digraph".
#
#   reps: Number of replicate chains for the Gibbs sampler.
#
#  draws: Integer indicating the total number of draws to take from the
#         posterior distribution.  Draws are taken evenly from each
#         replication (thus, the number of draws from a given chain is
#         draws/reps).
#
#burntime: Integer indicating the burn-in time for the Markov Chain.
#         Each replication is iterated burntime times before taking
#         draws (with these initial iterations being discarded); hence,
#         one should realize that each increment to burntime increases
#         execution time by a quantity proportional to reps.
#
#  quiet: Boolean indicating whether MCMC diagnostics should be
#         displayed.
#
# anames: A vector of names for the actors (vertices) in the graph.
#
# onames: A vector of names for the observers (possibly the actors
#         themselves) whose reports are contained in the input data.
#
#compute.sqrtrhat: A boolean indicating whether or not Gelman et al.'s
#         potential scale reduction measure (an MCMC convergence
#         diagnostic) should be computed (pooled and actor models
#         only).
#
#Return value:
#  An object of class bbnam.actor.
#
bbnam.mix<-
function (dat, nprior = NULL, emprior = c(1, 11), epprior = c(1, 
    11), diag = FALSE, mode = "digraph", reps = 5, draws = 1500, 
    burntime = 500, quiet = TRUE, anames = NULL, onames = NULL, 
    compute.sqrtrhat = TRUE) 
{
    require(sna)
    dat <- as.sociomatrix.sna(dat, simplify = TRUE)
    if (is.list(dat)) 
        stop("All bbnam input graphs must be of the same order.")
    if (length(dim(dat)) == 2) 
        dat <- array(dat, dim = c(1, NROW(dat), NCOL(dat)))
    m <- dim(dat)[1]
    n <- dim(dat)[2]
    d <- dat
    emax<-n*(n-1)/(1+(mode=="graph"))+n*diag
    slen <- burntime + floor(draws/reps)
    out <- list()
    if(is.null(nprior)){       #If left unspecified, use Jeffreys prior
      if(mode=="digraph")
        nhprior<-rep(0.5,3)
      else
        nhprior<-c(0.5,0.5)
    }else{
      nhprior<-nprior
    }
    if ((!is.matrix(emprior)) || (NROW(emprior) != n) || (NCOL(emprior) != 
        2)) {
        if (length(emprior) == 2) 
            emprior <- sapply(emprior, rep, n)
        else emprior <- matrix(emprior, n, 2)
    }
    if ((!is.matrix(epprior)) || (NROW(epprior) != n) || (NCOL(epprior) != 
        2)) {
        if (length(epprior) == 2) 
            epprior <- sapply(epprior, rep, n)
        else epprior <- matrix(epprior, n, 2)
    }
    if (is.null(anames)) 
        anames <- paste("a", 1:n, sep = "")
    if (is.null(onames)) 
        onames <- paste("o", 1:m, sep = "")
    if (mode == "graph") 
        d <- upper.tri.remove(d)
    if (!diag) 
        d <- diag.remove(d)
    if (!quiet) 
        cat("Creating temporary variables and drawing initial conditions....\n")
    a <- array(dim = c(reps, slen, n, n))
    em <- array(dim = c(reps, slen, m))
    ep <- array(dim = c(reps, slen, m))
    for (k in 1:reps) {
        if(length(nhprior)==2)
          temp<-nhprior[1]/(nhprior[1]+nhprior[2])
        else
          temp<-(2*nhprior[1]+nhprior[2])/(2*sum(nhprior))
        a[k, 1, , ] <- rgraph(n, 1, tp=temp, diag = diag, mode = mode)
        em[k, 1, ] <- runif(m, 0, 0.5)
        ep[k, 1, ] <- runif(m, 0, 0.5)
    }
    for (i in 1:reps) {
        if(mode=="digraph"){
          ecnt<-sum(a[i,1,,],na.rm=TRUE)
          dcnt<-dyad.census(a[i,1,,])
        }else
          ecnt<-sum(upper.tri(a[i,1,,],diag=diag))
        #checkme<-a[i,1,,]
        for (j in 2:slen) {
            if (!quiet) 
                cat("Repetition", i, ", draw", j, ":\n\tDrawing adjacency matrix\n")
            ep.a <- aperm(array(sapply(ep[i, j - 1, ], rep, n^2), 
                dim = c(n, n, m)), c(3, 2, 1))
            em.a <- aperm(array(sapply(em[i, j - 1, ], rep, n^2), 
                dim = c(n, n, m)), c(3, 2, 1))
            pygt <- apply(d * (1 - em.a) + (1 - d) * em.a, c(2, 
                3), prod, na.rm = TRUE)
            pygnt <- apply(d * ep.a + (1 - d) * (1 - ep.a), c(2, 
                3), prod, na.rm = TRUE)
            for(k in 1:n)
              for(h in 1:n)
                if((k<h)||((k==h)&&diag)||((k>h)&&(mode=="digraph"))){ #U. Tri.
                  #Take Gibbs draw for a[i,j,k,h] given rest of graph
                  llrat<-log(pygt[k,h])-log(pygnt[k,h]) #Log likelihood ratio
                  #Get complement stats (removing (k,h))
                  compec<-ecnt-a[i,j-1,k,h]  #Complement edge count
                  if(k<h)                    #Get latest corresponding edge
                    corredge<-a[i,j-1,h,k]
                  else
                    corredge<-a[i,j,h,k]
                  compdc<-dcnt               #Complement dyad count
                  compdc[1]<-compdc[1]-corredge*a[i,j-1,k,h]
                  compdc[2]<-compdc[2]-(corredge!=a[i,j-1,k,h])
                  compdc[3]<-compdc[3]-((corredge+a[i,j-1,k,h])==0)
                  #Get prior log edge probability ratio
                  if(length(nhprior)==2){  #Beta-Bernoulli graph
                    lepr<-log(compec+nhprior[1])-log(emax-1-compec+nhprior[2])
                  }else{                   #Dirichlet-categorical graph
                    if(corredge){
                      lepr<-log(compdc[1]+nhprior[1])- log((compdc[2]+nhprior[2])/2)
                    }else{
                      lepr<-log((compdc[2]+nhprior[2])/2)- log(compdc[3]+nhprior[3])
                    }
                  }
                  #Make the draw and deal with the consequences
                  a[i,j,k,h]<-(runif(1)<1/(1+exp(-llrat-lepr)))
                  #checkme[k,h]<-a[i,j,k,h]
                  if((k<h)&&(mode=="graph")){
                    a[i,j,h,k]<-a[i,j,k,h]
                  }
                  if(a[i,j,k,h]!=a[i,j-1,k,h]){ #If stuff changed, update stats
                    ecnt<-ecnt+2*a[i,j,k,h]-1     #Edge count
                    dcnt[1]<-dcnt[1]+corredge*(2*a[i,j,k,h]-1)
                    dcnt[2]<-dcnt[2]+(1-corredge)*(2*a[i,j,k,h]-1) + corredge*(1-2*a[i,j,k,h])
                    dcnt[3]<-dcnt[3]+(1-corredge)*(1-2*a[i,j,k,h])
                  }
              }
            if (!quiet) 
                cat("\tAggregating binomial counts\n")
            cem <- matrix(nrow = m, ncol = 2)
            cep <- matrix(nrow = m, ncol = 2)
            for (x in 1:m) {
                cem[x, 1] <- sum((1 - d[x, , ]) * a[i, j, , ], 
                  na.rm = TRUE)
                cem[x, 2] <- sum(d[x, , ] * a[i, j, , ], na.rm = TRUE)
                cep[x, 1] <- sum(d[x, , ] * (1 - a[i, j, , ]), 
                  na.rm = TRUE)
                cep[x, 2] <- sum((1 - d[x, , ]) * (1 - a[i, j, 
                  , ]), na.rm = TRUE)
            }
            if (!quiet) 
                cat("\tDrawing error parameters\n")
            em[i, j, ] <- rbeta(m, emprior[, 1] + cem[, 1], emprior[, 
                2] + cem[, 2])
            ep[i, j, ] <- rbeta(m, epprior[, 1] + cep[, 1], epprior[, 
                2] + cep[, 2])
        }
    }
    if (!quiet) 
        cat("Finished drawing from Markov chain.  Now computing potential scale reduction statistics.\n")
    if (compute.sqrtrhat) {
        out$sqrtrhat <- vector()
        for (i in 1:n) for (j in 1:n) out$sqrtrhat <- c(out$sqrtrhat, 
            potscalered.mcmc(aperm(a, c(2, 1, 3, 4))[, , i, j]))
        for (i in 1:m) out$sqrtrhat <- c(out$sqrtrhat, potscalered.mcmc(aperm(em, 
            c(2, 1, 3))[, , i]), potscalered.mcmc(aperm(ep, c(2, 
            1, 3))[, , i]))
        if (!quiet) 
            cat("\tMax potential scale reduction (Gelman et al.'s sqrt(Rhat)) for all scalar estimands:", 
                max(out$sqrtrhat[!is.nan(out$sqrtrhat)], na.rm = TRUE), 
                "\n")
    }
    if (!quiet) 
        cat("Preparing output.\n")
    out$net <- array(dim = c(reps * (slen - burntime), n, n))
    for (i in 1:reps) for (j in burntime:slen) {
        out$net[(i - 1) * (slen - burntime) + (j - burntime), 
            , ] <- a[i, j, , ]
    }
    if (!quiet) 
        cat("\tAggregated network variable draws\n")
    out$em <- em[1, (burntime + 1):slen, ]
    out$ep <- ep[1, (burntime + 1):slen, ]
    if (reps >= 2) 
        for (i in 2:reps) {
            out$em <- rbind(out$em, em[i, (burntime + 1):slen, 
                ])
            out$ep <- rbind(out$ep, ep[i, (burntime + 1):slen, 
                ])
        }
    if (!quiet) 
        cat("\tAggregated error parameters\n")
    out$anames <- anames
    out$onames <- onames
    out$nactors <- n
    out$nobservers <- m
    out$reps <- reps
    out$draws <- dim(out$em)[1]
    out$burntime <- burntime
    out$model <- "actor"
    class(out) <- c("bbnam.actor", "bbnam")
    out
}

