function clk=clk_make(clk,t_clk)
global vector_length;
global freq;
global T_mid;
global f0;
global UI_probes_mid;
global PJ;
global PJ_tot;
global f_PJ;
global peak_jit;
global thr;
vector_length2=round(vector_length*UI_probes_mid*4/T_mid);
l=length(clk);
t_clks=zeros(1,vector_length2);
slope_end=round(l*4/5);
k=1;
j=0;
if(vector_length>l)
    while(slope_end+t_clk<=l&&slope(clk(slope_end:l))~=0)
        t_clks(k)=slope(clk(slope_end:l));
        slope_end=slope_end+t_clks(k)-1;
        k=k+1;
    end
    %if(clk(l)<=thr)      
    %if(l-slope_end>t_clk/2)
      slope_end_fall=slope_fall(clk(slope_end:l))+slope_end;
      t_clks(k-6:k-1)
      while(slope_end_fall<=slope_end)
        slope_end=slope_end-t_clk;
        if(clk(slope_end-1)==0&&clk(slope_end)<thr)
            slope_end=slope_end+1;
        elseif(clk(slope_end-1)>thr&&clk(slope_end)==1)
            slope_end=slope_end-1;
        end
        slope_end_fall=slope_fall(clk(slope_end:l))+slope_end;
      end
      
    f_diff=10^9;
    while(j==0||(abs(f_diff)>=(f0(j+1)-f0(j))/2)&&(j<6))
        j=j+1;
        f_diff=freq-f0(j);
    end
    f_diff=f_diff/10^6;
    if(freq>f0(j))
            clk1=round((clk(slope_end-1)+f_diff/(f0(j+1)-f0(j))*10^6)*10^3)/10^3;
    else
            clk1=round((clk(slope_end-1)+f_diff/(f0(j)-f0(j-1))*10^6)*10^3)/10^3;
    end
        
      if(clk(slope_end_fall)<thr&&t_clks(k-1)<=t_clks(k-2)&&clk1<thr&&clk1>0)
        slope_end_fall=slope_end_fall-1;
      end
      clk=clk(1:slope_end_fall);
      clk=[clk clk_gen_f_not_id5(freq,length(clk),vector_length,clk(slope_end-1),vector_length2,1)];
    %else
        % clk=[clk ones(1,t_clk/2-(l-slope_end)-1) clk_gen_f_not_id5(freq,0,vector_length-l,clk(slope_end-1),vector_length2,1)];
    %end
figure
plot(clk(l-100:l+100));
end
