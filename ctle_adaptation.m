function ctle_s=ctle_adaptation(data, slopes)
global ctle_adapt;

if (data==[0 1 0 1 1 0 0 1])% || data==[1;1;0;1])
    fprintf('slopes');
    slopes
    fprintf(' data ');
    data
    
    ctle_s=1;
        if(slopes(1)== 1 )
            if(slopes(2)==0)
                ctle_adapt=0;
            else
                ctle_adapt=-1;
            end
            
        else
           if(slopes(2)==0)
                ctle_adapt=1;
           else
               ctle_adapt=0;
           end
        end
        
else
    ctle_s=0;
end
    