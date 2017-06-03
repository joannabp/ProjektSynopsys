function clk=clk_gen(t_clk,start)
global vector_length;
clk=zeros(1,vector_length);
%start=randi(30,1,1);

for i=start+1:vector_length
    if (mod(i-start,t_clk) <floor(t_clk/2)) 
      if ((mod(i-start,t_clk)<=2||mod(i-start,t_clk)==floor(t_clk/2)-1))
        clk(i)=1-abs(0.2*randn);					
      else
        clk(i)=1;
      end
    elseif(mod(i-start,t_clk)==floor(t_clk/2)||mod(i-start,t_clk)>=t_clk-2) 
      clk(i)=abs(0.2*randn);
    end
end