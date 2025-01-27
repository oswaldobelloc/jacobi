#' @title Weierstrass zeta function
#' @description Evaluation of the Weierstrass zeta function.
#'
#' @param z complex number
#' @param g the elliptic invariants, a vector of two complex numbers; they are 
#'   related to the half-periods (\code{omega}) and only one of \code{g} 
#'   and \code{omega} must be given
#' @param omega the half-periods, a vector of two complex numbers; they are 
#'   related to the elliptic invariants (\code{g}) and only one of \code{g} 
#'   and \code{omega} must be given
#' @param fix Boolean; if \code{TRUE} and if there is \code{NaN} or \code{Inf} 
#'   in the result, the function tries to get the correct result by applying 
#'   some transformations
#'
#' @return A complex number.
#' @export
#' 
#' @examples
#' # Mirror symmetry property:
#' z <- 1 + 1i
#' g <- c(1i, 1+2i)
#' zetaw(Conj(z), Conj(g))
#' Conj(zetaw(z, g))
zetaw <- function(z, g = NULL, omega = NULL, fix = FALSE){
  stopifnot(isComplex(z))
  if(is.null(g) && is.null(omega)){
    stop("You must supply either `g` or `omega`.")
  }
  if(!is.null(g) && !is.null(omega)){
    stop("You must supply either `g` or `omega`, not both.")
  }
  if(!is.null(g)){
    stopifnot(isComplexPair(g))
  }
  if(!is.null(omega)){
    stopifnot(isComplexPair(omega))
    g <- g_from_omega(omega[1L], omega[2L])
  }
  if(g[1L] == 0 && g[2L] == 0){
    return(1/z)
  }
  if(g[1L] == 3 && g[2L] == 1){
    return(z/2 + sqrt(3/2)/tan(sqrt(3/2)*z))
  }
  r <- e3e2e1(g)
  if(isReal(g)) r <- r[c(1L, 3L, 2L)]# unname(elliptic::e1e2e3(g))
  # g2 <- g[1L]
  # g3 <- g[2L]
  # r <- sort(polyroot(c(-g3, -g2, 0, 4)))
  r1 <- r[1L]
  r2 <- r[2L]
  r3 <- r[3L]
  a <- sqrt(r1 - r3)
  b <- sqrt(r1 - r2)
  c <- sqrt(r2 - r3)
  if(abs(a + b) < abs(a - b)) b <- -b
  if(abs(a + c) < abs(a - c)) c <- -c
  if(abs(c + 1i*b) < abs(c - 1i*b)){
    a <- sqrt(r3 - r1)
    b <- sqrt(r3 - r2)
    c <- sqrt(r2 - r1)
    w1 <- 1 / agm(1i*b, c) / 2
  }else{
    w1 <- 1 / agm(a, b) / 2
  }
  w3 <- 1i / agm(a, c) / 2
  # w1 <- 1
  # w3 <- 1i
  tau <- w3 / w1
  tau <- omega[2L]/omega[1L]
  w1 <- - omega[1L] / pi # NICKEL
  if(Im(tau) <= 0){
    stop("Invalid values of the parameters.")
  }
  q <- exp(1i * pi * tau)
  p <- 1 / w1 / 2
  eta1 <- p / 6 / w1 * jtheta1primeprimeprime0(tau) / jtheta1prime0(tau)
  out <- - eta1 * z + p * dljtheta1(p * z, tau, q)
  if(fix && (is.nan(out))){
    out <- zetaw(z-1, g = g, fix = FALSE) + 2*zetaw(1/2, g)
    if(is.nan(out)){
      out <- zetaw(z+1, g = g, fix = FALSE) - 2*zetaw(1/2, g)
    }
  }
  # attr(out, "info") <- c(tau = tau, eta1 = eta1, p = p, w1 = w1, w3 = w3)
  out
}
