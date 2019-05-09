library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;


entity forwarding_unit is 
 
Port(
clk: in std_logic;
Rdst_EXE_MEM, Rdst_MEM_WB,Rdst_ID_EXE , Rsrc_MEM_WB,Rsrc_EXE_MEM, Rsrc_ID_EXE: in std_logic_vector(2 downto 0);
RW1_EXE_MEM, RW2_EXE_MEM, RW1_MEM_WB, RW2_MEM_WB, RW1_ID_EXE, RW2_ID_EXE: in std_logic;
ALU_SRC_SEL,MUL_SRC_SEL,ALU_DST_SEL,MUL_DST_SEL: out std_logic_vector(2 downto 0)  
);
END ENTITY forwarding_unit;

ARCHITECTURE FU of forwarding_unit is
begin

process(clk,RW1_EXE_MEM, RW2_EXE_MEM, RW1_MEM_WB, RW2_MEM_WB,RW1_ID_EXE, RW2_ID_EXE)
begin 
------------------------------------------------EXE_EXE---------------------------------------------------

if (rising_edge(clk) and RW1_EXE_MEM='1' and RW2_EXE_MEM='0' ) then ---- first instruction is not multiply

      if (RW1_ID_EXE='1'and RW2_ID_EXE='1'and Rdst_EXE_MEM=Rsrc_ID_EXE ) then ---- second instruction is multiply
      MUL_SRC_SEL<="010"; ---let Rsrc_ID_EXE<=Rdst_EXE_MEM
      elsif (RW1_ID_EXE='1'and RW2_ID_EXE='1'and Rdst_EXE_MEM=Rdst_ID_EXE ) then --second instruction is  multiply 
       MUL_DST_SEL<="010"; ---let Rdst_ID_EXE<=Rdst_EXE_MEM
      elsif (RW1_ID_EXE='1'and RW2_ID_EXE='0'and Rdst_EXE_MEM=Rsrc_ID_EXE  ) then--second instruction is  NOT multiply
      ALU_SRC_SEL<="010"; --let  Rsrc_ID_EXE <=Rdst_EXE_MEM
      elsif (RW1_ID_EXE='1'and RW2_ID_EXE='0'and Rdst_EXE_MEM=Rdst_ID_EXE   ) then--second instruction is  NOT multiply
       ALU_DST_SEL<="010";---LET Rdst_ID_EXE<=Rdst_EXE_MEM
       else 
      MUL_SRC_SEL<="000"; --NORMAL
      MUL_DST_SEL<="000";
      ALU_SRC_SEL<="000";
      ALU_DST_SEL<="000";

      end if;

elsif (rising_edge(clk)and RW1_EXE_MEM='1' and RW2_EXE_MEM='1') then---- first instruction is  multiply

      if (RW1_ID_EXE='1'and RW2_ID_EXE='1'  and Rsrc_EXE_MEM=Rsrc_ID_EXE) then --- second instruction is multiply
      MUL_SRC_SEL<="001"; ----LET Rsrc_ID_EXE<= Rsrc_EXE_MEM
      elsIF (RW1_ID_EXE='1'and RW2_ID_EXE='1'  and Rsrc_EXE_MEM=Rdst_ID_EXE) then --- second instruction is multiply
      MUL_DST_SEL<="001";----LET Rdst_ID_EXE<=Rsrc_EXE_MEM
     elsIF (RW1_ID_EXE='1'and RW2_ID_EXE='1'  and Rdst_EXE_MEM=Rsrc_ID_EXE) then --- second instruction is multiply
      MUL_SRC_SEL<="010";----LET Rsrc_ID_EXE<= Rdst_EXE_MEM
     elsIF (RW1_ID_EXE='1'and RW2_ID_EXE='1'  and Rdst_EXE_MEM=Rdst_ID_EXE) then --- second instruction is multiply
      MUL_DST_SEL<="010";----LET Rdst_ID_EXE<= Rdst_EXE_MEM
     elsIF (RW1_ID_EXE='1'and RW2_ID_EXE='0'  and Rsrc_EXE_MEM=Rsrc_ID_EXE) then --- second instruction is NOT multiply
      ALU_SRC_SEL<="001";-----LET Rsrc_ID_EXE<=Rsrc_EXE_MEM
     elsIF (RW1_ID_EXE='1'and RW2_ID_EXE='0'  and Rdst_EXE_MEM=Rsrc_ID_EXE) then --- second instruction is NOT multiply
      ALU_SRC_SEL<="010";-----LET Rsrc_ID_EXE<=Rdst_EXE_MEM
     elsIF (RW1_ID_EXE='1'and RW2_ID_EXE='0'  and Rsrc_EXE_MEM=Rdst_ID_EXE) then --- second instruction is NOT multiply
      ALU_DST_SEL<="001";-----LET Rdst_ID_EXE<=Rsrc_EXE_MEM
     elsIF (RW1_ID_EXE='1'and RW2_ID_EXE='0'  and Rdst_EXE_MEM=Rdst_ID_EXE) then --- second instruction is NOT multiply
      ALU_DST_SEL<="010";-----LET Rdst_ID_EXE<=Rdst_EXE_MEM
      else 
      MUL_SRC_SEL<="000"; --NORMAL
      MUL_DST_SEL<="000";
      ALU_SRC_SEL<="000";
      ALU_DST_SEL<="000";
      end if;
ELSE

 MUL_SRC_SEL<="000"; --NORMAL
 MUL_DST_SEL<="000";
 ALU_SRC_SEL<="000";
 ALU_DST_SEL<="000";

