function [v_int,v_int_ret,kp,z]=integrate9(v_df,v_int_prev,kp,ki,z,zmax)
  global acc_size;
  v_int=zeros(1,acc_size);
  v_int_prev
  v_int_num=v_int_prev+v_df*ki;
  if(v_int_num>v_int_prev&&z<zmax)
      z=z+1;
  elseif(v_int_num<v_int_prev&&z>-zmax)
      z=z-1;
  end
%   if(z*(v_int_num-v_int_prev)<0&&kp>1)
%       %kp=1;
%       kp=kp/2;
% %       if(mod(kp,2)==1&&kp>1)
% %         kp=kp-1;
% %       end
%       %zmax=16;
%   elseif(abs(z)==zmax&&kp<128)
%       kp=kp*2;
% %       if(kp<4)
% %         kp=kp*2;
% %       else
% %         kp=kp+2;
% %      end
%       z=0;
%       %zmax=zmax*2;
%   end
%   
  if(z*(v_int_num-v_int_prev)<0&&kp>1)
      %kp=1;
      if(mod(kp,2)==1)
          kp=kp-1;
      end
      kp=kp/2;
      %z=-z/abs(z);
  elseif(abs(z)>=zmax)%&&kp<128) 
      if(kp<4)
        kp=kp*2;
      elseif(kp<64)
        kp=kp+4;
        if(kp>64)
          kp=64;
        end
%       elseif(kp<32)
%         kp=kp+8;
%       elseif(kp<128)
%         kp=kp+16;
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