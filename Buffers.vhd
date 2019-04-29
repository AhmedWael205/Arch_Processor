
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity  my_register is
generic (n:integer:=16);
Port (
input: IN std_logic_vector (n-1 downto 0);
clk,rst,enable:IN std_logic;
output:OUT std_logic_vector (n-1 downto 0)
);
end entity my_register;

ARCHITECTURE A_my_register OF my_register IS

BEGIN
	output <= (others=>'0') when rst = '1'
	else input when rising_edge(clk) and enable = '1';
 
END A_my_register;