end if;
------------------------------------------------EXE_MEM---------------------------------------------------

if (rising_edge(clk) and RW1_MEM_WB='1' and RW2_MEM_WB='0') then----first instruction is not multiply

      if (RW1_ID_EXE='1'and RW2_ID_EXE='1' and  Rdst_MEM_WB=Rsrc_ID_EXE and ((Rdst_EXE_MEM /= Rsrc_ID_EXE))) then ---THIRD instruction is a multiply
      MUL_SRC_SEL<="011";-----LET  Rsrc_ID_EXE <= Rdst_MEM_WB
      elsIF (RW1_ID_EXE='1'and RW2_ID_EXE='1' and  Rdst_MEM_WB=Rdst_ID_EXE and ((Rdst_EXE_MEM /= Rdst_ID_EXE))) then ---THIRD instruction is  a multiply
      MUL_DST_SEL<="011";-----LET  Rdst_ID_EXE<= Rdst_MEM_WB
      elsIF (RW1_ID_EXE='1'and RW2_ID_EXE='0' and  Rdst_MEM_WB=Rsrc_ID_EXE and ((Rdst_EXE_MEM /= Rsrc_ID_EXE))) then ---THIRD instruction is NOT a multiply
      ALU_SRC_SEL<="011";-----LET  Rsrc_ID_EXE<= Rdst_MEM_WB
      elsIF (RW1_ID_EXE='1'and RW2_ID_EXE='0' and  Rdst_MEM_WB=Rdst_ID_EXE and ((Rdst_EXE_MEM /= Rdst_ID_EXE))) then ---THIRD instruction is NOT a multiply
      ALU_DST_SEL<="011";-----LET  Rdst_ID_EXE<= Rdst_MEM_WB
      else 
      MUL_SRC_SEL<="000"; --NORMAL
      MUL_DST_SEL<="000";
      ALU_SRC_SEL<="000";
      ALU_DST_SEL<="000";
      end if;

elsif (rising_edge(clk) and RW1_MEM_WB='1' and RW2_MEM_WB='1' ) then --- FIRST INSTRUCTION IS A MULTIPLY

      if (RW1_ID_EXE='1'and RW2_ID_EXE='1'and ((Rsrc_EXE_MEM/=Rsrc_ID_EXE)) and (Rsrc_MEM_WB=Rsrc_ID_EXE)) then ---THIRD instruction is a multiply
      MUL_SRC_SEL<="100"; ---LET Rsrc_ID_EXE<=Rsrc_MEM_WB
      elsIF (RW1_ID_EXE='1'and RW2_ID_EXE='1'and ((Rsrc_EXE_MEM/=Rdst_ID_EXE)) and (Rsrc_MEM_WB=Rdst_ID_EXE)) then ---THIRD instruction is a multiply
      MUL_DST_SEL<="100";--LET Rdst_ID_EXE<=Rsrc_MEM_WB
      elsIF (RW1_ID_EXE='1'and RW2_ID_EXE='1'and ((Rdst_EXE_MEM/=Rsrc_ID_EXE)) and (Rdst_MEM_WB=Rsrc_ID_EXE)) then ---THIRD instruction is  a multiply
      MUL_SRC_SEL<="011";--LET Rsrc_ID_EXE<=Rdst_MEM_WB
      elsIF (RW1_ID_EXE='1'and RW2_ID_EXE='1'and ((Rdst_EXE_MEM/=Rdst_ID_EXE)) and (Rdst_MEM_WB=Rdst_ID_EXE)) then ---THIRD instruction is  a multiply
      MUL_DST_SEL<="011";--LET Rdst_ID_EXE<=Rdst_MEM_WB
      elsIF (RW1_ID_EXE='1'and RW2_ID_EXE='0'and ((Rsrc_EXE_MEM/=Rsrc_ID_EXE)) and (Rsrc_MEM_WB=Rsrc_ID_EXE)) then ---THIRD instruction is  not a multiply
      ALU_SRC_SEL<="100";--LET Rsrc_ID_EXE<=Rsrc_MEM_WB
      elsIF (RW1_ID_EXE='1'and RW2_ID_EXE='0'and ((Rdst_EXE_MEM/=Rsrc_ID_EXE)) and (Rdst_MEM_WB=Rsrc_ID_EXE)) then ---THIRD instruction is  not a multiply
      ALU_SRC_SEL<="011";--LET Rsrc_ID_EXE<=Rdst_MEM_WB
      elsIF (RW1_ID_EXE='1'and RW2_ID_EXE='0'and ((Rsrc_EXE_MEM/=Rdst_ID_EXE)) and (Rsrc_MEM_WB=Rdst_ID_EXE)) then ---THIRD instruction is  not a multiply
      ALU_DST_SEL<="100";--LET Rdst_ID_EXE<=Rsrc_MEM_WB
      elsIF (RW1_ID_EXE='1'and RW2_ID_EXE='0'and ((Rdst_EXE_MEM/=Rdst_ID_EXE)) and (Rdst_MEM_WB=Rdst_ID_EXE)) then ---THIRD instruction is  not a multiply
      ALU_DST_SEL<="011";--LET Rdst_ID_EXE<=Rdst_MEM_WB
      else 
      MUL_SRC_SEL<="000"; --NORMAL
      MUL_DST_SEL<="000";
      ALU_SRC_SEL<="000";
      ALU_DST_SEL<="000";
      end if;

end if;

end process;
end architecture;

