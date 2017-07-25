
clear all;
global vector_length;
global thr;
global over_sampling;
global freq;     % 10GHz
global T;        % 0.1ns
global EUI;        % 0.1ns
global acc_size;
global nonsignificant_bits;

freq = 10^10;     % 10GHz
T = 1/freq;       % 0.1ns
EUI=T/50;

vector_length=400000;
vector_length2=round(vector_length*EUI*4/T);
thr=0.5;
over_sampling=400;

acc_size=14;
nonsignificant_bits=acc_size-10;
delay=10;
kps=ones(1,vector_length2);
kps=kps*32;
ki=1;

%m_step=-4;
%kps(1)=1;
%time = (0:T/over_sampling:T*vector_length/over_sampling-(T/over_sampling));
%10 bitow sygnalu sterujacego zakres 9.5-10.5 f0=10ghz
%najm. krok 1mhz
%filtr integracyjny biegun 100mhz pasmo te�
%1 IUI - 100 ps
%zmiana napiecia o 1 kod cyfrowy - 1ps

time=zeros(1,vector_length*over_sampling);
for i=2:vector_length*over_sampling
  time(i)=time(i-1)+EUI/over_sampling;
end

%clk_ideal=zeros(1,vector_length);

%zmienna porzadkowa inkrementowana co wykryte zbocze zegara
%t_clk=T/(2*EUI);
%t_vco=T/EUI*f_clk/freq;


f_clks=zeros(1,vector_length2);
f_clks(1)=0.99*freq;
t_clks=zeros(1,vector_length2);
t_clks(1)=T/EUI*freq/f_clks(1);
t_clks_real=zeros(1,vector_length2);
f_clks_real=zeros(1,vector_length2);

f_vco_start=1*freq;
f_vcos=zeros(1,vector_length2);
f_vcos(1:delay)=f_vco_start;
t_vcos=zeros(1,vector_length2);
t_vcos(1:delay)=T/EUI*freq/f_vco_start;
t_vcos_real=zeros(1,vector_length2);
f_vcos_real=zeros(1,vector_length2);

%t0=[212,210,208,206,204,202,200,198,196,194,192,190];
% f0=zeros(1,12);
% for i=1:12
%     f0(i)=T/t0(i)*freq/EUI;
% end
t0=[54,52,50,48,46];
f0=zeros(1,5);
for i=1:5
    f0(i)=T/t0(i)*freq/EUI;
end

%zmienne i tablice okresow i czestotliwosci zegarow

%clk1=clk_not_id(24,start,floor(vector_length/2)+11);
%clk1=clk_gen_f(1*freq,0,floor(vector_length/16)+9);
%clk_ideal(1:floor(vector_length/16)+9)=clk1;
%clk_ideal(start:floor(vector_length/2)-1)=clk1;
%clk_ideal(1:floor(vector_length/2)-1)=clk_gen_f(freq*1.04,0,floor(vector_length/2)-1);
%clk2=clk_not_id(32,0,floor(vector_length/2)-11);
%clk2=clk_gen_f(freq,0,floor(vector_length*15/16)-9);
%[clk_ideal(1:vector_length),t_clks_real,f_clks_real]=clk_gen_f_not_id3(f_clks(1),0,vector_length,0,t0,f0,vector_length2);
%[clk_ideal(1:vector_length),t_clk_real,f_clk_real]=clk_gen_f_not_id4(f_clks(1),0,vector_length,0,t0,f0,vector_length2);
%clk2;
%clk_ideal(floor(vector_length/2):vector_length)=clk_gen_f(0.96*freq,0,floor(vector_length/2)+1);
%clk_ideal(start:vector_length)=clk_gen_f(freq,0,vector_length);
%clk_ideal(floor(vector_length/16)+10:vector_length)=clk2;
%clk_ideal(1:vector_length)=clk_gen_f_not_id(1*freq,0,vector_length);
%clk_ideal(60000:60015)=0;

%input_data1 = randi([0 1], 100, 1);
t=1;
start=1;
start_vco=1;
%zbocze zegara wej
curr=0;
curr_sl=0;
curr_vco=0;
curr_end=ceil(t_clks(1))+1;
curr_end_tot=0;
%curr_end_vco=delay*t_vcos(1);
start_vco=1;
%zbocze vco
slope_in=zeros(1,vector_length2);
slope_out=zeros(1,vector_length2);
%indeksy zboczy zegarow w dziedzinie czasu
slope_in_time=zeros(1,vector_length2);
slope_out_time=zeros(1,vector_length2);
%momenty wystepowania zboczy
t_diff=zeros(1,vector_length2);
tt_diff=zeros(1,vector_length2);
%roznice czasu miedzy zboczami
%interp_diff=zeros(1,vector_length);
%step=t_clk_real*3;
j=0;
iter=0;
% iter=zeros(1,vector_length2);
% iter2=zeros(1,vector_length2);
clk1=0;
clk1_out=0;

