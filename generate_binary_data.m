function input_data=generate_binary_data(input_bytes, training_seq); % training_seq-> ctle_pulses, dfe_pulses, none(transmisja danych)

input_data = zeros(8,input_bytes);

if strcmp(training_seq,'pulses')
    ctle_seq=[0; 0;  1; 1; 0; 0; 1; 1;];
    for i=1:input_bytes
        input_data(:,i)=ctle_seq;
    end
elseif strcmp(training_seq,'dfe_pulses')

ctle_seq=[0; 1;  0; 1; 0; 1; 1; 0;];

    for i=1:input_bytes
        input_data(:,i)=ctle_seq;
    end
elseif strcmp(training_seq,'none')
    for j=1:size(input_data,2)
        for i=1:size(input_data,1)
            input_data(i,j) = randi([0 1], 1, 1);
        end
    end
elseif strcmp(training_seq,'pulses_&&_ctle')
    pulses_seq=[0; 1;  1; 0; 0; 1; 1; 0;];
   
        for i=1:input_bytes
            if(i<input_bytes/2)
                input_data(:,i)=pulses_seq;
            else
                 input_data(:,i) = randi([0 1], 8, 1);
            end
        end  
    
 
end
