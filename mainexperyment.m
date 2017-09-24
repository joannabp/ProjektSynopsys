

clear all;
close all;
clc

%--------- common -----%%
global vector_length;
global input_bits;
global freq_mid;     % 10GHz
global freq;
global UI_probes_mid;      % 0.002ns
global UI_probes;
global T_mid;
global T;

dlugosc_kanalu = 10;
input_bytes=3000;   % number of input bytes for clk sync
input_bits=input_bytes*8;

freq_mid = 10e9;     % 10GHz
freq=9.95e9;
T_mid = 1/freq_mid;       % 0.1ns
T = 1/freq;       % 0.1ns
UI_probes_mid=T_mid/50;

% 10-10.02 GHz - <1kb
%10.05 - 2kb
%9.98 - <1kb
%9.95 - 1.5kb
%9.9 - 4kb
%10.1 - 6-6.5 kb
%------ data_rec ----- %%
global setup_t;
global hold_t;
global min_eye_opening;
global unres_val;
global ctle_adapt;
global peak_val;
global set_peak_value;
global fp1;
global fp2;

ctle_adapt=0;
set_peak_value=0;
peak_val=60;
fp1=9.8e9;
fp2=15.9e10;
unres_val=-1; % -1/ 'prev'
min_eye_opening=10; %[mV]


% ----- clocks ----%%

global PJ;
global PJ_tot;
global f_PJ;
global peak_jit;
global BER;
global RJ0;

global thr;
global t0;
global f0;


f_PJ=1e8; %czestotliwosc Periodic Jitter
PJ=0;%2e-14; %jedno przesuniecie okresu w wyniku PJ
PJ_tot=0; %zmienna akumulacyjna PJ, po freq/f_PJ zmienia kierunek zmian okresu

BER=1e-12;
peak_jit=[3.891 4.417 4.892 5.327 5.731 6.109 6.467 6.807 7.131 7.441 7.739];
peak_jit=peak_jit(log10(1e-3/BER));
RJ0=0;%1e-3;

thr=0.5;
vector_length=250*input_bytes;
vector_length2=round(vector_length*UI_probes_mid*4/T);
t0=[54,52,50,48,46];
f0=zeros(1,5);

for i=1:5
    f0(i)=T_mid/t0(i)*freq_mid/UI_probes_mid;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

input_data=generate_binary_data(input_bytes, 'pulses');
input_bits=numel(input_data);
%clk_ideal=clk_ideal_gen(input_bits,over_sampling);
%time = (0:T/over_sampling:T*input_bits-(T/over_sampling));


%---------------------Driver----------------------------------------------%
[clk,t_clk,~,~,~]=clk_gen_f_not_id5(freq,0,vector_length,0,vector_length2,1);
clk=clk(t_clk/2+mod(round(rand()*100),10)-5:length(clk));
% 
% sl=slope(clk(round(length(clk)/2):length(clk)))+round(length(clk)/2);
% clk(sl-10:sl+54)=zeros(1,65);    
% f_clks=freq_check(clk);
% figure
% plot(f_clks(2:length(f_clks)))
% ylabel('cz. zegara synchr.');

driv_data = driv_script(input_data,clk);
clk=clk(length(driv_data):length(clk));
UI_probes=1/(t_clk*freq);
setup_t=5*UI_probes; % 
hold_t=5*UI_probes; % 
%vector_length=length(driv_data);

%---------------------Channel---------------------------------------------%


channel_data = channel(driv_data);
% eq_dat=ctle_back(channel_data, 5e8, 6e9, 12e9, 0, -10); % (signal, fz, fp1,
 %fp2, HFboost, DCgain)
%eq_dat=ctle(channel_data, 5.5e9, 12); % (signal, fz, gain)
eq_dat=ctle(channel_data, 1e9, 12); % (signal, fz, gain)

%save('pulses_20kB_10G_3_2_5e9all.mat');

%% cdr

%% clock_synchro-------------------------------------------------------%%
[data, slope_sampled, min_eye300_100, min_eye100_100, min_eye100_300,setup_200, setup0, setup200, hold_200, hold0, hold200, eyeO1, eyeO2, eyeO3, wf,clk_vco,clk1_out,f_vco_end,v_int_end,kp_end]=cdr_prob(eq_dat,-1,0,1*freq_mid,-1,-1,1);

