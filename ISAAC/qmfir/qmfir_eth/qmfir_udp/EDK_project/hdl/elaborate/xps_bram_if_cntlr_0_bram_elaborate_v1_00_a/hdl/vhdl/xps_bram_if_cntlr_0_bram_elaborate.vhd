-------------------------------------------------------------------------------
-- xps_bram_if_cntlr_0_bram_elaborate.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity xps_bram_if_cntlr_0_bram_elaborate is
  generic (
    C_MEMSIZE : integer;
    C_PORT_DWIDTH : integer;
    C_PORT_AWIDTH : integer;
    C_NUM_WE : integer;
    C_FAMILY : string
    );
  port (
    BRAM_Rst_A : in std_logic;
    BRAM_Clk_A : in std_logic;
    BRAM_EN_A : in std_logic;
    BRAM_WEN_A : in std_logic_vector(0 to C_NUM_WE-1);
    BRAM_Addr_A : in std_logic_vector(0 to C_PORT_AWIDTH-1);
    BRAM_Din_A : out std_logic_vector(0 to C_PORT_DWIDTH-1);
    BRAM_Dout_A : in std_logic_vector(0 to C_PORT_DWIDTH-1);
    BRAM_Rst_B : in std_logic;
    BRAM_Clk_B : in std_logic;
    BRAM_EN_B : in std_logic;
    BRAM_WEN_B : in std_logic_vector(0 to C_NUM_WE-1);
    BRAM_Addr_B : in std_logic_vector(0 to C_PORT_AWIDTH-1);
    BRAM_Din_B : out std_logic_vector(0 to C_PORT_DWIDTH-1);
    BRAM_Dout_B : in std_logic_vector(0 to C_PORT_DWIDTH-1)
  );

  attribute keep_hierarchy : STRING;
  attribute keep_hierarchy of xps_bram_if_cntlr_0_bram_elaborate : entity is "yes";

end xps_bram_if_cntlr_0_bram_elaborate;

