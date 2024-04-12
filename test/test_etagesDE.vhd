library IEEE;

USE IEEE.STD_LOGIC_1164.ALL;

entity test_etageDE is
end test_etageDE;

architecture behavior of test_etageDE is
  constant clkpulse : Time := 10 ns; -- 1/2 periode horloge

  signal i_DE, WD_ER, pc_plus_4 : std_logic_vector(31 downto 0);
  signal Op3_ER : std_logic_vector(3 downto 0);
  signal RegSrc, immSrc : std_logic_vector(1 downto 0);
  signal RegWr, clk, init : std_logic;

  signal Reg1, Reg2, Op3_DE : std_logic_vector(3 downto 0);
  signal Op1, Op2, extImm : std_logic_vector(31 downto 0);
  
begin
  etageDE_inst: entity work.etageDE
    port map(
      clk => clk,
      
      -- input
      i_DE => i_DE,
      WD_ER => WD_ER,
      pc_plus_4 => pc_plus_4,
      Op3_ER => Op3_ER,
      RegSrc => RegSrc,
      immSrc => immSrc,
      RegWr => RegWr,
      init => init,

      -- output
      Reg1 => Reg1,
      Reg2 => Reg2,
      Op3_DE => Op3_DE,
      Op1 => Op1,
      Op2 => Op2,
      extImm => extImm
    );

  P_TEST: process
  begin
    -- initialisation inputs
    -- i_DE <= "" -- instruction a decoder
    -- pc_plus_4 <= "" -- valeur du PC
    -- RegSrc <= "" -- controle de la source des operandes
    -- immSrc <= "" -- controle du moe d'extension des immediats
    -- RegWr <= '0' -- controle de l'ecriture dans banc de registres
    -- init <= '1' -- initialisation asynchrone des registres
    
    -- VERIFICATION ECRITURE REGISTRES

    wait for clkpulse;
    clk <= '0';

    RegWr <= '1'; -- active l'ecriture dans le registre

    -- Ecrire dans le registre avec Op3 et WD
    WD_ER <= "00000000000000000000000000001001"; -- donnee a ecrire
    Op3_ER <= "1000"; -- indice du registre a ecrire a ce cycle
    
    wait for clkpulse;
    clk <= '1';
    wait for clkpulse;
    clk <= '0';

    -- Ecrire dans le registre avec Op3 et WD
    WD_ER <= "00000000000000000000000000001111"; -- donnee a ecrire
    Op3_ER <= "1001"; -- indice du registre a ecrire a ce cycle

    
    
    wait for clkpulse;
    clk <= '1';
    wait for clkpulse;
    clk <= '0';

    -- desactiver l'ecriture dans le registre
    RegWr <= '0';
    -- VERIFICATION LECTURE REGISTRES
    i_DE <= "00000000000010010000000000001000";
    RegSrc <= "00";

    
    wait for clkpulse;
    clk <= '1'; -- 5
    wait for clkpulse;
    clk <= '0'; -- 6
    wait for clkpulse;
    clk <= '1'; -- 7
    wait for clkpulse;
    clk <= '0'; -- 8

    wait for 250 ns;
    wait;

  end process P_TEST;
end behavior;