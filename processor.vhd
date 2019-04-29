library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

Entity proccesor is
port(
PORT_INOUT : INOUT STD_LOGIC_VECTOR (15 downto 0); 
CLK : IN std_logic;
RstMem : IN std_logic;
RstCounter : IN std_logic ;
RstRegs : IN STD_LOGIC_VECTOR (7 downto 0)
);
end Entity proccesor;

ARCHITECTURE A_proccesor OF proccesor IS

--------------------------------------------------------------------------------------------
-- REGISTER FILE

Component RegFile is
generic(n:integer :=16);
port(
ReadReg1,ReadReg2,WriteReg1,WriteReg2: IN std_logic_vector (2 downto 0);
WriteData1,WriteData2: IN std_logic_vector (n-1 downto 0);
RegWrite1,RegWrite2,clk:IN std_logic;
rst :IN std_logic_vector (7 downto 0);
ReadData1,ReadData2:OUT std_logic_vector (n-1 downto 0)
);
end component RegFile;
--------------------------------------------------------------------------------------------
-- ALU

Component ALU is 
GENERIC (N :INTEGER := 16);
Port(
Rsrc,Rdst : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
S: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
C_Flag,Z_Flag,N_Flag: OUT STD_LOGIC;
C_en,Z_en,N_en: OUT STD_LOGIC;
F : OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0)
);
END Component ALU;
--------------------------------------------------------------------------------------------
-- Control Unit

Component controlunit is
port(
Inst5B : IN std_logic_vector (4 downto 0);
controlOut: OUT std_logic_vector (31 downto 0);
AluSelectors : OUT std_logic_vector (3 downto 0);
PC_Enable: OUT STD_LOGIC;
REGWRITE1: OUT STD_LOGIC;
REGWRITE2: OUT STD_LOGIC;
SETC: OUT STD_LOGIC;
CLRC: OUT STD_LOGIC;
IN_TRI: OUT STD_LOGIC;
OUT_TRI: OUT STD_LOGIC;
MemWrite: OUT STD_LOGIC;
twoWords  : OUT std_logic;
MUL_EN : OUT STD_LOGIC;
ALU_IMM : OUT STD_LOGIC
);
end Component controlunit;

--------------------------------------------------------------------------------------------
-- Memory

Component memory IS
generic(m:integer:=20;n:integer:=16);
	PORT(
		clk,rst : IN std_logic;
		memWrite1,twoWords  : IN std_logic;
		address : IN  std_logic_vector(m-1 DOWNTO 0);
		dataIn1,dataIn2  : IN  std_logic_vector(n-1 DOWNTO 0);
		ReadData : OUT std_logic_vector(n-1 DOWNTO 0));
END Component memory;

--------------------------------------------------------------------------------------------
-- Buffers

component  my_register is
generic (n:integer:=16);
Port (
input: IN std_logic_vector (n-1 downto 0);
clk,rst,enable:IN std_logic;
output:OUT std_logic_vector (n-1 downto 0)
);
end component my_register;

--------------------------------------------------------------------------------------------
-- One Bit Register

Component  register1B is
Port (
input: IN std_logic;
clk,rst,enable:IN std_logic;
output:OUT std_logic
);
end Component register1B;
--------------------------------------------------------------------------------------------
-- Counter

Component my_counter IS
generic(m:integer:=32);
	PORT(
		clk,rst,enable: IN std_logic;
		counter_out : OUT std_logic_vector(m-1 DOWNTO 0)
	     );
END Component my_counter;
--------------------------------------------------------------------------------------------
-- TriBuffer

Component my_tribuffer is
generic (n:integer:=16);
port(
input : IN std_logic_vector ((n-1) downto 0);
control: IN std_logic;
output:OUT std_logic_vector ((n-1) downto 0)
);
end Component my_tribuffer;
--------------------------------------------------------------------------------------------
-- MULTIPLIER

Component MUL is 
GENERIC (N :INTEGER := 16);
Port(
Rsrc,Rdst : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
MUL_EN: IN STD_LOGIC;
Z_Flag,N_Flag: OUT STD_LOGIC;
Z_en,N_en: OUT STD_LOGIC;
F : OUT STD_LOGIC_VECTOR ((2*N)-1 DOWNTO 0)
);
END Component MUL;
--------------------------------------------------------------------------------------------

