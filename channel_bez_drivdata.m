
LineLength=1;
z = LineLength;

%attenuation
r0 = 1.72e-6;
er = 1;
f=5; %czestotliwosc
w=2*3.14*f; %omega
u=1; %przenikalnosc magnetyczna

alpha = sqrt((w*u*r0)/2); %wspolczynnik tlumienia

z = 1:0.01:10;
for i = 1:length(z)
    
    E(i)=100*exp((-1)*alpha*i); 

end

channel_data = E;
plot(channel_data);
