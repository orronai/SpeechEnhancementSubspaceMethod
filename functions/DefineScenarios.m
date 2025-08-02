function [theta_right_target, theta_left_target, theta_right_inter_1, theta_left_inter_1, ...
    theta_right_inter_2, theta_left_inter_2] = DefineScenarios(scenario, theta_diff)
% Define the scenarios for the simulations - the random angles for the sources
    if scenario == 1
        theta_right_target = 10;
        theta_right_inter_1 = 30;
        theta_right_inter_2 = 50;
    elseif scenario == 2
        theta_right_target = 10;
        theta_right_inter_1 = 70;
        theta_right_inter_2 = 130;
    elseif scenario == 3
        theta_right_target = 70;
        theta_right_inter_1 = 10;
        theta_right_inter_2 = 130;
    elseif scenario == 4
        theta_right_target = 30;
        theta_right_inter_1 = 10;
        theta_right_inter_2 = 50;
    elseif scenario == 5
        theta_right_target = 15;
        theta_right_inter_1 = 65;
        theta_right_inter_2 = 115;
    elseif scenario == 6
        theta_right_target = 65;
        theta_right_inter_1 = 15;
        theta_right_inter_2 = 115;
    elseif scenario == 7
        theta_right_target = 15;
        theta_right_inter_1 = 15;
        theta_right_inter_2 = 15;
    else
        theta_right_target = 30;
        theta_right_inter_1 = 30;
        theta_right_inter_2 = 30;
    end
    theta_left_target = theta_right_target + theta_diff;
    theta_left_inter_1 = theta_right_inter_1 + theta_diff;
    theta_left_inter_2 = theta_right_inter_2 + theta_diff;
end

