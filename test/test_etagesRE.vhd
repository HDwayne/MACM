library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity test_etageRE is
end test_etageRE;

architecture behavior of test_etageRE is
    constant clkpulse : Time := 10 ns; -- 1/2 period of clock
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
        -- Initialize inputs
        Res_Mem_RE <= std_logic_vector(to_unsigned(100, 32));  -- Example memory read value
        Res_ALU_RE <= std_logic_vector(to_unsigned(200, 32));  -- Example ALU result value
        Op3_RE <= std_logic_vector(to_unsigned(4, 4));  -- Example register index

        -- Test scenario 1: Select ALU result
        MemToReg_RE <= '0';  -- Select ALU result
        wait for clkpulse;
        clk <= '1';  -- Rising edge of clock
        wait for clkpulse;
        clk <= '0';  -- Falling edge of clock
        assert Res_RE = Res_ALU_RE
            report "ALU result was not correctly selected by Retire stage." severity error;

        -- Test scenario 2: Select Memory result
        MemToReg_RE <= '1';  -- Select Memory result
        wait for clkpulse;
        clk <= '1';  -- Rising edge of clock
        wait for clkpulse;
        clk <= '0';  -- Falling edge of clock
        assert Res_RE = Res_Mem_RE
            report "Memory result was not correctly selected by Retire stage." severity error;

        -- Check if Op3_RE is forwarded correctly
        assert Op3_RE_out = Op3_RE
            report "Register index was not correctly forwarded by Retire stage." severity error;

        wait; -- End simulation
    end process P_TEST;
end behavior;
