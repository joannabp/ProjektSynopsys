
function signal_d=delay2(signal,okres,del)
 #start=signal2(1);
 #signal_d=signal;
	if(del>0)
		for i=1:del
			signal_d(i)=0;
		end
	end
  for i=del+1:length(signal)
		signal_d(i)=signal(i-del);
  end
  # if(signal(1)==0&&signal(2)==0||signal(1)==1&&signal(2)==0)
      # signal_d(1)=1;
  # else
      # signal_d(1)=0;
  # end
# j=1;
# while(signal_d(j)==0)
	# j=j+1;
# end;
# if(j<okres)
	# k
# 
# j=1;
# while((signal_d(j)==signal_d(j+1))&&(j<(length(signal)-1)))
	# j=j+1;
# end
# if(j<floor(okres/2))
	# signal_d(1)=signal_d(2);
	# printf('stale');
# else
	# signal_d(1)=-signal_d(2)+1;
	# printf('zmiana');
# end
  # #signal_d(1)=signal(length(signal));
# if(signal_d(1)==1)
	# signal_d=-signal_d+1;
# end
end

