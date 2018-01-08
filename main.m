

clear all;
close all;
clc

%---------------------Common variables------------------------------------%
global vector_length;
global input_bits;
global freq_mid;     % 10GHz
global freq;
global UI_probes_mid;      % 0.002ns
global UI_probes;
global T_mid;
global T;

dlugosc_kanalu = 10;
input_bytes=500;   % number of input bytes for clk sync
input_bits=input_bytes*8;

freq_mid = 10e9;     % 10GHz
freq=10e9;
T_mid = 1/freq_mid;       % 0.1ns
T = 1/freq;       % 0.1ns
UI_probes_mid=T_mid/50;

% 9.98-10.02 GHz - <1kb
%10.05 - 2kb
%9.95 - 3kb
%9.9 - >=10kb
%10.1 - 5kb
%10.2 - >10kb
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
%peak_val=60;
fp1=9.8e9;
fp2=15.9e10;
unres_val=-1; % -1/ 'prev'
min_eye_opening=10; %[mV]


%---------------------Clock variables-------------------------------------%

global PJ;
global PJ_tot;
global f_PJ;
global RJ0;

global thr;
global t0;
global f0;


f_PJ=2e8;   %czestotliwosc Periodic Jitter
PJ_main=3000e6;
PJ=PJ_main*f_PJ/freq;     %amplituda Periodic Jitter w dziedzinie czestotliwosci
%PJ=15e6;
PJ_tot=0;   %zmienna akumulacyjna PJ*f_PJ/freq, po osiagnieciu PJ zmienia kierunek zmian okresu
%PJ_tot_vco=0;

RJ0=0;%2e6;%5e-3;

thr=0.5;
t0=[54,52,50,48,46];
f0=zeros(1,5);

for i=1:5
    f0(i)=T_mid/t0(i)*freq_mid/UI_probes_mid;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------START----------------------------------------------%

input_data=generate_binary_data(input_bytes, 'pulses');
%input_data2=generate_binary_data(input_bytes, 'none');
%input_data=[input_data input_data2];
input_bits=numel(input_data);
input_bytes=input_bits/8;
vector_length=250*input_bytes;
vector_length2=round(vector_length*UI_probes_mid*4/T);
%clk_ideal=clk_ideal_gen(input_bits,over_sampling);
%time = (0:T/over_sampling:T*input_bits-(T/over_sampling));

%---------------------Driver----------------------------------------------%

[clk,t_clk,f_clk,~,~,t_shift]=clk_gen_f_not_id5(freq,0,vector_length,0,vector_length2,1);
figure
plot(t_shift)
ylabel('przesuniecie zbocza w wyniku jitteru');
f_clks=freq_check(clk);
figure
plot(f_clks(2:length(f_clks)))
ylabel('cz. zegara synchro');
clk=clk(t_clk/2+mod(round(rand()*100),10)-5:length(clk));
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
prev_set=7;
[cur_set,fz,gain,peak_val]=ctle_set(prev_set)
%peak_val=100;
eq_dat=ctle(channel_data, fz, gain); % (signal, fz, gain)
%eq_dat=ctle(channel_data, 1e9, 12); % (signal, fz, gain)


%% CDR

%% Clock_Synchro----------------------------------------------------------%
[data, slope_sampled, setup_200, setup0, setup200, hold_200, hold0, hold200, wf, clk_vco,clk_vco2,clk1_out,f_vco_end,v_int_end,kp_end]=cdr_prob(eq_dat,-1,0,0,1*freq_mid,-1,-1,1);

%% CTLE Adapt-------------------------------------------------------------%
%   close all;
    input_bytes=100;
%   peak_val=80;
    vector_length=250*input_bytes;
    [clk,f_clk]=clk_make(clk,t_clk,f_clk);
%     ylabel('zegar drivera przy ctle');
%     f_clks=freq_check(clk);
%     figure
%     plot(f_clks(2:length(f_clks)))
%     ylabel('cz. zegara ctle');
    input_data=generate_binary_data(input_bytes, 'pulses_&&_ctle');
    input_bits=numel(input_data);
    driv_data = driv_script(input_data,clk);
    clk=clk(length(driv_data):length(clk));
    UI_probes=1/(t_clk*freq);
    channel_data = channel(driv_data);
    eq_dat=ctle(channel_data, fz, gain); % (signal, fz, gain)
    [data, slope_sampled, setup_200, setup0, setup200, hold_200, hold0, hold200, wf, clk_vco,clk_vco2,clk1_out,f_vco_end,v_int_end,kp_end]=cdr_prob(eq_dat,clk_vco,clk_vco2,clk1_out,f_vco_end,v_int_end,kp_end,2);
    r=0;
    while (ctle_adapt~=0&&r<12)
%         close all
        r=r+1;
        prev_set=cur_set;
        [cur_set, fz, gain, peak_val]=ctle_set(prev_set);
        eq_dat=ctle(channel_data, fz, gain); % (signal, fz, gain)   
        fprintf('curset %d', cur_set);
        [data, slope_sampled,setup_200, setup0, setup200, hold_200, hold0, hold200, wf, clk_vco,clk_vco2,clk1_out,f_vco_end,v_int_end,kp_end]=cdr_prob(eq_dat,clk_vco,clk_vco2,clk1_out,f_vco_end,v_int_end,kp_end,3);
    end
% plot(setup_ctle*1e12)
% ylabel('min setup ctle[ps]');
% figure
% plot(hold_ctle*1e12)
% ylabel('min hold ctle[ps]');
% save('10gpretest.mat');

%% DFE Peak Adapt---------------------------------------------------------%
    set_peak_value=1;
