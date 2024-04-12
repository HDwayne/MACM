LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity control_unit is
  port(
    Instr : in std_logic_vector(31 downto 0);
    PCSrc, RegWr, MemToReg, MemWr, Branch, CCWr, AluSrc : out std_logic;
    AluCtrl, ImmSrc, RegSrc : out std_logic_vector(1 downto 0);
    Cond : out std_logic_vector(3 downto 0)
);
end entity;

architecture control_unit_arch of control_unit is
  
begin
  -- INPUTS                          | OUTPUTS
  -- Instr <27..26> | Instr<24..21>  | AluCtrl <1..0>
  -- 10 (Branch)    | XXXX (b)       | 00 (+)
  -- 00 (Calcul)    | 0100 (ADD)     | 00 (+)
  -- 00 (Calcul)    | 0010 (SUB)     | 01 (-)
  -- 00 (Calcul)    | 0000 (AND)     | 10 (Et)
  -- 00 (Calcul)    | 1100 (ORR)     | 11 (Ou)
  -- 00 (Calcul)    | 1010 (CMP)     | 01 (-)
  -- 01 (Memoire)   | X0XX (LDR/STR) | 00 (+)
  -- 01 (Memoire)   | X1XX (LDR/STR) | 01 (-)

  AluCtrl <= "00" when Instr(27 downto 26) = "10" else
             "00" when Instr(27 downto 26) = "00" and Instr(24 downto 21) = "0100" else
             "01" when Instr(27 downto 26) = "00" and Instr(24 downto 21) = "0010" else
             "10" when Instr(27 downto 26) = "00" and Instr(24 downto 21) = "0000" else
             "11" when Instr(27 downto 26) = "00" and Instr(24 downto 21) = "1100" else
             "01" when Instr(27 downto 26) = "00" and Instr(24 downto 21) = "1010" else
             "00" when Instr(27 downto 26) = "01" and Instr(23) = '0' else
             "01" when Instr(27 downto 26) = "01" and Instr(23) = '1' else
             "00";
  
  -- INPUTS                                   | OUTPUTS
  -- Instr <27..26> | Instr <25> | Instr <20> | Branch |  MemToReg | MemWr | AluSrc | ImmSrc | RegWr | RegSrc
  -- 00 reg/reg     | 0          | X          | 0      | 0         | 0     | 0      | XX     | 1     | 00
  -- 00 (CMP)       | 0          | 1          | 0      | 0         | 0     | 0      | XX     | 0     | 00
  -- 00 reg/imm     | 1          | X          | 0      | 0         | 0     | 1      | 00     | 1     | X0
  -- 01 (LDR)       | X          | 1          | 0      | 1         | 0     | 1      | 01     | 1     | X0
  -- 01 (STR)       | X          | 0          | 0      | X         | 1     | 1      | 01     | 0     | 10
  -- 10 (B)         | X          | X          | 1      | 0         | 0     | 1      | 10     | 0     | X1

  Branch <= '0' when Instr(27 downto 26) = "00" and Instr(25) = '0' else
            '0' when Instr(27 downto 26) = "00" and Instr(25) = '0' and Instr(20) = '1' else
            '0' when Instr(27 downto 26) = "00" and Instr(25) = '1' else
            '0' when Instr(27 downto 26) = "01" and Instr(20) = '1' else
            '0' when Instr(27 downto 26) = "01" and Instr(20) = '0' else
            '1' when Instr(27 downto 26) = "10";

  MemToReg <= '0' when Instr(27 downto 26) = "00" and Instr(25) = '0' else
              '0' when Instr(27 downto 26) = "00" and Instr(25) = '0' and Instr(20) = '1' else
              '0' when Instr(27 downto 26) = "00" and Instr(25) = '1' else
              '1' when Instr(27 downto 26) = "01" and Instr(20) = '1' else
              '0' when Instr(27 downto 26) = "01" and Instr(20) = '0' else -- X
              '0' when Instr(27 downto 26) = "10";

  MemWr <= '0' when Instr(27 downto 26) = "00" and Instr(25) = '0' else
           '0' when Instr(27 downto 26) = "00" and Instr(25) = '0' and Instr(20) = '1' else
           '0' when Instr(27 downto 26) = "00" and Instr(25) = '1' else
           '0' when Instr(27 downto 26) = "01" and Instr(20) = '1' else
           '1' when Instr(27 downto 26) = "01" and Instr(20) = '0' else
           '0' when Instr(27 downto 26) = "10";

  AluSrc <= '0' when Instr(27 downto 26) = "00" and Instr(25) = '0' else
            '0' when Instr(27 downto 26) = "00" and Instr(25) = '0' and Instr(20) = '1' else
            '1' when Instr(27 downto 26) = "00" and Instr(25) = '1' else
            '1' when Instr(27 downto 26) = "01" and Instr(20) = '1' else
            '1' when Instr(27 downto 26) = "01" and Instr(20) = '0' else
            '1' when Instr(27 downto 26) = "10";

  ImmSrc <= "00" when Instr(27 downto 26) = "00" and Instr(25) = '0' else -- XX
            "00" when Instr(27 downto 26) = "00" and Instr(25) = '0' and Instr(20) = '1' else -- XX
            "00" when Instr(27 downto 26) = "00" and Instr(25) = '1' else
            "01" when Instr(27 downto 26) = "01" and Instr(20) = '1' else
            "01" when Instr(27 downto 26) = "01" and Instr(20) = '0' else
            "10" when Instr(27 downto 26) = "10";

  RegWr <= '1' when Instr(27 downto 26) = "00" and Instr(25) = '0' else
           '0' when Instr(27 downto 26) = "00" and Instr(25) = '0' and Instr(20) = '1' else
           '1' when Instr(27 downto 26) = "00" and Instr(25) = '1' else
           '1' when Instr(27 downto 26) = "01" and Instr(20) = '1' else
           '0' when Instr(27 downto 26) = "01" and Instr(20) = '0' else
           '0' when Instr(27 downto 26) = "10";

  RegSrc <= "00" when Instr(27 downto 26) = "00" and Instr(25) = '0' else
            "00" when Instr(27 downto 26) = "00" and Instr(25) = '0' and Instr(20) = '1' else
            "00" when Instr(27 downto 26) = "00" and Instr(25) = '1' else -- X0
            "00" when Instr(27 downto 26) = "01" and Instr(20) = '1' else -- X0
            "10" when Instr(27 downto 26) = "01" and Instr(20) = '0' else
            "01" when Instr(27 downto 26) = "10"; -- X1

  -- INPUTS                                                           | OUTPUTS
  -- Instr <27..26> | Instr <25> | Instr <20> | Instr <15..12>        | PCSrc 
  -- 00 reg/reg     | 0          | X          | 1111                  | 1
  -- 00 reg/reg     | 0          | 1          | XXXX (autre que 1111) | 0
  -- 00 reg/imm     | 1          | X          | 1111                  | 1
  -- 00 reg/imm     | 1          | X          | XXXX (autre que 1111) | 0
  -- 01 (LDR)       | X          | 1          | 1111                  | 1
  -- 01 (LDR)       | X          | 1          | XXXX (autre que 1111) | 0
  -- 01 (STR)       | X          | 0          | XXXX                  | 0
  -- 10 (B)         | X          | X          | XXXX                  | X
  -- X meaining don't care

  PCSrc <= '1' when Instr(27 downto 26) = "00" and Instr(25) = '0' and Instr(15 downto 12) = "1111" else
           '0' when Instr(27 downto 26) = "00" and Instr(25) = '0' and Instr(20) = '1' and Instr(15 downto 12) /= "1111" else
           '1' when Instr(27 downto 26) = "00" and Instr(25) = '1' and Instr(15 downto 12) = "1111" else
           '0' when Instr(27 downto 26) = "00" and Instr(25) = '1' and Instr(15 downto 12) /= "1111" else
           '1' when Instr(27 downto 26) = "01" and Instr(20) = '1' and Instr(15 downto 12) = "1111" else
           '0' when Instr(27 downto 26) = "01" and Instr(20) = '1' and Instr(15 downto 12) /= "1111" else
           '0' when Instr(27 downto 26) = "01" and Instr(20) = '0' else
           '0' when Instr(27 downto 26) = "10"; -- X

  -- INPUTS                                   | OUTPUTS
  -- Instr <27..26> | Instr <25> | Instr <20> | CCWr
  -- 00 reg/reg     | 0          | 0          | 0
  -- 00 reg/reg     | 0          | 1          | 1
  -- 00 reg/imm     | 1          | 0          | 0
  -- 00 reg/imm     | 1          | 1          | 1
  -- 01 (LDR)       | X          | 1          | 0
  -- 01 (STR)       | X          | 0          | 0
  -- 10 (B)         | X          | X          | 0

  CCWr <= '0' when Instr(27 downto 26) = "00" and Instr(25) = '0' and Instr(20) = '0' else
          '1' when Instr(27 downto 26) = "00" and Instr(25) = '0' and Instr(20) = '1' else
          '0' when Instr(27 downto 26) = "00" and Instr(25) = '1' and Instr(20) = '0' else
          '1' when Instr(27 downto 26) = "00" and Instr(25) = '1' and Instr(20) = '1' else
          '0' when Instr(27 downto 26) = "01" and Instr(20) = '1' else
          '0' when Instr(27 downto 26) = "01" and Instr(20) = '0' else
          '0' when Instr(27 downto 26) = "10";


end architecture;