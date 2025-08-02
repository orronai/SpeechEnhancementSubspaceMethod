function InterActivity(IndicatorSmall, N_I, num_frames)
% Activity pattern per segment of the interfering sources
% https://github.com/amitaybar/Interference-Rejection-using-Riemannian-Geometry-for-DoA-Estimation
    linewd = 0.8;
    hcfontsize = 20;
    map = [1 1 1; 0.9290 0.6940 0.1250];
    IndicatorSmallT = IndicatorSmall;
    figure; hold on;
    imagesc((1 : size(IndicatorSmallT, 2)) - 0.5, (1 : size(IndicatorSmallT, 1)) - 0.5, IndicatorSmallT);
    axis xy
    xlabel('Segment Index');
    ylabel('Interference Index');

    yt = get(gca, 'YTick');
    ytlbl = (1 : N_I);               
    set(gca, 'YTick', ytlbl - 0.5, 'YTickLabel', ytlbl)
    yt = get(gca, 'XTick');                         
    xtlbl = (1 : num_frames);
    set(gca, 'XTick', xtlbl - 0.5, 'XTickLabel', xtlbl)

    for l = 0 : N_I
        yline(l);
    end
    for l = 0 : num_frames
        xline(l);
    end

    % colormap gray
    colormap(map);
    alpha(0.9);
    box on
    set(gca, 'FontSize', hcfontsize / 1.5);
    set(gca, 'LineWidth', linewd);
end
