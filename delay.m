
function signal_d=delay(signal,okres)
 #start=signal2(1);
 signal_d=signal;
    for i=2:length(signal)
        signal_d(i)=signal(i-1);
    end
    # if(signal(1)==0&&signal(2)==0||signal(1)==1&&signal(2)==0)
        # signal_d(1)=1;
    # else
        # signal_d(1)=0;
    # end
	j=2;
	while(1)
		if(signal_d(j)==signal_d(j-1))
			j=j+1;
		else
			break;
		end
	end
	if(j<okres)
		signal_d(1)=signal_d(2);
	else
		signal_d(1)=-signal_d(2)+1;
	end
  #  signal_d(1)=signal(length(signal));
end
