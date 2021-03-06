
function  [out_data, slope_sampled, min_eye300_100, min_eye100_100,min_eye100_300,setup_200, setup0, setup200, hold_200, hold0, hold200, eyeO1, eyeO2, eyeO3, wf,clk_o,clk1,f_vco_end,v_int_end,kp_end]=cdr_prob(input_vector,clk_start,clk1,f_vco_start,v_int_start,kp_start,ph_det_mode)


global input_bits;
global set_peak_value;
global peak_val;


% ---------------------- clock recovery-------------------%
global vector_length;
global freq_mid;     % 10GHz
global UI_probes_mid;      % 0.002ns
global thr;
global t0;
global f0;
global prev_val;
global acc_size;
global nonsignificant_bits;
global ctle_adapt;


global T_mid;        % 0.1ns 
global PJ_tot;
global PVCO;
global Temp;
global TJ;
global F;
global RJ0;
Temp=300;
F=1;
PVCO=100;
TJ=Temp*F/PVCO*RJ0;


PJ_prev=PJ_tot;
PJ_tot=0;
acc_size=14;
nonsignificant_bits=acc_size-10;

vector_length2=round(vector_length*UI_probes_mid*4/T_mid);
delay=0;
z=0;
zmax=10;
j=1;
%zmienna porzadkowa inkrementowana co wykryte zbocze zegara
%clk1=0;
end_pll=0;
f_vcos=zeros(1,vector_length2);
f_vcos(1)=f_vco_start;
%t_vcos=zeros(1,vector_length2);
%t_vcos(1)=T_mid/UI_probes_mid*freq_mid/f_vco_start;
t_clk1=zeros(1,vector_length2);
t_clk2=zeros(1,vector_length2);
t_clk1(1)=round(T_mid/UI_probes_mid*freq_mid/f_vco_start);
t_clk2(1)=round(T_mid/UI_probes_mid*freq_mid/f_vco_start);

if(clk_start==-1)
    delay=3;
    [clk,~,~,clk1,curr_end_vco]=clk_gen_f_not_id5(f_vcos(1),0,vector_length,clk1,delay,0);
    fprintf('startowy zegar wyjsciowy wygenerowany do %d\n',curr_end_vco);
    f_vcos(2:delay)=f_vco_start;
    %t_vcos(2:delay)=T_mid/UI_probes_mid*freq_mid/f_vco_start;
    %clk=clk(floor(t_clk1(1)/4):curr_end_vco);
    %curr_end_vco=curr_end_vco-11;
else
    clk=clk_start;
    curr_end_vco=length(clk);
end
clk2=clk(t_clk1(1)/2+2:curr_end_vco);
v_int_num=zeros(1,vector_length);                                %numeryczna wartosc napiecia wyjsciowego integratora
if(v_int_start~=-1)
    v_int_num(1)=v_int_start;
else
    v_int_num(1)=round(2^(acc_size-1)+(f_vco_start-freq_mid)/10^6*2^nonsignificant_bits);
end
kps=ones(1,vector_length2);
% if(ph_det_mode==1)
%     kps=kps*64;
% end
if(kp_start~=-1)
    kps(1)=kp_start;
end

%-----------------------%---------------------------------%----------------
 % --------------data recovery--------------------------%
size_feed=3;
sample = zeros(1, size_feed);

wf=[0;0;0];
i=1;
t=1;
k=1;
out_data=zeros(1,input_bits);
slope_sampled=zeros(1,input_bits);
min_eye300_100=zeros(1,input_bits);  
min_eye100_100=zeros(1,input_bits);
min_eye100_300=zeros(1,input_bits);
setup_200=zeros(1,input_bits);
setup0=zeros(1,input_bits);
setup200=zeros(1,input_bits);
hold_200=zeros(1,input_bits);
hold0=zeros(1,input_bits);
hold200=zeros(1,input_bits);
eyeO1=zeros(1,input_bits);
eyeO2=zeros(1,input_bits);
eyeO3=zeros(1,input_bits);
sl1=zeros(1,vector_length2);
sl2=zeros(1,vector_length2);
th200_k= [20; 0];
scaled_th_dat=[-1.5, -1.5, -1.5];
prev_val=[0,0]

