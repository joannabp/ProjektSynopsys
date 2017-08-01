function [data_rec, th_200, th0, th200, slope_sampled, wf, scaled_th_dat, sample]=sample_and_decode_data(input_vector, rising_edge_detector, rising_edge_detector_shf, clk, wf, scaled_th_dat, sample)
global thr;

global unres_val;
global peak_val;

vector_length=length(input_vector);

% prev_val=0;
k=1;
j=1;
data=zeros(1,2);
sampled=zeros(1,10);


%wartości z odpowiedzi impulsowej
lvl1=-1.53;
lvl2=-0.58;
lvl3=125;

miu=0.0005;%step
%size_feed=3;
%wf=[0; 0; 0];

e=zeros(1,10); 

% prev_val=input_vector(1);
% setup(1)=1;

for i=1:vector_length 
    sampled(i)=0;
    if rising_edge_detector(i)==1
        sampled(i)= (input_vector(i)+(input_vector(i)-input_vector(i-1))*abs(clk(i)-thr-clk(i-1)));
        
    end
end
%scaled_th_dat=[];
%scaled_th_dat(1:2)=[-1.5 -1.5];

% th_200=zeros(1,50000);
% th0=zeros(1,50000);
% th200=zeros(1,50000);

th_200=zeros(1,50);
th0=zeros(1,50);
th200=zeros(1,50);
th_200(1)=-200;
th0(1)=0;
th200(1)=200;


%-------------------- compare----------------%
for i=1:vector_length 
    

% % ------------------- slope sampler------------% ---- 

if rising_edge_detector_shf(i)==1
    if input_vector(i)>0
        slope_sampled=1;
    else
        slope_sampled=0;
    end
end

 %------------------- compare -----------------------%
    
    if rising_edge_detector(i)==1

%-------------------- set threshold ----------------%
%th0(j)=0;
      %th0(j)=scaled_th_dat(j)*lvl1+scaled_th_dat(j+1)*lvl2;
      
      %th0(j)=0;
       th0(j)=scaled_th_dat(j)*wf(1)+scaled_th_dat(j+1)*wf(2);
        th_200(j)=th0(j)-peak_val*2;
        th200(j)=th0(j)+peak_val*2;
      
        
        %---------- compare level -200 ---------------%
            %if(setup_200(j)<setup_t || hold_200(j)<hold_t)
              % s_200(j)=unres;
    %else
       if(sampled(i)>th_200(j))
       %if(sampled(i)>-200)
                sig_200(j)=1;
            else
                sig_200(j)=0;
            end   
           
              

%-------------------- compare level 0 ----------------%

           % if(setup0(j)<setup_t || hold0(j)<hold_t)
              % s0(j)=unres;
    %else
       if(sampled(i)>th0(j))
      % if(sampled(i)>0)
                sig0(j)=1;
            else
                   sig0(j)=0;
            end   


%-------------------- compare level 200 ----------------%
            %if(setup200(j)<setup_t || hold200(j)<hold_t)
             %  s200(j)=unres;
    %else
      if(sampled(i)>th200(j))
      % if(sampled(i)>200)
               sig200(j)=1;
            else
               sig200(j)=0;
            end  
%-------------------- decode data ----------------%            
        %if(setup200(j)<setup_t || hold200(j)<hold_t || setup0(j)<setup_t || hold0(j)<hold_t || setup_200(j)<setup_t || hold_200(j)<hold_t)
          %  data(k:k+1)=unres;
          %  scaled_th_dat(j+2)=0.5;
    %else
        if(sig_200(j)+sig0(j)+sig200(j)==3)
             data(k:k+1)=1;
             scaled_th_dat(j+2)=1.5;
         elseif(sig_200(j)+sig0(j)==2)
             data(k)=1;
             data(k+1)=0;
             scaled_th_dat(j+2)=0.5;
         elseif(sig_200(j)==1)
             data(k)=0;
             data(k+1)=1;
             scaled_th_dat(j+2)=-0.5;
         else
             data(k:k+1)=0;
             scaled_th_dat(j+2)=-1.5;
        end
             
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            x(j)=sample*wf;
        w(j)=sampled(i)-x(j);
        if(sig0(j)==0)
            z(j)=-1;
        else
            z(j)=1;
        end
        e(j)= w(j)-z(j)*100;
        wf=wf+miu*e(j)*sample';
        wff1(j)=wf(1);
        wff2(j)=wf(2);
        sample = [ z(j) sample(1:end-1)];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%adapt_ctle
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        k=k+2;
        prev_val=data(j);
        j=j+1;  
        if(strcmp(unres_val, 'prev'))
            unres=prev_val;
        else
             unres=unres_val;
        end
    end
    
       

end 
scaled_th_dat(1:numel(scaled_th_dat)-1)=scaled_th_dat(2:numel(scaled_th_dat));
data_rec=data;
% 
% 
% for i=1:length(input_vector)/50
%     th_200plot((i-1)*50+1:i*50)=th_200(i);
%     th0plot((i-1)*50+1:i*50)=th0(i);
%     th200plot((i-1)*50+1:i*50)=th200(i);
%     
% end
% % figure 
% % plot(input_vector, 'color',[1 0 1]);
% % hold on
% % plot(th_200plot(1:length(input_vector)), 'color',[1 0 0]);
% % plot(th0plot(1:length(input_vector)), 'color',[0 1 0]);
% % plot(th200plot(1:length(input_vector)), 'color',[0 0 0]);
% % hold off
% 

% figure
% hold on
% plot(wff1);
% plot(wff2);
% hold off

