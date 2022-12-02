function [mt_a, mt_r] = movement_time(data, threshold)

dt = data.dt;
joints = data.joints;
diff_joints = joints(2:end, :, :) - joints(1:end-1, :, :);
movement = sqrt(sum(diff_joints.^2, 2)) / dt;
mt = sum(movement > threshold, 1);
mt_r = mt / size(movement, 1);
mt_a = mt * dt;

end

