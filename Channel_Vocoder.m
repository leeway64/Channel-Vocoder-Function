function [vocoded_speech, sampling_freq] = Channel_Vocoder(input_signal, bands, noise)
% This function returns a vocoded signal, based on the user designated
% input signal and the number of bands. The user can also decide to turn
% the vocoder into a noise vocoder.
% This function also plays the vocoded sound back, so the user can hear
% what the result sounds like.

% Inputs
% input_signal: .wav file you want to vocode
% bands: number of frequency bands
% noise: whether or not you want to turn the vocoder into a noise vocoder

% Outputs:
% vocoded_speech: the sound signal that has been vocoded. It should sound
% like a robotic voice
% sampling_freq: the sampling frequency of input_signal

    [y, Fs] = audioread(input_signal);
    sampling_freq = Fs;
    % sound(y, Fs);
    freq_bands = bands_cutoff(300, 6000, bands);
    vocoded_speech = zeros(length(y), 1);
    N = length(freq_bands);
    t =(0:length(y)-1)./Fs; % creating a time vector
    
    for j = 1:N - 1

        % Create Butterworth filter and apply it to input signal
        [BB, AA] = butter(3, [freq_bands(j), freq_bands(j+1)]./(Fs/2)); % 3rd order band-pass filter
        BPF_1 = filter(BB, AA, y);
        
        
%         % Plot various frequency responses of the band-pass Butterworth filter
%         subplot(N-1, 1, j);
%         [H,F]=freqz(BB,AA,256,Fs); % Fs is the sampling frequency
%         plot(F,abs(H));
%         title(['Frequency response of band-pass filter (', num2str(freq_bands(j)), ' Hz to ', num2str(freq_bands(j+1)), ' Hz)']);
%         xlabel('Frequency (Hz)'); ylabel('Magnitude');
        
        % Rectify signal by finding its absolute value
        rectified_signal = abs(BPF_1);

        % Create low-pass filter and apply it to rectified signal
        % This will detect the envelopes. 
        [bb, aa] = butter(2, 400/(Fs/2), 'low'); % 2nd order low-pass filter
        
        % Plot frequency response of the low-pass filter
%         [H,F]=freqz(bb,aa,256,Fs); % Fs is the sampling frequency
%         plot(F,abs(H));
%         title(['Frequency response of low-pass filter (cutoff frequency: 400 Hz)']);
%         xlabel('Frequency (Hz)'); ylabel('Magnitude');
        
        LPF = filter(bb, aa, rectified_signal);

%         %Plot the envelopes.
%         subplot(N-1,1,j);
% %         plot(rectified_signal);
%         plot(t, LPF);
%         title(['Envelope of signal for band ', num2str(j), ' (', num2str(freq_bands(j)), ' Hz to ', num2str(freq_bands(j+1)), ' Hz)']);
%         xlabel('Time (s)'); ylabel('Magnitude');
        
        % Create modulating signal (sine wave) and multiply it to low-pass
        % filtered signal
        if strcmp(noise, 'noise')
            modulated_signal = rand(length(y), 1) .* LPF;
        else
            t =(0:length(y)-1)./Fs; % creating a time vector
            Fc = (freq_bands(j) + freq_bands(j+1))/2; % Find center frequency of frequency band
            tone_carrier = sin(2*pi*Fc*t); % Modulating signal
            modulated_signal = LPF .* tone_carrier';
        end       
        
        % Filter the modulated signal with the original band-pass filter
        z = filter(BB, AA, modulated_signal);
        vocoded_speech = z + vocoded_speech;
        
%         % Plot the waveforms of the modulated signals
%         subplot(N-1, 1, j);
%         plot(t, z)
%         title(['Modulated signal for band ', num2str(j), ' (', num2str(freq_bands(j)), ' Hz to ', num2str(freq_bands(j+1)), ' Hz)']);
%         xlabel('Time (s)'); ylabel('Magnitude');
        
    end

    vocoded_speech = vocoded_speech./max(abs(vocoded_speech));
    
% %     Plot original and vocoded signal
%     subplot(2,1,1)
%     plot(t, vocoded_speech);
%     title('Vocoded signal vs. time');
%     xlabel('Time (s)'); ylabel('Sound');
%     
%     subplot(2,1,2)
%     plot(t, y)
%     title('Original signal vs. time');
%     xlabel('Time (s)'); ylabel('Sound');
    
    sound(vocoded_speech, Fs);
end