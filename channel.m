function channel_data = channel(driv_data);
global vector_length;
F_s = vector_length; %probkowanie
t_final = 1;
t = 0 : (1/F_s) : t_final - (1/F_s);
t=t';
L = length(t);

x = driv_data; %sygnal wejsciowy, wyzerowany
v = 2*randn(L,1);
%v = 10*randn(L,1); %DU¯E%ZAK£ÓCENIEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
ar = [1, 1/2];
v1 = filter(1,ar,v*5); %sygnal zaklocenia 
x = x';
x_out = x + v1;

% Konstruowanie filtru adaptacyjnego
LL = 7;                              % Ilosc wspolczynnikow filtru adaptacyjnego
hlms = adaptfilt.lms(LL);            % Filtr adaptacyjny FIR z uzyciem LMS

% Wybranie wielkosci kroku
[mumaxlms,mumaxmselms]   = maxstep(hlms,x_out)  % Maksymalny krok dla filtrow adaptacyjnych
 
% Ustawienie wielkosci kroku
hlms.StepSize  = mumaxmselms/30;     
                                  
% Projektowanie filtrow adaptacyjnych
[ylms,elms] = filter(hlms,v1,x_out);    

channel_data=x_out;
%plot(x_out)

end