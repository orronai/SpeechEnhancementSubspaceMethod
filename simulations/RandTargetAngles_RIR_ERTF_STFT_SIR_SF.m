function [error_E, error_R_cov_E, error_sf] = ...
    RandTargetAngles_RIR_ERTF_STFT_SIR_SF(...
    signal_target_list, inter_sig_list, sig_length, SNR_dB, N_I, ...
    target_gain, IndicatorBig, monte_carlo_num, delta, num_of_mics, first_mic_pos, trans_dist, ...
    inter_dist, target_height, inter_heights, SIR_dB_list, scenario, theta_diff, plot_scenario, ...
    angles_inter, room_dims, fs, c, win_length, overlap_stft_length, num_frames, ...
    frames_cov_est_with_overlap, beta, mtype, order, dim, orientation, hp_filter, delta_corr)
% Calculate the estimation error between the estimated signal in each one of
% the methods to the desired source, using EVD for RTF estimation with RIR,
% for different SIR values, for different signals in each monte carlo iteration,
% random desired source angles
    rng(137, 'twister');
    filter_samples = 2 * win_length;

    m_lin = (0 : num_of_mics - 1)';
    mics_pos_mat = first_mic_pos + [m_lin * delta, zeros(num_of_mics, 2)];
    mid_mic_pos = (mics_pos_mat(end, :) + mics_pos_mat(1, :)) / 2;

    fontSize = 20;
    error_E = zeros(length(SIR_dB_list), monte_carlo_num);
    error_R_cov_E = zeros(length(SIR_dB_list), monte_carlo_num);
    error_sf = zeros(length(SIR_dB_list), monte_carlo_num);
    dSIR_E = zeros(length(SIR_dB_list), monte_carlo_num);
    dSIR_R_cov_E = zeros(length(SIR_dB_list), monte_carlo_num);
    dSIR_sf = zeros(length(SIR_dB_list), monte_carlo_num);
    dSNR_E = zeros(length(SIR_dB_list), monte_carlo_num);
    dSNR_R_cov_E = zeros(length(SIR_dB_list), monte_carlo_num);
    dSNR_sf = zeros(length(SIR_dB_list), monte_carlo_num);

    [theta_right_target, theta_left_target, ~, ~, ~, ~] = DefineScenarios(scenario, theta_diff);

    inter_pos = zeros(N_I, 3);
    h_inter = zeros(N_I, num_of_mics, filter_samples);
    for i_i = 1 : N_I
        inter_pos(i_i, :) = mid_mic_pos .* [1 1 0] + ...
            [inter_dist * [cosd(angles_inter(i_i)) sind(angles_inter(i_i))] inter_heights(i_i)];
        [~, h_inter(i_i, :, :)] = evalc(['rir_generator(c, fs, mics_pos_mat, inter_pos(i_i, :), room_dims, beta, ', ...
            'filter_samples, mtype, order, dim, orientation, hp_filter)']);
    end

    for monte_carlo_index = 1 : monte_carlo_num
        rand_target_angle = (rand * theta_diff) + theta_right_target;
        rand_target_pos = mid_mic_pos .* [1 1 0] + ...
            [trans_dist * [cosd(rand_target_angle) sind(rand_target_angle)] target_height];

        [~, h_trans] = evalc(['rir_generator(c, fs, mics_pos_mat, rand_target_pos, room_dims, beta, ', ...
            'filter_samples, mtype, order, dim, orientation, hp_filter)']);

        added_noise = randn(num_of_mics, sig_length);

        signal_target_padded = [signal_target_list(monte_carlo_index, :) zeros(1, filter_samples)];
        for SIR_index = 1 : length(SIR_dB_list)
            inter_gain = target_gain / 10^(SIR_dB_list(SIR_index) / 20);
            inter_sig = squeeze(inter_sig_list(:, monte_carlo_index, :));
            for i_i = 1 : N_I
                inter_sig(i_i, :) = inter_gain * inter_sig(i_i, :) / norm(inter_sig(i_i, :));
            end
            inter_sig = inter_sig .* IndicatorBig;
            inter_sig_padded = zeros(N_I, sig_length + filter_samples);
            for i_i = 1 : N_I
                inter_sig_padded(i_i, :) = [inter_sig(i_i, :) zeros(1, filter_samples)];
            end

            mics_sig = zeros(num_of_mics, sig_length);
            mics_inter_sig = zeros(N_I, num_of_mics, sig_length);

            for mic_index = 1 : num_of_mics
                single_mic_sig = filter(h_trans(mic_index, :), 1, signal_target_padded);
                single_mic_sig = single_mic_sig(1 : sig_length);
                mics_sig(mic_index, :) = single_mic_sig;
    
                for i_i = 1 : N_I
                    single_mic_inter_sig = filter(squeeze(h_inter(i_i, mic_index, :)), 1, inter_sig_padded(i_i, :));
                    single_mic_inter_sig = single_mic_inter_sig(1 : sig_length);
                    mics_inter_sig(i_i, mic_index, :) = single_mic_inter_sig;
                end
            end

            noise_gain = zeros(1, num_of_mics);
            for mic_index = 1 : num_of_mics
                noise_gain(mic_index) = norm(mics_sig(mic_index, :)) / 10^(SNR_dB / 20);  % Epsilon
                added_noise(mic_index, :) = noise_gain(mic_index) * (added_noise(mic_index, :) / ...
                    norm(added_noise(mic_index, :)));
            end
            mics_inter_sig_all = squeeze(sum(mics_inter_sig, 1));
            noise_mics_sig = mics_sig + added_noise + mics_inter_sig_all;
            stft_tensor = StftTensor(noise_mics_sig, num_of_mics, fs, win_length, overlap_stft_length);

            SIR_dB_eff = 20 * log10(norm(mics_sig(1, :)) / norm(mics_inter_sig_all(1, :)));
            stft_tensor_signal = StftTensor(mics_sig, num_of_mics, fs, win_length, overlap_stft_length);
            stft_tensor_interferences = StftTensor(mics_inter_sig_all, num_of_mics, fs, ...
                win_length, overlap_stft_length);
            stft_tensor_noise = StftTensor(added_noise, num_of_mics, fs, ...
                win_length, overlap_stft_length);

            first_mics_sig_partial = mics_sig(1, win_length / 8 : end - win_length / 8);
            noise_mics_sig_partial = noise_mics_sig(1, win_length / 8 : end - win_length / 8);
            first_mics_sig_partial_norm = norm(first_mics_sig_partial)^2;

            [estimated_sig_E_partial, estimated_sig_R_cov_E_partial, estimated_sig_sf_partial, ...
                SIR_E, SIR_R_cov_E, SIR_sf, ...
                SNR_E, SNR_R_cov_E, SNR_sf] = ...
                EstimateSignal_SF(...
                stft_tensor, stft_tensor_signal, stft_tensor_interferences, stft_tensor_noise, ...
                num_of_mics, fs, win_length, overlap_stft_length, num_frames, ...
                frames_cov_est_with_overlap, delta_corr);
            dSIR_E(SIR_index, monte_carlo_index) = SIR_E - SIR_dB_eff;
            dSIR_R_cov_E(SIR_index, monte_carlo_index) = SIR_R_cov_E - SIR_dB_eff;
            dSIR_sf(SIR_index, monte_carlo_index) = SIR_sf - SIR_dB_eff;
            dSNR_E(SIR_index, monte_carlo_index) = SNR_E - SNR_dB;
            dSNR_R_cov_E(SIR_index, monte_carlo_index) = SNR_R_cov_E - SNR_dB;
            dSNR_sf(SIR_index, monte_carlo_index) = SNR_sf - SNR_dB;

            error_E_cur = norm(estimated_sig_E_partial - ...
                first_mics_sig_partial)^2 / first_mics_sig_partial_norm;
            error_R_cov_E_cur = norm(estimated_sig_R_cov_E_partial - ...
                first_mics_sig_partial)^2 / first_mics_sig_partial_norm;
            error_sf_cur = norm(estimated_sig_sf_partial - ...
                first_mics_sig_partial)^2 / first_mics_sig_partial_norm;
            error_E(SIR_index, monte_carlo_index) = 10 * log10(error_E_cur);
            error_R_cov_E(SIR_index, monte_carlo_index) = 10 * log10(error_R_cov_E_cur);
            error_sf(SIR_index, monte_carlo_index) = 10 * log10(error_sf_cur);
        end
    end

    legend_entries = {'$\textbf{\emph{r}}^d$($\hat{\bf\Gamma\rm})$', ...
        '$\textbf{\emph{r}}^d$($\hat{\bf\Gamma\rm}_\mathrm{R})$', ...
        '$\hat{\textbf{\emph{r}}}^d$'};
    xlabel_str = "SIR[dB]";

    % Log NMSE
    mean_error_E = mean(error_E, 2);
    std_error_E = std(error_E, 0, 2);
    mean_error_R_cov_E = mean(error_R_cov_E, 2);
    std_error_R_cov_E = std(error_R_cov_E, 0, 2);
    mean_error_sf = mean(error_sf, 2);
    std_error_sf = std(error_sf, 0, 2);

    figure('Position', [300, 200, 650, 500]);
    hold on
    grid on
    grid minor
    errorbar(SIR_dB_list, mean_error_E, std_error_E, ':', 'LineWidth', 2.5, ...
        'Color', [0.47,0.67,0.19])
    errorbar(SIR_dB_list, mean_error_R_cov_E, std_error_R_cov_E, '--', 'LineWidth', 2.5, ...
        'Color', [0.85 0.33 0.10])
    errorbar(SIR_dB_list, mean_error_sf, std_error_sf, '-', 'LineWidth', 2.5, ...
        'Color', [0 0.4470 0.7410])
    ax = gca;
    ax.FontSize = 20;
    ylabel("Log NMSE", "FontSize", fontSize)
    xlabel(xlabel_str, "FontSize", fontSize)
    leg = legend(legend_entries, "Interpreter", "latex");
    leg.FontSize = 18;
    hold off
    xlim([SIR_dB_list(1) SIR_dB_list(end)]);

    % dSIR
    mean_dSIR_E = mean(dSIR_E, 2);
    std_dSIR_E = std(dSIR_E, 0, 2);
    mean_dSIR_R_cov_E = mean(dSIR_R_cov_E, 2);
    std_dSIR_R_cov_E = std(dSIR_R_cov_E, 0, 2);
    mean_dSIR_sf = mean(dSIR_sf, 2);
    std_dSIR_sf = std(dSIR_sf, 0, 2);

    figure('Position', [300, 200, 650, 500]);
    hold on
    grid on
    grid minor
    errorbar(SIR_dB_list, mean_dSIR_E, std_dSIR_E, ':', 'LineWidth', 2.5, ...
        'Color', [0.47,0.67,0.19])
    errorbar(SIR_dB_list, mean_dSIR_R_cov_E, std_dSIR_R_cov_E, '--', 'LineWidth', 2.5, ...
        'Color', [0.85 0.33 0.10])
    errorbar(SIR_dB_list, mean_dSIR_sf, std_dSIR_sf, '-', 'LineWidth', 2.5, ...
    'Color', [0 0.4470 0.7410])
    ax = gca;
    ax.FontSize = 20;
    ylabel("\DeltaSIR", "FontSize", fontSize)
    xlabel(xlabel_str, "FontSize", fontSize)
    leg = legend(legend_entries, "Interpreter", "latex");
    leg.FontSize = 18;
    hold off
    xlim([SIR_dB_list(1) SIR_dB_list(end)]);

    % dSNR
    mean_dSNR_E = mean(dSNR_E, 2);
    std_dSNR_E = std(dSNR_E, 0, 2);
    mean_dSNR_R_cov_E = mean(dSNR_R_cov_E, 2);
    std_dSNR_R_cov_E = std(dSNR_R_cov_E, 0, 2);
    mean_dSNR_sf = mean(dSNR_sf, 2);
    std_dSNR_sf = std(dSNR_sf, 0, 2);

    figure('Position', [300, 200, 650, 500]);
    hold on
    grid on
    grid minor
    errorbar(SIR_dB_list, mean_dSNR_E, std_dSNR_E, ':', 'LineWidth', 2.5, ...
        'Color', [0.47,0.67,0.19])
    errorbar(SIR_dB_list, mean_dSNR_R_cov_E, std_dSNR_R_cov_E, '--', 'LineWidth', 2.5, ...
        'Color', [0.85 0.33 0.10])
    errorbar(SIR_dB_list, mean_dSNR_sf, std_dSNR_sf, '-', 'LineWidth', 2.5, ...
    'Color', [0 0.4470 0.7410])
    ax = gca;
    ax.FontSize = 20;
    ylabel("\DeltaSNR", "FontSize", fontSize)
    xlabel(xlabel_str, "FontSize", fontSize)
    leg = legend(legend_entries, "Interpreter", "latex");
    leg.FontSize = 18;
    hold off
    xlim([SIR_dB_list(1) SIR_dB_list(end)]);

    PlotScenarioMulti(theta_right_target, theta_left_target, angles_inter, trans_dist, inter_dist, ...
        mics_pos_mat, mid_mic_pos, target_height, inter_heights, room_dims, plot_scenario);
end
