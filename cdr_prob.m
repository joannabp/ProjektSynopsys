
function  [out_data, slope_sampled,setup_200, setup0, setup200, hold_200, hold0, hold200, wf,clk_o,clk_o2,clk1,f_vco_end,v_int_end,kp_end,f_vcos,setupt,holdt,v_int_num,kps,data_curr]=cdr_prob(input_vector,clk_start,clk_start2,clk1,f_vco_start,v_int_start,kp_start,stage)


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
global dane_iter;
global dane_iter_max;


global T_mid;        % 0.1ns 
global PJ;
global PVCO;
global Temp;
global TJ;
global F;
global RJ0;
global zmax;
global count;
Temp=300;
F=1;
PVCO=100;
TJ=Temp*F/PVCO*RJ0;


PJ_prev=PJ;
PJ=0;
acc_size=14;
nonsignificant_bits=acc_size-10;

vector_length2=round(vector_length*UI_probes_mid*4/T_mid);
z=0;
zmax=10;
count=0;
j=1;
%zmienna porzadkowa inkrementowana co wykryte zbocze zegara
end_pll=0;
f_vcos=zeros(1,vector_length2);
f_vcos(1)=f_vco_start;
%t_vcos=zeros(1,vector_length2);
%t_vcos(1)=T_mid/UI_probes_mid*freq_mid/f_vco_start;
t_clks=zeros(1,vector_length2);
%t_clk2=zeros(1,vector_length2);
t_clks(1:2)=round(T_mid/UI_probes_mid*freq_mid/f_vco_start);
%t_clk2(1:2)=round(T_mid/UI_probes_mid*freq_mid/f_vco_start);
delay=10;
f_vcos(2:delay)=f_vco_start;
if(clk_start==-1)
    [clk,~,~,clk1,curr_end_vco]=clk_gen_f_not_id5(f_vcos(1),0,vector_length,clk1,delay,0);
    fprintf('startowy zegar wyjsciowy wygenerowany do %d\n',curr_end_vco);
    clk2=clk(t_clks(1)/2+1:curr_end_vco);
else
    clk=clk_start;
    curr_end_vco=length(clk);
    clk2=clk_start2;
end
v_int_num=zeros(1,vector_length);                                          
%numeryczne wartosci napiecia wyjsciowego integratora
if(v_int_start~=-1)
    v_int_num(1)=v_int_start;
else
    v_int_num(1)=round(2^(acc_size-1)+(f_vco_start-freq_mid)/10^6*2^nonsignificant_bits);
end
kps=ones(1,vector_length2);
% if(stage==1)
%     kps=kps*64;
% end
if(kp_start~=-1)
    kps(1)=kp_start;
end

%----------------------------data recovery--------------------------------%
size_feed=3;
sample = zeros(1, size_feed);

wf=[0;0;0];
i=1;
t=1;
k=1;
out_data=zeros(1,input_bits);
slope_sampled=zeros(1,input_bits);

setup_200=zeros(1,input_bits);
setup0=zeros(1,input_bits);
setup200=zeros(1,input_bits);
hold_200=zeros(1,input_bits);
hold0=zeros(1,input_bits);
hold200=zeros(1,input_bits);
if(stage~=1)
    setupt=zeros(1,input_bits);
    holdt=zeros(1,input_bits);
end

sl1=zeros(1,vector_length2);
sl2=zeros(1,vector_length2);
th200_k= [20; 0];
scaled_th_dat=[-1.5, -1.5, -1.5];
prev_val=[0,0]

prev_peak_sampled=1;

ctle_val=0;

