function [m, s, ang_vec] = angular_velocity(data)
%angular_velocity  Mean and std of velocity of keypoints.
%   [M, S, V] = angulari_velocity(DATA) computes the mean M and standard 
%   deviation S of angular velocity V (in deg/s). 
%
%   The list of angles is as follows.
%
%   [knee_L, knee_R, elbow_L, elbow_R]

joint_coord = data.joints;
dt = data.dt;

femur = streval(joint_coord, '{hip_l,hip_r}-{knee_l,knee_r}');
tibia = streval(joint_coord, '{ankle_l,ankle_r}-{knee_l,knee_r}');
humerus = streval(joint_coord, '{shoulder_l,shoulder_r}-{elbow_l,elbow_r}');
radius = streval(joint_coord, '{wrist_l,wrist_r}-{elbow_l,elbow_r}');
cos_knee = sum(femur .* tibia, 2) ./ (vecnorm(femur, 2, 2) + 1e-10) ./ (vecnorm(tibia, 2, 2) + 1e-10);
cos_elbow = sum(humerus .* radius, 2) ./ (vecnorm(humerus, 2, 2) + 1e-10) ./ (vecnorm(radius, 2, 2) + 1e-10);
ang = acos(cat(3, cos_knee, cos_elbow)) / pi * 180;

ang_vec = abs(ang(2:end, :, :) - ang(1:end-1, :, :)) / dt;

m = mean(ang_vec, 1);
s = std(ang_vec, 1);
