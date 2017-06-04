function [clk_out,t_clk]=clk_div(clk_in,n)
  global vector_length;
  %global t_clk_start=4;
  %global start1=4;
  %clk_out=zeros(1,vector_length);
  %start=start1;
  %t_clk=t_clk_start;
  %start=0;
  %t_clk=1;
  %start=slope(clk_in);
  %for i=start+1:vector_length
   % if(clk_in(i+1)~=clk_in(i))
    %  break;
    %end
    %t_clk=t_clk+1;
  %end
  %t_clk=t_clk*2;
  clk_out=clk_ideal_gen(vector_length,n);
  t_clk=n;
  %printf("mamy t_clk = %d\n",t_clk);
  %t_clk=t_clk*n;
  printf("zwiekszamy t_clk do %d\n",t_clk);
  %for i=start+1:vector_length
    %if (mod(i-start,t_clk)<floor(t_clk/2)) 
        %clk(i)=1;					
    %end
  %end
end