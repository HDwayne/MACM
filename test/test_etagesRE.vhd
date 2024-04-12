library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity test_etageRE is
end test_etageRE;

architecture behavior of test_etageRE is
    constant clkpulse : Time := 10 ns;
    signal clk : std_logic;

    signal Res_Mem_RE, Res_ALU_RE : std_logic_vector(31 downto 0);
    signal Op3_RE : std_logic_vector(3 downto 0);
    signal MemToReg_RE : std_logic;
    signal Res_RE : std_logic_vector(31 downto 0);
    signal Op3_RE_out : std_logic_vector(3 downto 0);
  
begin
    etageRE_inst: entity work.etageRE
        port map(
            Res_Mem_RE => Res_Mem_RE,
            Res_ALU_RE => Res_ALU_RE,
            Op3_RE => Op3_RE,
            MemToReg_RE => MemToReg_RE,
            Res_RE => Res_RE,
            Op3_RE_out => Op3_RE_out
        );

    P_TEST: process
    begin
        -- Initialisation des entrées
        Res_Mem_RE <= std_logic_vector(to_unsigned(100, 32));
        Res_ALU_RE <= std_logic_vector(to_unsigned(200, 32));
        Op3_RE <= std_logic_vector(to_unsigned(4, 4));

        -- Test scenario 1: ALU
        MemToReg_RE <= '0';
        wait for clkpulse;
        clk <= '1';
        wait for clkpulse;
        clk <= '0';
        assert Res_RE = Res_ALU_RE
            report "Le resultat de l'ALU n'est pas correctement selectionné par l'étage RE." severity error;

        -- Test scenario 2: Memoire
        MemToReg_RE <= '1';
        wait for clkpulse;
        clk <= '1';
        wait for clkpulse;
        clk <= '0';
        assert Res_RE = Res_Mem_RE
            report "Le resultat de la memoire n'est pas correctement selectionné par l'étage RE." severity error;

        -- Test scenario 3: index du registre 
        assert Op3_RE_out = Op3_RE
            report "L'index du registre n'est pas correctement transmis par l'étage RE." severity error;

        wait;
    end process P_TEST;
end behavior;