% fprintf('\n-----------------------------------------------------------\n');
% clk_out=zeros(1,vector_length);
% %[clk_out,t_vcos_real(1:ceil(curr_end_vco*EUI/T)),f_vcos_real(1:ceil(curr_end_vco*EUI/T)),clk1,curr_end_vco,j]=clk_gen_f_not_id3(f_vcos(1),0,vector_length,clk1,t0,f0,ceil(curr_end_vco*EUI/T));
[clk_out,t_vcos_real(t),f_vco_real(t),clk1_out,curr_end_vco]=clk_gen_f_not_id5(f_vcos(1),0,vector_length,clk1_out,t0,f0,delay);
%     
fprintf('startowy zegar wyjsciowy wygenerowany do %d\n',curr_end_vco);
curr_end_vco_prev=curr_end_vco;
%step_vco=t_vcos_real(1)*3;
v_dfs=zeros(1,vector_length);                                    %napiecie wyjsciowe detektora fazy
v_int=zeros(1,acc_size);                                                   %kod napiecia wejsciowego VCO
v_int_num=zeros(1,vector_length);                                %numeryczna wartosc napiecia wyjsciowego integratora
v_int_num(1)=2^(acc_size-1)+(f_vco_start-freq)/10^6;
%v_int_num!=v_int

%curr_sl-od kiedy wykrywamy zbocze
%curr-od kiedy dopisujemy
%curr_end_tot-do kiedy dopisujemy
%curr_end-dlugosc zegara dopisywanego

while(curr<vector_length)%&&t<30)  
    t
%     if(t==1234)
%         curr=curr-11;
%         curr_end_tot=curr_end_tot-11;
%     end
    [clk,t_clks_real(t),f_clks_real(t),clk1,curr_end]=clk_gen_f_not_id5(f_clks(1),0,vector_length,clk1,t0,f0,1);
    
    curr_end_tot=curr_end_tot+curr_end;
    if(curr_end_tot>curr_end_tot)
        curr_end_tot=vector_length;
    end
    clk_ideal(curr+1:curr_end_tot)=clk;
    curr=curr+curr_end;
    fprintf('\nwejscie:\n');
    fprintf('wyszukiwanie zbocza od %d do %d\n',curr_sl+1,curr_end_tot);
    start=slope(clk_ideal(curr_sl+1:curr_end_tot));
    if(start==0)
        break;
    end
    start=start+curr_sl;
    curr_sl=start-1;
    
    fprintf('wejzbocze w: %d\n',start);
    slope_in(t)=(start-1)*over_sampling+sampletime(clk_ideal(start-1),clk_ideal(start));%start*over_sampling;
    %znajdowanie miejsca zbocza wejsciowego interpolowanego na dziedzine czasu
    slope_in_time(t)=time(slope_in(t));
    if(t>1)
        t_clks(t)=(slope_in(t)-slope_in(t-1))/over_sampling;
        f_clks(t)=round(T/t_clks(t)*freq/EUI/10^6)*10^6;
    end
    fprintf('wejzbocze interpolowane na czas w %d, czas=%d\n',slope_in(t),slope_in_time(t));
    fprintf('wykryty okres w %d do %d to: %d \n',curr_sl,curr_sl+t_clks(t),t_clks(t));
    fprintf('wykryta czestotliwosc w %d do %d to: %d GHz\n',curr_sl,curr_sl+t_clks(t),f_clks(t)/10^9);
