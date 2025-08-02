% Load the definitions required for the simulations of multiple interfering
% sources, for voice signals
% Load Speech Signals
load('TIMIT_10s.mat');
% s = reshape(s, [], size(s, 2) / 2);

% Set Seed
rng(154, 'twister');

% Signals
N_D = 1;
N_I = 2;
first_mic_pos = [3.7 1 2];
room_dims = [8 6 3.5];
target_height = 1.5;
inter_heights = 1.5 * ones(1, N_I);
trans_dist = 2.7;
inter_dist = 2.7;
active_probaility = 0.3;

sig_length = 32 * 1024 * 2;
target_gain = 1;
SIR_dB = 0;
inter_gain = target_gain / 10^(SIR_dB / 20);

% STFT and Frequency
c = 340; % Sound velocity [m/s]
fs = 16e3;
win_length = 1024;
overlap_stft_length = ceil(win_length / 2);
bin_ind = ceil(win_length / 4);
num_frames = 2;
frames_cov_est = sig_length / (num_frames * win_length);
frames_cov_est_with_overlap = 2 * frames_cov_est - 1;
freq_bin_inter = fs / win_length * (bin_ind - 0.5);
lambda = c / freq_bin_inter;
delta = lambda / 2;

% Simulation
plot_scenario = 1;
monte_carlo_num = 100;

% RIR
beta = 0.15;
mtype = 'omnidirectional';
order = -1;
dim = 3;
orientation = 0;
hp_filter = 1;

% Simulation Values
num_of_mics = 16;
SNR_dB = 20;
SNR_dB_list = -10 : 5 : 50;
SIR_dB_list = -15 : 3 : 21;
% Angles
angles_inter = zeros(1, N_I);
angles_inter_right = 15 + rand(1, N_I) * 30;
angles_inter_left = 135 + rand(1, N_I) * 30;
angles_indxs = rand(1, N_I);
angles_inter(angles_indxs > 0.5) = angles_inter_right(angles_indxs > 0.5);
angles_inter(angles_indxs <= 0.5) = angles_inter_left(angles_indxs <= 0.5);
angle_right = 31.5;
angle_left = 141.1;
angles_inter = [angle_right angle_left];
scenario = 6;
theta_diff = 50;
delta_corr = 0.001;

if num_frames == 2
    IndicatorSmall = eye(num_frames);
else
    IndicatorSmall = zeros(N_I, num_frames);
    IndicatorSmallIndx  = rand(N_I, num_frames);
    IndicatorSmall(IndicatorSmallIndx < active_probaility) = 1;
    IndicatorSmall(IndicatorSmallIndx >= active_probaility) = 0;
end
IndicatorBig = kron(IndicatorSmall, ones(1, frames_cov_est * win_length));

rand_signals_indexes = randi(size(s, 2), [monte_carlo_num N_D+N_I]);
rand_starting_points = randi(size(s, 1) - sig_length, [monte_carlo_num N_D+N_I]);

voice_signal_full_list = s(rand_starting_points(:, 1) : rand_starting_points(:, 1) + sig_length - 1, ...
    rand_signals_indexes(:, 1)).';

voice_inter_full_list = zeros(N_I, monte_carlo_num, sig_length);
for i = 1 : N_I
    voice_inter_full_list(i, :, :) = s(rand_starting_points(:, N_D + i) : ...
        rand_starting_points(:, N_D + i) + sig_length - 1, ...
        rand_signals_indexes(:, N_D + i)).';
end

voice_inter_list = zeros(size(voice_inter_full_list));

for sig_index = 1 : monte_carlo_num
    voice_signal_full_list(sig_index, :) = target_gain * voice_signal_full_list(sig_index, :) / ...
        norm(voice_signal_full_list(sig_index, :));
    for i_i = 1 : N_I
        voice_inter_full_list(i_i, sig_index, :) = inter_gain * voice_inter_full_list(i_i, sig_index, :) / ...
            norm(squeeze(voice_inter_full_list(i_i, sig_index, :)));
    end
    voice_inter_list(:, sig_index, :) = squeeze(voice_inter_full_list(:, sig_index, :)) .* IndicatorBig;
end