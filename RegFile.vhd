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

component  my_register is
generic (n:integer:=16);
Port (
input: IN std_logic_vector (n-1 downto 0);
clk,rst,enable:IN std_logic;
output:OUT std_logic_vector (n-1 downto 0)
);
end component my_register;

component my_decoder is
port(
WriteReg : IN std_logic_vector (2 downto 0);
decOut: OUT std_logic_vector (7 downto 0)
);
end component my_decoder;

signal decOut1 : std_logic_vector (7 downto 0);
signal Reg1_out,Reg2_out,Reg3_out,Reg4_out,Reg5_out,Reg6_out,Reg7_out,Reg8_out : std_logic_vector (n-1 downto 0);
signal enable1,enable2,enable3,enable4,enable5,enable6,enable7,enable8 : std_logic;

begin

enable1<=(decOut1(0) and RegWrite1);
enable2<=(decOut1(1) and RegWrite1);
enable3<=(decOut1(2) and RegWrite1);
enable4<=(decOut1(3) and RegWrite1);
enable5<=(decOut1(4) and RegWrite1);
enable6<=(decOut1(5) and RegWrite1);
enable7<=(decOut1(6) and RegWrite1);
enable8<=(decOut1(7) and RegWrite1);


D0 : my_decoder port map (WriteReg1,decOut1);


R0 : my_register generic map (16) port map (WriteData1,clk,rst(0),enable1,Reg1_out);
R1 : my_register generic map (16) port map (WriteData1,clk,rst(1),enable2,Reg2_out);
R2 : my_register generic map (16) port map (WriteData1,clk,rst(2),enable3,Reg3_out);
R3 : my_register generic map (16) port map (WriteData1,clk,rst(3),enable4,Reg4_out);
R4 : my_register generic map (16) port map (WriteData1,clk,rst(4),enable5,Reg5_out);
R5 : my_register generic map (16) port map (WriteData1,clk,rst(5),enable6,Reg6_out);
R6 : my_register generic map (16) port map (WriteData1,clk,rst(6),enable7,Reg7_out);
R7 : my_register generic map (16) port map (WriteData1,clk,rst(7),enable8,Reg8_out);

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