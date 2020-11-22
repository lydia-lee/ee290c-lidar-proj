clear all;
close all;
clc;
%%
% --------- BEGIN EDIT ---------
lamda = 1.55e-6; % meters
N = 8;
d = 35e-6; % meters
amp_sigma = [0, 0]; % normalize to 1
phase_sigma = [0, 0]; % rad
angle_steer = 1.26; % deg
phase_bins = [0]; % rad
angle_plot =  -4:0.0001:4; % azimuth angles (degrees)
% ---------- END EDIT ----------
c = physconst('lightspeed');
freq = c/lamda;

[array_ideal, array_nonideal] = make_opa(N, d, amp_sigma, phase_sigma, ...
    angle_steer, lamda, phase_bins);

steervec_ideal = phased.SteeringVector('SensorArray', array_ideal, ...
    'PropagationSpeed', c, ...
    'IncludeElementResponse', true, ...
    'NumPhaseShifterBits', 0);
sv_ideal = steervec_ideal(freq, angle_steer);
[pat_ideal_vec, az_ideal_vec, ~] = pattern(array_ideal, freq, angle_plot, 0, ...
    'PropagationSpeed', c, ...
    'CoordinateSystem', 'rectangular', ...
    'Type', 'powerdb', ...
    'Weights', sv_ideal);

steervec_nonideal = phased.SteeringVector('SensorArray', array_nonideal, ...
    'PropagationSpeed', c, ...
    'IncludeElementResponse', true, ...
    'NumPhaseShifterBits', 0);
sv_nonideal = steervec_nonideal(freq, angle_steer);
[pat_nonideal_vec, az_nonideal_vec, ~] = pattern(array_nonideal, freq, angle_plot, 0, ...
    'PropagationSpeed', c, ...
    'CoordinateSystem', 'rectangular', ...
    'Type', 'powerdb', ...
    'Weights', sv_nonideal);

plot(az_ideal_vec, pat_ideal_vec, 'DisplayName', sprintf('%0.1f deg', angle_steer));
hold on;
plot(az_nonideal_vec, pat_nonideal_vec, 'DisplayName', sprintf('%0.1f deg', angle_steer));
legend('Ideal', 'Nonideal');