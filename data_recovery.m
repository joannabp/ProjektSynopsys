function [out_data, slope_sampled, min_eye300_100, min_eye100_100, min_eye100_300,setup_200, setup0, setup200, hold_200, hold0, hold200, eyeO1, eyeO2, eyeO3, wf, th200_k, scaled_th_dat, sample]=data_recovery(input_vector, clk, clk_shf, wf, th200_k, scaled_th_dat, sample)


global thr;
%-------------------------- %
%ctle_vector = ctle(input_vector);
%-------rising edge detection ------%

rising_edge_detector= clk>=thr; %-----------rising edge vector
rising_edge_detector=[0 diff(rising_edge_detector)>0]>0;

% ------------------- half shifted rising edge detection ------------% 

rising_edge_detector_shf= clk_shf>thr; %-----------rising edge vector
rising_edge_detector_shf=[0 diff(rising_edge_detector_shf)>0]>0;


%coeffs=[wf; th200_k]
%[out_data, th_200, th0, th200, slope_sampled, coeffs,
%scaled_th_dat]=adapt_dfe(input_vector, rising_edge_detector, rising_edge_detector_shf, clk, coeffs, scaled_th_dat);
    

[out_data, th_200, th0, th200,slope_sampled, wf, scaled_th_dat, sample]=sample_and_decode_data(input_vector, rising_edge_detector, rising_edge_detector_shf, clk, wf, scaled_th_dat, sample);
%eq_data=ctle(input_vector);
[setup_200, setup0, setup200, hold_200, hold0, hold200, out_data]=setup_hold_check(input_vector, clk, rising_edge_detector, th0, th_200, th200, out_data); 

[min_eye300_100, min_eye100_100, min_eye100_300, eyeO1, eyeO2, eyeO3]=eye_values(input_vector, rising_edge_detector);

%wf=coeffs(1:3);
%th200_k=coeffs(4:5);




