
function [clk_o,clk_out,clk1,t_vco,f_vco,curr_end_vco,v_int_num,kp,z,error]=pll3(clk_out,clk1,curr_end_vco,v_int_num,data,data_prev,slope_in,kp,z,ph_det_mode,t)
%clk,clk_ideal,curr,curr_sl,curr_end,curr_end_tot,clk_out,clk1_out,curr_vco,curr_end_vco,time,v_int_num,t,slope_in_prev,slope_out_prev,t_clk,f_clk,data,slope_sampled)

global vector_length;
global PJ_tot;
ki=1;

error=0;
curr_end_vco_prev=curr_end_vco;

if(t>1)
   % fprintf('poprzednie dane to: %d, %d\n',data_prev(1),data_prev(2));
   % fprintf('inf o zboczu to %d\n', slope_in);
   % fprintf('odebrane dane to: %d,%d\n',data(1),data(2));
    v_df=phase_detector10(data,data_prev,slope_in,ph_det_mode);
else
    v_df=0;
end

[v_int,v_int_num,kp,z]=integrate9(v_df,v_int_num,kp,ki,z,ph_det_mode);
f_vco=freq_change6(v_int);

[clk_o,t_vco,f_vco,clk1,curr_end_vco]=clk_gen_f_not_id5(f_vco,curr_end_vco_prev,vector_length,clk1,1,0);
%fprintf('wygenerowano zegar od %d do %d z cz. %f GHz, clk1=%f\n',curr_end_vco_prev+1,curr_end_vco,f_vco/10^9,clk1);

clk_out(curr_end_vco_prev+1:curr_end_vco)=clk_o;
if(curr_end_vco>=vector_length)
    error=1;
end
fprintf('\n-----------------------------------------------------------\n');