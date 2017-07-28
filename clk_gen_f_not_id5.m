function [clk,t_clk,f_clk,clk1,curr_end]=clk_gen_f_not_id5(f_in,start,stop,clk1,vector_length2,full)
    global t0;
    global f0;
    if(full==1)
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
    f_clk=f0(j);
    while(curr<stop-start&&t<=vector_length2)%&&t<120)
        %t
        clk1=clk1+f_diff/400;
        if(clk1>0.5)
            shift=-1;
            clk1=clk1-0.5;
        elseif(clk1<0)
            shift=1;
            clk1=clk1+0.5;
        else
            shift=0;
        end
        %clk1
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