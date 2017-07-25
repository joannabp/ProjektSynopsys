function  [out_data, slope_sampled, min_eye300_100, min_eye100_100, min_eye100_300,setup_200, setup0, setup200, hold_200, hold0, hold200, eyeO1, eyeO2, eyeO3, wf]=cdr_prob(input_vector, clk)

global input_bits;
global sample;
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

while i<length(input_vector)-100
    if(mod(t,4)==0)
        th200(2)=1;
    else
        th200(2)=0;
    end
    
    [data, slope, min_eye300_100_tmp, min_eye100_100_tmp, min_eye100_300_tmp,setup_200_tmp, setup0_tmp, setup200_tmp, hold_200_tmp, hold0_tmp, hold200_tmp, eyeO1_tmp, eyeO2_tmp, eyeO3_tmp, wf, th200, scaled_th_dat]=data_recovery(input_vector(i:i+74), clk(i+50:i+124), clk(125:199), wf, th200, scaled_th_dat);
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
    
    
end