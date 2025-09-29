% Main file for our simulations for voice signals or random wideband signals,
% for multiple number of interfering sources and one desired source
%% Clears
clc; clear all; close all;


%% Paths
addpath(fullfile(pwd, 'plots'));
addpath(genpath(fullfile(pwd, 'simulations')));
addpath(fullfile(pwd, 'functions'));
addpath(fullfile(pwd, 'RIR'));


%% Simulations Definitions - 2 Interferences
LoadDefinitions2;


%% Different SNR Values - 2 Interferences - Combination of RTFs
RandTargetAngles_RIR_ERTF_STFT_SNR_SF(...
    voice_signal_full_list, voice_inter_list, sig_length, SNR_dB_list, N_I, ...
    monte_carlo_num, delta, num_of_mics, first_mic_pos, trans_dist, ...
    inter_dist, target_height, inter_heights, scenario, theta_diff, plot_scenario, ...
    angles_inter, room_dims, fs, c, win_length, overlap_stft_length, num_frames, ...
    frames_cov_est_with_overlap, beta, mtype, order, dim, orientation, hp_filter, delta_corr);


%% Different SIR Values - 2 Interferences - Combination of RTFs
plot_scenario = 0;
RandTargetAngles_RIR_ERTF_STFT_SIR_SF(...
    voice_signal_full_list, voice_inter_full_list, sig_length, SNR_dB, N_I, ...
    target_gain, IndicatorBig, monte_carlo_num, delta, num_of_mics, first_mic_pos, trans_dist, ...
    inter_dist, target_height, inter_heights, SIR_dB_list, scenario, theta_diff, ...
    plot_scenario, angles_inter, room_dims, fs, c, win_length, overlap_stft_length, num_frames, ...
    frames_cov_est_with_overlap, beta, mtype, order, dim, orientation, hp_filter, delta_corr);
