function PlotSpectrogramAndTime(signal, fs, win_length, overlap_stft_length)
    figure('Position', [100, 100, 800, 600]);

    h1 = subplot(3, 1, [1 2]);
    spectrogram(signal, hanning(win_length), overlap_stft_length, [], fs, 'yaxis');
    colormap(h1, 'jet');
    clim([-150 -80])
    xticks([])
    xlabel('')
    yticks(0 : 1 : 8)
    ax = gca;
    ax.FontSize = 20;
    ax.YLabel.FontSize = 24;

    subplot(3, 1, 3);
    t = (0:length(signal)-1) / fs;
    plot(t, signal, 'b');
    xlabel('Time (s)');
    ylabel('Amplitude');
    xlim([0 length(signal)-1] / fs)
    ylim([-3e-3 3e-3])
    yticks(-3e-3 : 1.5e-3 : 3e-3)
    ax = gca;
    ax.FontSize = 20;
    ax.YLabel.FontSize = 24;

    hColorbar = colorbar(h1);
    newPosition = get(hColorbar, 'Position');
    newPosition(1) = 0.91; % Adjust this value as needed
    newPosition(2) = 0.11; % Adjust this value as needed
    newPosition(3) = 0.02; % Set width to a small value for left-to-right span
    newPosition(4) = 0.815; % Adjust this value as needed
    set(hColorbar, 'Position', newPosition);
end
