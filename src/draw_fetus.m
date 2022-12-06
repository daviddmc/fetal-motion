function draw_fetus(data1, data2, t, ax)
%draw_fetus  Plot 3D fetal pose.
%   draw_fetus(DATA1, [], T) plots the T-th frame of DATA1.
%
%   draw_fetus(DATA1, DATA2, T) plots the T-the frame of DATA1 and DATA2 in 
%   solid and dashed line respectively.
%   
%   draw_fetus(..., AX) plots into AX instead of GCA.

if ~exist('ax','var')
    ax = gca;
else
    axes(ax)
end
shoulder_l = 12;
shoulder_r = 13;
neck = 16;

joint = squeeze(data1.joints(t, :, :))';
if ~isempty(data2)
    joint2 = squeeze(data2.joints(t, :, :))';
else
    joint2 = [];
end

joint(neck, :) = (joint(shoulder_l, :) + joint(shoulder_r, :)) / 2;
if ~isempty(joint2)
    joint2(neck, :) = (joint2(shoulder_l, :) + joint2(shoulder_r, :)) / 2;
end

v = get(ax, 'View');
scatter3(ax, joint(1:15,1), joint(1:15,2), joint(1:15,3), 80)
hold on
drawsegments(ax, joint, '')
if ~isempty(joint2)
    scatter3(ax, joint2(1:15,1), joint2(1:15,2), joint2(1:15,3), 80)
    drawsegments(ax, joint2, '--')
end
grid on 
axis equal
%xlim(xl)
%ylim(yl)
%zlim(zl)
set(ax, 'View', v);
hold off

function drawsegments(ax, joint, l)

ankle_l = 1;
ankle_r = 2;
knee_l = 3;
knee_r = 4;
bladder = 5;
elbow_l = 6;
elbow_r = 7;
eye_l = 8;
eye_r = 9;
hip_l = 10;
hip_r = 11;
shoulder_l = 12;
shoulder_r = 13;
wrist_l = 14;
wrist_r = 15;
neck = 16;

drawsegment(ax, [ankle_l, knee_l], joint, ['r',l])
drawsegment(ax, [ankle_r, knee_r], joint, ['b',l])
drawsegment(ax, [hip_l, knee_l], joint, ['r',l])
drawsegment(ax, [hip_r, knee_r], joint, ['b',l])
drawsegment(ax, [hip_r, bladder], joint, ['g',l])
drawsegment(ax, [hip_l, bladder], joint, ['g',l])
drawsegment(ax, [neck, bladder], joint, ['g',l])
drawsegment(ax, [neck, shoulder_l], joint, ['g',l])
drawsegment(ax, [neck, shoulder_r], joint, ['g',l])
drawsegment(ax, [elbow_l, shoulder_l], joint, ['r',l])
drawsegment(ax, [elbow_r, shoulder_r], joint, ['b',l])
drawsegment(ax, [elbow_l, wrist_l], joint, ['r',l])
drawsegment(ax, [elbow_r, wrist_r], joint, ['b',l])
drawsegment(ax, [neck, eye_l], joint, ['m',l])
drawsegment(ax, [neck, eye_r], joint, ['m',l])
drawsegment(ax, [eye_r, eye_l], joint, ['m',l])

function drawsegment(ax, c, joint, s)
plot3(ax, joint(c, 1), joint(c, 2), joint(c, 3), s,'LineWidth',3)

