function [MVDR_coeff, estimated_sig] = MvdrCoefficients(steering_vec, cov_inv, noise_sig)
% MVDR coeff. implementaion
    MVDR_coeff = cov_inv * steering_vec / (steering_vec' * cov_inv * steering_vec);
    estimated_sig = MVDR_coeff' * noise_sig;
end
