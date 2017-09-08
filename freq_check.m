function [f_clk,t_clk] = freq_check(clk)
    global vector_length2;
    f_clk=zeros(1,vector_length2);
    sl=zeros(1,vector_length2);
    t_clk=zeros(1,vector_length2);
    j=1;
    i=1;
    while(i<length(clk))
        sl(j)=slope(clk(i:length(clk)));        
        if(sl(j)==0)
            break;
        end
        %f_clk(j)=clk(sl(j)-1)*(f0(fzero+1)-f0(fzero-1))/2+f0(fzero);
        if(j>1)
            sl(j)=sl(j)+i;
            t_clk(j)=sl(j)-sl(j-1)+(0.5-clk(sl(j)-1))/0.5-(0.5-clk(sl(j-1)-1))/0.5;
            f_clk(j)=round(500/t_clk(j)*10^3)*10^6;
            %fprintf('wykryta cz. to %d\n',f_clk(j));
%             clk1d(j)=clk(sl(j)-1)-clk(sl(j-1)-1);
%             if(j>3)
%                         if(sl(j)-sl(j-1)>sl(j-1)-sl(j-2))
%                             fzero=fzero-1;
%                         elseif(sl(j)-sl(j-1)<sl(j-1)-sl(j-2))
%                             fzero=fzero+1;
%                         end
%             end
%             f_clks(j)=clk(sl(j)-1)+(0.5-clk(sl(j)-1))/(0.5-clk(sl(j-1)-1)%clk1d(j)*(f0(fzero+1)-f0(fzero-1))/2+T_mid/t_clk(j)*freq_mid/UI_probes_mid;
        end
        i=sl(j);
        j=j+1;
    end
    %f_clk=f_clk(1,2:vector_length2);