prev_peak_sampled=1;

ctle_val=0;

%-----------------------%---------------------------------%----------------
while ((i<length(input_vector)-100) &&end_pll==0)%&&j<50)
    if(mod(t-5,4)==0)
        th200_k(2)=1;
    else
        th200_k(2)=0;
    end
    fprintf('petla cdr \n');
    %clk2(i:i+t_vcos(j))=clk(i+round(t_vcos(j)/2):i+round(3/2*t_vcos(j)));
    sl1(j)=slope(clk(i:length(clk)));
    sl2(j)=slope(clk2(i:length(clk2)));
    if(j>1)
        sl1(j)=sl1(j)+i;
        sl2(j)=sl2(j)+i;
        t_clk1(j)=sl1(j)-sl1(j-1);
        t_clk2(j)=sl2(j)-sl2(j-1);
    end
    i
    fprintf('t vco: %d \n',t_clk1(j));
    fprintf('pobierany clk od %d do %d\n',i,i+t_clk1(j));
    [data, ~, min_eye300_100_tmp, min_eye100_100_tmp, min_eye100_300_tmp,setup_200_tmp, setup0_tmp, setup200_tmp, hold_200_tmp, hold0_tmp, hold200_tmp, eyeO1_tmp, eyeO2_tmp, eyeO3_tmp, wf, th200_k, scaled_th_dat, sample]=data_recovery(input_vector(i:i+t_clk1(j)), clk(i:i+t_clk1(j)), clk(i:i+t_clk1(j)), wf, th200_k, scaled_th_dat, sample);
    
    fprintf('pobierany clk2 od %d do %d\n',i+floor(t_clk2(j)/2),i+floor(3/2*t_clk2(j)));
    [~, slp, ~, ~, ~,~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]=data_recovery(input_vector(i+floor(t_clk2(j)/2):i+floor(3/2*t_clk2(j))), clk2(i:i+t_clk2(j)), clk2(i+floor(t_clk2(j)/2):i+floor(3/2*t_clk2(j))), wf, th200_k, scaled_th_dat, sample);
    
    %---- set peak_val --------%
    if(set_peak_value==1 && j>5 && (isequal(out_data(k-6:k-1),[0 1 0 1 0 1])))
       [peak_val, peak_sampled]=set_peak_val(input_vector(i:i+t_clk1(j)), clk(i:i+t_clk1(j)), peak_val)
       if(prev_peak_sampled~=peak_sampled && j>10 )
            set_peak_value=0;
       else
            prev_peak_sampled=peak_sampled;
       end
    end
    %-------------------------------------------%
    %[data, slope, min_eye300_100_tmp, min_eye100_100_tmp, min_eye100_300_tmp,setup_200_tmp, setup0_tmp, setup200_tmp, hold_200_tmp, hold0_tmp, hold200_tmp, eyeO1_tmp, eyeO2_tmp, eyeO3_tmp, wf, th200_k, scaled_th_dat]=data_recovery(input_vector(i:i+t_vcos(j)+10), clk_driv(1+(i-1)*61 +25:i*61+25), clk_driv(1+(i-1)*61+50:i*61+50), wf, th200_k, scaled_th_dat);
    prev_val=data;

    out_data(k: k+1)=data; 
    slope_sampled(j)=slp;
    
%     min_eye300_100(t)=min_eye300_100_tmp;
%     
%     min_eye100_100(t)=min_eye100_100_tmp;
%     min_eye100_300(t)=min_eye100_300_tmp;
    setup_200(t)=setup_200_tmp;
    setup0(t)=setup0_tmp;
    setup200(t)=setup200_tmp;
    hold_200(t)=hold_200_tmp;
    hold0(t)=hold0_tmp;
    hold200(t)=hold200_tmp;
