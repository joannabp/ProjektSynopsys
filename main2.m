clear all;
global vector_length;
global minimum_eye_opening;
global setup_t;
global hold_t;

vector_length=1600;

N=1600;
clk=zeros(1,N);
#clk_blaz=zeros(1,N);
clk_out=zeros(1,N);
# t=0;
# j=1;
# while(j<=N)
	# if(mod(j,4)==3)
		# clk(j)=1;
		# clk(j+1)=1;
		# j=j+2;
	# else 
		# j=j+1;
	# end
# end
# # for i=1:1600
    # if (mod(i,31) ~=0) 
        # clk(i)=0; 																#clk asi
    # else 
        # clk(i)=1;
    # end
# end
for i=15:1600
    if (mod(i,31) <15) 
        clk(i)=1; 																#clk blazeja
    # else 
        # clk_blaz(i)=1;
    end
end
# for i=1:1600
    # if (mod(i,8)==0) 														#clk blazeja
		# t=-t+1;
    # end
    # clk(i)=t;
# end
sum_clk=sum(clk);
input_num=randi([0 1], 100, 1);

out_vect=driv_script(input_num);
clk_out=pll3(clk,out_vect);
[data, min_eye300_100, min_eye100_100, min_eye_100_300, setup, holdt]=data_recovery(out_vect, clk);
nums_str=[data{:}];
nums_split=[];

for i=1:length(nums_str)
    nums_split(i)=str2num(nums_str(i));
end
nums_split=nums_split';

out_vect2=driv_script(nums_split);
for i=1:50
    if nums_split(i)~=input_num(i) 
        %i
        printf('error w %d',i);
		end
end
#plot(clk,out_vect,clk,out_vect2);
# subplot(2,1,1)
# fplot(clk,out_vect)
# subplot(2,1,2)
# fplot(clk,data)
 plot(out_vect);
 ylabel("data");
 # figure
 # plot(out_vect2);
 # ylabel("data out");
 figure
 plot(clk(1:66));
 ylabel("clk");
 figure
 plot(clk_out(1:66));
 ylabel("clk out");
 