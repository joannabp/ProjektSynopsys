function [v_int,v_int_ret,kp,z]=integrate9(v_df,v_int_prev,kp,ki,z)
  global acc_size;
  v_int=zeros(1,acc_size);
  v_int_prev
  v_int_num=v_int_prev+v_df*ki;
  if(v_int_num>v_int_prev)
      z=z+1;
  elseif(v_int_num<v_int_prev)
      z=z-1;
  end
  if(z*(v_int_num-v_int_prev)<0&&kp>8)
      kp=8;
  elseif(abs(z)>5)
      if(kp<32)
          kp=kp+8;
      elseif(kp<72)
          kp=kp+16;
      else
          kp=kp+24;
      end
      z=0;
  end
  
  if(v_int_num>2^(acc_size))
      v_int_num=2^(acc_size);
  elseif(v_int_num<0)
      v_int_num=0;
  end
  v_int_ret=v_int_num
  v_int_num=v_int_num+kp*v_df;
  
  if(v_int_num>2^(acc_size))
      v_int_num=2^(acc_size);
  elseif(v_int_num<0)
      v_int_num=0;
  end
  v_int_num
  for i=1:acc_size
    if(v_int_num>=2^(acc_size-i))
      v_int(i)=1;
      v_int_num=v_int_num-2^(acc_size-i);
    end
  end
