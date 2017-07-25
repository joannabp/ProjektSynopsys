function clk=clk_not_id2(t_clk,start,stop,clk1)
%global vector_length;
global thr;
%clk=[];
%clk=zeros(1,vector_length);
clk=zeros(1,stop-start);
%start=randi(30,1,1);
%printf("start w: %d, stop w: %d\n",start,stop);
% clk(1)=clk1;
% clk(2)=clk(1)+thr;
for i=1:stop-start
    if(mod(i,t_clk)==t_clk/2)
        clk(i)=clk1;
    elseif(mod(i,t_clk)==t_clk/2+1)
        clk(i)=thr+clk1;
        fprintf('zbocze w %d\n',i+start);
%abs(0.2*randn);
% for i=3:stop-start
%       if(mod(i,t_clk)==floor(t_clk/2)-1)
%         clk(i)=clk1;%abs(0.2*randn);
%       elseif(mod(i,t_clk)==0)
%          clk(i)=clk(i-1)+thr;
%     if(mod(i,t_clk)==floor(t_clk/2)+1||mod(i,t_clk)==0)
%         clk(i)=abs(0.2*randn);
%         if(clk(i)>0.4)
%             clk(i)=0.4;
%         end
%     elseif(mod(i,t_clk)==floor(t_clk/2)||mod(i,t_clk)==1)
%         clk(i)=clk(i-1)+abs(randn);
%         if(clk(i)>1)
%             clk(i)=1;
%         end
%         if(clk(i)<0.5)
%             clk(i)=0.5;
%         end
      elseif(mod(i,t_clk)>t_clk/2||i==t_clk)
        clk(i)=1;
      end
end