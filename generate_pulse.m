
%function data_out=generate_pulse(input_data, length);
close all
clear all


over_sampling=50;
input_data=[1 1];
length=1;

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
% input_data1=[-300 -300 -300 -300 -300 300 -300 -300 -300 -300 -300 -300];

%input_data1=[-100 -100 -100 -100 -100 100 -100 -100 -100 -100 -100]; % pam 2 
input_data1=[0 0 0 0 0 200 0 0 0 0 0]; % pam 2 
  % input_data1= (randn(3000, 1)>0)*2-1;  % Random bipolar (-1, 1) sequence;
 %  input_data1=input_data1*200;
%  input_data1=[-100 100 -100 -100 100 100 100 100 100 -100 -100 100 100 100 -100 -100 -100 100 100 100]; % pam 2 
% input_data1=[input_data1 input_data1 input_data1 input_data1 input_data1 -100 100 -100 -100 100 100 100 -100 -100 -100 -100 100 100 100 -100 -100 -100 100 100 100] ;
% input_data1=[input_data1 input_data1 input_data1 input_data1];
 %input_data1=[input_data1 input_data1 input_data1 input_data1];
for i=1:numel(input_data1); 
    ov_data1(1+(i-1)*52:i*52)=input_data1(i); 
end
    channel_data1=channel(ov_data1);
%     channel_data_1b = channel(channel_data_1a);
%     channel_data1 = channel(channel_data_1b);



  eq_dat=ctle(channel_data1, 5e8, 6e9, 12e9, 13, -10); % (signal, fz, fp1, fp2, HFboost, DCgain)
% input_data2=[-200 -200 -200 -200 -200 200 -200 0 0 0 0 0];
% for i=1:12 
%     ov_data2(1+(i-1)*50:i*50)=input_data2(i);
% end 
%     channel_data_2a=channel(ov_data2);
%     channel_data_2b = channel(channel_data_2a);
%     channel_data2 = channel(channel_data_2b);
% 
%  input_data3=[-300 -300 -300 -300 -300 100 100 -300 100 -300 300 -300 -300];
% for i=1:12 
%     ov_data3(1+(i-1)*50:i*50)=input_data3(i);
% end
%     channel_data_3a=channel(ov_data3);
%     channel_data3 = channel(channel_data_3a);
%     %channel_data3 = channel(channel_data_3b);
%     

     
%% LMS
    miu=0.001;%step
    size_feed=3;
    wf=[0; 0; 0];
    sample = zeros(1, size_feed);
    for i=1:50:numel(eq_dat)
        x(i)=sample*wf;
        w(i)=eq_dat(i)-x(i);
        z(i)= sign(eq_dat(i));
        e(i)= w(i)-z(i)*200;
        wf=wf+miu*e(i)*sample';
        sample = [ z(i) sample(1:end-1)];
    end

%% CTLE ADAPT
sData=[];
sSlope=[];
j=1;
HF=1;

 for i=1:52:numel(eq_dat)
       
     if(eq_dat(i)>25)
         sData(j)=1;
     else
         sData(j)=0;
     end
     j=j+1;
 end
 
 j=1;
 
 for i=13:52:numel(eq_dat)
       
     if(eq_dat(i)>-15)
         sSlope(j)=1;
     else
         sSlope(j)=0;
     end
     j=j+1;
     i
 end
 
 if(sum(sData)>=sum(sSlope))
     HF=HF+1;
 end

%%


figure
plot(ov_data1);
hold on
plot(channel_data1, 'color',[0 0 0]);
plot(eq_dat, 'color',[rand(1),rand(1),rand(1)]);
%plot(channel_data3);

%plot(th2);
%plot(channel_data3);
%plot(channel_data4);
hold off
   

