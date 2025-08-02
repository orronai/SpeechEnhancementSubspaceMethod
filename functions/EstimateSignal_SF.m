function [estimated_sig_E, estimated_sig_R_cov_E, estimated_sig_sf, ...
    SIR_E, SIR_R_cov_E, SIR_sf, ...
    SNR_E, SNR_R_cov_E, SNR_sf] = ...
    EstimateSignal_SF(...
    stft_tensor, stft_tensor_clean, stft_tensor_inter, stft_tensor_noise, num_mics, fs, ...
    win_length, overlap_stft_length, num_frames, frames_cov_est_with_overlap, delta_corr)
% Compute the estimated signal for each one of the methods, using the
% MVDR coeff. approach
    num_bins = size(stft_tensor, 2);
    num_time_frames = size(stft_tensor, 3);

    estimated_stft_signal_E = zeros(num_bins, num_time_frames);
    estimated_stft_interferences_E = zeros(num_bins, num_time_frames);
    estimated_stft_noise_E = zeros(num_bins, num_time_frames);
    estimated_stft_signal_R_cov_E = zeros(num_bins, num_time_frames);
    estimated_stft_interferences_R_cov_E = zeros(num_bins, num_time_frames);
    estimated_stft_noise_R_cov_E = zeros(num_bins, num_time_frames);
    estimated_stft_signal_sf = zeros(num_bins, num_time_frames);
    estimated_stft_interferences_sf = zeros(num_bins, num_time_frames);
    estimated_stft_noise_sf = zeros(num_bins, num_time_frames);
    for bin_index = 1 : num_bins
        stft_mat = squeeze(stft_tensor(:, bin_index, :));
        GammaTensor = STFT_GammaTensor(stft_mat, num_mics, num_frames, frames_cov_est_with_overlap);
        GammaR = RiemannianMean(GammaTensor);
        [eigvec_mat_R, ~] = SortedEVD(GammaR);
        atf_trans_est_R = eigvec_mat_R(:, 1);
        atf_trans_est_R = atf_trans_est_R / atf_trans_est_R(1);
        atf_trans_est_R_a = eigvec_mat_R(:, 1);

        phi_y = mean(GammaTensor, 3);
        [eigvec_mat_E, ~] = SortedEVD(phi_y);

        atf_trans_est_E = eigvec_mat_E(:, 1);
        atf_trans_est_E = atf_trans_est_E / atf_trans_est_E(1);
        phi_y_inv = pinv(phi_y);
        [h_mvdr_E, ~] = MvdrCoefficients(atf_trans_est_E, phi_y_inv, stft_mat);

        [h_mvdr_R_cov_E, ~] = MvdrCoefficients(atf_trans_est_R, phi_y_inv, stft_mat);

        correlations = eigvec_mat_E' * atf_trans_est_R_a;
        correlations = correlations .* (abs(correlations).^2 > delta_corr);
        atf_trans_est_sf = eigvec_mat_E * correlations;
        atf_trans_est_sf = atf_trans_est_sf / atf_trans_est_sf(1);
        [h_mvdr_sf, ~] = MvdrCoefficients(atf_trans_est_sf, phi_y_inv, stft_mat);

        stft_mat_bin_signal = squeeze(stft_tensor_clean(:, bin_index, :));
        stft_mat_bin_interferences = squeeze(stft_tensor_inter(:, bin_index, :));
        stft_mat_bin_noise = squeeze(stft_tensor_noise(:, bin_index, :));

        estimated_stft_signal_E(bin_index, :) = h_mvdr_E' * stft_mat_bin_signal;
        estimated_stft_interferences_E(bin_index, :) = h_mvdr_E' * stft_mat_bin_interferences;
        estimated_stft_noise_E(bin_index, :) = h_mvdr_E' * stft_mat_bin_noise;
        estimated_stft_signal_R_cov_E(bin_index, :) = h_mvdr_R_cov_E' * stft_mat_bin_signal;
        estimated_stft_interferences_R_cov_E(bin_index, :) = h_mvdr_R_cov_E' * stft_mat_bin_interferences;
        estimated_stft_noise_R_cov_E(bin_index, :) = h_mvdr_R_cov_E' * stft_mat_bin_noise;
        estimated_stft_signal_sf(bin_index, :) = h_mvdr_sf' * stft_mat_bin_signal;
        estimated_stft_interferences_sf(bin_index, :) = h_mvdr_sf' * stft_mat_bin_interferences;
        estimated_stft_noise_sf(bin_index, :) = h_mvdr_sf' * stft_mat_bin_noise;
    end
    estimated_signal_E = istft(estimated_stft_signal_E, fs, 'Window', hanning(win_length), ...
        'OverlapLength', overlap_stft_length).';
    estimated_interferences_E = istft(estimated_stft_interferences_E, fs, 'Window', hanning(win_length), ...
        'OverlapLength', overlap_stft_length).';
    estimated_noise_E = istft(estimated_stft_noise_E, fs, 'Window', hanning(win_length), ...
        'OverlapLength', overlap_stft_length).';
    estimated_signal_R_cov_E = istft(estimated_stft_signal_R_cov_E, fs, 'Window', hanning(win_length), ...
        'OverlapLength', overlap_stft_length).';
    estimated_interferences_R_cov_E = istft(estimated_stft_interferences_R_cov_E, fs, ...
        'Window', hanning(win_length), 'OverlapLength', overlap_stft_length).';
    estimated_noise_R_cov_E = istft(estimated_stft_noise_R_cov_E, fs, ...
        'Window', hanning(win_length), 'OverlapLength', overlap_stft_length).';
    estimated_signal_sf = istft(estimated_stft_signal_sf, fs, 'Window', hanning(win_length), ...
        'OverlapLength', overlap_stft_length).';
    estimated_interferences_sf = istft(estimated_stft_interferences_sf, fs, 'Window', hanning(win_length), ...
        'OverlapLength', overlap_stft_length).';
    estimated_noise_sf = istft(estimated_stft_noise_sf, fs, 'Window', hanning(win_length), ...
        'OverlapLength', overlap_stft_length).';

    estimated_signal_E = estimated_signal_E(win_length / 8 : end - win_length / 8);
    estimated_interferences_E = estimated_interferences_E(win_length / 8 : end - win_length / 8);
    estimated_noise_E = estimated_noise_E(win_length / 8 : end - win_length / 8);
    estimated_signal_R_cov_E = estimated_signal_R_cov_E(win_length / 8 : end - win_length / 8);
    estimated_interferences_R_cov_E = estimated_interferences_R_cov_E(win_length / 8 : end - win_length / 8);
    estimated_noise_R_cov_E = estimated_noise_R_cov_E(win_length / 8 : end - win_length / 8);
    estimated_signal_sf = estimated_signal_sf(win_length / 8 : end - win_length / 8);
    estimated_interferences_sf = estimated_interferences_sf(win_length / 8 : end - win_length / 8);
    estimated_noise_sf = estimated_noise_sf(win_length / 8 : end - win_length / 8);

    SIR_E = 20 * log10(norm(estimated_signal_E) / norm(estimated_interferences_E));
    SIR_R_cov_E = 20 * log10(norm(estimated_signal_R_cov_E) / norm(estimated_interferences_R_cov_E));
    SIR_sf = 20 * log10(norm(estimated_signal_sf) / norm(estimated_interferences_sf));

    SNR_E = 20 * log10(norm(estimated_signal_E) / norm(estimated_noise_E));
    SNR_R_cov_E = 20 * log10(norm(estimated_signal_R_cov_E) / norm(estimated_noise_R_cov_E));
    SNR_sf = 20 * log10(norm(estimated_signal_sf) / norm(estimated_noise_sf));

    estimated_sig_E = estimated_signal_E + estimated_interferences_E + estimated_noise_E;
    estimated_sig_R_cov_E = estimated_signal_R_cov_E + estimated_interferences_R_cov_E + estimated_noise_R_cov_E;
    estimated_sig_sf = estimated_signal_sf + estimated_interferences_sf + estimated_noise_sf;
end
