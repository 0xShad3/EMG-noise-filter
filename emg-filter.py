import numpy as np
import matplotlib.pyplot as plt
import scipy as sp
from scipy import signal

# to simulate an emg signal with 2 bursts
# normalized values to test including the noise
def generate_signal():
    muscle_burst1_start = np.random.uniform(-0.4,0.4,size=200) + 0.08
    muscle_burst1_midstart = np.random.uniform(-0.8,0.8,size=200) + 0.08
    muscle_burst1 = np.random.uniform(-0.95,0.95,size=300) + 0.08
    muscle_burst1_midend = np.random.uniform(-0.8,0.8,size=200) + 0.08
    muscle_burst1_end = np.random.uniform(-0.4,0.4,size=200) + 0.08

    muscle_burst2_start = np.random.uniform(-0.4,0.4,size=200) + 0.08
    muscle_burst2_midstart = np.random.uniform(-0.8,0.8,size=200) + 0.08
    muscle_burst2 = np.random.uniform(-0.95,0.95,size=300) + 0.08
    muscle_burst2_midend = np.random.uniform(-0.8,0.8,size=200) + 0.08
    muscle_burst2_end = np.random.uniform(-0.4,0.4,size=200) + 0.08
    # set frequency of the samplirate at 1000hz
    rest = np.random.uniform(-0.07,0.07,size=1000) + 0.08
    emg_signal = np.concatenate([rest,muscle_burst1_start,muscle_burst1_midstart,muscle_burst1,muscle_burst1_midend,muscle_burst1_end,rest,muscle_burst2_start,muscle_burst2_midstart,muscle_burst2,muscle_burst2_midend,muscle_burst2_end,rest])
    return emg_signal


def correct_means(raw_signal):
    return raw_signal - np.mean(raw_signal)


def generate_time_stamps(raw_signal):
    time_array = []
    for i in range(0,len(raw_signal),1):
        i = i/1000
        time_array.append(i)
    return np.array(time_array)




if __name__ == "__main__":
    
    raw_signal = generate_signal()
    mean_corrected_signal = correct_means(raw_signal)
    time_array = generate_time_stamps(raw_signal)
    fig = plt.figure()
    plt.plot(time_array,mean_corrected_signal)
    plt.xlabel('sec')
    plt.ylabel('emg')
    fig.set_size_inches(w=11,h=7)
    fig.savefig('fig2.png')