%-------------------------------------------------------------------------%
while ((i<length(input_vector)-100) &&end_pll==0)%&&j<50)
    if(mod(t-5,4)==0)
        th200_k(2)=1;
    else
        th200_k(2)=0;
    end
    fprintf('petla cdr \n');
    %clk2(i:i+t_vcos(j))=clk(i+round(t_vcos(j)/2):i+round(3/2*t_vcos(j)));
    if(j>1)
        sl1(j)=slope(clk(sl1(j-1)+1:length(clk)))-1;
        sl2(j)=slope(clk2(sl2(j-1)+1:length(clk2)))-1;
        sl1(j)=sl1(j)+sl1(j-1);
        sl2(j)=sl2(j)+sl2(j-1);
        t_clks(j)=sl1(j)-sl1(j-1);
        t_clks(j+1)=sl2(j)-sl2(j-1);
    else
        sl1(j)=slope(clk(i:length(clk)))-1;
        sl2(j)=slope(clk2(i:length(clk2)))-1;
    end
    i
    fprintf('t vco: %d \n',t_clks(j));
    fprintf('pobierany clk od %d do %d\n',i,i+t_clks(j));
    [data, ~, setup_200_tmp, setup0_tmp, setup200_tmp, hold_200_tmp, hold0_tmp, hold200_tmp, wf, th200_k, scaled_th_dat, sample]=data_recovery(input_vector(i:i+t_clks(j)), clk(i:i+t_clks(j)), clk(i:i+t_clks(j)), wf, th200_k, scaled_th_dat, sample);
    i=i+floor(t_clks(j)/2);
    fprintf('pobierany clk2 od %d do %d\n',i,i+t_clks(j+1));
    [~, slp, ~, ~, ~,~, ~, ~, ~, ~, ~, ~]=data_recovery(input_vector(i:i+t_clks(j+1)), clk2(i:i+t_clks(j+1)), clk2(i:i+t_clks(j+1)), wf, th200_k, scaled_th_dat, sample);
    i=i-floor(t_clks(j)/2);
    %---- set peak_val ---------------------------------------------------%
    if(set_peak_value==1 && j>5 && (isequal(out_data(k-6:k-1),[0 1 0 1 0 1])))
       [peak_val, peak_sampled]=set_peak_val(input_vector(i:i+t_clks(j)), clk(i:i+t_clks(j)), peak_val)
       if(prev_peak_sampled~=peak_sampled && j>10 )
            set_peak_value=0;
       else
            prev_peak_sampled=peak_sampled;
       end
    end
    %---------------------------------------------------------------------%
    %[data, slope, min_eye300_100_tmp, min_eye100_100_tmp, min_eye100_300_tmp,setup_200_tmp, setup0_tmp, setup200_tmp, hold_200_tmp, hold0_tmp, hold200_tmp, eyeO1_tmp, eyeO2_tmp, eyeO3_tmp, wf, th200_k, scaled_th_dat]=data_recovery(input_vector(i:i+t_vcos(j)+10), clk_driv(1+(i-1)*61 +25:i*61+25), clk_driv(1+(i-1)*61+50:i*61+50), wf, th200_k, scaled_th_dat);
    prev_val=data;

    out_data(k: k+1)=data; 
    slope_sampled(j)=slp;
    

    setup_200(t)=setup_200_tmp;
    setup0(t)=setup0_tmp;
    setup200(t)=setup200_tmp;
    hold_200(t)=hold_200_tmp;
    hold0(t)=hold0_tmp;
    hold200(t)=hold200_tmp;
    if(stage==0||stage==4)
        A=[setup_200_tmp setup0_tmp setup200_tmp];
        setupt(t)=min(A);
        A=[hold_200_tmp hold0_tmp hold200_tmp];
        holdt(t)=min(A);
    end
    i=i+t_clks(j);
    t=t+1;
    
    %---------------------Clock_Recovery----------------------------------%
    if(j>1)
        [clk_o,clk,clk1,~,f_vcos(j+delay),curr_end_vco,v_int_num(j),kps(j+1),z,end_pll]=pll3(clk,clk1,curr_end_vco,v_int_num(j-1),data,out_data(k-2:k-1),slope_sampled(j-1),kps(j),z,stage,j);     
    else
        [clk_o,clk,clk1,~,f_vcos(j+delay),curr_end_vco,v_int_num(j),kps(j+1),z,end_pll]=pll3(clk,clk1,curr_end_vco,v_int_num(j),data,0,slp,kps(j),z,stage,j);
    end
    clk2=[clk2 clk_o];
    %---------------------Ctle_adapt--------------------------------------%
    if(j>4 && ctle_val==0)
       fprintf('ctle_adapt \n');
       ctle_val=ctle_adaptation(out_data(k-6:k+1), slope_sampled(j-2:j-1))
    end
    %---------------------------------------------------------------------% 
    k=k+2;
    j=j+1;
    %---------------------------------------------------------------------%
    
