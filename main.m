clear all;
close all;
clc

global vector_length;
vector_length=1600;
<<<<<<< HEAD


global setup_t;
global hold_t;
global min_eye_opening;
global unres_val;

unres_val=-1;
setup_t=2;
hold_t=1;

min_eye_opening=10;

input_vector_length=100;
over_sampling = 16;
freq = 10^10;     % 10GHz
T = 1/freq;       % 0.1ns

time = (0:T/over_sampling:T*input_vector_length-(T/over_sampling));
clk_ideal=clk_ideal_gen(input_vector_length,over_sampling);

plot(time,clk_ideal)


input_data = randi([0 1], 100, 1);
%t_clk=randi(64,1,1)+1;
%start=randi(30,1,1);
t_clk=31;
start=31;
clk_in = clk_gen(t_clk,start);
%clk_tst=zeros(1,vector_length);
data_out=zeros(1,vector_length);

%---------------------Driver----------------------------------------------%
=======


global setup_t;
global hold_t;
global min_eye_opening;
global unres_val;

unres_val=0;
setup_t=1;
hold_t=1;

min_eye_opening=10;

input_bytes=200;   % number of imput bytes
input_bits=input_bytes*8;
over_sampling = 16;
freq = 10^10;     % 10GHz
T = 1/freq;       % 0.1ns
   % number of imput bits
time = (0:T/over_sampling:T*input_bits-(T/over_sampling));
clk_ideal=clk_ideal_gen(input_bits,over_sampling);

%plot(time,clk_ideal)


input_data = randi([0 1], 100, 1);
%t_clk=randi(64,1,1)+1;
%start=randi(30,1,1);
t_clk=31;
start=31;
clk_in = clk_gen(t_clk,start);
%clk_tst=zeros(1,vector_length);
data_out=zeros(1,vector_length);



input_data = zeros(8,input_bytes);
>>>>>>> febce030b53dc95bef6c4cac9866ba7a890f07a8

for j=1:size(input_data,2)
    for i=1:size(input_data,1)
        input_data(i,j) = randi([0 1], 1, 1);
    end
end




%---------------------Driver----------------------------------------------%

driv_data = driv_script(input_data,clk_ideal);

plot(time,clk_ideal*300,time,driv_data)

%---------------------Channel---------------------------------------------%

channel_data = channel(driv_data)';
%# for i=2:vector_length
%	# if(abs(driv_data(i)-driv_data(i-1))>=100)
%		# clk_tst(i)=1;
%	# end
%# end

%---------------------Clock_Recovery--------------------------------------%

clk_out=clock_recovery(clk_in,t_clk);

%---------------------Data_Recovery---------------------------------------%

%[data, min_eye300_100, min_eye100_100, min_eye100_300, setup, hold, out] = data_recovery(driv_data, clk_out);
[data, min_eye300_100, min_eye100_100, min_eye100_300, setup, hold] = data_recovery(channel_data, clk_out);

error=0;
<<<<<<< HEAD




% for i=1:length(nums_str)
%    if(nums_str(i)=='00' | nums_str(i)=='01' | nums_str(i)=='11'| nums_str(i)=='10' )
%         nums_split(i)=str2num(nums_str(i));
%    else
%         nums_split(i)=-1;
%    end
% end
% nums_split=nums_split';
% error=0;
% for i=1:length(input_data)
%     if nums_split(i)~=input_data(i) 
%         error=error+1;
%       
%     end
%     
% end


% %---------------------Dodatki---------------------------------------------%

=======
nums_str=[data{:}];

nums_split=[];

for i=1:length(nums_str)
   if(nums_str(i)~='x')
        nums_split(i)=str2num(nums_str(i));
   else
        nums_split(i)='x';
   end
end
nums_split=nums_split';
error=0;
for i=1:length(input_data)
    if nums_split(i)~=input_data(i) 
        error=error+1;
      
    end
    
end
%---------------------Dodatki---------------------------------------------%

>>>>>>> febce030b53dc95bef6c4cac9866ba7a890f07a8
plot(clk_in(1:266));
ylabel('clk wzor');
figure
plot(clk_out(1:266));
ylabel('clk out');
figure
<<<<<<< HEAD
plot(time, driv_data, time, channel_data,  time, (clk_out-0.5)*600);
ylabel('data in');



=======
plot(1:1600, driv_data, 1:1600, channel_data,  1:1600, (clk_out-0.5)*600);
ylabel('data in');

>>>>>>> febce030b53dc95bef6c4cac9866ba7a890f07a8
