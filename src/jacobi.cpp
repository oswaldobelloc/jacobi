#include "jacobi_types.h"

// [[Rcpp::export]]
double modulo(double a, double p) {
  double i = a > 0 ? std::floor(a/p) : std::ceil(a/p);
  return a - i * p;
}

const cplx _i_(0.0, 1.0);

cplx calctheta3(cplx z, cplx tau) {
  cplx out(1.0, 0.0);
  unsigned n = 0;
  bool iterate = true;
  while(iterate) {
    n++;
    double nn = n;
    cplx qweight = std::exp(nn * _i_ * M_PI * (nn * tau + 2.0 * z)) +
      std::exp(nn * _i_ * M_PI * (nn * tau - 2.0 * z));
    out += qweight;
    if(std::abs(out) == 0) {
      Rcpp::stop("log(0)");
    } else if(n >= 3 && (out + qweight) == out) {
      iterate = false;
    }
  }
  return std::log(out);
}

cplx argtheta3(cplx z, cplx tau, unsigned pass_in) {
  unsigned passes = pass_in + 1;
  if(passes > 500) {
    Rcpp::stop("passes > 500 (argtheta3)");
  }
  double z_img = z.imag();
  double h = tau.imag() / 2.0;
  cplx zuse(modulo(z.real(), 1.0), z_img);
  cplx out;
  if(z_img < -h) {
    out = argtheta3(-zuse, tau, passes);
  } else if(z_img >= h) {
    cplx zmin = zuse - tau;
    out = -2.0 * M_PI * _i_ * zmin + argtheta3(zmin, tau, passes) -
      _i_ * M_PI * tau;
  } else {
    out = calctheta3(zuse, tau);
  }
  return out;
}

cplx dologtheta4(cplx z, cplx tau, unsigned pass_in) {
  return dologtheta3(z + 0.5, tau, pass_in + 1);
}

cplx dologtheta3(cplx z, cplx tau, unsigned pass_in) {
  unsigned passes = pass_in + 1;
  if(passes > 500) {
    Rcpp::stop("passes > 500 (dologtheta3)");
  }
  cplx tau2;
  double rl = tau.real();
  if(rl >= 0) {
    tau2 = modulo(rl + 1.0, 2) - 1.0 + _i_ * tau.imag();
  } else {
    tau2 = modulo(rl - 1.0, 2) + 1.0 + _i_ * tau.imag();
  }
  rl = tau2.real();
  cplx out;
  if(rl > 0.6) {
    out = dologtheta4(z, tau2 - 1.0, passes);
  } else if(rl <= -0.6) {
    out = dologtheta4(z, tau2 + 1.0, passes);
  } else if(std::abs(tau2) < 0.98 && tau2.imag() < 0.98) {
    cplx tauprime = -1.0 / tau2;
    out = _i_ * M_PI * tauprime * z*z +
      dologtheta3(-z * tauprime, tauprime, passes) -
      std::log(std::sqrt(-_i_ * tau2));
  } else {
    out = argtheta3(z, tau2, passes);
  }
  return out;
}

cplx M(cplx z, cplx tau) {
  return _i_ * M_PI * (z +  tau / 4.0);
}

// [[Rcpp::export]]
cplx ljtheta2_cpp(cplx z, cplx tau) {
  return M(z, tau) + dologtheta3(z + 0.5*tau, tau, 0);
}

// [[Rcpp::export]]
cplx jtheta2_cpp(cplx z, cplx tau) {
  return std::exp(ljtheta2_cpp(z, tau));
}

// [[Rcpp::export]]
cplx ljtheta1_cpp(cplx z, cplx tau) {
  return ljtheta2_cpp(z - 0.5, tau);
}

// [[Rcpp::export]]
cplx jtheta1_cpp(cplx z, cplx tau) {
  return std::exp(ljtheta1_cpp(z, tau));
}

// [[Rcpp::export]]
cplx ljtheta3_cpp(cplx z, cplx tau) {
  return dologtheta3(z, tau, 0);
}

// [[Rcpp::export]]
cplx jtheta3_cpp(cplx z, cplx tau) {
  return std::exp(ljtheta3_cpp(z, tau));
}

// [[Rcpp::export]]
cplx ljtheta4_cpp(cplx z, cplx tau) {
  return dologtheta4(z, tau, 0);
}

// [[Rcpp::export]]
cplx jtheta4_cpp(cplx z, cplx tau) {
  return std::exp(ljtheta4_cpp(z, tau));
}
