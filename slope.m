
function start=slope(clk)
global vector_length;
	start=0;
	i=2;
	while((start==0)&&(i<=vector_length))
		if(clk(i)>clk(i-1))
			start=i;
	end
	i=i+1;
	end
end