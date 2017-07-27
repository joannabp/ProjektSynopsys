function  [out_data, slope_sampled, min_eye300_100, min_eye100_100, min_eye100_300,setup_200, setup0, setup200, hold_200, hold0, hold200, eyeO1, eyeO2, eyeO3, wf]=cdr(input_vector)






wf=[0,0,0];
i=1;

while i<length(input_vector)-probki_na_okres
    
    
    [out_data(t), slope_sampled(t), min_eye300_100(t), min_eye100_100(t), min_eye100_300(t),setup_200(t), setup0(t), setup200(t), hold_200(t), hold0(t), hold200(t), eyeO1(t), eyeO2(t), eyeO3(t), wf]=data_recovery(input_vector(i:probki_na_okres), clk, clk_shf, wf)];
    
    if(t>1)
        [clk_o,clk_out,clk1_out,clk_ideal,t_clks(t),f_clks(t),t_vcos(t),f_vcos(t),slope_in(t),slope_out(t),slope_in_time(t),slope_out_time(t),t_diff(t),curr,curr_sl,curr_end_tot,curr_vco,curr_end_vco,v_int_num(t),error]=pll(clk,clk_ideal,curr,curr_sl,curr_end,curr_end_tot,clk_out,clk1_out,curr_vco,curr_end_vco,time,v_int_num(t-1),t,slope_in(t-1),slope_out(t-1),t_clks(t),f_clks(t));
    else
        [clk_o,clk_out,clk1_out,clk_ideal,t_clks(t),f_clks(t),t_vcos(t),f_vcos(t),slope_in(t),slope_out(t),slope_in_time(t),slope_out_time(t),t_diff(t),curr,curr_sl,curr_end_tot,curr_vco,curr_end_vco,v_int_num(t),error]=pll(clk,clk_ideal,curr,curr_sl,curr_end,curr_end_tot,clk_out,clk1_out,curr_vco,curr_end_vco,time,0,t,0,0,t_clks(t),f_clks(t));
    end
    t=t+1;
    i=i+probki_na_okres;
end