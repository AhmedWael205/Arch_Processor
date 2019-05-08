LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY memory IS
generic(m:integer:=8;n:integer:=16);
	PORT(
		clk,rst : IN std_logic;
		EnableMem_4,EnableStack_4 : IN std_logic;
		memWrite_4,memPush_4,memPop_4,twoWords_4  : IN std_logic;
		address : IN  std_logic_vector(19 DOWNTO 0);
		dataIn1,dataIn2  : IN  std_logic_vector(n-1 DOWNTO 0);
		ReadData : OUT std_logic_vector(n-1 DOWNTO 0));
END ENTITY memory;

ARCHITECTURE A_memory OF memory IS

	TYPE ram_type IS ARRAY(0 TO (2**m)-1) OF std_logic_vector(n-1 DOWNTO 0);
	SIGNAL ram : ram_type ;
	
	BEGIN
		PROCESS(clk,RST) IS
		VARIABLE Stack_Pointer : std_logic_vector(31 DOWNTO 0):= x"000000f7";
			BEGIN
				if(rst='1') then 
					 ram<=(others=>(others=>'0'));
					 Stack_Pointer:=x"000000f7";
					 ReadData <=(others=>'0');
				elsif falling_edge(clk) THEN  
					IF EnableMem_4='1' and memWrite_4 = '1'  THEN
						ram(to_integer(unsigned(address))) <= dataIn1;
						IF twoWords_4 = '1' then 
							ram(to_integer(unsigned(address))+1) <= dataIn2; 
						END IF;
						ReadData <= ram(to_integer(unsigned(address)));

					ELSIF EnableStack_4='1' and MemPush_4 ='1' then 
						ram(to_integer(unsigned(Stack_Pointer (19 downto 0)))) <= dataIn1;
						Stack_Pointer:=  std_logic_vector(to_unsigned((to_integer(unsigned(Stack_Pointer)))-1,32));
						ReadData <= ram(to_integer(unsigned(address)));

					ELSIF EnableStack_4='1' and MemPop_4 ='1' then 
						ReadData <= ram(to_integer(unsigned(Stack_Pointer (19 downto 0)))+1);
						Stack_Pointer:=  std_logic_vector(to_unsigned((to_integer(unsigned(Stack_Pointer)))+1,32));
					else  ReadData <= ram(to_integer(unsigned(address)));
					END IF;
				END IF;
		END PROCESS;		
END A_memory;
