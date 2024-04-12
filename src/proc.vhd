-------------------------------------------------------

-- Chemin de données

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity dataPath is
  port(
    clk, init, Gel_LI, Gel_DI, RAZ_DI, Clr_EX: in std_logic;
    EA_EX, EB_EX : in std_logic_vector(1 downto 0);
    instr_DE: out std_logic_vector(31 downto 0);
    a1, a2, rs1, rs2, op3_EX_out, op3_ME_out, op3_RE_out: out std_logic_vector(3 downto 0)
);      
end entity;

architecture dataPath_arch of dataPath is
  signal Res_RE, npc_fwd_br, pc_plus_4, i_FE, i_DE, Op1_DE, Op2_DE, Op1_EX, Op2_EX, extImm_DE, extImm_EX, Res_EX, Res_ME, WD_EX, WD_ME, Res_Mem_ME, Res_Mem_RE, Res_ALU_ME, Res_ALU_RE, Res_fwd_ME : std_logic_vector(31 downto 0);
  signal Op3_DE, Op3_EX, a1_DE, a1_EX, a2_DE, a2_EX, Op3_EX_out_t, Op3_ME, Op3_ME_out_t, Op3_RE, Op3_RE_out_t : std_logic_vector(3 downto 0);

  signal uc_PCSrc, PCSrcEX, and_PCSrcEX, PCSrcME, PCSrcRE : std_logic;
  signal uc_RegWr, RegWR_EX, and_RegWR_EX, RegWR_ME, RegWR_RE: std_logic;
  signal uc_MemToReg, MemToReg_EX, MemToReg_ME, MemToReg_RE : std_logic;
  signal uc_MemWr, MemWrEX, and_MemWrEX, MemWr_MemME: std_logic;
  signal uc_Branch, BranchEX, Bpris_EX: std_logic;
  signal uc_Cond, cond : std_logic_vector(3 downto 0);

  signal uc_CCWr, CCWr_EX, uc_AluSrc, ALUSrc_EX, CondEx : std_logic;
  signal uc_AluCtrl, ALUCtrl_EX, uc_ImmSrc, uc_RegSrc : std_logic_vector(1 downto 0);
  signal CC, cc_prim, CC_EX : std_logic_vector(3 downto 0);