%% ctle adapt
%close all;
    input_bytes=250;
    %peak_val=80;
    vector_length=250*input_bytes;
    clk=clk_make(clk,t_clk);
    ylabel('zegar drivera przy ctle');
    f_clks=freq_check(clk);
    figure
    plot(f_clks(2:length(f_clks)))
    ylabel('cz. zegara ctle');
    input_data=generate_binary_data(input_bytes, 'pulses_&&_ctle');
    input_bits=numel(input_data);
    driv_data = driv_script(input_data,clk);
    clk=clk(length(driv_data):length(clk));
    UI_probes=1/(t_clk*freq);
    channel_data = channel(driv_data);
    prev_set=9;
    [cur_set, fz, gain, peak_val]=ctle_set(prev_set);
    eq_dat=ctle(channel_data, fz, gain); % (signal, fz, gain)
    [data, slope_sampled, min_eye300_100, min_eye100_100, min_eye100_300,setup_200, setup0, setup200, hold_200, hold0, hold200, eyeO1, eyeO2, eyeO3, wf,clk_vco,clk1_out,f_vco_end,v_int_end,kp_end]=cdr_prob(eq_dat,clk_vco,clk1_out,f_vco_end,v_int_end,kp_end,2);
 r=1;
    while (ctle_adapt~=0 && r<5)
        %close all
        r=r+1;
        prev_set=cur_set;
        [cur_set, fz, gain, peak_val]=ctle_set(prev_set);
        eq_dat=ctle(channel_data, fz, gain); % (signal, fz, gain)   
        fprintf('curset %d', cur_set);
        [data, slope_sampled, min_eye300_100, min_eye100_100, min_eye100_300,setup_200, setup0, setup200, hold_200, hold0, hold200, eyeO1, eyeO2, eyeO3, wf,clk_vco,clk1_out,f_vco_end,v_int_end,kp_end]=cdr_prob(eq_dat,clk_vco,clk1_out,f_vco_end,v_int_end,kp_end,3);
    end

    %% dfe peak adapt
    set_peak_value=1;
%    peak_val=60;
    input_bytes=500;
    vector_length=250*input_bytes;
    clk=clk_make(clk,t_clk);
    ylabel('zegar drivera przy dfe');
    f_clks=freq_check(clk);
    figure
    plot(f_clks(2:length(f_clks)))
    ylabel('cz. zegara dfe');
    %close all;
    input_data=generate_binary_data(input_bytes, 'dfe_pulses');
    input_bits=numel(input_data);
    driv_data = driv_script(input_data,clk);
    clk=clk(length(driv_data):length(clk));
    UI_probes=1/(t_clk*freq);
    channel_data = channel(driv_data);
  
    eq_dat=ctle(channel_data, fz, gain); % (signal, fz, gain)
    [data, slope_sampled, min_eye300_100, min_eye100_100, min_eye100_300,setup_200, setup0, setup200, hold_200, hold0, hold200, eyeO1, eyeO2, eyeO3, wf,clk_vco,clk1_out,f_vco_end,v_int_end,kp_end]=cdr_prob(eq_dat,clk_vco,clk1_out,f_vco_end,v_int_end,kp_end,4);
    set_peak_value=0;
    
 %% data transfer   
    input_bytes=1000;
    vector_length=250*input_bytes;
    clk=clk_make(clk,t_clk);
    ylabel('zegar drivera przy danych');
    input_data=generate_binary_data(input_bytes, 'none');
    input_bits=numel(input_data);
    driv_data = driv_script(input_data,clk);
    UI_probes=1/(t_clk*freq);
    channel_data = channel(driv_data);

    eq_dat=ctle(channel_data, fz, gain); % (signal, fz, gain)
    [data, slope_sampled, min_eye300_100, min_eye100_100, min_eye100_300,setup_200, setup0, setup200, hold_200, hold0, hold200, eyeO1, eyeO2, eyeO3, wf,clk_vco,clk1_out,f_vco_end,v_int_end,kp_end]=cdr_prob(eq_dat,clk_vco,clk1_out,f_vco_end,v_int_end,kp_end,0);
    
    if(vector_length<length(clk))
        f_clks=freq_check(clk(1:vector_length));
    else
        f_clks=freq_check(clk);
    end
    figure
    plot(f_clks(2:length(f_clks)))
    ylabel('cz. zegara taktujacego dane');
    
    f_vcos=freq_check(clk_vco);
    figure
    plot(f_vcos(2:length(f_vcos)))
    ylabel('cz. zegara vco');
    
    
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
        %i
    end
end
x=abs(data_c-data(1:input_bits-8));
% %---------------------Dodatki---------------------------------------------%
% 
% figure
% plot(time, driv_data, time, eq_dat, time, clk(1:numel(driv_data));%, time, clk(1:numel(clk_shf)-120)*10);
% ylabel('data driver, channel, clock');
UI_probes=t_clk;
figure
for i=1:length(driv_data)/UI_probes/3
    plot(-UI_probes:UI_probes-1, driv_data(1+2*UI_probes*(i-1):2*UI_probes*(i)));
    hold on
end


figure
for i=1:length(channel_data)/UI_probes/3
    plot(-UI_probes:UI_probes-1, channel_data(UI_probes/2+1+3*UI_probes*(i-1):3*UI_probes*(i) -UI_probes/2)) ;
    hold on
end

figure
for i=1:length(eq_dat)/UI_probes/3
    plot(-UI_probes:UI_probes-1, eq_dat(UI_probes/2+1+3*UI_probes*(i-1):3*UI_probes*(i) -UI_probes/2 )) ;
    hold on
end

figure
plot(data)
ylabel('data recovered');
% setup=setup';
% holdd=holdd';
% 
% sl=zeros(1,vector_length2);
% sl(1)=slope(clk(1:vector_length2));
% for z=2:vector_length2
%     sl(z)=slope(clk(sl(z-1):vector_length2));
%     if(sl(z)==0)
%         break;
%     end
% end
%
% figure
% data_c=data_c(3:length(data_c));
% x=abs(data(1:length(data_c))-data_c);
% plot(x)