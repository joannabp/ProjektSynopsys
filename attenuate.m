function [curr_end, t_clk, f_clk, clk1,j]=attenuate(f_in,start,clk1,t0,f0,t,j_prev)
     f_diff=10^9;
     j=0;
     curr=start;
     if(j_prev==0)
         while((abs(f_diff)>5*10^7)&&(j<13))
             j=j+1;
             f_diff=f_in-f0(j);
         end
     else
         j=j_prev;
         f_diff=f_in-f0(j);
     end
     t_clk=t0(j);
     f_diff=f_diff/10^6;
     clk1=clk1+f_diff/200;
     step=t_clk;
     curr_end=curr+step-1;
     fprintf('roznica zamierzonej i faktycznej cz. to %f MHz\n',f_diff);
%     while(clk1>=0.5||clk1<0)
     if(clk1>=0.5)
         %clk1=0.5;%clk1-f_diff/200;
         j=j+1;
         t_clk=t0(j);
         step=t_clk;%floor(T/EUI*freq/f0(j+1));
         fprintf('akumulowana roznica zamierzonej i faktycznej cz. przekroczyla 50 MHz, przesuniecie okresu na %d, cz. na %f GHz, generacja sygnalu do %d zamiast %d\n',t_clk, f0(j)/10^9,curr+step-1,curr_end);
         curr_end=curr+step-1;
         f_diff=f_in-f0(j);
         f_diff=f_diff/10^6;
         if(t>1)
            clk1=clk1-0.5;%clk1+f_diff/100;
         else
            clk1=f_diff/200;
         end
     elseif(clk1<0)
         %clk1=0;%clk1-f_diff/200;
         j=j-1;
         t_clk=t0(j);
         step=t_clk;%floor(T/EUI*freq/f0(j+1));
         fprintf('akumulowana roznica zamierzonej i faktycznej cz. spadla ponizej 0, przesuniecie okresu na %d, cz. na %f GHz, generacja sygnalu do %d zamiast %d\n',t_clk, f0(j)/10^9,curr+step-1,curr_end);
         curr_end=curr+step-2;
         f_diff=f_in-f0(j);
         f_diff=f_diff/10^6;
         if(t>1)
            clk1=clk1+0.5;%clk1+f_diff/100;
         else
            clk1=f_diff/200;
         end
     end
%     end
     if(clk1<0)
         clk1=0;
     elseif(clk1>=0.5)
         clk1=0.4999;
     end
     f_clk=f0(j);
end