end
if(stage~=1)
    setupt=setupt(1:t-1);
    holdt=holdt(1:t-1);
end
PJ=PJ_prev;
%x=mod(round(rand()*100),10)-5;
%fprintf('zegar wyjsciowy od %d do %d, przesuniecie %d\n',(sl1(j-1)+ceil(t_clks/4)+x),curr_end_vco,(ceil(t_clks/4)+x));

% if(length(clk2)>length(input_vector))
%     clk2=clk2(1:length(input_vector));
% end
% figure
% plot(t_clks(2:j)-t_clk2(1:j-1))
% ylabel('okresy vco');
    figure
    plot(1:length(input_vector), input_vector(1:length(input_vector)), 1:length(input_vector), 50*clk(1:length(input_vector)), 1:length(input_vector), 50*clk2(1:length(input_vector)));
    if(stage==1)
        ylabel('zegary prob. w czasie synchronizacji');
    elseif(stage==2)
        ylabel('zegary prob. i dane ctle1');
    elseif(stage==3)
        ylabel('zegary prob. i dane ctle2');
    elseif(stage==4)
        ylabel('zegary prob. i dane dfe');
    elseif(stage==0)
        if(dane_iter==1)
        ylabel('zegary prob. i dane czesc 1');
        elseif(dane_iter==2)
        ylabel('zegary prob. i dane czesc 2');
        elseif(dane_iter==3)
        ylabel('zegary prob. i dane czesc 3');
        elseif(dane_iter==4)
        ylabel('zegary prob. i dane czesc 4');
        end
    end
f_vcos=f_vcos(1:j-1);
v_int_num=v_int_num(1:j-1);
kps=kps(1:j-1);

if(stage~=0)
%    clk_o=clk(sl1(j-1)+ceil(t_clks/4)+x:curr_end_vco);
    sl_end=slope_fall(clk(sl1(j-1):curr_end_vco))+sl1(j-1);
    clk_o=clk(sl_end:curr_end_vco);
    clk_o2=clk2(sl2(j-1)+1:length(clk2));
elseif(dane_iter<dane_iter_max)
    clk_o=clk(length(input_vector):curr_end_vco);
    clk_o2=clk2(length(input_vector):length(clk2));
else
    clk_o=clk;
    clk_o2=clk2;
end
% clk_o=clk(sl1(j-1):curr_end_vco);

f_vco_end=f_vcos(j-1);
v_int_end=v_int_num(j-1);
kp_end=kps(j-1);
data_curr=i-t_clks(j)/2;
if(stage~=0)%||stage==0)
    figure
    plot(f_vcos(1:j-1));
    if(stage==1)
        ylabel('cz. vco w czasie synchronizacji');
    elseif(stage==2)
        ylabel('cz. vco w czasie ctle1');
    elseif(stage==3)
        ylabel('cz. vco w czasie ctle2');
    elseif(stage==4)
        ylabel('cz. vco w czasie dfe');
    end
    figure
    plot(v_int_num(1:j-1));
    if(stage==1)
        ylabel('wartosci akumulatora w czasie synchronizacji');
    elseif(stage==2)
        ylabel('wartosci akumulatora w czasie ctle1');
    elseif(stage==3)
        ylabel('wartosci akumulatora w czasie ctle2');
    elseif(stage==4)
        ylabel('wartosci akumulatora w czasie dfe');
    end
    % figure
    %scatter(1:j,sl1(1:j),1:j,sl2(1:j));
    figure
    plot(kps(1:j-1))
    if(stage==1)
        ylabel('wspolczynniki petli integracyjnej w czasie synchronizacji');
    elseif(stage==2)
        ylabel('wspolczynniki petli integracyjnej w czasie ctle1');
    elseif(stage==3)
        ylabel('wspolczynniki petli integracyjnej w czasie ctle2');
    elseif(stage==4)
        ylabel('wspolczynniki petli integracyjnej w czasie dfe');
    end
end