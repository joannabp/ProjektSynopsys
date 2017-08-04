
function start=slope(clk)
global vector_length;
global thr;
	start=0;
	i=2;
	while((start==0)&&(i<length(clk)))
    if(clk(i)>=thr&&clk(i-1)<thr)
			start=i;
	  end
	i=i+1;
	end
  if(start==0)
    fprintf('nie znaleziono zbocza\n');
end