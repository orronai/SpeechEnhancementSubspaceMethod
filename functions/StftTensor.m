function stft_tensor = StftTensor(signal, num_mics, fs, win_length, overlap_stft_length)
% Get the STFT of the signal in each microphone
    for mic_ind = 1 : num_mics
        stft_mat = stft(signal(mic_ind, :), fs, 'Window', hanning(win_length), ...
            'OverlapLength', overlap_stft_length);
        stft_tensor(mic_ind, :, :) = stft_mat;
    end
end

