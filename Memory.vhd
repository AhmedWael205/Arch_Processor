LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY memory IS
generic(m:integer:=6;n:integer:=16);
	PORT(
		clk,rst : IN std_logic;
		memWrite1,twoWords  : IN std_logic;
		address : IN  std_logic_vector(19 DOWNTO 0);
		dataIn1,dataIn2  : IN  std_logic_vector(n-1 DOWNTO 0);
		ReadData : OUT std_logic_vector(n-1 DOWNTO 0));
END ENTITY memory;

ARCHITECTURE A_memory OF memory IS

	TYPE ram_type IS ARRAY(0 TO (2**m)-1) OF std_logic_vector(n-1 DOWNTO 0);
	SIGNAL ram : ram_type ;
	
	BEGIN
		PROCESS(clk) IS
			BEGIN
				if(rst='1') then ram<=(others=>(others=>'0'));
				elsif rising_edge(clk) THEN  
					IF memWrite1 = '1'  THEN
						ram(to_integer(unsigned(address))) <= dataIn1;
						IF twoWords = '1' then 
							ram(to_integer(unsigned(address))+1) <= dataIn2; 
						END IF;
					END IF;
				END IF;
		END PROCESS;
		ReadData <= ram(to_integer(unsigned(address)));
END A_memory;