architecture STRUCTURE of xps_bram_if_cntlr_0_bram_elaborate is

  component RAMB36 is
    generic (
      WRITE_MODE_A : string;
      WRITE_MODE_B : string;
      READ_WIDTH_A : integer;
      READ_WIDTH_B : integer;
      WRITE_WIDTH_A : integer;
      WRITE_WIDTH_B : integer;
      RAM_EXTENSION_A : string;
      RAM_EXTENSION_B : string
    );
    port (
      ADDRA : in std_logic_vector(15 downto 0);
      CASCADEINLATA : in std_logic;
      CASCADEINREGA : in std_logic;
      CASCADEOUTLATA : out std_logic;
      CASCADEOUTREGA : out std_logic;
      CLKA : in std_logic;
      DIA : in std_logic_vector(31 downto 0);
      DIPA : in std_logic_vector(3 downto 0);
      DOA : out std_logic_vector(31 downto 0);
      DOPA : out std_logic_vector(3 downto 0);
      ENA : in std_logic;
      REGCEA : in std_logic;
      SSRA : in std_logic;
      WEA : in std_logic_vector(3 downto 0);
      ADDRB : in std_logic_vector(15 downto 0);
      CASCADEINLATB : in std_logic;
      CASCADEINREGB : in std_logic;
      CASCADEOUTLATB : out std_logic;
      CASCADEOUTREGB : out std_logic;
      CLKB : in std_logic;
      DIB : in std_logic_vector(31 downto 0);
      DIPB : in std_logic_vector(3 downto 0);
      DOB : out std_logic_vector(31 downto 0);
      DOPB : out std_logic_vector(3 downto 0);
      ENB : in std_logic;
      REGCEB : in std_logic;
      SSRB : in std_logic;
      WEB : in std_logic_vector(3 downto 0)
    );
  end component;

  -- Internal signals

  signal net_gnd0 : std_logic;
  signal net_gnd4 : std_logic_vector(3 downto 0);
  signal pgassign1 : std_logic_vector(0 to 0);
  signal pgassign2 : std_logic_vector(0 to 2);
  signal pgassign3 : std_logic_vector(0 to 23);
  signal pgassign4 : std_logic_vector(15 downto 0);
  signal pgassign5 : std_logic_vector(31 downto 0);
  signal pgassign6 : std_logic_vector(31 downto 0);
  signal pgassign7 : std_logic_vector(3 downto 0);
  signal pgassign8 : std_logic_vector(15 downto 0);
  signal pgassign9 : std_logic_vector(31 downto 0);
  signal pgassign10 : std_logic_vector(31 downto 0);
  signal pgassign11 : std_logic_vector(3 downto 0);
  signal pgassign12 : std_logic_vector(15 downto 0);
  signal pgassign13 : std_logic_vector(31 downto 0);
  signal pgassign14 : std_logic_vector(31 downto 0);
  signal pgassign15 : std_logic_vector(3 downto 0);
  signal pgassign16 : std_logic_vector(15 downto 0);
  signal pgassign17 : std_logic_vector(31 downto 0);
  signal pgassign18 : std_logic_vector(31 downto 0);
  signal pgassign19 : std_logic_vector(3 downto 0);
  signal pgassign20 : std_logic_vector(15 downto 0);
  signal pgassign21 : std_logic_vector(31 downto 0);
  signal pgassign22 : std_logic_vector(31 downto 0);
  signal pgassign23 : std_logic_vector(3 downto 0);
  signal pgassign24 : std_logic_vector(15 downto 0);
  signal pgassign25 : std_logic_vector(31 downto 0);
  signal pgassign26 : std_logic_vector(31 downto 0);
  signal pgassign27 : std_logic_vector(3 downto 0);
  signal pgassign28 : std_logic_vector(15 downto 0);
  signal pgassign29 : std_logic_vector(31 downto 0);
  signal pgassign30 : std_logic_vector(31 downto 0);
  signal pgassign31 : std_logic_vector(3 downto 0);
  signal pgassign32 : std_logic_vector(15 downto 0);
  signal pgassign33 : std_logic_vector(31 downto 0);
  signal pgassign34 : std_logic_vector(31 downto 0);
  signal pgassign35 : std_logic_vector(3 downto 0);
  signal pgassign36 : std_logic_vector(15 downto 0);
  signal pgassign37 : std_logic_vector(31 downto 0);
  signal pgassign38 : std_logic_vector(31 downto 0);
  signal pgassign39 : std_logic_vector(3 downto 0);
  signal pgassign40 : std_logic_vector(15 downto 0);
  signal pgassign41 : std_logic_vector(31 downto 0);
  signal pgassign42 : std_logic_vector(31 downto 0);
  signal pgassign43 : std_logic_vector(3 downto 0);
  signal pgassign44 : std_logic_vector(15 downto 0);
  signal pgassign45 : std_logic_vector(31 downto 0);
  signal pgassign46 : std_logic_vector(31 downto 0);
  signal pgassign47 : std_logic_vector(3 downto 0);
  signal pgassign48 : std_logic_vector(15 downto 0);
  signal pgassign49 : std_logic_vector(31 downto 0);
  signal pgassign50 : std_logic_vector(31 downto 0);
  signal pgassign51 : std_logic_vector(3 downto 0);
  signal pgassign52 : std_logic_vector(15 downto 0);
  signal pgassign53 : std_logic_vector(31 downto 0);
  signal pgassign54 : std_logic_vector(31 downto 0);
  signal pgassign55 : std_logic_vector(3 downto 0);
  signal pgassign56 : std_logic_vector(15 downto 0);
  signal pgassign57 : std_logic_vector(31 downto 0);
  signal pgassign58 : std_logic_vector(31 downto 0);
  signal pgassign59 : std_logic_vector(3 downto 0);
  signal pgassign60 : std_logic_vector(15 downto 0);
  signal pgassign61 : std_logic_vector(31 downto 0);
  signal pgassign62 : std_logic_vector(31 downto 0);
  signal pgassign63 : std_logic_vector(3 downto 0);
  signal pgassign64 : std_logic_vector(15 downto 0);
  signal pgassign65 : std_logic_vector(31 downto 0);
  signal pgassign66 : std_logic_vector(31 downto 0);
  signal pgassign67 : std_logic_vector(3 downto 0);