%    peak_val=60;
    input_bytes=500;
    input_data=generate_binary_data(input_bytes, 'dfe_pulses');
    %input_data2=generate_binary_data(input_bytes*4/5, 'none');
    %input_data=[input_data input_data2];
    input_bits=numel(input_data);
    %input_bytes=input_bits/8;
    vector_length=250*input_bytes;
    [clk,f_clk]=clk_make(clk,t_clk,f_clk);
%     ylabel('zegar drivera przy dfe');
%     f_clks=freq_check(clk);
%     figure
%     plot(f_clks(2:length(f_clks)))
%     ylabel('cz. zegara dfe');
%     close all;
    driv_data = driv_script(input_data,clk);
    clk=clk(length(driv_data):length(clk));
    UI_probes=1/(t_clk*freq);
    channel_data = channel(driv_data);
  
    eq_dat=ctle(channel_data, fz, gain); % (signal, fz, gain)
    [data, slope_sampled,setup_200, setup0, setup200, hold_200, hold0, hold200, wf, clk_vco,clk_vco2,clk1_out,f_vco_end,v_int_end,kp_end]=cdr_prob(eq_dat,clk_vco,clk_vco2,clk1_out,f_vco_end,v_int_end,kp_end,4);
    set_peak_value=0;
%     figure
% plot(setup_dfe*1e12)
% ylabel('min setup dfe[ps]');
% figure
% plot(hold_dfe*1e12)
% ylabel('min hold dfe[ps]');
% save('10gpretest.mat');
    
%% Data Transfer ---------------------------------------------------------%


input_bytes=500;
vector_length=250*input_bytes;
[clk,f_clk]=clk_make(clk,t_clk,f_clk);
% ylabel('zegar drivera przy danych');
%[clk,t_clk,f_clk,~,~,t_shift]=clk_gen_f_not_id5(freq,0,vector_length,0,vector_length2,1);
input_data=generate_binary_data(input_bytes, 'none');
input_bits=numel(input_data);
driv_data = driv_script(input_data,clk); % (1+(dane_iter-1)/dane_iter_max*vector_length:dane_iter/dane_iter_max*vector_length));
channel_data = channel(driv_data);  
eq_dat=ctle(channel_data, fz, gain); % (signal, fz, gain)
error=0;
k=1;
c=1;

[data, slope_sampled,setup_200, setup0, setup200, hold_200, hold0, hold200, wf, clk_vco,clk_vco2,clk1_out,f_vco_end,v_int_end,kp_end,f_vcos,setup_total,hold_total,v_int_num,kps, ~, th_200_all, th200_all, th0_all]=cdr_prob(eq_dat,clk_vco,clk_vco2,clk1_out,f_vco_end,v_int_end,kp_end,0);

for i=i:8:input_bits-8
    data_b(:,k )=data(c:c+7);
    data_c(c:c+7)=input_data(:, k);
    c=c+8;
    k=k+1;
end
    
for i=1:input_bits-8
    if(data_c(i)~=data(i))%&&(mod(i,input_bits/dane_iter_max)<input_bits/dane_iter_max-3))
        error=error+1;
        i
    end
end

input_bits=input_bytes*8;
[setup_200_end, setup0_end, setup200_end, hold_200_end, hold0_end, hold200_end]=setup_hold_check_end(eq_dat, clk_vco, th0_all, th_200_all, th200_all); 
setup_total_end=zeros(1,length(setup0_end));
hold_total_end=zeros(1,length(setup0_end));

for i=1:length(hold0_end)
    A=[setup_200_end(i), setup0_end(i), setup200_end(i)];
    setup_total_end(i)=min(A);
    A=[hold_200_end(i), hold0_end(i), hold200_end(i)];
    hold_total_end(i)=min(A);
end

% x=abs(data_c-data(1:input_bits-8));

%% Dodatki----------------------------------------------------------------%

%     f_clks=freq_check(clk(1:length(driv_data)));
%     figure
%     plot(f_clks)
%     ylabel('cz. zegara taktujacego dane');
    
    figure
    plot(f_vcos)
    ylabel('cz. VCO w czasie transmisji danych');
%     figure
%     plot(v_int_num)
%     ylabel('wartosci akumulatora w czasie transmisji danych');
%     figure
%     plot(kps)
%     ylabel('wspolczynniki petli integracyjnej w czasie transmisji danych');
    
%     f_vcos=freq_check(clk_vco);
%     figure
%     plot(round((f_vcos(10:length(f_vcos_orig)-1)-f_vcos_orig(11:length(f_vcos_orig)))/10^6));
%     ylabel('jitter vco');
%     avg_jitter=sum(abs(f_vcos(10:length(f_vcos_orig)-1)-f_vcos_orig(11:length(f_vcos_orig))))/(length(f_vcos_orig)-10);
%     fprintf('srednie odchylenie czestotliwosci wynosi %f MHz\n',avg_jitter/10^6);

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
plot(setup_total*1e12)
ylabel('min setup time[ps]');
% figure
% plot(setup_200_end)
% ylabel('setup zmierzony po zakonczeniu transmisji');
% figure
% plot(hold_total*1e12)
% ylabel('min hold time[ps]');
figure
plot(hold_total_end(1:length(hold_total_end)-1)*1e12)
ylabel('min hold time[ps]');
l_sh=min(length(hold_total_end),length(setup_total));
figure
plot((hold_total_end(1:l_sh)+setup_total(1:l_sh))*1e12)
ylabel('setup/hold margin[ps]');
%ylabel('hold zmierzony po zakonczeniu transmisji');
figure
% data_c=data_c(3:length(data_c));
x=abs(data(1:length(data_c))-data_c);
plot(x)
