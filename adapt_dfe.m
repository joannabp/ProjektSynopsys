function [data, th_200, th0, th200, slope_sampled, dfe_coeffs,scaled_th_dat]=adapt_dfe(input_vector, rising_edge_detector, rising_edge_detector_shf, clk, dfe_coeffs, scaled_th_dat);
thresh=0.5;
global min_eye_opening;
global setup_t;
global hold_t;
global unres_val;
global sample;
vector_length=length(input_vector);
size_feed=3;
 
prev_val=0;
k=1;
j=1;
data=zeros(1,2);
sampled=zeros(1,10);

%wartości z odpowiedzi impulsowej

miu=0.0005;%step
    size_feed=3;
    wf=dfe_coeffs(1:3);
%     sample = zeros(1, size_feed);

prev_val=input_vector(1);
setup(1)=1;

for i=1:vector_length 
    sampled(i)=0;
    if rising_edge_detector(i)==1
        sampled(i)= (input_vector(i)+(input_vector(i)-input_vector(i-1))*abs(clk(i)-thresh-clk(i-1)));
    end
end
% scaled_th_dat=zeros(1,3);
% scaled_th_dat(1:2)=[-1.5 -1.5];

th0=zeros(1,50000);
th_200=zeros(1,50000);
th200=ones(1,50000);

th0(1)=0;
e=zeros(1,10);

th200_k=dfe_coeffs(4);

%-------------------- compare----------------%
for i=1:vector_length 
    

% % ------------------- slope sampler------------% ---- 

if rising_edge_detector_shf(i)==1
    if input_vector(i)>0
        slope_sampled(j)=1;
    else
        slope_sampled(j)=0;
    end
end

 %------------------- compare -----------------------%
    
    if rising_edge_detector(i)==1

%-------------------- set threshold ----------------%
        th0(j)=scaled_th_dat(j)*wf(1)+scaled_th_dat(j+1)*wf(2);
        th200(j)=th0(j)+30;
        
        if(sampled(i)>th200_k)
            sig200(j)=1;
        else
            sig200(j)=-1;
        end
        
        if dfe_coeffs(5)==1
            if(sig200)==1
                th200_k=th200_k+0.5
            end
        end
%-------------------- compare level 0 ----------------%

           % if(setup0(j)<setup_t || hold0(j)<hold_t)
              % s0(j)=unres;
    %else
       if(sampled(i)>th0(j))
      % if(sampled(i)>0)
                sig0(j)=1;
            else
                   sig0(j)=-1;
            end   


%-------------------- decode data ----------------%            
      if(sig0(j)==1)
             data(k)=1;
             data(k+1)=0;
             scaled_th_dat(j+2)=0.5;
      else
             data(k)=0;
             data(k+1)=1;
             scaled_th_dat(j+2)=-0.5; 
      end
             
               
        x(j)=sample*wf;
        w(j)=sampled(i)-x(j);
        z(j)= sig0(j);
        e(j)= w(j)-z(j)*100;
        wf=wf+miu*e(j)*sample';
        wff1(j)=wf(1);
        wff2(j)=wf(2);
        sample = [ z(j) sample(1:end-1)]
        
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

dfe_coeffs= [wf; th200_k; 0];
scaled_th_dat(1:numel(scaled_th_dat)-1)=scaled_th_dat(2:numel(scaled_th_dat));


% figure
% hold on
% plot(wff1);
% plot(wff2);
% hold off

% figure 
% plot(input_vector, 'color',[1 0 1]);
% hold on
% plot(th_200plot(1:length(input_vector)), 'color',[1 0 0]);
% plot(th0plot(1:length(input_vector)), 'color',[0 1 0]);
% plot(th200plot(1:length(input_vector)), 'color',[0 0 0]);
% hold off

