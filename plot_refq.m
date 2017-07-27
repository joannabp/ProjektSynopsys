w = logspace(0,4,128);
H = 100 ./ (100 + j*w); % j is a builtin Matlab constant = sqrt(-1)
% Plot the magnitude and phase
subplot(2,1,1)
semilogx(w,20*log10(abs(H)))
title('Bode Plot for a very simple H(j\omega)');
ylabel('Magnitude (dB)')

subplot(2,1,2)
semilogx(w, 180/pi * unwrap(angle(H)))
xlabel('Frequency (Hz)'), ylabel('Phase (degrees)')