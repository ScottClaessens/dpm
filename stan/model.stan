// Generated with coevolve 0.0.0.9011
functions {
  // Charles Driver's optimized way of solving for the asymptotic Q matrix
  matrix ksolve (matrix A, matrix Q) {
    int d = rows(A);
    int d2 = (d * d - d) %/% 2;
    matrix [d + d2, d + d2] O;
    vector [d + d2] triQ;
    matrix[d,d] AQ;
    int z = 0;         // z is row of output
    for (j in 1:d) {   // for column reference of solution vector
      for (i in 1:j) { // and row reference...
        if (j >= i) {  // if i and j denote a covariance parameter (from upper tri)
          int y = 0;   // start new output row
          z += 1;      // shift current output row down
          for (ci in 1:d) {   // for columns and
            for (ri in 1:d) { // rows of solution
              if (ci >= ri) { // when in upper tri (inc diag)
                y += 1;       // move to next column of output
                if (i == j) { // if output row is for a diagonal element
                  if (ri == i) O[z, y] = 2 * A[ri, ci];
                  if (ci == i) O[z, y] = 2 * A[ci, ri];
                }
                if (i != j) { // if output row is not for a diagonal element
                  //if column of output matches row of output, sum both A diags
                  if (y == z) O[z, y] = A[ri, ri] + A[ci, ci];
                  if (y != z) { // otherwise...
                    // if solution element we refer to is related to output row...
                    if (ci == ri) { // if solution element is a variance
                      // if variance of solution corresponds to row of our output
                      if (ci == i) O[z, y] = A[j, ci];
                      // if variance of solution corresponds to col of our output
                      if (ci == j) O[z, y] = A[i, ci];
                    }
                    //if solution element is a related covariance
                    if (ci != ri && (ri == i || ri == j || ci == i || ci == j )) {
                      // for row 1,2 / 2,1 of output, if solution row ri 1 (match)
                      // and column ci 3, we need A[2,3]
                      if (ri == i) O[z, y] = A[j, ci];
                      if (ri == j) O[z, y] = A[i, ci];
                      if (ci == i) O[z, y] = A[j, ri];
                      if (ci == j) O[z, y] = A[i, ri];
                    }
                  }
                }
                if (is_nan(O[z, y])) O[z, y] = 0;
              }
            }
          }
        }
      }
    }
    z = 0; // get upper tri of Q
    for (j in 1:d) {
      for (i in 1:j) {
        z += 1;
        triQ[z] = Q[i, j];
      }
    }
    triQ = -O \ triQ; // get upper tri of asymQ
    z = 0; // put upper tri of asymQ into matrix
    for (j in 1:d) {
      for (i in 1:j) {
        z += 1;
        AQ[i, j] = triQ[z];
        if (i != j) AQ[j, i] = triQ[z];
      }
    }
    return AQ;
  }
  
  // return number of matches of y in vector x
  int num_matches(vector x, real y) {
    int n = 0;
    for (i in 1:rows(x))
      if (x[i] == y)
        n += 1;
    return n;
  }
  
  // return indices in vector x where x == y
  array[] int which_equal(vector x, real y) {
    array [num_matches(x, y)] int match_positions;
    int pos = 1;
    for (i in 1:rows(x)) {
      if (x[i] == y) {
        match_positions[pos] = i;
        pos += 1;
      }
    }
    return match_positions;
  }
}
data{
  int<lower=1> N_tips; // number of tips
  int<lower=1> N_obs; // number of observations
  int<lower=2> J; // number of response traits
  int<lower=1> N_seg; // total number of segments in the tree
  array[N_seg] int<lower=1> node_seq; // index of tree nodes
  array[N_seg] int<lower=0> parent; // index of the parent node of each descendent
  array[N_seg] real ts; // time since parent
  array[N_seg] int<lower=0,upper=1> tip; // indicator of whether a given segment ends in a tip
  array[J,J] int<lower=0,upper=1> effects_mat; // which effects should be estimated?
  int<lower=2> num_effects; // number of effects being estimated
  matrix[N_obs,J] y; // observed data
  matrix[N_obs,J] miss; // are data points missing?
  array[N_obs] int<lower=1> tip_id; // index between 1 and N_tips that gives the group id
  int<lower=0,upper=1> prior_only; // should the likelihood be ignored?
}
transformed data{
  vector[to_int(N_obs - sum(col(miss, 1)))] obs1; // observed data for variable 1
  vector[to_int(N_obs - sum(col(miss, 2)))] obs2; // observed data for variable 2
  obs1 = col(y, 1)[which_equal(col(miss, 1), 0)];
  obs2 = col(y, 2)[which_equal(col(miss, 2), 0)];
}
parameters{
  vector<upper=0>[J] A_diag; // autoregressive terms of A
  vector[num_effects - J] A_offdiag; // cross-lagged terms of A
  vector<lower=0>[J] Q_diag; // self-drift terms
  vector[J] b; // SDE intercepts
  vector[J] eta_anc; // ancestral states
  array[N_seg - 1] vector[J] z_drift; // stochastic drift, unscaled and uncorrelated
}
transformed parameters{
  array[N_seg] vector[J] eta;
  matrix[J,J] A = diag_matrix(A_diag); // selection matrix
  matrix[J,J] Q = diag_matrix(Q_diag); // drift matrix
  matrix[J,J] Q_inf; // asymptotic covariance matrix
  array[N_seg] vector[J] drift_tips; // terminal drift parameters
  array[N_seg] vector[J] sigma_tips; // terminal drift parameters
  // fill off diagonal of A matrix
  {
    int ticker = 1;
    for (i in 1:J) {
      for (j in 1:J) {
        if (i != j) {
          if (effects_mat[i,j] == 1) {
            A[i,j] = A_offdiag[ticker];
            ticker += 1;
          } else if (effects_mat[i,j] == 0) {
            A[i,j] = 0;
          }
        }
      }
    }
  }
  // calculate asymptotic covariance
  Q_inf = ksolve(A, Q);
  // setting ancestral states and placeholders
  for (j in 1:J) {
    eta[node_seq[1]][j] = eta_anc[j];
    drift_tips[node_seq[1]][j] = -99;
    sigma_tips[node_seq[1]][j] = -99;
  }
  for (i in 2:N_seg) {
    matrix[J,J] A_delta; // amount of deterministic change (selection)
    matrix[J,J] VCV; // variance-covariance matrix of stochastic change (drift)
    vector[J] drift_seg; // accumulated drift over the segment
    A_delta = matrix_exp(A * ts[i]);
    VCV = Q_inf - quad_form_sym(Q_inf, A_delta');
    drift_seg = cholesky_decompose(VCV) * z_drift[i-1];
    // if not a tip, add the drift parameter
    if (tip[i] == 0) {
      eta[node_seq[i]] = to_vector(
        A_delta * eta[parent[i]] + ((A \ add_diag(A_delta, -1)) * b) + drift_seg
      );
      drift_tips[node_seq[i]] = rep_vector(-99, J);
      sigma_tips[node_seq[i]] = rep_vector(-99, J);
    }
    // if is a tip, omit, we'll deal with it in the model block;
    else {
      eta[node_seq[i]] = to_vector(
        A_delta * eta[parent[i]] + ((A \ add_diag(A_delta, -1)) * b)
      );
      drift_tips[node_seq[i]] = drift_seg;
      sigma_tips[node_seq[i]] = diagonal(Q);
    }
  }
}
model{
  b ~ std_normal();
  eta_anc ~ std_normal();
  for (i in 1:(N_seg - 1)) z_drift[i] ~ std_normal();
  A_offdiag ~ normal(0, 2);
  A_diag ~ std_normal();
  Q_diag ~ std_normal();
  if (!prior_only) {
    for (i in 1:N_obs) {
      if (miss[i,1] == 0) y[i,1] ~ normal(eta[tip_id[i]][1], sigma_tips[tip_id[i]][1]);
      if (miss[i,2] == 0) y[i,2] ~ normal(eta[tip_id[i]][2], sigma_tips[tip_id[i]][2]);
    }
  }
}
generated quantities{
  vector[N_obs*J] log_lik; // log-likelihood
  matrix[N_obs,J] yrep; // predictive checks
  {
    matrix[N_obs,J] log_lik_temp = rep_matrix(0, N_obs, J);
    matrix[N_obs,J] yrep_temp;
    for (i in 1:N_obs) {
      if (miss[i,1] == 0) log_lik_temp[i,1] = normal_lpdf(y[i,1] | eta[tip_id[i]][1], sigma_tips[tip_id[i]][1]);
      yrep_temp[i,1] = normal_rng(eta[tip_id[i]][1], sigma_tips[tip_id[i]][1]);
      if (miss[i,2] == 0) log_lik_temp[i,2] = normal_lpdf(y[i,2] | eta[tip_id[i]][2], sigma_tips[tip_id[i]][2]);
      yrep_temp[i,2] = normal_rng(eta[tip_id[i]][2], sigma_tips[tip_id[i]][2]);
    }
  yrep = yrep_temp;
  log_lik = to_vector(log_lik_temp);
  }
}
