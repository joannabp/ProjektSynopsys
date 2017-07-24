%function t_vco_out=freq_change(v_df,t_vco_in,change)
function f_out=freq_change6(v_df)
  global acc_size;
  global nonsignificant_bits;
  global freq;
  f_out=freq*0.95;
  for i=1:acc_size-nonsignificant_bits
      if(v_df(i)==1)
          f_out=f_out+2^(acc_size-i-nonsignificant_bits)*10^6;%*change;%(v_df_size-i)*10^6*change;
      end
  end
  f_out=f_out/1.0012;
  f_out=round(f_out/10^6);
  f_out=f_out*10^6;
  %fprintf('czestotliwosc VCO to %f GHz\n',f_out/10^9)
  %t_vco_out=floor(200*freq/freq_in);