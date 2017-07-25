function v_df_ret=phase_detector9(data,slope)
if(abs(data(1)-slope)>abs(slope-data(2)))
	v_df_ret=1;
elseif(abs(data(1)-slope)<abs(slope-data(2)))
	v_df_ret=-1;
else
	v_df_ret=0;
end

