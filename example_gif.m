%%
%
% This example illustrates how to generate of gif of fetal motion.
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

%% compute metric
dat = data{59};
% name of angles
ang = {'knee_L', 'knee_R', 'elbow_L', 'elbow_R'};
% compute angle
[~, ~, a] = joint_angle(dat);
% plot angle of the left knee
a = squeeze(a);
a = a(:, 1);
% time in min
t = (0:(length(a) - 1)) * dat.dt / 60;
t = t';

%% plot
f = figure('color', 'w', 'position', [100, 100, 800, 400]);
ax1 = subplot(1,2,1);
ax2 = subplot(1,2,2);
started = false;
for ii = 1:length(t)
    % plot pose on the left
    draw_fetus(dat, [], ii, ax1);
    if ii == 1
        lim_x = get(ax1, 'xlim');
        lim_y = get(ax1, 'ylim');
        lim_z = get(ax1, 'zlim');
    end
    xlim(ax1, [lim_x(1)-20, lim_x(2)+20])
    ylim(ax1, [lim_y(1)-20, lim_y(2)+20])
    zlim(ax1, [lim_z(1)-20, lim_z(2)+20])
    if ii == 1
        xt = xticks;
        yt = yticks;
        zt = zticks;
    end
    xticklabels(ax1, [])
    yticklabels(ax1, [])
    zticklabels(ax1, [])
    xticks(ax1, xt);
    yticks(ax1, yt);
    zticks(ax1, zt);
    view(ax1, [-50, 10]);
    % plot curve on the right
    plot(ax2, t, a, 'LineWidth', 2)
    hold on
    xline(ax2, t(ii), 'k--', 'LineWidth',2)
    hold off
    title(ax2, 'angle of left knee')
    xlabel(ax2, 'time (min)')
    ylabel(ax2, 'angle (degree)')
    drawnow;
    % save as gif
    frame = getframe(f);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256); 
    if started
        imwrite(imind,cm,fullfile('.', 'example.gif'),'gif', 'DelayTime', 0.2,'WriteMode','append'); 
    else
        imwrite(imind,cm,fullfile('.', 'example.gif'),'gif', 'DelayTime', 0.2,'Loopcount',inf); 
    end
    started = true;
end

