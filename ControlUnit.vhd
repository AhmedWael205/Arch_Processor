library ieee;
use ieee.std_logic_1164.all;

Entity controlunit is
port(
Inst5B : IN std_logic_vector (4 downto 0);
controlOut: OUT std_logic_vector (31 downto 0);
AluSelectors : OUT std_logic_vector (3 downto 0);
PC_Enable: OUT STD_LOGIC;
REGWRITE1: OUT STD_LOGIC;
SETC: OUT STD_LOGIC;
CLRC: OUT STD_LOGIC;
IN_TRI: OUT STD_LOGIC;
OUT_TRI: OUT STD_LOGIC;
MemWrite: OUT STD_LOGIC;
twoWords  : OUT std_logic
);
end Entity controlunit;

Architecture A_controlunit of controlunit is
begin

controlOut<=
     "00000000000000000000000000000000" when Inst5B="00000" -- 1- NOP
else "00000000000000000000000000000001" when Inst5B="00001" -- 2- SETC
else "00000000000000000000000000000010" when Inst5B="00010" -- 3- CLRC
else "00000000000000000000000000000100" when Inst5B="00011" -- 4- NOT RDST
else "00000000000000000000000000001000" when Inst5B="00100" -- 5- INC RDST
else "00000000000000000000000000010000" when Inst5B="00101" -- 6- DEC RDST
else "00000000000000000000000000100000" when Inst5B="00110" -- 7- OUT RDST
else "00000000000000000000000001000000" when Inst5B="00111" -- 8- IN  RDST
---------------------------------------------------------------------------------------
else "00000000000000000000000010000000" when Inst5B="01000" -- 9-  MOV RSRC, RDST
else "00000000000000000000000100000000" when Inst5B="01001" -- 10- ADD RSRC, RDST
else "00000000000000000000001000000000" when Inst5B="01010" -- 11- MUL RSRC, RDST
else "00000000000000000000010000000000" when Inst5B="01011" -- 12- SUB RSRC, RDST
else "00000000000000000000100000000000" when Inst5B="01100" -- 13- AND RSRC, RDST
else "00000000000000000001000000000000" when Inst5B="01101" -- 14- OR  RSRC, RDST
else "00000000000000000010000000000000" when Inst5B="01110" -- 15- SHL RSRC, IMM
else "00000000000000000100000000000000" when Inst5B="01111" -- 16- SHR RSRC, IMM
---------------------------------------------------------------------------------------
else "00000000000000001000000000000000" when Inst5B="10000" -- 17- PUSH RDST
else "00000000000000010000000000000000" when Inst5B="10001" -- 18- POP  RDST
else "00000000000000100000000000000000" when Inst5B="10010" -- 19- LDM  RDST, IMM
else "00000000000001000000000000000000" when Inst5B="10011" -- 20- LDD  RDST, EA
else "00000000000010000000000000000000" when Inst5B="10100" -- 21- STD  RSRC, EA
---------------------------------------------------------------------------------------
else "00000000000100000000000000000000" when Inst5B="10101" -- 22- JZ   RDST
else "00000000001000000000000000000000" when Inst5B="10110" -- 23- JN   RDST
else "00000000010000000000000000000000" when Inst5B="10111" -- 24- JC   RDST
else "00000000100000000000000000000000" when Inst5B="11000" -- 25- JMP  RDST
else "00000001000000000000000000000000" when Inst5B="11001" -- 26- CALL RDST
else "00000010000000000000000000000000" when Inst5B="11010" -- 27- RET
else "00000100000000000000000000000000" when Inst5B="11011" -- 28- RTI
---------------------------------------------------------------------------------------
else "00001000000000000000000000000000" when Inst5B="11100" -- 29-
else "00010000000000000000000000000000" when Inst5B="11101" -- 30-
else "00100000000000000000000000000000" when Inst5B="11110" -- 31-
else "01000000000000000000000000000000" when Inst5B="11111";-- 32-
------------------------------------------------------------------------------------------------------------------------------

CLRC <= '1' WHEN Inst5B="00010"
ELSE '0';

SETC <= '1' WHEN Inst5B="00001"
ELSE '0';

IN_TRI <= '1' WHEN Inst5B="00111"
ELSE '0';

OUT_TRI <= '1' WHEN Inst5B="00110"
ELSE '0';

REGWRITE1 <= '1' WHEN Inst5B="00011" OR Inst5B="00100" OR Inst5B="00101" OR Inst5B="00111"
ELSE '0';

AluSelectors <= 
     "0001" when Inst5B="00011" -- 1- NOT RDST
else "0010" when Inst5B="00100" -- 2- INC RDST
else "0011" when Inst5B="00101" -- 3- DEC RDST
else "0100" when Inst5B="01000" -- 4- MOV RSRC, RDST
else "0101" when Inst5B="01001" -- 5- ADD RSRC, RDST
else "0110" when Inst5B="01011" -- 6- SUB RSRC, RDST
else "0111" when Inst5B="01100" -- 7- AND RSRC, RDST
else "1000" when Inst5B="01101" -- 8- OR  RSRC, RDST
else "1001" when Inst5B="01110" -- 9- SHL RSRC, IMM
else "1010" when Inst5B="01111" -- 10-SHR RSRC, IMM
else "1111";

MemWrite<='0';

twoWords<='0';

PC_Enable <= '1' WHEN Inst5B="00000" OR Inst5B="00001" OR Inst5B="00010" OR Inst5B="00011" OR Inst5B="00100" OR Inst5B="00101" OR Inst5B="00110" OR Inst5B="00111" OR Inst5B="01000"
ELSE '0';

end architecture A_controlunit;
