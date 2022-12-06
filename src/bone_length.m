function [m, s] = bone_length(data)
%bone_length  Mean and std of bone length in fetal pose.
%   [M, S] = bone_length(DATA) computes the mean M and standard deviation S
%   of bone length in fetal pose. 
%   
%   The list of bones is as follows.
%
%   1   tibai_L     (ankle_L, knee_L)
%   2   tibai_R     (ankle_R, knee_R)
%   3   femur_L     (knee_L, hip_L)
%   4   femur_R     (knee_R, hip_R)
%   5   radius_L    (wrist_L, elbow_L)
%   6   radius_R    (wrist_R, elbow_R)
%   7   humerus_L   (elbow_L, shoulder_L)
%   8   humerus_R   (elbow_R, shoulder_R)


bones = {'ankle_l', 'knee_l';...
         'ankle_r', 'knee_r';...
         'knee_l', 'hip_l';...
         'knee_r', 'hip_r';...
         'wrist_l', 'elbow_l';...
         'wrist_r', 'elbow_r';...
         'elbow_l', 'shoulder_l';...
         'elbow_r', 'shoulder_r'};
      
a = strjoin(bones(:, 1), ',');
b = strjoin(bones(:, 2), ',');

joints = data.joints;

res = streval(joints, ['{' a '}-{' b '}']);

res = sqrt(sum(res.^2, 2));
m = mean(res, 1);
s = std(res, 1);