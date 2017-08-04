
function [peak_val, peak_sampled]= set_peak_val(input_vector, clk, peak_val)

global thr;
rising_edge_detector= clk>=thr; %-----------rising edge vector
rising_edge_detector=[0 diff(rising_edge_detector)>0]>0;



[peak_val, peak_sampled]= sample_peak_val(input_vector, rising_edge_detector, clk, peak_val)