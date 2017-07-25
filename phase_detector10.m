function v_df_ret=phase_detector10(data,data_prev,slope)
if(data~=data_prev)
    if(slope==1)
        v_df_ret=-1;
    elseif(slope==0)
        v_df_ret=1;
    end
else
    v_df_ret=0;
end