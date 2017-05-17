function clk=clk_gen(t_clk,start)
global vector_length;
clk=zeros(1,vector_length);
clk_out=zeros(1,vector_length);

for i=start+1:vector_length
    if (mod(i-start,t_clk) <floor(t_clk/2)) 
        clk(i)=1; 						
    end
end
end