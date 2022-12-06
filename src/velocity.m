function [v_mean, v_std] = velocity(data)
%velocity  Mean and std of velocity of keypoints.
%   [M, S] = velocity(DATA) computes the mean M and standard deviation S
%   of velocity of keypoints. 

dt = data.dt;
joints = data.joints;
diff_joints = joints(2:end, :, :) - joints(1:end-1, :, :);
movement = sqrt(sum(diff_joints.^2, 2)) / dt;

v_mean = mean(movement, 1);
v_std = std(movement, 1);

end
