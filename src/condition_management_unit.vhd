LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity condition_management_unit is
  port(
    Cond, CC_EX, CC : in std_logic_vector(3 downto 0);
    CCWr_EX: in std_logic;
    CC_prim : out std_logic_vector(3 downto 0);
    CondEx : out std_logic
);
end entity;

architecture condition_management_unit_arch of condition_management_unit is
  signal Z, N, C, V : std_logic;
  signal sig_condEx : std_logic;
begin
  Z <= '1' when CC_EX(0) = '1' else '0';
  N <= '1' when CC_EX(1) = '1' else '0';
  C <= '1' when CC_EX(2) = '1' else '0';
  V <= '1' when CC_EX(3) = '1' else '0';

  -- Opcode | Condition | Sémantique                          | Calcul
  -- 0000   | EQ        | Egal/Egal à 0                       | Z set
  -- 0001   | NE        | Non égal                            | Z clear
  -- 0010   | CS/HS     | Carry set / unsigned higher or same | C set
  -- 0011   | CC/LO     | Carry clear /unsigned lower         | C clear
  -- 0100   | MI        | Négatif                             | N set
  -- 0101   | PL        | Positif                             | N clear
  -- 0110   | VS        | Overflow                            | V set
  -- 0111   | VC        | Pas d'overflow                      | V clear
  -- 1000   | HI        | Unsigned Higher                     | C set et Z clear
  -- 1001   | LS        | Unsigned lower or same              | C clear ou Z set
  -- 1010   | GE        | Signed greater or equal             | N == V
  -- 1011   | LT        | Signed less than                    | N != V
  -- 1100   | GT        | Signed greater than                 | Z clear et N == V
  -- 1101   | LE        | Signed less than or equal           | Z set ou N != V
  -- 1110   | AL        | Toujours vrai                       | 1

  sig_condEx <= '1' when Cond = "0000" and Z = '1' else
            '1' when Cond = "0001" and Z = '0' else
            '1' when Cond = "0010" and C = '1' else
            '1' when Cond = "0011" and C = '0' else
            '1' when Cond = "0100" and N = '1' else
            '1' when Cond = "0101" and N = '0' else
            '1' when Cond = "0110" and V = '1' else
            '1' when Cond = "0111" and V = '0' else
            '1' when Cond = "1000" and (C = '1' and Z = '0') else
            '1' when Cond = "1001" and (C = '0' or Z = '1') else
            '1' when Cond = "1010" and N = V else
            '1' when Cond = "1011" and N /= V else
            '1' when Cond = "1100" and (Z = '0' and N = V) else
            '1' when Cond = "1101" and (Z = '1' or N /= V) else
            '1' when Cond = "1110" else
            '0';

  CC_prim <= CC when CCWr_EX = '1' and sig_condEx = '1' else CC_EX;
  CondEx <= sig_condEx;

end architecture;