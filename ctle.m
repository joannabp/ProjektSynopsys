%channel
close all
clear all

d=15;
Cp=34.06e-12;
Rp=36.2e-3;
Lp=5.06e-12;
C=Cp*d;
R=Rp*d;
L=Lp*d;



%syms s

w = logspace(0,13, 500);
% 
 b=[1 ];
 a=[1  R*C*i*w];
%Hch = (1 + j*w*10e-11).*(1 + j*w*4e-11)./ ((1 + j*w*R*C).*(1 + j*w*15e-10).*(1 + j*w*2e-12)); 
 
Hch = 1./ (1 + j*w*R*C); 


fz=5e8;
fp1=1.5e9;
fp2=6e9;
wz=fz*pi*2;
wp1=fp1*pi*2;
wp2=fp2*pi*2;

b=[1 wz];
a0=[1 wp1];
a1=[1 wp2];
a=conv(a0, a1);

DCg=-3;
wp1=(DCg/2)*wz;
HFb=wp1/wz;
gmCp=wp2*10^(DCg/20)*HFb;
Hct =gmCp* (j*w +wz)./((j*w +wp1).*(j*w +wp2));

figure
semilogx(w/(2*pi),20*log10(abs(Hct)), 'color',[1 0 0])
title('Bode Plot for a very simple H(j\omega)');
ylabel('Magnitude (dB)')
xlabel('Frequency [Hz]')
hold on

semilogx(w/(2*pi),20*log10(abs(Hch)),'color',[0 0 0])
title('Bode Plot for a very simple H(j\omega)');
ylabel('Magnitude (dB)')

semilogx(w/(2*pi),(20*log10(abs(Hch)) +20*log10(abs(Hct))))


hold off

