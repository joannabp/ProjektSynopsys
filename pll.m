
function [clk_o,clk_out,clk1_out,clk_ideal,t_clk,f_clk,t_vco,f_vco,slope_in,slope_out,slope_in_time,slope_out_time,t_diff,curr,curr_sl,curr_end_tot,curr_vco,curr_end_vco,v_int_num,error]=pll(clk,clk_ideal,curr,curr_sl,curr_end,curr_end_tot,clk_out,clk1_out,curr_vco,curr_end_vco,time,v_int_num,t,slope_in_prev,slope_out_prev,t_clk,f_clk)

global vector_length;
global thr;
global over_sampling;
global freq;     % 10GHz
global T;        % 0.1ns
global EUI;        % 0.1ns
global acc_size;
global nonsignificant_bits;

vector_length2=round(vector_length*EUI*4/T);
thr=0.5;
over_sampling=400;

f_vco_start=1*freq;
acc_size=14;
nonsignificant_bits=acc_size-10;
kps=ones(1,vector_length2);
kps=kps*32;
ki=1;

%10 bitow sygnalu sterujacego zakres 9.5-10.5 f0=10ghz
%najm. krok 1mhz
%filtr integracyjny biegun 100mhz pasmo te�
%1 IUI - 100 ps
%zmiana napiecia o 1 kod cyfrowy - 1ps

%clk_ideal=zeros(1,vector_length);

%t_clk=T/(2*EUI);
%t_vco=T/EUI*f_clk/freq;

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
iter=0;
error=0;
%     
%step_vco=t_vcos_real(1)*3;
%v_int_num!=v_int

%curr_sl-od kiedy wykrywamy zbocze
%curr-od kiedy dopisujemy
%curr_end_tot-do kiedy dopisujemy
%curr_end-dlugosc zegara dopisywanego

%while(curr<vector_length)%&&t<30)  
curr_end_vco_prev=curr_end_vco;
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
    error=1;
end
start=start+curr_sl;
curr_sl=start-1;

fprintf('wejzbocze w: %d\n',start);
slope_in=(start-1)*over_sampling+sampletime(clk_ideal(start-1),clk_ideal(start));%start*over_sampling;
%znajdowanie miejsca zbocza wejsciowego interpolowanego na dziedzine czasu
slope_in_time=time(slope_in);
if(t>1)
    t_clk=(slope_in-slope_in_prev)/over_sampling;
    f_clk=round(T/t_clk*freq/EUI/10^6)*10^6;
    fprintf('wejzbocze interpolowane na czas w %d, czas=%d\n',slope_in,slope_in_time);
    fprintf('wykryty okres w %d do %d to: %d \n',curr_sl,curr_sl+t_clk,t_clk);
    fprintf('wykryta czestotliwosc w %d do %d to: %d\n',curr_sl,curr_sl+t_clk,f_clk);
else
    fprintf('wejzbocze interpolowane na czas w %d, czas=%d\n',slope_in,slope_in_time);
    fprintf('wykryty okres w %d do %d to: %d \n',curr_sl,curr_sl+t_clk,t_clk);
    fprintf('wykryta czestotliwosc w %d do %d to: %d\n',curr_sl,curr_sl+t_clk,f_clk);
end
%   fprintf('realny okres zegara wej to %d\n',t_clks_real(t));

fprintf('\nwyjscie:\n');
fprintf('wyszukiwanie zbocza wyj od %d do %d\n',curr_vco+1,curr_end_vco);
start_vco=slope(clk_out(curr_vco+1:curr_end_vco));
if(start_vco==0)
    error=1;
end
start_vco=curr_vco+start_vco;
curr_vco=start_vco-1;
fprintf('wyjzbocze w %d\n',start_vco);
slope_out=(start_vco-1)*over_sampling+sampletime(clk_out(start_vco-1),clk_out(start_vco));%start*over_sampling;
slope_out_time=time(slope_out);


while(slope_out<slope_in-t_clk*over_sampling&&iter<13)
% while(((slope_out<slope_in-t_clk*over_sampling)||(slope_out>=slope_in+t_clk*over_sampling))&&iter<13)
%     if(slope_out>slope_in)
%         curr_sl=curr_sl+floor(t_clk/2);
%         fprintf('wyszukiwanie zbocza2 od %d\n',curr_sl);
%     elseif(slope_out<slope_in)
%         curr_sl=curr_sl-floor(t_clk/2);
%         fprintf('wyszukiwanie zbocza3 od %d\n',curr_sl);
%     end
    curr_sl=curr_sl-floor(t_clk/2);
    iter=iter+1;
    start=slope(clk_ideal(curr_sl+1:curr_end_tot));
    start=start+curr_sl;
    slope_in=(start-1)*over_sampling+sampletime(clk_ideal(start-1),clk_ideal(start));%start*over_sampling;
    slope_in_time=time(slope_in);
    fprintf('wejzbocze2 w: %d\n',start);
    fprintf('zbocza w momentach %d w clk_in i %d w clk_out\n',slope_in,slope_out);
end
curr_sl=start-1;

t_diff=slope_in_time-slope_out_time;
fprintf('roznica czasu miedzy interpolowanymi sygnalami: %d w clk_in i %d w clk_out to %d\n',slope_in,slope_out,t_diff);

v_df=phase_detector8(t_diff);
if(t>1)
    [v_int,v_int_num]=integrate9(v_df,v_int_num,kps(t),ki);
else
    [v_int,v_int_num]=integrate9(v_df,2^(acc_size-1)+(f_vco_start-freq)/10^6,kps(t),ki);
end
f_vco=freq_change6(v_int);
if(t>1)
    t_vco=(slope_out-slope_out_prev)/over_sampling;
    fprintf('znaleziony okres vco to %d\n',t_vco);
else
    t_vco=T/EUI*freq/f_vco_start;
end
[clk_o,~,~,clk1_out,curr_end_vco]=clk_gen_f_not_id5(f_vco,curr_end_vco_prev,vector_length,clk1_out,t0,f0,1);
fprintf('wygenerowano zegar od %d do %d z cz. %f GHz, clk1=%f\n',curr_end_vco_prev+1,curr_end_vco,f_vco/10^9,clk1_out);

clk_out(curr_end_vco_prev+1:curr_end_vco)=clk_o;
%curr_end_vco_prev=curr_end_vco;
if(curr_end_vco>=vector_length)
    error=1;
end
fprintf('\n-----------------------------------------------------------\n');
%t=t+1;
%end

% figure
% plot(clk_ideal);
% ylabel('clk in');
% figure
% plot(t_clks(1:t-1));%,1:t,t_clks3(1:t));
% ylabel('t clk');
% % figure
% % plot(t_clks_real(1:vector_length2));%,1:t,t_clks3(1:t));
% % ylabel('t clk real');
% figure
% plot(slope_in_time(1:t-1),f_clks(1:t-1));
% ylabel('f clk');
% figure
% plot(clk_out)
% ylabel('clk out');
% figure
% plot(t_vcos(1:t-1))
% ylabel('t clk out');
% % figure
% % plot(t_vcos_real(1:round(curr_end_vco*EUI/T)))
% % ylabel('t clk out real');
% figure
% plot(slope_out_time(1:t-1),f_vcos(1:t-1))
% ylabel('f vco');
% figure
% plot(t_diff(1:t-1))
% ylabel('t diff');
% figure
% plot(iter(1:t-1))
% ylabel('iteracje wyszukiwania zbocza');