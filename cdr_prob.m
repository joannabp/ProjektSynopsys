% function  [out_data, slope_sampled, min_eye300_100, min_eye100_100, min_eye100_300,setup_200, setup0, setup200, hold_200, hold0, hold200, eyeO1, eyeO2, eyeO3, wf]=cdr_prob(input_vector)
% 
% global input_bits;
% global sample;
% 
% % ---------------------- clock recovery-------------------%
% global vector_length;
% global freq;     % 10GHz
% global EUI;      % 0.002ns
% global T;        % 0.1ns 
% global thr;
% global t0;
% global f0;
% global prev_val;
% 
% vector_length2=round(vector_length*EUI*4/T);
% delay=10;
% 
% f_vco_start=1*freq;
% f_vcos=zeros(1,vector_length2);
% f_vcos(1:delay)=f_vco_start;
% t_vcos=zeros(1,vector_length2);
% t_vcos(1:delay)=T/EUI*freq/f_vco_start;
% %t_vcos_real=zeros(1,vector_length2);
% %f_vcos_real=zeros(1,vector_length2);
% 
% curr=1;
% 
% j=1;
% %zmienna porzadkowa inkrementowana co wykryte zbocze zegara
% clk1_out=0;
% error_pll=0;
% 
% [clk_out,~,~,clk1_out,curr_end_vco]=clk_gen_f_not_id5(f_vcos(1),0,vector_length,clk1_out,delay); 
% 
% fprintf('startowy zegar wyjsciowy wygenerowany do %d\n',curr_end_vco);
% v_int_num=zeros(1,vector_length);                                %numeryczna wartosc napiecia wyjsciowego integratora
% 
% %-----------------------%---------------------------------%----------------
%  % --------------data recovery--------------------------%
% size_feed=3;
%  sample = zeros(1, size_feed);
% 
% wf=[0;0;0];
% i=1;
% t=1;
% k=1;
% out_data=zeros(1,input_bits);
% slope_sampled=zeros(1,input_bits);
% min_eye300_100=zeros(1,input_bits);  
% min_eye100_100=zeros(1,input_bits);
% min_eye100_300=zeros(1,input_bits);
% setup_200=zeros(1,input_bits);
% setup0=zeros(1,input_bits);
% setup200=zeros(1,input_bits);
% hold_200=zeros(1,input_bits);
% hold0=zeros(1,input_bits);
% hold200=zeros(1,input_bits);
% eyeO1=zeros(1,input_bits);
% eyeO2=zeros(1,input_bits);
% eyeO3=zeros(1,input_bits);
% 
% th200_k= [20; 0];
% scaled_th_dat=[-1.5, -1.5, -1.5];
% prev_val=[0,0]
% %-----------------------%---------------------------------%----------------
% while ((i<length(input_vector)-100) &&error_pll==0&&j<30)
%     if(mod(t,4)==0)
%         th200_k(2)=1;
%     else
%         th200_k(2)=0;
%     end
%     fprintf('petla cdr \n');
% 
%     clk1(i:i+3/2*t_vcos(j)-1)=clk_out(i+t_vcos(j):i+5/2*t_vcos(j)-1); 
%     clk2(i:i+3/2*t_vcos(j)-1)=clk_out(i+3/2*t_vcos(j):i+3*t_vcos(j)-1);
%     [data, slope, min_eye300_100_tmp, min_eye100_100_tmp, min_eye100_300_tmp,setup_200_tmp, setup0_tmp, setup200_tmp, hold_200_tmp, hold0_tmp, hold200_tmp, eyeO1_tmp, eyeO2_tmp, eyeO3_tmp, wf, th200_k, scaled_th_dat]=data_recovery(input_vector(i:i+t_vcos(j)), clk_out(i:i+t_vcos(j)), clk_out(i+t_vcos(j)/2:i+t_vcos(j)+t_vcos(j+1)/2), wf, th200_k, scaled_th_dat);
%     prev_val=data;
%     curr=curr+t_vcos(j);
% 
%      out_data(k: k+1)=data; 
%     slope_sampled(t)=slope;
%     
% %     min_eye300_100(t)=min_eye300_100_tmp;
% %     
% %     min_eye100_100(t)=min_eye100_100_tmp;
% %     min_eye100_300(t)=min_eye100_300_tmp;
% %     setup_200(t)=setup_200_tmp;
% %     setup0(t)=setup0_tmp;
% %     setup200(t)=setup200_tmp;
% %     hold_200(t)=hold_200_tmp;
% %     hold0(t)=hold0_tmp;
% %     hold200(t)=hold200_tmp;
% %     eyeO1(t)=eyeO1_tmp;
% %     eyeO2(t)=eyeO2_tmp;
% %     eyeO3(t)=eyeO3_tmp;
%     
%     i=i+50;
%     t=t+1;
%     
%      %---------------------Clock_Recovery----------------------------------
%      %----%
%     if(j>1)
%         [clk_o,clk_out,clk1_out,t_vcos(j+delay),f_vcos(j+delay),curr_end_vco,v_int_num(j),v_df,error_pll]=pll3(clk_out,clk1_out,curr_end_vco,v_int_num(j-1),data,out_data(k-2:k-1),slope,v_df,j);
%     else
%         [clk_o,clk_out,clk1_out,t_vcos(j+delay),f_vcos(j+delay),curr_end_vco,v_int_num(j),v_df,error_pll]=pll3(clk_out,clk1_out,curr_end_vco,0,data,0,slope,0,j);
%     end
%     
%     k=k+2;
%     j=j+1;
%     %----------------------------------------------------------------------
%     %---
%     
% end
% % 
% % figure
% % plot(1:length(input_vector), input_vector, 1:length(input_vector),50*clk_out(1:length(input_vector)))
% figure
% plot(1:length(clk1),50*clk1,1:length(clk1),50*clk2(1:length(clk1)));
% figure
% plot(f_vcos(1:j));
% figure
% plot(v_int_num(1:j));
% figure
% plot(t_vcos(1:j));

