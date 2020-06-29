# EMG-noise-filter
Simple filter for EMG signals written in Python 3.

## Covering Dependencies and Usage
To install the required libraries and run the script using the sample provided run the following commands.



### To run the python version of the script without the ADC converter
```bash

pip3 install -r requirements.txt
python3 emg-filter.py
```

### To run the Octave version of the script (implements the ADC)
Inside the octave command line
```
pkg load signal
emg-filterm-octave.m
```
### To run the MATLAB version of the script (implements the ADC)

Load the script (emg_filter_matlab.m) on the current matlab workspace and press run.

### To simulate the VHDL execution using ModelSim

Install ModelSim following the below instructions

https://www.intel.com/content/www/us/en/programmable/support/support-resources/software/download/eda_software/modelsim/ins-modelsim-56a.html
If you are on a Linux distribution keep in mind that ModelSim is amazingly buggy, and may require personall work to get it to work.

Hope this might be helpfull 

https://mil.ufl.edu/3701/docs/quartus/linux/ModelSim_linux.pdf



## Contributors
- Kalaitzidis Angelos Taxiarchis ``OxShad3``
- Konstantinides Loukas
- Lifousi Anna 

### Disclaimer
This script is part of a project assigned to us as a team in the Embedded Systems class, **under no circumstances consider this professional or application solid work**. 
