function [clk,t_clk,f_clk,clk1,curr_end, PJ_total]=clk_gen_f_not_id5(f_in,start,stop,clk1,vector_length2, dr)
    global t0;
    global f0;
    global peak_jit;
    global PJ;
    global PJ_tot;
    global f_PJ;
    global TJ;
    if(dr>=1)
        clk=zeros(1,stop-start);
    end
    if(abs(dr)==2)
        shift=dr/abs(dr);
    else
        shift=0;
    end
%     t_clk=zeros(1,vector_length2);
%     f_clk=zeros(1,vector_length2);
%     PJ_total=zeros(1,vector_length2);
    curr=1;
    curr_end=1;
    t=1;
    j=0;
    f_diff=10^9;
    while(j==0||(abs(f_diff)>=(f0(j+1)-f0(j))/2)&&(j<6))
        j=j+1;
        f_diff=f_in-f0(j);
    end
    t_clk=t0(j);
    while(curr<stop-start&&(t<=vector_length2||dr==1))
        %t
        if(dr==0)
            RJ=randn()*TJ;
            if(abs(RJ)>peak_jit*TJ)
                RJ=peak_jit;
                fprintf('peak jitter\n');
            end
        else
            RJ=0;
        end
        f_in=f_in/(1+PJ*f_PJ);
        PJ_tot=PJ_tot+PJ*f_PJ/f_in;
%         PJ_total(t)=PJ_tot;
        if(abs(PJ_tot)>abs(PJ))
            PJ=-PJ;
        end
        f_diff=f_in-f0(j);
        f_diff=f_diff/10^6;
        if(f_in>f0(j))
            clk1=round((clk1+f_diff/(f0(j+1)-f0(j))*10^6)*10^3)/10^3+RJ;
        else
            clk1=round((clk1+f_diff/(f0(j)-f0(j-1))*10^6)*10^3)/10^3+RJ;
        end
%         clk1=round((clk1+f_diff/(f0(j+1)-f0(j-1))*10^6*2)*10^3)/10^3+RJ;
%         if(dr==0)
%             fprintf('clk1 wynosi: %d\n',clk1);
%         end
        if(t>1)
            shift=0;
        end
        while(clk1>=0.5||clk1<0)
            if(clk1>=0.5)
                shift=shift-1;
                clk1=clk1-0.5;
            elseif(clk1<0)
                shift=shift+1;
                clk1=clk1+0.5;
            end
        end
        curr_end=curr+t0(j)-1+shift;
        clk(curr:curr_end)=clk_not_id3(t0(j),curr,curr_end+1,clk1,shift);
%         fprintf('zegar wygenerowany od %d do %d\n',start+curr,start+curr_end);
%         fprintf('------------------------------------------------------\n');
        curr=curr_end+1;
        if(curr>=stop)
            break;
        end
        if(curr_end>stop)
            curr_end=stop;
        end
        t=t+1;
    end
    if(length(clk)>stop-start)
        clk=clk(1:stop-start);
    end
    curr_end=curr_end+start;   
    if(curr_end>stop)
        curr_end=stop;
    end
%     PJ_total=PJ_total(1:t-1);
    f_clk=f_in;