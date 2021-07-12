# The script for CSS data processing

# Read packages
library(sna)

# Set a working directory
setwd("~/GitHub/imaginary-structures/R")

# Load data
# Krackhardt Office Data? Need to doublecheck
load('~/GitHub/imaginary-structures/data/krackhardt_css.RData')


# Krackhardt Office Data --------------------------------------------------


## BACKGROUND 
# David Krackhardt collected cognitive social structure data from 21 management 
# personnel in a high-tech, machine manufacturing firm to assess the effects of 
# a recent management intervention program. The relation queried was 
# "Who does X go to for advice and help with work?" (friendship_net) and 
# "Who is a friend of X?" (advice_net). Each person indicated not only his or 
# her own advice and friendship relationships, but also the relations he or 
# she perceived among all other managers, generating a full 21 by 21 matrix of 
# adjacency ratings from each person in the group.


## Row aggregated method
# Create a single True network from the friendship responses
# Using a row aggregated method
fr_row <- consensus(friendship_nets, 
                    mode="digraph", 
                    diag=FALSE, 
                    method="OR.row")
# Plot it as a network graph
gplot(fr_row, 
      displaylabels=TRUE,
      boxed.lab=FALSE)


## Baysian network inference
# Let's start by defining some priors for the Bayesian network inference
# model. We'll use an uninformative network prior, together with weakly
# informative (but diffuse and symmetric) priors on the error rates.  Read
# the man page ("?bbnam") to get more information about how the routine works.
np<-matrix(0.5,21,21)  # 21 x 21 matrix of Bernoulli parameters (since n=21)
emp<-sapply(c(3,11),rep,21)  # Beta(3,11) priors for false negatives
epp<-sapply(c(3,11),rep,21)  # Beta(3,11) priors for false positives
hist(rbeta(100000,3,11))  # This gives you a sense of what the priors look like!

# Now, let's take some posterior draws for the friendship network, using 
# various models (warning: slow)
fr.post.fixed<-bbnam.fixed(friendship_nets,nprior=np,em=3/(3+11),ep=3/(3+11))
fr.post.pooled<-bbnam.pooled(friendship_nets,nprior=np,em=emp[1,],ep=epp[1,])
fr.post.actor<-bbnam.actor(friendship_nets,nprior=np,em=emp,ep=epp)

# Network plots
gplot(apply(fr.post.fixed$net,c(2,3),median),
      displaylabels=TRUE,boxed.lab=FALSE)
gplot(apply(fr.post.pooled$net,c(2,3),median),
      displaylabels=TRUE,boxed.lab=FALSE)
gplot(apply(fr.post.actor$net,c(2,3),median),
      displaylabels=TRUE,boxed.lab=FALSE)


# Examine the results - note the difference that heterogeneity makes!
summary(fr.post.fixed)
summary(fr.post.pooled)
summary(fr.post.actor)
plot(fr.post.fixed)
plot(fr.post.pooled)
plot(fr.post.actor)