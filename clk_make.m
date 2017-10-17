function [clk,f_clk,PJ_total]=clk_make(clk,t_clk,f_clk)
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
t_clks=zeros(1,vector_length2/10);
l=length(clk);
slope_end=round(l*4/5);
k=1;
if(l<100)
    [clk,~,~,~,~,PJ_total]=clk_gen_f_not_id5(f_clk,0,vector_length,0,vector_length2,1);
elseif(vector_length>l)
    while(slope_end+t_clk<=l&&slope(clk(slope_end:l))~=0)
        t_clks(k)=slope(clk(slope_end:l));
        slope_end=slope_end+slope(clk(slope_end:l))-1;
        k=k+1;
    end
    slope_end_fall=slope_fall(clk(slope_end:l))+slope_end;
    while(slope_end_fall<=slope_end)
        slope_end=slope_end-t_clk;
        if(clk(slope_end-1)==0&&clk(slope_end)<thr)
            slope_end=slope_end+1;
        elseif(clk(slope_end-1)>thr&&clk(slope_end)==1)
            slope_end=slope_end-1;
        end
        slope_end_fall=slope_fall(clk(slope_end:l))+slope_end;
        k=k-1;
    end
    
    if(clk(slope_end_fall)<thr&&t_clks(k-1)>t_clk)
        slope_end_fall=slope_end_fall-1;
    end
    clk=clk(1:slope_end_fall);
    [clk2,~,f_clk]=clk_gen_f_not_id5(f_clk,length(clk),vector_length,clk(slope_end-1),vector_length2,1);
    clk=[clk clk2];
    
    figure
    plot(clk(l-100:l+100));
end
