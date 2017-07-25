%channel

function eq_data=ctle(input_vector, fz, fp1, fp2, HFboost, DCgain);


d=9;
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


% fz=5e8;
% fp1=1.5e9;
% fp2=6e9;
 wz=fz*pi*2;
 wp1=fp1*pi*2;
 wp2=fp2*pi*2;

if(HFboost==0)
   
    
    HFboost=20*log10(wp1/wz);
    

    
else
    wz=wp1/(10^(HFboost/20));
    
end



gmCp=wp2*10^(DCgain/20)*(10^(HFboost/20));
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


T=2e-12;
% Tfa=2/T;

% b=[Tfa+wz 2*wz wz-Tfa];
% a=[(Tfa^2+Tfa*(wp1-wp2)+wp1*wp2) (-2*Tfa^2+2*wp1*wp2) (Tfa^2-Tfa*(wp1+wp2)+wp1*wp2)];
% 
% b=gmCp*b/a(1);
% a=a/a(1);

b=gmCp*[0 1/T wz-1/T];

a0=[1/T wp1-1/T];
a1=[1/T wp2-1/T];
a=conv(a0, a1);
b=b/a(1);
a=a/a(1);
eq_data=filter(b,a, input_vector);





