function channel_data = channel(driv_data);
global vector_length;

d=100;
Cp=34.06e-12;
Rp=36.2e-3;
C=Cp*d;
R=Rp*d;



%syms s

%h1=1/((R*C*s+1)*(R2*C2*s+1)*(R*C*s+1))
w = logspace(0,20,128);
% 
% format long
%  b=[1];
%  a=[1 1/(R*C)];





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
Size =50; 
b = (1/Size)*ones(1,Size);
a = 1;


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
channel_data = filter(b, a, driv_data);

%  channel_data = filter(b,a,channel_data1);
% channel_data3 = filter(b,a,channel_data2);
% channel_data = filter(b,a,channel_data3);
% 1 dla 65
% 37
% 124
% 37
% 1

% 1 dla 40
% 14
% 172
% 14
% 1
