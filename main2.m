

clear all;
close all;
clc
 tic
profile on
global vector_length;
global setup_t;
global hold_t;
global min_eye_opening;
global unres_val;
global over_sampling;
global freq;     % 10GHz
global EUI;      % 0.002ns
global T;        % 0.1ns 
global thr;
global t0;
global f0;
global train_ena;
global input_bits;

vector_length=100000;
%time = (0:T/over_sampling:T*input_bits-(T/over_sampling));
time=zeros(1,vector_length*over_sampling);
for i=2:vector_length*over_sampling
  time(i)=time(i-1)+EUI/over_sampling;
end

freq = 10^10;     % 10GHz
T = 1/freq;       % 0.1ns
EUI=T/50;         % 2ps
over_sampling=400;  %EUI/400 - najm. krok czasowy
input_bytes=100;   % number of imput bytes
input_bits=input_bytes*8;
thr=0.5;

unres_val=-1; % -1/ 'prev'
train_ena=1;
min_eye_opening=10; %[mV]
dlugosc_kanalu = 10;


setup_t=2*T/100; % *2ns
hold_t=2*T/100; % *2ns

t0=[54,52,50,48,46];
f0=zeros(1,5);
for i=1:5
    f0(i)=T/t0(i)*freq/EUI;
end

%------------------------------ do clock_recovery--------------%
% 
% 
% 
% 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

input_data=generate_binary_data(input_bytes, 'none');

input_bits=numel(input_data);
%clk_ideal=clk_ideal_gen(input_bits,over_sampling);
vector_length2=round(vector_length*EUI*4/T);
%time = (0:T/over_sampling:T*input_bits-(T/over_sampling));


%---------------------Driver----------------------------------------------%

[clk,t_clk,f_clk,~,~]=clk_gen_f_not_id5(freq,0,vector_length,0,vector_length2);
driv_data = driv_script(input_data,clk);

vector_length=length(driv_data);

%---------------------Channel---------------------------------------------%


channel_data = channel(driv_data);
eq_dat=ctle(channel_data, 5e8, 6e9, 12e9, 13, -10); % (signal, fz, fp1, fp2, HFboost, DCgain)
 
%---------------------Data_Recovery---------------------------------------%

% clk_zero=[];
% clk_zero(1:50)=0;
% clk_ideal=[clk_zero clk_ideal];
% clk_zero_s(1:70)=0;
% clk_shf=[clk_zero_s clk_ideal];

%[data, slope_sampled, min_eye300_100, min_eye100_100, min_eye100_300,setup_200, setup0, setup200, hold_200, hold0, hold200, eyeO1, eyeO2, eyeO3, wf] = data_recovery(eq_dat, clk_ideal,clk_shf);% clk_shf);     
[data, slope_sampled, min_eye300_100, min_eye100_100, min_eye100_300,setup_200, setup0, setup200, hold_200, hold0, hold200, eyeO1, eyeO2, eyeO3, wf]=cdr_prob(eq_dat);

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
        i
    end
end


% %---------------------Dodatki---------------------------------------------%


% % figure
% % plot(time, driv_data, time, eq_dat, time, clk(1:numel(driv_data));%, time, clk(1:numel(clk_shf)-120)*10);
% % ylabel('data driver, channel, clock');
% figure
% for i=1:length(driv_data)/over_sampling/3
%     plot(-over_sampling:over_sampling-1, driv_data(over_sampling/2+1+3*over_sampling*(i-1):3*over_sampling*(i) -over_sampling/2));
%     hold on
% end
% 
% 
% figure
% for i=1:length(channel_data)/over_sampling/3
%     plot(-over_sampling:over_sampling-1, channel_data(over_sampling+1+3*over_sampling*(i-1):3*over_sampling*(i) )) ;
%     hold on
% end
% 
% figure
% for i=1:length(eq_dat)/over_sampling/3
%     plot(-over_sampling:over_sampling-1, eq_dat(over_sampling+1+3*over_sampling*(i-1):3*over_sampling*(i) )) ;
%     hold on
% end
% 
% figure
% plot(data)
% ylabel(' data recovered');
% % setup=setup';
% % holdd=holdd';
% toc;
% profile off
