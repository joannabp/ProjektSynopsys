function channel_data = channel(LineLength,driv_data)

z = LineLength;

%attenuation
r0 = 1.72e-6;
er = 1;
f=14; %czestotliwosc
w=2*3.14*f; %omega
u=1; %przenikalnosc magnetyczna

alpha = sqrt((w*u*r0)/2); %wspolczynnik tlumienia
z = 10;
%z = 1:0.01:10;
for i = 1:length(driv_data)
    
    out_data(i)=driv_data(i)*exp((-1)*alpha*z); 

end

channel_data = out_data;
plot(channel_data);
