library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity test_etageME is
end test_etageME;

architecture behavior of test_etageME is
    constant clkpulse : time := 10 ns; -- Clock pulse width
    signal clk : std_logic := '0';

    signal Res_ME, WD_ME, Res_Mem_ME, Res_ALU_ME : std_logic_vector(31 downto 0);
    signal Op3_ME, Op3_ME_out : std_logic_vector(3 downto 0);
    signal MemWR_Mem : std_logic;
    signal addr : std_logic_vector(31 downto 0);
    signal data : std_logic_vector(31 downto 0);

begin
    etageME_inst: entity work.data_mem
        port map(
            clk => clk,
            WR => MemWR_Mem,
            addr => addr,
            WD => WD_ME,
            data => Res_Mem_ME
        );

    -- Test scenarios
    P_TEST: process
    begin
        -- Initialize inputs
        addr <= std_logic_vector(to_unsigned(1, 32));  -- Set initial address
        WD_ME <= std_logic_vector(to_unsigned(123, 32));  -- Set initial data to write

        -- Test scenario 1: Write to memory
        MemWR_Mem <= '1'; -- Enable write operation
        wait for clkpulse;
        clk <= '1';  -- Rising edge of clock to trigger write
        wait for clkpulse;
        clk <= '0';  -- Falling edge of clock
        MemWR_Mem <= '0'; -- Disable write operation for next operations

        -- Test scenario 2: Read from memory
        wait for clkpulse;
        clk <= '1';  -- Rising edge of clock
        wait for clkpulse;
        clk <= '0';  -- Falling edge of clock
        
        -- Check if memory read value matches the written value
        assert Res_Mem_ME = WD_ME
            report "Memory read operation failed: Data mismatch on read back." severity error;

        -- Additional test cycle
        wait for clkpulse;
        clk <= '1';
        wait for clkpulse;
        clk <= '0';

        wait; -- End simulation
    end process P_TEST;
end behavior;
