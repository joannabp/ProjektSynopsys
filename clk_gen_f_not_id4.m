function [clk,clk1,curr_end]=clk_gen_f_not_id4(f_in,start,stop,clk1,t0,f0,vector_length2)

    clk=zeros(1,stop-start);
    %t_clk=zeros(1,vector_length2);
    %f_clk=zeros(1,vector_length2);
    curr=1; 
    t=1;
    j=0;
    f_diff=10^9;
    while((abs(f_diff)>2*10^8)&&(j<6))
        j=j+1;
        f_diff=f_in-f0(j);
    end
    f_diff=f_diff/10^6
    
    while(curr<stop-start&&t<=vector_length2)%&&t<120)
        t
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
        clk1
        curr_end=curr+t0(j)-1+shift
        clk(curr:curr_end)=clk_not_id3(t0(j),curr,curr_end+1,clk1,shift);
        fprintf('zegar wygenerowany od %d do %d\n',start+curr,start+curr_end);
        fprintf('------------------------------------------------------\n');
        curr=curr_end+1;
        if(curr>=stop)
            break;
        end
        if(curr_end>stop)
            curr_end=stop;
        end
        t=t+1;
    end
    clk=clk(1:stop-start);