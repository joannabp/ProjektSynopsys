
function start=slope_fall(clk)
global thr;
start=0;
i=2;
while((start==0)&&(i<=length(clk)))
    if(clk(i)<=thr&&clk(i-1)>thr)
        start=i-1;
    else
        i=i+1;
    end
end
if(start==0)
    fprintf('nie znaleziono zbocza\n');
end