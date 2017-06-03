clear all;
close all;
clc
global vector_length;
global setup_t;
global hold_t;
global min_eye_opening;
global unres_val;
global thr;

unres_val=1;
setup_t=0;
hold_t=0;
vector_length=1600;
min_eye_opening=10;
thr=0.7;
input_data = randi([0 1], 100, 1);
%t_clk=randi(64,1,1)+1;
%start=randi(30,1,1);
t_clk=31;
start=31;
clk_in = clk_gen_id(t_clk,start);
%clk_tst=zeros(1,vector_length);
%data_out=zeros(1,vector_length);

%---------------------driver----------------------------------------------%

driv_data = driv_script(input_data);

%eyediagram(driv_data,2,2);
%---------------------Channel---------------------------------------------%

channel_data =driv_data;
%channel_data =channel_function(100, driv_data);
%szum=szum(driv_data,0.5);

%---------------------Clock_Recovery--------------------------------------%

clk_out=clock_recovery(clk_in,t_clk);

%---------------------Data_Recovery---------------------------------------%

[data, min_eye300_100, min_eye100_100, min_eye100_300, setup, hold] = data_recovery2(driv_data, clk_out);

nums_str=[data{:}];
nums_split=[];

# for i=1:length(nums_str)
    # if(nums_str(i)~=unres_val)
        # nums_split(i)=str2num(nums_str(i));
        # printf("converting %c to: %d",nums_str(i),nums_split(i));
        # printf("\n");
    # else
        # nums_split(i)=unres_val;
        # printf("converting2 %c to: %d",nums_str(i),nums_split(i));
        # if(nums_split(i)==49)
        # nums_split(i)=1;
        # end
        # printf("\n");
    # end;
# end
for i=1:length(nums_str)
    if(nums_str(i)~=unres_val)
    nums_split(i)=str2num(nums_str(i));
		if(nums_split(i)~=0)
			nums_split(i)=1;
    end
    else
    nums_split(i)=unres_val;
    end
end
nums_split=nums_split';
%data_out=driv_script(nums_split);
error=[];
for i=1:50
    if nums_split(i)~=input_data(i)
        printf('error w %d',i);
        error(i)=1;
    else
        error(i)=0;
    end
end
%---------------------Dodatki---------------------------------------------%

%plot(driv_data);
%ylabel('data in');
plot(clk_in(1:266));
ylabel('clk wzor');
figure
plot(clk_out(1:266));
ylabel('clk out');
figure
plot(driv_data);
ylabel('data in');
