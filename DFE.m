
%function data_out=generate_pulse(input_data, length);
close all
clear all

tic;
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
% input_data1=[-300 -300 -300 -300 -300 -100 -300 -300 -300 -300 -300 -300];


input_data1=[0 0 0 0 0 200 0 0 0 0 0 0]; % pam 2 -100; 100
for i=1:12 
    ov_data1(1+(i-1)*50:i*50)=input_data1(i);
end
    channel_data_1a=channel(ov_data1);
    channel_data_1b = channel(channel_data_1a);
    channel_data1 = channel(channel_data_1b);
x(1:50)=0;
channel_data_int2 = channel_data1 + [x channel_data1(1:550)];
    
input_data2=[-200 -200 -200 -200 -200 200 -200 0 0 0 0 0];
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
    

     
figure
plot(ov_data1);
hold on
plot(channel_data1, 'color',[rand(1),rand(1),rand(1)]);
%plot(channel_data2, 'color',[rand(1),rand(1),rand(1)]);
%plot(channel_data3);

%plot(th2);
%plot(channel_data3);
%plot(channel_data4);
hold off
   
%% create values

offset=10; % slicer offset
input_vector=[-1 -1 -1 -1 -1 -1 1 1 -1 1 -1 1 1 1 1 -1 -1 -1 1 1 1 -1 -1 -1 - -1 1 1];
output_vector=[-1 -1 -1 -1 -1 -1 1 1 -1 1 -1 1 1 1 1 -1 -1 -1 1 1 1 -1 -1 -1 - -1 1 1];
[M, I]=max(channel_data1);
 % wartości tapów:
  lvl3=M;
  lvl2=channel_data1(I-over_sampling);
  lvl1=channel_data1(I-2*over_sampling);
  j=1;
 % wartości sygnału i threshold
 for i=3:length(input_vector)-2
    signal_val(j)=lvl1*output_vector(i-2)+lvl2*output_vector(i-1)+lvl3*output_vector(i)+lvl1*output_vector(i+2)+lvl2*output_vector(i+1);
    th0(j)=lvl1*output_vector(i-2)+lvl2*output_vector(i-1);
    th_m0(j)=lvl1*output_vector(i-2)+lvl2*output_vector(i-1) -lvl1;
    th_p0(j)=lvl1*output_vector(i-2)+lvl2*output_vector(i-1) +lvl1;
    % sprawdź marginesy
    marg0(j)=th0(j)-signal_val(j);
    marg_m0(j)=th_m0(j)-signal_val(j);
    marg_p0(j)=th_p0(j)-signal_val(j);
    % decode
     if (signal_val(j)>th0(j) && (marg0(j)+offset)*(marg0(j)-offset)>=0)
          output_vector(i)=1;
      elseif (marg0(j)+offset)*(marg0(j)-offset)>=0
          output_vector(i)=-1;
      else
          output_vector(i)=rand([-1, 1]);
     end
     
      if (signal_val(j)>th_m0(j) && (marg_m0(j)+offset)*(marg_m0(j)-offset)>=0)
          output_vector_m0(i)=1;
      elseif (marg_m0(j)+offset)*(marg_m0(j)-offset)>=0
          output_vector_m0(i)=-1;
      else
          output_vector_m0(i)=rand([-1, 1]);
      end
      
      if (signal_val(j)>th_p0(j) && (marg_p0(j)+offset)*(marg_p0(j)-offset)>=0)
          output_vector_p0(i)=1;
      elseif (marg_p0(j)+offset)*(marg_p0(j)-offset)>=0
          output_vector_p0(i)=-1;
      else
          output_vector_p0(i)=rand([-1, 1]);
      end
      
    
    j=j+1;
 end

 %korekcja
 
 for i=1:length(th0)
            if(output_vector(i)==output_vector_m0(i) && output_vector(i)==output_vector_p0(i))
                for j=i:k % k - poprzedni indeks dla 000 lub 111
                    if output_vector(j)==1 
                        output_vector(j-1)=output_vector_p0(i);
                    else
                       output_vector(j-1)=output_vector_m0(i);
                    end
                end
                k=i;
            end
 end
 


    
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% algorytm korekcji (pam 2) psedo kod
% % 
%   [M, I]=max(channel_data1);
%   wartości tapów:
%   lvl3=M;
%   lvl2=channel_data1(I-over_sampling);
%   lvl3=channel_data1(I-2*over_sampling);
% %-------------------- set threshold ----------------%
%         th0(j)=x[n-2]*lvl1+x[n-1]*lvl2; % 
%         th_m0(j)=x[n-2]*lvl1+x[n-1]*lvl2-lvl1;
%         th_p0(j)=x[n-2]*lvl1+x[n-1]*lvl2+lvl1;
%         
%         
%         
%         for i=1:length(th0)
%             if(x(i)==x_m0(i)==x_p0(i))
%                 for j=i:k % k - poprzedni indeks dla 000 lub 111
%                     if x(j)==1 
%                         x(j-1)=x_p0(i);
%                     else
%                        x(j-1)=x_m0(i);
%                     end
%                 end
%                 k=i;
%             end
%         end
% 
toc;
