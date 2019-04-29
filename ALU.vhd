library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity ALU is 
GENERIC (N :INTEGER := 16);
Port(
Rsrc,Rdst : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
S: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
C_Flag,Z_Flag,N_Flag: OUT STD_LOGIC;
C_en,Z_en,N_en: OUT STD_LOGIC;
F : OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0)
);
END ENTITY ALU;

ARCHITECTURE A_ALU of ALU is
Begin

process (S,Rsrc,Rdst)
	variable temp1: std_logic_vector(N-1 downto 0);
	begin
-----------------------------------------------------------------------------------------
	-- 1- NOT RDST
		if S="0001" then 
			f<= NOT Rdst;
			Z_en<='1';
			C_en<='0';
			N_en<='1';
			if (to_integer(signed(NOT Rdst))) = 0 then
				Z_Flag<='1' ;
			else 
				Z_Flag<='0';
			end if;
			if (to_integer(signed(NOT Rdst))) < 0 then
				N_Flag<='1' ;
			else 
				N_Flag<='0';
			end if;
			C_Flag<='0';
-----------------------------------------------------------------------------------------
	-- 2- INC RDST
		elsif S="0010" then 
			f<= std_logic_vector(to_signed((to_integer(signed(Rdst)))+1,n));
			Z_en<='1';
			C_en<='0';
			N_en<='1';
			if (to_integer(signed(Rdst)))+1 = 0 then
				Z_Flag<='1' ;
			else 
				Z_Flag<='0';
			end if;
			if (to_integer(signed(Rdst)))+1 < 0 then
				N_Flag<='1' ;
			else 
				N_Flag<='0';
			end if;
			C_Flag<='0';
-----------------------------------------------------------------------------------------
	-- 3- DEC RDST
		elsif S="0011" then 
			f<= std_logic_vector(to_signed((to_integer(signed(Rdst)))-1,n));
			Z_en<='1';
			C_en<='0';
			N_en<='1';
			if (to_integer(signed(Rdst)))-1 = 0 then
				Z_Flag<='1' ;
			else 
				Z_Flag<='0';
			end if;
			if (to_integer(signed(Rdst)))-1 < 0 then
				N_Flag<='1' ;
			else 
				N_Flag<='0';
			end if;
			C_Flag<='0';		
-----------------------------------------------------------------------------------------
	-- 4- MOV RSRC, RDST
		elsif S="0100" then 
			f<= Rsrc;
			Z_en<='1';
			C_en<='0';
			N_en<='1';
			if (to_integer(signed(Rsrc))) = 0 then
				Z_Flag<='1' ;
			else 
				Z_Flag<='0';
			end if;
			if (to_integer(signed(Rsrc))) < 0 then
				N_Flag<='1' ;
			else 
				N_Flag<='0';
			end if;
			C_Flag<='0';	
-----------------------------------------------------------------------------------------
	-- 5- ADD RSRC, RDST
		elsif S="0101" then
			Z_en<='1';
			C_en<='1';
			N_en<='1';
			if ((to_integer(signed(Rdst))) + (to_integer(signed(Rsrc)))) = 0 then
				Z_Flag<='1' ;
			else 
				Z_Flag<='0';
			end if;
			if ((to_integer(signed(Rdst))) + (to_integer(signed(Rsrc)))) < 0 then
				N_Flag<='1' ;
			else 
				N_Flag<='0';
			end if;
			if (((to_integer(signed(Rdst))) + (to_integer(signed(Rsrc)))) > 32767) then	
				C_Flag<='1' ;
				f<= '0' & std_logic_vector(to_signed(((to_integer(signed(Rdst))) +(to_integer(signed(Rsrc)))),n-1));
			elsif (((to_integer(signed(Rdst))) + (to_integer(signed(Rsrc)))) < -32678) then	
				C_Flag<='1' ;
				f<= '1' & std_logic_vector(to_signed(((to_integer(signed(Rdst))) + (to_integer(signed(Rsrc)))),n-1));

			else 
				C_Flag<='0';
				f<=std_logic_vector(to_signed(((to_integer(signed(Rdst))) + (to_integer(signed(Rsrc)))),n));
			end if;