begin

  -- Internal assignments

  pgassign1(0 to 0) <= B"1";
  pgassign2(0 to 2) <= B"000";
  pgassign3(0 to 23) <= B"000000000000000000000000";
  pgassign4(15 downto 15) <= B"1";
  pgassign4(14 downto 3) <= BRAM_Addr_A(17 to 28);
  pgassign4(2 downto 0) <= B"000";
  pgassign5(31 downto 8) <= B"000000000000000000000000";
  pgassign5(7 downto 0) <= BRAM_Dout_A(0 to 7);
  BRAM_Din_A(0 to 7) <= pgassign6(7 downto 0);
  pgassign7(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign7(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign7(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign7(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign8(15 downto 15) <= B"1";
  pgassign8(14 downto 3) <= BRAM_Addr_B(17 to 28);
  pgassign8(2 downto 0) <= B"000";
  pgassign9(31 downto 8) <= B"000000000000000000000000";
  pgassign9(7 downto 0) <= BRAM_Dout_B(0 to 7);
  BRAM_Din_B(0 to 7) <= pgassign10(7 downto 0);
  pgassign11(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign11(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign11(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign11(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign12(15 downto 15) <= B"1";
  pgassign12(14 downto 3) <= BRAM_Addr_A(17 to 28);
  pgassign12(2 downto 0) <= B"000";
  pgassign13(31 downto 8) <= B"000000000000000000000000";
  pgassign13(7 downto 0) <= BRAM_Dout_A(8 to 15);
  BRAM_Din_A(8 to 15) <= pgassign14(7 downto 0);
  pgassign15(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign15(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign15(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign15(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign16(15 downto 15) <= B"1";
  pgassign16(14 downto 3) <= BRAM_Addr_B(17 to 28);
  pgassign16(2 downto 0) <= B"000";
  pgassign17(31 downto 8) <= B"000000000000000000000000";
  pgassign17(7 downto 0) <= BRAM_Dout_B(8 to 15);
  BRAM_Din_B(8 to 15) <= pgassign18(7 downto 0);
  pgassign19(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign19(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign19(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign19(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign20(15 downto 15) <= B"1";
  pgassign20(14 downto 3) <= BRAM_Addr_A(17 to 28);
  pgassign20(2 downto 0) <= B"000";
  pgassign21(31 downto 8) <= B"000000000000000000000000";
  pgassign21(7 downto 0) <= BRAM_Dout_A(16 to 23);
  BRAM_Din_A(16 to 23) <= pgassign22(7 downto 0);
  pgassign23(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign23(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign23(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign23(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign24(15 downto 15) <= B"1";
  pgassign24(14 downto 3) <= BRAM_Addr_B(17 to 28);
  pgassign24(2 downto 0) <= B"000";
  pgassign25(31 downto 8) <= B"000000000000000000000000";
  pgassign25(7 downto 0) <= BRAM_Dout_B(16 to 23);
  BRAM_Din_B(16 to 23) <= pgassign26(7 downto 0);
  pgassign27(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign27(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign27(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign27(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign28(15 downto 15) <= B"1";
  pgassign28(14 downto 3) <= BRAM_Addr_A(17 to 28);
  pgassign28(2 downto 0) <= B"000";
  pgassign29(31 downto 8) <= B"000000000000000000000000";
  pgassign29(7 downto 0) <= BRAM_Dout_A(24 to 31);
  BRAM_Din_A(24 to 31) <= pgassign30(7 downto 0);
  pgassign31(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign31(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign31(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign31(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign32(15 downto 15) <= B"1";
  pgassign32(14 downto 3) <= BRAM_Addr_B(17 to 28);
  pgassign32(2 downto 0) <= B"000";
  pgassign33(31 downto 8) <= B"000000000000000000000000";
  pgassign33(7 downto 0) <= BRAM_Dout_B(24 to 31);
  BRAM_Din_B(24 to 31) <= pgassign34(7 downto 0);
  pgassign35(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign35(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign35(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign35(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign36(15 downto 15) <= B"1";
  pgassign36(14 downto 3) <= BRAM_Addr_A(17 to 28);
  pgassign36(2 downto 0) <= B"000";
  pgassign37(31 downto 8) <= B"000000000000000000000000";
  pgassign37(7 downto 0) <= BRAM_Dout_A(32 to 39);
  BRAM_Din_A(32 to 39) <= pgassign38(7 downto 0);
  pgassign39(3 downto 3) <= BRAM_WEN_A(4 to 4);
  pgassign39(2 downto 2) <= BRAM_WEN_A(4 to 4);
  pgassign39(1 downto 1) <= BRAM_WEN_A(4 to 4);
  pgassign39(0 downto 0) <= BRAM_WEN_A(4 to 4);
  pgassign40(15 downto 15) <= B"1";
  pgassign40(14 downto 3) <= BRAM_Addr_B(17 to 28);
  pgassign40(2 downto 0) <= B"000";
  pgassign41(31 downto 8) <= B"000000000000000000000000";
  pgassign41(7 downto 0) <= BRAM_Dout_B(32 to 39);
  BRAM_Din_B(32 to 39) <= pgassign42(7 downto 0);
  pgassign43(3 downto 3) <= BRAM_WEN_B(4 to 4);
  pgassign43(2 downto 2) <= BRAM_WEN_B(4 to 4);
  pgassign43(1 downto 1) <= BRAM_WEN_B(4 to 4);
  pgassign43(0 downto 0) <= BRAM_WEN_B(4 to 4);
  pgassign44(15 downto 15) <= B"1";
  pgassign44(14 downto 3) <= BRAM_Addr_A(17 to 28);
  pgassign44(2 downto 0) <= B"000";
  pgassign45(31 downto 8) <= B"000000000000000000000000";
  pgassign45(7 downto 0) <= BRAM_Dout_A(40 to 47);
  BRAM_Din_A(40 to 47) <= pgassign46(7 downto 0);
  pgassign47(3 downto 3) <= BRAM_WEN_A(5 to 5);
  pgassign47(2 downto 2) <= BRAM_WEN_A(5 to 5);
  pgassign47(1 downto 1) <= BRAM_WEN_A(5 to 5);
  pgassign47(0 downto 0) <= BRAM_WEN_A(5 to 5);
  pgassign48(15 downto 15) <= B"1";
  pgassign48(14 downto 3) <= BRAM_Addr_B(17 to 28);
  pgassign48(2 downto 0) <= B"000";
  pgassign49(31 downto 8) <= B"000000000000000000000000";
  pgassign49(7 downto 0) <= BRAM_Dout_B(40 to 47);
  BRAM_Din_B(40 to 47) <= pgassign50(7 downto 0);
  pgassign51(3 downto 3) <= BRAM_WEN_B(5 to 5);
  pgassign51(2 downto 2) <= BRAM_WEN_B(5 to 5);
  pgassign51(1 downto 1) <= BRAM_WEN_B(5 to 5);
  pgassign51(0 downto 0) <= BRAM_WEN_B(5 to 5);
  pgassign52(15 downto 15) <= B"1";
  pgassign52(14 downto 3) <= BRAM_Addr_A(17 to 28);
  pgassign52(2 downto 0) <= B"000";
  pgassign53(31 downto 8) <= B"000000000000000000000000";
  pgassign53(7 downto 0) <= BRAM_Dout_A(48 to 55);
  BRAM_Din_A(48 to 55) <= pgassign54(7 downto 0);
  pgassign55(3 downto 3) <= BRAM_WEN_A(6 to 6);
  pgassign55(2 downto 2) <= BRAM_WEN_A(6 to 6);
  pgassign55(1 downto 1) <= BRAM_WEN_A(6 to 6);
  pgassign55(0 downto 0) <= BRAM_WEN_A(6 to 6);
  pgassign56(15 downto 15) <= B"1";
  pgassign56(14 downto 3) <= BRAM_Addr_B(17 to 28);
  pgassign56(2 downto 0) <= B"000";
  pgassign57(31 downto 8) <= B"000000000000000000000000";
  pgassign57(7 downto 0) <= BRAM_Dout_B(48 to 55);
  BRAM_Din_B(48 to 55) <= pgassign58(7 downto 0);
  pgassign59(3 downto 3) <= BRAM_WEN_B(6 to 6);
  pgassign59(2 downto 2) <= BRAM_WEN_B(6 to 6);
  pgassign59(1 downto 1) <= BRAM_WEN_B(6 to 6);
  pgassign59(0 downto 0) <= BRAM_WEN_B(6 to 6);
  pgassign60(15 downto 15) <= B"1";
  pgassign60(14 downto 3) <= BRAM_Addr_A(17 to 28);
  pgassign60(2 downto 0) <= B"000";
  pgassign61(31 downto 8) <= B"000000000000000000000000";
  pgassign61(7 downto 0) <= BRAM_Dout_A(56 to 63);
  BRAM_Din_A(56 to 63) <= pgassign62(7 downto 0);
  pgassign63(3 downto 3) <= BRAM_WEN_A(7 to 7);
  pgassign63(2 downto 2) <= BRAM_WEN_A(7 to 7);
  pgassign63(1 downto 1) <= BRAM_WEN_A(7 to 7);
  pgassign63(0 downto 0) <= BRAM_WEN_A(7 to 7);
  pgassign64(15 downto 15) <= B"1";
  pgassign64(14 downto 3) <= BRAM_Addr_B(17 to 28);
  pgassign64(2 downto 0) <= B"000";
  pgassign65(31 downto 8) <= B"000000000000000000000000";
  pgassign65(7 downto 0) <= BRAM_Dout_B(56 to 63);
  BRAM_Din_B(56 to 63) <= pgassign66(7 downto 0);
  pgassign67(3 downto 3) <= BRAM_WEN_B(7 to 7);
  pgassign67(2 downto 2) <= BRAM_WEN_B(7 to 7);
  pgassign67(1 downto 1) <= BRAM_WEN_B(7 to 7);
  pgassign67(0 downto 0) <= BRAM_WEN_B(7 to 7);
  net_gnd0 <= '0';
  net_gnd4(3 downto 0) <= B"0000";

  ramb36_0 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      READ_WIDTH_A => 9,
      READ_WIDTH_B => 9,
      WRITE_WIDTH_A => 9,
      WRITE_WIDTH_B => 9,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      ADDRA => pgassign4,
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign5,
      DIPA => net_gnd4,
      DOA => pgassign6,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign7,
      ADDRB => pgassign8,
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign9,
      DIPB => net_gnd4,
      DOB => pgassign10,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign11
    );

  ramb36_1 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      READ_WIDTH_A => 9,
      READ_WIDTH_B => 9,
      WRITE_WIDTH_A => 9,
      WRITE_WIDTH_B => 9,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      ADDRA => pgassign12,
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign13,
      DIPA => net_gnd4,
      DOA => pgassign14,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign15,
      ADDRB => pgassign16,
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign17,
      DIPB => net_gnd4,
      DOB => pgassign18,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign19
    );

  ramb36_2 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      READ_WIDTH_A => 9,
      READ_WIDTH_B => 9,
      WRITE_WIDTH_A => 9,
      WRITE_WIDTH_B => 9,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      ADDRA => pgassign20,
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign21,
      DIPA => net_gnd4,
      DOA => pgassign22,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign23,
      ADDRB => pgassign24,
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign25,
      DIPB => net_gnd4,
      DOB => pgassign26,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign27
    );

  ramb36_3 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      READ_WIDTH_A => 9,
      READ_WIDTH_B => 9,
      WRITE_WIDTH_A => 9,
      WRITE_WIDTH_B => 9,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      ADDRA => pgassign28,
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign29,
      DIPA => net_gnd4,
      DOA => pgassign30,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign31,
      ADDRB => pgassign32,
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign33,
      DIPB => net_gnd4,
      DOB => pgassign34,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign35
    );

  ramb36_4 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      READ_WIDTH_A => 9,
      READ_WIDTH_B => 9,
      WRITE_WIDTH_A => 9,
      WRITE_WIDTH_B => 9,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      ADDRA => pgassign36,
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign37,
      DIPA => net_gnd4,
      DOA => pgassign38,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign39,
      ADDRB => pgassign40,
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign41,
      DIPB => net_gnd4,
      DOB => pgassign42,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign43
    );

  ramb36_5 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      READ_WIDTH_A => 9,
      READ_WIDTH_B => 9,
      WRITE_WIDTH_A => 9,
      WRITE_WIDTH_B => 9,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      ADDRA => pgassign44,
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign45,
      DIPA => net_gnd4,
      DOA => pgassign46,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign47,
      ADDRB => pgassign48,
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign49,
      DIPB => net_gnd4,
      DOB => pgassign50,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign51
    );

  ramb36_6 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      READ_WIDTH_A => 9,
      READ_WIDTH_B => 9,
      WRITE_WIDTH_A => 9,
      WRITE_WIDTH_B => 9,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      ADDRA => pgassign52,
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign53,
      DIPA => net_gnd4,
      DOA => pgassign54,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign55,
      ADDRB => pgassign56,
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign57,
      DIPB => net_gnd4,
      DOB => pgassign58,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign59
    );

  ramb36_7 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      READ_WIDTH_A => 9,
      READ_WIDTH_B => 9,
      WRITE_WIDTH_A => 9,
      WRITE_WIDTH_B => 9,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      ADDRA => pgassign60,
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign61,
      DIPA => net_gnd4,
      DOA => pgassign62,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign63,
      ADDRB => pgassign64,
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign65,
      DIPB => net_gnd4,
      DOB => pgassign66,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign67
    );

end architecture STRUCTURE;

