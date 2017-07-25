function  [out_data, slope_sampled, min_eye300_100, min_eye100_100, min_eye100_300,setup_200, setup0, setup200, hold_200, hold0, hold200, eyeO1, eyeO2, eyeO3, wf]=cdr_prob(input_vector)

global input_bits;
global vector_length;
global sample;
global freq;     % 10GHz
global EUI;      % 0.002ns
global T;        % 0.1ns 
global thr;
global t0;
global f0;

vector_length2=round(vector_length*EUI*4/T);
delay=10;

f_vco_start=1*freq;
f_vcos=zeros(1,vector_length2);
f_vcos(1:delay)=f_vco_start;
t_vcos=zeros(1,vector_length2);
t_vcos(1:delay)=T/EUI*freq/f_vco_start;
%t_vcos_real=zeros(1,vector_length2);
%f_vcos_real=zeros(1,vector_length2);

t0=[54,52,50,48,46];
f0=zeros(1,5);
for i=1:5
    f0(i)=T/t0(i)*freq/EUI;
end

curr=1;

j=1;
%zmienna porzadkowa inkrementowana co wykryte zbocze zegara
clk1_out=0;
error_pll=0;

[clk_out,~,~,clk1_out,curr_end_vco]=clk_gen_f_not_id5(f_vcos(1),0,vector_length,clk1_out,delay); 

fprintf('startowy zegar wyjsciowy wygenerowany do %d\n',curr_end_vco);
v_int_num=zeros(1,vector_length);                                %numeryczna wartosc napiecia wyjsciowego integratora
size_feed=3;
 sample = zeros(1, size_feed);

wf=[0;0;0];
i=1;
t=1;
out_data=[];
slope_sampled=[];
min_eye300_100=[];  
min_eye100_100=[];
min_eye100_300=[];
setup_200=[];
setup0=[];
setup200=[];
hold_200=[];
hold0=[];
hold200=[];
eyeO1=[];
eyeO2=[];
eyeO3=[];

th200= [20; 0];
scaled_th_dat=[-0.5, -0.5, -0.5];

while (i<length(input_vector)-100&&error_pll==0)    
    if(mod(t,4)==0)
        th200(2)=1;
    else
        th200(2)=0;
    end

    [data, slope, min_eye300_100_tmp, min_eye100_100_tmp, min_eye100_300_tmp,setup_200_tmp, setup0_tmp, setup200_tmp, hold_200_tmp, hold0_tmp, hold200_tmp, eyeO1_tmp, eyeO2_tmp, eyeO3_tmp, wf, th200, scaled_th_dat]=data_recovery(input_vector(i:i+74), clk_out(curr+t_vcos(j):curr+5*t_vcos(j)/2), clk_out(curr+5*t_vcos(j)/2+1:curr+4*t_vcos(j)-1), wf, th200, scaled_th_dat);
    curr=curr_vco+t_vcos(j);
    i=i+50;
    t=t+1;
    out_data=[out_data data]; 
    slope_sampled=[slope_sampled slope];
    
    min_eye300_100=[min_eye300_100 min_eye300_100_tmp];
    
    min_eye100_100=[min_eye100_100 min_eye100_100_tmp];
    min_eye100_300=[min_eye100_300 min_eye100_300_tmp];
    setup_200=[setup_200 setup_200_tmp];
    setup0=[setup0 setup0_tmp];
    setup200=[setup200 setup200_tmp];
    hold_200=[hold_200 hold_200_tmp];
    hold0=[hold0 hold0_tmp];
    hold200=[hold200 hold200_tmp];
    eyeO1=[eyeO1 eyeO1_tmp];
    eyeO2=[eyeO2 eyeO2_tmp];
    eyeO3=[eyeO3 eyeO3_tmp]; 
    
    %---------------------Clock_Recovery--------------------------------------%
    
    if(j>1)
        [clk_o,clk_out,clk1_out,t_vcos(j+delay),f_vcos(j+delay),curr_vco,curr_end_vco,v_int_num(j),error_pll]=pll3(clk_out,clk1_out,curr_vco,curr_end_vco,v_int_num(j-1),data,out_data(j-1),slope,j);
    else
        [clk_o,clk_out,clk1_out,t_vcos(j+delay),f_vcos(j+delay),curr_vco,curr_end_vco,v_int_num(j),error_pll]=pll3(clk_out,clk1_out,curr_vco,curr_end_vco,0,data,0,slope,j);
    end
    
    j=j+1;
    %-------------------------------------------------------------------------
    
    
end