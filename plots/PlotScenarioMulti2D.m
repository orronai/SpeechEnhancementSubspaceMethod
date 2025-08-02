function PlotScenarioMulti2D(theta_right_target, theta_left_target, angles_inter, ...
    trans_dist, inter_dist, mics_array, mid_mic_pos, room_dims)
% Plot the room scenario in 2D for 1 desired source and multiple interfering sources
% https://github.com/amitaybar/Interference-Rejection-using-Riemannian-Geometry-for-DoA-Estimation
    fontSize = 14;
    theta_vec_target = pi / 180 * linspace(theta_right_target, theta_left_target);

    figure;
    hold on
    for m = 1 : size(mics_array, 1)
        p_mics = plot(mics_array(m, 1), mics_array(m, 2), ...
            'o', 'MarkerSize', 5, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');
    end
    p_trans = plot(mid_mic_pos(1) + trans_dist * cos(theta_vec_target), ...
        mid_mic_pos(2) + trans_dist * sin(theta_vec_target), 'o', 'MarkerSize', 5, ...
        'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r');
    for i_i = 1 : length(angles_inter)
        p_inter = plot(mid_mic_pos(1) + inter_dist * cosd(angles_inter(i_i)), ...
            mid_mic_pos(2) + inter_dist * sind(angles_inter(i_i)), 'o', 'MarkerSize', 5, ...
            'MarkerEdgeColor', 'g', 'MarkerFaceColor', 'g');
    end

    xlabel('x[m]'); ylabel('y[m]');
    legend([p_mics p_trans p_inter], {'Microphone', 'Target', 'Interference'});
    set(gca, 'FontSize', fontSize);
    set(gca, 'LineWidth', 0.8);
    set(gca, 'YTick', 1 : 6);
    box on; grid on
    xlim([0 room_dims(1)])
    ylim([0 room_dims(2)])
%     axis equal
end

