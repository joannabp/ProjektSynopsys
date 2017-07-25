function [out_data, slope_sampled, min_eye300_100, min_eye100_100, min_eye100_300,setup_200, setup0, setup200, hold_200, hold0, hold200, eyeO1, eyeO2, eyeO3, wf, th200, scaled_th_dat]=data_recovery(input_vector, clk, clk_shf, wf, th200, scaled_th_dat)

global min_eye_opening;
global setup_t;
global hold_t;
global unres_val;
global sample;

vector_length=length(input_vector);
%-------------------------- %
%ctle_vector = ctle(input_vector);
%-------rising edge detection ------%
thresh=0.5;
rising_edge_detector= clk>=thresh; %-----------rising edge vector
rising_edge_detector=[0 diff(rising_edge_detector)>0]>0;

% ------------------- half shifted rising edge detection ------------% 
thresh=0.5;
rising_edge_detector_shf= clk_shf>thresh; %-----------rising edge vector
rising_edge_detector_shf=[0 diff(rising_edge_detector_shf)>0]>0;
wf
th200
co=[wf; th200]
[out_data, th_200, th0, th200, slope_sampled, co, scaled_th_dat]=adapt_dfe(input_vector, rising_edge_detector, rising_edge_detector_shf, clk, co, scaled_th_dat);

[out_data, th_200, th0, th200,slope_sampled, wf]=sample_and_decode_data(input_vector, rising_edge_detector, rising_edge_detector_shf, clk, wf);
%eq_data=ctle(input_vector);
[setup_200, setup0, setup200, hold_200, hold0, hold200, out_data]=setup_hold_check(input_vector, clk, rising_edge_detector, th0, th_200, th200, out_data); 

[min_eye300_100, min_eye100_100, min_eye100_300, eyeO1, eyeO2, eyeO3]=eye_values(input_vector, rising_edge_detector);
wf=co(1:3);
th200=co(4:5);





