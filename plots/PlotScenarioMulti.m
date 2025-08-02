function PlotScenarioMulti(theta_right_target, theta_left_target, angles_inter, trans_dist, inter_dist, ...
    mics_pos_mat, mid_mic_pos, target_height, inter_heights, room_dims, plot_scenario)
% Plot the room scenario both in 2D and 3D for 1 desired source and multiple interfering sources
    if plot_scenario
        PlotScenarioMulti2D(theta_right_target, theta_left_target, angles_inter, ...
            trans_dist, inter_dist, mics_pos_mat, mid_mic_pos, room_dims);
        PlotScenarioMulti3D(theta_right_target, theta_left_target, angles_inter, trans_dist, inter_dist, ...
            mics_pos_mat, mid_mic_pos, target_height, inter_heights, room_dims);
    end
end
