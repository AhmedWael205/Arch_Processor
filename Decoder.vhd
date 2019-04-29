library ieee;
use ieee.std_logic_1164.all;

Entity my_decoder is
port(
WriteReg : IN std_logic_vector (2 downto 0);
decOut: OUT std_logic_vector (7 downto 0)
);
end Entity my_decoder;

Architecture A_my_decoder of my_decoder is
begin
decOut<=
     "00000001" when WriteReg="000"
else "00000010" when WriteReg="001"
else "00000100" when WriteReg="010"
else "00001000" when WriteReg="011"
else "00010000" when WriteReg="100"
else "00100000" when WriteReg="101"
else "01000000" when WriteReg="110"
else "10000000" when WriteReg="111"
else "00000000";

end architecture A_my_decoder;
