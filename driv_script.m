function dr=driv_script(input_num);
%input_num=randi([0 1], 100, 1);
j=1;
pam4_vect=zeros(1,50);
for i=1:2:99
    i;
    pam4_vect(1,j)=str2num(strcat(num2str(input_num(i)),num2str(input_num(i+1))));
    j=j+1;
end 

 %pam4_vect=bi2de(pam4_vect(i);
j=1;
for i=1:50
        if pam4_vect(1,i)==0
            
            out(j:j+31)=-300;
           
            j=j+32;
        elseif  pam4_vect(1,i)==1
            out(j:j+31)=-100;
            j=j+32;
        elseif  pam4_vect(1,i)==10

            out(j:j+31)=100;
            j=j+32;
        else 

            out(j:j+31)=300;
            j=j+32;
        end
end

%plot(1:1600,out);
alpha = 0.45;
exponentialMA_data = filter(alpha, [1 alpha-1], out);
figure
plot(1:1600, exponentialMA_data);
dr=exponentialMA_data;