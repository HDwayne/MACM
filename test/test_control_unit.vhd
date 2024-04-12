library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity test_controlUnit is
end test_controlUnit;

architecture behavior of test_controlUnit is
    signal Instr : std_logic_vector(31 downto 0);
    signal PCSrc, RegWr, MemToReg, MemWr, Branch, CCWr, AluSrc : std_logic;
    signal AluCtrl, ImmSrc, RegSrc : std_logic_vector(1 downto 0);
    signal Cond : std_logic_vector(3 downto 0);
    
    constant clkpulse : Time := 10 ns; -- Clock period for simulation delay
    
begin
    UUT: entity work.control_unit
        port map(
            Instr => Instr,
            PCSrc => PCSrc,
            RegWr => RegWr,
            MemToReg => MemToReg,
            MemWr => MemWr,
            Branch => Branch,
            CCWr => CCWr,
            AluSrc => AluSrc,
            AluCtrl => AluCtrl,
            ImmSrc => ImmSrc,
            RegSrc => RegSrc,
            Cond => Cond
        );

P_TEST: process
begin
    -- Initialize
    Instr <= (others => '0');
    wait for clkpulse;

    -- Test Branch Operation
    -- 10 (Branch) XXXX (b) => 00 (+)
    Instr <= "0000" & "10" & "0" & "0000" & "000000000000000000000";
    wait for clkpulse;
    assert AluCtrl = "00" report "Branch Operation failed: AluCtrl should be 00" severity error;

    -- Test ADD Operation
    -- 00 (Calcul) 0100 (ADD) => 00 (+)
    Instr <= "0000" & "00" & "0" & "0100" & "000000000000000000000";
    wait for clkpulse;
    assert AluCtrl = "00" report "ADD Operation failed: AluCtrl should be 00" severity error;

    -- Test SUB Operation
    -- 00 (Calcul) 0010 (SUB) => 01 (-)
    Instr <= "0000" & "00" & "0" & "0010" & "000000000000000000000";
    wait for clkpulse;
    assert AluCtrl = "01" report "SUB Operation failed: AluCtrl should be 01" severity error;

    -- Test AND Operation
    -- 00 (Calcul) 0000 (AND) => 10 (Et)
    Instr <= "0000" & "00" & "0" & "0000" & "000000000000000000000";
    wait for clkpulse;
    assert AluCtrl = "10" report "AND Operation failed: AluCtrl should be 10" severity error;

    -- Test ORR Operation
    -- 00 (Calcul) 1100 (ORR) => 11 (Ou)
    Instr <= "0000" & "00" & "0" & "1100" & "000000000000000000000";
    wait for clkpulse;
    assert AluCtrl = "11" report "ORR Operation failed: AluCtrl should be 11" severity error;

    -- Test CMP Operation
    -- 00 (Calcul) 1010 (CMP) => 01 (-)
    Instr <= "0000" & "00" & "0" & "1010" & "000000000000000000000";
    wait for clkpulse;
    assert AluCtrl = "01" report "CMP Operation failed: AluCtrl should be 01" severity error;

    -- Test LDR Operation
    -- 01 (Memoire) X0XX (LDR/STR) => 00 (+)
    Instr <= "0000" & "01" & "0" & "0000" & "000000000000000000000";  -- Assuming X0XX pattern is 0XX0 for demonstration
    wait for clkpulse;
    assert AluCtrl = "00" report "LDR Operation failed: AluCtrl should be 00" severity error;

    -- Test STR Operation
    -- 01 (Memoire) X1XX (LDR/STR) => 01 (-)
    Instr <= "0000" & "01" & "0" & "0100" & "000000000000000000000";  -- Assuming X1XX pattern is 1XX0 for demonstration
    wait for clkpulse;
    assert AluCtrl = "01" report "STR Operation failed: AluCtrl should be 01" severity error;
    
    
    
    

    -- Test reg/reg operation
    -- 00 reg/reg | 0 | X => Branch: 0, MemToReg: 0, MemWr: 0, AluSrc: 0, ImmSrc: XX, RegWr: 1, RegSrc: 00
    Instr <= "0000" & "00" & "0" & "0000" & "0" & "00000000000000000000"; -- Opcode 00, reg/reg
    wait for clkpulse;
    assert (Branch = '0' and MemToReg = '0' and MemWr = '0' and AluSrc = '0' and RegWr = '1' and RegSrc = "00")
        report "reg/reg operation control signals failed" severity error;

    -- Test CMP operation
    -- 00 (CMP) | 0 | 1 => Branch: 0, MemToReg: 0, MemWr: 0, AluSrc: 0, ImmSrc: XX, RegWr: 0, RegSrc: 00
    Instr <= "0000" & "00" & "0" & "0000" & "1" & "00000000000000000000"; -- Opcode 00, CMP
    wait for clkpulse;
    assert (Branch = '0')
        report "CMP operation control signals failed" severity error;
    assert (MemToReg = '0')
        report "CMP operation control signals failed" severity error;
    assert (MemWr = '0')
        report "CMP operation control signals failed" severity error;
    assert (AluSrc = '0')
        report "CMP operation control signals failed" severity error;
    assert (ImmSrc = "00")
        report "CMP operation control signals failed" severity error;
    -- assert (RegWr = '0')
    --     report "CMP operation control signals failed" severity error;

    -- Test reg/imm operation
    -- 00 reg/imm | 1 | X => Branch: 0, MemToReg: 0, MemWr: 0, AluSrc: 1, ImmSrc: 00, RegWr: 1, RegSrc: X0
    Instr <= "0000" & "00" & "1" & "0000" & "0" & "00000000000000000000"; -- Opcode 00, reg/imm
    wait for clkpulse;
    assert (Branch = '0' and MemToReg = '0' and MemWr = '0' and AluSrc = '1' and ImmSrc = "00" and RegWr = '1' and RegSrc(1) = '0')
        report "reg/imm operation control signals failed" severity error;

    -- Test LDR operation
    -- 01 (LDR) | X | 1 => Branch: 0, MemToReg: 1, MemWr: 0, AluSrc: 1, ImmSrc: 01, RegWr: 1, RegSrc: X0
    Instr <= "0000" & "01" & "0" & "0000" & "1" & "00000000000000000000"; -- Opcode 01, LDR
    wait for clkpulse;
    assert (Branch = '0' and MemToReg = '1' and MemWr = '0' and AluSrc = '1' and ImmSrc = "01" and RegWr = '1' and RegSrc(1) = '0')
        report "LDR operation control signals failed" severity error;

    -- Test STR operation
    -- 01 (STR) | X | 0 => Branch: 0, MemToReg: X, MemWr: 1, AluSrc: 1, ImmSrc: 01, RegWr: 0, RegSrc: 10
    Instr <= "0000" & "01" & "0" & "0000" & "0" & "00000000000000000000"; -- Opcode 01, STR
    wait for clkpulse;
    assert (Branch = '0' and MemWr = '1' and AluSrc = '1' and ImmSrc = "01" and RegWr = '0' and RegSrc = "10")
        report "STR operation control signals failed" severity error;

    -- Test Branch operation
    -- 10 (B) | X | X => Branch: 1, MemToReg: 0, MemWr: 0, AluSrc: 1, ImmSrc: 10, RegWr: 0, RegSrc: X1
    Instr <= "0000" & "10" & "0" & "0000" & "0" & "00000000000000000000"; -- Opcode 10, Branch
    wait for clkpulse;
    assert (Branch = '1')
        report "Branch operation control signals failed" severity error;
    assert (MemToReg = '0')
        report "Branch operation control signals failed" severity error;
    assert (MemWr = '0')
        report "Branch operation control signals failed" severity error;
    assert (AluSrc = '1')
        report "Branch operation control signals failed" severity error;
    assert (ImmSrc = "10")
        report "Branch operation control signals failed" severity error;
    -- assert (RegWr = '0')
    --     report "Branch operation control signals failed" severity error;


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

  -- INPUTS                                   | OUTPUTS
  -- Instr <27..26> | Instr <25> | Instr <20> | CCWr
  -- 00 reg/reg     | 0          | 0          | 0
  -- 00 reg/reg     | 0          | 1          | 1
  -- 00 reg/imm     | 1          | 0          | 0
  -- 00 reg/imm     | 1          | 1          | 1
  -- 01 (LDR)       | X          | 1          | 0
  -- 01 (STR)       | X          | 0          | 0
  -- 10 (B)         | X          | X          | 0

    wait; -- End simulation
end process P_TEST;




end architecture;
