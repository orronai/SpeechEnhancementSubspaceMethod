function GammaTensor = STFT_GammaTensor(stft_mat, num_mics, num_frames, frames_cov_est_with_overlap)
% Return for each frame the arithmetic mean of the correlation matrices
    GammaTensor = zeros(num_mics, num_mics, num_frames);
    for frame = 1 : num_frames
        sigma = stft_mat(:, (frame - 1) * frames_cov_est_with_overlap + frame : frame * frames_cov_est_with_overlap + frame - 1);
        for stft_frame = 1 : frames_cov_est_with_overlap
            GammaTensor(:, :, frame) = GammaTensor(:, :, frame) + 1 / size(sigma, 2) * sigma(:, stft_frame) * sigma(:, stft_frame)';
        end
    end
end
