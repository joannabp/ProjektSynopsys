function clk=clk_gen_id(t_clk,start)
global vector_length;
clk=zeros(1,vector_length);
%start=randi(30,1,1);

for i=start+1:vector_length
    if (mod(i-start,t_clk)<floor(t_clk/2)) 
        clk(i)=1;					
    end
end