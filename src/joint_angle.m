function [m, s, ang] = joint_angle(data)
%joint_angle  Mean and std of joint angles.
%   [M, S, A] = joint_angle(DATA) computes the mean M and standard 
%   deviation S of joint angles A (in degree). 
%
%   The list of angles is as follows.
%
%   [knee_L, knee_R, elbow_L, elbow_R

joint_coord = data.joints;

femur = streval(joint_coord, '{hip_l,hip_r}-{knee_l,knee_r}');
tibia = streval(joint_coord, '{ankle_l,ankle_r}-{knee_l,knee_r}');
humerus = streval(joint_coord, '{shoulder_l,shoulder_r}-{elbow_l,elbow_r}');
radius = streval(joint_coord, '{wrist_l,wrist_r}-{elbow_l,elbow_r}');
cos_knee = sum(femur .* tibia, 2) ./ (vecnorm(femur, 2, 2) + 1e-10) ./ (vecnorm(tibia, 2, 2) + 1e-10);
cos_elbow = sum(humerus .* radius, 2) ./ (vecnorm(humerus, 2, 2) + 1e-10) ./ (vecnorm(radius, 2, 2) + 1e-10);
ang = acos(cat(3, cos_knee, cos_elbow)) / pi * 180;

m = mean(ang, 1);
s = std(ang, 1);
