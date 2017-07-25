function v_df_ret=phase_detector8(time_diff)
  change=0;
  if(time_diff>=1e-13)
      change=-1;
  elseif(time_diff<=-1e-13)
      change=1;
  end
  v_df_ret=change