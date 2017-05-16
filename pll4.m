function clk_out=pll3(clk_in,v_in);
	
#pam4_vect=[00 01 00 01 11 10 01 00 00 01 00 01 11 10 01 00 00 01 00 01 11 10 01 00 00 01 00 01 11 10 01 00 00 01 00 01 11 10 01 00 00 01 00 01 11 10 01 00 00 01 00 01 11 10 01 00 00 01 00 01 11 10 01 00];
#v_in=[300 298 100 -99 -101 -299 -100 100];
#v_in=dane(pam4_vect);
N=length(v_in);
t_clk = 0;
t_vco=32;
det=zeros(1,N);
clk_out=zeros(1,N);
j=2;
start_in=0;
start_out=0;
#clk_in=zeros(1,N);
# while(j<=N)
	# if(mod(j,4)==3)
		# clk_in(j)=1;
		# clk_in(j+1)=1;
		# j=j+2;
	# else 
		# j=j+1;
	# end
# end
# for i=1:1600
    # if (mod(i,31) <15) 
        # clk_in(i)=1; 																#clk blazeja
		# end	
# end
for i=2:N
    if(clk_in(i)>clk_in(i-1))
			if(t_clk==0)
			start_out=i;
			end
		t_clk=t_clk+1;
		end
end
t_clk=ceil(N/t_clk);
clk_out=clk_in;
printf("start zegara w: %d\n",start_out);
#slope_sum=0;
k_df=10;
df=0;
#f_vco=10^9;
#nadp=2;
# df_out=zeros(1,N);
# v_out=zeros(1,N);
# x=zeros(1,N);
# x2=zeros(1,N);
if(t_clk==t_vco)
	for i=2:N
		det(i)=slope(v_in(i),v_in(i-1));
		if(det(i)~=0) 
			#slope_sum=slope_sum+1;
			#printf('found_in');
			if(start_in==0)
				start_in=i;
			end
		end
	end
	#while(f_vco~=N/(slope_sum*nadp)
	printf("pierwsza zmiana napiecia w: %d\n",start_in);
	printf("start zegara w: %d\n",start_out);
	v_df=k_df*abs(start_out-start_in);
	printf("napiecie detektora fazy1: %d\n",v_df);
	del=0;
	while(v_df>0)#start_out~=ceil(start_in/nadp))
		# if((slope_sum*nadp)==0)
			# printf('zero');
			# break;
		# else
		del=del+1;
		printf('start przesuwany do %d\n',del);
		clk_out=delay2(clk_in,t_vco,del);%ceil(N/(nadp)));
		for i=2:N
			if(clk_out(i)>clk_out(i-1))
				start_out=i;
				printf('start out w %d\n',i);
				break;
			end
			if(i==N-1)
				printf('nie znaleziono startu');
			end
		end
		v_df=k_df*abs(start_out-start_in);
		printf("napiecie detektora fazy2: %d\n",v_df);
		# if(start_out==ceil(start_in/nadp))
			# break;
		# end
end
else
	printf("nie wchodzi: t_clk=%d, t_vco=%d\n",t_clk,t_vco);
end
# printf("suma zmian napiecia to: %d\n",slope_sum);
# printf("okres to: %d\n",ceil(N/(slope_sum*nadp)));
# if(f_clk~=slope_sum)
	# clk_out(1)=clk_in(1);
	# j=2;
	# while(j<=N)
		# if((slope_sum*nadp)==0)
			# printf('zero');
			# break;
		# else
		# x2(j)=mod(j,ceil(N/(slope_sum*nadp)));
		# if(mod(j,ceil(N/(slope_sum*nadp)))==0)
			# #printf('found_out');
			# clk_out(j)=-clk_out(j-1)+1;
			# if(start_out==0)
				# start_out=j;
			# end
		# else
			# clk_out(j)=clk_out(j-1);
		# end
		# j=j+1;
		# end
	# end
# end
# del=0;
# while(start_out~=ceil(start_in/nadp))
		# # if((slope_sum*nadp)==0)
			# # printf('zero');
			# # break;
		# # else
		# clk_out=delay(clk_out,f_vco);%ceil(N/(nadp)));
		# del=del+1;
		# for i=2:N
			# if(get_f(clk_out(i),clk_out(i-1))==1)
				# start_out=i;
				# printf('start out w %d\n',i);
				# break;
			# end
		# end
		# # if(start_out==ceil(start_in/nadp))
			# # break;
		# # end
	# end
# end
# v_out=probkowanie(v_in, clk_out);
# plot(v_in);
# figure
# plot(v_out);
# 
	
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