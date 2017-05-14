N=1600;
f_clk = 0;
#f_vco=10^9;
f_vco=0;
clk_in=zeros(1,N);
clk_out=zeros(1,N);
pam4_vect=[00 01 00 01 11 10 01 00 00 01 00 01 11 10 01 00 00 01 00 01 11 10 01 00 00 01 00 01 11 10 01 00 00 01 00 01 11 10 01 00 00 01 00 01 11 10 01 00 00 01 00 01 11 10 01 00 00 01 00 01 11 10 01 00];
j=2;
start_in=0;
start_out=0;
while(j<=N)
	if(mod(j,4)==3)
		clk_in(j)=1;
		clk_in(j+1)=1;
		j=j+2;
	else 
		j=j+1;
	end
end
#v_in=[300 298 100 -99 -101 -299 -100 100];
v_in=dane(pam4_vect);
det=zeros(1,N);
slope_sum=0;
df=0;
df_out=zeros(1,N);
v_out=zeros(1,N);
x=zeros(1,N);
x2=zeros(1,N);
for i=2:N
    f_clk=f_clk+get_f(clk_in(i),clk_in(i-1));
end
#f_vco=f_vco*f_clk/N;
for i=2:N
    det(i)=slope(v_in(i),v_in(i-1));
	  if(det(i)~=0) 
				slope_sum=slope_sum+1;
				if(start_in==0)
					start_in=i;
					end
		end
end
if(f_clk~=slope_sum)
	clk_out(1)=clk_in(1);
	j=2;
	while(j<=N)
		x2(j)=mod(j,N/slope_sum);
		if(mod(j,N/slope_sum)<1)
			printf('found_out');
			clk_out(j)=-clk_out(j-1)+1;
			if(start_out==0)
				start_out=j;
				end
		else
			clk_out(j)=clk_out(j-1);
		end
		j=j+1;
	end
end
del=0;
if(start_in~=start_out)
	 while(start_in~=start_out)
		clk_out=delay(clk_out,N/slope_sum);
		del=del+1;
		for i=2:N
			if(clk_out(i)~=clk_out(i-1))
				start_out=i;
				break;
			end
		end
	if(start_in==start_out)
		break;
	end
end
end

	
# for i=2:N
    # x(i)=get_f(clk_in(i),clk_in(i-1));
    # if(x(i)==1&&det(i)==0)
        # df=df+1;
    # end
# end
# j=N;
# df_tot=df;
# while(j>0)
    # if(2^j<=df)
        # df_out(N-j)=1;
        # df=df-2^j;
    # end
    # j=j-1;
# end
				# clk_out(j-1)=clk_in(j-1);
				# if(clk_out(j-1)==1)
					# clk_out(j)=0;
				# else
					# clk_out(j)=1;
				# #clk_out(j+1)=clk_in(j);
				# end
			# else
			# clk_out(j-1)=clk_in(j-1);
			# j=j+1;
			# # end
		# end
		# f_vco=0;
		# # for i=2:N
			# # f_vco=f_vco+get_f(clk_out(i),clk_out(i-1));
				# printf('found2');
		# end
		# if(f_vco<=slope_sum)
			# printf('finished');
			# break;
		# # end
	# end
# end
# # v_out(1)=v_in(1);
# if(f_clk>slope_sum)
	# f_vco=f_vco-df_tot*f_vco/10;
    # for i=2:N
        # if(det(i)+det(i-1)==0)
            # v_out(i)=v_in(i+1);
        # end
    # end
# elseif(f_clk<slope_sum)
	# f_vco=f_vco+df_tot*f_vco/10;
    # for i=2:N
        # if(det(i)+det(i-1)==1)
            # v_out(i)=v_in(i-1);
            # v_out(i+1)=v_in(i);
            # %i=i+1;
        # end
    # end
# end
# 