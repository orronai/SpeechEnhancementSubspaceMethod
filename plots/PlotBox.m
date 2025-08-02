function PlotBox(grouped_data, x_axis, legend_entries, colors, fontSize, title_str, ...
    subtitle_str, ylabel_str, xlabel_str)
% Boxplot of the errors
% https://github.com/amitaybar/Interference-Rejection-using-Riemannian-Geometry-for-DoA-Estimation
    N = numel(grouped_data);
    delta = linspace(-0.3, 0.3, N);
    width = 0.16;
    legWidth = 1.8;
    x_ticks = arrayfun(@num2str, x_axis, 'UniformOutput', 0);

    figure;
    hold on
    for index = 1 : N
        labels = x_ticks;
        boxplot(grouped_data{index}.', 'Color', colors{index}, 'position', (1 : numel(labels)) + delta(index), ...
            'widths', width, 'labels', labels, 'symbol', '')
        plot(NaN, 1, 'color', colors{index});  % dummy plot for legend
    end
    title(title_str, "FontSize", fontSize)
    subtitle(subtitle_str)
    ylabel(ylabel_str, "FontSize", fontSize)
    xlabel(xlabel_str, "FontSize", fontSize)
    set(findobj(gca, 'type', 'line'), 'linew', 2)
    set(gca, 'YGrid', 'on', 'XGrid', 'off')
    xlim([1+2*delta(1) numel(labels)+legWidth+2*delta(N)])  % adjust x limits, with room for legend
    ylim auto
    legend(legend_entries, "Interpreter", "latex");
    hold off
end

