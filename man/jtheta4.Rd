% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/jtheta.R
\name{jtheta4}
\alias{jtheta4}
\alias{ljtheta4}
\title{Jacobi theta function four}
\usage{
jtheta4(z, tau = NULL, q = NULL)

ljtheta4(z, tau = NULL, q = NULL)
}
\arguments{
\item{z}{complex number, vector, or matrix}

\item{tau}{lattice parameter, a complex number with strictly positive 
imaginary part; the two complex numbers \code{tau} and \code{q} are 
related by \code{q = exp(1i*pi*tau)}, and only one of them must be 
supplied}

\item{q}{the nome, a complex number whose modulus is strictly less than one, 
and which is not zero nor a negative real number}
}
\value{
A complex number, vector or matrix; \code{jtheta4} evaluates the 
  fourth Jacobi theta function and \code{ljtheta4} evaluates its logarithm.
}
\description{
Evaluates the fourth Jacobi theta function.
}
\examples{
jtheta4(1 + 1i, q = exp(-pi/2))
}
