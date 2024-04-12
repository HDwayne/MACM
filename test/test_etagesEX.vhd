library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

entity test_etageEX is
end test_etageEX;

architecture behavior of test_etageEX is
  constant clkpulse : Time := 10 ns;
  signal clk : std_logic;

  signal Op1_EX, Op2_EX, ExtImm_EX, Res_fwd_ME, Res_fwd_ER : std_logic_vector(31 downto 0);
  signal Op3_EX : std_logic_vector(3 downto 0);
  signal EA_EX, EB_EX, ALUCtrl_EX : std_logic_vector(1 downto 0);
  signal ALUSrc_EX : std_logic;
  signal CC, Op3_EX_out : std_logic_vector(3 downto 0);
  signal WD_EX, Res_EX, npc_fw_br : std_logic_vector(31 downto 0);
  
begin
  etageEX_inst: entity work.etageEX
    port map(
      Op1_EX => Op1_EX,
      Op2_EX => Op2_EX,
      Op3_EX => Op3_EX,
      ExtImm_EX => ExtImm_EX,
      EA_EX => EA_EX,
      EB_EX => EB_EX,
      ALUCtrl_EX => ALUCtrl_EX,
      ALUSrc_EX => ALUSrc_EX,
      CC => CC,
      Op3_EX_out => Op3_EX_out,
      WD_EX => WD_EX,
      Res_EX => Res_EX,
      npc_fw_br => npc_fw_br,
      Res_fwd_ME => Res_fwd_ME,
      Res_fwd_ER => Res_fwd_ER
    );

  P_TEST: process
  begin
    -- initialisation des signaux
    Op1_EX <= std_logic_vector(to_unsigned(15, 32));
    Op2_EX <= std_logic_vector(to_unsigned(10, 32));
    ExtImm_EX <= std_logic_vector(to_unsigned(5, 32));
    Res_fwd_ME <= std_logic_vector(to_unsigned(20, 32));
    Res_fwd_ER <= std_logic_vector(to_unsigned(25, 32));
    ALUCtrl_EX <= "00"; -- ADD operation
    ALUSrc_EX <= '0';
    EA_EX <= "00";
    EB_EX <= "00";
    clk <= '0';
    
    -- Test Scenario 1: Addition
    wait for clkpulse;
    clk <= '1';
    wait for clkpulse;
    clk <= '0';
    assert Res_EX = std_logic_vector(to_unsigned(25, 32)) 
        -- report "ALU operation failed: Addition incorrect." severity error;
        report "ALU addition erreur." severity error;

    -- Test Scenario 2
    ALUSrc_EX <= '1';
    wait for clkpulse;
    clk <= '1';
    wait for clkpulse;
    clk <= '0';
    assert Res_EX = std_logic_vector(to_unsigned(20, 32)) 
        report "ALU operation avec immediate erreur." severity error;
    ALUSrc_EX <= '0';

    -- Test Scenario 3: Forwarding
    EB_EX <= "10";
    wait for clkpulse;
    clk <= '1';
    wait for clkpulse;
    clk <= '0';
    assert Res_EX = std_logic_vector(to_unsigned(35, 32)) 
        report "Forwarding de ME erreur." severity error;

    wait for clkpulse * 10;
    wait;
  end process P_TEST;
end behavior;