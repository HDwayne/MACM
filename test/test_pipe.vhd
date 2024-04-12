library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity dataPath_tb is
end;

architecture bench of dataPath_tb is

  component dataPath
    port(
      clk, init, Gel_LI, Gel_DI, RAZ_DI, Clr_EX: in std_logic;
      EA_EX, EB_EX : in std_logic_vector(1 downto 0);
      instr_DE: out std_logic_vector(31 downto 0);
      a1, a2, rs1, rs2, op3_EX_out, op3_ME_out, op3_RE_out: out std_logic_vector(3 downto 0)
  );      
  end component;

  signal clk, init, Gel_LI, Gel_DI, RAZ_DI, Clr_EX: std_logic;
  signal EA_EX, EB_EX: std_logic_vector(1 downto 0);
  signal instr_DE: std_logic_vector(31 downto 0);
  signal a1, a2, rs1, rs2, op3_EX_out, op3_ME_out, op3_RE_out: std_logic_vector(3 downto 0) ;

begin

  uut: dataPath port map ( clk        => clk,
                           init       => init,
                           Gel_LI     => Gel_LI,
                           Gel_DI     => Gel_DI,
                           RAZ_DI     => RAZ_DI,
                           Clr_EX     => Clr_EX,
                           EA_EX      => EA_EX,
                           EB_EX      => EB_EX,
                           instr_DE   => instr_DE,
                           a1         => a1,
                           a2         => a2,
                           rs1        => rs1,
                           rs2        => rs2,
                           op3_EX_out => op3_EX_out,
                           op3_ME_out => op3_ME_out,
                           op3_RE_out => op3_RE_out );

  stimulus: process
  begin
  
    -- Put initialisation code here


    -- Put test bench stimulus code here

    wait;
  end process;


end;
  