begin

  -- FE

  FE: entity work.etageFE
    port map(
      npc => Res_RE,
      npc_fw_br => npc_fwd_br,
      PCSrc_ER => PCSrcRE,
      Bpris_EX => Bpris_EX,
      Gel_LI => Gel_LI,
      clk => clk,
      pc_plus_4 => pc_plus_4,
      i_FE => i_FE
  );

  Reg32FE_i_FE: entity work.Reg32
    port map(
      source => i_FE,
      output => i_DE,
      wr => Gel_DI,
      raz => RAZ_DI,
      clk => clk
  );

  -- DE

  DE: entity work.etageDE
    port map(
      i_DE => i_DE,
      WD_ER => Res_RE,
      pc_plus_4 => pc_plus_4,
      Op3_ER => Op3_RE_out_t,
      RegSrc => uc_RegSrc,
      immSrc => uc_ImmSrc,
      RegWr => RegWR_RE,
      clk => clk,
      init => init,
      Reg1 => a1_DE,
      Reg2 => a2_DE,
      Op3_DE => Op3_DE,
      Op1 => Op1_DE,
      Op2 => Op2_DE,
      extImm => extImm_DE
  );

  control_unit: entity work.control_unit
    port map(
      instr => i_DE,
      PCSrc => uc_PCSrc,
      RegWr => uc_RegWr,
      MemToReg => uc_MemToReg,
      MemWr => uc_MemWr,
      Branch => uc_Branch,
      CCWr => uc_CCWr,
      AluSrc => uc_AluSrc,
      AluCtrl => uc_AluCtrl,
      ImmSrc => uc_ImmSrc,
      RegSrc => uc_RegSrc,
      Cond => uc_Cond
  );

  Reg1UC_AluSrc : entity work.Reg1
    port map(
      source => uc_AluSrc,
      output => ALUSrc_EX,
      wr => '1',
      raz => Clr_EX,
      clk => clk
  );

  Reg2UC_AluCtrl : entity work.Reg2
    port map(
      source => uc_AluCtrl,
      output => ALUCtrl_EX,
      wr => '1',
      raz => Clr_EX,
      clk => clk
  );

  Reg1UC_MemToReg : entity work.Reg1
    port map(
      source => uc_MemToReg,
      output => MemToReg_EX,
      wr => '1',
      raz => Clr_EX,
      clk => clk
  );

  Reg1UC_RegWr : entity work.Reg1
    port map(
      source => uc_RegWr,
      output => RegWR_EX,
      wr => '1',
      raz => Clr_EX,
      clk => clk
  );

  Reg1UC_PCSrc : entity work.Reg1
    port map(
      source => uc_PCSrc,
      output => and_PCSrcEX,
      wr => '1',
      raz => Clr_EX,
      clk => clk
  );

  Reg1UC_MemWr : entity work.Reg1
    port map(
      source => uc_MemWr,
      output => MemWrEX,
      wr => '1',
      raz => Clr_EX,
      clk => clk
  );

  Reg1UC_Branch : entity work.Reg1
    port map(
      source => uc_Branch,
      output => BranchEX,
      wr => '1',
      raz => Clr_EX,
      clk => clk
  );

  Reg4DE_a1 : entity work.Reg4
    port map(
      source => a1_DE,
      output => a1_EX,
      wr => '1',
      raz => Clr_EX,
      clk => clk
  );

  Reg4DE_a2 : entity work.Reg4
    port map(
      source => a2_DE,
      output => a2_EX,
      wr => '1',
      raz => Clr_EX,
      clk => clk
  );

  Reg32DE_Op1 : entity work.Reg32
    port map(
      source => Op1_DE,
      output => Op1_EX,
      wr => '1',
      raz => Clr_EX,
      clk => clk
  );

  Reg32DE_Op2 : entity work.Reg32
    port map(
      source => Op2_DE,
      output => Op2_EX,
      wr => '1',
      raz => Clr_EX,
      clk => clk
  );

  Reg32DE_extImm : entity work.Reg32
    port map(
      source => extImm_DE,
      output => extImm_EX,
      wr => '1',
      raz => Clr_EX,
      clk => clk
  );

  Reg4DE_Op3 : entity work.Reg4
    port map(
      source => Op3_DE,
      output => Op3_EX,
      wr => '1',
      raz => Clr_EX,
      clk => clk
  );

  Reg4DE_CC_prim : entity work.Reg4
    port map(
      source => CC_prim,
      output => CC_EX,
      wr => '1',
      raz => Clr_EX,
      clk => clk
  );

  Reg4DE_Cond : entity work.Reg4
    port map(
      source => uc_Cond,
      output => cond,
      wr => '1',
      raz => Clr_EX,
      clk => clk
  );

  Reg1DE_CCWr : entity work.Reg1
    port map(
      source => uc_CCWr,
      output => CCWr_EX,
      wr => '1',
      raz => Clr_EX,
      clk => clk
  );

  -- EX
 
  EX: entity work.etageEX
    port map(
      Op1_EX => Op1_EX,
      Op2_EX => Op2_EX,
      ExtImm_EX => extImm_EX,
      Res_fwd_ME => Res_fwd_ME,
      Res_fwd_ER => Res_RE,
      Op3_EX => Op3_EX,
      EA_EX => EA_EX,
      EB_EX => EB_EX,
      ALUCtrl_EX => ALUCtrl_EX,
      ALUSrc_EX => ALUSrc_EX,
      CC => CC,
      Op3_EX_out => Op3_EX_out_t,
      WD_EX => WD_EX,
      Res_EX => Res_EX,
      npc_fw_br => npc_fwd_br
  );

  condition_management_unit: entity work.condition_management_unit
    port map(
      Cond => cond,
      CC_EX => CC_EX,
      CC => CC,
      CCWr_EX => CCWr_EX,
      CC_prim => cc_prim,
      CondEx => CondEx
  );

  and_RegWR_EX <= RegWR_EX when CondEx = '1' else '0';
  and_PCSrcEX <= PCSrcEX when CondEx = '1' else '0';
  and_MemWrEX <= MemWrEX when CondEx = '1' else '0';
  Bpris_EX <= BranchEX when CondEx = '1' else '0';

  Reg32EX_RegWR : entity work.Reg1
    port map(
      source => and_RegWR_EX,
      output => RegWR_ME,
      wr => '1',
      raz => '1',
      clk => clk
  );

  Reg1EX_PCSrc : entity work.Reg1
    port map(
      source => and_PCSrcEX,
      output => PCSrcME,
      wr => '1',
      raz => '1',
      clk => clk
  );

  Reg32EX_Res : entity work.Reg32
    port map(
      source => Res_EX,
      output => Res_ME,
      wr => '1',
      raz => '1',
      clk => clk
  );

  Reg32EX_WD : entity work.Reg32
    port map(
      source => WD_EX,
      output => WD_ME,
      wr => '1',
      raz => '1',
      clk => clk
  );

  Reg4EX_Op3 : entity work.Reg4
    port map(
      source => Op3_EX_out_t,
      output => Op3_ME,
      wr => '1',
      raz => '1',
      clk => clk
  );

  Reg1EX_MemToReg : entity work.Reg1
    port map(
      source => MemToReg_EX,
      output => MemToReg_ME,
      wr => '1',
      raz => '1',
      clk => clk
  );

  Reg1EX_MemWr : entity work.Reg1
    port map(
      source => and_MemWrEX,
      output => MemWr_MemME,
      wr => '1',
      raz => '1',
      clk => clk
  );

  -- ME

  ME: entity work.etageME
    port map(
      Res_ME => Res_ME,
      WD_ME => WD_ME,
      Op3_ME => Op3_ME,
      clk => clk,
      MemWr_Mem => MemWr_MemME,
      Res_ALU_ME => Res_ALU_ME,
      Res_Mem_ME => Res_Mem_ME,
      Op3_ME_out => Op3_ME_out_t,
      Res_fwd_ME => Res_fwd_ME
  );

  Reg32ME_Res_Mem : entity work.Reg32
    port map(
      source => Res_Mem_ME,
      output => Res_Mem_RE,
      wr => '1',
      raz => '1',
      clk => clk
  );

  Reg32ME_Res_ALU : entity work.Reg32
    port map(
      source => Res_ALU_ME,
      output => Res_ALU_RE,
      wr => '1',
      raz => '1',
      clk => clk
  );

  Reg4ME_Op3 : entity work.Reg4
    port map(
      source => Op3_ME_out_t,
      output => Op3_RE,
      wr => '1',
      raz => '1',
      clk => clk
  );

  Reg1ME_MemToReg : entity work.Reg1
    port map(
      source => MemToReg_ME,
      output => MemToReg_RE,
      wr => '1',
      raz => Clr_EX,
      clk => clk
  );

  Reg1ME_RegWR : entity work.Reg1
    port map(
      source => RegWR_ME,
      output => RegWR_RE,
      wr => '1',
      raz => Clr_EX,
      clk => clk
  );

  Reg1ME_PCSrc : entity work.Reg1
    port map(
      source => PCSrcME,
      output => PCSrcRE,
      wr => '1',
      raz => Clr_EX,
      clk => clk
  );

  -- RE

  RE: entity work.etageRE
    port map(
      Res_Mem_RE => Res_Mem_RE,
      Res_ALU_RE => Res_ALU_RE,
      Op3_RE => Op3_RE,
      MemToReg_RE => MemToReg_RE,
      Res_RE => Res_RE,
      Op3_RE_out => Op3_RE_out_t
  );

  -- Signaux

  instr_DE <= i_DE;
  a1 <= a1_DE;
  a2 <= a2_DE;
  rs1 <= Op3_DE;
  rs2 <= Op3_DE;
  CC <= Op3_DE;
  op3_EX_out <= Op3_EX_out_t;
  op3_ME_out <= Op3_ME_out_t;
  op3_RE_out <= Op3_RE_out_t;
  
end architecture;
