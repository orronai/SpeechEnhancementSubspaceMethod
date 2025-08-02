function PlotScenarioMulti3D(theta_right_target, theta_left_target, angles_inter, trans_dist, ...
    inter_dist, mics_array, mid_mic_pos, target_height, inter_heights, room_dims)
% Plot the room scenario in 3D for 1 desired source and multiple interfering sources
% https://github.com/amitaybar/Interference-Rejection-using-Riemannian-Geometry-for-DoA-Estimation
    fontSize = 14;
    theta_vec_target = pi / 180 * linspace(theta_right_target, theta_left_target);

    figure;
    hold on
    % for m = 1 : 2 : size(mics_array, 1)
    for m = 1 : size(mics_array, 1)
        p_mics = plot3(mics_array(m, 1), mics_array(m, 2), mics_array(m, 3), ...
            'o', 'MarkerSize', 4, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');
    end
    p_trans = plot3(mid_mic_pos(1) + trans_dist * cos(theta_vec_target), ...
        mid_mic_pos(2) + trans_dist * sin(theta_vec_target), ...
        target_height * ones(1, length(theta_vec_target)), ...
        'o', 'MarkerSize', 5, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r');
    for i_i = 1 : length(angles_inter)
        p_inter = plot3(mid_mic_pos(1) + inter_dist * cosd(angles_inter(i_i)), ...
            mid_mic_pos(2) + inter_dist * sind(angles_inter(i_i)), inter_heights(i_i), ...
            'o', 'MarkerSize', 5, 'MarkerEdgeColor', 'g', 'MarkerFaceColor', 'g');
    end

    PlotCube(room_dims, [0 0 0], 0.01, [1 0 0]);
    % xlabel('x[m]'); ylabel('y[m]'); zlabel('z[m]');
    legend([p_mics p_trans p_inter], {'Microphone', 'Target', 'Interference'});
    set(gca, 'FontSize', fontSize);
    set(gca, 'LineWidth', 0.1);
    grid on
    xlim([-0.5 room_dims(1)+0.5])
    ylim([-0.5 room_dims(2)+0.5])
    % set(gca, 'xtick', [])
    % set(gca, 'xticklabel', [])
    % set(gca, 'ytick', [])
    % set(gca, 'yticklabel', [])
    % set(gca, 'ztick', [])
    % set(gca, 'zticklabel', [])
    % view(225, 315);
end

