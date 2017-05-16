function clk_out=pll6(clk_in,t_clk)
N=length(clk_in);
clk_out=zeros(1,N);
t_vco=31;
start_in=0;
start_out=31;
k_df=10;
v_df=0;
for i=2:N
		if(clk_in(i)>clk_in(i-1))
			start_in=i;
			printf('start zegara w %d\n',i);
			break;
		end
end
%clk_out=clk_in;
v_df=k_df*abs(start_out-start_in);
while(v_df>0)
%while(t_vco~=t_clk)%||start_out~=start_in)
	if(t_vco>t_clk)
		%v_df=k_df*abs(start_out-start_in);
		t_clk=t_clk+1;
	else
		t_clk=t_clk-1;
	end
	
	if(start_in>start_out)
		start_in=start_in-1;
	elseif(start_in<start_out)
		start_in=start_in+1;
	end

	for i=1:start_in
		clk_out(i)=0;
	end

	for i=start_in+1:1600
		if(mod(i-start_in,t_clk)<floor(t_clk/2)) 
        clk_out(i)=1; 																
		else
        clk_out(i)=0; 														
		end
	end

	for i=2:N
		if(clk_out(i)>clk_out(i-1))
			start_in=i;
			printf('start zegara w %d\n',i);
			break;
		end
	end
	v_df=k_df*abs(start_out-start_in);
	printf("napiecie detektora fazy: %d\n",v_df);
end
