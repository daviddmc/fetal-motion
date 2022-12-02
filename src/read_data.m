function data = read_data(path_joints, name, resolution, dt, ga)
s = load(path_joints);
J = s.joint_coord;
assert(size(J, 2) == 3 && size(J, 3) == 15)
if length(resolution) == 1
    J = J * resolution;
else
    J = J * reshape(resolution, 1, 3, 1);
end
I = find(J <= 0);
for idx = I
    [ii, jj, kk] = ind2sub(size(J), idx);
    if ii == 1
        J(ii, jj, kk) = J(ii+1, jj, kk);
    elseif ii == size(J, 1)
        J(ii, jj, kk) = J(ii-1, jj, kk);
    else
        J(ii, jj, kk) = (J(ii-1, jj, kk) + J(ii+1, jj, kk))/2;
    end
end

J = checkbone(J);

data.joints = J;
if strlength(name) > 0
    data.name = name;
else
    [~, name, ~] = fileparts(path_joints);
    data.name = name;
end
data.dt = dt;
data.ga = ga;

end

function res = checkbone(joints)

a = [1, 2, 3, 4, 14, 15, 6, 7, 8];
b = [3, 4, 10, 11, 6, 7, 12, 13, 9];

B = joints(:, :, a) - joints(:, :, b);
 
B = sqrt(sum(B.^2, 2));
Bmean = trimmean(B, 10, 'round', 1);
Berr = abs(B - Bmean) ./ Bmean;

th = 0.3;

for ii = 1:length(a)
    r = squeeze(Berr(:, :, ii));
    I = find(r > th);
    for jj = 1:length(I)
        idx = I(jj);
        idx_low = idx - 1;
        while(idx_low > 0 && r(idx_low) > th)
            idx_low = idx_low - 1;
        end
        idx_high = idx + 1;
        while(idx_high <= length(r) && r(idx_high) > th)
            idx_high = idx_high + 1;
        end
        if idx_low > 0 && idx_high <= length(r)
            joints(idx, :, [a(ii), b(ii)]) = ...
                (idx_high - idx) / (idx_high - idx_low) * joints(idx_low, :, [a(ii), b(ii)]) + ...
                (idx - idx_low) / (idx_high - idx_low) * joints(idx_high, :, [a(ii), b(ii)]);
        end 
    end
end

res = joints;
end