signal C_FLAG,C_FLAG_IN,C_FLAG_IN_1,C_EN_1,C_EN : STD_Logic:='0';
signal Z_FLAG,Z_FLAG_IN,Z_FLAG_IN_1,Z_FLAG_IN_2,Z_EN_1,Z_EN_2,Z_EN: STD_Logic:='0';
signal N_FLAG,N_FLAG_IN,N_FLAG_IN_1,N_FLAG_IN_2,N_EN_1,N_EN_2,N_EN: STD_Logic:='0';
signal PC_EN : STD_Logic:='0';
signal PC_in  : STD_LOGIC_VECTOR (31 DOWNTO 0);
signal PC_OUT : STD_LOGIC_VECTOR (31 DOWNTO 0);
signal Counter_Out_1,Counter_Out_2 : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL MEMOUT,Instruction : STD_LOGIC_VECTOR (15 DOWNTO 0);
signal ControlOut : STD_LOGIC_VECTOR (31 downto 0);
signal IN_TRI_2,IN_TRI_3,IN_TRI_4,IN_TRI_5 : std_logic:='0';
signal OUT_TRI_2,OUT_TRI_3 : std_logic:='0';
signal ALU_IMM_2,ALU_IMM_3 : std_logic:='0';
signal MUL_EN_2,MUL_EN_3 : std_logic:='0';
signal REGWRITE1_2,REGWRITE1_3,REGWRITE1_4,REGWRITE1_5  : std_logic:='0';
signal REGWRITE2_2,REGWRITE2_3,REGWRITE2_4,REGWRITE2_5  : std_logic:='0';
signal MemWrite_2,MemWrite_3,MemWrite_4 : std_logic:='0';
signal twoWords_2,twoWords_3,twoWords_4 : std_logic:='0';
signal SETC_2,SETC_3 : std_logic:='0';
signal CLRC_2,CLRC_3 : std_logic:='0';
signal AluSelectors_2,AluSelectors_3 : std_logic_vector (3 downto 0):="0000";
signal ReadData1_2,ReadData1_3 : STD_LOGIC_VECTOR (15 DOWNTO 0):=x"0000";
signal ReadData2_2,ReadData2_3 : STD_LOGIC_VECTOR (15 DOWNTO 0):=x"0000";
signal Rdst_3,Rdst_4,Rdst_5 : std_logic_vector (2 downto 0);
signal Rsrc_3,Rsrc_4,Rsrc_5 : std_logic_vector (2 downto 0);
signal IMM_3,IMM_4,IMM_5 : STD_LOGIC_VECTOR (15 DOWNTO 0):=x"0000";
signal EA_3,EA_4 : std_logic_vector (3 downto 0):="0000";
signal ALU_OUT_3,ALU_OUT_4,ALU_OUT_5 : std_logic_vector (15 downto 0);
signal MUL_OUT_3,MUL_OUT_4,MUL_OUT_5 : std_logic_vector (31 downto 0);
signal WRITEDATA1_5,WRITEDATA2_5 : STD_LOGIC_VECTOR (15 DOWNTO 0):=x"0000";
signal  PORT_INOUT_3,PORT_INOUT_4,PORT_INOUT_5 : STD_LOGIC_VECTOR (15 DOWNTO 0);

--------------------------------------------------------------------------------------------

BEGIN

--------------------------------------------------------------------------------------------
-- Stage One: Fetch

Counter : my_counter generic map (32) port map(clk,RstCounter,'1',Counter_OUT_1);

PC_IN <= Counter_OUT_1;

PC : my_register generic map (32) port map (PC_in,clk,'0','1',PC_OUT);
M0 : memory generic map (6,16) port map (clk,RstMem,MemWrite_4, twoWords_4,PC_OUT(19 downto 0),x"0000",x"0000",MemOut);

--------------------------------------------------------------------------------------------
-- IF/ID BUFFERS

