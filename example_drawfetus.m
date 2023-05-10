%%
%
% This example illustrates how to draw fetal pose ("stick figure") based on 
% the keypoint data.
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

% plot the first frame of the first subject
figure;
draw_fetus(data{1}, [], 1);
view(3);
