%function eq_data = ctle(input_vector);


fz=5e9;
fp1=8e10;
fp2=12e10;
wz=fz*3.14*2;
wp1=fp1*3.14*2;
wp2=fp2*3.14*2;

b=[1 wz];
a0=[1 wp1];
a1=[1 wp2];



% b = [1 2*3.14*fz];
%  a0 = [1 2*3.14*fp1];
%  a1 = [1 2*3.14*fp2];
%  a=conv(a0,a1);
% d=1;
% Cp=34.06e-12;
% Rp=36.2e-3;
% Lp=5.06e-9;
% C=Cp*d;
% R=Rp*d;
% L=Lp*d;
% 
% b=[1 -1];
% a=[1 -1/exp(R/L)];
%  
% %  b0=a*exp(b)*(b-w)+w*exp(b)*(a-b)+b*exp(a)*(w-a);
% % b1=a*exp(b)*(w-b)+w*(b-a)+b*exp(a)*(a-w);
% % 
% % 
% % a0=a^2*b*exp(b)-b^2*a*exp(b);
% % a1=a^2*b+b^2*a;
% % 
% % 
% % a1=a1/a0;
% % b0=b0/a0;
% % b1=b1/a0;
% % ac=[1 a1];
% % bc=[b0 b1];
%  eq_data =filter(b, a, input_vector);
% %  w = logspace(0,20,32);
% %  
% %  
% %  H = (bc(1)+j*w*bc(2)) ./ (ac(1)+ j*w*ac(2)); 
% %  
% % subplot(2,1,1)
% % semilogx(w,20*log10(abs(H)))
% % title('Bode Plot for a very simple H(j\omega)');
% % ylabel('Magnitude (dB)')
% % 
% % subplot(2,1,2)
% % semilogx(w, 180/pi * unwrap(angle(H)))
% % xlabel('Frequency (Hz)'), ylabel('Phase (degrees)')
% 
% % w = logspace(-1,20);
% % h=freqs(b,a,w);
% % 
% % mag = abs(h); 
% % phase = angle(h);
% % subplot(2,1,1), loglog(w,mag)
% % subplot(2,1,2), semilogx(w,phase)
% 
% 
% % figure
% % plot(filtered_data(1:500))
% % ylabel('filtered_data');
