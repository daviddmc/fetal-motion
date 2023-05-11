%%
%
% This example illustrates how to compute metrics based on the keypoint
% data.
%

%% setup
addpath('./src')


% path to the keypoint data
data_path = './data';
% path to the data table
data_table = './data.xlsx';
% resolution of the data in mm
resolution = [3.0, 3.0, 3.0];
% threshold for motion (mm/s)
threshold_mt = 3.0;


% name of keypoints
kp = {'ankle_L', 'ankle_R', 'knee_L', 'knee_R', 'bladder',...
    'elbow_L', 'elbow_R', 'eye_L', 'eye_R', 'hip_L', 'hip_R', ...
    'shoulder_L', 'shoulder_R', 'wrist_L', 'wrist_R'};
% name of bones
bone = {'tibia_L', 'tibia_R', 'femur_L', 'femur_R', ...
    'radius_L', 'radius_R', 'humerus_L', 'humerus_R'};
% name of angles
ang = {'knee_L', 'knee_R', 'elbow_L', 'elbow_R'};


%% read data
T = readtable(data_table, 'TextType', 'string');
data = cell(size(T, 1), 1);
for ii = 1:size(T,1)
    ga = T.GA_week + T.GA_day / 7;
    data{ii} = read_data( ...
        fullfile(data_path, [T.name{ii} '.mat']), ... % path to the data
        T.name{ii}, ... % name of subject
        resolution, ... % resolution
        T.duration(ii), ... % duration of the scan in min
        ga ... % GA in weeks
        ); 
end

T_out = T;

%% movement time
% init
MT_abs = zeros(size(T, 1), length(kp));
MT_rel = zeros(size(T, 1), length(kp));
% compute metric
for ii = 1:size(T, 1)
    [MT_abs(ii, :), MT_rel(ii, :)] = movement_time(data{ii}, threshold_mt);
end
% save output
for ii = 1:length(kp)
    T_out = addvars(T_out, MT_abs(:, ii), 'NewVariableNames', ['movement_time_absolute_' kp{ii}]);
end
for ii = 1:length(kp)
    T_out = addvars(T_out, MT_rel(:, ii), 'NewVariableNames', ['movement_time_relative_' kp{ii}]);
end

%% bone length
% init
bl_mean = zeros(size(T, 1), length(bone));
bl_std = zeros(size(T, 1), length(bone));
% compute metric
for ii = 1:size(T, 1)
    [bl_mean(ii, :), bl_std(ii, :), ~] = bone_length(data{ii});
end
% save output
for ii = 1:length(bone)
    T_out = addvars(T_out, bl_mean(:, ii), 'NewVariableNames', ['avg_length_' bone{ii}]);
end
for ii = 1:length(bone)
    T_out = addvars(T_out, bl_std(:, ii), 'NewVariableNames', ['std_length_' bone{ii}]);
end

%% velocity
% init
mean_vel = zeros(size(T, 1), length(kp));
std_vel = zeros(size(T, 1), length(kp));
% compute metric
for ii = 1:size(T, 1)
    [mean_vel(ii, :), std_vel(ii, :), ~] = velocity(data{ii});
end
% save output
for ii = 1:length(kp)
    T_out = addvars(T_out, mean_vel(:, ii), 'NewVariableNames', ['mean_velocity_' kp{ii}]);
end
for ii = 1:length(kp)
    T_out = addvars(T_out, std_vel(:, ii), 'NewVariableNames', ['std_velocity_' kp{ii}]);
end

%% angle
% init
angle_mean = zeros(size(T, 1), length(ang));
angle_std = zeros(size(T, 1), length(ang));
% compute metric
for ii = 1:size(T, 1)
    [angle_mean(ii, :), angle_std(ii, :), ~] = joint_angle(data{ii});
end
% save output
for ii = 1:length(ang)
    T_out = addvars(T_out, angle_mean(:, ii), 'NewVariableNames', ['avg_angle_' ang{ii}]);
end
for ii = 1:length(ang)
    T_out = addvars(T_out, angle_std(:, ii), 'NewVariableNames', ['std_angle_' ang{ii}]);
end

%% angular velocity
% init
angle_vel_mean = zeros(size(T, 1), length(ang));
angle_vel_std = zeros(size(T, 1), length(ang));
% compute metric
for ii = 1:size(T, 1)
    [angle_vel_mean(ii, :), angle_vel_std(ii, :), ~] = angular_velocity(data{ii});
end
% save output
for ii = 1:length(ang)
    T_out = addvars(T_out, angle_vel_mean(:, ii), 'NewVariableNames', ['avg_angle_velocity_' ang{ii}]);
end
for ii = 1:length(ang)
    T_out = addvars(T_out, angle_vel_std(:, ii), 'NewVariableNames', ['std_angle_velocity_' ang{ii}]);
end

%% angular acceleration
% init
angle_acc_mean = zeros(size(T, 1), length(ang));
angle_acc_std = zeros(size(T, 1), length(ang));
% compute metric
for ii = 1:size(T, 1)
    [angle_acc_mean(ii, :), angle_acc_std(ii, :), ~] = angular_acceleration(data{ii});
end
% save output
for ii = 1:length(ang)
    T_out = addvars(T_out, angle_acc_mean(:, ii), 'NewVariableNames', ['avg_angle_acceleration_' ang{ii}]);
end
for ii = 1:length(ang)
    T_out = addvars(T_out, angle_acc_std(:, ii), 'NewVariableNames', ['std_angle_acceleration_' ang{ii}]);
end

%% write resutls
writetable(T_out, 'results.xlsx');