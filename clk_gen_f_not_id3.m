function [clk,t_clk,f_clk,clk1,curr_end]=clk_gen_f_not_id3(f_in,start,stop,clk1,t0,f0,vector_length2)

    clk=zeros(1,stop-start);
    t_clk=zeros(1,vector_length2);
    f_clk=zeros(1,vector_length2);
    curr=1; 
    t=1;
    
    while(curr<stop-start&&t<=vector_length2)%&&t<120)
        [curr_end,t_clk(t),f_clk(t),clk1]=attenuate(f_in,curr,clk1,t0,f0,t);
%         f_diff=10^9;
%         while((abs(f_diff)>10^8)&&(j<13))
%               j=j+1;
%               f_diff=f_in-f0(j);
%         end
%         t_clk(t)=t0(j);
%         f_diff=f_diff/10^6;
%         clk1=clk1+f_diff/200;
%         step=t_clk(t);
%         curr_end=curr+step-1;
%         if(curr_end>stop-start)
%             curr_end=stop-start;
%         end
%         %fprintf('roznica zamierzonej i faktycznej cz. to %f MHz\n',f_diff);
%         if(clk1>=0.5)
%             j=j+1;
%             t_clk(t)=t0(j);
%             step=t_clk(t);%floor(T/EUI*freq/f0(j+1));
%             %fprintf('akumulowana roznica zamierzonej i faktycznej cz. przekroczyla 50 MHz, przesuniecie okresu na %d, cz. na %f GHz, generacja sygnalu do %d zamiast %d\n',t_clks(t), f0(j)/10^9,curr+step-1,curr_end_vco);
%             curr_end=curr+step-1;
%             clk1=clk1-0.5;
%         elseif(clk1<0)
%             j=j-1;
%             t_clk(t)=t0(j);
%             step=t_clk(t);%floor(T/EUI*freq/f0(j+1));
%             %fprintf('akumulowana roznica zamierzonej i faktycznej cz. spadla ponizej 50 MHz, przesuniecie okresu na %d, cz. na %f GHz, generacja sygnalu do %d zamiast %d\n',t_clks(t), f0(j)/10^9,curr+step-1,curr_end_vco);
%             curr_end=curr+step-1;
%             clk1=clk1+0.5;
%         end
        %fprintf('realny okres zegara to %d\n',t_clk);
        %fprintf('faktyczna cz. to %f GHz\n',f0(j)/10^9);
        clk(curr:curr_end)=clk_not_id2(t_clk(t),curr,curr_end+1,clk1);
        %fprintf('zegar wygenerowany od %d do %d\n',start+curr,start+curr_end);
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