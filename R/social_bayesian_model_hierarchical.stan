data {
  int<lower=1> N;
  int<lower=1> K;
  int<lower=1> J;
  matrix[N, K] X;
  vector[N] y;                     // standardized response
  int<lower=1, upper=J> province[N];
}

parameters {
  real beta_0;                     // global intercept
  real<lower=0> sigma_beta_0;      // SD of province intercepts
  vector[J] z_beta_0;              // non-centered intercepts

  vector[K] beta;                  // slopes
  real<lower=0> sigma;             // residual SD
}

transformed parameters {
  vector[J] beta_0i;               // actual province intercepts
  beta_0i = beta_0 + sigma_beta_0 * z_beta_0;
}

model {
  // Priors for standardized y and X
  beta_0       ~ normal(0, 1); // y intercept
  sigma_beta_0 ~ normal(0, 1); // realm specific deviation
  z_beta_0     ~ normal(0, 1); // realm specific mean

  beta         ~ normal(0, 1);
  sigma        ~ exponential(1); // process error

  // Likelihood
  for (n in 1:N) {
    y[n] ~ normal(beta_0i[province[n]] + X[n] * beta, sigma);
  }
}

generated quantities {
  vector[N] y_pred;
  vector[N] log_lik;

  for (n in 1:N) {
    real mu_n = beta_0i[province[n]] + X[n] * beta;
    y_pred[n] = normal_rng(mu_n, sigma);
    log_lik[n] = normal_lpdf(y[n] | mu_n, sigma);
  }
}