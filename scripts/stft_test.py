import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import ShortTimeFFT
from scipy.signal.windows import gaussian


def heart_rate(data, window_size):
    rates = []
    for i in range(window_size//2, len(data)-window_size//2):
        average = np.mean(data[i-window_size//2:i+window_size//2])
        rates.append(60/average)

    return np.array(rates)

data = np.array([0.87241524, 0.9059697, 0.855638, 0.8220836, 0.8472494, 0.79691774, 0.81369495, 0.855638, 0.7633633, 0.77175194, 0.7633633, 0.8640266, 0.8388608, 0.8640266, 0.7633633, 0.8388608, 0.8304722, 0.8304722, 0.7549747, 0.8472494, 0.7549747, 0.7465861, 0.7633633, 0.87241524, 0.7801405, 0.8472494, 0.8220836, 0.8472494, 0.8220836, 0.7465861, 0.8304722, 0.78852916, 0.7801405, 0.72980887])

for w in [3,5,7,9,11,13]:
    hr = heart_rate(data, w)
    x = np.arange(w//2, len(data)-w//2)
    plt.plot(x, hr, label=w)
plt.legend()
plt.show()