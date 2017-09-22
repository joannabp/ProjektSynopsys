function clk=clk_make(clk,t_clk)
global vector_length;
global freq;
global T_mid;
global UI_probes_mid;
global PJ;
global PJ_tot;
global f_PJ;
global peak_jit;
global thr;
vector_length2=round(vector_length*UI_probes_mid*4/T_mid);

slope_end=1;%round(length(clk)*9/10);
l=length(clk);
while(slope_end+t_clk<l)
    slope_end=slope_end+slope(clk(slope_end:l))-1;
end
if(vector_length>l)
    if(clk(l)<=thr)      
%     if(l-slope_end>t_clk/2)
      slope_end_fall=slope_fall(clk(slope_end:l))+slope_end;
      clk=clk(1:slope_end_fall);
      clk=[clk clk_gen_f_not_id5(freq,0,vector_length-length(clk),clk(slope_end-1),vector_length2,1)];
    else
      clk=[clk ones(1,t_clk/2-(l-slope_end)-1) clk_gen_f_not_id5(freq,0,vector_length-l,clk(slope_end-1),vector_length2,1)];
    end
figure
plot(clk(l-100:l+100));
end