function  [out_data, slope_sampled, min_eye300_100, min_eye100_100, min_eye100_300,setup_200, setup0, setup200, hold_200, hold0, hold200, eyeO1, eyeO2, eyeO3, wf,clk_out,clk2]=cdr_prob(input_vector)

global input_bits;


% ---------------------- clock recovery-------------------%
global vector_length;
global freq;     % 10GHz
global EUI;      % 0.002ns
global T;        % 0.1ns 
global thr;
global t0;
global f0;
global prev_val;
global acc_size;
global nonsignificant_bits;
global f_vco_start;

f_vco_start=1*freq;
acc_size=14;
nonsignificant_bits=acc_size-10;

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
z=0;
j=1;
%zmienna porzadkowa inkrementowana co wykryte zbocze zegara
clk1_out=0;
error_pll=0;
kps=ones(1,vector_length2);
%kps=kps*8;
%clk_out=zeros(1,25);
[clk_out,~,~,clk1_out,curr_end_vco]=clk_gen_f_not_id5(f_vcos(1),0,vector_length,clk1_out,delay,0);
clk_out=clk_out(12:curr_end_vco);
curr_end_vco=curr_end_vco-11;
%clk_out=[clk_out clk_out2];
% 
% clk_out=clk_out(25:curr_end_vco);
%curr_end_vco=curr_end_vco+25;
clk2=clk_out(26:curr_end_vco);
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
sl1=zeros(1,vector_length2);
sl2=zeros(1,vector_length2);
t_clk1=zeros(1,vector_length2);
t_clk2=zeros(1,vector_length2);
t_clk1(1)=50;
t_clk2(1)=50;

th200_k= [20; 0];
scaled_th_dat=[-1.5, -1.5, -1.5];
prev_val=[0,0]


