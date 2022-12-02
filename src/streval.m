function res = streval(joints, s)

kp.ankle_l = 1;
kp.ankle_r = 2;
kp.knee_l = 3;
kp.knee_r = 4;
kp.bladder = 5;
kp.elbow_l = 6;
kp.elbow_r = 7;
kp.eye_l = 8;
kp.eye_r = 9;
kp.hip_l = 10;
kp.hip_r = 11;
kp.shoulder_l = 12;
kp.shoulder_r = 13;
kp.wrist_l = 14;
kp.wrist_r = 15;

s = convertStringsToChars(s);

l = strfind(s, '{');
r = strfind(s, '}');

assert(length(l) == length(r) && all(l < r));

if isempty(l)
    s_new = s;
else
    s_new = s(1:l(1)-1);
    for ii = 1:length(l)
        kp_names = s(l(ii)+1:r(ii)-1);
        kp_names = strjoin(cellfun(@(x)num2str(kp.(x)), strsplit(kp_names, ','), 'UniformOutput', false), ',');
        s_new = [s_new 'joints(:,:,[' kp_names '])'];
        if ii == length(l)
            s_new = [s_new s(r(ii)+1:end)];
        else
            s_new = [s_new s(r(ii)+1:l(ii+1)-1)];
        end
    end
end

res = eval(s_new);