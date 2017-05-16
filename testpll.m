N=1600;
clk=zeros(1,N);
clk_out=zeros(1,N);
start=randi(30,1,1);
t_clk=randi(64,1,1)+1;
for i=start+1:1600
    if (mod(i-start,t_clk) <floor(t_clk/2)) 
        clk(i)=1; 																#clk blazeja
    end
end
clk_out=pll6(clk,t_clk);
plot(clk(1:66));
ylabel("clk");
figure
plot(clk_out(1:66));
ylabel("clk out");