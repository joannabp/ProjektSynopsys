
% d=0.001;
% Lp=1.06e-6;
% Cp=34.06e-12;
% Rp=36.2e-3;
% Gp=1/(256e6);
% Zl=8;
% f=2e10;
% w=2*3.14*f;
% 
% L=Lp*d;
% C=Cp*d;
% R=Rp*d;
% G=Gp*d;
% 
% s = tf('s'); 
% Xp=((Zl*1/G)/(Zl+1/G));
% Ck=1/(s*C);
% X=Xp*Ck/(Xp+Ck);
% Y=s*w*L+R;
% 
% t=R*C;
%  h1=1/(t*s+1);
% a=[1];
% b=[t  1];
% w = logspace(-1,20);
% c=tf(a, b);
% H=freqs(a,b, w);
% 
% bode(c);
% figure
% mag = abs(H); 
% phase = angle(H);
% subplot(2,1,1), loglog(w,mag)
% subplot(2,1,2), semilogx(w,phase)

% d=50;
% Cp=34.06e-12;
% Rp=36.2e-3;
% C=Cp*d;
% R=Rp*d;
% 
% R2=Rp*0.7*d;
% C2=Cp*0.7*d;
% 
% b=[1.435e-26 1.881e-17 7.675e-09 1]
% 
% h1=1/((R*C*s+1)*(R2*C2*s+1)*(R*C*s+1))

clear all;
close all;
display('LMS DFE');
N=10000; %length of the sequence
h=[0 3.2 81 15.5  2.8 0];  % channel impulse response
miu=0.05;%adaptation step
size_feed=3;
d= (randn(N, 1)>0)*2-1;  % Random bipolar (-1, 1) sequence;
d=d*100;
ah=conv(h, d);
v= sqrt(0.001)*randn(N, 1);  % Gaussian noise with variance 0.001;
u=ah(1:N)+v;
wf=zeros(size_feed, 1);
sample = zeros(1, size_feed);
for i=1:N
    x(i)=sample*wf;
    w(i)=u(i)-x(i);
    z(i)= sign(w(i));
    e(i)= w(i)-z(i);
    %e(i)=z(i)-w(i);
    wf=wf+miu*e(i)*sample';
    sample = [ z(i) sample(1:end-1)];
end
