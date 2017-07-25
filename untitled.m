
global vector_length;
global freq;
vector_length=40000;
freq=10^10;
global thr;
thr=0.5;
t0=[212,210,208,206,204,202,200,198,196,194,192,190];
f0=zeros(1,12);
for i=1:12
    f0(i)=200/t0(i)*freq;
end

clk=clk_gen_f_not_id3(0.995*freq,0,vector_length,0,t0,f0,25);
