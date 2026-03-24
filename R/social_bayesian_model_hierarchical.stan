data {
  int<lower=1> N;            // Number of data points (countries)
  int<lower=1> K;            // Number of explanatory variables
  int<lower=1> J;            // Number of realms
  matrix[N, K] X;            // Design matrix (explanatory variables)
  vector[N] y;               // Response vector (standardized)
  int<lower=1, upper=J> province[N]; // Realm index for each country
}

parameters {
  real beta_0;               // Global intercept
  real<lower=0> sigma_beta_0;  // SD of realm-specific intercepts
  vector[J] beta_0i;         // Realm-specific intercepts
  vector[K] beta;            // Slopes
  real<lower=0> sigma;       // Residual standard deviation
}

model {
  // Priors
  beta_0       ~ normal(0, 1);  // Global intercept prior
  sigma_beta_0 ~ normal(0, 1);  // Standard deviation for realm intercepts
  beta_0i      ~ normal(beta_0, sigma_beta_0);  // Realm-specific intercepts centered around beta_0
  beta         ~ normal(0, 1);  // Slopes prior
  sigma        ~ exponential(1);  // Residual error prior

  // Likelihood
  for (n in 1:N) {
    y[n] ~ normal(beta_0i[province[n]] + X[n] * beta, sigma);
  }
}

generated quantities {
  vector[N] y_pred;           // Predictions
  vector[N] log_lik;          // Log likelihood

  for (n in 1:N) {
    real mu_n = beta_0i[province[n]] + X[n] * beta;
    y_pred[n] = normal_rng(mu_n, sigma);
    log_lik[n] = normal_lpdf(y[n] | mu_n, sigma);
  }
}
