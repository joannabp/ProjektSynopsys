function [clk,t_clk,f_clk,clk1,curr_end,t_shift,PJ_total]=clk_gen_f_not_id5(f_in,start,stop,clk1,vector_length2,dr)
    global t0;
    global f0;
    global PJ;
    global PJ_tot;
    global freq;
    global f_PJ;
    global TJ;
    if(dr>=1)
        clk=zeros(1,stop-start);
        RJ=0;
    else
        PJ=0;
    end
    t_shift=zeros(1,vector_length2);
    t_shift_max=1e9;
    %PJ_tot0=0;
%     t_clk=zeros(1,vector_length2);
%     f_clk=zeros(1,vector_length2);
%     PJ_total=zeros(1,vector_length2);
    curr=1;
    curr_end=1;
    t=1;
    j=0;
    PJ_prev=0;
    f_diff=10^9;
    if(dr==1)
        PJ=PJ/2;
    end
    while(j==0||(abs(f_diff)>=(f0(j+1)-f0(j))/2)&&(j<6))
        j=j+1;
        f_diff=f_in-f0(j);
    end
    t_clk=t0(j);
    while(curr<stop-start&&(t<=vector_length2||dr==1))
        if(dr==0)
            RJ=randn()*TJ;
            f_in=f_in+RJ;
        elseif(abs(PJ)>0)
            f_in=freq+PJ*sin(PJ_tot/PJ*pi());%f_in/(1+PJ*f_PJ);
            f_diff=f_in-f0(j);
            PJ_tot=PJ_tot+PJ*f_PJ/f_in;
        end
        
        t_shift(t)=1/f_in-1/freq;
        if(t>1)
            t_shift(t)=t_shift(t)+t_shift(t-1);
        end
        
        if(abs(t_shift(t))>t_shift_max&&abs(PJ)>0)
            if(t_shift(t)>0)
                t_shift(t)=t_shift_max-t_shift(t-1);
            else
                t_shift(t)=-t_shift_max-t_shift(t-1);
            end
            f_in=freq/(t_shift(t)*freq+1);
            f_diff=f_in-f0(j);
            t_shift(t)=1/f_in-1/freq;
            t_shift(t)=t_shift(t)+t_shift(t-1);
        end
        
        if(abs(PJ_tot)>abs(PJ))
            PJ=-PJ;
            PJ_prev=PJ_tot;
            PJ_tot=0;
            if(dr==1)
                PJ=2*PJ;
                dr=2;
                t_shift_max=abs(t_shift(t));
            end
        end
        
        if(f_in>f0(j))
            %clk1_prev=clk1;
            clk1=round((clk1+f_diff/(f0(j+1)-f0(j)))*10^6)/10^6;%+RJ;%clk1+f_diff/(f0(j+1)-f0(j))*10^6+RJ;
            %clk1=clk1+f_diff/(f0(j+1)-f0(j));
            %clk1_id=round((clk1_id+(freq-f0(j))/(f0(j+1)-f0(j)))*10^6)/10^6;
        else
            %clk1_prev=clk1;
            clk1=round((clk1+f_diff/(f0(j)-f0(j-1)))*10^6)/10^6;
            %clk1=clk1+f_diff/(f0(j+1)-f0(j));
            %+RJ;%clk1+f_diff/(f0(j)-f0(j-1))*10^6+RJ;
            %clk1_id=round((clk1_id+(freq-f0(j))/(f0(j)-f0(j-1)))*10^6)/10^6;
        end
        
%         clk1=round((clk1+f_diff/(f0(j+1)-f0(j-1))*10^6*2)*10^3)/10^3+RJ;
%         if(dr==0)
%             fprintf('clk1 wynosi: %d\n',clk1);
%         end
        shift=0;
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
    f_clk=f_in;
    PJ_tot=PJ_prev;
    if(length(clk)>stop-start)
        clk=clk(1:stop-start);
    end
    curr_end=curr_end+start;   
    if(curr_end>stop)
        curr_end=stop;
    end
    t_shift=t_shift(1:t-1);
%     PJ_total=PJ_total(1:t-1);