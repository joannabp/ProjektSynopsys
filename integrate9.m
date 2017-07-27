function [v_int,v_int_ret,kp,z]=integrate9(v_df,v_int_prev,kp,ki,z)
  global acc_size;
  v_int=zeros(1,acc_size);
  %ki=1;
%  v_int_num=8192;
%   v_df_num=0;
%   change=1;
%   if(v_df(1)==1)
%       change=-1;
%   end
%   for i=2:v_df_size
%       if(v_df(i)==1)
%         v_df_num=v_df_num+change*2^(v_df_size-i);
%       end
%   end
  v_int_prev
  v_int_num=v_int_prev+v_df*ki;%2^(acc_size-1)+v_df_prev+v_df
  if(v_int_num>v_int_prev)
      z=z+1;
  elseif(v_int_num<v_int_prev)
      z=z-1;
  end
  if(z*(v_int_num-v_int_prev)<0&&kp>8)
      kp=8;
  elseif(abs(z)>20)
      if(kp<32)
          kp=kp+8;
      else
          kp=kp+16;
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
%   if(v_int_num>=0)
%       v_int(1)=0;
%   else
%       v_int(1)=1;
%   end
  v_int_num
  for i=1:acc_size
    if(v_int_num>=2^(acc_size-i))
      v_int(i)=1;
      v_int_num=v_int_num-2^(acc_size-i);%v_int_num/abs(v_int_num)*2^(v_df_size-i);
    end
  end
  %v_int(2:v_df_size)=de2bi(bi2de(round(v_df_prev(2:v_df_size)))+change*bi2de(round(v_df(2:v_df_size))));
  %v_int(2:v_df_size)=de2bi(bi2de(flipr(v_df_prev(2:v_df_size)))+change*bi2de(flipr(v_df(2:v_df_size))));
