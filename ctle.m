function eq_data = ctle(input_vector);


fz=0.5e10;
fp1=8e10;
fp2=12e10;

b = [1 2*3.14*fz];
 a0 = [1 2*3.14*fp1];
 a1 = [1 2*3.14*fp2];
 a=conv(a0,a1);
% w = logspace(-1,20);
% h=freqs(b,a,w);
% 
% mag = abs(h); 
% phase = angle(h);
% subplot(2,1,1), loglog(w,mag)
% subplot(2,1,2), semilogx(w,phase)

eq_data =filter(b, a, input_vector);
% figure
% plot(filtered_data(1:500))
% ylabel('filtered_data');
