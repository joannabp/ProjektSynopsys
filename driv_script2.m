function driv_data=driv_script2(input_data,clk)

global train_ena;
global input_bits;
global thr;

pam4 = zeros(1,size(input_data,2)*size(input_data,1)/2);

for j=0:size(input_data,2)-1
    for i=0:size(input_data,1)/2-1 %%%%%%%%%%%%%%%%%
        if input_data(2*i+1,j+1) == 1
            if input_data(2*i+2,j+1) == 1
                pam4(j*(size(input_data,1)/2)+i+1) = 300;
            else  
                pam4(j*(size(input_data,1)/2)+i+1) = 100;
            end
        else
            if input_data(2*i+2,j+1) == 1
                pam4(j*(size(input_data,1)/2)+i+1) = -100;
            else
                pam4(j*(size(input_data,1)/2)+i+1) = -300;
            end
        end
    end
end

driv_data=zeros(1,input_bits*50);
k=1;
i=2;
numel(pam4)
driv_data(1)=pam4(1);

while k<numel(pam4)
   if(clk(i)>=thr&&clk(i-1)<thr)
       driv_data(i)=pam4(k);%driv_data(i-1)+(clk(i)-clk(i-1))*(pam4(k+1)-pam4(k));
       %if(clk(i)==1)
       k=k+1;
       %end
   else
       driv_data(i)=driv_data(i-1);
   end
   i=i+1;
end

driv_data=driv_data(1:i);

alpha = 0.2;
driv_data = filter(alpha, [1 alpha-1], driv_data);

end
   