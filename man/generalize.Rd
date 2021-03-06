% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generalize.R
\name{generalize}
\alias{generalize}
\title{Generalize experimental results}
\usage{
generalize(
  sources,
  target,
  monotonic = FALSE,
  n.iter = 10000,
  n.adapt = 1000,
  n.burnin = 10000,
  n.chains = 4
)
}
\arguments{
\item{sources}{Either a \code{\link{data.frame}} with one source population, or a \code{\link{list}} with two data.frames with two source populations. The data.frame must have a specific structure: it must have only one row, and at least four columns, including \code{N0}, \code{n0}, \code{N1} and \code{n1}. For an example of the format, see the example data in \code{\link{Aceh}}.}

\item{target}{A \code{\link{data.frame}} with one target population. The data.frame must have only one row, and at least two columns, \code{N0} and \code{n0}.}

\item{monotonic}{Is monotonicity assumed? Default is \code{FALSE}.}

\item{n.iter}{Number of iterations to monitor passed to \code{\link{coda.samples}}.}

\item{n.adapt}{Number of iterations for adaptation passed to \code{\link{jags.model}}.}

\item{n.burnin}{Number of iterations for the burn-in phase, passed to \code{\link{update}}.}

\item{n.chains}{Number of parallel chains for the model passed to \code{\link{jags.model}}.}
}
\value{
An object of class \code{generalize} containing:
\describe{
\item{data}{A \code{\link{data.frame}} containing the data used for the analysis.}
\item{model.code}{A \code{\link{character}} vector containing the \code{\link{rjags}} code used for the analysis.}
\item{model}{An object of class \code{jags} returned from the function \code{\link{jags.model}} which can be used to generate dependent samples from the posterior distribution of the parameters.}
\item{samples}{An object of class \code{mcmc.list} returned from the function \code{\link{coda.samples}}. It contains the posterior samples of the parameters.}

}
}
\description{
This function implements the methods discussed in Cinelli and Pearl (2020+).
The function generalizes experimental results from one or more source populations to a target population by leveraging
the invariance of probabilities of causation (Pearl, 1999).
}
\details{
The function works mainly as a convenience wrapper to \code{\link{rjags}} code, and uses the priors described in Cinelli and Pearl (2020+) for an illustration of the method.
Should users prefer to personalize the analyses with their own priors, they can extract the model code and modify it directly in \code{\link{rjags}}.
}
\examples{
# loads package
library(generalizing)

# loads data
data("Aceh")
data("West.Java")
data("Sarlahi")

#### ACEH to WEST JAVA

# flat prior
Aceh_to_WJ   <- generalize(sources = Aceh, target = West.Java, n.iter = 1e5)

# monotonic prior
Aceh_to_WJ_m <- generalize(sources = Aceh, target = West.Java,
                           monotonic = TRUE, n.iter = 1e5)


# posterior samples histograms
par(mfrow = c(1,2))
mark <- West.Java$n1/West.Java$N1
par(mfrow = c(1,2))

## hist flat prior
hist(Aceh_to_WJ, main = "Flat prior")
abline(v = mark, col = "red", lty = 2, lwd = 2)

## hist monotonic prior
hist(Aceh_to_WJ_m, main = "Monotonic prior")
abline(v = mark, col = "red", lty = 2, lwd = 2)

#### ACEH + WEST JAVA to SARLAHI
AcehWJ_to_Sarlahi   <- generalize(sources = list(Aceh, West.Java),
                                  target = Sarlahi,
                                  n.iter = 1e5)
# posterior samples histograms
par(mfrow = c(1, 3))
mark <- Sarlahi$n1/Sarlahi$N1

## hist prob of sufficient for saving
hist(AcehWJ_to_Sarlahi, var = "PS01")

## hist prob of sufficient for harming
hist(AcehWJ_to_Sarlahi, var = "PS10")

## hist of P(Y1 = 1)
hist(AcehWJ_to_Sarlahi, var = "P11s")
abline(v = mark, col = "red", lty = 2, lwd = 2)
}
\references{
C. Cinelli and J. Pearl. Generalizing Experimental Results by Leveraging Knowledge of Mechanisms. European Journal of Epidemiology.
Forthcoming (2020+)


J. Pearl. Probabilities of causation: three counterfactual interpretations and
their identification. Synthese, 121(1-2):93–149, 1999.
}
