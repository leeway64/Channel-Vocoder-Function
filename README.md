# Speech Synthesizer: Channel Vocoder Function
This project created a channel vocoder function in MATLAB that could synthesize “robotic” sounding speech according to a user-designated sound file.

The channel vocoder is a method of altering a sound signal by band-pass filtering the modulator signal (the input) and the carrier signal, and then multiplying the modulator and the carrier signals together. The results are summed with the products of other frequency bands.

The channel vocoder can be used to create a robotic voice, which is used extensively as a sound effect. Another application is found in the realm of biomedical devices. To simulate what hearing speech is like for people with cochlear implants, the channel vocoder can be used.

This project is from the course BEE 235. I would like to credit UW Bothell professor Dr. Kaibao Nie for providing the specifications for the project, along with the "bands_cutoff.m" function.


# Summary of theory of operation

![Filter bank](https://github.com/leeway64/Channel-Vocoder-Function/blob/master/Filter%20Bank.jpg)

First, the input signal is divided into various frequency bands by applying a different band-pass filter for each frequency band; the frequency bands of the filter is determined by the function bands_cutoff.m. For each frequency band, the absolute value is taken, and then a low-pass filter is applied. A sinusoidal signal is multiplied onto the result, and then another band-pass filter is applied. Finally, the results for each frequency band is summed with each other to produce the vocoded sound.

Note that the MATLAB function that implements the vocoder is "Channel_Vocoder.m".