B1_1 : my_register generic map (32) port map (Counter_OUT_1,clk,'0','1',Counter_OUT_2);
B1_2 : my_register generic map (16) port map (MemOut,clk,'0','1',Instruction);

--------------------------------------------------------------------------------------------
-- Stage Two: DECODE

C0 : controlunit port map (Instruction(4 downto 0),ControlOut(31 downto 0),AluSelectors_2(3 downto 0),PC_EN,REGWRITE1_2,REGWRITE2_2, SETC_2, CLRC_2, IN_TRI_2, OUT_TRI_2, MemWrite_2 , twoWords_2,MUL_EN_2,ALU_IMM_2);
REG0 : RegFile generic map (16) port map (Instruction(7 downto 5),Instruction(10 downto 8),Rdst_5,Rsrc_5,WRITEDATA1_5,WRITEDATA2_5,REGWRITE1_5,REGWRITE2_5,clk,RstRegs,ReadData1_2,ReadData2_2);

-- ReadData1_2 == Rdst
-- ReadData2_2 == RSrc

--------------------------------------------------------------------------------------------
-- ID/EXE BUFFERS

B2_WB_1 :register1B port map (REGWRITE1_2,clk,'0','1',REGWRITE1_3);
B2_WB_2 :register1B port map (REGWRITE2_2,clk,'0','1',REGWRITE2_3);
B2_WB_3 :register1B port map (IN_TRI_2,clk,'0','1',IN_TRI_3);
B2_WB_4 :register1B port map (OUT_TRI_2,clk,'0','1',OUT_TRI_3);

B2_MEM_1 :register1B port map (MemWrite_2,clk,'0','1',MemWrite_3);
B2_MEM_2 :register1B port map (twoWords_2,clk,'0','1',twoWords_3);

B2_ALU_1 :register1B port map (SETC_2,clk,'0','1',SETC_3);
B2_ALU_2 :register1B port map (ClRC_2,clk,'0','1',CLRC_3);
B2_ALU_3 :register1B port map (MUL_EN_2,clk,'0','1',MUL_EN_3);
B2_ALU_4 :register1B port map (ALU_IMM_2,clk,'0','1',ALU_IMM_3);
B2_ALU_5 :my_register generic map (4) port map (AluSelectors_2(3 downto 0),clk,'0','1',AluSelectors_3(3 downto 0));

B2_1 : my_register generic map (16) port map (ReadData1_2,clk,'0','1',ReadData1_3);
B2_2 : my_register generic map (16) port map (ReadData2_2,clk,'0','1',ReadData2_3);

B2_3 : my_register generic map (3) port map (Instruction(7 downto 5),clk,'0','1',Rdst_3);
B2_4 : my_register generic map (3) port map (Instruction(10 downto 8),clk,'0','1',Rsrc_3);

B2_5 : my_register generic map (16) port map (Instruction(15 downto 0),clk,'0','1',IMM_3(15 downto 0));
B2_6 : my_register generic map (4) port map (Instruction(15 downto 12),clk,'0','1',EA_3(3 downto 0));
B2_7 : my_register generic map (16) port map (PORT_INOUT(15 downto 0),clk,'0',IN_TRI_2,PORT_INOUT_3(15 downto 0));

--------------------------------------------------------------------------------------------
-- Stage Three: EXECUTE

A0 : ALU port map (ReadData2_3(15 downto 0),ReadData1_3(15 downto 0),AluSelectors_3(3 downto 0),C_FLAG_IN_1,Z_FLAG_IN_1,N_FLAG_IN_1,C_EN_1,Z_EN_1,N_EN_1,ALU_OUT_3(15 downto 0));
MUL0 : MUL generic map (16) port map (ReadData2_3(15 downto 0),ReadData1_3(15 downto 0),MUL_EN_3,Z_FLAG_IN_2,N_FLAG_IN_2,Z_EN_2,N_EN_2,MUL_OUT_3(31 downto 0));


C_FLAG_IN <= C_FLAG_IN_1 OR SETC_3 ;
C_EN <= C_EN_1 OR SETC_3 ;

Z_FLAG_IN <= Z_FLAG_IN_1 OR Z_FLAG_IN_2 ;
Z_EN <= Z_EN_1 OR Z_EN_2 ;

