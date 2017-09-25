function input_data=generate_binary_data(input_bytes, training_seq); % training_seq-> ctle_pulses, dfe_pulses, none(transmisja danych)

input_data = zeros(8,input_bytes);

if strcmp(training_seq,'pulses')
    ctle_seq=[0; 0;  1; 1; 0; 0; 1; 1;];
    for i=1:input_bytes
        input_data(:,i)=ctle_seq;
    end
elseif strcmp(training_seq,'dfe_pulses')

ctle_seq=[1; 0;  0; 1; 0; 1; 0; 1;];

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
    seq=[0; 1;  0; 1; 1; 0; 0; 1;];
 seq2=[1; 0;  1; 0; 0; 1; 1; 0;];
        for i=1:input_bytes
            if(mod(i, 25)==0)
                input_data(:,i)=seq;
            elseif (mod(i, 15)==0)
                 input_data(:,i) = seq2;
            else
                input_data(:,i) = [1; 0;  1; 0; 1; 0; 1; 0;];
%             else
%                 input_data(:,i)=randi([0 1], 1, 1);
            end
        end  
    
 
end
