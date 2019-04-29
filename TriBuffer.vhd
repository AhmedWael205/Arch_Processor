library ieee;
use ieee.std_logic_1164.all;

Entity my_tribuffer is
generic (n:integer:=16);
port(
input : IN std_logic_vector ((n-1) downto 0);
control: IN std_logic;
output:OUT std_logic_vector ((n-1) downto 0)
);

end entity my_tribuffer;

architecture A_my_tribuffer of my_tribuffer is
begin
output<=input when control='1';
-- else (others=>'Z');
end architecture A_my_tribuffer;
