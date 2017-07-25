function sample_time=sampletime(clk1,clk2)%,time1,time2)
  global over_sampling;
  global thr;
  % zbocze pomi�dzy pr�bkami( [ 0.15 0.65]->(0.5-wart1)*k_det_zbocza
% -> warto�� w czasie(!) -> por�wnanie z momentem zbocza w czasie sygna�u vco ->
% detektor fazy->
%   clk1
%   clk2
  v_diff=clk2-clk1;
  %t_diff=time2-time1;
  sample_time=ceil(((thr-clk1)/v_diff)*over_sampling);
  %sample_time=ceil((thr-clk1)*over_sampling);
  %printf("probkowanie w momencie %d \n",sample_time);