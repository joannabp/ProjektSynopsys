function driv_data=driv_script2(input_data,clk);

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


trigger = 0;
k=0;
rand = randi([0 3], 1, 1);

for i=2:length(clk)
    if clk(i)-clk(i-1)==1
        trigger = 1;
        k = k + 1;
        if k > length(pam4)
            break
        end
    end
    if trigger == 0
        driv_data(1) = -300 + rand * 200;
        driv_data(i) = -300 + rand * 200;
    else 
        driv_data(i) = pam4(k);
    end
end


alpha = 0.45;
driv_data = filter(alpha, [1 alpha-1], driv_data);
        




end
   