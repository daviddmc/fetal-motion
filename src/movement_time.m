function [mt_a, mt_r] = movement_time(data, threshold)
%movement_time  Movement time of fetal pose time series.
%   [A, R] = movement(DATA, THRESHOLD) computes the absolute and relative
%   movement time of each keypoint, where movement smaller than THRESHOLD
%   (in mm/s) would be ignored. A is the absolute movement time in second
%   and R is relative movement time (normalized to [0, 1]).

dt = data.dt;
joints = data.joints;
diff_joints = joints(2:end, :, :) - joints(1:end-1, :, :);
movement = sqrt(sum(diff_joints.^2, 2)) / dt;
mt = sum(movement > threshold, 1);
mt_r = mt / size(movement, 1);
mt_a = mt * dt;

end

