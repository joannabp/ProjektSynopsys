

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
global T;
global train_ena;
global thr;
global input_bits;
train_ena=1;

unres_val=-1; % -1/ 'prev'

min_eye_opening=10; %[mV]
vector_length=2000;


dlugosc_kanalu = 10;
input_bytes=100;   % number of imput bytes

input_bits=input_bytes*8;
over_sampling = 100;
freq = 10^10;     % 10GHz
T = 1/freq;       % 0.1ns
   % number of input bits
%time = (0:T/over_sampling:T*input_bits-(T/over_sampling));
clk_ideal=clk_ideal_gen(input_bits,over_sampling);
setup_t=2*T/over_sampling; % *2ns
hold_t=2*T/over_sampling; % *2ns

% figure
% plot(time,clk_ideal)

t_clk=31;
start=31;
clk_in = clk_gen(t_clk,start);
%clk_tst=zeros(1,vector_length);



%------------------------------ do clock_recovery--------------%

global EUI;        % 0.1ns
global acc_size;
global nonsignificant_bits;

EUI=T/50;

vector_length=400000;
vector_length2=round(vector_length*EUI*4/T);
thr=0.5;
%over_sampling=400;

acc_size=14;
nonsignificant_bits=acc_size-10;
delay=10;

time=zeros(1,vector_length*over_sampling);
for i=2:vector_length*over_sampling
  time(i)=time(i-1)+EUI/over_sampling;
end

t0=[54,52,50,48,46];
f0=zeros(1,5);
for i=1:5
    f0(i)=T/t0(i)*freq/EUI;
end

[clk,t_clk,f_clk,~,~]=clk_gen_f_not_id5(freq,0,vector_length,0,t0,f0,vector_length2)

t_diff=zeros(1,vector_length2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

input_data=generate_binary_data(input_bytes, 'none');

input_bits=numel(input_data);
clk_ideal=clk_ideal_gen(input_bits,over_sampling);
time = (0:T/over_sampling:T*input_bits-(T/over_sampling));


%---------------------Driver----------------------------------------------%

driv_data = driv_script(input_data,clk);

vector_length=length(driv_data);

%---------------------Channel---------------------------------------------%


channel_data = channel(driv_data);
 eq_dat=ctle(channel_data, 5e8, 6e9, 12e9, 13, -10); % (signal, fz, fp1, fp2, HFboost, DCgain)
 
%  t0=[212,210,208,206,204,202,200,198,196,194,192,190];
% f0=zeros(1,12);
% for i=1:12
%     f0(i)=200/t0(i)*freq;
% end
% 
% clk=clk_gen_f_not_id3(freq,0,length(driv_data),0,t0,f0,input_bits)

% channel_data2 = channel(channel_data1);
% channel_data = channel(channel_data2);
%# for i=2:vector_length
%	# if(abs(driv_data(i)-driv_data(i-1))>=100)
%		# clk_tst(i)=1;
%	# end
%# end

%---------------------Clock_Recovery--------------------------------------%

%clk_out=clock_recovery(clk_in,t_clk);

%---------------------Data_Recovery---------------------------------------%

% clk_zero=[];
clk_zero(1:50)=0;
clk_ideal=[clk_zero clk_ideal];
clk_zero_s(1:70)=0;
clk_shf=[clk_zero_s clk_ideal];

%[data, slope_sampled, min_eye300_100, min_eye100_100, min_eye100_300,setup_200, setup0, setup200, hold_200, hold0, hold200, eyeO1, eyeO2, eyeO3, wf] = data_recovery(eq_dat, clk_ideal,clk_shf);% clk_shf);     
[data, slope_sampled, min_eye300_100, min_eye100_100, min_eye100_300,setup_200, setup0, setup200, hold_200, hold0, hold200, eyeO1, eyeO2, eyeO3, wf]=cdr_prob(eq_dat, clk);

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
% 
% figure
% plot(time, driv_data, time, eq_dat, time, clk(1:numel(driv_data));%, time, clk(1:numel(clk_shf)-120)*10);
% ylabel('data driver, channel, clock');
figure
for i=1:length(driv_data)/over_sampling/3
    plot(-over_sampling:over_sampling-1, driv_data(over_sampling/2+1+3*over_sampling*(i-1):3*over_sampling*(i) -over_sampling/2));
    hold on
end


figure
for i=1:length(channel_data)/over_sampling/3
    plot(-over_sampling:over_sampling-1, channel_data(over_sampling+1+3*over_sampling*(i-1):3*over_sampling*(i) )) ;
    hold on
end

figure
for i=1:length(eq_dat)/over_sampling/3
    plot(-over_sampling:over_sampling-1, eq_dat(over_sampling+1+3*over_sampling*(i-1):3*over_sampling*(i) )) ;
    hold on
end

figure
plot(data)
ylabel(' data recovered');
% setup=setup';
% holdd=holdd';
toc;
profile off
