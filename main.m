
clear all;
close all;
clc

global vector_length;
global setup_t;
global hold_t;
global min_eye_opening;
global unres_val;
global over_sampling;
global T;

unres_val=-1; % -1/ 'prev'

min_eye_opening=10; %[mV]
vector_length=2000;


dlugosc_kanalu = 10;
input_bytes=200;   % number of imput bytes

input_bits=input_bytes*8;
over_sampling = 50;
freq = 10^10;     % 10GHz
T = 1/freq;       % 0.1ns
   % number of imput bits
time = (0:T/over_sampling:T*input_bits-(T/over_sampling));
clk_ideal=clk_ideal_gen(input_bits,over_sampling);
setup_t=4*T; % *2ns
hold_t=4*T; % *2ns
% figure
% plot(time,clk_ideal)

t_clk=31;
start=31;
clk_in = clk_gen(t_clk,start);
%clk_tst=zeros(1,vector_length);



input_data = zeros(8,input_bytes);

for j=1:size(input_data,2)
    for i=1:size(input_data,1)
        input_data(i,j) = randi([0 1], 1, 1);
    end
end

%---------------------Driver----------------------------------------------%

driv_data = driv_script(input_data,clk_ideal);

vector_length=length(driv_data);

%---------------------Channel---------------------------------------------%


channel_data1 = channel(driv_data);
channel_data = channel(channel_data1);
%channel_data = channel(channel_data2);
%# for i=2:vector_length
%	# if(abs(driv_data(i)-driv_data(i-1))>=100)
%		# clk_tst(i)=1;
%	# end
%# end

%---------------------Clock_Recovery--------------------------------------%

clk_out=clock_recovery(clk_in,t_clk);

%---------------------Data_Recovery---------------------------------------%

clk_zero=[];
clk_zero(1:75)=0;
clk_ideal=[clk_zero clk_ideal];

[data, min_eye300_100, min_eye100_100, min_eye100_300,setup_200, setup0, setup200, hold_200, hold0, hold200, eyeO1, eyeO2, eyeO3] = data_recovery(channel_data, clk_ideal,T);     

error=0;
k=1;
c=1;
data_b=[,];
for i=1:8:input_bits-8
    data_b(:,k )=data(i:i+7);
    if~(isequal(data_b(:,k ), input_data(:, k)))
       % error=error+1;
    end  
    data_c(c:c+7)=input_data(:, k);
    c=c+8;
    k=k+1;
end



for i=1:input_bits-8
    if~(data_c(i)==data(i))
        error=error+1;
    end
end
% %---------------------Dodatki---------------------------------------------%

figure
plot(time, driv_data, time, channel_data, time, clk_ideal(1:80000)*50);
ylabel('data driver, channel, clock');
figure
for i=1:length(driv_data)/over_sampling/3
    plot(-over_sampling:over_sampling-1, driv_data(over_sampling/2+1+3*over_sampling*(i-1):3*over_sampling*(i) -over_sampling/2));
    hold on
end


figure
for i=1:length(channel_data)/over_sampling/3
    plot(-over_sampling:over_sampling-1, channel_data(over_sampling/2+1+3*over_sampling*(i-1):3*over_sampling*(i) -over_sampling/2)) ;
    hold on
end



figure
plot(data)
ylabel(' data recovered');
% setup=setup';
% holdd=holdd';