%   fprintf('realny okres zegara wej to %d\n',t_clks_real(t));
    
    fprintf('\nwyjscie:\n');
    fprintf('wyszukiwanie zbocza wyj od %d do %d\n',start_vco,curr_end_vco);
    start_vco=slope(clk_out(start_vco:curr_end_vco));
    if(start_vco==0)
        break;
    end
    start_vco=curr_vco+start_vco;
    curr_vco=start_vco-1;
    fprintf('wyjzbocze w %d\n',start_vco);
    slope_out(t)=(start_vco-1)*over_sampling+sampletime(clk_out(start_vco-1),clk_out(start_vco));%start*over_sampling;
    slope_out_time(t)=time(slope_out(t)); 
     
    while(((slope_out(t)<slope_in(t)-t_clks(t)*over_sampling)||(slope_out(t)>=slope_in(t)+t_clks(t)*over_sampling))&&iter<13)
        if(slope_out(t)>slope_in(t))
            [clk,t_clks_real(t),f_clks_real(t),clk1,curr_end]=clk_gen_f_not_id5(f_clks(1),0,vector_length,clk1,t0,f0,1);
            curr_end_tot=curr_end_tot+curr_end;
            if(curr_end_tot>curr_end_tot)
                curr_end_tot=vector_length;
            end
            clk_ideal(curr+1:curr_end_tot)=clk;
            curr=curr+curr_end;
            curr_sl=curr_sl+floor(t_clks(t)/2);
            fprintf('wyszukiwanie zbocza2 od %d\n',curr_sl);
        elseif(slope_out(t)<slope_in(t))
            curr_sl=curr_sl-floor(t_clks(t)/2);
            fprintf('wyszukiwanie zbocza3 od %d\n',curr_sl);
        end
        iter=iter+1;
        start=slope(clk_ideal(curr_sl+1:curr_end_tot));
        if(start==0)
            break;
        end
        start=start+curr_sl;
        slope_in(t)=(start-1)*over_sampling+sampletime(clk_ideal(start-1),clk_ideal(start));%start*over_sampling;
        slope_in_time(t)=time(slope_in(t));
        fprintf('wejzbocze2 w: %d\n',start);
        fprintf('zbocza w momentach %d w clk_in i %d w clk_out\n',slope_in(t),slope_out(t));
    end
    curr_sl=start-1;
    iter=0;
    
    t_diff(t)=slope_in_time(t)-slope_out_time(t);    
    fprintf('roznica czasu miedzy interpolowanymi sygnalami: %d w clk_in i %d w clk_out to %d\n',slope_in(t),slope_out(t),t_diff(t));
    
    v_dfs(t)=phase_detector8(t_diff(t));
    if(t>1)
        [v_int,v_int_num(t)]=integrate9(v_dfs(t),v_int_num(t-1),kps(t),ki);
    else
        [v_int,v_int_num(t)]=integrate9(v_dfs(t),2^(acc_size-1)+(f_vco_start-freq)/10^6,kps(t),ki);
    end
    f_vcos(t+delay)=freq_change6(v_int);
    if(t>1)
        t_vcos(t)=(slope_out(t)-slope_out(t-1))/over_sampling;
        fprintf('znaleziony okres vco to %d\n',t_vcos(t));
        if(t<delay)
            f_vcos(t)=round(T/t_vcos(t)*freq/EUI/10^6)*10^6;
            fprintf('znaleziona cz. vco to %d\n',f_vcos(t));
        end
    end
        [clk_o,t_vcos_real(t),f_vcos_real(t),clk1_out,curr_end_vco]=clk_gen_f_not_id5(f_vcos(t+delay),curr_end_vco_prev,vector_length,clk1_out,t0,f0,1);
        fprintf('wygenerowano zegar od %d do %d z cz. %f GHz, clk1=%f\n',curr_end_vco_prev+1,curr_end_vco,f_vcos(t+delay)/10^9,clk1_out);
        
        clk_out(curr_end_vco_prev+1:curr_end_vco)=clk_o;
        curr_end_vco_prev=curr_end_vco;
        if(curr_end_vco>=vector_length)
            break;
        end
     fprintf('\n-----------------------------------------------------------\n');
     t=t+1;
end

% figure
% plot(clk_ideal);
% ylabel('clk in');
% figure
% plot(t_clks(1:t-1));%,1:t,t_clks3(1:t));
% ylabel('t clk');
% % figure
% % plot(t_clks_real(1:vector_length2));%,1:t,t_clks3(1:t));
% % ylabel('t clk real');
figure
plot(slope_in_time(1:t-1),f_clks(1:t-1));
ylabel('f clk');
figure
plot(clk_out)
ylabel('clk out');
figure
plot(t_vcos(1:t-1))
ylabel('t clk out');
% figure
% plot(t_vcos_real(1:round(curr_end_vco*EUI/T)))
% ylabel('t clk out real');
figure
plot(slope_out_time(1:t-1),f_vcos(1:t-1))
ylabel('f vco');
figure
plot(t_diff(1:t-1))
ylabel('t diff');
% figure
% plot(iter(1:t-1))
% ylabel('iteracje wyszukiwania zbocza');