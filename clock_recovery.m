function clk_out=clock_recovery(clk_in,t_clk)
global vector_length;
<<<<<<< HEAD
t_vco_start=20;																		%okres sygnalu wyjsciowego vco przy zerowym napieciu detektora fazy
start_out=14; 																		
clk_out=clk_gen_id(t_vco_start,start_out);
=======
clk_out=zeros(1,vector_length);
t_vco_start=20;																		%okres sygnalu wyjsciowego vco przy zerowym napieciu detektora fazy
start_out=14; 																		
>>>>>>> febce030b53dc95bef6c4cac9866ba7a890f07a8
k_df=10; 																					%wspolczynnik napiecia detektora fazy
v_df=0; 																					%napiecie wyjsciowe detektora fazy
start=slope(clk_in); 															%wykrywanie pierwszego zbocza zegara wejsciowego
t_vco=t_vco_start;
v_df=k_df*abs(start_out-start); 									%obliczenie poczatkowego napiecia detektora fazy
while(v_df>0||t_clk~=t_vco) 											%petla wykonywana do osiagniecia zgodnosci faz i czestotliwosci zegarów

		if(t_vco>t_clk)
<<<<<<< HEAD
			t_vco=t_vco-1; 			
     % printf("zmniejszany okres, t_vco = %d \n",t_vco);      
    elseif(t_vco<t_clk)	
			t_vco=t_vco+1; 	
    %  printf("zwiekszamy okres, t_vco = %d \n",t_vco);     																	    
    end

	clk_out=clk_gen_id(t_vco,start_out);										%generacja zegara z nowym opóznieniem startowym i okresem
=======
			t_vco=t_vco-1; 															
    elseif(t_vco<t_clk)	
			t_vco=t_vco+1; 																		    %zmniejszany okres
    end

	clk_out=clk_gen(t_vco,start_out);										%generacja zegara z nowym opóznieniem startowym i okresem
>>>>>>> febce030b53dc95bef6c4cac9866ba7a890f07a8
	
	if(start~=start_out)
		start_out=slope(clk_out);													%znajdowanie pierwszego zbocza zegara
	end
	v_df=k_df*abs(start_out-start);							    %obliczanie nowego napiecia detektora fazy
end
%figure
%plot(1:1600,clk_in,1:1600,clk_out);
%ylabel('clk');
%plot(clk_in(1:66));
%ylabel('clk in');
%figure
%plot(clk_out(1:66));
%ylabel('clk out');