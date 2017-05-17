function sygnal_wyjsciowy = szum(signal, targetSNR)
signalLength = length(signal);
awgnNoise = randn(size(signal)); %szum oryginalny
powerSignal = sqrt(sum(signal.^2))/signalLength; %si³a sygna³u
powerNoise = sqrt(sum(awgnNoise.^2))/signalLength; %si³a szumu

if targetSNR ~= 0
    scaleFactor = (powerSignal/powerNoise)/targetSNR;
    awgnNoise = scaleFactor*awgnNoise; 
    sygnal_wyjsciowy = signal + awgnNoise; % add noise
else
   sygnal_wyjsciowy = awgnNoise; %sam szum
end