%% Biomedical Robotics - Assignment 1

%% STEP 0: Clean workspace
clear all
clc

%% STEP 1: Load and extract data
% Load the data
load('ES1_emg.mat');

% Extract the EMG signal and accelerometer data
emg_signal = Es1_emg.matrix(:, 1);  % EMG Deltoid
accel_x = Es1_emg.matrix(:, 2);     % Deltoid Accelerometer - X
accel_y = Es1_emg.matrix(:, 3);     % Deltoid Accelerometer - Y
accel_z = Es1_emg.matrix(:, 4);     % Deltoid Accelerometer - Z

%% STEP 2: Filter the raw EMG signal with a 30-450Hz band pass filter
% Sampling frequency in Hz
Fs = 2000; 

% Band-pass Filter (30-450 Hz) for EMG Signal using FIR filter
bpFilt = designfilt('bandpassfir', 'FilterOrder', 100, ...
    'CutoffFrequency1', 30, 'CutoffFrequency2', 450, ...
    'SampleRate', Fs);

% Apply zero-phase filtering using filtfilt to avoid phase shift
filtered_emg = filtfilt(bpFilt, emg_signal);

%% Step 3: Rectify the signal
rectified_emg = abs(filtered_emg);

%% Step 4: Compute the envelope (low-pass filter at 3-6 Hz)
% Low pass filter (6 Hz) using FIR filter
lpFilt = designfilt('lowpassfir', 'FilterOrder', 150, ...
    'CutoffFrequency', 6, 'SampleRate', Fs);

% Apply filter to rectified signal to create envelope
envelope = filtfilt(lpFilt, rectified_emg);

%% Step 5: Down-sample the signal 
% Factor to reduce the number of samples by keeping only every 10th sample
downsampling_factor = 10;

% Time vector of original EMG signal
time_vector = (1:length(emg_signal)) / Fs; 

% Take every 10th sample, creating a downsampled time vector
downsampled_time = time_vector(1:downsampling_factor:end);

% Downsample envelope by selecting every 10th data point 
% (in order to have fewer samples for easier plotting)
downsampled_envelope = envelope(1:downsampling_factor:end);

% Normalized envelope
norm_envelope = downsampled_envelope./max(downsampled_envelope);

%% Plots
figure;

% Subfigure 1: Raw EMG signal and Filtered EMG signal
subplot(3, 1, 1);
plot(downsampled_time, emg_signal(1:downsampling_factor:end), 'k');
hold on;
plot(downsampled_time, filtered_emg(1:downsampling_factor:end), 'r');
title('Raw and Filtered EMG Signal');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Raw EMG', 'Filtered EMG');

% Subfigure 2: Rectified EMG signal and Envelope
subplot(3, 1, 2);
plot(downsampled_time, rectified_emg(1:downsampling_factor:end), 'b');
hold on;
plot(downsampled_time, downsampled_envelope, 'g');
title('Rectified EMG and Envelope');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Rectified EMG', 'Envelope');

% Subfigure 3: Movement Signal (Accelerometer X) and Envelope
subplot(3, 1, 3);
plot(downsampled_time, accel_x(1:downsampling_factor:end), 'r');
hold on;
plot(downsampled_time, accel_y(1:downsampling_factor:end), 'b');
hold on;
plot(downsampled_time, accel_z(1:downsampling_factor:end), 'g');
hold on;
plot(downsampled_time, norm_envelope, 'r');
hold on
title('Movement Signal (X, Y, Z) and Envelope');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Accelerometer X', 'Accelerometer Y', 'Accelerometer Z', 'envelope');


