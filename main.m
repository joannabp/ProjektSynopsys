clear all;
close all;
clc
global vector_length;
global setup_t;
global hold_t;
global min_eye_opening;
global unres_val;

unres_val='x';
setup_t=3;
hold_t=1;
vector_length=1600;
min_eye_opening=10;
input_data = randi([0 1], 100, 1);
t_clk=randi(64,1,1)+1;
start=randi(30,1,1);

clk = clk_gen(t_clk,start);
start=30;

%---------------------driver----------------------------------------------%

driv_data = driv_script(input_data);

%eyediagram(driv_data,2,2);
%---------------------Channel---------------------------------------------%

channel_data =driv_data;
%channel_data =channel_function(100, driv_data);
%szum=szum(driv_data,0.5);

%---------------------Clock_Recovery--------------------------------------%

clk_out=clock_recovery(clk,t_clk);

%---------------------Data_Recovery---------------------------------------%

[data, min_eye300_100, min_eye100_100, min_eye100_300, setup, holdd] = data_recovery(driv_data, clk_out);

% nums_str=[data{:}];
% nums_split=[];
% 
% for i=1:length(nums_str)
%     if(nums_split(i)~=unres_val)
%         nums_split(i)=str2num(nums_str(i));
%     else
%         nums_split(i)=unres_val;
% end
% nums_split=nums_split';
% error=[];
% for i=1:50
%     if nums_split(i)~=input_data(i) 
%      %   printf('error w %d',i);
%      error(i)=1;
%     else
%         error(i)=0;
%     end
% end
%---------------------Dodatki---------------------------------------------%

%plot(driv_data);
%ylabel('data in');
% figure
% plot(clk(1:66));
% ylabel('clk wzor');
% figure
% plot(clk_out(1:66));
% ylabel('clk out');