%input_vector=input_vector(1:length(input_vector));
%-----------------------%---------------------------------%----------------
while ((i<length(input_vector)-100) &&error_pll==0)%&&j<50)
    if(mod(t,4)==0)
        th200_k(2)=1;
    else
        th200_k(2)=0;
    end
    fprintf('petla cdr \n');
    %clk2(i:i+t_vcos(j))=clk_out(i+round(t_vcos(j)/2):i+round(3/2*t_vcos(j)));
     sl1(j)=slope(clk_out(i:length(clk_out)));
    sl2(j)=slope(clk2(i:length(clk2)));
    if(j>1)
        sl1(j)=sl1(j)+i;
        sl2(j)=sl2(j)+i;
        t_clk1(j)=sl1(j)-sl1(j-1);
        t_clk2(j)=sl2(j)-sl2(j-1);
    end
    i
    fprintf('t vco: %d \n',t_clk1(j));
    fprintf('pobierany clk od %d do %d\n',i,i+t_vcos(j));
    [data, slope1, min_eye300_100_tmp, min_eye100_100_tmp, min_eye100_300_tmp,setup_200_tmp, setup0_tmp, setup200_tmp, hold_200_tmp, hold0_tmp, hold200_tmp, eyeO1_tmp, eyeO2_tmp, eyeO3_tmp, wf, th200_k, scaled_th_dat, sample]=data_recovery(input_vector(i:i+t_clk1(j)), clk_out(i:i+t_clk1(j)), clk_out(i:i+t_clk1(j)), wf, th200_k, scaled_th_dat, sample);
    
    fprintf('pobierany clk od %d do %d\n',i+25,i+25+t_vcos(j));
    [data1, slopes, min_eye300_100_tmp1, min_eye100_100_tmp1, min_eye100_300_tmp1,setup_200_tmp1, setup0_tmp1, setup200_tmp1, hold_200_tmp1, hold0_tmp1, hold200_tmp1, eyeO1_tmp1, eyeO2_tmp1, eyeO3_tmp1, wf1, th200_k1, scaled_th_dat1, sample1]=data_recovery(input_vector(i+round(t_clk2(j)/2):i+round(3/2*t_clk2(j))+1), clk2(i:i+t_clk2(j)+10), clk2(i+round(t_clk2(j)/2):i+round(3/2*t_clk2(j))+1), wf, th200_k, scaled_th_dat, sample);
    
   
    
    %[data, slope, min_eye300_100_tmp, min_eye100_100_tmp, min_eye100_300_tmp,setup_200_tmp, setup0_tmp, setup200_tmp, hold_200_tmp, hold0_tmp, hold200_tmp, eyeO1_tmp, eyeO2_tmp, eyeO3_tmp, wf, th200_k, scaled_th_dat]=data_recovery(input_vector(i:i+t_vcos(j)+10), clk_driv(1+(i-1)*61 +25:i*61+25), clk_driv(1+(i-1)*61+50:i*61+50), wf, th200_k, scaled_th_dat);
    prev_val=data;
    curr=curr+t_vcos(j);

    out_data(k: k+1)=data; 
    slope_sampled(j)=slopes;
    
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
        [clk_o,clk_out,clk1_out,t_vcos(j+delay),f_vcos(j+delay),curr_end_vco,v_int_num(j),kps(j+1),z,error_pll]=pll3(clk_out,clk1_out,curr_end_vco,v_int_num(j-1),data,out_data(k-2:k-1),slope_sampled(j-1),kps(j),z,j);     
        %kps(j+1)=kpalg(kps(j),v_int_num(j),v_int_num(j-1));
    else
        [clk_o,clk_out,clk1_out,t_vcos(j+delay),f_vcos(j+delay),curr_end_vco,v_int_num(j),kps(j+1),z,error_pll]=pll3(clk_out,clk1_out,curr_end_vco,2^(acc_size-1)+(f_vco_start-freq)/10^6,data,0,slopes,kps(j),z,j);
    end
    clk2=[clk2 clk_o];
    
    %----------------------------------------------------------------------
  
    
   %---------------------Ctle_adapt----------------------------------
   if(j>4)
        fprintf('ctle_adapt \n');
       ctle_val=ctle_adapt(out_data(k-6:k+1), slope_sampled(j-2:j-1))
    end
   %-----------------------------------------------------------% 
    k=k+2;
    j=j+1;
end
save('kps.mat', 'kps');

clk2=clk2(1:length(input_vector));
figure
plot(1:length(clk2), input_vector(1:length(clk2)), 1:length(clk2), 50*clk_out(1:length(clk2)), 1:length(clk2), 50*clk2(1:length(clk2)));
figure
plot(f_vcos(1:j));
figure
plot(v_int_num(1:j));
% figure
%scatter(1:j,sl1(1:j),1:j,sl2(1:j));
figure
plot(kps(1:j))