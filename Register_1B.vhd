LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity  register1B is
Port (
input: IN std_logic;
clk,rst,enable:IN std_logic;
output:OUT std_logic
);
end entity register1B;

ARCHITECTURE A_register1B OF register1B IS

BEGIN
    process(clk, rst)
    begin
        if rst = '1' then
            output <= '0';
        elsif rising_edge(clk) then
            if enable = '1' then
                output <= input;
            end if;
        end if;
    end process;
END A_register1B;
