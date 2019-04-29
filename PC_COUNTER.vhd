LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY my_counter IS
generic(m:integer:=32);
	PORT(
		clk,rst,enable: IN std_logic;
		counter_out : OUT std_logic_vector(m-1 DOWNTO 0)
	     );
END ENTITY my_counter;


architecture a_my_counter of my_counter is 
signal temp : std_logic_vector(m-1 DOWNTO 0):=(others=>'0');
begin
temp<=(others=>'0') when (rst='1')
else std_logic_vector(to_unsigned((to_integer(unsigned(temp)))+1,m)) when (rising_edge(clk)and enable='1');
counter_out<=temp;
end a_my_counter;
