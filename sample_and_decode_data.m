function [data, th_200, th0, th200]=sample_and_decode_data(input_vector, rising_edge_detector, clk);
thresh=0.5;
global min_eye_opening;
global setup_t;
global hold_t;
global unres_val;
vector_length=length(input_vector);

prev_val=0;
k=1;
j=1;
data=[];
sampled=[];

lvl1=1;
lvl2=37;
lvl3=124;

% lvl1=1;
% lvl2=14;
% lvl3=172;
% unres=unres_val;
% 
% s_200=1;
% s0=1;
% s200=1;
% 
% h_200=1;
% h0=1;
% h200=1;

prev_val=input_vector(1);
setup(1)=1;

for i=1:vector_length 
    sampled(i)=0;
    if rising_edge_detector(i)==1
        sampled(i)= (input_vector(i)+(input_vector(i)-input_vector(i-1))*abs(clk(i)-thresh-clk(i-1)));
    end
end
scaled_th_dat=[];
scaled_th_dat(1:2)=[-1.5 -1.5];

th_200=zeros(1,50000);
th0=zeros(1,50000);
th200=zeros(1,50000);

th_200(1)=-200;
th0(1)=0;
th200(1)=200;

% setup_200=zeros(1,50000);
% setup0=zeros(1,50000);
% setup200=zeros(1,50000);
% 
% setup_200(1)=1;
% setup0(1)=1;
% setup200(1)=1;
% 
% hold_200=zeros(1,50000);
% hold0=zeros(1,50000);
% hold200=zeros(1,50000);
% 
% hold_200(1)=1;
% hold0(1)=1;
% hold200(1)=1;

%-------------------- compare----------------%
for i=1:vector_length 
    

% % ------------------- check setup -200 time ------------% ---- 
% 
%    
%     if (abs(input_vector(i)-th_200(j))>min_eye_opening/2)
%         setup_200(s_200)=setup_200(s_200)+1;
%     else 
%         setup_200(s_200)=1;
%     end
% % ------------------- check setup 0 time ------------% ---- 
% 
%    
%     if (abs(input_vector(i)-th0(j))>min_eye_opening/2)
%         setup0(s0)=setup(s0)+1;
%     else 
%         setup0(s0)=1;
%     end
% % ------------------- check setup -200 time ------------% ----
% 
%    
%     if (abs(input_vector(i)-th200(j))>min_eye_opening/2)
%         setup200(s200)=setup(s200)+1;
%     else 
%         setup200(s200)=1;
%     end
% 
    
 %------------------- compare -----------------------%
    
    if rising_edge_detector(i)==1
         %setup(s-1)=setup(s-1)-clk(i)-thresh-clk(i-1);
%          s_200=s_200+1;
%         setup_200(s_200)=1;
%          s200=s200+1;
%         setup200(s200)=1;
%         s0=s0+1;
%         setup0(s0)=1;
%         
%         h_200=h_200+1;
%         hold_200(h_200)=0.5;
%         h0=h0+1;
%         hold0(h0)=0.5;
%         h200=h200+1;
%         hold200(h200)=0.5;
        
%-------------------- set threshold ----------------%
        th0(j)=scaled_th_dat(j)*lvl1+scaled_th_dat(j+1)*lvl2;
        th_200(j)=th0(j)-lvl3;
        th200(j)=th0(j)+lvl3;
    
        
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



for i=1:length(input_vector)/50
    th_200plot((i-1)*50+1:i*50)=th_200(i);
    th0plot((i-1)*50+1:i*50)=th0(i);
    th200plot((i-1)*50+1:i*50)=th200(i);
    
end
figure 
plot(input_vector, 'color',[1 0 1]);
hold on
plot(th_200plot(1:length(input_vector)), 'color',[1 0 0]);
plot(th0plot(1:length(input_vector)), 'color',[0 1 0]);
plot(th200plot(1:length(input_vector)), 'color',[0 0 0]);
hold off

