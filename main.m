
clear all;
close all;
clc

global vector_length;
global setup_t;
global hold_t;
global min_eye_opening;
global unres_val;

unres_val=-1; % -1/ 'prev'
setup_t=1; % *6.4ps
hold_t=1; % *6.4ps
min_eye_opening=10; %[mV]
vector_length=1600;
input_bytes=200;   % number of imput bytes
input_bits=input_bytes*8;
over_sampling = 16;
freq = 10^10;     % 10GHz
T = 1/freq;       % 0.1ns
   % number of imput bits
time = (0:T/over_sampling:T*input_bits-(T/over_sampling));
clk_ideal=clk_ideal_gen(input_bits,over_sampling);
%plot(time,clk_ideal)

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

%plot(time,clk_ideal*300,time,driv_data)

%---------------------Channel---------------------------------------------%

channel_data = channel(driv_data)';
%# for i=2:vector_length
%	# if(abs(driv_data(i)-driv_data(i-1))>=100)
%		# clk_tst(i)=1;
%	# end
%# end

%---------------------Clock_Recovery--------------------------------------%

clk_out=clock_recovery(clk_in,t_clk);

%---------------------Data_Recovery---------------------------------------%


[data, min_eye300_100, min_eye100_100, min_eye100_300, setup, hold, eyem300_100, eye100_100, eye100_300] = data_recovery(channel_data, clk_out);

error=0;
k=1;
data_b=[,];
for i=1:8:(length(input_data)-8)
    data_b(:,k )=data(i:i+8);
    if~(isequal(data_b(:,k ), input_data(:, k)))
        error=error+1;
    end   
    k=k+1;
end
% %---------------------Dodatki---------------------------------------------%

figure
plot(time, driv_data, time, channel_data,  time, (clk_out-0.5)*600);
ylabel('data driver, channel, clock');

% figure
% plot(driv_data(1:500))
% ylabel('driver data');
% eyediagram(driv_data, 32, 100)

% figure
% plot(channel_data(1:500))
% ylabel('channel data');
% eyediagram(channel_data, 32, 100)

% figure
% plot(data)
% ylabel(' data recovered');

