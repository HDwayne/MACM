-------------------------------------------------

-- Etage FE

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity etageFE is
  port(
    npc, npc_fw_br : in std_logic_vector(31 downto 0);
    PCSrc_ER, Bpris_EX, GEL_LI, clk : in std_logic;
    pc_plus_4, i_FE : out std_logic_vector(31 downto 0)
);
end entity;


architecture etageFE_arch of etageFE is
  signal pc_inter, pc_reg_in, pc_reg_out, sig_pc_plus_4, sig_4: std_logic_vector(31 downto 0);
begin

  sig_4 <= (2=>'1', others => '0'); -- 4 en binaire
  
  pc_inter <= npc when PCSrc_ER = '1' else sig_pc_plus_4;

  pc_reg_in <= pc_inter when Bpris_EX = '0' else npc_fw_br;

  reg: entity work.Reg32
    port map(pc_reg_in, pc_reg_out, GEL_LI, '1', clk);
  
  add: entity work.addComplex
    port map(pc_reg_out, sig_4, '0', sig_pc_plus_4); -- , '0', '0');

  pc_plus_4 <= sig_pc_plus_4;
    
  mem_instr: entity work.inst_mem
    port map(pc_reg_out, i_FE);

end architecture;

-- -------------------------------------------------

-- Etage DE

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity etageDE is
  port (
    i_DE, WD_ER, pc_plus_4 : in std_logic_vector(31 downto 0);
    Op3_ER : in std_logic_vector(3 downto 0);
    RegSrc, immSrc : in std_logic_vector(1 downto 0);
    RegWr, clk, init : in std_logic;

    Reg1, Reg2, Op3_DE : out std_logic_vector(3 downto 0);
    Op1, Op2, extImm : out std_logic_vector(31 downto 0)
  );
end entity;

architecture etageDE_arch of etageDE is
  signal sigOp1, sigOp2 : std_logic_vector(3 downto 0);
  signal outOp1, outOp2 : std_logic_vector(31 downto 0);
  signal sig_15: std_logic_vector(3 downto 0);
begin
  sig_15 <= "1111";

  sigOp1 <= sig_15 when RegSrc(0) = '1' else i_DE(19 downto 16);
  sigOp2 <= i_DE(15 downto 12) when RegSrc(1) = '1' else i_DE(3 downto 0);

  Reg1 <= sigOp1;
  Reg2 <= sigOp2;

  Op3_DE <= i_DE(15 downto 12);

  RegisterBank : entity work.RegisterBank
    port map(sigOp1, Op1, sigOp2, Op2, Op3_ER, WD_ER, pc_plus_4, init, RegWr, clk);

  extension : entity work.extension
    port map(i_DE(23 downto 0), immSrc, extImm);

end architecture;

-- -------------------------------------------------

-- Etage EX

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity etageEX is
  port (
    Op1_EX, Op2_EX, ExtImm_EX, Res_fwd_ME, Res_fwd_ER : in std_logic_vector(31 downto 0);
    Op3_EX : in std_logic_vector(3 downto 0);
    EA_EX, EB_EX, ALUCtrl_EX : in std_logic_vector(1 downto 0);
    ALUSrc_EX : in std_logic;
    CC, Op3_EX_out : out std_logic_vector(3 downto 0);
    WD_EX, Res_EX, npc_fw_br : out std_logic_vector(31 downto 0)
  );
end entity;

architecture etageEX_arch of etageEX is
  signal ALUOp1, ALUOp2, Res, Oper2 : std_logic_vector(31 downto 0);
begin
  ALUOp1 <= Op1_EX when EA_EX = "00" else Res_fwd_ER when EA_EX = "01" else Res_fwd_ME;
  Oper2 <= Op2_EX when EB_EX = "00" else Res_fwd_ER when EB_EX = "01" else Res_fwd_ME;
  ALUOp2 <= ExtImm_EX when ALUSrc_EX = '1' else Oper2;

  Op3_EX_out <= Op3_EX;
  WD_EX <= Op2_EX;

  add: entity work.ALU
    port map(ALUOp1, ALUOp2, ALUCtrl_EX, Res, CC);

  Res_EX <= Res;
  npc_fw_br <= Res;
end architecture;


  -- -------------------------------------------------

-- Etage ME

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity etageME is
  port(
    Res_ME, WD_ME : in std_logic_vector(31 downto 0);
    Op3_ME : in std_logic_vector(3 downto 0);
    clk, MemWR_Mem : in std_logic;
    Res_ALU_ME, Res_Mem_ME : out std_logic_vector(31 downto 0);
    Op3_ME_out : out std_logic_vector(3 downto 0);
    Res_fwd_ME : out std_logic_vector(31 downto 0)
  );
end entity;

architecture etageME_arch of etageME is
begin
  Res_ALU_ME <= Res_ME;
  Op3_ME_out <= Op3_ME;
  Res_fwd_ME <= Res_ME;

  data_mem: entity work.data_mem
    port map(Res_ME, WD_ME, clk, MemWR_Mem, Res_Mem_ME);

end architecture;
-- -------------------------------------------------

-- -- Etage RE

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity etageRE is
  port(
    Res_Mem_RE, Res_ALU_RE : in std_logic_vector(31 downto 0);
    Op3_RE : in std_logic_vector(3 downto 0);
    MemToReg_RE : in std_logic;
    Res_RE : out std_logic_vector(31 downto 0);
    Op3_RE_out : out std_logic_vector(3 downto 0)
  );
end entity;

architecture etageRE_arch of etageRE is
begin
  Res_RE <= Res_ALU_RE when MemToReg_RE = '0' else Res_Mem_RE;
  Op3_RE_out <= Op3_RE;
end architecture;