%     eyeO1(t)=eyeO1_tmp;
%     eyeO2(t)=eyeO2_tmp;
%     eyeO3(t)=eyeO3_tmp;
    
    i=i+t_clk1(j);
    t=t+1;
    
    %---------------------Clock_Recovery--------------------------------------%
    if(j>1)
        [clk_o,clk,clk1,~,f_vcos(j+delay),curr_end_vco,v_int_num(j),kps(j+1),z,end_pll]=pll3(clk,clk1,curr_end_vco,v_int_num(j-1),data,out_data(k-2:k-1),slope_sampled(j-1),kps(j),z,ph_det_mode,j);     
    else
        [clk_o,clk,clk1,~,f_vcos(j+delay),curr_end_vco,v_int_num(j),kps(j+1),z,end_pll]=pll3(clk,clk1,curr_end_vco,v_int_num(j),data,0,slp,kps(j),z,ph_det_mode,j);
    end
    clk2=[clk2 clk_o];
    
    %---------------------Ctle_adapt----------------------------------
    if(j>4 && ctle_val==0)
       fprintf('ctle_adapt \n');
       ctle_val=ctle_adaptation(out_data(k-6:k+1), slope_sampled(j-2:j-1))
    end
    %-----------------------------------------------------------% 
    k=k+2;
    j=j+1;
    %----------------------------------------------------------------------
    %---
        
end
PJ_tot=PJ_prev;
x=mod(round(rand()*100),10)-5;
%fprintf('zegar wyjsciowy od %d do %d, przesuniecie %d\n',(sl1(j-1)+ceil(t_clk1/4)+x),curr_end_vco,(ceil(t_clk1/4)+x));
if(ph_det_mode~=0)
    clk_o=clk(sl1(j-1)+ceil(t_clk1/4)+x:curr_end_vco);
else
    clk_o=clk;
end
%clk_o=clk(sl1(j-1):curr_end_vco);
f_vco_end=f_vcos(j-1);
v_int_end=v_int_num(j-1);
kp_end=kps(j-1);
if(length(clk2)>length(input_vector))
    clk2=clk2(1:length(input_vector));
end
% figure
% plot(t_clk1(2:j)-t_clk2(1:j-1))
% ylabel('okresy vco');
    figure
    plot(1:length(clk2), input_vector(1:length(clk2)), 1:length(clk2), 50*clk(1:length(clk2)), 1:length(clk2), 50*clk2(1:length(clk2)));
    if(ph_det_mode==1)
        ylabel('zegary prob. w czasie synchronizacji');
    elseif(ph_det_mode==2)
        ylabel('zegary prob. i dane ctle1');
    elseif(ph_det_mode==3)
        ylabel('zegary prob. i dane ctle2');
    elseif(ph_det_mode==4)
        ylabel('zegary prob. i dane dfe');
    elseif(ph_det_mode==0)
        ylabel('zegary prob. i dane');
    end
if(ph_det_mode==1||ph_det_mode==0)
    figure
    plot(f_vcos(1:j-1));
    if(ph_det_mode==1)
        ylabel('cz. vco w czasie synchronizacji');
    else
        ylabel('cz. vco w czasie transmisji danych');
    end
    figure
    plot(v_int_num(1:j-1));
    if(ph_det_mode==1)
        ylabel('wartosci akumulatora w czasie synchronizacji');
    else
        ylabel('wartosci akumulatora w czasie transmisji danych');
    end
    % figure
    %scatter(1:j,sl1(1:j),1:j,sl2(1:j));
    figure
    plot(kps(1:j-1))
    if(ph_det_mode==1)
        ylabel('wspolczynniki petli integracyjnej w czasie synchronizacji');
    else
        ylabel('wspolczynniki petli integracyjnej w czasie transmisji danych');
    end
end