-----------------------------------------------------------------------------------------
	-- 6- SUB RSRC, RDST
		elsif S="0110" then 
			Z_en<='1';
			C_en<='1';
			N_en<='1';
			if ((to_integer(signed(Rdst))) - (to_integer(signed(Rsrc)))) = 0 then
				Z_Flag<='1' ;
			else 
				Z_Flag<='0';
			end if;
			if ((to_integer(signed(Rdst))) - (to_integer(signed(Rsrc)))) < 0 then
				N_Flag<='1' ;
			else 
				N_Flag<='0';
			end if;
			if (((to_integer(signed(Rdst))) - (to_integer(signed(Rsrc)))) > 32767) then	
				C_Flag<='1' ;
				f<= '0' & std_logic_vector(to_signed(((to_integer(signed(Rdst))) - (to_integer(signed(Rsrc)))),n-1));
			elsif (((to_integer(signed(Rdst))) - (to_integer(signed(Rsrc)))) < -32678) then	
				C_Flag<='1' ;
				f<= '1' & std_logic_vector(to_signed(((to_integer(signed(Rdst))) - (to_integer(signed(Rsrc)))),n-1));

			else 
				C_Flag<='0';
				f<=std_logic_vector(to_signed(((to_integer(signed(Rdst))) - (to_integer(signed(Rsrc)))),n));
			end if;
-----------------------------------------------------------------------------------------
-- So far dh sha8al
	-- 7- AND RSRC, RDST
		elsif S="0111" then 
			f<= Rsrc AND Rdst;
			Z_en<='1';
			C_en<='0';
			N_en<='1';
			if (to_integer(signed(Rsrc AND Rdst))) = 0 then
				Z_Flag<='1' ;
			else 
				Z_Flag<='0';
			end if;
			if (to_integer(signed(Rsrc AND Rdst))) < 0 then
				N_Flag<='1' ;
			else 
				N_Flag<='0';
			end if;
			C_Flag<='0';
-----------------------------------------------------------------------------------------
	-- 8- OR  RSRC, RDST
		elsif S="1000" then 
			f<= Rsrc OR Rdst;
			Z_en<='1';
			C_en<='0';
			N_en<='1';
			if (to_integer(signed(Rsrc OR Rdst))) = 0 then
				Z_Flag<='1' ;
			else 
				Z_Flag<='0';
			end if;
			if (to_integer(signed(Rsrc OR Rdst))) < 0 then
				N_Flag<='1' ;
			else 
				N_Flag<='0';
			end if;
			C_Flag<='0';
-----------------------------------------------------------------------------------------
	-- 9- SHL RSRC, IMM
		elsif S="1001" then
			f<= to_stdlogicvector(to_bitvector(Rsrc) sll (to_integer(signed(Rdst))));
			temp1:= to_stdlogicvector(to_bitvector(Rsrc)sll (to_integer(signed(Rdst))-1));
			Z_en<='1';
			C_en<='1';
			N_en<='1';
			if (to_integer(signed(to_stdlogicvector(to_bitvector(Rsrc) sll (to_integer(signed(Rdst))))))) = 0 then
				Z_Flag<='1' ;
			else 
				Z_Flag<='0';
			end if;
			if (to_integer(signed(to_stdlogicvector(to_bitvector(Rsrc) sll (to_integer(signed(Rdst))))))) < 0 then
				N_Flag<='1' ;
			else 
				N_Flag<='0';
			end if;
			C_Flag<=temp1(n-1);
-----------------------------------------------------------------------------------------
 	-- 10-SHR RSRC, IMM
		elsif S="1010" then
			f<= to_stdlogicvector(to_bitvector(Rsrc) srl (to_integer(signed(Rdst))));
			Z_en<='1';
			C_en<='0';
			N_en<='1';
			if (to_integer(signed(to_stdlogicvector(to_bitvector(Rsrc) srl (to_integer(signed(Rdst))))))) = 0 then
				Z_Flag<='1' ;
			else 
				Z_Flag<='0';
			end if;
			if (to_integer(signed(to_stdlogicvector(to_bitvector(Rsrc) srl (to_integer(signed(Rdst))))))) < 0 then
				N_Flag<='1' ;
			else 
				N_Flag<='0';
			end if;
			C_Flag<='0';
-----------------------------------------------------------------------------------------
		else 
			f<= Rdst;
			Z_en<='0';
			C_en<='0';
			N_en<='0';
			C_Flag<='0';
			Z_Flag<='0';
			N_Flag<='0';
-----------------------------------------------------------------------------------------
		end if;
	end process;
end A_ALU;