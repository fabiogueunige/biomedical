%% Biomedical Robotics - Assignment 1.2

%% STEP 0: Clean workspace
clear all
clc
close all

%% STEP 1: Load and extract data
% Load the data
load('ES2_emg.mat');

% Extract the EMG signal and accelerometer data
time_vector = ES2_emg.time;
bicep_right = ES2_emg.signals(:, 1);        
bicep_left = ES2_emg.signals(:, 2);        
trapezius_right = ES2_emg.signals(:, 3);    
trapezius_left = ES2_emg.signals(:, 4);

% Sampling frequency in Hz
Fs = 1000; 

% Band-pass Filter (30-450 Hz) for EMG Signal using FIR filter
bpFilt = designfilt('bandpassfir', 'FilterOrder', 100, ...
    'CutoffFrequency1', 30, 'CutoffFrequency2', 450, ...
    'SampleRate', Fs);

% Apply zero-phase filtering using filtfilt to avoid phase shift
filtered_br = filtfilt(bpFilt, bicep_right);
filtered_bl = filtfilt(bpFilt, bicep_left);
filtered_tr = filtfilt(bpFilt, trapezius_right);
filtered_tl = filtfilt(bpFilt, trapezius_left);

%% Step 3: Rectify the signal
rectified_br = abs(filtered_br);
rectified_bl = abs(filtered_bl);
rectified_tr = abs(filtered_tr);
rectified_tl = abs(filtered_tl);

%% Step 4: Compute the envelope (low-pass filter at 3-6 Hz)
% Low pass filter (6 Hz) using FIR filter
lpFilt = designfilt('lowpassfir', 'FilterOrder', 300, ...
    'CutoffFrequency', 6, 'SampleRate', Fs);

% Apply filter to rectified signal to create envelope
envelope_br = filtfilt(lpFilt, rectified_br);
envelope_bl = filtfilt(lpFilt, rectified_bl);
envelope_tr = filtfilt(lpFilt, rectified_tr);
envelope_tl = filtfilt(lpFilt, rectified_tl);

% Normalized envelope signals
normal_br = envelope_br./max(envelope_br);
normal_bl = envelope_bl./max(envelope_bl);
normal_tr = envelope_tr./max(envelope_tr);
normal_tl = envelope_tl./max(envelope_tl);

% Factor to reduce the number of samples by keeping only every 50th sample
downsampling_factor = 50;

% Take every 50th sample, creating a downsampled time vector
downsampled_time = time_vector(1:downsampling_factor:end);
 
% Downsample envelope by selecting every 50th data point 
% (in order to have fewer samples for easier plotting)
downsampled_br = normal_br(1:downsampling_factor:end);
downsampled_bl = normal_bl(1:downsampling_factor:end);
downsampled_tr = normal_tr(1:downsampling_factor:end);
downsampled_tl = normal_tl(1:downsampling_factor:end);

musclebr = [downsampled_time, downsampled_br];
musclebl = [downsampled_time, downsampled_bl];
muscletr = [downsampled_time, downsampled_tr];
muscletl = [downsampled_time, downsampled_tl];

figure;
subplot(4, 1, 1);
plot(downsampled_time, downsampled_br);
title('br');
subplot(4, 1, 2);
plot(downsampled_time, downsampled_bl);
title('bl');
subplot(4, 1, 3);
plot(downsampled_time, downsampled_tr);
title('tr');
subplot(4, 1, 4);
plot(downsampled_time, downsampled_tl);
title('tl');