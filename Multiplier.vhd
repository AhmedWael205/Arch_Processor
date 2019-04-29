library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
use IEEE.MATH_REAL.all;

entity MUL is 
GENERIC (N :INTEGER := 16);
Port(
Rsrc,Rdst : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
MUL_EN: IN STD_LOGIC;
Z_Flag,N_Flag: OUT STD_LOGIC;
Z_en,N_en: OUT STD_LOGIC;
F : OUT STD_LOGIC_VECTOR ((2*N)-1 DOWNTO 0)
);
END ENTITY MUL;

ARCHITECTURE A_MUL of MUL is
Begin
	process (MUL_EN,Rsrc,Rdst)
	variable temp1 : integer;
	variable temp2 : STD_LOGIC_VECTOR ((2*N)-1 DOWNTO 0);
	begin
		if MUL_EN = '1' then 
			temp1:=(to_integer(unsigned(Rdst)))* (to_integer(unsigned(Rsrc)));
			f<= std_logic_vector(to_unsigned(temp1,(2*n)));
			temp2:=std_logic_vector(to_unsigned(temp1,(2*n)));
			Z_en<='1';
			N_en<='1';
			if temp1 =0 then
				Z_Flag<='1' ;
			else 
				Z_Flag<='0';
			end if;
			if temp2((2*n)-1) = '1' then 
				N_Flag<='1' ;
			else 
				N_Flag<='0';
			end if;	
		else
			Z_en<='0';
			N_en<='0';
			N_Flag<='0';		 
			Z_Flag<='0';
		end if;
	end process;
end ARCHITECTURE A_MUL;