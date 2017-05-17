function clk_out=clock_recovery(clk_in,t_clk)
global vector_length;
clk_out=zeros(1,vector_length);
t_vco=31;																					%docelowy okres zegara wyjsciowego
start=0;  
start_out=31; 																		%docelowe miejsce pierwszego zbocza narastajacego zegara
k_df=10; 																					%wspolczynnik napiecia detektora fazy
v_df=0; 																					%napiecie wyjsciowe detektora fazy
start=slope(clk_in); 															%wykrywanie pierwszego zbocza zegara wejsciowego
# for i=2:N
		# if(clk_in(i)>clk_in(i-1))
			# start_in=i;
			# printf('start zegara wej. w %d\n',i);
			# break;
		# end
# end
%clk_out=clk_in;
v_df=k_df*abs(start_out-start); 									%obliczenie poczatkowego napiecia detektora fazy
while(v_df>0||t_clk~=t_vco) 											%petla wykonywana do osiagniecia zgodnosci faz i czestotliwosci zegarów
	if(t_vco~=t_clk)
		if(t_vco>t_clk)
			t_clk=t_clk+1; 															%zwiekszany okres
		elseif(t_vco<t_clk)			
			t_clk=t_clk-1;															%zmniejszany okres
		end
	end
	
	# for i=1:start																		%opóznienie startowe w oczekiwaniu na pierwsza probke
		# clk_out(i)=0;
	# end
	clk_out=clk_gen(t_clk,start);
	# for i=start_in+1:vector_length									%wypelnianie wektora zegara wyjsciowego z nowym okresem
		# if(mod(i-start_in,t_clk)<floor(t_clk/2)) 
        # clk_out(i)=1; 																
		# else
        # clk_out(i)=0; 														
		# end
	# end
	
	if(start~=start_out)
		start=slope(clk_out);
		# for i=2:N
			# if(clk_out(i)>clk_out(i-1))
				# start_in=i;
				# %detekcja pierwszego zbocza zegara
				# break;
			# end
		# end
	end
	v_df=k_df*abs(start_out-start);							%obliczanie nowego napiecia detektora fazy
end
