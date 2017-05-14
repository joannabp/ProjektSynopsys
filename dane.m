function out=dane(pam4_vect)
j=1;
for i=1:50
        if pam4_vect(1,i)==0
            out(j)=-280;
            out(j+1)=-285;
            out(j+2)=-299;
            out(j+3:j+28)=-300;
            out(j+29)=-299;
            out(j+30)=-290;
            out(j+31)=-288;
            j=j+32;
        elseif  pam4_vect(1,i)==1
            out(j)=-80;
            out(j+1)=-85;
            out(j+2)=-99;
            out(j+3:j+28)=-100;
            out(j+29)=-99;
            out(j+30)=-90;
            out(j+31)=-88;
            j=j+32;
        elseif  pam4_vect(1,i)==10
             out(j)=80;
            out(j+1)=85;
            out(j+2)=99;
            out(j+3:j+28)=100;
            out(j+29)=99;
            out(j+30)=90;
            out(j+31)=88;
            j=j+32;
        else 
            out(j)=280;
            out(j+1)=285;
            out(j+2)=299;
            out(j+3:j+28)=300;
            out(j+29)=299;
            out(j+30)=290;
            out(j+31)=288;
            j=j+32;
        end
end