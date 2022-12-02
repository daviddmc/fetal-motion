function [m, s] = bone_length(data)

bones = {'ankle_l', 'knee_l';...
         'ankle_r', 'knee_r';...
         'knee_l', 'hip_l';...
         'knee_r', 'hip_r';...
         'wrist_l', 'elbow_l';...
         'wrist_r', 'elbow_r';...
         'elbow_l', 'shoulder_l';...
         'elbow_r', 'shoulder_r'};
 
% tibia_L, tibia_R
% femur_L, femur_R
% radius_L, radius_R
% humerus_L, humerus_R 
     
a = strjoin(bones(:, 1), ',');
b = strjoin(bones(:, 2), ',');

joints = data.joints;

res = streval(joints, ['{' a '}-{' b '}']);

res = sqrt(sum(res.^2, 2));
m = mean(res, 1);
s = std(res, 1);