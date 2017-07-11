%function data_out=generate_pulse(input_data, length);
close all
clear all
over_sampling=50;
input_data=[1 1];
length=1;
pam_pr(1:5*over_sampling)=-300;
%     pam4(1:over_sampling)=-300;
%    for i=1:length
%         if input_data(1) == 1
%             if input_data(2) == 1
%                 pam4(i*over_sampling+1:(i+1)*over_sampling) = 300;
%             else  
%                 pam4(i*over_sampling+1:(i+1)*over_sampling) = 100;
%             end
%         else
%             if input_data(2) == 1
%                 pam4(i*over_sampling+1:(i+1)*over_sampling) = -100;
%             else
%                 pam4(i*over_sampling+1:(i+1)*over_sampling) = -300;
%             end
%         end
%    end     
%     pam4((i+1)*over_sampling+1:(i+10)*2*over_sampling)=-300;   
%     data_out=[pam_pr pam4];
%     
% input_data1=[-300 -300 -300 -300 -300 -100 -300 -300 -300 -300 -300 -300];
input_data1=[0 0 0 0 0 200 200 0 0 0 0 0];
for i=1:12 
    ov_data1(1+(i-1)*50:i*50)=input_data1(i);
end
    channel_data_1a=channel(ov_data1);
    channel_data_1b = channel(channel_data_1a);
    channel_data1 = channel(channel_data_1b);
x(1:50)=0;
channel_data_int2 = channel_data1 + [x channel_data1(1:550)];
    
input_data2=[0 0 0 0 0 200 0 0 0 0 0 0];
for i=1:12 
    ov_data2(1+(i-1)*50:i*50)=input_data2(i);
end
    channel_data_2a=channel(ov_data2);
    channel_data_2b = channel(channel_data_2a);
    channel_data2 = channel(channel_data_2b);

 input_data3=[-300 -300 -300 -300 -300 100 100 -300 100 -300 300 -300 -300];
for i=1:12 
    ov_data3(1+(i-1)*50:i*50)=input_data3(i);
end
    channel_data_3a=channel(ov_data3);
    channel_data3 = channel(channel_data_3a);
    %channel_data3 = channel(channel_data_3b);
    
 lvl1=2.5;
 lvl2=47;
 
%  for i=3:11
%      th((i-1)*50+1:i*50)=lvl1*channel_data1((i-2)*50)/200+lvl2*channel_data1((i-2)*50)/200+lvl2*channel_data1((i+1)*50)/200;
%  end
       
    
figure
plot(ov_data1);
hold on
plot(channel_data1, 'color',[rand(1),rand(1),rand(1)]);
plot(channel_data2, 'color',[rand(1),rand(1),rand(1)]);
%plot(channel_data3);

%plot(th2);
%plot(channel_data3);
%plot(channel_data4);
hold off
   