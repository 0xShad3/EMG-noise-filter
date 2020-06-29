% Generates an unfiltered emg signal based on bursts given as input
% Returns a vector with the values of the emg raw signal

clear all;
close all;

% Main program

signal = rawSignal(3)
correct_means = signal - mean(signal) 
digitalSignal = analogToDigital(correct_means)
filteredSignal = butterworthFilter(digitalSignal)
timesig = generateTimestamp(signal,1)
time = generateTimestamp(filteredSignal,10)
%To calculate the coefficients storred in the bsc array used in the VHDL code 

fs = 1000 / 2
highBand = 20
lowBand = 450 
highPass = highBand / fs
lowPass = lowBand / fs
B = 8
[b,a] = butter(3,[highPass,lowPass],"bandpass")
L = floor(log2((2^(B-1)-1)/max(b)));
bsc = b*2^L;

% Plotting the output

subplot(3,1,1)
plot(timesig,signal)
title("Raw signal")
xlabel("Time (sec)")
ylabel("Amplitured mV")

figure(1)
subplot(3,1,2)
plot(time,digitalSignal)
title("Digitilized/quantised signal")
ylabel("Hz")
xlabel("Time (sec)")

subplot(3,1,3)
plot(time,filteredSignal)
title("Bandpass filtered signal 20-450Hz encoded for 8 bit interpretation")
ylabel("Normalised band")
xlabel("Time (sec)")

figure(2)  
title("Bandpass butterworth filter: LB-450Hz UB-20Hz")
freqz(b,a)
title("Bandpass butterworth filter: LB-450Hz UB-20Hz")

function emg_signal = rawSignal(bursts)
  rest = rand(1,1000) * 1.4 - 0.7 + 0.08;
  rest = mod(rest,0.07)
  emg_signal = rest;
  for i = 1:3
    muscle_burst_start = rand(1,200) * 0.8 - 0.4 + 0.08;
    emg_signal = [emg_signal,muscle_burst_start];
    muscle_burst_midstart = rand(1,200) * 1.6 - 0.8 + 0.08;
    emg_signal = [emg_signal,muscle_burst_midstart];
    muscle_burst = rand(1,200) * 1.9 -  0.95 + 0.08;
    emg_signal = [emg_signal,muscle_burst];
    muscle_burst_midend = rand(1,200) * 1.6 - 0.8 + 0.08
    emg_signal = [emg_signal,muscle_burst_midend];
    muscle_burst_end = rand(1,200) * 0.8 - 0.4 + 0.08
    emg_signal = [emg_signal,muscle_burst_end];
    emg_signal = [emg_signal,rest];
  end
end

% Generates time stamps to normalise the values plotted bellow
% Returns the vector containing the values

function time_stamp = generateTimestamp(raw_signal,modified)
  echo off all;

  time_stamp(:,1) = [1:length(raw_signal)]' * 0.001 * modified;
end

% First filter applied
% Since the signal is unfiltered we treat it as an analog signal
% This filter converts the analog signal to digital quantising the signal to 10 bits 
% Samples/second
% analog = 10000
% digital = 1000
function digitalSignal = analogToDigital(analogSignal)

bits = 8 
range = 1
analogSamplesPerSecond = 10000;
digitalSamplesPerSecond = 1000;
downsampledSignal = downsample(analogSignal,analogSamplesPerSecond/digitalSamplesPerSecond);
digitalSignal = uencode(downsampledSignal,bits,range)
end
% Second filter applied
% It takes as an input an digital sampled filter 
% Returns a filtered butterworth filtered banpass signal 
function filteredSignal = butterworthFilter(digitalSignal)
  %Nyquist sampling rate = digitalSamplesPerSecond / 2
  fs = 1000 / 2
  highBand = 20
  lowBand = 450 
  highPass = highBand / fs
  lowPass = lowBand / fs
  
  [b,a] = butter(3,[highPass,lowPass],"bandpass")
  filteredSignal = filter(b,a,digitalSignal)
end