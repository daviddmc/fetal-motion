function [v_mean, v_std, v] = velocity(data)
%velocity  Mean and std of velocity of keypoints.
%   [M, S, V] = velocity(DATA) computes the mean M and standard deviation S
%   of velocity V of keypoints. 

dt = data.dt;
joints = data.joints;
diff_joints = joints(2:end, :, :) - joints(1:end-1, :, :);
v = sqrt(sum(diff_joints.^2, 2)) / dt;

v_mean = mean(v, 1);
v_std = std(v, 1);

end
