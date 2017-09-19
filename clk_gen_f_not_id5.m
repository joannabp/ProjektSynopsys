function [clk,t_clk,f_clk,clk1,curr_end]=clk_gen_f_not_id5(f_in,start,stop,clk1,vector_length2, dr)
    global t0;
    global f0;
    global peak_jit;
    global PJ;
    global PJ_tot;
    global f_PJ;
    global TJ;
    if(dr==1)
        clk=zeros(1,stop-start);
    end
    %t_clk=zeros(1,vector_length2);
    %f_clk=zeros(1,vector_length2);
    curr=1;
    curr_end=1;
    t=1;
    j=0;
    f_diff=10^9;
    while(j==0||(abs(f_diff)>=(f0(j+1)-f0(j))/2)&&(j<6))
        j=j+1;
        f_diff=f_in-f0(j);
    end
    f_diff=f_diff/10^6
    t_clk=t0(j);
    f_clk=j;
    while(curr<stop-start&&t<=vector_length2)%&&t<120)
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
        if(abs(PJ_tot)>abs(PJ))
            PJ=-PJ;
        end
        f_diff=f_in-f0(j);
        f_diff=f_diff/10^6;
%         clk1=round((clk1+f_diff/(f0(j+1)-f0(j-1))*10^6*2)*10^3)/10^3+RJ;
        if(f_in>f0(j))
            clk1=round((clk1+f_diff/(f0(j+1)-f0(j))*10^6)*10^3)/10^3+RJ;
        else
            clk1=round((clk1+f_diff/(f0(j)-f0(j-1))*10^6)*10^3)/10^3+RJ;
        %if(dr==0)
            %fprintf('clk1 wynosi: %d\n',clk1);
        %end
        end
        if(clk1>=0.5)
            shift=-1;
            clk1=clk1-0.5;
            %t_clk=t_clk-1;
        elseif(clk1<0)
            shift=1;
            clk1=clk1+0.5;
            %t_clk=t_clk+1;
        else
            shift=0;
        end
%         if(clk1>0.5)
%             clk1=clk1-0.5;
%             shift=shift-1;
%         elseif(clk1<0)
%             clk1=clk1+0.5;
%             shift=shift+1;
%         end
        %clk1
        curr_end=curr+t0(j)-1+shift;
        %if(dr==0)
            %fprintf('generacja od: %d do %d\n',curr+start,curr_end+start);
        %end
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