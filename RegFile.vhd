library ieee;
use ieee.std_logic_1164.all;

Entity RegFile is
generic(n:integer :=16);
port(
ReadReg1,ReadReg2,WriteReg1,WriteReg2: IN std_logic_vector (2 downto 0);
WriteData1,WriteData2: IN std_logic_vector (n-1 downto 0);
RegWrite1,RegWrite2,clk:IN std_logic;
rst :IN std_logic_vector (7 downto 0);
ReadData1,ReadData2:OUT std_logic_vector (n-1 downto 0)
);
end entity RegFile;

Architecture A_RegFile of RegFile is

component my_register_2WRT is
generic (n:integer:=16);
Port (
input1,input2: IN std_logic_vector (n-1 downto 0);
clk,rst,enable1,enable2:IN std_logic;
output:OUT std_logic_vector (n-1 downto 0)
);
end component my_register_2WRT;

component my_decoder is
port(
WriteReg : IN std_logic_vector (2 downto 0);
decOut: OUT std_logic_vector (7 downto 0)
);
end component my_decoder;

signal decOut1 : std_logic_vector (7 downto 0);
signal decOut2 : std_logic_vector (7 downto 0);
signal Reg1_out,Reg2_out,Reg3_out,Reg4_out,Reg5_out,Reg6_out,Reg7_out,Reg8_out : std_logic_vector (n-1 downto 0);
signal enable1_1,enable2_1,enable3_1,enable4_1,enable5_1,enable6_1,enable7_1,enable8_1 : std_logic;
signal enable1_2,enable2_2,enable3_2,enable4_2,enable5_2,enable6_2,enable7_2,enable8_2 : std_logic;

begin

D0 : my_decoder port map (WriteReg1,decOut1);
D1 : my_decoder port map (WriteReg2,decOut2);

enable1_1<=(decOut1(0) and RegWrite1);
enable2_1<=(decOut1(1) and RegWrite1);
enable3_1<=(decOut1(2) and RegWrite1);
enable4_1<=(decOut1(3) and RegWrite1);
enable5_1<=(decOut1(4) and RegWrite1);
enable6_1<=(decOut1(5) and RegWrite1);
enable7_1<=(decOut1(6) and RegWrite1);
enable8_1<=(decOut1(7) and RegWrite1);

enable1_2<=(decOut2(0) and RegWrite2);
enable2_2<=(decOut2(1) and RegWrite2);
enable3_2<=(decOut2(2) and RegWrite2);
enable4_2<=(decOut2(3) and RegWrite2);
enable5_2<=(decOut2(4) and RegWrite2);
enable6_2<=(decOut2(5) and RegWrite2);
enable7_2<=(decOut2(6) and RegWrite2);
enable8_2<=(decOut2(7) and RegWrite2);


R0 : my_register_2WRT generic map (16) port map (WriteData1,WriteData2,clk,rst(0),enable1_1,enable1_2,Reg1_out);
R1 : my_register_2WRT generic map (16) port map (WriteData1,WriteData2,clk,rst(1),enable2_1,enable2_2,Reg2_out);
R2 : my_register_2WRT generic map (16) port map (WriteData1,WriteData2,clk,rst(2),enable3_1,enable3_2,Reg3_out);
R3 : my_register_2WRT generic map (16) port map (WriteData1,WriteData2,clk,rst(3),enable4_1,enable4_2,Reg4_out);
R4 : my_register_2WRT generic map (16) port map (WriteData1,WriteData2,clk,rst(4),enable5_1,enable5_2,Reg5_out);
R5 : my_register_2WRT generic map (16) port map (WriteData1,WriteData2,clk,rst(5),enable6_1,enable6_2,Reg6_out);
R6 : my_register_2WRT generic map (16) port map (WriteData1,WriteData2,clk,rst(6),enable7_1,enable7_2,Reg7_out);
R7 : my_register_2WRT generic map (16) port map (WriteData1,WriteData2,clk,rst(7),enable8_1,enable8_2,Reg8_out);

ReadData1 <= 
     Reg1_out when ReadReg1="000"
else Reg2_out when ReadReg1="001"
else Reg3_out when ReadReg1="010"
else Reg4_out when ReadReg1="011"
else Reg5_out when ReadReg1="100"
else Reg6_out when ReadReg1="101"
else Reg7_out when ReadReg1="110"
else Reg8_out when ReadReg1="111";

ReadData2 <= 
     Reg1_out when ReadReg2="000"
else Reg2_out when ReadReg2="001"
else Reg3_out when ReadReg2="010"
else Reg4_out when ReadReg2="011"
else Reg5_out when ReadReg2="100"
else Reg6_out when ReadReg2="101"
else Reg7_out when ReadReg2="110"
else Reg8_out when ReadReg2="111";


end architecture A_RegFile;