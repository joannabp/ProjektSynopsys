function  [out_data, slope_sampled, min_eye300_100, min_eye100_100, min_eye100_300,setup_200, setup0, setup200, hold_200, hold0, hold200, eyeO1, eyeO2, eyeO3, wf]=cdr_prob(input_vector)

global input_bits;
global sample;

% ---------------------- clock recovery-------------------%
global vector_length;
global freq;     % 10GHz
global EUI;      % 0.002ns
global T;        % 0.1ns 
global thr;
global t0;
global f0;
global prev_val;

vector_length2=round(vector_length*EUI*4/T);
delay=10;

f_vco_start=1*freq;
f_vcos=zeros(1,vector_length2);
f_vcos(1:delay)=f_vco_start;
t_vcos=zeros(1,vector_length2);
t_vcos(1:delay)=T/EUI*freq/f_vco_start;
%t_vcos_real=zeros(1,vector_length2);
%f_vcos_real=zeros(1,vector_length2);

curr=1;

j=1;
%zmienna porzadkowa inkrementowana co wykryte zbocze zegara
clk1_out=0;
error_pll=0;

[clk_out,~,~,clk1_out,curr_end_vco]=clk_gen_f_not_id5(f_vcos(1),0,vector_length,clk1_out,delay); 

fprintf('startowy zegar wyjsciowy wygenerowany do %d\n',curr_end_vco);
v_int_num=zeros(1,vector_length);                                %numeryczna wartosc napiecia wyjsciowego integratora

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

th200_k= [20; 0];
scaled_th_dat=[-1.5, -1.5, -1.5];
prev_val=[0,0]
%-----------------------%---------------------------------%----------------
while ((i<length(input_vector)-100) &&error_pll==0)
    if(mod(t,4)==0)
        th200_k(2)=1;
    else
        th200_k(2)=0;
    end
    fprintf('petla cdr \n');

    [data, slope, min_eye300_100_tmp, min_eye100_100_tmp, min_eye100_300_tmp,setup_200_tmp, setup0_tmp, setup200_tmp, hold_200_tmp, hold0_tmp, hold200_tmp, eyeO1_tmp, eyeO2_tmp, eyeO3_tmp, wf, th200_k, scaled_th_dat]=data_recovery(input_vector(i:i+t_vcos(j)+10), clk_out(i+t_vcos(j):i+2*t_vcos(j)+10), clk_out(i+2*t_vcos(j)+10:i+3*t_vcos(j)+20), wf, th200_k, scaled_th_dat);
    prev_val=data;
    curr=curr+t_vcos(j);

     out_data(k: k+1)=data; 
    slope_sampled(t)=slope;
    
%     min_eye300_100(t)=min_eye300_100_tmp;
%     
%     min_eye100_100(t)=min_eye100_100_tmp;
%     min_eye100_300(t)=min_eye100_300_tmp;
%     setup_200(t)=setup_200_tmp;
%     setup0(t)=setup0_tmp;
%     setup200(t)=setup200_tmp;
%     hold_200(t)=hold_200_tmp;
%     hold0(t)=hold0_tmp;
%     hold200(t)=hold200_tmp;
%     eyeO1(t)=eyeO1_tmp;
%     eyeO2(t)=eyeO2_tmp;
%     eyeO3(t)=eyeO3_tmp;
    
    i=i+50;
    t=t+1;
    
     %---------------------Clock_Recovery--------------------------------------%
    
    if(j>1)
        [clk_o,clk_out,clk1_out,t_vcos(j+delay),f_vcos(j+delay),curr_end_vco,v_int_num(j),error_pll]=pll3(clk_out,clk1_out,curr_end_vco,v_int_num(j-1),data,out_data(k-2:k-1),slope,j);
    else
        [clk_o,clk_out,clk1_out,t_vcos(j+delay),f_vcos(j+delay),curr_end_vco,v_int_num(j),error_pll]=pll3(clk_out,clk1_out,curr_end_vco,0,data,0,slope,j);
    end
    
    k=k+2;
    j=j+1;
    %----------------------------------------------------------------------
    %---
    
end

figure
plot(1:length(input_vector), input_vector, 1:length(input_vector), 50*clk_out(1:length(input_vector)));
figure
plot(f_vcos);