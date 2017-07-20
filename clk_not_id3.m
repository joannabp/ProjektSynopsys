function clk=clk_not_id3(t_clk,start,stop,clk1,shift)
global thr;
clk=zeros(1,stop-start);

for i=1:stop-start
    if(mod(i,t_clk)==t_clk/2)
        clk(i+shift)=clk1;
    elseif(mod(i,t_clk)==t_clk/2+1)
        clk(i+shift)=thr+clk1;
        fprintf('zbocze w %d\n',i+start+shift);
    elseif(mod(i,t_clk)>t_clk/2||i==t_clk)
        clk(i+shift)=1;
    end
end