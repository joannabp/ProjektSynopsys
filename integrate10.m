function [v_int,v_int_ret,kp,x,z]=integrate9(v_df,v_int_prev,kp,ki,z,zmax)
  global acc_size;
  v_int=zeros(1,acc_size);
  v_int_prev
  x=0;
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
        kp=1;
        x=100;
%       z=-z/abs(z);
%       if(mod(kp,2)==1)
%           kp=kp-1;
%       end
%       kp=kp/2;
   elseif(abs(z)>=zmax&&kp<64)%&&kp<128)
       %kp=kp*2;
       if(kp<4)
           kp=kp*2;
       elseif(kp<64)
           kp=kp+4;
           if(kp>64)
               kp=64;
           end
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
  x
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