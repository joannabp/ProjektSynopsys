function channel_data = channel(driv_data);
global vector_length;

format long
d=7;
Cp=34.06e-12;
Rp=36.2e-3;
Lp=5.06e-12;
C=Cp*d;
R=Rp*d;
L=Lp*d;



%syms s

w = logspace(0,20,32);
% 
 b=[1];
 a=[1  R*C*i*w]
H = 1 ./ (1 + j*w*R*C); 
 
subplot(2,1,1)
semilogx(w,20*log10(abs(H)))
title('Bode Plot for a very simple H(j\omega)');
ylabel('Magnitude (dB)')

% subplot(2,1,2)
% semilogx(w, 180/pi * unwrap(angle(H)))
% xlabel('Frequency (Hz)'), ylabel('Phase (degrees)')
% hold on
% 
% H = L*j*w ./ (R + j*w*L);
% subplot(2,1,1)
% semilogx(w,20*log10(abs(H)))
% title('Bode Plot for a very simple H(j\omega)');
% ylabel('Magnitude (dB)')

subplot(2,1,2)
semilogx(w, 180/pi * unwrap(angle(H)))
xlabel('Frequency (Hz)'), ylabel('Phase (degrees)')

%c=tf(a, b);
%H=freqs(b, a, w);
% bode(c);
% figure
% mag = abs(H); 
% phase = angle(H);
% subplot(2,1,1), loglog(w,mag)
% subplot(2,1,2), semilogx(w,phase)

%channel_data=driv_data;

% 
% Size =50; 
% b = (1/Size)*ones(1,Size);
% a = 1;


% H=(1/Size)*j*w ./ a;
% 
% subplot(2,1,1)
% semilogx(w,20*log10(abs(H)))
% title('Bode Plot for a very simple H(j\omega)');
% ylabel('Magnitude (dB)')
% 
% subplot(2,1,2)
% semilogx(w, 180/pi * unwrap(angle(H)))
% xlabel('Frequency (Hz)'), ylabel('Phase (degrees)')
%channel_data = filter(b, a, driv_data);

Fs=1;
% Default to allpass if invalid type is selected
b = [ 1 0 ];
a = [ 1 0 ];

% Constants
RC = R * C;
T  = 1;

% Analog Cutoff Fc
w = 1 / (RC);

% Prewarped coefficient for Bilinear transform
a = exp(-2e-12/(RC))

b=[1-a]
a=[1 -a]

    
  
channel_data = filter(b, a, driv_data);

