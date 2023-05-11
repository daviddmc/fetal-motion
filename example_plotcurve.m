%%
%
% This example illustrates how to plot a curve of a metric.
%

%% setup
addpath('./src')


% path to the keypoint data
data_path = './data';
% path to the data table
data_table = './data.xlsx';
% resolution of the data in mm
resolution = [3.0, 3.0, 3.0];

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

%% plot
dat = data{1};
% name of angles
ang = {'knee_L', 'knee_R', 'elbow_L', 'elbow_R'};
% compute angle
[~, ~, a] = joint_angle(dat);
% plot angle of the left knee
a = squeeze(a);
a = a(:, 1);
figure;
% time in min
t = (0:(length(a) - 1)) * dat.dt / 60;
plot(t, a, 'LineWidth', 2)
title('angle of left knee')
xlabel('time (min)')
ylabel('angle (degree)')

