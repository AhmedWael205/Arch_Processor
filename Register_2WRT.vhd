LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity  my_register_2WRT is
generic (n:integer:=16);
Port (
input1,input2: IN std_logic_vector (n-1 downto 0);
clk,rst,enable1,enable2:IN std_logic;
output:OUT std_logic_vector (n-1 downto 0)
);
end entity my_register_2WRT;

ARCHITECTURE A_my_register_2WRT OF my_register_2WRT IS

BEGIN
	output <= (others=>'0') when rst = '1'
	else input1 when rising_edge(clk) and enable1 = '1'
	else input2 when rising_edge(clk) and enable2 = '1';
	
END A_my_register_2WRT;