N_FLAG_IN <= N_FLAG_IN_1 OR N_FLAG_IN_2 ;
N_EN <= N_EN_1 OR N_EN_2 ;

Carry : register1B port map (C_FLAG_IN,clk,CLRC_3,C_EN,C_FLAG);
Negative : register1B port map (N_FLAG_IN,clk,'0',N_EN,N_FLAG);
Zero : register1B port map (Z_FLAG_IN,clk,'0',Z_EN,Z_FLAG);

T0 : my_tribuffer generic map (16) port map (ReadData1_3(15 downto 0),OUT_TRI_3,PORT_INOUT(15 downto 0));

--------------------------------------------------------------------------------------------
-- EXE/MEM BUFFERS

B3_WB_1 :register1B port map (REGWRITE1_3,clk,'0','1',REGWRITE1_4);
B3_WB_2 :register1B port map (REGWRITE2_3,clk,'0','1',REGWRITE2_4);
B3_WB_3 :register1B port map (IN_TRI_3,clk,'0','1',IN_TRI_4);

B3_MEM_1 :register1B port map (MemWrite_3,clk,'0','1',MemWrite_4);
B3_MEM_2 :register1B port map (twoWords_3,clk,'0','1',twoWords_4);

B3_1 : my_register generic map (3) port map (Rdst_3,clk,'0','1',Rdst_4);
B3_2 : my_register generic map (3) port map (Rsrc_3,clk,'0','1',Rsrc_4);

B3_3 : my_register generic map (16) port map (ALU_OUT_3(15 downto 0),clk,'0','1',ALU_OUT_4(15 downto 0));
B3_4 : my_register generic map (32) port map (MUL_OUT_3(31 downto 0),clk,'0','1',MUL_OUT_4(31 downto 0));
B3_5 : my_register generic map (4) port map (EA_3(3 downto 0),clk,'0','1',EA_4(3 downto 0));
B3_6 : my_register generic map (16) port map (IMM_3(15 downto 0),clk,'0','1',IMM_4(15 downto 0));
B3_7 : my_register generic map (16) port map (PORT_INOUT_3(15 downto 0),clk,'0','1',PORT_INOUT_4(15 downto 0));

--------------------------------------------------------------------------------------------
-- Stage Four: MEMORY


--------------------------------------------------------------------------------------------
-- MEM/WB BUFFERS

B4_WB_1 :register1B port map (REGWRITE1_4,clk,'0','1',REGWRITE1_5);
B4_WB_2 :register1B port map (REGWRITE2_4,clk,'0','1',REGWRITE2_5);
B4_WB_3 :register1B port map (IN_TRI_4,clk,'0','1',IN_TRI_5);

B4_1 : my_register generic map (3) port map (Rdst_4,clk,'0','1',Rdst_5);
B4_2 : my_register generic map (3) port map (Rsrc_4,clk,'0','1',Rsrc_5);

B4_3 : my_register generic map (16) port map (ALU_OUT_4(15 downto 0),clk,'0','1',ALU_OUT_5(15 downto 0));
B4_4 : my_register generic map (32) port map (MUL_OUT_4(31 downto 0),clk,'0','1',MUL_OUT_5(31 downto 0));
B4_5 : my_register generic map (16) port map (IMM_4(15 downto 0),clk,'0','1',IMM_5(15 downto 0));
B4_6 : my_register generic map (16) port map (PORT_INOUT_4(15 downto 0),clk,'0','1',PORT_INOUT_5(15 downto 0));

--------------------------------------------------------------------------------------------
-- Stage Five: WRITE BACK

WRITEDATA1_5 (15 downto 0) <= MUL_OUT_5(15 downto 0) when REGWRITE2_5='1'
else ALU_OUT_5(15 downto 0) when IN_TRI_5='0'
else PORT_INOUT_5 (15 downto 0);

WRITEDATA2_5 (15 downto 0) <=MUL_OUT_5(31 downto 16) when REGWRITE2_5='1'
else x"0000";

--------------------------------------------------------------------------------------------

END A_proccesor;
