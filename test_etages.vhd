library IEEE;

USE IEEE.STD_LOGIC_1164.ALL;

entity test_etageFE is
end test_etageFE;

architecture behavior of test_etageFE is
  constant clkpulse : Time := 10 ns; -- 1/2 periode horloge

  signal npc, npc_fw_br : std_logic_vector(31 downto 0);
  signal PCSrc_ER, Bpris_EX, GEL_LI, clk : std_logic;
  signal pc_plus_4, i_FE : std_logic_vector(31 downto 0);
  
begin
  etageFE_inst: entity work.etageFE
    port map(
      clk => clk,
      
      -- input parameters
      PCSrc_ER => PCSrc_ER,
      Bpris_EX => Bpris_EX,
      GEL_LI => GEL_LI,

      -- input values
      npc => npc,
      npc_fw_br => npc_fw_br,
      
      -- output
      pc_plus_4 => pc_plus_4,
      i_FE => i_FE
    );

  P_TEST: process
  begin
    --instanciation
    npc <= (others => '0');
    npc_fw_br <= (others => '1');
    GEL_LI <= '1';

    wait for clkpulse;
    clk <= '0';
    
    PCSrc_ER <= '1';
    Bpris_EX <= '0';

    wait for clkpulse;
    clk <= '1';

    Bpris_EX <= '1';

    wait for clkpulse;
    clk <= '0';
    
    PCSrc_ER <= '0';
    Bpris_EX <= '0';

    wait for clkpulse;
    clk <= '1';

    Bpris_EX <= '1';

    wait for clkpulse;
    clk <= '0'; -- 4
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