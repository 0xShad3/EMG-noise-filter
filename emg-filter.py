import numpy as np
import matplotlib.pyplot as plt
import scipy as sp
from scipy import signal

# to simulate an emg signal with 2 bursts
# normalized values to test including the noise
def generate_signal(bursts):
   
    # set frequency of the samplirate at 1000hz
    rest = np.random.uniform(-0.07,0.07,size=1000) + 0.08
    emg_signal = rest
    for i in range(bursts):
        muscle_burst_start = np.random.uniform(-0.4,0.4,size=200) + 0.08
        muscle_burst_midstart = np.random.uniform(-0.8,0.8,size=200) + 0.08
        muscle_burst = np.random.uniform(-0.95,0.95,size=300) + 0.08
        muscle_burst_midend = np.random.uniform(-0.8,0.8,size=200) + 0.08
        muscle_burst_end = np.random.uniform(-0.4,0.4,size=200) + 0.08
        emg_signal = np.concatenate([emg_signal,muscle_burst_start,muscle_burst_midstart,muscle_burst,muscle_burst_midend,muscle_burst_end,rest])
    return emg_signal


def correct_means(raw_signal):
    return raw_signal - np.mean(raw_signal)


def generate_time_stamps(raw_signal):
    time_array = []
    for i in range(0,len(raw_signal),1):
        i = i/1000
        time_array.append(i)
    return np.array(time_array)

# linear butterworth filter for emg 
def bandpass_filter(mean_corrected_signal):
    high = 20/(1000/2)
    low = 450/(1000/2)
    
    print ("High :" + str(high)  + " Low :" + str(low))
    b, a = sp.signal.butter(4,[high,low],btype='bandpass')
    return sp.signal.filtfilt(b, a, mean_corrected_signal) 


if __name__ == "__main__":
    
    raw_signal = generate_signal(3)
    mean_corrected_signal = correct_means(raw_signal)
    filtered_emg = bandpass_filter(mean_corrected_signal)
    rectified_emg = abs(filtered_emg)
    
    
    time_array = generate_time_stamps(raw_signal)
    
    fig = plt.figure()
    plt.subplot(3,1,1)
    plt.subplot(3,1,1).set_title('Raw signal')
    plt.plot(time_array,raw_signal,color='green')
    plt.xlabel('sec')
    plt.ylabel('emg') 
    
    plt.subplot(3,1,2)
    plt.subplot(3,1,2).set_title('Filtered EMG signal')
    plt.plot(time_array,filtered_emg,color='red')
    plt.xlabel('sec')
    plt.ylabel('emg')
    
    
    plt.subplot(3,1,3)
    plt.subplot(3,1,3).set_title('Rectified EMG signal')
    plt.plot(time_array,rectified_emg,color='red')
    plt.xlabel('sec')
    plt.ylabel('emg')
    fig.set_size_inches(w=25,h=20)
    
    fig.savefig('comparison.png')