function [th, peak_sampled]= sample_peak_val(input_vector, rising_edge_detector, clk, th)
thresh=0.5;

vector_length=length(input_vector);


sampled=zeros(1,10);


for i=1:vector_length 
    sampled(i)=0;
    if rising_edge_detector(i)==1
        sampled(i)= (input_vector(i)+(input_vector(i)-input_vector(i-1))*abs(clk(i)-thresh-clk(i-1)));
        
    end
end


for i=1:vector_length 
    

    
    if rising_edge_detector(i)==1
      
          
          if(sampled(i)>th)
              peak_sampled=1;
          else
              peak_sampled=-1;
          end
      
        
      th=th+5*peak_sampled;
    else 
        peak_sampled=0;
    end
end
          
          
          