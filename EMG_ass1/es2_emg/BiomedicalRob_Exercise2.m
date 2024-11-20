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
muscle.br = ES2_emg.signals(:, 1);  % EMG Deltoid
muscle.bl = ES2_emg.signals(:, 2);     % Deltoid Accelerometer - X
muscle.tr = ES2_emg.signals(:, 3);     % Deltoid Accelerometer - Y
muscle.tl = ES2_emg.signals(:, 4);     % Deltoid Accelerometer - Z

% Sampling frequency in Hz
Fs = 1000; 

% Band-pass Filter (30-450 Hz) for EMG Signal using FIR filter
bpFilt = designfilt('bandpassfir', 'FilterOrder', 100, ...
    'CutoffFrequency1', 30, 'CutoffFrequency2', 450, ...
    'SampleRate', Fs);

% Apply zero-phase filtering using filtfilt to avoid phase shift
muscle.br = filtfilt(bpFilt, muscle.br);
muscle.bl = filtfilt(bpFilt, muscle.bl);
muscle.tr = filtfilt(bpFilt, muscle.tr);
muscle.tl = filtfilt(bpFilt, muscle.tl);

%% Step 3: Rectify the signal
muscle.br = abs(muscle.br);
muscle.bl = abs(muscle.bl);
muscle.tr = abs(muscle.tr);
muscle.tl = abs(muscle.tl);

%% Step 4: Compute the envelope (low-pass filter at 3-6 Hz)
% Low pass filter (6 Hz) using FIR filter
lpFilt = designfilt('lowpassfir', 'FilterOrder', 150, ...
    'CutoffFrequency', 6, 'SampleRate', Fs);

%% Apply filter to rectified signal to create envelope
muscle.br = filtfilt(lpFilt, muscle.br);
muscle.bl = filtfilt(lpFilt, muscle.bl);
muscle.tr= filtfilt(lpFilt, muscle.tr);
muscle.tl = filtfilt(lpFilt, muscle.tl);

%% Normalized envelope signals
muscle.br = muscle.br./max(muscle.br);
muscle.bl = muscle.bl./max(muscle.bl);
muscle.tr = muscle.tr./max(muscle.tr);
muscle.tl = muscle.tl./max(muscle.tl);

%% Downsample the signal and time
downsampling_factor = 50;

% downsample time
downsampled_time = time_vector(1:downsampling_factor:end);
 
% Downsample the signals
muscle.br = muscle.br(1:downsampling_factor:end);
muscle.bl = muscle.bl(1:downsampling_factor:end);
muscle.tr = muscle.tr(1:downsampling_factor:end);
muscle.tl = muscle.tl(1:downsampling_factor:end);

musclebr = [downsampled_time, muscle.br];
musclebl = [downsampled_time, muscle.bl];
muscletr = [downsampled_time, muscle.tr];
muscletl = [downsampled_time, muscle.tl];


