function [setup_200, setup0, setup200, hold_200, hold0, hold200, data]=setup_hold_check(input_vector, clk, rising_edge_detector, th0, th_200, th200, data); 
thresh=0.5;
global min_eye_opening;
global setup_t;
global hold_t;
global T;
global unres_val;
global over_sampling;


vector_length=length(input_vector);
% % ------------------- check setup time ------------% ---- 
% s=1;
% prev_val=input_vector(1);
% setup(1)=1;
% for i=2:vector_length
%     c=(input_vector(i)-prev_val);
%     if (c<abs(min_eye_opening))
%         setup(s)=setup(s)+1;
%     else 
%         setup(s)=1;
%     end
%     if(rising_edge_detector(i)==1)
%         s=s+1;
%         %setup(s-1)=setup(s-1)-clk(i)-thresh-clk(i-1);
%         setup(s)=1;
%     end
%     prev_val=input_vector(i);
% end
% % ------------------- check hold time ------------% ---- 
% 
% h=1;
% prev_val=input_vector(1);
% hold(1)=1;
% for i=2:vector_length
%     c=(input_vector(i)-prev_val);
%     if(rising_edge_detector(i)==1)
%         h=h+1;
%         hold(h)=clk(i)-thresh-clk(i-1);
%         prev_val=input_vector(i);
%     end
%     if (c<abs(min_eye_opening))
%         
%         hold(h)=hold(h)+1;
%     end
% end
% 
% setup=setup*T-setup_t;
% hold=hold*T-hold_t;
unres=unres_val;

s_200=1;
s0=1;
s200=1;

h_200=1;
h0=1;
h200=1;

%setup_200=zeros(1,50000);
%setup0=zeros(1,50000);
%setup200=zeros(1,50000);

setup_200(1)=1;
setup0(1)=1;
setup200(1)=1;

%hold_200=zeros(1,50000);
%hold0=zeros(1,50000);
%hold200=zeros(1,50000);

hold_200(1)=1;
hold0(1)=1;
hold200(1)=1;
j=1;
% ------------------- check setup -200 time ------------% ---- 

for i=2:vector_length
   
    if (abs(input_vector(i)-th_200(j))>min_eye_opening/2)
        setup_200(s_200)=setup_200(s_200)+1;
    else 
        setup_200(s_200)=1;
    end
% ------------------- check setup 0 time ------------% ---- 

   
    if (abs(input_vector(i)-th0(j))>min_eye_opening/2)
        setup0(s0)=setup0(s0)+1;
    else 
        setup0(s0)=1;
    end
% ------------------- check setup -200 time ------------% ----

   
    if (abs(input_vector(i)-th200(j))>min_eye_opening/2)
        setup200(s200)=setup200(s200)+1;
    else 
        setup200(s200)=1;
    end
    
  
    
    if(rising_edge_detector(i)==1)
        j=j+1;
        
         %setup(s-1)=setup(s-1)-clk(i)-thresh-clk(i-1);
         s_200=s_200+1;
        setup_200(s_200)=1;
         s200=s200+1;
        setup200(s200)=1;
        s0=s0+1;
        setup0(s0)=1;
        
        h_200=h_200+1;
        hold_200(h_200)=0.5;
        h0=h0+1;
        hold0(h0)=0.5;
        h200=h200+1;
        hold200(h200)=0.5;
    end
      
    % ------------------- check hold -200 time ------------% ---- 

   
    if (abs(input_vector(i)-th_200(j))>min_eye_opening/2)
        hold_200(h_200)=hold_200(h_200)+1;
    end
% ------------------- check hold 0 time ------------% ---- 

   
    if (abs(input_vector(i)-th0(j))>min_eye_opening/2)
        hold0(h0)=hold0(h0)+1;
    else 
        hold0(h0)=1;
    end
% ------------------- check hold -200 time ------------% ----

   
    if (abs(input_vector(i)-th200(j))>min_eye_opening/2)
        hold200(h200)=hold200(h200)+1;
    end
end




setup_200=setup_200*T/over_sampling;
setup0=setup0*T/over_sampling;
setup200=setup200*T/over_sampling;

setup_200=setup_200-setup_t;
setup0=setup0-setup_t;
setup200=setup200-setup_t;

hold_200=hold_200*T/over_sampling-hold_t;
hold0=hold0*T/over_sampling-hold_t;
hold200=hold200*T/over_sampling-hold_t;
k=1;

for i=1:j 
    
     if(setup200(i)<0 || hold200(i)<0 || setup0(i)<0 || hold0(i)<0 || setup_200(i)<0 || hold_200(i)<0)
         data(k:k+1)=unres;
          
     end
     k=k+2;
      prev_val=data(i);
        j=j+1;  
        if(strcmp(unres_val, 'prev'))
            unres=prev_val;
        else
             unres=unres_val;
        end
             
end


