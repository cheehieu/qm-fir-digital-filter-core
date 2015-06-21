-------------------------------------------------------------------------------
-- system.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity system is
  port (
    fpga_0_RS232_0_RX_pin : in std_logic;
    fpga_0_RS232_0_TX_pin : out std_logic;
    fpga_0_Hard_Ethernet_MAC_TemacPhy_RST_n_pin : out std_logic;
    fpga_0_Hard_Ethernet_MAC_MII_TXD_0_pin : out std_logic_vector(3 downto 0);
    fpga_0_Hard_Ethernet_MAC_MII_TX_EN_0_pin : out std_logic;
    fpga_0_Hard_Ethernet_MAC_MII_TX_ER_0_pin : out std_logic;
    fpga_0_Hard_Ethernet_MAC_MII_RXD_0_pin : in std_logic_vector(3 downto 0);
    fpga_0_Hard_Ethernet_MAC_MII_RX_DV_0_pin : in std_logic;
    fpga_0_Hard_Ethernet_MAC_MII_RX_ER_0_pin : in std_logic;
    fpga_0_Hard_Ethernet_MAC_MII_RX_CLK_0_pin : in std_logic;
    fpga_0_Hard_Ethernet_MAC_MII_TX_CLK_0_pin : in std_logic;
    fpga_0_Hard_Ethernet_MAC_MDC_0_pin : out std_logic;
    fpga_0_Hard_Ethernet_MAC_MDIO_0_pin : inout std_logic;
    fpga_0_Hard_Ethernet_MAC_PHY_INTR_pin : in std_logic;
    fpga_0_DDR_SDRAM_0_DDR_Clk_pin : out std_logic;
    fpga_0_DDR_SDRAM_0_DDR_Clk_n_pin : out std_logic;
    fpga_0_DDR_SDRAM_0_DDR_Addr_pin : out std_logic_vector(13 downto 0);
    fpga_0_DDR_SDRAM_0_DDR_BankAddr_pin : out std_logic_vector(1 downto 0);
    fpga_0_DDR_SDRAM_0_DDR_CAS_n_pin : out std_logic;
    fpga_0_DDR_SDRAM_0_DDR_CE_pin : out std_logic;
    fpga_0_DDR_SDRAM_0_DDR_CS_n_pin : out std_logic_vector(1 downto 0);
    fpga_0_DDR_SDRAM_0_DDR_RAS_n_pin : out std_logic;
    fpga_0_DDR_SDRAM_0_DDR_WE_n_pin : out std_logic;
    fpga_0_DDR_SDRAM_0_DDR_DM_pin : out std_logic_vector(4 downto 0);
    fpga_0_DDR_SDRAM_0_DDR_DQS_pin : inout std_logic_vector(4 downto 0);
    fpga_0_DDR_SDRAM_0_DDR_DQ_pin : inout std_logic_vector(39 downto 0);
    fpga_0_DDR_SDRAM_0_CLK_RESET_n_pin : out std_logic;
    fpga_0_sys_clk_pin : in std_logic;
    fpga_0_sys_rst_pin : in std_logic
  );
end system;

architecture STRUCTURE of system is

  component xps_timer_0_wrapper is
    port (
      CaptureTrig0 : in std_logic;
      CaptureTrig1 : in std_logic;
      GenerateOut0 : out std_logic;
      GenerateOut1 : out std_logic;
      PWM0 : out std_logic;
      Interrupt : out std_logic;
      Freeze : in std_logic;
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 15);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_wrDBus : in std_logic_vector(0 to 127);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 127);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 0);
      Sl_MWrErr : out std_logic_vector(0 to 0);
      Sl_MRdErr : out std_logic_vector(0 to 0);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_lockErr : in std_logic;
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_wrBTerm : out std_logic;
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdBTerm : out std_logic;
      Sl_MIRQ : out std_logic_vector(0 to 0)
    );
  end component;

  component xps_sysmon_adc_0_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 15);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_wrDBus : in std_logic_vector(0 to 127);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 127);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 0);
      Sl_MWrErr : out std_logic_vector(0 to 0);
      Sl_MRdErr : out std_logic_vector(0 to 0);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_lockErr : in std_logic;
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_wrBTerm : out std_logic;
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdBTerm : out std_logic;
      Sl_MIRQ : out std_logic_vector(0 to 0);
      IP2INTC_Irpt : out std_logic;
      VAUXP : in std_logic_vector(15 downto 0);
      VAUXN : in std_logic_vector(15 downto 0);
      CONVST : in std_logic;
      ALARM : out std_logic_vector(2 downto 0)
    );
  end component;

  component xps_intc_0_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 15);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_wrDBus : in std_logic_vector(0 to 127);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_lockErr : in std_logic;
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 127);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 0);
      Sl_MWrErr : out std_logic_vector(0 to 0);
      Sl_MRdErr : out std_logic_vector(0 to 0);
      Sl_wrBTerm : out std_logic;
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdBTerm : out std_logic;
      Sl_MIRQ : out std_logic_vector(0 to 0);
      Intr : in std_logic_vector(6 downto 0);
      Irq : out std_logic
    );
  end component;

  component xps_bram_if_cntlr_0_bram_wrapper is
    port (
      BRAM_Rst_A : in std_logic;
      BRAM_Clk_A : in std_logic;
      BRAM_EN_A : in std_logic;
      BRAM_WEN_A : in std_logic_vector(0 to 7);
      BRAM_Addr_A : in std_logic_vector(0 to 31);
      BRAM_Din_A : out std_logic_vector(0 to 63);
      BRAM_Dout_A : in std_logic_vector(0 to 63);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 7);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 63);
      BRAM_Dout_B : in std_logic_vector(0 to 63)
    );
  end component;

  component xps_bram_if_cntlr_0_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 15);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 127);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 127);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 0);
      Sl_MWrErr : out std_logic_vector(0 to 0);
      Sl_MRdErr : out std_logic_vector(0 to 0);
      Sl_MIRQ : out std_logic_vector(0 to 0);
      BRAM_Rst : out std_logic;
      BRAM_Clk : out std_logic;
      BRAM_EN : out std_logic;
      BRAM_WEN : out std_logic_vector(0 to 7);
      BRAM_Addr : out std_logic_vector(0 to 31);
      BRAM_Din : in std_logic_vector(0 to 63);
      BRAM_Dout : out std_logic_vector(0 to 63)
    );
  end component;

  component proc_sys_reset_0_wrapper is
    port (
      Slowest_sync_clk : in std_logic;
      Ext_Reset_In : in std_logic;
      Aux_Reset_In : in std_logic;
      MB_Debug_Sys_Rst : in std_logic;
      Core_Reset_Req_0 : in std_logic;
      Chip_Reset_Req_0 : in std_logic;
      System_Reset_Req_0 : in std_logic;
      Core_Reset_Req_1 : in std_logic;
      Chip_Reset_Req_1 : in std_logic;
      System_Reset_Req_1 : in std_logic;
      Dcm_locked : in std_logic;
      RstcPPCresetcore_0 : out std_logic;
      RstcPPCresetchip_0 : out std_logic;
      RstcPPCresetsys_0 : out std_logic;
      RstcPPCresetcore_1 : out std_logic;
      RstcPPCresetchip_1 : out std_logic;
      RstcPPCresetsys_1 : out std_logic;
      MB_Reset : out std_logic;
      Bus_Struct_Reset : out std_logic_vector(0 to 0);
      Peripheral_Reset : out std_logic_vector(0 to 0)
    );
  end component;

  component ppc440_0_wrapper is
    port (
      CPMC440CLK : in std_logic;
      CPMC440CLKEN : in std_logic;
      CPMINTERCONNECTCLK : in std_logic;
      CPMINTERCONNECTCLKEN : in std_logic;
      CPMINTERCONNECTCLKNTO1 : in std_logic;
      CPMC440CORECLOCKINACTIVE : in std_logic;
      CPMC440TIMERCLOCK : in std_logic;
      C440MACHINECHECK : out std_logic;
      C440CPMCORESLEEPREQ : out std_logic;
      C440CPMDECIRPTREQ : out std_logic;
      C440CPMFITIRPTREQ : out std_logic;
      C440CPMMSRCE : out std_logic;
      C440CPMMSREE : out std_logic;
      C440CPMTIMERRESETREQ : out std_logic;
      C440CPMWDIRPTREQ : out std_logic;
      PPCCPMINTERCONNECTBUSY : out std_logic;
      DBGC440DEBUGHALT : in std_logic;
      DBGC440DEBUGHALTNEG : in std_logic;
      DBGC440SYSTEMSTATUS : in std_logic_vector(0 to 4);
      DBGC440UNCONDDEBUGEVENT : in std_logic;
      C440DBGSYSTEMCONTROL : out std_logic_vector(0 to 7);
      SPLB0_Error : out std_logic_vector(0 to 3);
      SPLB1_Error : out std_logic_vector(0 to 3);
      EICC440CRITIRQ : in std_logic;
      EICC440EXTIRQ : in std_logic;
      PPCEICINTERCONNECTIRQ : out std_logic;
      CPMDCRCLK : in std_logic;
      DCRPPCDMACK : in std_logic;
      DCRPPCDMDBUSIN : in std_logic_vector(0 to 31);
      DCRPPCDMTIMEOUTWAIT : in std_logic;
      PPCDMDCRREAD : out std_logic;
      PPCDMDCRWRITE : out std_logic;
      PPCDMDCRABUS : out std_logic_vector(0 to 9);
      PPCDMDCRDBUSOUT : out std_logic_vector(0 to 31);
      DCRPPCDSREAD : in std_logic;
      DCRPPCDSWRITE : in std_logic;
      DCRPPCDSABUS : in std_logic_vector(0 to 9);
      DCRPPCDSDBUSOUT : in std_logic_vector(0 to 31);
      PPCDSDCRACK : out std_logic;
      PPCDSDCRDBUSIN : out std_logic_vector(0 to 31);
      PPCDSDCRTIMEOUTWAIT : out std_logic;
      CPMFCMCLK : in std_logic;
      FCMAPUCR : in std_logic_vector(0 to 3);
      FCMAPUDONE : in std_logic;
      FCMAPUEXCEPTION : in std_logic;
      FCMAPUFPSCRFEX : in std_logic;
      FCMAPURESULT : in std_logic_vector(0 to 31);
      FCMAPURESULTVALID : in std_logic;
      FCMAPUSLEEPNOTREADY : in std_logic;
      FCMAPUCONFIRMINSTR : in std_logic;
      FCMAPUSTOREDATA : in std_logic_vector(0 to 127);
      APUFCMDECNONAUTON : out std_logic;
      APUFCMDECFPUOP : out std_logic;
      APUFCMDECLDSTXFERSIZE : out std_logic_vector(0 to 2);
      APUFCMDECLOAD : out std_logic;
      APUFCMNEXTINSTRREADY : out std_logic;
      APUFCMDECSTORE : out std_logic;
      APUFCMDECUDI : out std_logic_vector(0 to 3);
      APUFCMDECUDIVALID : out std_logic;
      APUFCMENDIAN : out std_logic;
      APUFCMFLUSH : out std_logic;
      APUFCMINSTRUCTION : out std_logic_vector(0 to 31);
      APUFCMINSTRVALID : out std_logic;
      APUFCMLOADBYTEADDR : out std_logic_vector(0 to 3);
      APUFCMLOADDATA : out std_logic_vector(0 to 127);
      APUFCMLOADDVALID : out std_logic;
      APUFCMOPERANDVALID : out std_logic;
      APUFCMRADATA : out std_logic_vector(0 to 31);
      APUFCMRBDATA : out std_logic_vector(0 to 31);
      APUFCMWRITEBACKOK : out std_logic;
      APUFCMMSRFE0 : out std_logic;
      APUFCMMSRFE1 : out std_logic;
      JTGC440TCK : in std_logic;
      JTGC440TDI : in std_logic;
      JTGC440TMS : in std_logic;
      JTGC440TRSTNEG : in std_logic;
      C440JTGTDO : out std_logic;
      C440JTGTDOEN : out std_logic;
      CPMMCCLK : in std_logic;
      MCMIREADDATA : in std_logic_vector(0 to 127);
      MCMIREADDATAVALID : in std_logic;
      MCMIREADDATAERR : in std_logic;
      MCMIADDRREADYTOACCEPT : in std_logic;
      MIMCREADNOTWRITE : out std_logic;
      MIMCADDRESS : out std_logic_vector(0 to 35);
      MIMCADDRESSVALID : out std_logic;
      MIMCWRITEDATA : out std_logic_vector(0 to 127);
      MIMCWRITEDATAVALID : out std_logic;
      MIMCBYTEENABLE : out std_logic_vector(0 to 15);
      MIMCBANKCONFLICT : out std_logic;
      MIMCROWCONFLICT : out std_logic;
      CPMPPCMPLBCLK : in std_logic;
      PLBPPCMMBUSY : in std_logic;
      PLBPPCMMIRQ : in std_logic;
      PLBPPCMMRDERR : in std_logic;
      PLBPPCMMWRERR : in std_logic;
      PLBPPCMADDRACK : in std_logic;
      PLBPPCMRDBTERM : in std_logic;
      PLBPPCMRDDACK : in std_logic;
      PLBPPCMRDDBUS : in std_logic_vector(0 to 127);
      PLBPPCMRDWDADDR : in std_logic_vector(0 to 3);
      PLBPPCMREARBITRATE : in std_logic;
      PLBPPCMSSIZE : in std_logic_vector(0 to 1);
      PLBPPCMTIMEOUT : in std_logic;
      PLBPPCMWRBTERM : in std_logic;
      PLBPPCMWRDACK : in std_logic;
      PLBPPCMRDPENDPRI : in std_logic_vector(0 to 1);
      PLBPPCMRDPENDREQ : in std_logic;
      PLBPPCMREQPRI : in std_logic_vector(0 to 1);
      PLBPPCMWRPENDPRI : in std_logic_vector(0 to 1);
      PLBPPCMWRPENDREQ : in std_logic;
      PPCMPLBABORT : out std_logic;
      PPCMPLBABUS : out std_logic_vector(0 to 31);
      PPCMPLBBE : out std_logic_vector(0 to 15);
      PPCMPLBBUSLOCK : out std_logic;
      PPCMPLBLOCKERR : out std_logic;
      PPCMPLBMSIZE : out std_logic_vector(0 to 1);
      PPCMPLBPRIORITY : out std_logic_vector(0 to 1);
      PPCMPLBRDBURST : out std_logic;
      PPCMPLBREQUEST : out std_logic;
      PPCMPLBRNW : out std_logic;
      PPCMPLBSIZE : out std_logic_vector(0 to 3);
      PPCMPLBTATTRIBUTE : out std_logic_vector(0 to 15);
      PPCMPLBTYPE : out std_logic_vector(0 to 2);
      PPCMPLBUABUS : out std_logic_vector(0 to 31);
      PPCMPLBWRBURST : out std_logic;
      PPCMPLBWRDBUS : out std_logic_vector(0 to 127);
      CPMPPCS0PLBCLK : in std_logic;
      PLBPPCS0MASTERID : in std_logic_vector(0 to 0);
      PLBPPCS0PAVALID : in std_logic;
      PLBPPCS0SAVALID : in std_logic;
      PLBPPCS0RDPENDREQ : in std_logic;
      PLBPPCS0WRPENDREQ : in std_logic;
      PLBPPCS0RDPENDPRI : in std_logic_vector(0 to 1);
      PLBPPCS0WRPENDPRI : in std_logic_vector(0 to 1);
      PLBPPCS0REQPRI : in std_logic_vector(0 to 1);
      PLBPPCS0RDPRIM : in std_logic;
      PLBPPCS0WRPRIM : in std_logic;
      PLBPPCS0BUSLOCK : in std_logic;
      PLBPPCS0ABORT : in std_logic;
      PLBPPCS0RNW : in std_logic;
      PLBPPCS0BE : in std_logic_vector(0 to 15);
      PLBPPCS0SIZE : in std_logic_vector(0 to 3);
      PLBPPCS0TYPE : in std_logic_vector(0 to 2);
      PLBPPCS0TATTRIBUTE : in std_logic_vector(0 to 15);
      PLBPPCS0LOCKERR : in std_logic;
      PLBPPCS0MSIZE : in std_logic_vector(0 to 1);
      PLBPPCS0UABUS : in std_logic_vector(0 to 31);
      PLBPPCS0ABUS : in std_logic_vector(0 to 31);
      PLBPPCS0WRDBUS : in std_logic_vector(0 to 127);
      PLBPPCS0WRBURST : in std_logic;
      PLBPPCS0RDBURST : in std_logic;
      PPCS0PLBADDRACK : out std_logic;
      PPCS0PLBWAIT : out std_logic;
      PPCS0PLBREARBITRATE : out std_logic;
      PPCS0PLBWRDACK : out std_logic;
      PPCS0PLBWRCOMP : out std_logic;
      PPCS0PLBRDDBUS : out std_logic_vector(0 to 127);
      PPCS0PLBRDWDADDR : out std_logic_vector(0 to 3);
      PPCS0PLBRDDACK : out std_logic;
      PPCS0PLBRDCOMP : out std_logic;
      PPCS0PLBRDBTERM : out std_logic;
      PPCS0PLBWRBTERM : out std_logic;
      PPCS0PLBMBUSY : out std_logic_vector(0 to 0);
      PPCS0PLBMRDERR : out std_logic_vector(0 to 0);
      PPCS0PLBMWRERR : out std_logic_vector(0 to 0);
      PPCS0PLBMIRQ : out std_logic_vector(0 to 0);
      PPCS0PLBSSIZE : out std_logic_vector(0 to 1);
      CPMPPCS1PLBCLK : in std_logic;
      PLBPPCS1MASTERID : in std_logic_vector(0 to 0);
      PLBPPCS1PAVALID : in std_logic;
      PLBPPCS1SAVALID : in std_logic;
      PLBPPCS1RDPENDREQ : in std_logic;
      PLBPPCS1WRPENDREQ : in std_logic;
      PLBPPCS1RDPENDPRI : in std_logic_vector(0 to 1);
      PLBPPCS1WRPENDPRI : in std_logic_vector(0 to 1);
      PLBPPCS1REQPRI : in std_logic_vector(0 to 1);
      PLBPPCS1RDPRIM : in std_logic;
      PLBPPCS1WRPRIM : in std_logic;
      PLBPPCS1BUSLOCK : in std_logic;
      PLBPPCS1ABORT : in std_logic;
      PLBPPCS1RNW : in std_logic;
      PLBPPCS1BE : in std_logic_vector(0 to 15);
      PLBPPCS1SIZE : in std_logic_vector(0 to 3);
      PLBPPCS1TYPE : in std_logic_vector(0 to 2);
      PLBPPCS1TATTRIBUTE : in std_logic_vector(0 to 15);
      PLBPPCS1LOCKERR : in std_logic;
      PLBPPCS1MSIZE : in std_logic_vector(0 to 1);
      PLBPPCS1UABUS : in std_logic_vector(0 to 31);
      PLBPPCS1ABUS : in std_logic_vector(0 to 31);
      PLBPPCS1WRDBUS : in std_logic_vector(0 to 127);
      PLBPPCS1WRBURST : in std_logic;
      PLBPPCS1RDBURST : in std_logic;
      PPCS1PLBADDRACK : out std_logic;
      PPCS1PLBWAIT : out std_logic;
      PPCS1PLBREARBITRATE : out std_logic;
      PPCS1PLBWRDACK : out std_logic;
      PPCS1PLBWRCOMP : out std_logic;
      PPCS1PLBRDDBUS : out std_logic_vector(0 to 127);
      PPCS1PLBRDWDADDR : out std_logic_vector(0 to 3);
      PPCS1PLBRDDACK : out std_logic;
      PPCS1PLBRDCOMP : out std_logic;
      PPCS1PLBRDBTERM : out std_logic;
      PPCS1PLBWRBTERM : out std_logic;
      PPCS1PLBMBUSY : out std_logic_vector(0 to 0);
      PPCS1PLBMRDERR : out std_logic_vector(0 to 0);
      PPCS1PLBMWRERR : out std_logic_vector(0 to 0);
      PPCS1PLBMIRQ : out std_logic_vector(0 to 0);
      PPCS1PLBSSIZE : out std_logic_vector(0 to 1);
      CPMDMA0LLCLK : in std_logic;
      LLDMA0TXDSTRDYN : in std_logic;
      LLDMA0RXD : in std_logic_vector(0 to 31);
      LLDMA0RXREM : in std_logic_vector(0 to 3);
      LLDMA0RXSOFN : in std_logic;
      LLDMA0RXEOFN : in std_logic;
      LLDMA0RXSOPN : in std_logic;
      LLDMA0RXEOPN : in std_logic;
      LLDMA0RXSRCRDYN : in std_logic;
      LLDMA0RSTENGINEREQ : in std_logic;
      DMA0LLTXD : out std_logic_vector(0 to 31);
      DMA0LLTXREM : out std_logic_vector(0 to 3);
      DMA0LLTXSOFN : out std_logic;
      DMA0LLTXEOFN : out std_logic;
      DMA0LLTXSOPN : out std_logic;
      DMA0LLTXEOPN : out std_logic;
      DMA0LLTXSRCRDYN : out std_logic;
      DMA0LLRXDSTRDYN : out std_logic;
      DMA0LLRSTENGINEACK : out std_logic;
      DMA0TXIRQ : out std_logic;
      DMA0RXIRQ : out std_logic;
      CPMDMA1LLCLK : in std_logic;
      LLDMA1TXDSTRDYN : in std_logic;
      LLDMA1RXD : in std_logic_vector(0 to 31);
      LLDMA1RXREM : in std_logic_vector(0 to 3);
      LLDMA1RXSOFN : in std_logic;
      LLDMA1RXEOFN : in std_logic;
      LLDMA1RXSOPN : in std_logic;
      LLDMA1RXEOPN : in std_logic;
      LLDMA1RXSRCRDYN : in std_logic;
      LLDMA1RSTENGINEREQ : in std_logic;
      DMA1LLTXD : out std_logic_vector(0 to 31);
      DMA1LLTXREM : out std_logic_vector(0 to 3);
      DMA1LLTXSOFN : out std_logic;
      DMA1LLTXEOFN : out std_logic;
      DMA1LLTXSOPN : out std_logic;
      DMA1LLTXEOPN : out std_logic;
      DMA1LLTXSRCRDYN : out std_logic;
      DMA1LLRXDSTRDYN : out std_logic;
      DMA1LLRSTENGINEACK : out std_logic;
      DMA1TXIRQ : out std_logic;
      DMA1RXIRQ : out std_logic;
      CPMDMA2LLCLK : in std_logic;
      LLDMA2TXDSTRDYN : in std_logic;
      LLDMA2RXD : in std_logic_vector(0 to 31);
      LLDMA2RXREM : in std_logic_vector(0 to 3);
      LLDMA2RXSOFN : in std_logic;
      LLDMA2RXEOFN : in std_logic;
      LLDMA2RXSOPN : in std_logic;
      LLDMA2RXEOPN : in std_logic;
      LLDMA2RXSRCRDYN : in std_logic;
      LLDMA2RSTENGINEREQ : in std_logic;
      DMA2LLTXD : out std_logic_vector(0 to 31);
      DMA2LLTXREM : out std_logic_vector(0 to 3);
      DMA2LLTXSOFN : out std_logic;
      DMA2LLTXEOFN : out std_logic;
      DMA2LLTXSOPN : out std_logic;
      DMA2LLTXEOPN : out std_logic;
      DMA2LLTXSRCRDYN : out std_logic;
      DMA2LLRXDSTRDYN : out std_logic;
      DMA2LLRSTENGINEACK : out std_logic;
      DMA2TXIRQ : out std_logic;
      DMA2RXIRQ : out std_logic;
      CPMDMA3LLCLK : in std_logic;
      LLDMA3TXDSTRDYN : in std_logic;
      LLDMA3RXD : in std_logic_vector(0 to 31);
      LLDMA3RXREM : in std_logic_vector(0 to 3);
      LLDMA3RXSOFN : in std_logic;
      LLDMA3RXEOFN : in std_logic;
      LLDMA3RXSOPN : in std_logic;
      LLDMA3RXEOPN : in std_logic;
      LLDMA3RXSRCRDYN : in std_logic;
      LLDMA3RSTENGINEREQ : in std_logic;
      DMA3LLTXD : out std_logic_vector(0 to 31);
      DMA3LLTXREM : out std_logic_vector(0 to 3);
      DMA3LLTXSOFN : out std_logic;
      DMA3LLTXEOFN : out std_logic;
      DMA3LLTXSOPN : out std_logic;
      DMA3LLTXEOPN : out std_logic;
      DMA3LLTXSRCRDYN : out std_logic;
      DMA3LLRXDSTRDYN : out std_logic;
      DMA3LLRSTENGINEACK : out std_logic;
      DMA3TXIRQ : out std_logic;
      DMA3RXIRQ : out std_logic;
      RSTC440RESETCORE : in std_logic;
      RSTC440RESETCHIP : in std_logic;
      RSTC440RESETSYSTEM : in std_logic;
      C440RSTCORERESETREQ : out std_logic;
      C440RSTCHIPRESETREQ : out std_logic;
      C440RSTSYSTEMRESETREQ : out std_logic;
      TRCC440TRACEDISABLE : in std_logic;
      TRCC440TRIGGEREVENTIN : in std_logic;
      C440TRCBRANCHSTATUS : out std_logic_vector(0 to 2);
      C440TRCCYCLE : out std_logic;
      C440TRCEXECUTIONSTATUS : out std_logic_vector(0 to 4);
      C440TRCTRACESTATUS : out std_logic_vector(0 to 6);
      C440TRCTRIGGEREVENTOUT : out std_logic;
      C440TRCTRIGGEREVENTTYPE : out std_logic_vector(0 to 13)
    );
  end component;

  component plb_v46_0_wrapper is
    port (
      PLB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      PLB_Rst : out std_logic;
      SPLB_Rst : out std_logic_vector(0 to 9);
      MPLB_Rst : out std_logic_vector(0 to 0);
      PLB_dcrAck : out std_logic;
      PLB_dcrDBus : out std_logic_vector(0 to 31);
      DCR_ABus : in std_logic_vector(0 to 9);
      DCR_DBus : in std_logic_vector(0 to 31);
      DCR_Read : in std_logic;
      DCR_Write : in std_logic;
      M_ABus : in std_logic_vector(0 to 31);
      M_UABus : in std_logic_vector(0 to 31);
      M_BE : in std_logic_vector(0 to 15);
      M_RNW : in std_logic_vector(0 to 0);
      M_abort : in std_logic_vector(0 to 0);
      M_busLock : in std_logic_vector(0 to 0);
      M_TAttribute : in std_logic_vector(0 to 15);
      M_lockErr : in std_logic_vector(0 to 0);
      M_MSize : in std_logic_vector(0 to 1);
      M_priority : in std_logic_vector(0 to 1);
      M_rdBurst : in std_logic_vector(0 to 0);
      M_request : in std_logic_vector(0 to 0);
      M_size : in std_logic_vector(0 to 3);
      M_type : in std_logic_vector(0 to 2);
      M_wrBurst : in std_logic_vector(0 to 0);
      M_wrDBus : in std_logic_vector(0 to 127);
      Sl_addrAck : in std_logic_vector(0 to 9);
      Sl_MRdErr : in std_logic_vector(0 to 9);
      Sl_MWrErr : in std_logic_vector(0 to 9);
      Sl_MBusy : in std_logic_vector(0 to 9);
      Sl_rdBTerm : in std_logic_vector(0 to 9);
      Sl_rdComp : in std_logic_vector(0 to 9);
      Sl_rdDAck : in std_logic_vector(0 to 9);
      Sl_rdDBus : in std_logic_vector(0 to 1279);
      Sl_rdWdAddr : in std_logic_vector(0 to 39);
      Sl_rearbitrate : in std_logic_vector(0 to 9);
      Sl_SSize : in std_logic_vector(0 to 19);
      Sl_wait : in std_logic_vector(0 to 9);
      Sl_wrBTerm : in std_logic_vector(0 to 9);
      Sl_wrComp : in std_logic_vector(0 to 9);
      Sl_wrDAck : in std_logic_vector(0 to 9);
      Sl_MIRQ : in std_logic_vector(0 to 9);
      PLB_MIRQ : out std_logic_vector(0 to 0);
      PLB_ABus : out std_logic_vector(0 to 31);
      PLB_UABus : out std_logic_vector(0 to 31);
      PLB_BE : out std_logic_vector(0 to 15);
      PLB_MAddrAck : out std_logic_vector(0 to 0);
      PLB_MTimeout : out std_logic_vector(0 to 0);
      PLB_MBusy : out std_logic_vector(0 to 0);
      PLB_MRdErr : out std_logic_vector(0 to 0);
      PLB_MWrErr : out std_logic_vector(0 to 0);
      PLB_MRdBTerm : out std_logic_vector(0 to 0);
      PLB_MRdDAck : out std_logic_vector(0 to 0);
      PLB_MRdDBus : out std_logic_vector(0 to 127);
      PLB_MRdWdAddr : out std_logic_vector(0 to 3);
      PLB_MRearbitrate : out std_logic_vector(0 to 0);
      PLB_MWrBTerm : out std_logic_vector(0 to 0);
      PLB_MWrDAck : out std_logic_vector(0 to 0);
      PLB_MSSize : out std_logic_vector(0 to 1);
      PLB_PAValid : out std_logic;
      PLB_RNW : out std_logic;
      PLB_SAValid : out std_logic;
      PLB_abort : out std_logic;
      PLB_busLock : out std_logic;
      PLB_TAttribute : out std_logic_vector(0 to 15);
      PLB_lockErr : out std_logic;
      PLB_masterID : out std_logic_vector(0 to 0);
      PLB_MSize : out std_logic_vector(0 to 1);
      PLB_rdPendPri : out std_logic_vector(0 to 1);
      PLB_wrPendPri : out std_logic_vector(0 to 1);
      PLB_rdPendReq : out std_logic;
      PLB_wrPendReq : out std_logic;
      PLB_rdBurst : out std_logic;
      PLB_rdPrim : out std_logic_vector(0 to 9);
      PLB_reqPri : out std_logic_vector(0 to 1);
      PLB_size : out std_logic_vector(0 to 3);
      PLB_type : out std_logic_vector(0 to 2);
      PLB_wrBurst : out std_logic;
      PLB_wrDBus : out std_logic_vector(0 to 127);
      PLB_wrPrim : out std_logic_vector(0 to 9);
      PLB_SaddrAck : out std_logic;
      PLB_SMRdErr : out std_logic_vector(0 to 0);
      PLB_SMWrErr : out std_logic_vector(0 to 0);
      PLB_SMBusy : out std_logic_vector(0 to 0);
      PLB_SrdBTerm : out std_logic;
      PLB_SrdComp : out std_logic;
      PLB_SrdDAck : out std_logic;
      PLB_SrdDBus : out std_logic_vector(0 to 127);
      PLB_SrdWdAddr : out std_logic_vector(0 to 3);
      PLB_Srearbitrate : out std_logic;
      PLB_Sssize : out std_logic_vector(0 to 1);
      PLB_Swait : out std_logic;
      PLB_SwrBTerm : out std_logic;
      PLB_SwrComp : out std_logic;
      PLB_SwrDAck : out std_logic;
      Bus_Error_Det : out std_logic
    );
  end component;

  component jtagppc_cntlr_inst_wrapper is
    port (
      TRSTNEG : in std_logic;
      HALTNEG0 : in std_logic;
      DBGC405DEBUGHALT0 : out std_logic;
      HALTNEG1 : in std_logic;
      DBGC405DEBUGHALT1 : out std_logic;
      C405JTGTDO0 : in std_logic;
      C405JTGTDOEN0 : in std_logic;
      JTGC405TCK0 : out std_logic;
      JTGC405TDI0 : out std_logic;
      JTGC405TMS0 : out std_logic;
      JTGC405TRSTNEG0 : out std_logic;
      C405JTGTDO1 : in std_logic;
      C405JTGTDOEN1 : in std_logic;
      JTGC405TCK1 : out std_logic;
      JTGC405TDI1 : out std_logic;
      JTGC405TMS1 : out std_logic;
      JTGC405TRSTNEG1 : out std_logic
    );
  end component;

  component clock_generator_0_wrapper is
    port (
      CLKIN : in std_logic;
      CLKFBIN : in std_logic;
      CLKOUT0 : out std_logic;
      CLKOUT1 : out std_logic;
      CLKOUT2 : out std_logic;
      CLKOUT3 : out std_logic;
      CLKOUT4 : out std_logic;
      CLKOUT5 : out std_logic;
      CLKOUT6 : out std_logic;
      CLKOUT7 : out std_logic;
      CLKOUT8 : out std_logic;
      CLKOUT9 : out std_logic;
      CLKOUT10 : out std_logic;
      CLKOUT11 : out std_logic;
      CLKOUT12 : out std_logic;
      CLKOUT13 : out std_logic;
      CLKOUT14 : out std_logic;
      CLKOUT15 : out std_logic;
      CLKFBOUT : out std_logic;
      PSCLK : in std_logic;
      PSEN : in std_logic;
      PSINCDEC : in std_logic;
      PSDONE : out std_logic;
      RST : in std_logic;
      LOCKED : out std_logic
    );
  end component;

  component rs232_0_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 15);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_wrDBus : in std_logic_vector(0 to 127);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_lockErr : in std_logic;
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 127);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 0);
      Sl_MWrErr : out std_logic_vector(0 to 0);
      Sl_MRdErr : out std_logic_vector(0 to 0);
      Sl_wrBTerm : out std_logic;
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdBTerm : out std_logic;
      Sl_MIRQ : out std_logic_vector(0 to 0);
      RX : in std_logic;
      TX : out std_logic;
      Interrupt : out std_logic
    );
  end component;

  component hard_ethernet_mac_fifo_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 15);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 127);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 127);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 0);
      Sl_MWrErr : out std_logic_vector(0 to 0);
      Sl_MRdErr : out std_logic_vector(0 to 0);
      Sl_MIRQ : out std_logic_vector(0 to 0);
      IP2INTC_Irpt : out std_logic;
      llink_rst : out std_logic;
      tx_llink_din : out std_logic_vector(0 to 31);
      tx_llink_src_rdy_n : out std_logic;
      tx_llink_dest_rdy_n : in std_logic;
      tx_llink_sof_n : out std_logic;
      tx_llink_sop_n : out std_logic;
      tx_llink_eof_n : out std_logic;
      tx_llink_eop_n : out std_logic;
      tx_llink_rem_n : out std_logic_vector(0 to 3);
      rx_llink_din : in std_logic_vector(0 to 31);
      rx_llink_src_rdy_n : in std_logic;
      rx_llink_dest_rdy_n : out std_logic;
      rx_llink_sof_n : in std_logic;
      rx_llink_sop_n : in std_logic;
      rx_llink_eof_n : in std_logic;
      rx_llink_eop_n : in std_logic;
      rx_llink_rem_n : in std_logic_vector(0 to 3)
    );
  end component;

  component hard_ethernet_mac_wrapper is
    port (
      TemacIntc0_Irpt : out std_logic;
      TemacIntc1_Irpt : out std_logic;
      TemacPhy_RST_n : out std_logic;
      GTX_CLK_0 : in std_logic;
      MGTCLK_P : in std_logic;
      MGTCLK_N : in std_logic;
      REFCLK : in std_logic;
      DCLK : in std_logic;
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      Core_Clk : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 15);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 127);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 127);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 0);
      Sl_MWrErr : out std_logic_vector(0 to 0);
      Sl_MRdErr : out std_logic_vector(0 to 0);
      Sl_MIRQ : out std_logic_vector(0 to 0);
      LlinkTemac0_CLK : in std_logic;
      LlinkTemac0_RST : in std_logic;
      LlinkTemac0_SOP_n : in std_logic;
      LlinkTemac0_EOP_n : in std_logic;
      LlinkTemac0_SOF_n : in std_logic;
      LlinkTemac0_EOF_n : in std_logic;
      LlinkTemac0_REM : in std_logic_vector(0 to 3);
      LlinkTemac0_Data : in std_logic_vector(0 to 31);
      LlinkTemac0_SRC_RDY_n : in std_logic;
      Temac0Llink_DST_RDY_n : out std_logic;
      Temac0Llink_SOP_n : out std_logic;
      Temac0Llink_EOP_n : out std_logic;
      Temac0Llink_SOF_n : out std_logic;
      Temac0Llink_EOF_n : out std_logic;
      Temac0Llink_REM : out std_logic_vector(0 to 3);
      Temac0Llink_Data : out std_logic_vector(0 to 31);
      Temac0Llink_SRC_RDY_n : out std_logic;
      LlinkTemac0_DST_RDY_n : in std_logic;
      LlinkTemac1_CLK : in std_logic;
      LlinkTemac1_RST : in std_logic;
      LlinkTemac1_SOP_n : in std_logic;
      LlinkTemac1_EOP_n : in std_logic;
      LlinkTemac1_SOF_n : in std_logic;
      LlinkTemac1_EOF_n : in std_logic;
      LlinkTemac1_REM : in std_logic_vector(0 to 3);
      LlinkTemac1_Data : in std_logic_vector(0 to 31);
      LlinkTemac1_SRC_RDY_n : in std_logic;
      Temac1Llink_DST_RDY_n : out std_logic;
      Temac1Llink_SOP_n : out std_logic;
      Temac1Llink_EOP_n : out std_logic;
      Temac1Llink_SOF_n : out std_logic;
      Temac1Llink_EOF_n : out std_logic;
      Temac1Llink_REM : out std_logic_vector(0 to 3);
      Temac1Llink_Data : out std_logic_vector(0 to 31);
      Temac1Llink_SRC_RDY_n : out std_logic;
      LlinkTemac1_DST_RDY_n : in std_logic;
      MII_TXD_0 : out std_logic_vector(3 downto 0);
      MII_TX_EN_0 : out std_logic;
      MII_TX_ER_0 : out std_logic;
      MII_RXD_0 : in std_logic_vector(3 downto 0);
      MII_RX_DV_0 : in std_logic;
      MII_RX_ER_0 : in std_logic;
      MII_RX_CLK_0 : in std_logic;
      MII_TX_CLK_0 : in std_logic;
      MII_TXD_1 : out std_logic_vector(3 downto 0);
      MII_TX_EN_1 : out std_logic;
      MII_TX_ER_1 : out std_logic;
      MII_RXD_1 : in std_logic_vector(3 downto 0);
      MII_RX_DV_1 : in std_logic;
      MII_RX_ER_1 : in std_logic;
      MII_RX_CLK_1 : in std_logic;
      MII_TX_CLK_1 : in std_logic;
      GMII_TXD_0 : out std_logic_vector(7 downto 0);
      GMII_TX_EN_0 : out std_logic;
      GMII_TX_ER_0 : out std_logic;
      GMII_TX_CLK_0 : out std_logic;
      GMII_RXD_0 : in std_logic_vector(7 downto 0);
      GMII_RX_DV_0 : in std_logic;
      GMII_RX_ER_0 : in std_logic;
      GMII_RX_CLK_0 : in std_logic;
      GMII_TXD_1 : out std_logic_vector(7 downto 0);
      GMII_TX_EN_1 : out std_logic;
      GMII_TX_ER_1 : out std_logic;
      GMII_TX_CLK_1 : out std_logic;
      GMII_RXD_1 : in std_logic_vector(7 downto 0);
      GMII_RX_DV_1 : in std_logic;
      GMII_RX_ER_1 : in std_logic;
      GMII_RX_CLK_1 : in std_logic;
      TXP_0 : out std_logic;
      TXN_0 : out std_logic;
      RXP_0 : in std_logic;
      RXN_0 : in std_logic;
      TXP_1 : out std_logic;
      TXN_1 : out std_logic;
      RXP_1 : in std_logic;
      RXN_1 : in std_logic;
      RGMII_TXD_0 : out std_logic_vector(3 downto 0);
      RGMII_TX_CTL_0 : out std_logic;
      RGMII_TXC_0 : out std_logic;
      RGMII_RXD_0 : in std_logic_vector(3 downto 0);
      RGMII_RX_CTL_0 : in std_logic;
      RGMII_RXC_0 : in std_logic;
      RGMII_TXD_1 : out std_logic_vector(3 downto 0);
      RGMII_TX_CTL_1 : out std_logic;
      RGMII_TXC_1 : out std_logic;
      RGMII_RXD_1 : in std_logic_vector(3 downto 0);
      RGMII_RX_CTL_1 : in std_logic;
      RGMII_RXC_1 : in std_logic;
      MDC_0 : out std_logic;
      MDC_1 : out std_logic;
      HostMiimRdy : in std_logic;
      HostRdData : in std_logic_vector(31 downto 0);
      HostMiimSel : out std_logic;
      HostReq : out std_logic;
      HostAddr : out std_logic_vector(9 downto 0);
      HostEmac1Sel : out std_logic;
      Temac0AvbTxClk : out std_logic;
      Temac0AvbTxClkEn : out std_logic;
      Temac0AvbRxClk : out std_logic;
      Temac0AvbRxClkEn : out std_logic;
      Avb2Mac0TxData : in std_logic_vector(7 downto 0);
      Avb2Mac0TxDataValid : in std_logic;
      Avb2Mac0TxUnderrun : in std_logic;
      Mac02AvbTxAck : out std_logic;
      Mac02AvbRxData : out std_logic_vector(7 downto 0);
      Mac02AvbRxDataValid : out std_logic;
      Mac02AvbRxFrameGood : out std_logic;
      Mac02AvbRxFrameBad : out std_logic;
      Temac02AvbTxData : out std_logic_vector(7 downto 0);
      Temac02AvbTxDataValid : out std_logic;
      Temac02AvbTxUnderrun : out std_logic;
      Avb2Temac0TxAck : in std_logic;
      Avb2Temac0RxData : in std_logic_vector(7 downto 0);
      Avb2Temac0RxDataValid : in std_logic;
      Avb2Temac0RxFrameGood : in std_logic;
      Avb2Temac0RxFrameBad : in std_logic;
      Temac1AvbTxClk : out std_logic;
      Temac1AvbTxClkEn : out std_logic;
      Temac1AvbRxClk : out std_logic;
      Temac1AvbRxClkEn : out std_logic;
      Avb2Mac1TxData : in std_logic_vector(7 downto 0);
      Avb2Mac1TxDataValid : in std_logic;
      Avb2Mac1TxUnderrun : in std_logic;
      Mac12AvbTxAck : out std_logic;
      Mac12AvbRxData : out std_logic_vector(7 downto 0);
      Mac12AvbRxDataValid : out std_logic;
      Mac12AvbRxFrameGood : out std_logic;
      Mac12AvbRxFrameBad : out std_logic;
      Temac12AvbTxData : out std_logic_vector(7 downto 0);
      Temac12AvbTxDataValid : out std_logic;
      Temac12AvbTxUnderrun : out std_logic;
      Avb2Temac1TxAck : in std_logic;
      Avb2Temac1RxData : in std_logic_vector(7 downto 0);
      Avb2Temac1RxDataValid : in std_logic;
      Avb2Temac1RxFrameGood : in std_logic;
      Avb2Temac1RxFrameBad : in std_logic;
      TxClientClk_0 : out std_logic;
      ClientTxStat_0 : out std_logic;
      ClientTxStatsVld_0 : out std_logic;
      ClientTxStatsByteVld_0 : out std_logic;
      RxClientClk_0 : out std_logic;
      ClientRxStats_0 : out std_logic_vector(6 downto 0);
      ClientRxStatsVld_0 : out std_logic;
      ClientRxStatsByteVld_0 : out std_logic;
      TxClientClk_1 : out std_logic;
      ClientTxStat_1 : out std_logic;
      ClientTxStatsVld_1 : out std_logic;
      ClientTxStatsByteVld_1 : out std_logic;
      RxClientClk_1 : out std_logic;
      ClientRxStats_1 : out std_logic_vector(6 downto 0);
      ClientRxStatsVld_1 : out std_logic;
      ClientRxStatsByteVld_1 : out std_logic;
      MDIO_0_I : in std_logic;
      MDIO_0_O : out std_logic;
      MDIO_0_T : out std_logic;
      MDIO_1_I : in std_logic;
      MDIO_1_O : out std_logic;
      MDIO_1_T : out std_logic
    );
  end component;

  component ddr_sdram_0_wrapper is
    port (
      FSL0_M_Clk : in std_logic;
      FSL0_M_Write : in std_logic;
      FSL0_M_Data : in std_logic_vector(0 to 31);
      FSL0_M_Control : in std_logic;
      FSL0_M_Full : out std_logic;
      FSL0_S_Clk : in std_logic;
      FSL0_S_Read : in std_logic;
      FSL0_S_Data : out std_logic_vector(0 to 31);
      FSL0_S_Control : out std_logic;
      FSL0_S_Exists : out std_logic;
      FSL0_B_M_Clk : in std_logic;
      FSL0_B_M_Write : in std_logic;
      FSL0_B_M_Data : in std_logic_vector(0 to 31);
      FSL0_B_M_Control : in std_logic;
      FSL0_B_M_Full : out std_logic;
      FSL0_B_S_Clk : in std_logic;
      FSL0_B_S_Read : in std_logic;
      FSL0_B_S_Data : out std_logic_vector(0 to 31);
      FSL0_B_S_Control : out std_logic;
      FSL0_B_S_Exists : out std_logic;
      SPLB0_Clk : in std_logic;
      SPLB0_Rst : in std_logic;
      SPLB0_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB0_PLB_PAValid : in std_logic;
      SPLB0_PLB_SAValid : in std_logic;
      SPLB0_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB0_PLB_RNW : in std_logic;
      SPLB0_PLB_BE : in std_logic_vector(0 to 15);
      SPLB0_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB0_PLB_rdPrim : in std_logic;
      SPLB0_PLB_wrPrim : in std_logic;
      SPLB0_PLB_abort : in std_logic;
      SPLB0_PLB_busLock : in std_logic;
      SPLB0_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB0_PLB_size : in std_logic_vector(0 to 3);
      SPLB0_PLB_type : in std_logic_vector(0 to 2);
      SPLB0_PLB_lockErr : in std_logic;
      SPLB0_PLB_wrPendReq : in std_logic;
      SPLB0_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB0_PLB_rdPendReq : in std_logic;
      SPLB0_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB0_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB0_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB0_PLB_rdBurst : in std_logic;
      SPLB0_PLB_wrBurst : in std_logic;
      SPLB0_PLB_wrDBus : in std_logic_vector(0 to 127);
      SPLB0_Sl_addrAck : out std_logic;
      SPLB0_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB0_Sl_wait : out std_logic;
      SPLB0_Sl_rearbitrate : out std_logic;
      SPLB0_Sl_wrDAck : out std_logic;
      SPLB0_Sl_wrComp : out std_logic;
      SPLB0_Sl_wrBTerm : out std_logic;
      SPLB0_Sl_rdDBus : out std_logic_vector(0 to 127);
      SPLB0_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB0_Sl_rdDAck : out std_logic;
      SPLB0_Sl_rdComp : out std_logic;
      SPLB0_Sl_rdBTerm : out std_logic;
      SPLB0_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB0_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB0_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB0_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA0_Clk : in std_logic;
      SDMA0_Rx_IntOut : out std_logic;
      SDMA0_Tx_IntOut : out std_logic;
      SDMA0_RstOut : out std_logic;
      SDMA0_TX_D : out std_logic_vector(0 to 31);
      SDMA0_TX_Rem : out std_logic_vector(0 to 3);
      SDMA0_TX_SOF : out std_logic;
      SDMA0_TX_EOF : out std_logic;
      SDMA0_TX_SOP : out std_logic;
      SDMA0_TX_EOP : out std_logic;
      SDMA0_TX_Src_Rdy : out std_logic;
      SDMA0_TX_Dst_Rdy : in std_logic;
      SDMA0_RX_D : in std_logic_vector(0 to 31);
      SDMA0_RX_Rem : in std_logic_vector(0 to 3);
      SDMA0_RX_SOF : in std_logic;
      SDMA0_RX_EOF : in std_logic;
      SDMA0_RX_SOP : in std_logic;
      SDMA0_RX_EOP : in std_logic;
      SDMA0_RX_Src_Rdy : in std_logic;
      SDMA0_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL0_Clk : in std_logic;
      SDMA_CTRL0_Rst : in std_logic;
      SDMA_CTRL0_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL0_PLB_PAValid : in std_logic;
      SDMA_CTRL0_PLB_SAValid : in std_logic;
      SDMA_CTRL0_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL0_PLB_RNW : in std_logic;
      SDMA_CTRL0_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL0_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL0_PLB_rdPrim : in std_logic;
      SDMA_CTRL0_PLB_wrPrim : in std_logic;
      SDMA_CTRL0_PLB_abort : in std_logic;
      SDMA_CTRL0_PLB_busLock : in std_logic;
      SDMA_CTRL0_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL0_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL0_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL0_PLB_lockErr : in std_logic;
      SDMA_CTRL0_PLB_wrPendReq : in std_logic;
      SDMA_CTRL0_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL0_PLB_rdPendReq : in std_logic;
      SDMA_CTRL0_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL0_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL0_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL0_PLB_rdBurst : in std_logic;
      SDMA_CTRL0_PLB_wrBurst : in std_logic;
      SDMA_CTRL0_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL0_Sl_addrAck : out std_logic;
      SDMA_CTRL0_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL0_Sl_wait : out std_logic;
      SDMA_CTRL0_Sl_rearbitrate : out std_logic;
      SDMA_CTRL0_Sl_wrDAck : out std_logic;
      SDMA_CTRL0_Sl_wrComp : out std_logic;
      SDMA_CTRL0_Sl_wrBTerm : out std_logic;
      SDMA_CTRL0_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL0_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL0_Sl_rdDAck : out std_logic;
      SDMA_CTRL0_Sl_rdComp : out std_logic;
      SDMA_CTRL0_Sl_rdBTerm : out std_logic;
      SDMA_CTRL0_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL0_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL0_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL0_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM0_Addr : in std_logic_vector(31 downto 0);
      PIM0_AddrReq : in std_logic;
      PIM0_AddrAck : out std_logic;
      PIM0_RNW : in std_logic;
      PIM0_Size : in std_logic_vector(3 downto 0);
      PIM0_RdModWr : in std_logic;
      PIM0_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM0_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM0_WrFIFO_Push : in std_logic;
      PIM0_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM0_RdFIFO_Pop : in std_logic;
      PIM0_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM0_WrFIFO_Empty : out std_logic;
      PIM0_WrFIFO_AlmostFull : out std_logic;
      PIM0_WrFIFO_Flush : in std_logic;
      PIM0_RdFIFO_Empty : out std_logic;
      PIM0_RdFIFO_Flush : in std_logic;
      PIM0_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM0_InitDone : out std_logic;
      PPC440MC0_MIMCReadNotWrite : in std_logic;
      PPC440MC0_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC0_MIMCAddressValid : in std_logic;
      PPC440MC0_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC0_MIMCWriteDataValid : in std_logic;
      PPC440MC0_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC0_MIMCBankConflict : in std_logic;
      PPC440MC0_MIMCRowConflict : in std_logic;
      PPC440MC0_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC0_MCMIReadDataValid : out std_logic;
      PPC440MC0_MCMIReadDataErr : out std_logic;
      PPC440MC0_MCMIAddrReadyToAccept : out std_logic;
      VFBC0_Cmd_Clk : in std_logic;
      VFBC0_Cmd_Reset : in std_logic;
      VFBC0_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC0_Cmd_Write : in std_logic;
      VFBC0_Cmd_End : in std_logic;
      VFBC0_Cmd_Full : out std_logic;
      VFBC0_Cmd_Almost_Full : out std_logic;
      VFBC0_Cmd_Idle : out std_logic;
      VFBC0_Wd_Clk : in std_logic;
      VFBC0_Wd_Reset : in std_logic;
      VFBC0_Wd_Write : in std_logic;
      VFBC0_Wd_End_Burst : in std_logic;
      VFBC0_Wd_Flush : in std_logic;
      VFBC0_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC0_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC0_Wd_Full : out std_logic;
      VFBC0_Wd_Almost_Full : out std_logic;
      VFBC0_Rd_Clk : in std_logic;
      VFBC0_Rd_Reset : in std_logic;
      VFBC0_Rd_Read : in std_logic;
      VFBC0_Rd_End_Burst : in std_logic;
      VFBC0_Rd_Flush : in std_logic;
      VFBC0_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC0_Rd_Empty : out std_logic;
      VFBC0_Rd_Almost_Empty : out std_logic;
      MCB0_cmd_clk : in std_logic;
      MCB0_cmd_en : in std_logic;
      MCB0_cmd_instr : in std_logic_vector(2 downto 0);
      MCB0_cmd_bl : in std_logic_vector(5 downto 0);
      MCB0_cmd_byte_addr : in std_logic_vector(29 downto 0);
      MCB0_cmd_empty : out std_logic;
      MCB0_cmd_full : out std_logic;
      MCB0_wr_clk : in std_logic;
      MCB0_wr_en : in std_logic;
      MCB0_wr_mask : in std_logic_vector(7 downto 0);
      MCB0_wr_data : in std_logic_vector(63 downto 0);
      MCB0_wr_full : out std_logic;
      MCB0_wr_empty : out std_logic;
      MCB0_wr_count : out std_logic_vector(6 downto 0);
      MCB0_wr_underrun : out std_logic;
      MCB0_wr_error : out std_logic;
      MCB0_rd_clk : in std_logic;
      MCB0_rd_en : in std_logic;
      MCB0_rd_data : out std_logic_vector(63 downto 0);
      MCB0_rd_full : out std_logic;
      MCB0_rd_empty : out std_logic;
      MCB0_rd_count : out std_logic_vector(6 downto 0);
      MCB0_rd_overflow : out std_logic;
      MCB0_rd_error : out std_logic;
      FSL1_M_Clk : in std_logic;
      FSL1_M_Write : in std_logic;
      FSL1_M_Data : in std_logic_vector(0 to 31);
      FSL1_M_Control : in std_logic;
      FSL1_M_Full : out std_logic;
      FSL1_S_Clk : in std_logic;
      FSL1_S_Read : in std_logic;
      FSL1_S_Data : out std_logic_vector(0 to 31);
      FSL1_S_Control : out std_logic;
      FSL1_S_Exists : out std_logic;
      FSL1_B_M_Clk : in std_logic;
      FSL1_B_M_Write : in std_logic;
      FSL1_B_M_Data : in std_logic_vector(0 to 31);
      FSL1_B_M_Control : in std_logic;
      FSL1_B_M_Full : out std_logic;
      FSL1_B_S_Clk : in std_logic;
      FSL1_B_S_Read : in std_logic;
      FSL1_B_S_Data : out std_logic_vector(0 to 31);
      FSL1_B_S_Control : out std_logic;
      FSL1_B_S_Exists : out std_logic;
      SPLB1_Clk : in std_logic;
      SPLB1_Rst : in std_logic;
      SPLB1_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB1_PLB_PAValid : in std_logic;
      SPLB1_PLB_SAValid : in std_logic;
      SPLB1_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB1_PLB_RNW : in std_logic;
      SPLB1_PLB_BE : in std_logic_vector(0 to 7);
      SPLB1_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB1_PLB_rdPrim : in std_logic;
      SPLB1_PLB_wrPrim : in std_logic;
      SPLB1_PLB_abort : in std_logic;
      SPLB1_PLB_busLock : in std_logic;
      SPLB1_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB1_PLB_size : in std_logic_vector(0 to 3);
      SPLB1_PLB_type : in std_logic_vector(0 to 2);
      SPLB1_PLB_lockErr : in std_logic;
      SPLB1_PLB_wrPendReq : in std_logic;
      SPLB1_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB1_PLB_rdPendReq : in std_logic;
      SPLB1_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB1_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB1_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB1_PLB_rdBurst : in std_logic;
      SPLB1_PLB_wrBurst : in std_logic;
      SPLB1_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB1_Sl_addrAck : out std_logic;
      SPLB1_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB1_Sl_wait : out std_logic;
      SPLB1_Sl_rearbitrate : out std_logic;
      SPLB1_Sl_wrDAck : out std_logic;
      SPLB1_Sl_wrComp : out std_logic;
      SPLB1_Sl_wrBTerm : out std_logic;
      SPLB1_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB1_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB1_Sl_rdDAck : out std_logic;
      SPLB1_Sl_rdComp : out std_logic;
      SPLB1_Sl_rdBTerm : out std_logic;
      SPLB1_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB1_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB1_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB1_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA1_Clk : in std_logic;
      SDMA1_Rx_IntOut : out std_logic;
      SDMA1_Tx_IntOut : out std_logic;
      SDMA1_RstOut : out std_logic;
      SDMA1_TX_D : out std_logic_vector(0 to 31);
      SDMA1_TX_Rem : out std_logic_vector(0 to 3);
      SDMA1_TX_SOF : out std_logic;
      SDMA1_TX_EOF : out std_logic;
      SDMA1_TX_SOP : out std_logic;
      SDMA1_TX_EOP : out std_logic;
      SDMA1_TX_Src_Rdy : out std_logic;
      SDMA1_TX_Dst_Rdy : in std_logic;
      SDMA1_RX_D : in std_logic_vector(0 to 31);
      SDMA1_RX_Rem : in std_logic_vector(0 to 3);
      SDMA1_RX_SOF : in std_logic;
      SDMA1_RX_EOF : in std_logic;
      SDMA1_RX_SOP : in std_logic;
      SDMA1_RX_EOP : in std_logic;
      SDMA1_RX_Src_Rdy : in std_logic;
      SDMA1_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL1_Clk : in std_logic;
      SDMA_CTRL1_Rst : in std_logic;
      SDMA_CTRL1_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL1_PLB_PAValid : in std_logic;
      SDMA_CTRL1_PLB_SAValid : in std_logic;
      SDMA_CTRL1_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL1_PLB_RNW : in std_logic;
      SDMA_CTRL1_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL1_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL1_PLB_rdPrim : in std_logic;
      SDMA_CTRL1_PLB_wrPrim : in std_logic;
      SDMA_CTRL1_PLB_abort : in std_logic;
      SDMA_CTRL1_PLB_busLock : in std_logic;
      SDMA_CTRL1_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL1_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL1_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL1_PLB_lockErr : in std_logic;
      SDMA_CTRL1_PLB_wrPendReq : in std_logic;
      SDMA_CTRL1_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL1_PLB_rdPendReq : in std_logic;
      SDMA_CTRL1_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL1_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL1_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL1_PLB_rdBurst : in std_logic;
      SDMA_CTRL1_PLB_wrBurst : in std_logic;
      SDMA_CTRL1_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL1_Sl_addrAck : out std_logic;
      SDMA_CTRL1_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL1_Sl_wait : out std_logic;
      SDMA_CTRL1_Sl_rearbitrate : out std_logic;
      SDMA_CTRL1_Sl_wrDAck : out std_logic;
      SDMA_CTRL1_Sl_wrComp : out std_logic;
      SDMA_CTRL1_Sl_wrBTerm : out std_logic;
      SDMA_CTRL1_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL1_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL1_Sl_rdDAck : out std_logic;
      SDMA_CTRL1_Sl_rdComp : out std_logic;
      SDMA_CTRL1_Sl_rdBTerm : out std_logic;
      SDMA_CTRL1_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL1_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL1_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL1_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM1_Addr : in std_logic_vector(31 downto 0);
      PIM1_AddrReq : in std_logic;
      PIM1_AddrAck : out std_logic;
      PIM1_RNW : in std_logic;
      PIM1_Size : in std_logic_vector(3 downto 0);
      PIM1_RdModWr : in std_logic;
      PIM1_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM1_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM1_WrFIFO_Push : in std_logic;
      PIM1_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM1_RdFIFO_Pop : in std_logic;
      PIM1_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM1_WrFIFO_Empty : out std_logic;
      PIM1_WrFIFO_AlmostFull : out std_logic;
      PIM1_WrFIFO_Flush : in std_logic;
      PIM1_RdFIFO_Empty : out std_logic;
      PIM1_RdFIFO_Flush : in std_logic;
      PIM1_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM1_InitDone : out std_logic;
      PPC440MC1_MIMCReadNotWrite : in std_logic;
      PPC440MC1_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC1_MIMCAddressValid : in std_logic;
      PPC440MC1_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC1_MIMCWriteDataValid : in std_logic;
      PPC440MC1_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC1_MIMCBankConflict : in std_logic;
      PPC440MC1_MIMCRowConflict : in std_logic;
      PPC440MC1_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC1_MCMIReadDataValid : out std_logic;
      PPC440MC1_MCMIReadDataErr : out std_logic;
      PPC440MC1_MCMIAddrReadyToAccept : out std_logic;
      VFBC1_Cmd_Clk : in std_logic;
      VFBC1_Cmd_Reset : in std_logic;
      VFBC1_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC1_Cmd_Write : in std_logic;
      VFBC1_Cmd_End : in std_logic;
      VFBC1_Cmd_Full : out std_logic;
      VFBC1_Cmd_Almost_Full : out std_logic;
      VFBC1_Cmd_Idle : out std_logic;
      VFBC1_Wd_Clk : in std_logic;
      VFBC1_Wd_Reset : in std_logic;
      VFBC1_Wd_Write : in std_logic;
      VFBC1_Wd_End_Burst : in std_logic;
      VFBC1_Wd_Flush : in std_logic;
      VFBC1_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC1_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC1_Wd_Full : out std_logic;
      VFBC1_Wd_Almost_Full : out std_logic;
      VFBC1_Rd_Clk : in std_logic;
      VFBC1_Rd_Reset : in std_logic;
      VFBC1_Rd_Read : in std_logic;
      VFBC1_Rd_End_Burst : in std_logic;
      VFBC1_Rd_Flush : in std_logic;
      VFBC1_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC1_Rd_Empty : out std_logic;
      VFBC1_Rd_Almost_Empty : out std_logic;
      MCB1_cmd_clk : in std_logic;
      MCB1_cmd_en : in std_logic;
      MCB1_cmd_instr : in std_logic_vector(2 downto 0);
      MCB1_cmd_bl : in std_logic_vector(5 downto 0);
      MCB1_cmd_byte_addr : in std_logic_vector(29 downto 0);
      MCB1_cmd_empty : out std_logic;
      MCB1_cmd_full : out std_logic;
      MCB1_wr_clk : in std_logic;
      MCB1_wr_en : in std_logic;
      MCB1_wr_mask : in std_logic_vector(7 downto 0);
      MCB1_wr_data : in std_logic_vector(63 downto 0);
      MCB1_wr_full : out std_logic;
      MCB1_wr_empty : out std_logic;
      MCB1_wr_count : out std_logic_vector(6 downto 0);
      MCB1_wr_underrun : out std_logic;
      MCB1_wr_error : out std_logic;
      MCB1_rd_clk : in std_logic;
      MCB1_rd_en : in std_logic;
      MCB1_rd_data : out std_logic_vector(63 downto 0);
      MCB1_rd_full : out std_logic;
      MCB1_rd_empty : out std_logic;
      MCB1_rd_count : out std_logic_vector(6 downto 0);
      MCB1_rd_overflow : out std_logic;
      MCB1_rd_error : out std_logic;
      FSL2_M_Clk : in std_logic;
      FSL2_M_Write : in std_logic;
      FSL2_M_Data : in std_logic_vector(0 to 31);
      FSL2_M_Control : in std_logic;
      FSL2_M_Full : out std_logic;
      FSL2_S_Clk : in std_logic;
      FSL2_S_Read : in std_logic;
      FSL2_S_Data : out std_logic_vector(0 to 31);
      FSL2_S_Control : out std_logic;
      FSL2_S_Exists : out std_logic;
      FSL2_B_M_Clk : in std_logic;
      FSL2_B_M_Write : in std_logic;
      FSL2_B_M_Data : in std_logic_vector(0 to 31);
      FSL2_B_M_Control : in std_logic;
      FSL2_B_M_Full : out std_logic;
      FSL2_B_S_Clk : in std_logic;
      FSL2_B_S_Read : in std_logic;
      FSL2_B_S_Data : out std_logic_vector(0 to 31);
      FSL2_B_S_Control : out std_logic;
      FSL2_B_S_Exists : out std_logic;
      SPLB2_Clk : in std_logic;
      SPLB2_Rst : in std_logic;
      SPLB2_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB2_PLB_PAValid : in std_logic;
      SPLB2_PLB_SAValid : in std_logic;
      SPLB2_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB2_PLB_RNW : in std_logic;
      SPLB2_PLB_BE : in std_logic_vector(0 to 7);
      SPLB2_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB2_PLB_rdPrim : in std_logic;
      SPLB2_PLB_wrPrim : in std_logic;
      SPLB2_PLB_abort : in std_logic;
      SPLB2_PLB_busLock : in std_logic;
      SPLB2_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB2_PLB_size : in std_logic_vector(0 to 3);
      SPLB2_PLB_type : in std_logic_vector(0 to 2);
      SPLB2_PLB_lockErr : in std_logic;
      SPLB2_PLB_wrPendReq : in std_logic;
      SPLB2_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB2_PLB_rdPendReq : in std_logic;
      SPLB2_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB2_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB2_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB2_PLB_rdBurst : in std_logic;
      SPLB2_PLB_wrBurst : in std_logic;
      SPLB2_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB2_Sl_addrAck : out std_logic;
      SPLB2_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB2_Sl_wait : out std_logic;
      SPLB2_Sl_rearbitrate : out std_logic;
      SPLB2_Sl_wrDAck : out std_logic;
      SPLB2_Sl_wrComp : out std_logic;
      SPLB2_Sl_wrBTerm : out std_logic;
      SPLB2_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB2_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB2_Sl_rdDAck : out std_logic;
      SPLB2_Sl_rdComp : out std_logic;
      SPLB2_Sl_rdBTerm : out std_logic;
      SPLB2_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB2_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB2_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB2_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA2_Clk : in std_logic;
      SDMA2_Rx_IntOut : out std_logic;
      SDMA2_Tx_IntOut : out std_logic;
      SDMA2_RstOut : out std_logic;
      SDMA2_TX_D : out std_logic_vector(0 to 31);
      SDMA2_TX_Rem : out std_logic_vector(0 to 3);
      SDMA2_TX_SOF : out std_logic;
      SDMA2_TX_EOF : out std_logic;
      SDMA2_TX_SOP : out std_logic;
      SDMA2_TX_EOP : out std_logic;
      SDMA2_TX_Src_Rdy : out std_logic;
      SDMA2_TX_Dst_Rdy : in std_logic;
      SDMA2_RX_D : in std_logic_vector(0 to 31);
      SDMA2_RX_Rem : in std_logic_vector(0 to 3);
      SDMA2_RX_SOF : in std_logic;
      SDMA2_RX_EOF : in std_logic;
      SDMA2_RX_SOP : in std_logic;
      SDMA2_RX_EOP : in std_logic;
      SDMA2_RX_Src_Rdy : in std_logic;
      SDMA2_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL2_Clk : in std_logic;
      SDMA_CTRL2_Rst : in std_logic;
      SDMA_CTRL2_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL2_PLB_PAValid : in std_logic;
      SDMA_CTRL2_PLB_SAValid : in std_logic;
      SDMA_CTRL2_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL2_PLB_RNW : in std_logic;
      SDMA_CTRL2_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL2_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL2_PLB_rdPrim : in std_logic;
      SDMA_CTRL2_PLB_wrPrim : in std_logic;
      SDMA_CTRL2_PLB_abort : in std_logic;
      SDMA_CTRL2_PLB_busLock : in std_logic;
      SDMA_CTRL2_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL2_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL2_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL2_PLB_lockErr : in std_logic;
      SDMA_CTRL2_PLB_wrPendReq : in std_logic;
      SDMA_CTRL2_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL2_PLB_rdPendReq : in std_logic;
      SDMA_CTRL2_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL2_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL2_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL2_PLB_rdBurst : in std_logic;
      SDMA_CTRL2_PLB_wrBurst : in std_logic;
      SDMA_CTRL2_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL2_Sl_addrAck : out std_logic;
      SDMA_CTRL2_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL2_Sl_wait : out std_logic;
      SDMA_CTRL2_Sl_rearbitrate : out std_logic;
      SDMA_CTRL2_Sl_wrDAck : out std_logic;
      SDMA_CTRL2_Sl_wrComp : out std_logic;
      SDMA_CTRL2_Sl_wrBTerm : out std_logic;
      SDMA_CTRL2_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL2_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL2_Sl_rdDAck : out std_logic;
      SDMA_CTRL2_Sl_rdComp : out std_logic;
      SDMA_CTRL2_Sl_rdBTerm : out std_logic;
      SDMA_CTRL2_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL2_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL2_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL2_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM2_Addr : in std_logic_vector(31 downto 0);
      PIM2_AddrReq : in std_logic;
      PIM2_AddrAck : out std_logic;
      PIM2_RNW : in std_logic;
      PIM2_Size : in std_logic_vector(3 downto 0);
      PIM2_RdModWr : in std_logic;
      PIM2_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM2_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM2_WrFIFO_Push : in std_logic;
      PIM2_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM2_RdFIFO_Pop : in std_logic;
      PIM2_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM2_WrFIFO_Empty : out std_logic;
      PIM2_WrFIFO_AlmostFull : out std_logic;
      PIM2_WrFIFO_Flush : in std_logic;
      PIM2_RdFIFO_Empty : out std_logic;
      PIM2_RdFIFO_Flush : in std_logic;
      PIM2_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM2_InitDone : out std_logic;
      PPC440MC2_MIMCReadNotWrite : in std_logic;
      PPC440MC2_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC2_MIMCAddressValid : in std_logic;
      PPC440MC2_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC2_MIMCWriteDataValid : in std_logic;
      PPC440MC2_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC2_MIMCBankConflict : in std_logic;
      PPC440MC2_MIMCRowConflict : in std_logic;
      PPC440MC2_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC2_MCMIReadDataValid : out std_logic;
      PPC440MC2_MCMIReadDataErr : out std_logic;
      PPC440MC2_MCMIAddrReadyToAccept : out std_logic;
      VFBC2_Cmd_Clk : in std_logic;
      VFBC2_Cmd_Reset : in std_logic;
      VFBC2_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC2_Cmd_Write : in std_logic;
      VFBC2_Cmd_End : in std_logic;
      VFBC2_Cmd_Full : out std_logic;
      VFBC2_Cmd_Almost_Full : out std_logic;
      VFBC2_Cmd_Idle : out std_logic;
      VFBC2_Wd_Clk : in std_logic;
      VFBC2_Wd_Reset : in std_logic;
      VFBC2_Wd_Write : in std_logic;
      VFBC2_Wd_End_Burst : in std_logic;
      VFBC2_Wd_Flush : in std_logic;
      VFBC2_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC2_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC2_Wd_Full : out std_logic;
      VFBC2_Wd_Almost_Full : out std_logic;
      VFBC2_Rd_Clk : in std_logic;
      VFBC2_Rd_Reset : in std_logic;
      VFBC2_Rd_Read : in std_logic;
      VFBC2_Rd_End_Burst : in std_logic;
      VFBC2_Rd_Flush : in std_logic;
      VFBC2_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC2_Rd_Empty : out std_logic;
      VFBC2_Rd_Almost_Empty : out std_logic;
      MCB2_cmd_clk : in std_logic;
      MCB2_cmd_en : in std_logic;
      MCB2_cmd_instr : in std_logic_vector(2 downto 0);
      MCB2_cmd_bl : in std_logic_vector(5 downto 0);
      MCB2_cmd_byte_addr : in std_logic_vector(29 downto 0);
      MCB2_cmd_empty : out std_logic;
      MCB2_cmd_full : out std_logic;
      MCB2_wr_clk : in std_logic;
      MCB2_wr_en : in std_logic;
      MCB2_wr_mask : in std_logic_vector(7 downto 0);
      MCB2_wr_data : in std_logic_vector(63 downto 0);
      MCB2_wr_full : out std_logic;
      MCB2_wr_empty : out std_logic;
      MCB2_wr_count : out std_logic_vector(6 downto 0);
      MCB2_wr_underrun : out std_logic;
      MCB2_wr_error : out std_logic;
      MCB2_rd_clk : in std_logic;
      MCB2_rd_en : in std_logic;
      MCB2_rd_data : out std_logic_vector(63 downto 0);
      MCB2_rd_full : out std_logic;
      MCB2_rd_empty : out std_logic;
      MCB2_rd_count : out std_logic_vector(6 downto 0);
      MCB2_rd_overflow : out std_logic;
      MCB2_rd_error : out std_logic;
      FSL3_M_Clk : in std_logic;
      FSL3_M_Write : in std_logic;
      FSL3_M_Data : in std_logic_vector(0 to 31);
      FSL3_M_Control : in std_logic;
      FSL3_M_Full : out std_logic;
      FSL3_S_Clk : in std_logic;
      FSL3_S_Read : in std_logic;
      FSL3_S_Data : out std_logic_vector(0 to 31);
      FSL3_S_Control : out std_logic;
      FSL3_S_Exists : out std_logic;
      FSL3_B_M_Clk : in std_logic;
      FSL3_B_M_Write : in std_logic;
      FSL3_B_M_Data : in std_logic_vector(0 to 31);
      FSL3_B_M_Control : in std_logic;
      FSL3_B_M_Full : out std_logic;
      FSL3_B_S_Clk : in std_logic;
      FSL3_B_S_Read : in std_logic;
      FSL3_B_S_Data : out std_logic_vector(0 to 31);
      FSL3_B_S_Control : out std_logic;
      FSL3_B_S_Exists : out std_logic;
      SPLB3_Clk : in std_logic;
      SPLB3_Rst : in std_logic;
      SPLB3_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB3_PLB_PAValid : in std_logic;
      SPLB3_PLB_SAValid : in std_logic;
      SPLB3_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB3_PLB_RNW : in std_logic;
      SPLB3_PLB_BE : in std_logic_vector(0 to 7);
      SPLB3_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB3_PLB_rdPrim : in std_logic;
      SPLB3_PLB_wrPrim : in std_logic;
      SPLB3_PLB_abort : in std_logic;
      SPLB3_PLB_busLock : in std_logic;
      SPLB3_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB3_PLB_size : in std_logic_vector(0 to 3);
      SPLB3_PLB_type : in std_logic_vector(0 to 2);
      SPLB3_PLB_lockErr : in std_logic;
      SPLB3_PLB_wrPendReq : in std_logic;
      SPLB3_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB3_PLB_rdPendReq : in std_logic;
      SPLB3_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB3_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB3_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB3_PLB_rdBurst : in std_logic;
      SPLB3_PLB_wrBurst : in std_logic;
      SPLB3_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB3_Sl_addrAck : out std_logic;
      SPLB3_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB3_Sl_wait : out std_logic;
      SPLB3_Sl_rearbitrate : out std_logic;
      SPLB3_Sl_wrDAck : out std_logic;
      SPLB3_Sl_wrComp : out std_logic;
      SPLB3_Sl_wrBTerm : out std_logic;
      SPLB3_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB3_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB3_Sl_rdDAck : out std_logic;
      SPLB3_Sl_rdComp : out std_logic;
      SPLB3_Sl_rdBTerm : out std_logic;
      SPLB3_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB3_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB3_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB3_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA3_Clk : in std_logic;
      SDMA3_Rx_IntOut : out std_logic;
      SDMA3_Tx_IntOut : out std_logic;
      SDMA3_RstOut : out std_logic;
      SDMA3_TX_D : out std_logic_vector(0 to 31);
      SDMA3_TX_Rem : out std_logic_vector(0 to 3);
      SDMA3_TX_SOF : out std_logic;
      SDMA3_TX_EOF : out std_logic;
      SDMA3_TX_SOP : out std_logic;
      SDMA3_TX_EOP : out std_logic;
      SDMA3_TX_Src_Rdy : out std_logic;
      SDMA3_TX_Dst_Rdy : in std_logic;
      SDMA3_RX_D : in std_logic_vector(0 to 31);
      SDMA3_RX_Rem : in std_logic_vector(0 to 3);
      SDMA3_RX_SOF : in std_logic;
      SDMA3_RX_EOF : in std_logic;
      SDMA3_RX_SOP : in std_logic;
      SDMA3_RX_EOP : in std_logic;
      SDMA3_RX_Src_Rdy : in std_logic;
      SDMA3_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL3_Clk : in std_logic;
      SDMA_CTRL3_Rst : in std_logic;
      SDMA_CTRL3_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL3_PLB_PAValid : in std_logic;
      SDMA_CTRL3_PLB_SAValid : in std_logic;
      SDMA_CTRL3_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL3_PLB_RNW : in std_logic;
      SDMA_CTRL3_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL3_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL3_PLB_rdPrim : in std_logic;
      SDMA_CTRL3_PLB_wrPrim : in std_logic;
      SDMA_CTRL3_PLB_abort : in std_logic;
      SDMA_CTRL3_PLB_busLock : in std_logic;
      SDMA_CTRL3_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL3_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL3_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL3_PLB_lockErr : in std_logic;
      SDMA_CTRL3_PLB_wrPendReq : in std_logic;
      SDMA_CTRL3_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL3_PLB_rdPendReq : in std_logic;
      SDMA_CTRL3_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL3_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL3_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL3_PLB_rdBurst : in std_logic;
      SDMA_CTRL3_PLB_wrBurst : in std_logic;
      SDMA_CTRL3_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL3_Sl_addrAck : out std_logic;
      SDMA_CTRL3_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL3_Sl_wait : out std_logic;
      SDMA_CTRL3_Sl_rearbitrate : out std_logic;
      SDMA_CTRL3_Sl_wrDAck : out std_logic;
      SDMA_CTRL3_Sl_wrComp : out std_logic;
      SDMA_CTRL3_Sl_wrBTerm : out std_logic;
      SDMA_CTRL3_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL3_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL3_Sl_rdDAck : out std_logic;
      SDMA_CTRL3_Sl_rdComp : out std_logic;
      SDMA_CTRL3_Sl_rdBTerm : out std_logic;
      SDMA_CTRL3_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL3_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL3_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL3_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM3_Addr : in std_logic_vector(31 downto 0);
      PIM3_AddrReq : in std_logic;
      PIM3_AddrAck : out std_logic;
      PIM3_RNW : in std_logic;
      PIM3_Size : in std_logic_vector(3 downto 0);
      PIM3_RdModWr : in std_logic;
      PIM3_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM3_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM3_WrFIFO_Push : in std_logic;
      PIM3_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM3_RdFIFO_Pop : in std_logic;
      PIM3_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM3_WrFIFO_Empty : out std_logic;
      PIM3_WrFIFO_AlmostFull : out std_logic;
      PIM3_WrFIFO_Flush : in std_logic;
      PIM3_RdFIFO_Empty : out std_logic;
      PIM3_RdFIFO_Flush : in std_logic;
      PIM3_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM3_InitDone : out std_logic;
      PPC440MC3_MIMCReadNotWrite : in std_logic;
      PPC440MC3_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC3_MIMCAddressValid : in std_logic;
      PPC440MC3_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC3_MIMCWriteDataValid : in std_logic;
      PPC440MC3_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC3_MIMCBankConflict : in std_logic;
      PPC440MC3_MIMCRowConflict : in std_logic;
      PPC440MC3_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC3_MCMIReadDataValid : out std_logic;
      PPC440MC3_MCMIReadDataErr : out std_logic;
      PPC440MC3_MCMIAddrReadyToAccept : out std_logic;
      VFBC3_Cmd_Clk : in std_logic;
      VFBC3_Cmd_Reset : in std_logic;
      VFBC3_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC3_Cmd_Write : in std_logic;
      VFBC3_Cmd_End : in std_logic;
      VFBC3_Cmd_Full : out std_logic;
      VFBC3_Cmd_Almost_Full : out std_logic;
      VFBC3_Cmd_Idle : out std_logic;
      VFBC3_Wd_Clk : in std_logic;
      VFBC3_Wd_Reset : in std_logic;
      VFBC3_Wd_Write : in std_logic;
      VFBC3_Wd_End_Burst : in std_logic;
      VFBC3_Wd_Flush : in std_logic;
      VFBC3_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC3_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC3_Wd_Full : out std_logic;
      VFBC3_Wd_Almost_Full : out std_logic;
      VFBC3_Rd_Clk : in std_logic;
      VFBC3_Rd_Reset : in std_logic;
      VFBC3_Rd_Read : in std_logic;
      VFBC3_Rd_End_Burst : in std_logic;
      VFBC3_Rd_Flush : in std_logic;
      VFBC3_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC3_Rd_Empty : out std_logic;
      VFBC3_Rd_Almost_Empty : out std_logic;
      MCB3_cmd_clk : in std_logic;
      MCB3_cmd_en : in std_logic;
      MCB3_cmd_instr : in std_logic_vector(2 downto 0);
      MCB3_cmd_bl : in std_logic_vector(5 downto 0);
      MCB3_cmd_byte_addr : in std_logic_vector(29 downto 0);
      MCB3_cmd_empty : out std_logic;
      MCB3_cmd_full : out std_logic;
      MCB3_wr_clk : in std_logic;
      MCB3_wr_en : in std_logic;
      MCB3_wr_mask : in std_logic_vector(7 downto 0);
      MCB3_wr_data : in std_logic_vector(63 downto 0);
      MCB3_wr_full : out std_logic;
      MCB3_wr_empty : out std_logic;
      MCB3_wr_count : out std_logic_vector(6 downto 0);
      MCB3_wr_underrun : out std_logic;
      MCB3_wr_error : out std_logic;
      MCB3_rd_clk : in std_logic;
      MCB3_rd_en : in std_logic;
      MCB3_rd_data : out std_logic_vector(63 downto 0);
      MCB3_rd_full : out std_logic;
      MCB3_rd_empty : out std_logic;
      MCB3_rd_count : out std_logic_vector(6 downto 0);
      MCB3_rd_overflow : out std_logic;
      MCB3_rd_error : out std_logic;
      FSL4_M_Clk : in std_logic;
      FSL4_M_Write : in std_logic;
      FSL4_M_Data : in std_logic_vector(0 to 31);
      FSL4_M_Control : in std_logic;
      FSL4_M_Full : out std_logic;
      FSL4_S_Clk : in std_logic;
      FSL4_S_Read : in std_logic;
      FSL4_S_Data : out std_logic_vector(0 to 31);
      FSL4_S_Control : out std_logic;
      FSL4_S_Exists : out std_logic;
      FSL4_B_M_Clk : in std_logic;
      FSL4_B_M_Write : in std_logic;
      FSL4_B_M_Data : in std_logic_vector(0 to 31);
      FSL4_B_M_Control : in std_logic;
      FSL4_B_M_Full : out std_logic;
      FSL4_B_S_Clk : in std_logic;
      FSL4_B_S_Read : in std_logic;
      FSL4_B_S_Data : out std_logic_vector(0 to 31);
      FSL4_B_S_Control : out std_logic;
      FSL4_B_S_Exists : out std_logic;
      SPLB4_Clk : in std_logic;
      SPLB4_Rst : in std_logic;
      SPLB4_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB4_PLB_PAValid : in std_logic;
      SPLB4_PLB_SAValid : in std_logic;
      SPLB4_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB4_PLB_RNW : in std_logic;
      SPLB4_PLB_BE : in std_logic_vector(0 to 7);
      SPLB4_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB4_PLB_rdPrim : in std_logic;
      SPLB4_PLB_wrPrim : in std_logic;
      SPLB4_PLB_abort : in std_logic;
      SPLB4_PLB_busLock : in std_logic;
      SPLB4_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB4_PLB_size : in std_logic_vector(0 to 3);
      SPLB4_PLB_type : in std_logic_vector(0 to 2);
      SPLB4_PLB_lockErr : in std_logic;
      SPLB4_PLB_wrPendReq : in std_logic;
      SPLB4_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB4_PLB_rdPendReq : in std_logic;
      SPLB4_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB4_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB4_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB4_PLB_rdBurst : in std_logic;
      SPLB4_PLB_wrBurst : in std_logic;
      SPLB4_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB4_Sl_addrAck : out std_logic;
      SPLB4_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB4_Sl_wait : out std_logic;
      SPLB4_Sl_rearbitrate : out std_logic;
      SPLB4_Sl_wrDAck : out std_logic;
      SPLB4_Sl_wrComp : out std_logic;
      SPLB4_Sl_wrBTerm : out std_logic;
      SPLB4_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB4_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB4_Sl_rdDAck : out std_logic;
      SPLB4_Sl_rdComp : out std_logic;
      SPLB4_Sl_rdBTerm : out std_logic;
      SPLB4_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB4_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB4_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB4_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA4_Clk : in std_logic;
      SDMA4_Rx_IntOut : out std_logic;
      SDMA4_Tx_IntOut : out std_logic;
      SDMA4_RstOut : out std_logic;
      SDMA4_TX_D : out std_logic_vector(0 to 31);
      SDMA4_TX_Rem : out std_logic_vector(0 to 3);
      SDMA4_TX_SOF : out std_logic;
      SDMA4_TX_EOF : out std_logic;
      SDMA4_TX_SOP : out std_logic;
      SDMA4_TX_EOP : out std_logic;
      SDMA4_TX_Src_Rdy : out std_logic;
      SDMA4_TX_Dst_Rdy : in std_logic;
      SDMA4_RX_D : in std_logic_vector(0 to 31);
      SDMA4_RX_Rem : in std_logic_vector(0 to 3);
      SDMA4_RX_SOF : in std_logic;
      SDMA4_RX_EOF : in std_logic;
      SDMA4_RX_SOP : in std_logic;
      SDMA4_RX_EOP : in std_logic;
      SDMA4_RX_Src_Rdy : in std_logic;
      SDMA4_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL4_Clk : in std_logic;
      SDMA_CTRL4_Rst : in std_logic;
      SDMA_CTRL4_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL4_PLB_PAValid : in std_logic;
      SDMA_CTRL4_PLB_SAValid : in std_logic;
      SDMA_CTRL4_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL4_PLB_RNW : in std_logic;
      SDMA_CTRL4_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL4_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL4_PLB_rdPrim : in std_logic;
      SDMA_CTRL4_PLB_wrPrim : in std_logic;
      SDMA_CTRL4_PLB_abort : in std_logic;
      SDMA_CTRL4_PLB_busLock : in std_logic;
      SDMA_CTRL4_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL4_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL4_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL4_PLB_lockErr : in std_logic;
      SDMA_CTRL4_PLB_wrPendReq : in std_logic;
      SDMA_CTRL4_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL4_PLB_rdPendReq : in std_logic;
      SDMA_CTRL4_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL4_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL4_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL4_PLB_rdBurst : in std_logic;
      SDMA_CTRL4_PLB_wrBurst : in std_logic;
      SDMA_CTRL4_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL4_Sl_addrAck : out std_logic;
      SDMA_CTRL4_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL4_Sl_wait : out std_logic;
      SDMA_CTRL4_Sl_rearbitrate : out std_logic;
      SDMA_CTRL4_Sl_wrDAck : out std_logic;
      SDMA_CTRL4_Sl_wrComp : out std_logic;
      SDMA_CTRL4_Sl_wrBTerm : out std_logic;
      SDMA_CTRL4_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL4_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL4_Sl_rdDAck : out std_logic;
      SDMA_CTRL4_Sl_rdComp : out std_logic;
      SDMA_CTRL4_Sl_rdBTerm : out std_logic;
      SDMA_CTRL4_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL4_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL4_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL4_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM4_Addr : in std_logic_vector(31 downto 0);
      PIM4_AddrReq : in std_logic;
      PIM4_AddrAck : out std_logic;
      PIM4_RNW : in std_logic;
      PIM4_Size : in std_logic_vector(3 downto 0);
      PIM4_RdModWr : in std_logic;
      PIM4_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM4_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM4_WrFIFO_Push : in std_logic;
      PIM4_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM4_RdFIFO_Pop : in std_logic;
      PIM4_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM4_WrFIFO_Empty : out std_logic;
      PIM4_WrFIFO_AlmostFull : out std_logic;
      PIM4_WrFIFO_Flush : in std_logic;
      PIM4_RdFIFO_Empty : out std_logic;
      PIM4_RdFIFO_Flush : in std_logic;
      PIM4_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM4_InitDone : out std_logic;
      PPC440MC4_MIMCReadNotWrite : in std_logic;
      PPC440MC4_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC4_MIMCAddressValid : in std_logic;
      PPC440MC4_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC4_MIMCWriteDataValid : in std_logic;
      PPC440MC4_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC4_MIMCBankConflict : in std_logic;
      PPC440MC4_MIMCRowConflict : in std_logic;
      PPC440MC4_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC4_MCMIReadDataValid : out std_logic;
      PPC440MC4_MCMIReadDataErr : out std_logic;
      PPC440MC4_MCMIAddrReadyToAccept : out std_logic;
      VFBC4_Cmd_Clk : in std_logic;
      VFBC4_Cmd_Reset : in std_logic;
      VFBC4_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC4_Cmd_Write : in std_logic;
      VFBC4_Cmd_End : in std_logic;
      VFBC4_Cmd_Full : out std_logic;
      VFBC4_Cmd_Almost_Full : out std_logic;
      VFBC4_Cmd_Idle : out std_logic;
      VFBC4_Wd_Clk : in std_logic;
      VFBC4_Wd_Reset : in std_logic;
      VFBC4_Wd_Write : in std_logic;
      VFBC4_Wd_End_Burst : in std_logic;
      VFBC4_Wd_Flush : in std_logic;
      VFBC4_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC4_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC4_Wd_Full : out std_logic;
      VFBC4_Wd_Almost_Full : out std_logic;
      VFBC4_Rd_Clk : in std_logic;
      VFBC4_Rd_Reset : in std_logic;
      VFBC4_Rd_Read : in std_logic;
      VFBC4_Rd_End_Burst : in std_logic;
      VFBC4_Rd_Flush : in std_logic;
      VFBC4_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC4_Rd_Empty : out std_logic;
      VFBC4_Rd_Almost_Empty : out std_logic;
      MCB4_cmd_clk : in std_logic;
      MCB4_cmd_en : in std_logic;
      MCB4_cmd_instr : in std_logic_vector(2 downto 0);
      MCB4_cmd_bl : in std_logic_vector(5 downto 0);
      MCB4_cmd_byte_addr : in std_logic_vector(29 downto 0);
      MCB4_cmd_empty : out std_logic;
      MCB4_cmd_full : out std_logic;
      MCB4_wr_clk : in std_logic;
      MCB4_wr_en : in std_logic;
      MCB4_wr_mask : in std_logic_vector(7 downto 0);
      MCB4_wr_data : in std_logic_vector(63 downto 0);
      MCB4_wr_full : out std_logic;
      MCB4_wr_empty : out std_logic;
      MCB4_wr_count : out std_logic_vector(6 downto 0);
      MCB4_wr_underrun : out std_logic;
      MCB4_wr_error : out std_logic;
      MCB4_rd_clk : in std_logic;
      MCB4_rd_en : in std_logic;
      MCB4_rd_data : out std_logic_vector(63 downto 0);
      MCB4_rd_full : out std_logic;
      MCB4_rd_empty : out std_logic;
      MCB4_rd_count : out std_logic_vector(6 downto 0);
      MCB4_rd_overflow : out std_logic;
      MCB4_rd_error : out std_logic;
      FSL5_M_Clk : in std_logic;
      FSL5_M_Write : in std_logic;
      FSL5_M_Data : in std_logic_vector(0 to 31);
      FSL5_M_Control : in std_logic;
      FSL5_M_Full : out std_logic;
      FSL5_S_Clk : in std_logic;
      FSL5_S_Read : in std_logic;
      FSL5_S_Data : out std_logic_vector(0 to 31);
      FSL5_S_Control : out std_logic;
      FSL5_S_Exists : out std_logic;
      FSL5_B_M_Clk : in std_logic;
      FSL5_B_M_Write : in std_logic;
      FSL5_B_M_Data : in std_logic_vector(0 to 31);
      FSL5_B_M_Control : in std_logic;
      FSL5_B_M_Full : out std_logic;
      FSL5_B_S_Clk : in std_logic;
      FSL5_B_S_Read : in std_logic;
      FSL5_B_S_Data : out std_logic_vector(0 to 31);
      FSL5_B_S_Control : out std_logic;
      FSL5_B_S_Exists : out std_logic;
      SPLB5_Clk : in std_logic;
      SPLB5_Rst : in std_logic;
      SPLB5_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB5_PLB_PAValid : in std_logic;
      SPLB5_PLB_SAValid : in std_logic;
      SPLB5_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB5_PLB_RNW : in std_logic;
      SPLB5_PLB_BE : in std_logic_vector(0 to 7);
      SPLB5_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB5_PLB_rdPrim : in std_logic;
      SPLB5_PLB_wrPrim : in std_logic;
      SPLB5_PLB_abort : in std_logic;
      SPLB5_PLB_busLock : in std_logic;
      SPLB5_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB5_PLB_size : in std_logic_vector(0 to 3);
      SPLB5_PLB_type : in std_logic_vector(0 to 2);
      SPLB5_PLB_lockErr : in std_logic;
      SPLB5_PLB_wrPendReq : in std_logic;
      SPLB5_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB5_PLB_rdPendReq : in std_logic;
      SPLB5_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB5_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB5_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB5_PLB_rdBurst : in std_logic;
      SPLB5_PLB_wrBurst : in std_logic;
      SPLB5_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB5_Sl_addrAck : out std_logic;
      SPLB5_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB5_Sl_wait : out std_logic;
      SPLB5_Sl_rearbitrate : out std_logic;
      SPLB5_Sl_wrDAck : out std_logic;
      SPLB5_Sl_wrComp : out std_logic;
      SPLB5_Sl_wrBTerm : out std_logic;
      SPLB5_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB5_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB5_Sl_rdDAck : out std_logic;
      SPLB5_Sl_rdComp : out std_logic;
      SPLB5_Sl_rdBTerm : out std_logic;
      SPLB5_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB5_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB5_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB5_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA5_Clk : in std_logic;
      SDMA5_Rx_IntOut : out std_logic;
      SDMA5_Tx_IntOut : out std_logic;
      SDMA5_RstOut : out std_logic;
      SDMA5_TX_D : out std_logic_vector(0 to 31);
      SDMA5_TX_Rem : out std_logic_vector(0 to 3);
      SDMA5_TX_SOF : out std_logic;
      SDMA5_TX_EOF : out std_logic;
      SDMA5_TX_SOP : out std_logic;
      SDMA5_TX_EOP : out std_logic;
      SDMA5_TX_Src_Rdy : out std_logic;
      SDMA5_TX_Dst_Rdy : in std_logic;
      SDMA5_RX_D : in std_logic_vector(0 to 31);
      SDMA5_RX_Rem : in std_logic_vector(0 to 3);
      SDMA5_RX_SOF : in std_logic;
      SDMA5_RX_EOF : in std_logic;
      SDMA5_RX_SOP : in std_logic;
      SDMA5_RX_EOP : in std_logic;
      SDMA5_RX_Src_Rdy : in std_logic;
      SDMA5_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL5_Clk : in std_logic;
      SDMA_CTRL5_Rst : in std_logic;
      SDMA_CTRL5_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL5_PLB_PAValid : in std_logic;
      SDMA_CTRL5_PLB_SAValid : in std_logic;
      SDMA_CTRL5_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL5_PLB_RNW : in std_logic;
      SDMA_CTRL5_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL5_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL5_PLB_rdPrim : in std_logic;
      SDMA_CTRL5_PLB_wrPrim : in std_logic;
      SDMA_CTRL5_PLB_abort : in std_logic;
      SDMA_CTRL5_PLB_busLock : in std_logic;
      SDMA_CTRL5_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL5_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL5_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL5_PLB_lockErr : in std_logic;
      SDMA_CTRL5_PLB_wrPendReq : in std_logic;
      SDMA_CTRL5_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL5_PLB_rdPendReq : in std_logic;
      SDMA_CTRL5_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL5_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL5_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL5_PLB_rdBurst : in std_logic;
      SDMA_CTRL5_PLB_wrBurst : in std_logic;
      SDMA_CTRL5_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL5_Sl_addrAck : out std_logic;
      SDMA_CTRL5_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL5_Sl_wait : out std_logic;
      SDMA_CTRL5_Sl_rearbitrate : out std_logic;
      SDMA_CTRL5_Sl_wrDAck : out std_logic;
      SDMA_CTRL5_Sl_wrComp : out std_logic;
      SDMA_CTRL5_Sl_wrBTerm : out std_logic;
      SDMA_CTRL5_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL5_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL5_Sl_rdDAck : out std_logic;
      SDMA_CTRL5_Sl_rdComp : out std_logic;
      SDMA_CTRL5_Sl_rdBTerm : out std_logic;
      SDMA_CTRL5_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL5_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL5_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL5_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM5_Addr : in std_logic_vector(31 downto 0);
      PIM5_AddrReq : in std_logic;
      PIM5_AddrAck : out std_logic;
      PIM5_RNW : in std_logic;
      PIM5_Size : in std_logic_vector(3 downto 0);
      PIM5_RdModWr : in std_logic;
      PIM5_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM5_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM5_WrFIFO_Push : in std_logic;
      PIM5_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM5_RdFIFO_Pop : in std_logic;
      PIM5_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM5_WrFIFO_Empty : out std_logic;
      PIM5_WrFIFO_AlmostFull : out std_logic;
      PIM5_WrFIFO_Flush : in std_logic;
      PIM5_RdFIFO_Empty : out std_logic;
      PIM5_RdFIFO_Flush : in std_logic;
      PIM5_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM5_InitDone : out std_logic;
      PPC440MC5_MIMCReadNotWrite : in std_logic;
      PPC440MC5_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC5_MIMCAddressValid : in std_logic;
      PPC440MC5_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC5_MIMCWriteDataValid : in std_logic;
      PPC440MC5_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC5_MIMCBankConflict : in std_logic;
      PPC440MC5_MIMCRowConflict : in std_logic;
      PPC440MC5_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC5_MCMIReadDataValid : out std_logic;
      PPC440MC5_MCMIReadDataErr : out std_logic;
      PPC440MC5_MCMIAddrReadyToAccept : out std_logic;
      VFBC5_Cmd_Clk : in std_logic;
      VFBC5_Cmd_Reset : in std_logic;
      VFBC5_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC5_Cmd_Write : in std_logic;
      VFBC5_Cmd_End : in std_logic;
      VFBC5_Cmd_Full : out std_logic;
      VFBC5_Cmd_Almost_Full : out std_logic;
      VFBC5_Cmd_Idle : out std_logic;
      VFBC5_Wd_Clk : in std_logic;
      VFBC5_Wd_Reset : in std_logic;
      VFBC5_Wd_Write : in std_logic;
      VFBC5_Wd_End_Burst : in std_logic;
      VFBC5_Wd_Flush : in std_logic;
      VFBC5_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC5_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC5_Wd_Full : out std_logic;
      VFBC5_Wd_Almost_Full : out std_logic;
      VFBC5_Rd_Clk : in std_logic;
      VFBC5_Rd_Reset : in std_logic;
      VFBC5_Rd_Read : in std_logic;
      VFBC5_Rd_End_Burst : in std_logic;
      VFBC5_Rd_Flush : in std_logic;
      VFBC5_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC5_Rd_Empty : out std_logic;
      VFBC5_Rd_Almost_Empty : out std_logic;
      MCB5_cmd_clk : in std_logic;
      MCB5_cmd_en : in std_logic;
      MCB5_cmd_instr : in std_logic_vector(2 downto 0);
      MCB5_cmd_bl : in std_logic_vector(5 downto 0);
      MCB5_cmd_byte_addr : in std_logic_vector(29 downto 0);
      MCB5_cmd_empty : out std_logic;
      MCB5_cmd_full : out std_logic;
      MCB5_wr_clk : in std_logic;
      MCB5_wr_en : in std_logic;
      MCB5_wr_mask : in std_logic_vector(7 downto 0);
      MCB5_wr_data : in std_logic_vector(63 downto 0);
      MCB5_wr_full : out std_logic;
      MCB5_wr_empty : out std_logic;
      MCB5_wr_count : out std_logic_vector(6 downto 0);
      MCB5_wr_underrun : out std_logic;
      MCB5_wr_error : out std_logic;
      MCB5_rd_clk : in std_logic;
      MCB5_rd_en : in std_logic;
      MCB5_rd_data : out std_logic_vector(63 downto 0);
      MCB5_rd_full : out std_logic;
      MCB5_rd_empty : out std_logic;
      MCB5_rd_count : out std_logic_vector(6 downto 0);
      MCB5_rd_overflow : out std_logic;
      MCB5_rd_error : out std_logic;
      FSL6_M_Clk : in std_logic;
      FSL6_M_Write : in std_logic;
      FSL6_M_Data : in std_logic_vector(0 to 31);
      FSL6_M_Control : in std_logic;
      FSL6_M_Full : out std_logic;
      FSL6_S_Clk : in std_logic;
      FSL6_S_Read : in std_logic;
      FSL6_S_Data : out std_logic_vector(0 to 31);
      FSL6_S_Control : out std_logic;
      FSL6_S_Exists : out std_logic;
      FSL6_B_M_Clk : in std_logic;
      FSL6_B_M_Write : in std_logic;
      FSL6_B_M_Data : in std_logic_vector(0 to 31);
      FSL6_B_M_Control : in std_logic;
      FSL6_B_M_Full : out std_logic;
      FSL6_B_S_Clk : in std_logic;
      FSL6_B_S_Read : in std_logic;
      FSL6_B_S_Data : out std_logic_vector(0 to 31);
      FSL6_B_S_Control : out std_logic;
      FSL6_B_S_Exists : out std_logic;
      SPLB6_Clk : in std_logic;
      SPLB6_Rst : in std_logic;
      SPLB6_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB6_PLB_PAValid : in std_logic;
      SPLB6_PLB_SAValid : in std_logic;
      SPLB6_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB6_PLB_RNW : in std_logic;
      SPLB6_PLB_BE : in std_logic_vector(0 to 7);
      SPLB6_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB6_PLB_rdPrim : in std_logic;
      SPLB6_PLB_wrPrim : in std_logic;
      SPLB6_PLB_abort : in std_logic;
      SPLB6_PLB_busLock : in std_logic;
      SPLB6_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB6_PLB_size : in std_logic_vector(0 to 3);
      SPLB6_PLB_type : in std_logic_vector(0 to 2);
      SPLB6_PLB_lockErr : in std_logic;
      SPLB6_PLB_wrPendReq : in std_logic;
      SPLB6_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB6_PLB_rdPendReq : in std_logic;
      SPLB6_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB6_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB6_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB6_PLB_rdBurst : in std_logic;
      SPLB6_PLB_wrBurst : in std_logic;
      SPLB6_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB6_Sl_addrAck : out std_logic;
      SPLB6_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB6_Sl_wait : out std_logic;
      SPLB6_Sl_rearbitrate : out std_logic;
      SPLB6_Sl_wrDAck : out std_logic;
      SPLB6_Sl_wrComp : out std_logic;
      SPLB6_Sl_wrBTerm : out std_logic;
      SPLB6_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB6_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB6_Sl_rdDAck : out std_logic;
      SPLB6_Sl_rdComp : out std_logic;
      SPLB6_Sl_rdBTerm : out std_logic;
      SPLB6_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB6_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB6_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB6_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA6_Clk : in std_logic;
      SDMA6_Rx_IntOut : out std_logic;
      SDMA6_Tx_IntOut : out std_logic;
      SDMA6_RstOut : out std_logic;
      SDMA6_TX_D : out std_logic_vector(0 to 31);
      SDMA6_TX_Rem : out std_logic_vector(0 to 3);
      SDMA6_TX_SOF : out std_logic;
      SDMA6_TX_EOF : out std_logic;
      SDMA6_TX_SOP : out std_logic;
      SDMA6_TX_EOP : out std_logic;
      SDMA6_TX_Src_Rdy : out std_logic;
      SDMA6_TX_Dst_Rdy : in std_logic;
      SDMA6_RX_D : in std_logic_vector(0 to 31);
      SDMA6_RX_Rem : in std_logic_vector(0 to 3);
      SDMA6_RX_SOF : in std_logic;
      SDMA6_RX_EOF : in std_logic;
      SDMA6_RX_SOP : in std_logic;
      SDMA6_RX_EOP : in std_logic;
      SDMA6_RX_Src_Rdy : in std_logic;
      SDMA6_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL6_Clk : in std_logic;
      SDMA_CTRL6_Rst : in std_logic;
      SDMA_CTRL6_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL6_PLB_PAValid : in std_logic;
      SDMA_CTRL6_PLB_SAValid : in std_logic;
      SDMA_CTRL6_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL6_PLB_RNW : in std_logic;
      SDMA_CTRL6_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL6_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL6_PLB_rdPrim : in std_logic;
      SDMA_CTRL6_PLB_wrPrim : in std_logic;
      SDMA_CTRL6_PLB_abort : in std_logic;
      SDMA_CTRL6_PLB_busLock : in std_logic;
      SDMA_CTRL6_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL6_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL6_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL6_PLB_lockErr : in std_logic;
      SDMA_CTRL6_PLB_wrPendReq : in std_logic;
      SDMA_CTRL6_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL6_PLB_rdPendReq : in std_logic;
      SDMA_CTRL6_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL6_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL6_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL6_PLB_rdBurst : in std_logic;
      SDMA_CTRL6_PLB_wrBurst : in std_logic;
      SDMA_CTRL6_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL6_Sl_addrAck : out std_logic;
      SDMA_CTRL6_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL6_Sl_wait : out std_logic;
      SDMA_CTRL6_Sl_rearbitrate : out std_logic;
      SDMA_CTRL6_Sl_wrDAck : out std_logic;
      SDMA_CTRL6_Sl_wrComp : out std_logic;
      SDMA_CTRL6_Sl_wrBTerm : out std_logic;
      SDMA_CTRL6_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL6_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL6_Sl_rdDAck : out std_logic;
      SDMA_CTRL6_Sl_rdComp : out std_logic;
      SDMA_CTRL6_Sl_rdBTerm : out std_logic;
      SDMA_CTRL6_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL6_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL6_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL6_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM6_Addr : in std_logic_vector(31 downto 0);
      PIM6_AddrReq : in std_logic;
      PIM6_AddrAck : out std_logic;
      PIM6_RNW : in std_logic;
      PIM6_Size : in std_logic_vector(3 downto 0);
      PIM6_RdModWr : in std_logic;
      PIM6_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM6_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM6_WrFIFO_Push : in std_logic;
      PIM6_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM6_RdFIFO_Pop : in std_logic;
      PIM6_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM6_WrFIFO_Empty : out std_logic;
      PIM6_WrFIFO_AlmostFull : out std_logic;
      PIM6_WrFIFO_Flush : in std_logic;
      PIM6_RdFIFO_Empty : out std_logic;
      PIM6_RdFIFO_Flush : in std_logic;
      PIM6_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM6_InitDone : out std_logic;
      PPC440MC6_MIMCReadNotWrite : in std_logic;
      PPC440MC6_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC6_MIMCAddressValid : in std_logic;
      PPC440MC6_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC6_MIMCWriteDataValid : in std_logic;
      PPC440MC6_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC6_MIMCBankConflict : in std_logic;
      PPC440MC6_MIMCRowConflict : in std_logic;
      PPC440MC6_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC6_MCMIReadDataValid : out std_logic;
      PPC440MC6_MCMIReadDataErr : out std_logic;
      PPC440MC6_MCMIAddrReadyToAccept : out std_logic;
      VFBC6_Cmd_Clk : in std_logic;
      VFBC6_Cmd_Reset : in std_logic;
      VFBC6_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC6_Cmd_Write : in std_logic;
      VFBC6_Cmd_End : in std_logic;
      VFBC6_Cmd_Full : out std_logic;
      VFBC6_Cmd_Almost_Full : out std_logic;
      VFBC6_Cmd_Idle : out std_logic;
      VFBC6_Wd_Clk : in std_logic;
      VFBC6_Wd_Reset : in std_logic;
      VFBC6_Wd_Write : in std_logic;
      VFBC6_Wd_End_Burst : in std_logic;
      VFBC6_Wd_Flush : in std_logic;
      VFBC6_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC6_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC6_Wd_Full : out std_logic;
      VFBC6_Wd_Almost_Full : out std_logic;
      VFBC6_Rd_Clk : in std_logic;
      VFBC6_Rd_Reset : in std_logic;
      VFBC6_Rd_Read : in std_logic;
      VFBC6_Rd_End_Burst : in std_logic;
      VFBC6_Rd_Flush : in std_logic;
      VFBC6_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC6_Rd_Empty : out std_logic;
      VFBC6_Rd_Almost_Empty : out std_logic;
      MCB6_cmd_clk : in std_logic;
      MCB6_cmd_en : in std_logic;
      MCB6_cmd_instr : in std_logic_vector(2 downto 0);
      MCB6_cmd_bl : in std_logic_vector(5 downto 0);
      MCB6_cmd_byte_addr : in std_logic_vector(29 downto 0);
      MCB6_cmd_empty : out std_logic;
      MCB6_cmd_full : out std_logic;
      MCB6_wr_clk : in std_logic;
      MCB6_wr_en : in std_logic;
      MCB6_wr_mask : in std_logic_vector(7 downto 0);
      MCB6_wr_data : in std_logic_vector(63 downto 0);
      MCB6_wr_full : out std_logic;
      MCB6_wr_empty : out std_logic;
      MCB6_wr_count : out std_logic_vector(6 downto 0);
      MCB6_wr_underrun : out std_logic;
      MCB6_wr_error : out std_logic;
      MCB6_rd_clk : in std_logic;
      MCB6_rd_en : in std_logic;
      MCB6_rd_data : out std_logic_vector(63 downto 0);
      MCB6_rd_full : out std_logic;
      MCB6_rd_empty : out std_logic;
      MCB6_rd_count : out std_logic_vector(6 downto 0);
      MCB6_rd_overflow : out std_logic;
      MCB6_rd_error : out std_logic;
      FSL7_M_Clk : in std_logic;
      FSL7_M_Write : in std_logic;
      FSL7_M_Data : in std_logic_vector(0 to 31);
      FSL7_M_Control : in std_logic;
      FSL7_M_Full : out std_logic;
      FSL7_S_Clk : in std_logic;
      FSL7_S_Read : in std_logic;
      FSL7_S_Data : out std_logic_vector(0 to 31);
      FSL7_S_Control : out std_logic;
      FSL7_S_Exists : out std_logic;
      FSL7_B_M_Clk : in std_logic;
      FSL7_B_M_Write : in std_logic;
      FSL7_B_M_Data : in std_logic_vector(0 to 31);
      FSL7_B_M_Control : in std_logic;
      FSL7_B_M_Full : out std_logic;
      FSL7_B_S_Clk : in std_logic;
      FSL7_B_S_Read : in std_logic;
      FSL7_B_S_Data : out std_logic_vector(0 to 31);
      FSL7_B_S_Control : out std_logic;
      FSL7_B_S_Exists : out std_logic;
      SPLB7_Clk : in std_logic;
      SPLB7_Rst : in std_logic;
      SPLB7_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB7_PLB_PAValid : in std_logic;
      SPLB7_PLB_SAValid : in std_logic;
      SPLB7_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB7_PLB_RNW : in std_logic;
      SPLB7_PLB_BE : in std_logic_vector(0 to 7);
      SPLB7_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB7_PLB_rdPrim : in std_logic;
      SPLB7_PLB_wrPrim : in std_logic;
      SPLB7_PLB_abort : in std_logic;
      SPLB7_PLB_busLock : in std_logic;
      SPLB7_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB7_PLB_size : in std_logic_vector(0 to 3);
      SPLB7_PLB_type : in std_logic_vector(0 to 2);
      SPLB7_PLB_lockErr : in std_logic;
      SPLB7_PLB_wrPendReq : in std_logic;
      SPLB7_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB7_PLB_rdPendReq : in std_logic;
      SPLB7_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB7_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB7_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB7_PLB_rdBurst : in std_logic;
      SPLB7_PLB_wrBurst : in std_logic;
      SPLB7_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB7_Sl_addrAck : out std_logic;
      SPLB7_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB7_Sl_wait : out std_logic;
      SPLB7_Sl_rearbitrate : out std_logic;
      SPLB7_Sl_wrDAck : out std_logic;
      SPLB7_Sl_wrComp : out std_logic;
      SPLB7_Sl_wrBTerm : out std_logic;
      SPLB7_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB7_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB7_Sl_rdDAck : out std_logic;
      SPLB7_Sl_rdComp : out std_logic;
      SPLB7_Sl_rdBTerm : out std_logic;
      SPLB7_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB7_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB7_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB7_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA7_Clk : in std_logic;
      SDMA7_Rx_IntOut : out std_logic;
      SDMA7_Tx_IntOut : out std_logic;
      SDMA7_RstOut : out std_logic;
      SDMA7_TX_D : out std_logic_vector(0 to 31);
      SDMA7_TX_Rem : out std_logic_vector(0 to 3);
      SDMA7_TX_SOF : out std_logic;
      SDMA7_TX_EOF : out std_logic;
      SDMA7_TX_SOP : out std_logic;
      SDMA7_TX_EOP : out std_logic;
      SDMA7_TX_Src_Rdy : out std_logic;
      SDMA7_TX_Dst_Rdy : in std_logic;
      SDMA7_RX_D : in std_logic_vector(0 to 31);
      SDMA7_RX_Rem : in std_logic_vector(0 to 3);
      SDMA7_RX_SOF : in std_logic;
      SDMA7_RX_EOF : in std_logic;
      SDMA7_RX_SOP : in std_logic;
      SDMA7_RX_EOP : in std_logic;
      SDMA7_RX_Src_Rdy : in std_logic;
      SDMA7_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL7_Clk : in std_logic;
      SDMA_CTRL7_Rst : in std_logic;
      SDMA_CTRL7_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL7_PLB_PAValid : in std_logic;
      SDMA_CTRL7_PLB_SAValid : in std_logic;
      SDMA_CTRL7_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL7_PLB_RNW : in std_logic;
      SDMA_CTRL7_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL7_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL7_PLB_rdPrim : in std_logic;
      SDMA_CTRL7_PLB_wrPrim : in std_logic;
      SDMA_CTRL7_PLB_abort : in std_logic;
      SDMA_CTRL7_PLB_busLock : in std_logic;
      SDMA_CTRL7_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL7_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL7_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL7_PLB_lockErr : in std_logic;
      SDMA_CTRL7_PLB_wrPendReq : in std_logic;
      SDMA_CTRL7_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL7_PLB_rdPendReq : in std_logic;
      SDMA_CTRL7_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL7_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL7_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL7_PLB_rdBurst : in std_logic;
      SDMA_CTRL7_PLB_wrBurst : in std_logic;
      SDMA_CTRL7_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL7_Sl_addrAck : out std_logic;
      SDMA_CTRL7_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL7_Sl_wait : out std_logic;
      SDMA_CTRL7_Sl_rearbitrate : out std_logic;
      SDMA_CTRL7_Sl_wrDAck : out std_logic;
      SDMA_CTRL7_Sl_wrComp : out std_logic;
      SDMA_CTRL7_Sl_wrBTerm : out std_logic;
      SDMA_CTRL7_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL7_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL7_Sl_rdDAck : out std_logic;
      SDMA_CTRL7_Sl_rdComp : out std_logic;
      SDMA_CTRL7_Sl_rdBTerm : out std_logic;
      SDMA_CTRL7_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL7_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL7_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL7_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM7_Addr : in std_logic_vector(31 downto 0);
      PIM7_AddrReq : in std_logic;
      PIM7_AddrAck : out std_logic;
      PIM7_RNW : in std_logic;
      PIM7_Size : in std_logic_vector(3 downto 0);
      PIM7_RdModWr : in std_logic;
      PIM7_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM7_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM7_WrFIFO_Push : in std_logic;
      PIM7_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM7_RdFIFO_Pop : in std_logic;
      PIM7_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM7_WrFIFO_Empty : out std_logic;
      PIM7_WrFIFO_AlmostFull : out std_logic;
      PIM7_WrFIFO_Flush : in std_logic;
      PIM7_RdFIFO_Empty : out std_logic;
      PIM7_RdFIFO_Flush : in std_logic;
      PIM7_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM7_InitDone : out std_logic;
      PPC440MC7_MIMCReadNotWrite : in std_logic;
      PPC440MC7_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC7_MIMCAddressValid : in std_logic;
      PPC440MC7_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC7_MIMCWriteDataValid : in std_logic;
      PPC440MC7_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC7_MIMCBankConflict : in std_logic;
      PPC440MC7_MIMCRowConflict : in std_logic;
      PPC440MC7_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC7_MCMIReadDataValid : out std_logic;
      PPC440MC7_MCMIReadDataErr : out std_logic;
      PPC440MC7_MCMIAddrReadyToAccept : out std_logic;
      VFBC7_Cmd_Clk : in std_logic;
      VFBC7_Cmd_Reset : in std_logic;
      VFBC7_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC7_Cmd_Write : in std_logic;
      VFBC7_Cmd_End : in std_logic;
      VFBC7_Cmd_Full : out std_logic;
      VFBC7_Cmd_Almost_Full : out std_logic;
      VFBC7_Cmd_Idle : out std_logic;
      VFBC7_Wd_Clk : in std_logic;
      VFBC7_Wd_Reset : in std_logic;
      VFBC7_Wd_Write : in std_logic;
      VFBC7_Wd_End_Burst : in std_logic;
      VFBC7_Wd_Flush : in std_logic;
      VFBC7_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC7_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC7_Wd_Full : out std_logic;
      VFBC7_Wd_Almost_Full : out std_logic;
      VFBC7_Rd_Clk : in std_logic;
      VFBC7_Rd_Reset : in std_logic;
      VFBC7_Rd_Read : in std_logic;
      VFBC7_Rd_End_Burst : in std_logic;
      VFBC7_Rd_Flush : in std_logic;
      VFBC7_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC7_Rd_Empty : out std_logic;
      VFBC7_Rd_Almost_Empty : out std_logic;
      MCB7_cmd_clk : in std_logic;
      MCB7_cmd_en : in std_logic;
      MCB7_cmd_instr : in std_logic_vector(2 downto 0);
      MCB7_cmd_bl : in std_logic_vector(5 downto 0);
      MCB7_cmd_byte_addr : in std_logic_vector(29 downto 0);
      MCB7_cmd_empty : out std_logic;
      MCB7_cmd_full : out std_logic;
      MCB7_wr_clk : in std_logic;
      MCB7_wr_en : in std_logic;
      MCB7_wr_mask : in std_logic_vector(7 downto 0);
      MCB7_wr_data : in std_logic_vector(63 downto 0);
      MCB7_wr_full : out std_logic;
      MCB7_wr_empty : out std_logic;
      MCB7_wr_count : out std_logic_vector(6 downto 0);
      MCB7_wr_underrun : out std_logic;
      MCB7_wr_error : out std_logic;
      MCB7_rd_clk : in std_logic;
      MCB7_rd_en : in std_logic;
      MCB7_rd_data : out std_logic_vector(63 downto 0);
      MCB7_rd_full : out std_logic;
      MCB7_rd_empty : out std_logic;
      MCB7_rd_count : out std_logic_vector(6 downto 0);
      MCB7_rd_overflow : out std_logic;
      MCB7_rd_error : out std_logic;
      MPMC_CTRL_Clk : in std_logic;
      MPMC_CTRL_Rst : in std_logic;
      MPMC_CTRL_PLB_ABus : in std_logic_vector(0 to 31);
      MPMC_CTRL_PLB_PAValid : in std_logic;
      MPMC_CTRL_PLB_SAValid : in std_logic;
      MPMC_CTRL_PLB_masterID : in std_logic_vector(0 to 0);
      MPMC_CTRL_PLB_RNW : in std_logic;
      MPMC_CTRL_PLB_BE : in std_logic_vector(0 to 15);
      MPMC_CTRL_PLB_UABus : in std_logic_vector(0 to 31);
      MPMC_CTRL_PLB_rdPrim : in std_logic;
      MPMC_CTRL_PLB_wrPrim : in std_logic;
      MPMC_CTRL_PLB_abort : in std_logic;
      MPMC_CTRL_PLB_busLock : in std_logic;
      MPMC_CTRL_PLB_MSize : in std_logic_vector(0 to 1);
      MPMC_CTRL_PLB_size : in std_logic_vector(0 to 3);
      MPMC_CTRL_PLB_type : in std_logic_vector(0 to 2);
      MPMC_CTRL_PLB_lockErr : in std_logic;
      MPMC_CTRL_PLB_wrPendReq : in std_logic;
      MPMC_CTRL_PLB_wrPendPri : in std_logic_vector(0 to 1);
      MPMC_CTRL_PLB_rdPendReq : in std_logic;
      MPMC_CTRL_PLB_rdPendPri : in std_logic_vector(0 to 1);
      MPMC_CTRL_PLB_reqPri : in std_logic_vector(0 to 1);
      MPMC_CTRL_PLB_TAttribute : in std_logic_vector(0 to 15);
      MPMC_CTRL_PLB_rdBurst : in std_logic;
      MPMC_CTRL_PLB_wrBurst : in std_logic;
      MPMC_CTRL_PLB_wrDBus : in std_logic_vector(0 to 127);
      MPMC_CTRL_Sl_addrAck : out std_logic;
      MPMC_CTRL_Sl_SSize : out std_logic_vector(0 to 1);
      MPMC_CTRL_Sl_wait : out std_logic;
      MPMC_CTRL_Sl_rearbitrate : out std_logic;
      MPMC_CTRL_Sl_wrDAck : out std_logic;
      MPMC_CTRL_Sl_wrComp : out std_logic;
      MPMC_CTRL_Sl_wrBTerm : out std_logic;
      MPMC_CTRL_Sl_rdDBus : out std_logic_vector(0 to 127);
      MPMC_CTRL_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      MPMC_CTRL_Sl_rdDAck : out std_logic;
      MPMC_CTRL_Sl_rdComp : out std_logic;
      MPMC_CTRL_Sl_rdBTerm : out std_logic;
      MPMC_CTRL_Sl_MBusy : out std_logic_vector(0 to 0);
      MPMC_CTRL_Sl_MRdErr : out std_logic_vector(0 to 0);
      MPMC_CTRL_Sl_MWrErr : out std_logic_vector(0 to 0);
      MPMC_CTRL_Sl_MIRQ : out std_logic_vector(0 to 0);
      MPMC_Clk0 : in std_logic;
      MPMC_Clk0_DIV2 : in std_logic;
      MPMC_Clk90 : in std_logic;
      MPMC_Clk_200MHz : in std_logic;
      MPMC_Rst : in std_logic;
      MPMC_Clk_Mem : in std_logic;
      MPMC_Clk_Mem_2x : in std_logic;
      MPMC_Clk_Mem_2x_180 : in std_logic;
      MPMC_Clk_Mem_2x_CE0 : in std_logic;
      MPMC_Clk_Mem_2x_CE90 : in std_logic;
      MPMC_Clk_Wr_I0 : in std_logic;
      MPMC_Clk_Wr_O0 : in std_logic;
      MPMC_Clk_Wr_I1 : in std_logic;
      MPMC_Clk_Wr_O1 : in std_logic;
      MPMC_PLL_Lock : in std_logic;
      MPMC_Idelayctrl_Rdy_I : in std_logic;
      MPMC_Idelayctrl_Rdy_O : out std_logic;
      MPMC_InitDone : out std_logic;
      MPMC_ECC_Intr : out std_logic;
      MPMC_DCM_PSEN : out std_logic;
      MPMC_DCM_PSINCDEC : out std_logic;
      MPMC_DCM_PSDONE : in std_logic;
      SDRAM_Clk : out std_logic_vector(0 to 0);
      SDRAM_CE : out std_logic_vector(0 to 0);
      SDRAM_CS_n : out std_logic_vector(1 downto 0);
      SDRAM_RAS_n : out std_logic;
      SDRAM_CAS_n : out std_logic;
      SDRAM_WE_n : out std_logic;
      SDRAM_BankAddr : out std_logic_vector(1 downto 0);
      SDRAM_Addr : out std_logic_vector(13 downto 0);
      SDRAM_DQ : inout std_logic_vector(39 downto 0);
      SDRAM_DM : out std_logic_vector(4 downto 0);
      DDR_Clk : out std_logic_vector(0 to 0);
      DDR_Clk_n : out std_logic_vector(0 to 0);
      DDR_CE : out std_logic_vector(0 to 0);
      DDR_CS_n : out std_logic_vector(1 downto 0);
      DDR_RAS_n : out std_logic;
      DDR_CAS_n : out std_logic;
      DDR_WE_n : out std_logic;
      DDR_BankAddr : out std_logic_vector(1 downto 0);
      DDR_Addr : out std_logic_vector(13 downto 0);
      DDR_DQ : inout std_logic_vector(39 downto 0);
      DDR_DM : out std_logic_vector(4 downto 0);
      DDR_DQS : inout std_logic_vector(4 downto 0);
      DDR_DQS_Div_O : out std_logic;
      DDR_DQS_Div_I : in std_logic;
      DDR2_Clk : out std_logic_vector(0 to 0);
      DDR2_Clk_n : out std_logic_vector(0 to 0);
      DDR2_CE : out std_logic_vector(0 to 0);
      DDR2_CS_n : out std_logic_vector(1 downto 0);
      DDR2_ODT : out std_logic_vector(0 to 0);
      DDR2_RAS_n : out std_logic;
      DDR2_CAS_n : out std_logic;
      DDR2_WE_n : out std_logic;
      DDR2_BankAddr : out std_logic_vector(1 downto 0);
      DDR2_Addr : out std_logic_vector(13 downto 0);
      DDR2_DQ : inout std_logic_vector(39 downto 0);
      DDR2_DM : out std_logic_vector(4 downto 0);
      DDR2_DQS : inout std_logic_vector(4 downto 0);
      DDR2_DQS_n : inout std_logic_vector(4 downto 0);
      DDR2_DQS_Div_O : out std_logic;
      DDR2_DQS_Div_I : in std_logic;
      DDR3_Clk : out std_logic_vector(0 to 0);
      DDR3_Clk_n : out std_logic_vector(0 to 0);
      DDR3_CE : out std_logic_vector(0 to 0);
      DDR3_CS_n : out std_logic_vector(1 downto 0);
      DDR3_ODT : out std_logic_vector(0 to 0);
      DDR3_RAS_n : out std_logic;
      DDR3_CAS_n : out std_logic;
      DDR3_WE_n : out std_logic;
      DDR3_BankAddr : out std_logic_vector(1 downto 0);
      DDR3_Addr : out std_logic_vector(13 downto 0);
      DDR3_DQ : inout std_logic_vector(39 downto 0);
      DDR3_DM : out std_logic_vector(4 downto 0);
      DDR3_Reset_n : out std_logic;
      DDR3_DQS : inout std_logic_vector(4 downto 0);
      DDR3_DQS_n : inout std_logic_vector(4 downto 0);
      mcbx_dram_addr : out std_logic_vector(13 downto 0);
      mcbx_dram_ba : out std_logic_vector(1 downto 0);
      mcbx_dram_ras_n : out std_logic;
      mcbx_dram_cas_n : out std_logic;
      mcbx_dram_we_n : out std_logic;
      mcbx_dram_cke : out std_logic;
      mcbx_dram_clk : out std_logic;
      mcbx_dram_clk_n : out std_logic;
      mcbx_dram_dq : inout std_logic_vector(31 downto 0);
      mcbx_dram_dqs : inout std_logic;
      mcbx_dram_dqs_n : inout std_logic;
      mcbx_dram_udqs : inout std_logic;
      mcbx_dram_udqs_n : inout std_logic;
      mcbx_dram_udm : out std_logic;
      mcbx_dram_ldm : out std_logic;
      mcbx_dram_odt : out std_logic;
      mcbx_dram_ddr3_rst : out std_logic;
      selfrefresh_enter : in std_logic;
      selfrefresh_mode : out std_logic;
      calib_recal : in std_logic;
      rzq : inout std_logic;
      zio : inout std_logic
    );
  end component;

  component qmfir_0_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 15);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 127);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 127);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 0);
      Sl_MWrErr : out std_logic_vector(0 to 0);
      Sl_MRdErr : out std_logic_vector(0 to 0);
      Sl_MIRQ : out std_logic_vector(0 to 0);
      IP2INTC_Irpt : out std_logic
    );
  end component;

  component IOBUF is
    port (
      I : in std_logic;
      IO : inout std_logic;
      O : out std_logic;
      T : in std_logic
    );
  end component;

  -- Internal signals

  signal Dcm_all_locked : std_logic;
  signal Hard_Ethernet_MAC_TemacIntc0_Irpt : std_logic;
  signal Hard_Ethernet_MAC_fifo_IP2INTC_Irpt : std_logic;
  signal Hard_Ethernet_MAC_llink0_LL_RST_ACK : std_logic;
  signal Hard_Ethernet_MAC_llink0_LL_Rx_Data : std_logic_vector(0 to 31);
  signal Hard_Ethernet_MAC_llink0_LL_Rx_DstRdy_n : std_logic;
  signal Hard_Ethernet_MAC_llink0_LL_Rx_EOF_n : std_logic;
  signal Hard_Ethernet_MAC_llink0_LL_Rx_EOP_n : std_logic;
  signal Hard_Ethernet_MAC_llink0_LL_Rx_Rem : std_logic_vector(0 to 3);
  signal Hard_Ethernet_MAC_llink0_LL_Rx_SOF_n : std_logic;
  signal Hard_Ethernet_MAC_llink0_LL_Rx_SOP_n : std_logic;
  signal Hard_Ethernet_MAC_llink0_LL_Rx_SrcRdy_n : std_logic;
  signal Hard_Ethernet_MAC_llink0_LL_Tx_Data : std_logic_vector(0 to 31);
  signal Hard_Ethernet_MAC_llink0_LL_Tx_DstRdy_n : std_logic;
  signal Hard_Ethernet_MAC_llink0_LL_Tx_EOF_n : std_logic;
  signal Hard_Ethernet_MAC_llink0_LL_Tx_EOP_n : std_logic;
  signal Hard_Ethernet_MAC_llink0_LL_Tx_Rem : std_logic_vector(0 to 3);
  signal Hard_Ethernet_MAC_llink0_LL_Tx_SOF_n : std_logic;
  signal Hard_Ethernet_MAC_llink0_LL_Tx_SOP_n : std_logic;
  signal Hard_Ethernet_MAC_llink0_LL_Tx_SrcRdy_n : std_logic;
  signal RS232_0_Interrupt : std_logic;
  signal clk_125_0000MHz90PLL0_ADJUST : std_logic;
  signal clk_125_0000MHzPLL0_ADJUST : std_logic;
  signal clk_200_0000MHz : std_logic;
  signal clk_250_0000MHzPLL0 : std_logic;
  signal dcm_clk_s : std_logic;
  signal fpga_0_Hard_Ethernet_MAC_MDIO_0_pin_I : std_logic;
  signal fpga_0_Hard_Ethernet_MAC_MDIO_0_pin_O : std_logic;
  signal fpga_0_Hard_Ethernet_MAC_MDIO_0_pin_T : std_logic;
  signal net_gnd0 : std_logic;
  signal net_gnd1 : std_logic_vector(0 to 0);
  signal net_gnd2 : std_logic_vector(0 to 1);
  signal net_gnd3 : std_logic_vector(0 to 2);
  signal net_gnd4 : std_logic_vector(0 to 3);
  signal net_gnd5 : std_logic_vector(0 to 4);
  signal net_gnd6 : std_logic_vector(5 downto 0);
  signal net_gnd8 : std_logic_vector(0 to 7);
  signal net_gnd10 : std_logic_vector(0 to 9);
  signal net_gnd16 : std_logic_vector(15 downto 0);
  signal net_gnd30 : std_logic_vector(29 downto 0);
  signal net_gnd32 : std_logic_vector(31 downto 0);
  signal net_gnd36 : std_logic_vector(0 to 35);
  signal net_gnd64 : std_logic_vector(0 to 63);
  signal net_gnd128 : std_logic_vector(0 to 127);
  signal net_vcc0 : std_logic;
  signal net_vcc4 : std_logic_vector(0 to 3);
  signal pgassign1 : std_logic_vector(0 to 0);
  signal pgassign2 : std_logic_vector(0 to 0);
  signal pgassign3 : std_logic_vector(0 to 0);
  signal pgassign4 : std_logic_vector(6 downto 0);
  signal plb_v46_0_M_ABus : std_logic_vector(0 to 31);
  signal plb_v46_0_M_BE : std_logic_vector(0 to 15);
  signal plb_v46_0_M_MSize : std_logic_vector(0 to 1);
  signal plb_v46_0_M_RNW : std_logic_vector(0 to 0);
  signal plb_v46_0_M_TAttribute : std_logic_vector(0 to 15);
  signal plb_v46_0_M_UABus : std_logic_vector(0 to 31);
  signal plb_v46_0_M_abort : std_logic_vector(0 to 0);
  signal plb_v46_0_M_busLock : std_logic_vector(0 to 0);
  signal plb_v46_0_M_lockErr : std_logic_vector(0 to 0);
  signal plb_v46_0_M_priority : std_logic_vector(0 to 1);
  signal plb_v46_0_M_rdBurst : std_logic_vector(0 to 0);
  signal plb_v46_0_M_request : std_logic_vector(0 to 0);
  signal plb_v46_0_M_size : std_logic_vector(0 to 3);
  signal plb_v46_0_M_type : std_logic_vector(0 to 2);
  signal plb_v46_0_M_wrBurst : std_logic_vector(0 to 0);
  signal plb_v46_0_M_wrDBus : std_logic_vector(0 to 127);
  signal plb_v46_0_PLB_ABus : std_logic_vector(0 to 31);
  signal plb_v46_0_PLB_BE : std_logic_vector(0 to 15);
  signal plb_v46_0_PLB_MAddrAck : std_logic_vector(0 to 0);
  signal plb_v46_0_PLB_MBusy : std_logic_vector(0 to 0);
  signal plb_v46_0_PLB_MIRQ : std_logic_vector(0 to 0);
  signal plb_v46_0_PLB_MRdBTerm : std_logic_vector(0 to 0);
  signal plb_v46_0_PLB_MRdDAck : std_logic_vector(0 to 0);
  signal plb_v46_0_PLB_MRdDBus : std_logic_vector(0 to 127);
  signal plb_v46_0_PLB_MRdErr : std_logic_vector(0 to 0);
  signal plb_v46_0_PLB_MRdWdAddr : std_logic_vector(0 to 3);
  signal plb_v46_0_PLB_MRearbitrate : std_logic_vector(0 to 0);
  signal plb_v46_0_PLB_MSSize : std_logic_vector(0 to 1);
  signal plb_v46_0_PLB_MSize : std_logic_vector(0 to 1);
  signal plb_v46_0_PLB_MTimeout : std_logic_vector(0 to 0);
  signal plb_v46_0_PLB_MWrBTerm : std_logic_vector(0 to 0);
  signal plb_v46_0_PLB_MWrDAck : std_logic_vector(0 to 0);
  signal plb_v46_0_PLB_MWrErr : std_logic_vector(0 to 0);
  signal plb_v46_0_PLB_PAValid : std_logic;
  signal plb_v46_0_PLB_RNW : std_logic;
  signal plb_v46_0_PLB_SAValid : std_logic;
  signal plb_v46_0_PLB_TAttribute : std_logic_vector(0 to 15);
  signal plb_v46_0_PLB_UABus : std_logic_vector(0 to 31);
  signal plb_v46_0_PLB_abort : std_logic;
  signal plb_v46_0_PLB_busLock : std_logic;
  signal plb_v46_0_PLB_lockErr : std_logic;
  signal plb_v46_0_PLB_masterID : std_logic_vector(0 to 0);
  signal plb_v46_0_PLB_rdBurst : std_logic;
  signal plb_v46_0_PLB_rdPendPri : std_logic_vector(0 to 1);
  signal plb_v46_0_PLB_rdPendReq : std_logic;
  signal plb_v46_0_PLB_rdPrim : std_logic_vector(0 to 9);
  signal plb_v46_0_PLB_reqPri : std_logic_vector(0 to 1);
  signal plb_v46_0_PLB_size : std_logic_vector(0 to 3);
  signal plb_v46_0_PLB_type : std_logic_vector(0 to 2);
  signal plb_v46_0_PLB_wrBurst : std_logic;
  signal plb_v46_0_PLB_wrDBus : std_logic_vector(0 to 127);
  signal plb_v46_0_PLB_wrPendPri : std_logic_vector(0 to 1);
  signal plb_v46_0_PLB_wrPendReq : std_logic;
  signal plb_v46_0_PLB_wrPrim : std_logic_vector(0 to 9);
  signal plb_v46_0_SPLB_Rst : std_logic_vector(0 to 9);
  signal plb_v46_0_Sl_MBusy : std_logic_vector(0 to 9);
  signal plb_v46_0_Sl_MIRQ : std_logic_vector(0 to 9);
  signal plb_v46_0_Sl_MRdErr : std_logic_vector(0 to 9);
  signal plb_v46_0_Sl_MWrErr : std_logic_vector(0 to 9);
  signal plb_v46_0_Sl_SSize : std_logic_vector(0 to 19);
  signal plb_v46_0_Sl_addrAck : std_logic_vector(0 to 9);
  signal plb_v46_0_Sl_rdBTerm : std_logic_vector(0 to 9);
  signal plb_v46_0_Sl_rdComp : std_logic_vector(0 to 9);
  signal plb_v46_0_Sl_rdDAck : std_logic_vector(0 to 9);
  signal plb_v46_0_Sl_rdDBus : std_logic_vector(0 to 1279);
  signal plb_v46_0_Sl_rdWdAddr : std_logic_vector(0 to 39);
  signal plb_v46_0_Sl_rearbitrate : std_logic_vector(0 to 9);
  signal plb_v46_0_Sl_wait : std_logic_vector(0 to 9);
  signal plb_v46_0_Sl_wrBTerm : std_logic_vector(0 to 9);
  signal plb_v46_0_Sl_wrComp : std_logic_vector(0 to 9);
  signal plb_v46_0_Sl_wrDAck : std_logic_vector(0 to 9);
  signal ppc440_0_EICC440EXTIRQ : std_logic;
  signal ppc440_0_jtagppc_bus_C405JTGTDO : std_logic;
  signal ppc440_0_jtagppc_bus_C405JTGTDOEN : std_logic;
  signal ppc440_0_jtagppc_bus_JTGC405TCK : std_logic;
  signal ppc440_0_jtagppc_bus_JTGC405TDI : std_logic;
  signal ppc440_0_jtagppc_bus_JTGC405TMS : std_logic;
  signal ppc440_0_jtagppc_bus_JTGC405TRSTNEG : std_logic;
  signal ppc_reset_bus_Chip_Reset_Req : std_logic;
  signal ppc_reset_bus_Core_Reset_Req : std_logic;
  signal ppc_reset_bus_RstcPPCresetcore : std_logic;
  signal ppc_reset_bus_RstcPPCresetsys : std_logic;
  signal ppc_reset_bus_RstsPPCresetchip : std_logic;
  signal ppc_reset_bus_System_Reset_Req : std_logic;
  signal qmfir_0_IP2INTC_Irpt : std_logic;
  signal sys_bus_reset : std_logic_vector(0 to 0);
  signal sys_periph_reset : std_logic_vector(0 to 0);
  signal sys_rst_s : std_logic;
  signal xps_bram_if_cntlr_0_port_BRAM_Addr : std_logic_vector(0 to 31);
  signal xps_bram_if_cntlr_0_port_BRAM_Clk : std_logic;
  signal xps_bram_if_cntlr_0_port_BRAM_Din : std_logic_vector(0 to 63);
  signal xps_bram_if_cntlr_0_port_BRAM_Dout : std_logic_vector(0 to 63);
  signal xps_bram_if_cntlr_0_port_BRAM_EN : std_logic;
  signal xps_bram_if_cntlr_0_port_BRAM_Rst : std_logic;
  signal xps_bram_if_cntlr_0_port_BRAM_WEN : std_logic_vector(0 to 7);
  signal xps_sysmon_adc_0_IP2INTC_Irpt : std_logic;
  signal xps_timer_0_Interrupt : std_logic;

  attribute BOX_TYPE : STRING;
  attribute BOX_TYPE of xps_timer_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of xps_sysmon_adc_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of xps_intc_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of xps_bram_if_cntlr_0_bram_wrapper : component is "user_black_box";
  attribute BOX_TYPE of xps_bram_if_cntlr_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of proc_sys_reset_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of ppc440_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of plb_v46_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of jtagppc_cntlr_inst_wrapper : component is "user_black_box";
  attribute BOX_TYPE of clock_generator_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of rs232_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of hard_ethernet_mac_fifo_wrapper : component is "user_black_box";
  attribute BOX_TYPE of hard_ethernet_mac_wrapper : component is "user_black_box";
  attribute BOX_TYPE of ddr_sdram_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of qmfir_0_wrapper : component is "user_black_box";

begin

  -- Internal assignments

  dcm_clk_s <= fpga_0_sys_clk_pin;
  sys_rst_s <= fpga_0_sys_rst_pin;
  fpga_0_DDR_SDRAM_0_DDR_Clk_pin <= pgassign1(0);
  fpga_0_DDR_SDRAM_0_DDR_Clk_n_pin <= pgassign2(0);
  fpga_0_DDR_SDRAM_0_DDR_CE_pin <= pgassign3(0);
  pgassign4(6) <= xps_timer_0_Interrupt;
  pgassign4(5) <= Hard_Ethernet_MAC_TemacIntc0_Irpt;
  pgassign4(4) <= Hard_Ethernet_MAC_fifo_IP2INTC_Irpt;
  pgassign4(3) <= fpga_0_Hard_Ethernet_MAC_PHY_INTR_pin;
  pgassign4(2) <= RS232_0_Interrupt;
  pgassign4(1) <= xps_sysmon_adc_0_IP2INTC_Irpt;
  pgassign4(0) <= qmfir_0_IP2INTC_Irpt;
  net_gnd0 <= '0';
  net_gnd1(0 to 0) <= B"0";
  net_gnd10(0 to 9) <= B"0000000000";
  net_gnd128(0 to 127) <= B"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  net_gnd16(15 downto 0) <= B"0000000000000000";
  net_gnd2(0 to 1) <= B"00";
  net_gnd3(0 to 2) <= B"000";
  net_gnd30(29 downto 0) <= B"000000000000000000000000000000";
  net_gnd32(31 downto 0) <= B"00000000000000000000000000000000";
  net_gnd36(0 to 35) <= B"000000000000000000000000000000000000";
  net_gnd4(0 to 3) <= B"0000";
  net_gnd5(0 to 4) <= B"00000";
  net_gnd6(5 downto 0) <= B"000000";
  net_gnd64(0 to 63) <= B"0000000000000000000000000000000000000000000000000000000000000000";
  net_gnd8(0 to 7) <= B"00000000";
  net_vcc0 <= '1';
  fpga_0_DDR_SDRAM_0_CLK_RESET_n_pin <= net_vcc0;
  net_vcc4(0 to 3) <= B"1111";

  xps_timer_0 : xps_timer_0_wrapper
    port map (
      CaptureTrig0 => net_gnd0,
      CaptureTrig1 => net_gnd0,
      GenerateOut0 => open,
      GenerateOut1 => open,
      PWM0 => open,
      Interrupt => xps_timer_0_Interrupt,
      Freeze => net_gnd0,
      SPLB_Clk => clk_125_0000MHzPLL0_ADJUST,
      SPLB_Rst => plb_v46_0_SPLB_Rst(0),
      PLB_ABus => plb_v46_0_PLB_ABus,
      PLB_PAValid => plb_v46_0_PLB_PAValid,
      PLB_masterID => plb_v46_0_PLB_masterID(0 to 0),
      PLB_RNW => plb_v46_0_PLB_RNW,
      PLB_BE => plb_v46_0_PLB_BE,
      PLB_size => plb_v46_0_PLB_size,
      PLB_type => plb_v46_0_PLB_type,
      PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      Sl_addrAck => plb_v46_0_Sl_addrAck(0),
      Sl_SSize => plb_v46_0_Sl_SSize(0 to 1),
      Sl_wait => plb_v46_0_Sl_wait(0),
      Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(0),
      Sl_wrDAck => plb_v46_0_Sl_wrDAck(0),
      Sl_wrComp => plb_v46_0_Sl_wrComp(0),
      Sl_rdDBus => plb_v46_0_Sl_rdDBus(0 to 127),
      Sl_rdDAck => plb_v46_0_Sl_rdDAck(0),
      Sl_rdComp => plb_v46_0_Sl_rdComp(0),
      Sl_MBusy => plb_v46_0_Sl_MBusy(0 to 0),
      Sl_MWrErr => plb_v46_0_Sl_MWrErr(0 to 0),
      Sl_MRdErr => plb_v46_0_Sl_MRdErr(0 to 0),
      PLB_UABus => plb_v46_0_PLB_UABus,
      PLB_SAValid => plb_v46_0_PLB_SAValid,
      PLB_rdPrim => plb_v46_0_PLB_rdPrim(0),
      PLB_wrPrim => plb_v46_0_PLB_wrPrim(0),
      PLB_abort => plb_v46_0_PLB_abort,
      PLB_busLock => plb_v46_0_PLB_busLock,
      PLB_MSize => plb_v46_0_PLB_MSize,
      PLB_lockErr => plb_v46_0_PLB_lockErr,
      PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      PLB_reqPri => plb_v46_0_PLB_reqPri,
      PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(0),
      Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(0 to 3),
      Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(0),
      Sl_MIRQ => plb_v46_0_Sl_MIRQ(0 to 0)
    );

  xps_sysmon_adc_0 : xps_sysmon_adc_0_wrapper
    port map (
      SPLB_Clk => clk_125_0000MHzPLL0_ADJUST,
      SPLB_Rst => plb_v46_0_SPLB_Rst(1),
      PLB_ABus => plb_v46_0_PLB_ABus,
      PLB_PAValid => plb_v46_0_PLB_PAValid,
      PLB_masterID => plb_v46_0_PLB_masterID(0 to 0),
      PLB_RNW => plb_v46_0_PLB_RNW,
      PLB_BE => plb_v46_0_PLB_BE,
      PLB_size => plb_v46_0_PLB_size,
      PLB_type => plb_v46_0_PLB_type,
      PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      Sl_addrAck => plb_v46_0_Sl_addrAck(1),
      Sl_SSize => plb_v46_0_Sl_SSize(2 to 3),
      Sl_wait => plb_v46_0_Sl_wait(1),
      Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(1),
      Sl_wrDAck => plb_v46_0_Sl_wrDAck(1),
      Sl_wrComp => plb_v46_0_Sl_wrComp(1),
      Sl_rdDBus => plb_v46_0_Sl_rdDBus(128 to 255),
      Sl_rdDAck => plb_v46_0_Sl_rdDAck(1),
      Sl_rdComp => plb_v46_0_Sl_rdComp(1),
      Sl_MBusy => plb_v46_0_Sl_MBusy(1 to 1),
      Sl_MWrErr => plb_v46_0_Sl_MWrErr(1 to 1),
      Sl_MRdErr => plb_v46_0_Sl_MRdErr(1 to 1),
      PLB_UABus => plb_v46_0_PLB_UABus,
      PLB_SAValid => plb_v46_0_PLB_SAValid,
      PLB_rdPrim => plb_v46_0_PLB_rdPrim(1),
      PLB_wrPrim => plb_v46_0_PLB_wrPrim(1),
      PLB_abort => plb_v46_0_PLB_abort,
      PLB_busLock => plb_v46_0_PLB_busLock,
      PLB_MSize => plb_v46_0_PLB_MSize,
      PLB_lockErr => plb_v46_0_PLB_lockErr,
      PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      PLB_reqPri => plb_v46_0_PLB_reqPri,
      PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(1),
      Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(4 to 7),
      Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(1),
      Sl_MIRQ => plb_v46_0_Sl_MIRQ(1 to 1),
      IP2INTC_Irpt => xps_sysmon_adc_0_IP2INTC_Irpt,
      VAUXP => net_gnd16,
      VAUXN => net_gnd16,
      CONVST => net_gnd0,
      ALARM => open
    );

  xps_intc_0 : xps_intc_0_wrapper
    port map (
      SPLB_Clk => clk_125_0000MHzPLL0_ADJUST,
      SPLB_Rst => plb_v46_0_SPLB_Rst(2),
      PLB_ABus => plb_v46_0_PLB_ABus,
      PLB_PAValid => plb_v46_0_PLB_PAValid,
      PLB_masterID => plb_v46_0_PLB_masterID(0 to 0),
      PLB_RNW => plb_v46_0_PLB_RNW,
      PLB_BE => plb_v46_0_PLB_BE,
      PLB_size => plb_v46_0_PLB_size,
      PLB_type => plb_v46_0_PLB_type,
      PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      PLB_UABus => plb_v46_0_PLB_UABus,
      PLB_SAValid => plb_v46_0_PLB_SAValid,
      PLB_rdPrim => plb_v46_0_PLB_rdPrim(2),
      PLB_wrPrim => plb_v46_0_PLB_wrPrim(2),
      PLB_abort => plb_v46_0_PLB_abort,
      PLB_busLock => plb_v46_0_PLB_busLock,
      PLB_MSize => plb_v46_0_PLB_MSize,
      PLB_lockErr => plb_v46_0_PLB_lockErr,
      PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      PLB_reqPri => plb_v46_0_PLB_reqPri,
      PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      Sl_addrAck => plb_v46_0_Sl_addrAck(2),
      Sl_SSize => plb_v46_0_Sl_SSize(4 to 5),
      Sl_wait => plb_v46_0_Sl_wait(2),
      Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(2),
      Sl_wrDAck => plb_v46_0_Sl_wrDAck(2),
      Sl_wrComp => plb_v46_0_Sl_wrComp(2),
      Sl_rdDBus => plb_v46_0_Sl_rdDBus(256 to 383),
      Sl_rdDAck => plb_v46_0_Sl_rdDAck(2),
      Sl_rdComp => plb_v46_0_Sl_rdComp(2),
      Sl_MBusy => plb_v46_0_Sl_MBusy(2 to 2),
      Sl_MWrErr => plb_v46_0_Sl_MWrErr(2 to 2),
      Sl_MRdErr => plb_v46_0_Sl_MRdErr(2 to 2),
      Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(2),
      Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(8 to 11),
      Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(2),
      Sl_MIRQ => plb_v46_0_Sl_MIRQ(2 to 2),
      Intr => pgassign4,
      Irq => ppc440_0_EICC440EXTIRQ
    );

  xps_bram_if_cntlr_0_bram : xps_bram_if_cntlr_0_bram_wrapper
    port map (
      BRAM_Rst_A => xps_bram_if_cntlr_0_port_BRAM_Rst,
      BRAM_Clk_A => xps_bram_if_cntlr_0_port_BRAM_Clk,
      BRAM_EN_A => xps_bram_if_cntlr_0_port_BRAM_EN,
      BRAM_WEN_A => xps_bram_if_cntlr_0_port_BRAM_WEN,
      BRAM_Addr_A => xps_bram_if_cntlr_0_port_BRAM_Addr,
      BRAM_Din_A => xps_bram_if_cntlr_0_port_BRAM_Din,
      BRAM_Dout_A => xps_bram_if_cntlr_0_port_BRAM_Dout,
      BRAM_Rst_B => net_gnd0,
      BRAM_Clk_B => net_gnd0,
      BRAM_EN_B => net_gnd0,
      BRAM_WEN_B => net_gnd8,
      BRAM_Addr_B => net_gnd32(31 downto 0),
      BRAM_Din_B => open,
      BRAM_Dout_B => net_gnd64
    );

  xps_bram_if_cntlr_0 : xps_bram_if_cntlr_0_wrapper
    port map (
      SPLB_Clk => clk_125_0000MHzPLL0_ADJUST,
      SPLB_Rst => plb_v46_0_SPLB_Rst(3),
      PLB_ABus => plb_v46_0_PLB_ABus,
      PLB_UABus => plb_v46_0_PLB_UABus,
      PLB_PAValid => plb_v46_0_PLB_PAValid,
      PLB_SAValid => plb_v46_0_PLB_SAValid,
      PLB_rdPrim => plb_v46_0_PLB_rdPrim(3),
      PLB_wrPrim => plb_v46_0_PLB_wrPrim(3),
      PLB_masterID => plb_v46_0_PLB_masterID(0 to 0),
      PLB_abort => plb_v46_0_PLB_abort,
      PLB_busLock => plb_v46_0_PLB_busLock,
      PLB_RNW => plb_v46_0_PLB_RNW,
      PLB_BE => plb_v46_0_PLB_BE,
      PLB_MSize => plb_v46_0_PLB_MSize,
      PLB_size => plb_v46_0_PLB_size,
      PLB_type => plb_v46_0_PLB_type,
      PLB_lockErr => plb_v46_0_PLB_lockErr,
      PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      PLB_reqPri => plb_v46_0_PLB_reqPri,
      PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      Sl_addrAck => plb_v46_0_Sl_addrAck(3),
      Sl_SSize => plb_v46_0_Sl_SSize(6 to 7),
      Sl_wait => plb_v46_0_Sl_wait(3),
      Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(3),
      Sl_wrDAck => plb_v46_0_Sl_wrDAck(3),
      Sl_wrComp => plb_v46_0_Sl_wrComp(3),
      Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(3),
      Sl_rdDBus => plb_v46_0_Sl_rdDBus(384 to 511),
      Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(12 to 15),
      Sl_rdDAck => plb_v46_0_Sl_rdDAck(3),
      Sl_rdComp => plb_v46_0_Sl_rdComp(3),
      Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(3),
      Sl_MBusy => plb_v46_0_Sl_MBusy(3 to 3),
      Sl_MWrErr => plb_v46_0_Sl_MWrErr(3 to 3),
      Sl_MRdErr => plb_v46_0_Sl_MRdErr(3 to 3),
      Sl_MIRQ => plb_v46_0_Sl_MIRQ(3 to 3),
      BRAM_Rst => xps_bram_if_cntlr_0_port_BRAM_Rst,
      BRAM_Clk => xps_bram_if_cntlr_0_port_BRAM_Clk,
      BRAM_EN => xps_bram_if_cntlr_0_port_BRAM_EN,
      BRAM_WEN => xps_bram_if_cntlr_0_port_BRAM_WEN,
      BRAM_Addr => xps_bram_if_cntlr_0_port_BRAM_Addr,
      BRAM_Din => xps_bram_if_cntlr_0_port_BRAM_Din,
      BRAM_Dout => xps_bram_if_cntlr_0_port_BRAM_Dout
    );

  proc_sys_reset_0 : proc_sys_reset_0_wrapper
    port map (
      Slowest_sync_clk => clk_125_0000MHzPLL0_ADJUST,
      Ext_Reset_In => sys_rst_s,
      Aux_Reset_In => net_gnd0,
      MB_Debug_Sys_Rst => net_gnd0,
      Core_Reset_Req_0 => ppc_reset_bus_Core_Reset_Req,
      Chip_Reset_Req_0 => ppc_reset_bus_Chip_Reset_Req,
      System_Reset_Req_0 => ppc_reset_bus_System_Reset_Req,
      Core_Reset_Req_1 => net_gnd0,
      Chip_Reset_Req_1 => net_gnd0,
      System_Reset_Req_1 => net_gnd0,
      Dcm_locked => Dcm_all_locked,
      RstcPPCresetcore_0 => ppc_reset_bus_RstcPPCresetcore,
      RstcPPCresetchip_0 => ppc_reset_bus_RstsPPCresetchip,
      RstcPPCresetsys_0 => ppc_reset_bus_RstcPPCresetsys,
      RstcPPCresetcore_1 => open,
      RstcPPCresetchip_1 => open,
      RstcPPCresetsys_1 => open,
      MB_Reset => open,
      Bus_Struct_Reset => sys_bus_reset(0 to 0),
      Peripheral_Reset => sys_periph_reset(0 to 0)
    );

  ppc440_0 : ppc440_0_wrapper
    port map (
      CPMC440CLK => clk_250_0000MHzPLL0,
      CPMC440CLKEN => net_vcc0,
      CPMINTERCONNECTCLK => clk_250_0000MHzPLL0,
      CPMINTERCONNECTCLKEN => net_vcc0,
      CPMINTERCONNECTCLKNTO1 => net_vcc0,
      CPMC440CORECLOCKINACTIVE => net_gnd0,
      CPMC440TIMERCLOCK => net_vcc0,
      C440MACHINECHECK => open,
      C440CPMCORESLEEPREQ => open,
      C440CPMDECIRPTREQ => open,
      C440CPMFITIRPTREQ => open,
      C440CPMMSRCE => open,
      C440CPMMSREE => open,
      C440CPMTIMERRESETREQ => open,
      C440CPMWDIRPTREQ => open,
      PPCCPMINTERCONNECTBUSY => open,
      DBGC440DEBUGHALT => net_gnd0,
      DBGC440DEBUGHALTNEG => net_vcc0,
      DBGC440SYSTEMSTATUS => net_gnd5,
      DBGC440UNCONDDEBUGEVENT => net_gnd0,
      C440DBGSYSTEMCONTROL => open,
      SPLB0_Error => open,
      SPLB1_Error => open,
      EICC440CRITIRQ => net_gnd0,
      EICC440EXTIRQ => ppc440_0_EICC440EXTIRQ,
      PPCEICINTERCONNECTIRQ => open,
      CPMDCRCLK => net_vcc0,
      DCRPPCDMACK => net_gnd0,
      DCRPPCDMDBUSIN => net_gnd32(31 downto 0),
      DCRPPCDMTIMEOUTWAIT => net_gnd0,
      PPCDMDCRREAD => open,
      PPCDMDCRWRITE => open,
      PPCDMDCRABUS => open,
      PPCDMDCRDBUSOUT => open,
      DCRPPCDSREAD => net_gnd0,
      DCRPPCDSWRITE => net_gnd0,
      DCRPPCDSABUS => net_gnd10,
      DCRPPCDSDBUSOUT => net_gnd32(31 downto 0),
      PPCDSDCRACK => open,
      PPCDSDCRDBUSIN => open,
      PPCDSDCRTIMEOUTWAIT => open,
      CPMFCMCLK => net_vcc0,
      FCMAPUCR => net_gnd4,
      FCMAPUDONE => net_gnd0,
      FCMAPUEXCEPTION => net_gnd0,
      FCMAPUFPSCRFEX => net_gnd0,
      FCMAPURESULT => net_gnd32(31 downto 0),
      FCMAPURESULTVALID => net_gnd0,
      FCMAPUSLEEPNOTREADY => net_gnd0,
      FCMAPUCONFIRMINSTR => net_gnd0,
      FCMAPUSTOREDATA => net_gnd128,
      APUFCMDECNONAUTON => open,
      APUFCMDECFPUOP => open,
      APUFCMDECLDSTXFERSIZE => open,
      APUFCMDECLOAD => open,
      APUFCMNEXTINSTRREADY => open,
      APUFCMDECSTORE => open,
      APUFCMDECUDI => open,
      APUFCMDECUDIVALID => open,
      APUFCMENDIAN => open,
      APUFCMFLUSH => open,
      APUFCMINSTRUCTION => open,
      APUFCMINSTRVALID => open,
      APUFCMLOADBYTEADDR => open,
      APUFCMLOADDATA => open,
      APUFCMLOADDVALID => open,
      APUFCMOPERANDVALID => open,
      APUFCMRADATA => open,
      APUFCMRBDATA => open,
      APUFCMWRITEBACKOK => open,
      APUFCMMSRFE0 => open,
      APUFCMMSRFE1 => open,
      JTGC440TCK => ppc440_0_jtagppc_bus_JTGC405TCK,
      JTGC440TDI => ppc440_0_jtagppc_bus_JTGC405TDI,
      JTGC440TMS => ppc440_0_jtagppc_bus_JTGC405TMS,
      JTGC440TRSTNEG => ppc440_0_jtagppc_bus_JTGC405TRSTNEG,
      C440JTGTDO => ppc440_0_jtagppc_bus_C405JTGTDO,
      C440JTGTDOEN => ppc440_0_jtagppc_bus_C405JTGTDOEN,
      CPMMCCLK => clk_125_0000MHzPLL0_ADJUST,
      MCMIREADDATA => net_gnd128,
      MCMIREADDATAVALID => net_gnd0,
      MCMIREADDATAERR => net_gnd0,
      MCMIADDRREADYTOACCEPT => net_vcc0,
      MIMCREADNOTWRITE => open,
      MIMCADDRESS => open,
      MIMCADDRESSVALID => open,
      MIMCWRITEDATA => open,
      MIMCWRITEDATAVALID => open,
      MIMCBYTEENABLE => open,
      MIMCBANKCONFLICT => open,
      MIMCROWCONFLICT => open,
      CPMPPCMPLBCLK => clk_125_0000MHzPLL0_ADJUST,
      PLBPPCMMBUSY => plb_v46_0_PLB_MBusy(0),
      PLBPPCMMIRQ => plb_v46_0_PLB_MIRQ(0),
      PLBPPCMMRDERR => plb_v46_0_PLB_MRdErr(0),
      PLBPPCMMWRERR => plb_v46_0_PLB_MWrErr(0),
      PLBPPCMADDRACK => plb_v46_0_PLB_MAddrAck(0),
      PLBPPCMRDBTERM => plb_v46_0_PLB_MRdBTerm(0),
      PLBPPCMRDDACK => plb_v46_0_PLB_MRdDAck(0),
      PLBPPCMRDDBUS => plb_v46_0_PLB_MRdDBus,
      PLBPPCMRDWDADDR => plb_v46_0_PLB_MRdWdAddr,
      PLBPPCMREARBITRATE => plb_v46_0_PLB_MRearbitrate(0),
      PLBPPCMSSIZE => plb_v46_0_PLB_MSSize,
      PLBPPCMTIMEOUT => plb_v46_0_PLB_MTimeout(0),
      PLBPPCMWRBTERM => plb_v46_0_PLB_MWrBTerm(0),
      PLBPPCMWRDACK => plb_v46_0_PLB_MWrDAck(0),
      PLBPPCMRDPENDPRI => plb_v46_0_PLB_rdPendPri,
      PLBPPCMRDPENDREQ => plb_v46_0_PLB_rdPendReq,
      PLBPPCMREQPRI => plb_v46_0_PLB_reqPri,
      PLBPPCMWRPENDPRI => plb_v46_0_PLB_wrPendPri,
      PLBPPCMWRPENDREQ => plb_v46_0_PLB_wrPendReq,
      PPCMPLBABORT => plb_v46_0_M_abort(0),
      PPCMPLBABUS => plb_v46_0_M_ABus,
      PPCMPLBBE => plb_v46_0_M_BE,
      PPCMPLBBUSLOCK => plb_v46_0_M_busLock(0),
      PPCMPLBLOCKERR => plb_v46_0_M_lockErr(0),
      PPCMPLBMSIZE => plb_v46_0_M_MSize,
      PPCMPLBPRIORITY => plb_v46_0_M_priority,
      PPCMPLBRDBURST => plb_v46_0_M_rdBurst(0),
      PPCMPLBREQUEST => plb_v46_0_M_request(0),
      PPCMPLBRNW => plb_v46_0_M_RNW(0),
      PPCMPLBSIZE => plb_v46_0_M_size,
      PPCMPLBTATTRIBUTE => plb_v46_0_M_TAttribute,
      PPCMPLBTYPE => plb_v46_0_M_type,
      PPCMPLBUABUS => plb_v46_0_M_UABus,
      PPCMPLBWRBURST => plb_v46_0_M_wrBurst(0),
      PPCMPLBWRDBUS => plb_v46_0_M_wrDBus,
      CPMPPCS0PLBCLK => net_vcc0,
      PLBPPCS0MASTERID => net_gnd1(0 to 0),
      PLBPPCS0PAVALID => net_gnd0,
      PLBPPCS0SAVALID => net_gnd0,
      PLBPPCS0RDPENDREQ => net_gnd0,
      PLBPPCS0WRPENDREQ => net_gnd0,
      PLBPPCS0RDPENDPRI => net_gnd2,
      PLBPPCS0WRPENDPRI => net_gnd2,
      PLBPPCS0REQPRI => net_gnd2,
      PLBPPCS0RDPRIM => net_gnd0,
      PLBPPCS0WRPRIM => net_gnd0,
      PLBPPCS0BUSLOCK => net_gnd0,
      PLBPPCS0ABORT => net_gnd0,
      PLBPPCS0RNW => net_gnd0,
      PLBPPCS0BE => net_gnd16(15 downto 0),
      PLBPPCS0SIZE => net_gnd4,
      PLBPPCS0TYPE => net_gnd3,
      PLBPPCS0TATTRIBUTE => net_gnd16(15 downto 0),
      PLBPPCS0LOCKERR => net_gnd0,
      PLBPPCS0MSIZE => net_gnd2,
      PLBPPCS0UABUS => net_gnd32(31 downto 0),
      PLBPPCS0ABUS => net_gnd32(31 downto 0),
      PLBPPCS0WRDBUS => net_gnd128,
      PLBPPCS0WRBURST => net_gnd0,
      PLBPPCS0RDBURST => net_gnd0,
      PPCS0PLBADDRACK => open,
      PPCS0PLBWAIT => open,
      PPCS0PLBREARBITRATE => open,
      PPCS0PLBWRDACK => open,
      PPCS0PLBWRCOMP => open,
      PPCS0PLBRDDBUS => open,
      PPCS0PLBRDWDADDR => open,
      PPCS0PLBRDDACK => open,
      PPCS0PLBRDCOMP => open,
      PPCS0PLBRDBTERM => open,
      PPCS0PLBWRBTERM => open,
      PPCS0PLBMBUSY => open,
      PPCS0PLBMRDERR => open,
      PPCS0PLBMWRERR => open,
      PPCS0PLBMIRQ => open,
      PPCS0PLBSSIZE => open,
      CPMPPCS1PLBCLK => net_vcc0,
      PLBPPCS1MASTERID => net_gnd1(0 to 0),
      PLBPPCS1PAVALID => net_gnd0,
      PLBPPCS1SAVALID => net_gnd0,
      PLBPPCS1RDPENDREQ => net_gnd0,
      PLBPPCS1WRPENDREQ => net_gnd0,
      PLBPPCS1RDPENDPRI => net_gnd2,
      PLBPPCS1WRPENDPRI => net_gnd2,
      PLBPPCS1REQPRI => net_gnd2,
      PLBPPCS1RDPRIM => net_gnd0,
      PLBPPCS1WRPRIM => net_gnd0,
      PLBPPCS1BUSLOCK => net_gnd0,
      PLBPPCS1ABORT => net_gnd0,
      PLBPPCS1RNW => net_gnd0,
      PLBPPCS1BE => net_gnd16(15 downto 0),
      PLBPPCS1SIZE => net_gnd4,
      PLBPPCS1TYPE => net_gnd3,
      PLBPPCS1TATTRIBUTE => net_gnd16(15 downto 0),
      PLBPPCS1LOCKERR => net_gnd0,
      PLBPPCS1MSIZE => net_gnd2,
      PLBPPCS1UABUS => net_gnd32(31 downto 0),
      PLBPPCS1ABUS => net_gnd32(31 downto 0),
      PLBPPCS1WRDBUS => net_gnd128,
      PLBPPCS1WRBURST => net_gnd0,
      PLBPPCS1RDBURST => net_gnd0,
      PPCS1PLBADDRACK => open,
      PPCS1PLBWAIT => open,
      PPCS1PLBREARBITRATE => open,
      PPCS1PLBWRDACK => open,
      PPCS1PLBWRCOMP => open,
      PPCS1PLBRDDBUS => open,
      PPCS1PLBRDWDADDR => open,
      PPCS1PLBRDDACK => open,
      PPCS1PLBRDCOMP => open,
      PPCS1PLBRDBTERM => open,
      PPCS1PLBWRBTERM => open,
      PPCS1PLBMBUSY => open,
      PPCS1PLBMRDERR => open,
      PPCS1PLBMWRERR => open,
      PPCS1PLBMIRQ => open,
      PPCS1PLBSSIZE => open,
      CPMDMA0LLCLK => net_vcc0,
      LLDMA0TXDSTRDYN => net_vcc0,
      LLDMA0RXD => net_gnd32(31 downto 0),
      LLDMA0RXREM => net_gnd4,
      LLDMA0RXSOFN => net_vcc0,
      LLDMA0RXEOFN => net_vcc0,
      LLDMA0RXSOPN => net_vcc0,
      LLDMA0RXEOPN => net_vcc0,
      LLDMA0RXSRCRDYN => net_vcc0,
      LLDMA0RSTENGINEREQ => net_gnd0,
      DMA0LLTXD => open,
      DMA0LLTXREM => open,
      DMA0LLTXSOFN => open,
      DMA0LLTXEOFN => open,
      DMA0LLTXSOPN => open,
      DMA0LLTXEOPN => open,
      DMA0LLTXSRCRDYN => open,
      DMA0LLRXDSTRDYN => open,
      DMA0LLRSTENGINEACK => open,
      DMA0TXIRQ => open,
      DMA0RXIRQ => open,
      CPMDMA1LLCLK => net_vcc0,
      LLDMA1TXDSTRDYN => net_vcc0,
      LLDMA1RXD => net_gnd32(31 downto 0),
      LLDMA1RXREM => net_gnd4,
      LLDMA1RXSOFN => net_vcc0,
      LLDMA1RXEOFN => net_vcc0,
      LLDMA1RXSOPN => net_vcc0,
      LLDMA1RXEOPN => net_vcc0,
      LLDMA1RXSRCRDYN => net_vcc0,
      LLDMA1RSTENGINEREQ => net_gnd0,
      DMA1LLTXD => open,
      DMA1LLTXREM => open,
      DMA1LLTXSOFN => open,
      DMA1LLTXEOFN => open,
      DMA1LLTXSOPN => open,
      DMA1LLTXEOPN => open,
      DMA1LLTXSRCRDYN => open,
      DMA1LLRXDSTRDYN => open,
      DMA1LLRSTENGINEACK => open,
      DMA1TXIRQ => open,
      DMA1RXIRQ => open,
      CPMDMA2LLCLK => net_vcc0,
      LLDMA2TXDSTRDYN => net_vcc0,
      LLDMA2RXD => net_gnd32(31 downto 0),
      LLDMA2RXREM => net_gnd4,
      LLDMA2RXSOFN => net_vcc0,
      LLDMA2RXEOFN => net_vcc0,
      LLDMA2RXSOPN => net_vcc0,
      LLDMA2RXEOPN => net_vcc0,
      LLDMA2RXSRCRDYN => net_vcc0,
      LLDMA2RSTENGINEREQ => net_gnd0,
      DMA2LLTXD => open,
      DMA2LLTXREM => open,
      DMA2LLTXSOFN => open,
      DMA2LLTXEOFN => open,
      DMA2LLTXSOPN => open,
      DMA2LLTXEOPN => open,
      DMA2LLTXSRCRDYN => open,
      DMA2LLRXDSTRDYN => open,
      DMA2LLRSTENGINEACK => open,
      DMA2TXIRQ => open,
      DMA2RXIRQ => open,
      CPMDMA3LLCLK => net_vcc0,
      LLDMA3TXDSTRDYN => net_vcc0,
      LLDMA3RXD => net_gnd32(31 downto 0),
      LLDMA3RXREM => net_gnd4,
      LLDMA3RXSOFN => net_vcc0,
      LLDMA3RXEOFN => net_vcc0,
      LLDMA3RXSOPN => net_vcc0,
      LLDMA3RXEOPN => net_vcc0,
      LLDMA3RXSRCRDYN => net_vcc0,
      LLDMA3RSTENGINEREQ => net_gnd0,
      DMA3LLTXD => open,
      DMA3LLTXREM => open,
      DMA3LLTXSOFN => open,
      DMA3LLTXEOFN => open,
      DMA3LLTXSOPN => open,
      DMA3LLTXEOPN => open,
      DMA3LLTXSRCRDYN => open,
      DMA3LLRXDSTRDYN => open,
      DMA3LLRSTENGINEACK => open,
      DMA3TXIRQ => open,
      DMA3RXIRQ => open,
      RSTC440RESETCORE => ppc_reset_bus_RstcPPCresetcore,
      RSTC440RESETCHIP => ppc_reset_bus_RstsPPCresetchip,
      RSTC440RESETSYSTEM => ppc_reset_bus_RstcPPCresetsys,
      C440RSTCORERESETREQ => ppc_reset_bus_Core_Reset_Req,
      C440RSTCHIPRESETREQ => ppc_reset_bus_Chip_Reset_Req,
      C440RSTSYSTEMRESETREQ => ppc_reset_bus_System_Reset_Req,
      TRCC440TRACEDISABLE => net_gnd0,
      TRCC440TRIGGEREVENTIN => net_gnd0,
      C440TRCBRANCHSTATUS => open,
      C440TRCCYCLE => open,
      C440TRCEXECUTIONSTATUS => open,
      C440TRCTRACESTATUS => open,
      C440TRCTRIGGEREVENTOUT => open,
      C440TRCTRIGGEREVENTTYPE => open
    );

  plb_v46_0 : plb_v46_0_wrapper
    port map (
      PLB_Clk => clk_125_0000MHzPLL0_ADJUST,
      SYS_Rst => sys_bus_reset(0),
      PLB_Rst => open,
      SPLB_Rst => plb_v46_0_SPLB_Rst,
      MPLB_Rst => open,
      PLB_dcrAck => open,
      PLB_dcrDBus => open,
      DCR_ABus => net_gnd10,
      DCR_DBus => net_gnd32(31 downto 0),
      DCR_Read => net_gnd0,
      DCR_Write => net_gnd0,
      M_ABus => plb_v46_0_M_ABus,
      M_UABus => plb_v46_0_M_UABus,
      M_BE => plb_v46_0_M_BE,
      M_RNW => plb_v46_0_M_RNW(0 to 0),
      M_abort => plb_v46_0_M_abort(0 to 0),
      M_busLock => plb_v46_0_M_busLock(0 to 0),
      M_TAttribute => plb_v46_0_M_TAttribute,
      M_lockErr => plb_v46_0_M_lockErr(0 to 0),
      M_MSize => plb_v46_0_M_MSize,
      M_priority => plb_v46_0_M_priority,
      M_rdBurst => plb_v46_0_M_rdBurst(0 to 0),
      M_request => plb_v46_0_M_request(0 to 0),
      M_size => plb_v46_0_M_size,
      M_type => plb_v46_0_M_type,
      M_wrBurst => plb_v46_0_M_wrBurst(0 to 0),
      M_wrDBus => plb_v46_0_M_wrDBus,
      Sl_addrAck => plb_v46_0_Sl_addrAck,
      Sl_MRdErr => plb_v46_0_Sl_MRdErr,
      Sl_MWrErr => plb_v46_0_Sl_MWrErr,
      Sl_MBusy => plb_v46_0_Sl_MBusy,
      Sl_rdBTerm => plb_v46_0_Sl_rdBTerm,
      Sl_rdComp => plb_v46_0_Sl_rdComp,
      Sl_rdDAck => plb_v46_0_Sl_rdDAck,
      Sl_rdDBus => plb_v46_0_Sl_rdDBus,
      Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr,
      Sl_rearbitrate => plb_v46_0_Sl_rearbitrate,
      Sl_SSize => plb_v46_0_Sl_SSize,
      Sl_wait => plb_v46_0_Sl_wait,
      Sl_wrBTerm => plb_v46_0_Sl_wrBTerm,
      Sl_wrComp => plb_v46_0_Sl_wrComp,
      Sl_wrDAck => plb_v46_0_Sl_wrDAck,
      Sl_MIRQ => plb_v46_0_Sl_MIRQ,
      PLB_MIRQ => plb_v46_0_PLB_MIRQ(0 to 0),
      PLB_ABus => plb_v46_0_PLB_ABus,
      PLB_UABus => plb_v46_0_PLB_UABus,
      PLB_BE => plb_v46_0_PLB_BE,
      PLB_MAddrAck => plb_v46_0_PLB_MAddrAck(0 to 0),
      PLB_MTimeout => plb_v46_0_PLB_MTimeout(0 to 0),
      PLB_MBusy => plb_v46_0_PLB_MBusy(0 to 0),
      PLB_MRdErr => plb_v46_0_PLB_MRdErr(0 to 0),
      PLB_MWrErr => plb_v46_0_PLB_MWrErr(0 to 0),
      PLB_MRdBTerm => plb_v46_0_PLB_MRdBTerm(0 to 0),
      PLB_MRdDAck => plb_v46_0_PLB_MRdDAck(0 to 0),
      PLB_MRdDBus => plb_v46_0_PLB_MRdDBus,
      PLB_MRdWdAddr => plb_v46_0_PLB_MRdWdAddr,
      PLB_MRearbitrate => plb_v46_0_PLB_MRearbitrate(0 to 0),
      PLB_MWrBTerm => plb_v46_0_PLB_MWrBTerm(0 to 0),
      PLB_MWrDAck => plb_v46_0_PLB_MWrDAck(0 to 0),
      PLB_MSSize => plb_v46_0_PLB_MSSize,
      PLB_PAValid => plb_v46_0_PLB_PAValid,
      PLB_RNW => plb_v46_0_PLB_RNW,
      PLB_SAValid => plb_v46_0_PLB_SAValid,
      PLB_abort => plb_v46_0_PLB_abort,
      PLB_busLock => plb_v46_0_PLB_busLock,
      PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      PLB_lockErr => plb_v46_0_PLB_lockErr,
      PLB_masterID => plb_v46_0_PLB_masterID(0 to 0),
      PLB_MSize => plb_v46_0_PLB_MSize,
      PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      PLB_rdPrim => plb_v46_0_PLB_rdPrim,
      PLB_reqPri => plb_v46_0_PLB_reqPri,
      PLB_size => plb_v46_0_PLB_size,
      PLB_type => plb_v46_0_PLB_type,
      PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      PLB_wrPrim => plb_v46_0_PLB_wrPrim,
      PLB_SaddrAck => open,
      PLB_SMRdErr => open,
      PLB_SMWrErr => open,
      PLB_SMBusy => open,
      PLB_SrdBTerm => open,
      PLB_SrdComp => open,
      PLB_SrdDAck => open,
      PLB_SrdDBus => open,
      PLB_SrdWdAddr => open,
      PLB_Srearbitrate => open,
      PLB_Sssize => open,
      PLB_Swait => open,
      PLB_SwrBTerm => open,
      PLB_SwrComp => open,
      PLB_SwrDAck => open,
      Bus_Error_Det => open
    );

  jtagppc_cntlr_inst : jtagppc_cntlr_inst_wrapper
    port map (
      TRSTNEG => net_vcc0,
      HALTNEG0 => net_vcc0,
      DBGC405DEBUGHALT0 => open,
      HALTNEG1 => net_vcc0,
      DBGC405DEBUGHALT1 => open,
      C405JTGTDO0 => ppc440_0_jtagppc_bus_C405JTGTDO,
      C405JTGTDOEN0 => ppc440_0_jtagppc_bus_C405JTGTDOEN,
      JTGC405TCK0 => ppc440_0_jtagppc_bus_JTGC405TCK,
      JTGC405TDI0 => ppc440_0_jtagppc_bus_JTGC405TDI,
      JTGC405TMS0 => ppc440_0_jtagppc_bus_JTGC405TMS,
      JTGC405TRSTNEG0 => ppc440_0_jtagppc_bus_JTGC405TRSTNEG,
      C405JTGTDO1 => net_gnd0,
      C405JTGTDOEN1 => net_gnd0,
      JTGC405TCK1 => open,
      JTGC405TDI1 => open,
      JTGC405TMS1 => open,
      JTGC405TRSTNEG1 => open
    );

  clock_generator_0 : clock_generator_0_wrapper
    port map (
      CLKIN => dcm_clk_s,
      CLKFBIN => net_gnd0,
      CLKOUT0 => clk_125_0000MHz90PLL0_ADJUST,
      CLKOUT1 => clk_125_0000MHzPLL0_ADJUST,
      CLKOUT2 => clk_200_0000MHz,
      CLKOUT3 => clk_250_0000MHzPLL0,
      CLKOUT4 => open,
      CLKOUT5 => open,
      CLKOUT6 => open,
      CLKOUT7 => open,
      CLKOUT8 => open,
      CLKOUT9 => open,
      CLKOUT10 => open,
      CLKOUT11 => open,
      CLKOUT12 => open,
      CLKOUT13 => open,
      CLKOUT14 => open,
      CLKOUT15 => open,
      CLKFBOUT => open,
      PSCLK => net_gnd0,
      PSEN => net_gnd0,
      PSINCDEC => net_gnd0,
      PSDONE => open,
      RST => sys_rst_s,
      LOCKED => Dcm_all_locked
    );

  RS232_0 : rs232_0_wrapper
    port map (
      SPLB_Clk => clk_125_0000MHzPLL0_ADJUST,
      SPLB_Rst => plb_v46_0_SPLB_Rst(4),
      PLB_ABus => plb_v46_0_PLB_ABus,
      PLB_PAValid => plb_v46_0_PLB_PAValid,
      PLB_masterID => plb_v46_0_PLB_masterID(0 to 0),
      PLB_RNW => plb_v46_0_PLB_RNW,
      PLB_BE => plb_v46_0_PLB_BE,
      PLB_size => plb_v46_0_PLB_size,
      PLB_type => plb_v46_0_PLB_type,
      PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      PLB_UABus => plb_v46_0_PLB_UABus,
      PLB_SAValid => plb_v46_0_PLB_SAValid,
      PLB_rdPrim => plb_v46_0_PLB_rdPrim(4),
      PLB_wrPrim => plb_v46_0_PLB_wrPrim(4),
      PLB_abort => plb_v46_0_PLB_abort,
      PLB_busLock => plb_v46_0_PLB_busLock,
      PLB_MSize => plb_v46_0_PLB_MSize,
      PLB_lockErr => plb_v46_0_PLB_lockErr,
      PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      PLB_reqPri => plb_v46_0_PLB_reqPri,
      PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      Sl_addrAck => plb_v46_0_Sl_addrAck(4),
      Sl_SSize => plb_v46_0_Sl_SSize(8 to 9),
      Sl_wait => plb_v46_0_Sl_wait(4),
      Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(4),
      Sl_wrDAck => plb_v46_0_Sl_wrDAck(4),
      Sl_wrComp => plb_v46_0_Sl_wrComp(4),
      Sl_rdDBus => plb_v46_0_Sl_rdDBus(512 to 639),
      Sl_rdDAck => plb_v46_0_Sl_rdDAck(4),
      Sl_rdComp => plb_v46_0_Sl_rdComp(4),
      Sl_MBusy => plb_v46_0_Sl_MBusy(4 to 4),
      Sl_MWrErr => plb_v46_0_Sl_MWrErr(4 to 4),
      Sl_MRdErr => plb_v46_0_Sl_MRdErr(4 to 4),
      Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(4),
      Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(16 to 19),
      Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(4),
      Sl_MIRQ => plb_v46_0_Sl_MIRQ(4 to 4),
      RX => fpga_0_RS232_0_RX_pin,
      TX => fpga_0_RS232_0_TX_pin,
      Interrupt => RS232_0_Interrupt
    );

  Hard_Ethernet_MAC_fifo : hard_ethernet_mac_fifo_wrapper
    port map (
      SPLB_Clk => clk_125_0000MHzPLL0_ADJUST,
      SPLB_Rst => plb_v46_0_SPLB_Rst(5),
      PLB_ABus => plb_v46_0_PLB_ABus,
      PLB_UABus => plb_v46_0_PLB_UABus,
      PLB_PAValid => plb_v46_0_PLB_PAValid,
      PLB_SAValid => plb_v46_0_PLB_SAValid,
      PLB_rdPrim => plb_v46_0_PLB_rdPrim(5),
      PLB_wrPrim => plb_v46_0_PLB_wrPrim(5),
      PLB_masterID => plb_v46_0_PLB_masterID(0 to 0),
      PLB_abort => plb_v46_0_PLB_abort,
      PLB_busLock => plb_v46_0_PLB_busLock,
      PLB_RNW => plb_v46_0_PLB_RNW,
      PLB_BE => plb_v46_0_PLB_BE,
      PLB_MSize => plb_v46_0_PLB_MSize,
      PLB_size => plb_v46_0_PLB_size,
      PLB_type => plb_v46_0_PLB_type,
      PLB_lockErr => plb_v46_0_PLB_lockErr,
      PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      PLB_reqPri => plb_v46_0_PLB_reqPri,
      PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      Sl_addrAck => plb_v46_0_Sl_addrAck(5),
      Sl_SSize => plb_v46_0_Sl_SSize(10 to 11),
      Sl_wait => plb_v46_0_Sl_wait(5),
      Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(5),
      Sl_wrDAck => plb_v46_0_Sl_wrDAck(5),
      Sl_wrComp => plb_v46_0_Sl_wrComp(5),
      Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(5),
      Sl_rdDBus => plb_v46_0_Sl_rdDBus(640 to 767),
      Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(20 to 23),
      Sl_rdDAck => plb_v46_0_Sl_rdDAck(5),
      Sl_rdComp => plb_v46_0_Sl_rdComp(5),
      Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(5),
      Sl_MBusy => plb_v46_0_Sl_MBusy(5 to 5),
      Sl_MWrErr => plb_v46_0_Sl_MWrErr(5 to 5),
      Sl_MRdErr => plb_v46_0_Sl_MRdErr(5 to 5),
      Sl_MIRQ => plb_v46_0_Sl_MIRQ(5 to 5),
      IP2INTC_Irpt => Hard_Ethernet_MAC_fifo_IP2INTC_Irpt,
      llink_rst => Hard_Ethernet_MAC_llink0_LL_RST_ACK,
      tx_llink_din => Hard_Ethernet_MAC_llink0_LL_Tx_Data,
      tx_llink_src_rdy_n => Hard_Ethernet_MAC_llink0_LL_Tx_SrcRdy_n,
      tx_llink_dest_rdy_n => Hard_Ethernet_MAC_llink0_LL_Tx_DstRdy_n,
      tx_llink_sof_n => Hard_Ethernet_MAC_llink0_LL_Tx_SOF_n,
      tx_llink_sop_n => Hard_Ethernet_MAC_llink0_LL_Tx_SOP_n,
      tx_llink_eof_n => Hard_Ethernet_MAC_llink0_LL_Tx_EOF_n,
      tx_llink_eop_n => Hard_Ethernet_MAC_llink0_LL_Tx_EOP_n,
      tx_llink_rem_n => Hard_Ethernet_MAC_llink0_LL_Tx_Rem,
      rx_llink_din => Hard_Ethernet_MAC_llink0_LL_Rx_Data,
      rx_llink_src_rdy_n => Hard_Ethernet_MAC_llink0_LL_Rx_SrcRdy_n,
      rx_llink_dest_rdy_n => Hard_Ethernet_MAC_llink0_LL_Rx_DstRdy_n,
      rx_llink_sof_n => Hard_Ethernet_MAC_llink0_LL_Rx_SOF_n,
      rx_llink_sop_n => Hard_Ethernet_MAC_llink0_LL_Rx_SOP_n,
      rx_llink_eof_n => Hard_Ethernet_MAC_llink0_LL_Rx_EOF_n,
      rx_llink_eop_n => Hard_Ethernet_MAC_llink0_LL_Rx_EOP_n,
      rx_llink_rem_n => Hard_Ethernet_MAC_llink0_LL_Rx_Rem
    );

  Hard_Ethernet_MAC : hard_ethernet_mac_wrapper
    port map (
      TemacIntc0_Irpt => Hard_Ethernet_MAC_TemacIntc0_Irpt,
      TemacIntc1_Irpt => open,
      TemacPhy_RST_n => fpga_0_Hard_Ethernet_MAC_TemacPhy_RST_n_pin,
      GTX_CLK_0 => net_gnd0,
      MGTCLK_P => net_gnd0,
      MGTCLK_N => net_gnd0,
      REFCLK => net_gnd0,
      DCLK => net_gnd0,
      SPLB_Clk => clk_125_0000MHzPLL0_ADJUST,
      SPLB_Rst => plb_v46_0_SPLB_Rst(6),
      Core_Clk => net_gnd0,
      PLB_ABus => plb_v46_0_PLB_ABus,
      PLB_UABus => plb_v46_0_PLB_UABus,
      PLB_PAValid => plb_v46_0_PLB_PAValid,
      PLB_SAValid => plb_v46_0_PLB_SAValid,
      PLB_rdPrim => plb_v46_0_PLB_rdPrim(6),
      PLB_wrPrim => plb_v46_0_PLB_wrPrim(6),
      PLB_masterID => plb_v46_0_PLB_masterID(0 to 0),
      PLB_abort => plb_v46_0_PLB_abort,
      PLB_busLock => plb_v46_0_PLB_busLock,
      PLB_RNW => plb_v46_0_PLB_RNW,
      PLB_BE => plb_v46_0_PLB_BE,
      PLB_MSize => plb_v46_0_PLB_MSize,
      PLB_size => plb_v46_0_PLB_size,
      PLB_type => plb_v46_0_PLB_type,
      PLB_lockErr => plb_v46_0_PLB_lockErr,
      PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      PLB_reqPri => plb_v46_0_PLB_reqPri,
      PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      Sl_addrAck => plb_v46_0_Sl_addrAck(6),
      Sl_SSize => plb_v46_0_Sl_SSize(12 to 13),
      Sl_wait => plb_v46_0_Sl_wait(6),
      Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(6),
      Sl_wrDAck => plb_v46_0_Sl_wrDAck(6),
      Sl_wrComp => plb_v46_0_Sl_wrComp(6),
      Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(6),
      Sl_rdDBus => plb_v46_0_Sl_rdDBus(768 to 895),
      Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(24 to 27),
      Sl_rdDAck => plb_v46_0_Sl_rdDAck(6),
      Sl_rdComp => plb_v46_0_Sl_rdComp(6),
      Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(6),
      Sl_MBusy => plb_v46_0_Sl_MBusy(6 to 6),
      Sl_MWrErr => plb_v46_0_Sl_MWrErr(6 to 6),
      Sl_MRdErr => plb_v46_0_Sl_MRdErr(6 to 6),
      Sl_MIRQ => plb_v46_0_Sl_MIRQ(6 to 6),
      LlinkTemac0_CLK => clk_125_0000MHzPLL0_ADJUST,
      LlinkTemac0_RST => Hard_Ethernet_MAC_llink0_LL_RST_ACK,
      LlinkTemac0_SOP_n => Hard_Ethernet_MAC_llink0_LL_Tx_SOP_n,
      LlinkTemac0_EOP_n => Hard_Ethernet_MAC_llink0_LL_Tx_EOP_n,
      LlinkTemac0_SOF_n => Hard_Ethernet_MAC_llink0_LL_Tx_SOF_n,
      LlinkTemac0_EOF_n => Hard_Ethernet_MAC_llink0_LL_Tx_EOF_n,
      LlinkTemac0_REM => Hard_Ethernet_MAC_llink0_LL_Tx_Rem,
      LlinkTemac0_Data => Hard_Ethernet_MAC_llink0_LL_Tx_Data,
      LlinkTemac0_SRC_RDY_n => Hard_Ethernet_MAC_llink0_LL_Tx_SrcRdy_n,
      Temac0Llink_DST_RDY_n => Hard_Ethernet_MAC_llink0_LL_Tx_DstRdy_n,
      Temac0Llink_SOP_n => Hard_Ethernet_MAC_llink0_LL_Rx_SOP_n,
      Temac0Llink_EOP_n => Hard_Ethernet_MAC_llink0_LL_Rx_EOP_n,
      Temac0Llink_SOF_n => Hard_Ethernet_MAC_llink0_LL_Rx_SOF_n,
      Temac0Llink_EOF_n => Hard_Ethernet_MAC_llink0_LL_Rx_EOF_n,
      Temac0Llink_REM => Hard_Ethernet_MAC_llink0_LL_Rx_Rem,
      Temac0Llink_Data => Hard_Ethernet_MAC_llink0_LL_Rx_Data,
      Temac0Llink_SRC_RDY_n => Hard_Ethernet_MAC_llink0_LL_Rx_SrcRdy_n,
      LlinkTemac0_DST_RDY_n => Hard_Ethernet_MAC_llink0_LL_Rx_DstRdy_n,
      LlinkTemac1_CLK => net_vcc0,
      LlinkTemac1_RST => net_vcc0,
      LlinkTemac1_SOP_n => net_vcc0,
      LlinkTemac1_EOP_n => net_vcc0,
      LlinkTemac1_SOF_n => net_vcc0,
      LlinkTemac1_EOF_n => net_vcc0,
      LlinkTemac1_REM => net_vcc4,
      LlinkTemac1_Data => net_gnd32(31 downto 0),
      LlinkTemac1_SRC_RDY_n => net_vcc0,
      Temac1Llink_DST_RDY_n => open,
      Temac1Llink_SOP_n => open,
      Temac1Llink_EOP_n => open,
      Temac1Llink_SOF_n => open,
      Temac1Llink_EOF_n => open,
      Temac1Llink_REM => open,
      Temac1Llink_Data => open,
      Temac1Llink_SRC_RDY_n => open,
      LlinkTemac1_DST_RDY_n => net_vcc0,
      MII_TXD_0 => fpga_0_Hard_Ethernet_MAC_MII_TXD_0_pin,
      MII_TX_EN_0 => fpga_0_Hard_Ethernet_MAC_MII_TX_EN_0_pin,
      MII_TX_ER_0 => fpga_0_Hard_Ethernet_MAC_MII_TX_ER_0_pin,
      MII_RXD_0 => fpga_0_Hard_Ethernet_MAC_MII_RXD_0_pin,
      MII_RX_DV_0 => fpga_0_Hard_Ethernet_MAC_MII_RX_DV_0_pin,
      MII_RX_ER_0 => fpga_0_Hard_Ethernet_MAC_MII_RX_ER_0_pin,
      MII_RX_CLK_0 => fpga_0_Hard_Ethernet_MAC_MII_RX_CLK_0_pin,
      MII_TX_CLK_0 => fpga_0_Hard_Ethernet_MAC_MII_TX_CLK_0_pin,
      MII_TXD_1 => open,
      MII_TX_EN_1 => open,
      MII_TX_ER_1 => open,
      MII_RXD_1 => net_gnd4(0 to 3),
      MII_RX_DV_1 => net_gnd0,
      MII_RX_ER_1 => net_gnd0,
      MII_RX_CLK_1 => net_gnd0,
      MII_TX_CLK_1 => net_gnd0,
      GMII_TXD_0 => open,
      GMII_TX_EN_0 => open,
      GMII_TX_ER_0 => open,
      GMII_TX_CLK_0 => open,
      GMII_RXD_0 => net_gnd8(0 to 7),
      GMII_RX_DV_0 => net_gnd0,
      GMII_RX_ER_0 => net_gnd0,
      GMII_RX_CLK_0 => net_gnd0,
      GMII_TXD_1 => open,
      GMII_TX_EN_1 => open,
      GMII_TX_ER_1 => open,
      GMII_TX_CLK_1 => open,
      GMII_RXD_1 => net_gnd8(0 to 7),
      GMII_RX_DV_1 => net_gnd0,
      GMII_RX_ER_1 => net_gnd0,
      GMII_RX_CLK_1 => net_gnd0,
      TXP_0 => open,
      TXN_0 => open,
      RXP_0 => net_vcc0,
      RXN_0 => net_gnd0,
      TXP_1 => open,
      TXN_1 => open,
      RXP_1 => net_vcc0,
      RXN_1 => net_gnd0,
      RGMII_TXD_0 => open,
      RGMII_TX_CTL_0 => open,
      RGMII_TXC_0 => open,
      RGMII_RXD_0 => net_gnd4(0 to 3),
      RGMII_RX_CTL_0 => net_gnd0,
      RGMII_RXC_0 => net_gnd0,
      RGMII_TXD_1 => open,
      RGMII_TX_CTL_1 => open,
      RGMII_TXC_1 => open,
      RGMII_RXD_1 => net_gnd4(0 to 3),
      RGMII_RX_CTL_1 => net_gnd0,
      RGMII_RXC_1 => net_gnd0,
      MDC_0 => fpga_0_Hard_Ethernet_MAC_MDC_0_pin,
      MDC_1 => open,
      HostMiimRdy => net_gnd0,
      HostRdData => net_gnd32,
      HostMiimSel => open,
      HostReq => open,
      HostAddr => open,
      HostEmac1Sel => open,
      Temac0AvbTxClk => open,
      Temac0AvbTxClkEn => open,
      Temac0AvbRxClk => open,
      Temac0AvbRxClkEn => open,
      Avb2Mac0TxData => net_gnd8(0 to 7),
      Avb2Mac0TxDataValid => net_gnd0,
      Avb2Mac0TxUnderrun => net_gnd0,
      Mac02AvbTxAck => open,
      Mac02AvbRxData => open,
      Mac02AvbRxDataValid => open,
      Mac02AvbRxFrameGood => open,
      Mac02AvbRxFrameBad => open,
      Temac02AvbTxData => open,
      Temac02AvbTxDataValid => open,
      Temac02AvbTxUnderrun => open,
      Avb2Temac0TxAck => net_gnd0,
      Avb2Temac0RxData => net_gnd8(0 to 7),
      Avb2Temac0RxDataValid => net_gnd0,
      Avb2Temac0RxFrameGood => net_gnd0,
      Avb2Temac0RxFrameBad => net_gnd0,
      Temac1AvbTxClk => open,
      Temac1AvbTxClkEn => open,
      Temac1AvbRxClk => open,
      Temac1AvbRxClkEn => open,
      Avb2Mac1TxData => net_gnd8(0 to 7),
      Avb2Mac1TxDataValid => net_gnd0,
      Avb2Mac1TxUnderrun => net_gnd0,
      Mac12AvbTxAck => open,
      Mac12AvbRxData => open,
      Mac12AvbRxDataValid => open,
      Mac12AvbRxFrameGood => open,
      Mac12AvbRxFrameBad => open,
      Temac12AvbTxData => open,
      Temac12AvbTxDataValid => open,
      Temac12AvbTxUnderrun => open,
      Avb2Temac1TxAck => net_gnd0,
      Avb2Temac1RxData => net_gnd8(0 to 7),
      Avb2Temac1RxDataValid => net_gnd0,
      Avb2Temac1RxFrameGood => net_gnd0,
      Avb2Temac1RxFrameBad => net_gnd0,
      TxClientClk_0 => open,
      ClientTxStat_0 => open,
      ClientTxStatsVld_0 => open,
      ClientTxStatsByteVld_0 => open,
      RxClientClk_0 => open,
      ClientRxStats_0 => open,
      ClientRxStatsVld_0 => open,
      ClientRxStatsByteVld_0 => open,
      TxClientClk_1 => open,
      ClientTxStat_1 => open,
      ClientTxStatsVld_1 => open,
      ClientTxStatsByteVld_1 => open,
      RxClientClk_1 => open,
      ClientRxStats_1 => open,
      ClientRxStatsVld_1 => open,
      ClientRxStatsByteVld_1 => open,
      MDIO_0_I => fpga_0_Hard_Ethernet_MAC_MDIO_0_pin_I,
      MDIO_0_O => fpga_0_Hard_Ethernet_MAC_MDIO_0_pin_O,
      MDIO_0_T => fpga_0_Hard_Ethernet_MAC_MDIO_0_pin_T,
      MDIO_1_I => net_vcc0,
      MDIO_1_O => open,
      MDIO_1_T => open
    );

  DDR_SDRAM_0 : ddr_sdram_0_wrapper
    port map (
      FSL0_M_Clk => net_vcc0,
      FSL0_M_Write => net_gnd0,
      FSL0_M_Data => net_gnd32(31 downto 0),
      FSL0_M_Control => net_gnd0,
      FSL0_M_Full => open,
      FSL0_S_Clk => net_gnd0,
      FSL0_S_Read => net_gnd0,
      FSL0_S_Data => open,
      FSL0_S_Control => open,
      FSL0_S_Exists => open,
      FSL0_B_M_Clk => net_vcc0,
      FSL0_B_M_Write => net_gnd0,
      FSL0_B_M_Data => net_gnd32(31 downto 0),
      FSL0_B_M_Control => net_gnd0,
      FSL0_B_M_Full => open,
      FSL0_B_S_Clk => net_gnd0,
      FSL0_B_S_Read => net_gnd0,
      FSL0_B_S_Data => open,
      FSL0_B_S_Control => open,
      FSL0_B_S_Exists => open,
      SPLB0_Clk => clk_125_0000MHzPLL0_ADJUST,
      SPLB0_Rst => plb_v46_0_SPLB_Rst(7),
      SPLB0_PLB_ABus => plb_v46_0_PLB_ABus,
      SPLB0_PLB_PAValid => plb_v46_0_PLB_PAValid,
      SPLB0_PLB_SAValid => plb_v46_0_PLB_SAValid,
      SPLB0_PLB_masterID => plb_v46_0_PLB_masterID(0 to 0),
      SPLB0_PLB_RNW => plb_v46_0_PLB_RNW,
      SPLB0_PLB_BE => plb_v46_0_PLB_BE,
      SPLB0_PLB_UABus => plb_v46_0_PLB_UABus,
      SPLB0_PLB_rdPrim => plb_v46_0_PLB_rdPrim(7),
      SPLB0_PLB_wrPrim => plb_v46_0_PLB_wrPrim(7),
      SPLB0_PLB_abort => plb_v46_0_PLB_abort,
      SPLB0_PLB_busLock => plb_v46_0_PLB_busLock,
      SPLB0_PLB_MSize => plb_v46_0_PLB_MSize,
      SPLB0_PLB_size => plb_v46_0_PLB_size,
      SPLB0_PLB_type => plb_v46_0_PLB_type,
      SPLB0_PLB_lockErr => plb_v46_0_PLB_lockErr,
      SPLB0_PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      SPLB0_PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      SPLB0_PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      SPLB0_PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      SPLB0_PLB_reqPri => plb_v46_0_PLB_reqPri,
      SPLB0_PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      SPLB0_PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      SPLB0_PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      SPLB0_PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      SPLB0_Sl_addrAck => plb_v46_0_Sl_addrAck(7),
      SPLB0_Sl_SSize => plb_v46_0_Sl_SSize(14 to 15),
      SPLB0_Sl_wait => plb_v46_0_Sl_wait(7),
      SPLB0_Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(7),
      SPLB0_Sl_wrDAck => plb_v46_0_Sl_wrDAck(7),
      SPLB0_Sl_wrComp => plb_v46_0_Sl_wrComp(7),
      SPLB0_Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(7),
      SPLB0_Sl_rdDBus => plb_v46_0_Sl_rdDBus(896 to 1023),
      SPLB0_Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(28 to 31),
      SPLB0_Sl_rdDAck => plb_v46_0_Sl_rdDAck(7),
      SPLB0_Sl_rdComp => plb_v46_0_Sl_rdComp(7),
      SPLB0_Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(7),
      SPLB0_Sl_MBusy => plb_v46_0_Sl_MBusy(7 to 7),
      SPLB0_Sl_MRdErr => plb_v46_0_Sl_MRdErr(7 to 7),
      SPLB0_Sl_MWrErr => plb_v46_0_Sl_MWrErr(7 to 7),
      SPLB0_Sl_MIRQ => plb_v46_0_Sl_MIRQ(7 to 7),
      SDMA0_Clk => net_gnd0,
      SDMA0_Rx_IntOut => open,
      SDMA0_Tx_IntOut => open,
      SDMA0_RstOut => open,
      SDMA0_TX_D => open,
      SDMA0_TX_Rem => open,
      SDMA0_TX_SOF => open,
      SDMA0_TX_EOF => open,
      SDMA0_TX_SOP => open,
      SDMA0_TX_EOP => open,
      SDMA0_TX_Src_Rdy => open,
      SDMA0_TX_Dst_Rdy => net_vcc0,
      SDMA0_RX_D => net_gnd32(31 downto 0),
      SDMA0_RX_Rem => net_vcc4,
      SDMA0_RX_SOF => net_vcc0,
      SDMA0_RX_EOF => net_vcc0,
      SDMA0_RX_SOP => net_vcc0,
      SDMA0_RX_EOP => net_vcc0,
      SDMA0_RX_Src_Rdy => net_vcc0,
      SDMA0_RX_Dst_Rdy => open,
      SDMA_CTRL0_Clk => net_vcc0,
      SDMA_CTRL0_Rst => net_gnd0,
      SDMA_CTRL0_PLB_ABus => net_gnd32(31 downto 0),
      SDMA_CTRL0_PLB_PAValid => net_gnd0,
      SDMA_CTRL0_PLB_SAValid => net_gnd0,
      SDMA_CTRL0_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL0_PLB_RNW => net_gnd0,
      SDMA_CTRL0_PLB_BE => net_gnd8,
      SDMA_CTRL0_PLB_UABus => net_gnd32(31 downto 0),
      SDMA_CTRL0_PLB_rdPrim => net_gnd0,
      SDMA_CTRL0_PLB_wrPrim => net_gnd0,
      SDMA_CTRL0_PLB_abort => net_gnd0,
      SDMA_CTRL0_PLB_busLock => net_gnd0,
      SDMA_CTRL0_PLB_MSize => net_gnd2,
      SDMA_CTRL0_PLB_size => net_gnd4,
      SDMA_CTRL0_PLB_type => net_gnd3,
      SDMA_CTRL0_PLB_lockErr => net_gnd0,
      SDMA_CTRL0_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL0_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL0_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL0_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL0_PLB_reqPri => net_gnd2,
      SDMA_CTRL0_PLB_TAttribute => net_gnd16(15 downto 0),
      SDMA_CTRL0_PLB_rdBurst => net_gnd0,
      SDMA_CTRL0_PLB_wrBurst => net_gnd0,
      SDMA_CTRL0_PLB_wrDBus => net_gnd64,
      SDMA_CTRL0_Sl_addrAck => open,
      SDMA_CTRL0_Sl_SSize => open,
      SDMA_CTRL0_Sl_wait => open,
      SDMA_CTRL0_Sl_rearbitrate => open,
      SDMA_CTRL0_Sl_wrDAck => open,
      SDMA_CTRL0_Sl_wrComp => open,
      SDMA_CTRL0_Sl_wrBTerm => open,
      SDMA_CTRL0_Sl_rdDBus => open,
      SDMA_CTRL0_Sl_rdWdAddr => open,
      SDMA_CTRL0_Sl_rdDAck => open,
      SDMA_CTRL0_Sl_rdComp => open,
      SDMA_CTRL0_Sl_rdBTerm => open,
      SDMA_CTRL0_Sl_MBusy => open,
      SDMA_CTRL0_Sl_MRdErr => open,
      SDMA_CTRL0_Sl_MWrErr => open,
      SDMA_CTRL0_Sl_MIRQ => open,
      PIM0_Addr => net_gnd32,
      PIM0_AddrReq => net_gnd0,
      PIM0_AddrAck => open,
      PIM0_RNW => net_gnd0,
      PIM0_Size => net_gnd4(0 to 3),
      PIM0_RdModWr => net_gnd0,
      PIM0_WrFIFO_Data => net_gnd64(0 to 63),
      PIM0_WrFIFO_BE => net_gnd8(0 to 7),
      PIM0_WrFIFO_Push => net_gnd0,
      PIM0_RdFIFO_Data => open,
      PIM0_RdFIFO_Pop => net_gnd0,
      PIM0_RdFIFO_RdWdAddr => open,
      PIM0_WrFIFO_Empty => open,
      PIM0_WrFIFO_AlmostFull => open,
      PIM0_WrFIFO_Flush => net_gnd0,
      PIM0_RdFIFO_Empty => open,
      PIM0_RdFIFO_Flush => net_gnd0,
      PIM0_RdFIFO_Latency => open,
      PIM0_InitDone => open,
      PPC440MC0_MIMCReadNotWrite => net_gnd0,
      PPC440MC0_MIMCAddress => net_gnd36,
      PPC440MC0_MIMCAddressValid => net_gnd0,
      PPC440MC0_MIMCWriteData => net_gnd128,
      PPC440MC0_MIMCWriteDataValid => net_gnd0,
      PPC440MC0_MIMCByteEnable => net_gnd16(15 downto 0),
      PPC440MC0_MIMCBankConflict => net_gnd0,
      PPC440MC0_MIMCRowConflict => net_gnd0,
      PPC440MC0_MCMIReadData => open,
      PPC440MC0_MCMIReadDataValid => open,
      PPC440MC0_MCMIReadDataErr => open,
      PPC440MC0_MCMIAddrReadyToAccept => open,
      VFBC0_Cmd_Clk => net_gnd0,
      VFBC0_Cmd_Reset => net_gnd0,
      VFBC0_Cmd_Data => net_gnd32,
      VFBC0_Cmd_Write => net_gnd0,
      VFBC0_Cmd_End => net_gnd0,
      VFBC0_Cmd_Full => open,
      VFBC0_Cmd_Almost_Full => open,
      VFBC0_Cmd_Idle => open,
      VFBC0_Wd_Clk => net_gnd0,
      VFBC0_Wd_Reset => net_gnd0,
      VFBC0_Wd_Write => net_gnd0,
      VFBC0_Wd_End_Burst => net_gnd0,
      VFBC0_Wd_Flush => net_gnd0,
      VFBC0_Wd_Data => net_gnd32,
      VFBC0_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC0_Wd_Full => open,
      VFBC0_Wd_Almost_Full => open,
      VFBC0_Rd_Clk => net_gnd0,
      VFBC0_Rd_Reset => net_gnd0,
      VFBC0_Rd_Read => net_gnd0,
      VFBC0_Rd_End_Burst => net_gnd0,
      VFBC0_Rd_Flush => net_gnd0,
      VFBC0_Rd_Data => open,
      VFBC0_Rd_Empty => open,
      VFBC0_Rd_Almost_Empty => open,
      MCB0_cmd_clk => net_gnd0,
      MCB0_cmd_en => net_gnd0,
      MCB0_cmd_instr => net_gnd3(0 to 2),
      MCB0_cmd_bl => net_gnd6,
      MCB0_cmd_byte_addr => net_gnd30,
      MCB0_cmd_empty => open,
      MCB0_cmd_full => open,
      MCB0_wr_clk => net_gnd0,
      MCB0_wr_en => net_gnd0,
      MCB0_wr_mask => net_gnd8(0 to 7),
      MCB0_wr_data => net_gnd64(0 to 63),
      MCB0_wr_full => open,
      MCB0_wr_empty => open,
      MCB0_wr_count => open,
      MCB0_wr_underrun => open,
      MCB0_wr_error => open,
      MCB0_rd_clk => net_gnd0,
      MCB0_rd_en => net_gnd0,
      MCB0_rd_data => open,
      MCB0_rd_full => open,
      MCB0_rd_empty => open,
      MCB0_rd_count => open,
      MCB0_rd_overflow => open,
      MCB0_rd_error => open,
      FSL1_M_Clk => net_vcc0,
      FSL1_M_Write => net_gnd0,
      FSL1_M_Data => net_gnd32(31 downto 0),
      FSL1_M_Control => net_gnd0,
      FSL1_M_Full => open,
      FSL1_S_Clk => net_gnd0,
      FSL1_S_Read => net_gnd0,
      FSL1_S_Data => open,
      FSL1_S_Control => open,
      FSL1_S_Exists => open,
      FSL1_B_M_Clk => net_vcc0,
      FSL1_B_M_Write => net_gnd0,
      FSL1_B_M_Data => net_gnd32(31 downto 0),
      FSL1_B_M_Control => net_gnd0,
      FSL1_B_M_Full => open,
      FSL1_B_S_Clk => net_gnd0,
      FSL1_B_S_Read => net_gnd0,
      FSL1_B_S_Data => open,
      FSL1_B_S_Control => open,
      FSL1_B_S_Exists => open,
      SPLB1_Clk => net_vcc0,
      SPLB1_Rst => net_gnd0,
      SPLB1_PLB_ABus => net_gnd32(31 downto 0),
      SPLB1_PLB_PAValid => net_gnd0,
      SPLB1_PLB_SAValid => net_gnd0,
      SPLB1_PLB_masterID => net_gnd1(0 to 0),
      SPLB1_PLB_RNW => net_gnd0,
      SPLB1_PLB_BE => net_gnd8,
      SPLB1_PLB_UABus => net_gnd32(31 downto 0),
      SPLB1_PLB_rdPrim => net_gnd0,
      SPLB1_PLB_wrPrim => net_gnd0,
      SPLB1_PLB_abort => net_gnd0,
      SPLB1_PLB_busLock => net_gnd0,
      SPLB1_PLB_MSize => net_gnd2,
      SPLB1_PLB_size => net_gnd4,
      SPLB1_PLB_type => net_gnd3,
      SPLB1_PLB_lockErr => net_gnd0,
      SPLB1_PLB_wrPendReq => net_gnd0,
      SPLB1_PLB_wrPendPri => net_gnd2,
      SPLB1_PLB_rdPendReq => net_gnd0,
      SPLB1_PLB_rdPendPri => net_gnd2,
      SPLB1_PLB_reqPri => net_gnd2,
      SPLB1_PLB_TAttribute => net_gnd16(15 downto 0),
      SPLB1_PLB_rdBurst => net_gnd0,
      SPLB1_PLB_wrBurst => net_gnd0,
      SPLB1_PLB_wrDBus => net_gnd64,
      SPLB1_Sl_addrAck => open,
      SPLB1_Sl_SSize => open,
      SPLB1_Sl_wait => open,
      SPLB1_Sl_rearbitrate => open,
      SPLB1_Sl_wrDAck => open,
      SPLB1_Sl_wrComp => open,
      SPLB1_Sl_wrBTerm => open,
      SPLB1_Sl_rdDBus => open,
      SPLB1_Sl_rdWdAddr => open,
      SPLB1_Sl_rdDAck => open,
      SPLB1_Sl_rdComp => open,
      SPLB1_Sl_rdBTerm => open,
      SPLB1_Sl_MBusy => open,
      SPLB1_Sl_MRdErr => open,
      SPLB1_Sl_MWrErr => open,
      SPLB1_Sl_MIRQ => open,
      SDMA1_Clk => net_gnd0,
      SDMA1_Rx_IntOut => open,
      SDMA1_Tx_IntOut => open,
      SDMA1_RstOut => open,
      SDMA1_TX_D => open,
      SDMA1_TX_Rem => open,
      SDMA1_TX_SOF => open,
      SDMA1_TX_EOF => open,
      SDMA1_TX_SOP => open,
      SDMA1_TX_EOP => open,
      SDMA1_TX_Src_Rdy => open,
      SDMA1_TX_Dst_Rdy => net_vcc0,
      SDMA1_RX_D => net_gnd32(31 downto 0),
      SDMA1_RX_Rem => net_vcc4,
      SDMA1_RX_SOF => net_vcc0,
      SDMA1_RX_EOF => net_vcc0,
      SDMA1_RX_SOP => net_vcc0,
      SDMA1_RX_EOP => net_vcc0,
      SDMA1_RX_Src_Rdy => net_vcc0,
      SDMA1_RX_Dst_Rdy => open,
      SDMA_CTRL1_Clk => net_vcc0,
      SDMA_CTRL1_Rst => net_gnd0,
      SDMA_CTRL1_PLB_ABus => net_gnd32(31 downto 0),
      SDMA_CTRL1_PLB_PAValid => net_gnd0,
      SDMA_CTRL1_PLB_SAValid => net_gnd0,
      SDMA_CTRL1_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL1_PLB_RNW => net_gnd0,
      SDMA_CTRL1_PLB_BE => net_gnd8,
      SDMA_CTRL1_PLB_UABus => net_gnd32(31 downto 0),
      SDMA_CTRL1_PLB_rdPrim => net_gnd0,
      SDMA_CTRL1_PLB_wrPrim => net_gnd0,
      SDMA_CTRL1_PLB_abort => net_gnd0,
      SDMA_CTRL1_PLB_busLock => net_gnd0,
      SDMA_CTRL1_PLB_MSize => net_gnd2,
      SDMA_CTRL1_PLB_size => net_gnd4,
      SDMA_CTRL1_PLB_type => net_gnd3,
      SDMA_CTRL1_PLB_lockErr => net_gnd0,
      SDMA_CTRL1_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL1_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL1_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL1_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL1_PLB_reqPri => net_gnd2,
      SDMA_CTRL1_PLB_TAttribute => net_gnd16(15 downto 0),
      SDMA_CTRL1_PLB_rdBurst => net_gnd0,
      SDMA_CTRL1_PLB_wrBurst => net_gnd0,
      SDMA_CTRL1_PLB_wrDBus => net_gnd64,
      SDMA_CTRL1_Sl_addrAck => open,
      SDMA_CTRL1_Sl_SSize => open,
      SDMA_CTRL1_Sl_wait => open,
      SDMA_CTRL1_Sl_rearbitrate => open,
      SDMA_CTRL1_Sl_wrDAck => open,
      SDMA_CTRL1_Sl_wrComp => open,
      SDMA_CTRL1_Sl_wrBTerm => open,
      SDMA_CTRL1_Sl_rdDBus => open,
      SDMA_CTRL1_Sl_rdWdAddr => open,
      SDMA_CTRL1_Sl_rdDAck => open,
      SDMA_CTRL1_Sl_rdComp => open,
      SDMA_CTRL1_Sl_rdBTerm => open,
      SDMA_CTRL1_Sl_MBusy => open,
      SDMA_CTRL1_Sl_MRdErr => open,
      SDMA_CTRL1_Sl_MWrErr => open,
      SDMA_CTRL1_Sl_MIRQ => open,
      PIM1_Addr => net_gnd32,
      PIM1_AddrReq => net_gnd0,
      PIM1_AddrAck => open,
      PIM1_RNW => net_gnd0,
      PIM1_Size => net_gnd4(0 to 3),
      PIM1_RdModWr => net_gnd0,
      PIM1_WrFIFO_Data => net_gnd64(0 to 63),
      PIM1_WrFIFO_BE => net_gnd8(0 to 7),
      PIM1_WrFIFO_Push => net_gnd0,
      PIM1_RdFIFO_Data => open,
      PIM1_RdFIFO_Pop => net_gnd0,
      PIM1_RdFIFO_RdWdAddr => open,
      PIM1_WrFIFO_Empty => open,
      PIM1_WrFIFO_AlmostFull => open,
      PIM1_WrFIFO_Flush => net_gnd0,
      PIM1_RdFIFO_Empty => open,
      PIM1_RdFIFO_Flush => net_gnd0,
      PIM1_RdFIFO_Latency => open,
      PIM1_InitDone => open,
      PPC440MC1_MIMCReadNotWrite => net_gnd0,
      PPC440MC1_MIMCAddress => net_gnd36,
      PPC440MC1_MIMCAddressValid => net_gnd0,
      PPC440MC1_MIMCWriteData => net_gnd128,
      PPC440MC1_MIMCWriteDataValid => net_gnd0,
      PPC440MC1_MIMCByteEnable => net_gnd16(15 downto 0),
      PPC440MC1_MIMCBankConflict => net_gnd0,
      PPC440MC1_MIMCRowConflict => net_gnd0,
      PPC440MC1_MCMIReadData => open,
      PPC440MC1_MCMIReadDataValid => open,
      PPC440MC1_MCMIReadDataErr => open,
      PPC440MC1_MCMIAddrReadyToAccept => open,
      VFBC1_Cmd_Clk => net_gnd0,
      VFBC1_Cmd_Reset => net_gnd0,
      VFBC1_Cmd_Data => net_gnd32,
      VFBC1_Cmd_Write => net_gnd0,
      VFBC1_Cmd_End => net_gnd0,
      VFBC1_Cmd_Full => open,
      VFBC1_Cmd_Almost_Full => open,
      VFBC1_Cmd_Idle => open,
      VFBC1_Wd_Clk => net_gnd0,
      VFBC1_Wd_Reset => net_gnd0,
      VFBC1_Wd_Write => net_gnd0,
      VFBC1_Wd_End_Burst => net_gnd0,
      VFBC1_Wd_Flush => net_gnd0,
      VFBC1_Wd_Data => net_gnd32,
      VFBC1_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC1_Wd_Full => open,
      VFBC1_Wd_Almost_Full => open,
      VFBC1_Rd_Clk => net_gnd0,
      VFBC1_Rd_Reset => net_gnd0,
      VFBC1_Rd_Read => net_gnd0,
      VFBC1_Rd_End_Burst => net_gnd0,
      VFBC1_Rd_Flush => net_gnd0,
      VFBC1_Rd_Data => open,
      VFBC1_Rd_Empty => open,
      VFBC1_Rd_Almost_Empty => open,
      MCB1_cmd_clk => net_gnd0,
      MCB1_cmd_en => net_gnd0,
      MCB1_cmd_instr => net_gnd3(0 to 2),
      MCB1_cmd_bl => net_gnd6,
      MCB1_cmd_byte_addr => net_gnd30,
      MCB1_cmd_empty => open,
      MCB1_cmd_full => open,
      MCB1_wr_clk => net_gnd0,
      MCB1_wr_en => net_gnd0,
      MCB1_wr_mask => net_gnd8(0 to 7),
      MCB1_wr_data => net_gnd64(0 to 63),
      MCB1_wr_full => open,
      MCB1_wr_empty => open,
      MCB1_wr_count => open,
      MCB1_wr_underrun => open,
      MCB1_wr_error => open,
      MCB1_rd_clk => net_gnd0,
      MCB1_rd_en => net_gnd0,
      MCB1_rd_data => open,
      MCB1_rd_full => open,
      MCB1_rd_empty => open,
      MCB1_rd_count => open,
      MCB1_rd_overflow => open,
      MCB1_rd_error => open,
      FSL2_M_Clk => net_vcc0,
      FSL2_M_Write => net_gnd0,
      FSL2_M_Data => net_gnd32(31 downto 0),
      FSL2_M_Control => net_gnd0,
      FSL2_M_Full => open,
      FSL2_S_Clk => net_gnd0,
      FSL2_S_Read => net_gnd0,
      FSL2_S_Data => open,
      FSL2_S_Control => open,
      FSL2_S_Exists => open,
      FSL2_B_M_Clk => net_vcc0,
      FSL2_B_M_Write => net_gnd0,
      FSL2_B_M_Data => net_gnd32(31 downto 0),
      FSL2_B_M_Control => net_gnd0,
      FSL2_B_M_Full => open,
      FSL2_B_S_Clk => net_gnd0,
      FSL2_B_S_Read => net_gnd0,
      FSL2_B_S_Data => open,
      FSL2_B_S_Control => open,
      FSL2_B_S_Exists => open,
      SPLB2_Clk => net_vcc0,
      SPLB2_Rst => net_gnd0,
      SPLB2_PLB_ABus => net_gnd32(31 downto 0),
      SPLB2_PLB_PAValid => net_gnd0,
      SPLB2_PLB_SAValid => net_gnd0,
      SPLB2_PLB_masterID => net_gnd1(0 to 0),
      SPLB2_PLB_RNW => net_gnd0,
      SPLB2_PLB_BE => net_gnd8,
      SPLB2_PLB_UABus => net_gnd32(31 downto 0),
      SPLB2_PLB_rdPrim => net_gnd0,
      SPLB2_PLB_wrPrim => net_gnd0,
      SPLB2_PLB_abort => net_gnd0,
      SPLB2_PLB_busLock => net_gnd0,
      SPLB2_PLB_MSize => net_gnd2,
      SPLB2_PLB_size => net_gnd4,
      SPLB2_PLB_type => net_gnd3,
      SPLB2_PLB_lockErr => net_gnd0,
      SPLB2_PLB_wrPendReq => net_gnd0,
      SPLB2_PLB_wrPendPri => net_gnd2,
      SPLB2_PLB_rdPendReq => net_gnd0,
      SPLB2_PLB_rdPendPri => net_gnd2,
      SPLB2_PLB_reqPri => net_gnd2,
      SPLB2_PLB_TAttribute => net_gnd16(15 downto 0),
      SPLB2_PLB_rdBurst => net_gnd0,
      SPLB2_PLB_wrBurst => net_gnd0,
      SPLB2_PLB_wrDBus => net_gnd64,
      SPLB2_Sl_addrAck => open,
      SPLB2_Sl_SSize => open,
      SPLB2_Sl_wait => open,
      SPLB2_Sl_rearbitrate => open,
      SPLB2_Sl_wrDAck => open,
      SPLB2_Sl_wrComp => open,
      SPLB2_Sl_wrBTerm => open,
      SPLB2_Sl_rdDBus => open,
      SPLB2_Sl_rdWdAddr => open,
      SPLB2_Sl_rdDAck => open,
      SPLB2_Sl_rdComp => open,
      SPLB2_Sl_rdBTerm => open,
      SPLB2_Sl_MBusy => open,
      SPLB2_Sl_MRdErr => open,
      SPLB2_Sl_MWrErr => open,
      SPLB2_Sl_MIRQ => open,
      SDMA2_Clk => net_gnd0,
      SDMA2_Rx_IntOut => open,
      SDMA2_Tx_IntOut => open,
      SDMA2_RstOut => open,
      SDMA2_TX_D => open,
      SDMA2_TX_Rem => open,
      SDMA2_TX_SOF => open,
      SDMA2_TX_EOF => open,
      SDMA2_TX_SOP => open,
      SDMA2_TX_EOP => open,
      SDMA2_TX_Src_Rdy => open,
      SDMA2_TX_Dst_Rdy => net_vcc0,
      SDMA2_RX_D => net_gnd32(31 downto 0),
      SDMA2_RX_Rem => net_vcc4,
      SDMA2_RX_SOF => net_vcc0,
      SDMA2_RX_EOF => net_vcc0,
      SDMA2_RX_SOP => net_vcc0,
      SDMA2_RX_EOP => net_vcc0,
      SDMA2_RX_Src_Rdy => net_vcc0,
      SDMA2_RX_Dst_Rdy => open,
      SDMA_CTRL2_Clk => net_vcc0,
      SDMA_CTRL2_Rst => net_gnd0,
      SDMA_CTRL2_PLB_ABus => net_gnd32(31 downto 0),
      SDMA_CTRL2_PLB_PAValid => net_gnd0,
      SDMA_CTRL2_PLB_SAValid => net_gnd0,
      SDMA_CTRL2_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL2_PLB_RNW => net_gnd0,
      SDMA_CTRL2_PLB_BE => net_gnd8,
      SDMA_CTRL2_PLB_UABus => net_gnd32(31 downto 0),
      SDMA_CTRL2_PLB_rdPrim => net_gnd0,
      SDMA_CTRL2_PLB_wrPrim => net_gnd0,
      SDMA_CTRL2_PLB_abort => net_gnd0,
      SDMA_CTRL2_PLB_busLock => net_gnd0,
      SDMA_CTRL2_PLB_MSize => net_gnd2,
      SDMA_CTRL2_PLB_size => net_gnd4,
      SDMA_CTRL2_PLB_type => net_gnd3,
      SDMA_CTRL2_PLB_lockErr => net_gnd0,
      SDMA_CTRL2_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL2_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL2_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL2_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL2_PLB_reqPri => net_gnd2,
      SDMA_CTRL2_PLB_TAttribute => net_gnd16(15 downto 0),
      SDMA_CTRL2_PLB_rdBurst => net_gnd0,
      SDMA_CTRL2_PLB_wrBurst => net_gnd0,
      SDMA_CTRL2_PLB_wrDBus => net_gnd64,
      SDMA_CTRL2_Sl_addrAck => open,
      SDMA_CTRL2_Sl_SSize => open,
      SDMA_CTRL2_Sl_wait => open,
      SDMA_CTRL2_Sl_rearbitrate => open,
      SDMA_CTRL2_Sl_wrDAck => open,
      SDMA_CTRL2_Sl_wrComp => open,
      SDMA_CTRL2_Sl_wrBTerm => open,
      SDMA_CTRL2_Sl_rdDBus => open,
      SDMA_CTRL2_Sl_rdWdAddr => open,
      SDMA_CTRL2_Sl_rdDAck => open,
      SDMA_CTRL2_Sl_rdComp => open,
      SDMA_CTRL2_Sl_rdBTerm => open,
      SDMA_CTRL2_Sl_MBusy => open,
      SDMA_CTRL2_Sl_MRdErr => open,
      SDMA_CTRL2_Sl_MWrErr => open,
      SDMA_CTRL2_Sl_MIRQ => open,
      PIM2_Addr => net_gnd32,
      PIM2_AddrReq => net_gnd0,
      PIM2_AddrAck => open,
      PIM2_RNW => net_gnd0,
      PIM2_Size => net_gnd4(0 to 3),
      PIM2_RdModWr => net_gnd0,
      PIM2_WrFIFO_Data => net_gnd64(0 to 63),
      PIM2_WrFIFO_BE => net_gnd8(0 to 7),
      PIM2_WrFIFO_Push => net_gnd0,
      PIM2_RdFIFO_Data => open,
      PIM2_RdFIFO_Pop => net_gnd0,
      PIM2_RdFIFO_RdWdAddr => open,
      PIM2_WrFIFO_Empty => open,
      PIM2_WrFIFO_AlmostFull => open,
      PIM2_WrFIFO_Flush => net_gnd0,
      PIM2_RdFIFO_Empty => open,
      PIM2_RdFIFO_Flush => net_gnd0,
      PIM2_RdFIFO_Latency => open,
      PIM2_InitDone => open,
      PPC440MC2_MIMCReadNotWrite => net_gnd0,
      PPC440MC2_MIMCAddress => net_gnd36,
      PPC440MC2_MIMCAddressValid => net_gnd0,
      PPC440MC2_MIMCWriteData => net_gnd128,
      PPC440MC2_MIMCWriteDataValid => net_gnd0,
      PPC440MC2_MIMCByteEnable => net_gnd16(15 downto 0),
      PPC440MC2_MIMCBankConflict => net_gnd0,
      PPC440MC2_MIMCRowConflict => net_gnd0,
      PPC440MC2_MCMIReadData => open,
      PPC440MC2_MCMIReadDataValid => open,
      PPC440MC2_MCMIReadDataErr => open,
      PPC440MC2_MCMIAddrReadyToAccept => open,
      VFBC2_Cmd_Clk => net_gnd0,
      VFBC2_Cmd_Reset => net_gnd0,
      VFBC2_Cmd_Data => net_gnd32,
      VFBC2_Cmd_Write => net_gnd0,
      VFBC2_Cmd_End => net_gnd0,
      VFBC2_Cmd_Full => open,
      VFBC2_Cmd_Almost_Full => open,
      VFBC2_Cmd_Idle => open,
      VFBC2_Wd_Clk => net_gnd0,
      VFBC2_Wd_Reset => net_gnd0,
      VFBC2_Wd_Write => net_gnd0,
      VFBC2_Wd_End_Burst => net_gnd0,
      VFBC2_Wd_Flush => net_gnd0,
      VFBC2_Wd_Data => net_gnd32,
      VFBC2_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC2_Wd_Full => open,
      VFBC2_Wd_Almost_Full => open,
      VFBC2_Rd_Clk => net_gnd0,
      VFBC2_Rd_Reset => net_gnd0,
      VFBC2_Rd_Read => net_gnd0,
      VFBC2_Rd_End_Burst => net_gnd0,
      VFBC2_Rd_Flush => net_gnd0,
      VFBC2_Rd_Data => open,
      VFBC2_Rd_Empty => open,
      VFBC2_Rd_Almost_Empty => open,
      MCB2_cmd_clk => net_gnd0,
      MCB2_cmd_en => net_gnd0,
      MCB2_cmd_instr => net_gnd3(0 to 2),
      MCB2_cmd_bl => net_gnd6,
      MCB2_cmd_byte_addr => net_gnd30,
      MCB2_cmd_empty => open,
      MCB2_cmd_full => open,
      MCB2_wr_clk => net_gnd0,
      MCB2_wr_en => net_gnd0,
      MCB2_wr_mask => net_gnd8(0 to 7),
      MCB2_wr_data => net_gnd64(0 to 63),
      MCB2_wr_full => open,
      MCB2_wr_empty => open,
      MCB2_wr_count => open,
      MCB2_wr_underrun => open,
      MCB2_wr_error => open,
      MCB2_rd_clk => net_gnd0,
      MCB2_rd_en => net_gnd0,
      MCB2_rd_data => open,
      MCB2_rd_full => open,
      MCB2_rd_empty => open,
      MCB2_rd_count => open,
      MCB2_rd_overflow => open,
      MCB2_rd_error => open,
      FSL3_M_Clk => net_vcc0,
      FSL3_M_Write => net_gnd0,
      FSL3_M_Data => net_gnd32(31 downto 0),
      FSL3_M_Control => net_gnd0,
      FSL3_M_Full => open,
      FSL3_S_Clk => net_gnd0,
      FSL3_S_Read => net_gnd0,
      FSL3_S_Data => open,
      FSL3_S_Control => open,
      FSL3_S_Exists => open,
      FSL3_B_M_Clk => net_vcc0,
      FSL3_B_M_Write => net_gnd0,
      FSL3_B_M_Data => net_gnd32(31 downto 0),
      FSL3_B_M_Control => net_gnd0,
      FSL3_B_M_Full => open,
      FSL3_B_S_Clk => net_gnd0,
      FSL3_B_S_Read => net_gnd0,
      FSL3_B_S_Data => open,
      FSL3_B_S_Control => open,
      FSL3_B_S_Exists => open,
      SPLB3_Clk => net_vcc0,
      SPLB3_Rst => net_gnd0,
      SPLB3_PLB_ABus => net_gnd32(31 downto 0),
      SPLB3_PLB_PAValid => net_gnd0,
      SPLB3_PLB_SAValid => net_gnd0,
      SPLB3_PLB_masterID => net_gnd1(0 to 0),
      SPLB3_PLB_RNW => net_gnd0,
      SPLB3_PLB_BE => net_gnd8,
      SPLB3_PLB_UABus => net_gnd32(31 downto 0),
      SPLB3_PLB_rdPrim => net_gnd0,
      SPLB3_PLB_wrPrim => net_gnd0,
      SPLB3_PLB_abort => net_gnd0,
      SPLB3_PLB_busLock => net_gnd0,
      SPLB3_PLB_MSize => net_gnd2,
      SPLB3_PLB_size => net_gnd4,
      SPLB3_PLB_type => net_gnd3,
      SPLB3_PLB_lockErr => net_gnd0,
      SPLB3_PLB_wrPendReq => net_gnd0,
      SPLB3_PLB_wrPendPri => net_gnd2,
      SPLB3_PLB_rdPendReq => net_gnd0,
      SPLB3_PLB_rdPendPri => net_gnd2,
      SPLB3_PLB_reqPri => net_gnd2,
      SPLB3_PLB_TAttribute => net_gnd16(15 downto 0),
      SPLB3_PLB_rdBurst => net_gnd0,
      SPLB3_PLB_wrBurst => net_gnd0,
      SPLB3_PLB_wrDBus => net_gnd64,
      SPLB3_Sl_addrAck => open,
      SPLB3_Sl_SSize => open,
      SPLB3_Sl_wait => open,
      SPLB3_Sl_rearbitrate => open,
      SPLB3_Sl_wrDAck => open,
      SPLB3_Sl_wrComp => open,
      SPLB3_Sl_wrBTerm => open,
      SPLB3_Sl_rdDBus => open,
      SPLB3_Sl_rdWdAddr => open,
      SPLB3_Sl_rdDAck => open,
      SPLB3_Sl_rdComp => open,
      SPLB3_Sl_rdBTerm => open,
      SPLB3_Sl_MBusy => open,
      SPLB3_Sl_MRdErr => open,
      SPLB3_Sl_MWrErr => open,
      SPLB3_Sl_MIRQ => open,
      SDMA3_Clk => net_gnd0,
      SDMA3_Rx_IntOut => open,
      SDMA3_Tx_IntOut => open,
      SDMA3_RstOut => open,
      SDMA3_TX_D => open,
      SDMA3_TX_Rem => open,
      SDMA3_TX_SOF => open,
      SDMA3_TX_EOF => open,
      SDMA3_TX_SOP => open,
      SDMA3_TX_EOP => open,
      SDMA3_TX_Src_Rdy => open,
      SDMA3_TX_Dst_Rdy => net_vcc0,
      SDMA3_RX_D => net_gnd32(31 downto 0),
      SDMA3_RX_Rem => net_vcc4,
      SDMA3_RX_SOF => net_vcc0,
      SDMA3_RX_EOF => net_vcc0,
      SDMA3_RX_SOP => net_vcc0,
      SDMA3_RX_EOP => net_vcc0,
      SDMA3_RX_Src_Rdy => net_vcc0,
      SDMA3_RX_Dst_Rdy => open,
      SDMA_CTRL3_Clk => net_vcc0,
      SDMA_CTRL3_Rst => net_gnd0,
      SDMA_CTRL3_PLB_ABus => net_gnd32(31 downto 0),
      SDMA_CTRL3_PLB_PAValid => net_gnd0,
      SDMA_CTRL3_PLB_SAValid => net_gnd0,
      SDMA_CTRL3_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL3_PLB_RNW => net_gnd0,
      SDMA_CTRL3_PLB_BE => net_gnd8,
      SDMA_CTRL3_PLB_UABus => net_gnd32(31 downto 0),
      SDMA_CTRL3_PLB_rdPrim => net_gnd0,
      SDMA_CTRL3_PLB_wrPrim => net_gnd0,
      SDMA_CTRL3_PLB_abort => net_gnd0,
      SDMA_CTRL3_PLB_busLock => net_gnd0,
      SDMA_CTRL3_PLB_MSize => net_gnd2,
      SDMA_CTRL3_PLB_size => net_gnd4,
      SDMA_CTRL3_PLB_type => net_gnd3,
      SDMA_CTRL3_PLB_lockErr => net_gnd0,
      SDMA_CTRL3_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL3_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL3_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL3_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL3_PLB_reqPri => net_gnd2,
      SDMA_CTRL3_PLB_TAttribute => net_gnd16(15 downto 0),
      SDMA_CTRL3_PLB_rdBurst => net_gnd0,
      SDMA_CTRL3_PLB_wrBurst => net_gnd0,
      SDMA_CTRL3_PLB_wrDBus => net_gnd64,
      SDMA_CTRL3_Sl_addrAck => open,
      SDMA_CTRL3_Sl_SSize => open,
      SDMA_CTRL3_Sl_wait => open,
      SDMA_CTRL3_Sl_rearbitrate => open,
      SDMA_CTRL3_Sl_wrDAck => open,
      SDMA_CTRL3_Sl_wrComp => open,
      SDMA_CTRL3_Sl_wrBTerm => open,
      SDMA_CTRL3_Sl_rdDBus => open,
      SDMA_CTRL3_Sl_rdWdAddr => open,
      SDMA_CTRL3_Sl_rdDAck => open,
      SDMA_CTRL3_Sl_rdComp => open,
      SDMA_CTRL3_Sl_rdBTerm => open,
      SDMA_CTRL3_Sl_MBusy => open,
      SDMA_CTRL3_Sl_MRdErr => open,
      SDMA_CTRL3_Sl_MWrErr => open,
      SDMA_CTRL3_Sl_MIRQ => open,
      PIM3_Addr => net_gnd32,
      PIM3_AddrReq => net_gnd0,
      PIM3_AddrAck => open,
      PIM3_RNW => net_gnd0,
      PIM3_Size => net_gnd4(0 to 3),
      PIM3_RdModWr => net_gnd0,
      PIM3_WrFIFO_Data => net_gnd64(0 to 63),
      PIM3_WrFIFO_BE => net_gnd8(0 to 7),
      PIM3_WrFIFO_Push => net_gnd0,
      PIM3_RdFIFO_Data => open,
      PIM3_RdFIFO_Pop => net_gnd0,
      PIM3_RdFIFO_RdWdAddr => open,
      PIM3_WrFIFO_Empty => open,
      PIM3_WrFIFO_AlmostFull => open,
      PIM3_WrFIFO_Flush => net_gnd0,
      PIM3_RdFIFO_Empty => open,
      PIM3_RdFIFO_Flush => net_gnd0,
      PIM3_RdFIFO_Latency => open,
      PIM3_InitDone => open,
      PPC440MC3_MIMCReadNotWrite => net_gnd0,
      PPC440MC3_MIMCAddress => net_gnd36,
      PPC440MC3_MIMCAddressValid => net_gnd0,
      PPC440MC3_MIMCWriteData => net_gnd128,
      PPC440MC3_MIMCWriteDataValid => net_gnd0,
      PPC440MC3_MIMCByteEnable => net_gnd16(15 downto 0),
      PPC440MC3_MIMCBankConflict => net_gnd0,
      PPC440MC3_MIMCRowConflict => net_gnd0,
      PPC440MC3_MCMIReadData => open,
      PPC440MC3_MCMIReadDataValid => open,
      PPC440MC3_MCMIReadDataErr => open,
      PPC440MC3_MCMIAddrReadyToAccept => open,
      VFBC3_Cmd_Clk => net_gnd0,
      VFBC3_Cmd_Reset => net_gnd0,
      VFBC3_Cmd_Data => net_gnd32,
      VFBC3_Cmd_Write => net_gnd0,
      VFBC3_Cmd_End => net_gnd0,
      VFBC3_Cmd_Full => open,
      VFBC3_Cmd_Almost_Full => open,
      VFBC3_Cmd_Idle => open,
      VFBC3_Wd_Clk => net_gnd0,
      VFBC3_Wd_Reset => net_gnd0,
      VFBC3_Wd_Write => net_gnd0,
      VFBC3_Wd_End_Burst => net_gnd0,
      VFBC3_Wd_Flush => net_gnd0,
      VFBC3_Wd_Data => net_gnd32,
      VFBC3_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC3_Wd_Full => open,
      VFBC3_Wd_Almost_Full => open,
      VFBC3_Rd_Clk => net_gnd0,
      VFBC3_Rd_Reset => net_gnd0,
      VFBC3_Rd_Read => net_gnd0,
      VFBC3_Rd_End_Burst => net_gnd0,
      VFBC3_Rd_Flush => net_gnd0,
      VFBC3_Rd_Data => open,
      VFBC3_Rd_Empty => open,
      VFBC3_Rd_Almost_Empty => open,
      MCB3_cmd_clk => net_gnd0,
      MCB3_cmd_en => net_gnd0,
      MCB3_cmd_instr => net_gnd3(0 to 2),
      MCB3_cmd_bl => net_gnd6,
      MCB3_cmd_byte_addr => net_gnd30,
      MCB3_cmd_empty => open,
      MCB3_cmd_full => open,
      MCB3_wr_clk => net_gnd0,
      MCB3_wr_en => net_gnd0,
      MCB3_wr_mask => net_gnd8(0 to 7),
      MCB3_wr_data => net_gnd64(0 to 63),
      MCB3_wr_full => open,
      MCB3_wr_empty => open,
      MCB3_wr_count => open,
      MCB3_wr_underrun => open,
      MCB3_wr_error => open,
      MCB3_rd_clk => net_gnd0,
      MCB3_rd_en => net_gnd0,
      MCB3_rd_data => open,
      MCB3_rd_full => open,
      MCB3_rd_empty => open,
      MCB3_rd_count => open,
      MCB3_rd_overflow => open,
      MCB3_rd_error => open,
      FSL4_M_Clk => net_vcc0,
      FSL4_M_Write => net_gnd0,
      FSL4_M_Data => net_gnd32(31 downto 0),
      FSL4_M_Control => net_gnd0,
      FSL4_M_Full => open,
      FSL4_S_Clk => net_gnd0,
      FSL4_S_Read => net_gnd0,
      FSL4_S_Data => open,
      FSL4_S_Control => open,
      FSL4_S_Exists => open,
      FSL4_B_M_Clk => net_vcc0,
      FSL4_B_M_Write => net_gnd0,
      FSL4_B_M_Data => net_gnd32(31 downto 0),
      FSL4_B_M_Control => net_gnd0,
      FSL4_B_M_Full => open,
      FSL4_B_S_Clk => net_gnd0,
      FSL4_B_S_Read => net_gnd0,
      FSL4_B_S_Data => open,
      FSL4_B_S_Control => open,
      FSL4_B_S_Exists => open,
      SPLB4_Clk => net_vcc0,
      SPLB4_Rst => net_gnd0,
      SPLB4_PLB_ABus => net_gnd32(31 downto 0),
      SPLB4_PLB_PAValid => net_gnd0,
      SPLB4_PLB_SAValid => net_gnd0,
      SPLB4_PLB_masterID => net_gnd1(0 to 0),
      SPLB4_PLB_RNW => net_gnd0,
      SPLB4_PLB_BE => net_gnd8,
      SPLB4_PLB_UABus => net_gnd32(31 downto 0),
      SPLB4_PLB_rdPrim => net_gnd0,
      SPLB4_PLB_wrPrim => net_gnd0,
      SPLB4_PLB_abort => net_gnd0,
      SPLB4_PLB_busLock => net_gnd0,
      SPLB4_PLB_MSize => net_gnd2,
      SPLB4_PLB_size => net_gnd4,
      SPLB4_PLB_type => net_gnd3,
      SPLB4_PLB_lockErr => net_gnd0,
      SPLB4_PLB_wrPendReq => net_gnd0,
      SPLB4_PLB_wrPendPri => net_gnd2,
      SPLB4_PLB_rdPendReq => net_gnd0,
      SPLB4_PLB_rdPendPri => net_gnd2,
      SPLB4_PLB_reqPri => net_gnd2,
      SPLB4_PLB_TAttribute => net_gnd16(15 downto 0),
      SPLB4_PLB_rdBurst => net_gnd0,
      SPLB4_PLB_wrBurst => net_gnd0,
      SPLB4_PLB_wrDBus => net_gnd64,
      SPLB4_Sl_addrAck => open,
      SPLB4_Sl_SSize => open,
      SPLB4_Sl_wait => open,
      SPLB4_Sl_rearbitrate => open,
      SPLB4_Sl_wrDAck => open,
      SPLB4_Sl_wrComp => open,
      SPLB4_Sl_wrBTerm => open,
      SPLB4_Sl_rdDBus => open,
      SPLB4_Sl_rdWdAddr => open,
      SPLB4_Sl_rdDAck => open,
      SPLB4_Sl_rdComp => open,
      SPLB4_Sl_rdBTerm => open,
      SPLB4_Sl_MBusy => open,
      SPLB4_Sl_MRdErr => open,
      SPLB4_Sl_MWrErr => open,
      SPLB4_Sl_MIRQ => open,
      SDMA4_Clk => net_gnd0,
      SDMA4_Rx_IntOut => open,
      SDMA4_Tx_IntOut => open,
      SDMA4_RstOut => open,
      SDMA4_TX_D => open,
      SDMA4_TX_Rem => open,
      SDMA4_TX_SOF => open,
      SDMA4_TX_EOF => open,
      SDMA4_TX_SOP => open,
      SDMA4_TX_EOP => open,
      SDMA4_TX_Src_Rdy => open,
      SDMA4_TX_Dst_Rdy => net_vcc0,
      SDMA4_RX_D => net_gnd32(31 downto 0),
      SDMA4_RX_Rem => net_vcc4,
      SDMA4_RX_SOF => net_vcc0,
      SDMA4_RX_EOF => net_vcc0,
      SDMA4_RX_SOP => net_vcc0,
      SDMA4_RX_EOP => net_vcc0,
      SDMA4_RX_Src_Rdy => net_vcc0,
      SDMA4_RX_Dst_Rdy => open,
      SDMA_CTRL4_Clk => net_vcc0,
      SDMA_CTRL4_Rst => net_gnd0,
      SDMA_CTRL4_PLB_ABus => net_gnd32(31 downto 0),
      SDMA_CTRL4_PLB_PAValid => net_gnd0,
      SDMA_CTRL4_PLB_SAValid => net_gnd0,
      SDMA_CTRL4_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL4_PLB_RNW => net_gnd0,
      SDMA_CTRL4_PLB_BE => net_gnd8,
      SDMA_CTRL4_PLB_UABus => net_gnd32(31 downto 0),
      SDMA_CTRL4_PLB_rdPrim => net_gnd0,
      SDMA_CTRL4_PLB_wrPrim => net_gnd0,
      SDMA_CTRL4_PLB_abort => net_gnd0,
      SDMA_CTRL4_PLB_busLock => net_gnd0,
      SDMA_CTRL4_PLB_MSize => net_gnd2,
      SDMA_CTRL4_PLB_size => net_gnd4,
      SDMA_CTRL4_PLB_type => net_gnd3,
      SDMA_CTRL4_PLB_lockErr => net_gnd0,
      SDMA_CTRL4_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL4_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL4_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL4_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL4_PLB_reqPri => net_gnd2,
      SDMA_CTRL4_PLB_TAttribute => net_gnd16(15 downto 0),
      SDMA_CTRL4_PLB_rdBurst => net_gnd0,
      SDMA_CTRL4_PLB_wrBurst => net_gnd0,
      SDMA_CTRL4_PLB_wrDBus => net_gnd64,
      SDMA_CTRL4_Sl_addrAck => open,
      SDMA_CTRL4_Sl_SSize => open,
      SDMA_CTRL4_Sl_wait => open,
      SDMA_CTRL4_Sl_rearbitrate => open,
      SDMA_CTRL4_Sl_wrDAck => open,
      SDMA_CTRL4_Sl_wrComp => open,
      SDMA_CTRL4_Sl_wrBTerm => open,
      SDMA_CTRL4_Sl_rdDBus => open,
      SDMA_CTRL4_Sl_rdWdAddr => open,
      SDMA_CTRL4_Sl_rdDAck => open,
      SDMA_CTRL4_Sl_rdComp => open,
      SDMA_CTRL4_Sl_rdBTerm => open,
      SDMA_CTRL4_Sl_MBusy => open,
      SDMA_CTRL4_Sl_MRdErr => open,
      SDMA_CTRL4_Sl_MWrErr => open,
      SDMA_CTRL4_Sl_MIRQ => open,
      PIM4_Addr => net_gnd32,
      PIM4_AddrReq => net_gnd0,
      PIM4_AddrAck => open,
      PIM4_RNW => net_gnd0,
      PIM4_Size => net_gnd4(0 to 3),
      PIM4_RdModWr => net_gnd0,
      PIM4_WrFIFO_Data => net_gnd64(0 to 63),
      PIM4_WrFIFO_BE => net_gnd8(0 to 7),
      PIM4_WrFIFO_Push => net_gnd0,
      PIM4_RdFIFO_Data => open,
      PIM4_RdFIFO_Pop => net_gnd0,
      PIM4_RdFIFO_RdWdAddr => open,
      PIM4_WrFIFO_Empty => open,
      PIM4_WrFIFO_AlmostFull => open,
      PIM4_WrFIFO_Flush => net_gnd0,
      PIM4_RdFIFO_Empty => open,
      PIM4_RdFIFO_Flush => net_gnd0,
      PIM4_RdFIFO_Latency => open,
      PIM4_InitDone => open,
      PPC440MC4_MIMCReadNotWrite => net_gnd0,
      PPC440MC4_MIMCAddress => net_gnd36,
      PPC440MC4_MIMCAddressValid => net_gnd0,
      PPC440MC4_MIMCWriteData => net_gnd128,
      PPC440MC4_MIMCWriteDataValid => net_gnd0,
      PPC440MC4_MIMCByteEnable => net_gnd16(15 downto 0),
      PPC440MC4_MIMCBankConflict => net_gnd0,
      PPC440MC4_MIMCRowConflict => net_gnd0,
      PPC440MC4_MCMIReadData => open,
      PPC440MC4_MCMIReadDataValid => open,
      PPC440MC4_MCMIReadDataErr => open,
      PPC440MC4_MCMIAddrReadyToAccept => open,
      VFBC4_Cmd_Clk => net_gnd0,
      VFBC4_Cmd_Reset => net_gnd0,
      VFBC4_Cmd_Data => net_gnd32,
      VFBC4_Cmd_Write => net_gnd0,
      VFBC4_Cmd_End => net_gnd0,
      VFBC4_Cmd_Full => open,
      VFBC4_Cmd_Almost_Full => open,
      VFBC4_Cmd_Idle => open,
      VFBC4_Wd_Clk => net_gnd0,
      VFBC4_Wd_Reset => net_gnd0,
      VFBC4_Wd_Write => net_gnd0,
      VFBC4_Wd_End_Burst => net_gnd0,
      VFBC4_Wd_Flush => net_gnd0,
      VFBC4_Wd_Data => net_gnd32,
      VFBC4_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC4_Wd_Full => open,
      VFBC4_Wd_Almost_Full => open,
      VFBC4_Rd_Clk => net_gnd0,
      VFBC4_Rd_Reset => net_gnd0,
      VFBC4_Rd_Read => net_gnd0,
      VFBC4_Rd_End_Burst => net_gnd0,
      VFBC4_Rd_Flush => net_gnd0,
      VFBC4_Rd_Data => open,
      VFBC4_Rd_Empty => open,
      VFBC4_Rd_Almost_Empty => open,
      MCB4_cmd_clk => net_gnd0,
      MCB4_cmd_en => net_gnd0,
      MCB4_cmd_instr => net_gnd3(0 to 2),
      MCB4_cmd_bl => net_gnd6,
      MCB4_cmd_byte_addr => net_gnd30,
      MCB4_cmd_empty => open,
      MCB4_cmd_full => open,
      MCB4_wr_clk => net_gnd0,
      MCB4_wr_en => net_gnd0,
      MCB4_wr_mask => net_gnd8(0 to 7),
      MCB4_wr_data => net_gnd64(0 to 63),
      MCB4_wr_full => open,
      MCB4_wr_empty => open,
      MCB4_wr_count => open,
      MCB4_wr_underrun => open,
      MCB4_wr_error => open,
      MCB4_rd_clk => net_gnd0,
      MCB4_rd_en => net_gnd0,
      MCB4_rd_data => open,
      MCB4_rd_full => open,
      MCB4_rd_empty => open,
      MCB4_rd_count => open,
      MCB4_rd_overflow => open,
      MCB4_rd_error => open,
      FSL5_M_Clk => net_vcc0,
      FSL5_M_Write => net_gnd0,
      FSL5_M_Data => net_gnd32(31 downto 0),
      FSL5_M_Control => net_gnd0,
      FSL5_M_Full => open,
      FSL5_S_Clk => net_gnd0,
      FSL5_S_Read => net_gnd0,
      FSL5_S_Data => open,
      FSL5_S_Control => open,
      FSL5_S_Exists => open,
      FSL5_B_M_Clk => net_vcc0,
      FSL5_B_M_Write => net_gnd0,
      FSL5_B_M_Data => net_gnd32(31 downto 0),
      FSL5_B_M_Control => net_gnd0,
      FSL5_B_M_Full => open,
      FSL5_B_S_Clk => net_gnd0,
      FSL5_B_S_Read => net_gnd0,
      FSL5_B_S_Data => open,
      FSL5_B_S_Control => open,
      FSL5_B_S_Exists => open,
      SPLB5_Clk => net_vcc0,
      SPLB5_Rst => net_gnd0,
      SPLB5_PLB_ABus => net_gnd32(31 downto 0),
      SPLB5_PLB_PAValid => net_gnd0,
      SPLB5_PLB_SAValid => net_gnd0,
      SPLB5_PLB_masterID => net_gnd1(0 to 0),
      SPLB5_PLB_RNW => net_gnd0,
      SPLB5_PLB_BE => net_gnd8,
      SPLB5_PLB_UABus => net_gnd32(31 downto 0),
      SPLB5_PLB_rdPrim => net_gnd0,
      SPLB5_PLB_wrPrim => net_gnd0,
      SPLB5_PLB_abort => net_gnd0,
      SPLB5_PLB_busLock => net_gnd0,
      SPLB5_PLB_MSize => net_gnd2,
      SPLB5_PLB_size => net_gnd4,
      SPLB5_PLB_type => net_gnd3,
      SPLB5_PLB_lockErr => net_gnd0,
      SPLB5_PLB_wrPendReq => net_gnd0,
      SPLB5_PLB_wrPendPri => net_gnd2,
      SPLB5_PLB_rdPendReq => net_gnd0,
      SPLB5_PLB_rdPendPri => net_gnd2,
      SPLB5_PLB_reqPri => net_gnd2,
      SPLB5_PLB_TAttribute => net_gnd16(15 downto 0),
      SPLB5_PLB_rdBurst => net_gnd0,
      SPLB5_PLB_wrBurst => net_gnd0,
      SPLB5_PLB_wrDBus => net_gnd64,
      SPLB5_Sl_addrAck => open,
      SPLB5_Sl_SSize => open,
      SPLB5_Sl_wait => open,
      SPLB5_Sl_rearbitrate => open,
      SPLB5_Sl_wrDAck => open,
      SPLB5_Sl_wrComp => open,
      SPLB5_Sl_wrBTerm => open,
      SPLB5_Sl_rdDBus => open,
      SPLB5_Sl_rdWdAddr => open,
      SPLB5_Sl_rdDAck => open,
      SPLB5_Sl_rdComp => open,
      SPLB5_Sl_rdBTerm => open,
      SPLB5_Sl_MBusy => open,
      SPLB5_Sl_MRdErr => open,
      SPLB5_Sl_MWrErr => open,
      SPLB5_Sl_MIRQ => open,
      SDMA5_Clk => net_gnd0,
      SDMA5_Rx_IntOut => open,
      SDMA5_Tx_IntOut => open,
      SDMA5_RstOut => open,
      SDMA5_TX_D => open,
      SDMA5_TX_Rem => open,
      SDMA5_TX_SOF => open,
      SDMA5_TX_EOF => open,
      SDMA5_TX_SOP => open,
      SDMA5_TX_EOP => open,
      SDMA5_TX_Src_Rdy => open,
      SDMA5_TX_Dst_Rdy => net_vcc0,
      SDMA5_RX_D => net_gnd32(31 downto 0),
      SDMA5_RX_Rem => net_vcc4,
      SDMA5_RX_SOF => net_vcc0,
      SDMA5_RX_EOF => net_vcc0,
      SDMA5_RX_SOP => net_vcc0,
      SDMA5_RX_EOP => net_vcc0,
      SDMA5_RX_Src_Rdy => net_vcc0,
      SDMA5_RX_Dst_Rdy => open,
      SDMA_CTRL5_Clk => net_vcc0,
      SDMA_CTRL5_Rst => net_gnd0,
      SDMA_CTRL5_PLB_ABus => net_gnd32(31 downto 0),
      SDMA_CTRL5_PLB_PAValid => net_gnd0,
      SDMA_CTRL5_PLB_SAValid => net_gnd0,
      SDMA_CTRL5_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL5_PLB_RNW => net_gnd0,
      SDMA_CTRL5_PLB_BE => net_gnd8,
      SDMA_CTRL5_PLB_UABus => net_gnd32(31 downto 0),
      SDMA_CTRL5_PLB_rdPrim => net_gnd0,
      SDMA_CTRL5_PLB_wrPrim => net_gnd0,
      SDMA_CTRL5_PLB_abort => net_gnd0,
      SDMA_CTRL5_PLB_busLock => net_gnd0,
      SDMA_CTRL5_PLB_MSize => net_gnd2,
      SDMA_CTRL5_PLB_size => net_gnd4,
      SDMA_CTRL5_PLB_type => net_gnd3,
      SDMA_CTRL5_PLB_lockErr => net_gnd0,
      SDMA_CTRL5_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL5_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL5_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL5_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL5_PLB_reqPri => net_gnd2,
      SDMA_CTRL5_PLB_TAttribute => net_gnd16(15 downto 0),
      SDMA_CTRL5_PLB_rdBurst => net_gnd0,
      SDMA_CTRL5_PLB_wrBurst => net_gnd0,
      SDMA_CTRL5_PLB_wrDBus => net_gnd64,
      SDMA_CTRL5_Sl_addrAck => open,
      SDMA_CTRL5_Sl_SSize => open,
      SDMA_CTRL5_Sl_wait => open,
      SDMA_CTRL5_Sl_rearbitrate => open,
      SDMA_CTRL5_Sl_wrDAck => open,
      SDMA_CTRL5_Sl_wrComp => open,
      SDMA_CTRL5_Sl_wrBTerm => open,
      SDMA_CTRL5_Sl_rdDBus => open,
      SDMA_CTRL5_Sl_rdWdAddr => open,
      SDMA_CTRL5_Sl_rdDAck => open,
      SDMA_CTRL5_Sl_rdComp => open,
      SDMA_CTRL5_Sl_rdBTerm => open,
      SDMA_CTRL5_Sl_MBusy => open,
      SDMA_CTRL5_Sl_MRdErr => open,
      SDMA_CTRL5_Sl_MWrErr => open,
      SDMA_CTRL5_Sl_MIRQ => open,
      PIM5_Addr => net_gnd32,
      PIM5_AddrReq => net_gnd0,
      PIM5_AddrAck => open,
      PIM5_RNW => net_gnd0,
      PIM5_Size => net_gnd4(0 to 3),
      PIM5_RdModWr => net_gnd0,
      PIM5_WrFIFO_Data => net_gnd64(0 to 63),
      PIM5_WrFIFO_BE => net_gnd8(0 to 7),
      PIM5_WrFIFO_Push => net_gnd0,
      PIM5_RdFIFO_Data => open,
      PIM5_RdFIFO_Pop => net_gnd0,
      PIM5_RdFIFO_RdWdAddr => open,
      PIM5_WrFIFO_Empty => open,
      PIM5_WrFIFO_AlmostFull => open,
      PIM5_WrFIFO_Flush => net_gnd0,
      PIM5_RdFIFO_Empty => open,
      PIM5_RdFIFO_Flush => net_gnd0,
      PIM5_RdFIFO_Latency => open,
      PIM5_InitDone => open,
      PPC440MC5_MIMCReadNotWrite => net_gnd0,
      PPC440MC5_MIMCAddress => net_gnd36,
      PPC440MC5_MIMCAddressValid => net_gnd0,
      PPC440MC5_MIMCWriteData => net_gnd128,
      PPC440MC5_MIMCWriteDataValid => net_gnd0,
      PPC440MC5_MIMCByteEnable => net_gnd16(15 downto 0),
      PPC440MC5_MIMCBankConflict => net_gnd0,
      PPC440MC5_MIMCRowConflict => net_gnd0,
      PPC440MC5_MCMIReadData => open,
      PPC440MC5_MCMIReadDataValid => open,
      PPC440MC5_MCMIReadDataErr => open,
      PPC440MC5_MCMIAddrReadyToAccept => open,
      VFBC5_Cmd_Clk => net_gnd0,
      VFBC5_Cmd_Reset => net_gnd0,
      VFBC5_Cmd_Data => net_gnd32,
      VFBC5_Cmd_Write => net_gnd0,
      VFBC5_Cmd_End => net_gnd0,
      VFBC5_Cmd_Full => open,
      VFBC5_Cmd_Almost_Full => open,
      VFBC5_Cmd_Idle => open,
      VFBC5_Wd_Clk => net_gnd0,
      VFBC5_Wd_Reset => net_gnd0,
      VFBC5_Wd_Write => net_gnd0,
      VFBC5_Wd_End_Burst => net_gnd0,
      VFBC5_Wd_Flush => net_gnd0,
      VFBC5_Wd_Data => net_gnd32,
      VFBC5_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC5_Wd_Full => open,
      VFBC5_Wd_Almost_Full => open,
      VFBC5_Rd_Clk => net_gnd0,
      VFBC5_Rd_Reset => net_gnd0,
      VFBC5_Rd_Read => net_gnd0,
      VFBC5_Rd_End_Burst => net_gnd0,
      VFBC5_Rd_Flush => net_gnd0,
      VFBC5_Rd_Data => open,
      VFBC5_Rd_Empty => open,
      VFBC5_Rd_Almost_Empty => open,
      MCB5_cmd_clk => net_gnd0,
      MCB5_cmd_en => net_gnd0,
      MCB5_cmd_instr => net_gnd3(0 to 2),
      MCB5_cmd_bl => net_gnd6,
      MCB5_cmd_byte_addr => net_gnd30,
      MCB5_cmd_empty => open,
      MCB5_cmd_full => open,
      MCB5_wr_clk => net_gnd0,
      MCB5_wr_en => net_gnd0,
      MCB5_wr_mask => net_gnd8(0 to 7),
      MCB5_wr_data => net_gnd64(0 to 63),
      MCB5_wr_full => open,
      MCB5_wr_empty => open,
      MCB5_wr_count => open,
      MCB5_wr_underrun => open,
      MCB5_wr_error => open,
      MCB5_rd_clk => net_gnd0,
      MCB5_rd_en => net_gnd0,
      MCB5_rd_data => open,
      MCB5_rd_full => open,
      MCB5_rd_empty => open,
      MCB5_rd_count => open,
      MCB5_rd_overflow => open,
      MCB5_rd_error => open,
      FSL6_M_Clk => net_vcc0,
      FSL6_M_Write => net_gnd0,
      FSL6_M_Data => net_gnd32(31 downto 0),
      FSL6_M_Control => net_gnd0,
      FSL6_M_Full => open,
      FSL6_S_Clk => net_gnd0,
      FSL6_S_Read => net_gnd0,
      FSL6_S_Data => open,
      FSL6_S_Control => open,
      FSL6_S_Exists => open,
      FSL6_B_M_Clk => net_vcc0,
      FSL6_B_M_Write => net_gnd0,
      FSL6_B_M_Data => net_gnd32(31 downto 0),
      FSL6_B_M_Control => net_gnd0,
      FSL6_B_M_Full => open,
      FSL6_B_S_Clk => net_gnd0,
      FSL6_B_S_Read => net_gnd0,
      FSL6_B_S_Data => open,
      FSL6_B_S_Control => open,
      FSL6_B_S_Exists => open,
      SPLB6_Clk => net_vcc0,
      SPLB6_Rst => net_gnd0,
      SPLB6_PLB_ABus => net_gnd32(31 downto 0),
      SPLB6_PLB_PAValid => net_gnd0,
      SPLB6_PLB_SAValid => net_gnd0,
      SPLB6_PLB_masterID => net_gnd1(0 to 0),
      SPLB6_PLB_RNW => net_gnd0,
      SPLB6_PLB_BE => net_gnd8,
      SPLB6_PLB_UABus => net_gnd32(31 downto 0),
      SPLB6_PLB_rdPrim => net_gnd0,
      SPLB6_PLB_wrPrim => net_gnd0,
      SPLB6_PLB_abort => net_gnd0,
      SPLB6_PLB_busLock => net_gnd0,
      SPLB6_PLB_MSize => net_gnd2,
      SPLB6_PLB_size => net_gnd4,
      SPLB6_PLB_type => net_gnd3,
      SPLB6_PLB_lockErr => net_gnd0,
      SPLB6_PLB_wrPendReq => net_gnd0,
      SPLB6_PLB_wrPendPri => net_gnd2,
      SPLB6_PLB_rdPendReq => net_gnd0,
      SPLB6_PLB_rdPendPri => net_gnd2,
      SPLB6_PLB_reqPri => net_gnd2,
      SPLB6_PLB_TAttribute => net_gnd16(15 downto 0),
      SPLB6_PLB_rdBurst => net_gnd0,
      SPLB6_PLB_wrBurst => net_gnd0,
      SPLB6_PLB_wrDBus => net_gnd64,
      SPLB6_Sl_addrAck => open,
      SPLB6_Sl_SSize => open,
      SPLB6_Sl_wait => open,
      SPLB6_Sl_rearbitrate => open,
      SPLB6_Sl_wrDAck => open,
      SPLB6_Sl_wrComp => open,
      SPLB6_Sl_wrBTerm => open,
      SPLB6_Sl_rdDBus => open,
      SPLB6_Sl_rdWdAddr => open,
      SPLB6_Sl_rdDAck => open,
      SPLB6_Sl_rdComp => open,
      SPLB6_Sl_rdBTerm => open,
      SPLB6_Sl_MBusy => open,
      SPLB6_Sl_MRdErr => open,
      SPLB6_Sl_MWrErr => open,
      SPLB6_Sl_MIRQ => open,
      SDMA6_Clk => net_gnd0,
      SDMA6_Rx_IntOut => open,
      SDMA6_Tx_IntOut => open,
      SDMA6_RstOut => open,
      SDMA6_TX_D => open,
      SDMA6_TX_Rem => open,
      SDMA6_TX_SOF => open,
      SDMA6_TX_EOF => open,
      SDMA6_TX_SOP => open,
      SDMA6_TX_EOP => open,
      SDMA6_TX_Src_Rdy => open,
      SDMA6_TX_Dst_Rdy => net_vcc0,
      SDMA6_RX_D => net_gnd32(31 downto 0),
      SDMA6_RX_Rem => net_vcc4,
      SDMA6_RX_SOF => net_vcc0,
      SDMA6_RX_EOF => net_vcc0,
      SDMA6_RX_SOP => net_vcc0,
      SDMA6_RX_EOP => net_vcc0,
      SDMA6_RX_Src_Rdy => net_vcc0,
      SDMA6_RX_Dst_Rdy => open,
      SDMA_CTRL6_Clk => net_vcc0,
      SDMA_CTRL6_Rst => net_gnd0,
      SDMA_CTRL6_PLB_ABus => net_gnd32(31 downto 0),
      SDMA_CTRL6_PLB_PAValid => net_gnd0,
      SDMA_CTRL6_PLB_SAValid => net_gnd0,
      SDMA_CTRL6_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL6_PLB_RNW => net_gnd0,
      SDMA_CTRL6_PLB_BE => net_gnd8,
      SDMA_CTRL6_PLB_UABus => net_gnd32(31 downto 0),
      SDMA_CTRL6_PLB_rdPrim => net_gnd0,
      SDMA_CTRL6_PLB_wrPrim => net_gnd0,
      SDMA_CTRL6_PLB_abort => net_gnd0,
      SDMA_CTRL6_PLB_busLock => net_gnd0,
      SDMA_CTRL6_PLB_MSize => net_gnd2,
      SDMA_CTRL6_PLB_size => net_gnd4,
      SDMA_CTRL6_PLB_type => net_gnd3,
      SDMA_CTRL6_PLB_lockErr => net_gnd0,
      SDMA_CTRL6_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL6_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL6_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL6_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL6_PLB_reqPri => net_gnd2,
      SDMA_CTRL6_PLB_TAttribute => net_gnd16(15 downto 0),
      SDMA_CTRL6_PLB_rdBurst => net_gnd0,
      SDMA_CTRL6_PLB_wrBurst => net_gnd0,
      SDMA_CTRL6_PLB_wrDBus => net_gnd64,
      SDMA_CTRL6_Sl_addrAck => open,
      SDMA_CTRL6_Sl_SSize => open,
      SDMA_CTRL6_Sl_wait => open,
      SDMA_CTRL6_Sl_rearbitrate => open,
      SDMA_CTRL6_Sl_wrDAck => open,
      SDMA_CTRL6_Sl_wrComp => open,
      SDMA_CTRL6_Sl_wrBTerm => open,
      SDMA_CTRL6_Sl_rdDBus => open,
      SDMA_CTRL6_Sl_rdWdAddr => open,
      SDMA_CTRL6_Sl_rdDAck => open,
      SDMA_CTRL6_Sl_rdComp => open,
      SDMA_CTRL6_Sl_rdBTerm => open,
      SDMA_CTRL6_Sl_MBusy => open,
      SDMA_CTRL6_Sl_MRdErr => open,
      SDMA_CTRL6_Sl_MWrErr => open,
      SDMA_CTRL6_Sl_MIRQ => open,
      PIM6_Addr => net_gnd32,
      PIM6_AddrReq => net_gnd0,
      PIM6_AddrAck => open,
      PIM6_RNW => net_gnd0,
      PIM6_Size => net_gnd4(0 to 3),
      PIM6_RdModWr => net_gnd0,
      PIM6_WrFIFO_Data => net_gnd64(0 to 63),
      PIM6_WrFIFO_BE => net_gnd8(0 to 7),
      PIM6_WrFIFO_Push => net_gnd0,
      PIM6_RdFIFO_Data => open,
      PIM6_RdFIFO_Pop => net_gnd0,
      PIM6_RdFIFO_RdWdAddr => open,
      PIM6_WrFIFO_Empty => open,
      PIM6_WrFIFO_AlmostFull => open,
      PIM6_WrFIFO_Flush => net_gnd0,
      PIM6_RdFIFO_Empty => open,
      PIM6_RdFIFO_Flush => net_gnd0,
      PIM6_RdFIFO_Latency => open,
      PIM6_InitDone => open,
      PPC440MC6_MIMCReadNotWrite => net_gnd0,
      PPC440MC6_MIMCAddress => net_gnd36,
      PPC440MC6_MIMCAddressValid => net_gnd0,
      PPC440MC6_MIMCWriteData => net_gnd128,
      PPC440MC6_MIMCWriteDataValid => net_gnd0,
      PPC440MC6_MIMCByteEnable => net_gnd16(15 downto 0),
      PPC440MC6_MIMCBankConflict => net_gnd0,
      PPC440MC6_MIMCRowConflict => net_gnd0,
      PPC440MC6_MCMIReadData => open,
      PPC440MC6_MCMIReadDataValid => open,
      PPC440MC6_MCMIReadDataErr => open,
      PPC440MC6_MCMIAddrReadyToAccept => open,
      VFBC6_Cmd_Clk => net_gnd0,
      VFBC6_Cmd_Reset => net_gnd0,
      VFBC6_Cmd_Data => net_gnd32,
      VFBC6_Cmd_Write => net_gnd0,
      VFBC6_Cmd_End => net_gnd0,
      VFBC6_Cmd_Full => open,
      VFBC6_Cmd_Almost_Full => open,
      VFBC6_Cmd_Idle => open,
      VFBC6_Wd_Clk => net_gnd0,
      VFBC6_Wd_Reset => net_gnd0,
      VFBC6_Wd_Write => net_gnd0,
      VFBC6_Wd_End_Burst => net_gnd0,
      VFBC6_Wd_Flush => net_gnd0,
      VFBC6_Wd_Data => net_gnd32,
      VFBC6_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC6_Wd_Full => open,
      VFBC6_Wd_Almost_Full => open,
      VFBC6_Rd_Clk => net_gnd0,
      VFBC6_Rd_Reset => net_gnd0,
      VFBC6_Rd_Read => net_gnd0,
      VFBC6_Rd_End_Burst => net_gnd0,
      VFBC6_Rd_Flush => net_gnd0,
      VFBC6_Rd_Data => open,
      VFBC6_Rd_Empty => open,
      VFBC6_Rd_Almost_Empty => open,
      MCB6_cmd_clk => net_gnd0,
      MCB6_cmd_en => net_gnd0,
      MCB6_cmd_instr => net_gnd3(0 to 2),
      MCB6_cmd_bl => net_gnd6,
      MCB6_cmd_byte_addr => net_gnd30,
      MCB6_cmd_empty => open,
      MCB6_cmd_full => open,
      MCB6_wr_clk => net_gnd0,
      MCB6_wr_en => net_gnd0,
      MCB6_wr_mask => net_gnd8(0 to 7),
      MCB6_wr_data => net_gnd64(0 to 63),
      MCB6_wr_full => open,
      MCB6_wr_empty => open,
      MCB6_wr_count => open,
      MCB6_wr_underrun => open,
      MCB6_wr_error => open,
      MCB6_rd_clk => net_gnd0,
      MCB6_rd_en => net_gnd0,
      MCB6_rd_data => open,
      MCB6_rd_full => open,
      MCB6_rd_empty => open,
      MCB6_rd_count => open,
      MCB6_rd_overflow => open,
      MCB6_rd_error => open,
      FSL7_M_Clk => net_vcc0,
      FSL7_M_Write => net_gnd0,
      FSL7_M_Data => net_gnd32(31 downto 0),
      FSL7_M_Control => net_gnd0,
      FSL7_M_Full => open,
      FSL7_S_Clk => net_gnd0,
      FSL7_S_Read => net_gnd0,
      FSL7_S_Data => open,
      FSL7_S_Control => open,
      FSL7_S_Exists => open,
      FSL7_B_M_Clk => net_vcc0,
      FSL7_B_M_Write => net_gnd0,
      FSL7_B_M_Data => net_gnd32(31 downto 0),
      FSL7_B_M_Control => net_gnd0,
      FSL7_B_M_Full => open,
      FSL7_B_S_Clk => net_gnd0,
      FSL7_B_S_Read => net_gnd0,
      FSL7_B_S_Data => open,
      FSL7_B_S_Control => open,
      FSL7_B_S_Exists => open,
      SPLB7_Clk => net_vcc0,
      SPLB7_Rst => net_gnd0,
      SPLB7_PLB_ABus => net_gnd32(31 downto 0),
      SPLB7_PLB_PAValid => net_gnd0,
      SPLB7_PLB_SAValid => net_gnd0,
      SPLB7_PLB_masterID => net_gnd1(0 to 0),
      SPLB7_PLB_RNW => net_gnd0,
      SPLB7_PLB_BE => net_gnd8,
      SPLB7_PLB_UABus => net_gnd32(31 downto 0),
      SPLB7_PLB_rdPrim => net_gnd0,
      SPLB7_PLB_wrPrim => net_gnd0,
      SPLB7_PLB_abort => net_gnd0,
      SPLB7_PLB_busLock => net_gnd0,
      SPLB7_PLB_MSize => net_gnd2,
      SPLB7_PLB_size => net_gnd4,
      SPLB7_PLB_type => net_gnd3,
      SPLB7_PLB_lockErr => net_gnd0,
      SPLB7_PLB_wrPendReq => net_gnd0,
      SPLB7_PLB_wrPendPri => net_gnd2,
      SPLB7_PLB_rdPendReq => net_gnd0,
      SPLB7_PLB_rdPendPri => net_gnd2,
      SPLB7_PLB_reqPri => net_gnd2,
      SPLB7_PLB_TAttribute => net_gnd16(15 downto 0),
      SPLB7_PLB_rdBurst => net_gnd0,
      SPLB7_PLB_wrBurst => net_gnd0,
      SPLB7_PLB_wrDBus => net_gnd64,
      SPLB7_Sl_addrAck => open,
      SPLB7_Sl_SSize => open,
      SPLB7_Sl_wait => open,
      SPLB7_Sl_rearbitrate => open,
      SPLB7_Sl_wrDAck => open,
      SPLB7_Sl_wrComp => open,
      SPLB7_Sl_wrBTerm => open,
      SPLB7_Sl_rdDBus => open,
      SPLB7_Sl_rdWdAddr => open,
      SPLB7_Sl_rdDAck => open,
      SPLB7_Sl_rdComp => open,
      SPLB7_Sl_rdBTerm => open,
      SPLB7_Sl_MBusy => open,
      SPLB7_Sl_MRdErr => open,
      SPLB7_Sl_MWrErr => open,
      SPLB7_Sl_MIRQ => open,
      SDMA7_Clk => net_gnd0,
      SDMA7_Rx_IntOut => open,
      SDMA7_Tx_IntOut => open,
      SDMA7_RstOut => open,
      SDMA7_TX_D => open,
      SDMA7_TX_Rem => open,
      SDMA7_TX_SOF => open,
      SDMA7_TX_EOF => open,
      SDMA7_TX_SOP => open,
      SDMA7_TX_EOP => open,
      SDMA7_TX_Src_Rdy => open,
      SDMA7_TX_Dst_Rdy => net_vcc0,
      SDMA7_RX_D => net_gnd32(31 downto 0),
      SDMA7_RX_Rem => net_vcc4,
      SDMA7_RX_SOF => net_vcc0,
      SDMA7_RX_EOF => net_vcc0,
      SDMA7_RX_SOP => net_vcc0,
      SDMA7_RX_EOP => net_vcc0,
      SDMA7_RX_Src_Rdy => net_vcc0,
      SDMA7_RX_Dst_Rdy => open,
      SDMA_CTRL7_Clk => net_vcc0,
      SDMA_CTRL7_Rst => net_gnd0,
      SDMA_CTRL7_PLB_ABus => net_gnd32(31 downto 0),
      SDMA_CTRL7_PLB_PAValid => net_gnd0,
      SDMA_CTRL7_PLB_SAValid => net_gnd0,
      SDMA_CTRL7_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL7_PLB_RNW => net_gnd0,
      SDMA_CTRL7_PLB_BE => net_gnd8,
      SDMA_CTRL7_PLB_UABus => net_gnd32(31 downto 0),
      SDMA_CTRL7_PLB_rdPrim => net_gnd0,
      SDMA_CTRL7_PLB_wrPrim => net_gnd0,
      SDMA_CTRL7_PLB_abort => net_gnd0,
      SDMA_CTRL7_PLB_busLock => net_gnd0,
      SDMA_CTRL7_PLB_MSize => net_gnd2,
      SDMA_CTRL7_PLB_size => net_gnd4,
      SDMA_CTRL7_PLB_type => net_gnd3,
      SDMA_CTRL7_PLB_lockErr => net_gnd0,
      SDMA_CTRL7_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL7_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL7_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL7_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL7_PLB_reqPri => net_gnd2,
      SDMA_CTRL7_PLB_TAttribute => net_gnd16(15 downto 0),
      SDMA_CTRL7_PLB_rdBurst => net_gnd0,
      SDMA_CTRL7_PLB_wrBurst => net_gnd0,
      SDMA_CTRL7_PLB_wrDBus => net_gnd64,
      SDMA_CTRL7_Sl_addrAck => open,
      SDMA_CTRL7_Sl_SSize => open,
      SDMA_CTRL7_Sl_wait => open,
      SDMA_CTRL7_Sl_rearbitrate => open,
      SDMA_CTRL7_Sl_wrDAck => open,
      SDMA_CTRL7_Sl_wrComp => open,
      SDMA_CTRL7_Sl_wrBTerm => open,
      SDMA_CTRL7_Sl_rdDBus => open,
      SDMA_CTRL7_Sl_rdWdAddr => open,
      SDMA_CTRL7_Sl_rdDAck => open,
      SDMA_CTRL7_Sl_rdComp => open,
      SDMA_CTRL7_Sl_rdBTerm => open,
      SDMA_CTRL7_Sl_MBusy => open,
      SDMA_CTRL7_Sl_MRdErr => open,
      SDMA_CTRL7_Sl_MWrErr => open,
      SDMA_CTRL7_Sl_MIRQ => open,
      PIM7_Addr => net_gnd32,
      PIM7_AddrReq => net_gnd0,
      PIM7_AddrAck => open,
      PIM7_RNW => net_gnd0,
      PIM7_Size => net_gnd4(0 to 3),
      PIM7_RdModWr => net_gnd0,
      PIM7_WrFIFO_Data => net_gnd64(0 to 63),
      PIM7_WrFIFO_BE => net_gnd8(0 to 7),
      PIM7_WrFIFO_Push => net_gnd0,
      PIM7_RdFIFO_Data => open,
      PIM7_RdFIFO_Pop => net_gnd0,
      PIM7_RdFIFO_RdWdAddr => open,
      PIM7_WrFIFO_Empty => open,
      PIM7_WrFIFO_AlmostFull => open,
      PIM7_WrFIFO_Flush => net_gnd0,
      PIM7_RdFIFO_Empty => open,
      PIM7_RdFIFO_Flush => net_gnd0,
      PIM7_RdFIFO_Latency => open,
      PIM7_InitDone => open,
      PPC440MC7_MIMCReadNotWrite => net_gnd0,
      PPC440MC7_MIMCAddress => net_gnd36,
      PPC440MC7_MIMCAddressValid => net_gnd0,
      PPC440MC7_MIMCWriteData => net_gnd128,
      PPC440MC7_MIMCWriteDataValid => net_gnd0,
      PPC440MC7_MIMCByteEnable => net_gnd16(15 downto 0),
      PPC440MC7_MIMCBankConflict => net_gnd0,
      PPC440MC7_MIMCRowConflict => net_gnd0,
      PPC440MC7_MCMIReadData => open,
      PPC440MC7_MCMIReadDataValid => open,
      PPC440MC7_MCMIReadDataErr => open,
      PPC440MC7_MCMIAddrReadyToAccept => open,
      VFBC7_Cmd_Clk => net_gnd0,
      VFBC7_Cmd_Reset => net_gnd0,
      VFBC7_Cmd_Data => net_gnd32,
      VFBC7_Cmd_Write => net_gnd0,
      VFBC7_Cmd_End => net_gnd0,
      VFBC7_Cmd_Full => open,
      VFBC7_Cmd_Almost_Full => open,
      VFBC7_Cmd_Idle => open,
      VFBC7_Wd_Clk => net_gnd0,
      VFBC7_Wd_Reset => net_gnd0,
      VFBC7_Wd_Write => net_gnd0,
      VFBC7_Wd_End_Burst => net_gnd0,
      VFBC7_Wd_Flush => net_gnd0,
      VFBC7_Wd_Data => net_gnd32,
      VFBC7_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC7_Wd_Full => open,
      VFBC7_Wd_Almost_Full => open,
      VFBC7_Rd_Clk => net_gnd0,
      VFBC7_Rd_Reset => net_gnd0,
      VFBC7_Rd_Read => net_gnd0,
      VFBC7_Rd_End_Burst => net_gnd0,
      VFBC7_Rd_Flush => net_gnd0,
      VFBC7_Rd_Data => open,
      VFBC7_Rd_Empty => open,
      VFBC7_Rd_Almost_Empty => open,
      MCB7_cmd_clk => net_gnd0,
      MCB7_cmd_en => net_gnd0,
      MCB7_cmd_instr => net_gnd3(0 to 2),
      MCB7_cmd_bl => net_gnd6,
      MCB7_cmd_byte_addr => net_gnd30,
      MCB7_cmd_empty => open,
      MCB7_cmd_full => open,
      MCB7_wr_clk => net_gnd0,
      MCB7_wr_en => net_gnd0,
      MCB7_wr_mask => net_gnd8(0 to 7),
      MCB7_wr_data => net_gnd64(0 to 63),
      MCB7_wr_full => open,
      MCB7_wr_empty => open,
      MCB7_wr_count => open,
      MCB7_wr_underrun => open,
      MCB7_wr_error => open,
      MCB7_rd_clk => net_gnd0,
      MCB7_rd_en => net_gnd0,
      MCB7_rd_data => open,
      MCB7_rd_full => open,
      MCB7_rd_empty => open,
      MCB7_rd_count => open,
      MCB7_rd_overflow => open,
      MCB7_rd_error => open,
      MPMC_CTRL_Clk => clk_125_0000MHzPLL0_ADJUST,
      MPMC_CTRL_Rst => plb_v46_0_SPLB_Rst(8),
      MPMC_CTRL_PLB_ABus => plb_v46_0_PLB_ABus,
      MPMC_CTRL_PLB_PAValid => plb_v46_0_PLB_PAValid,
      MPMC_CTRL_PLB_SAValid => plb_v46_0_PLB_SAValid,
      MPMC_CTRL_PLB_masterID => plb_v46_0_PLB_masterID(0 to 0),
      MPMC_CTRL_PLB_RNW => plb_v46_0_PLB_RNW,
      MPMC_CTRL_PLB_BE => plb_v46_0_PLB_BE,
      MPMC_CTRL_PLB_UABus => plb_v46_0_PLB_UABus,
      MPMC_CTRL_PLB_rdPrim => plb_v46_0_PLB_rdPrim(8),
      MPMC_CTRL_PLB_wrPrim => plb_v46_0_PLB_wrPrim(8),
      MPMC_CTRL_PLB_abort => plb_v46_0_PLB_abort,
      MPMC_CTRL_PLB_busLock => plb_v46_0_PLB_busLock,
      MPMC_CTRL_PLB_MSize => plb_v46_0_PLB_MSize,
      MPMC_CTRL_PLB_size => plb_v46_0_PLB_size,
      MPMC_CTRL_PLB_type => plb_v46_0_PLB_type,
      MPMC_CTRL_PLB_lockErr => plb_v46_0_PLB_lockErr,
      MPMC_CTRL_PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      MPMC_CTRL_PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      MPMC_CTRL_PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      MPMC_CTRL_PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      MPMC_CTRL_PLB_reqPri => plb_v46_0_PLB_reqPri,
      MPMC_CTRL_PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      MPMC_CTRL_PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      MPMC_CTRL_PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      MPMC_CTRL_PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      MPMC_CTRL_Sl_addrAck => plb_v46_0_Sl_addrAck(8),
      MPMC_CTRL_Sl_SSize => plb_v46_0_Sl_SSize(16 to 17),
      MPMC_CTRL_Sl_wait => plb_v46_0_Sl_wait(8),
      MPMC_CTRL_Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(8),
      MPMC_CTRL_Sl_wrDAck => plb_v46_0_Sl_wrDAck(8),
      MPMC_CTRL_Sl_wrComp => plb_v46_0_Sl_wrComp(8),
      MPMC_CTRL_Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(8),
      MPMC_CTRL_Sl_rdDBus => plb_v46_0_Sl_rdDBus(1024 to 1151),
      MPMC_CTRL_Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(32 to 35),
      MPMC_CTRL_Sl_rdDAck => plb_v46_0_Sl_rdDAck(8),
      MPMC_CTRL_Sl_rdComp => plb_v46_0_Sl_rdComp(8),
      MPMC_CTRL_Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(8),
      MPMC_CTRL_Sl_MBusy => plb_v46_0_Sl_MBusy(8 to 8),
      MPMC_CTRL_Sl_MRdErr => plb_v46_0_Sl_MRdErr(8 to 8),
      MPMC_CTRL_Sl_MWrErr => plb_v46_0_Sl_MWrErr(8 to 8),
      MPMC_CTRL_Sl_MIRQ => plb_v46_0_Sl_MIRQ(8 to 8),
      MPMC_Clk0 => clk_125_0000MHzPLL0_ADJUST,
      MPMC_Clk0_DIV2 => net_vcc0,
      MPMC_Clk90 => clk_125_0000MHz90PLL0_ADJUST,
      MPMC_Clk_200MHz => clk_200_0000MHz,
      MPMC_Rst => sys_periph_reset(0),
      MPMC_Clk_Mem => net_vcc0,
      MPMC_Clk_Mem_2x => net_vcc0,
      MPMC_Clk_Mem_2x_180 => net_vcc0,
      MPMC_Clk_Mem_2x_CE0 => net_vcc0,
      MPMC_Clk_Mem_2x_CE90 => net_vcc0,
      MPMC_Clk_Wr_I0 => net_vcc0,
      MPMC_Clk_Wr_O0 => net_vcc0,
      MPMC_Clk_Wr_I1 => net_vcc0,
      MPMC_Clk_Wr_O1 => net_vcc0,
      MPMC_PLL_Lock => net_gnd0,
      MPMC_Idelayctrl_Rdy_I => net_vcc0,
      MPMC_Idelayctrl_Rdy_O => open,
      MPMC_InitDone => open,
      MPMC_ECC_Intr => open,
      MPMC_DCM_PSEN => open,
      MPMC_DCM_PSINCDEC => open,
      MPMC_DCM_PSDONE => net_gnd0,
      SDRAM_Clk => open,
      SDRAM_CE => open,
      SDRAM_CS_n => open,
      SDRAM_RAS_n => open,
      SDRAM_CAS_n => open,
      SDRAM_WE_n => open,
      SDRAM_BankAddr => open,
      SDRAM_Addr => open,
      SDRAM_DQ => open,
      SDRAM_DM => open,
      DDR_Clk => pgassign1(0 to 0),
      DDR_Clk_n => pgassign2(0 to 0),
      DDR_CE => pgassign3(0 to 0),
      DDR_CS_n => fpga_0_DDR_SDRAM_0_DDR_CS_n_pin,
      DDR_RAS_n => fpga_0_DDR_SDRAM_0_DDR_RAS_n_pin,
      DDR_CAS_n => fpga_0_DDR_SDRAM_0_DDR_CAS_n_pin,
      DDR_WE_n => fpga_0_DDR_SDRAM_0_DDR_WE_n_pin,
      DDR_BankAddr => fpga_0_DDR_SDRAM_0_DDR_BankAddr_pin,
      DDR_Addr => fpga_0_DDR_SDRAM_0_DDR_Addr_pin,
      DDR_DQ => fpga_0_DDR_SDRAM_0_DDR_DQ_pin,
      DDR_DM => fpga_0_DDR_SDRAM_0_DDR_DM_pin,
      DDR_DQS => fpga_0_DDR_SDRAM_0_DDR_DQS_pin,
      DDR_DQS_Div_O => open,
      DDR_DQS_Div_I => net_gnd0,
      DDR2_Clk => open,
      DDR2_Clk_n => open,
      DDR2_CE => open,
      DDR2_CS_n => open,
      DDR2_ODT => open,
      DDR2_RAS_n => open,
      DDR2_CAS_n => open,
      DDR2_WE_n => open,
      DDR2_BankAddr => open,
      DDR2_Addr => open,
      DDR2_DQ => open,
      DDR2_DM => open,
      DDR2_DQS => open,
      DDR2_DQS_n => open,
      DDR2_DQS_Div_O => open,
      DDR2_DQS_Div_I => net_gnd0,
      DDR3_Clk => open,
      DDR3_Clk_n => open,
      DDR3_CE => open,
      DDR3_CS_n => open,
      DDR3_ODT => open,
      DDR3_RAS_n => open,
      DDR3_CAS_n => open,
      DDR3_WE_n => open,
      DDR3_BankAddr => open,
      DDR3_Addr => open,
      DDR3_DQ => open,
      DDR3_DM => open,
      DDR3_Reset_n => open,
      DDR3_DQS => open,
      DDR3_DQS_n => open,
      mcbx_dram_addr => open,
      mcbx_dram_ba => open,
      mcbx_dram_ras_n => open,
      mcbx_dram_cas_n => open,
      mcbx_dram_we_n => open,
      mcbx_dram_cke => open,
      mcbx_dram_clk => open,
      mcbx_dram_clk_n => open,
      mcbx_dram_dq => open,
      mcbx_dram_dqs => open,
      mcbx_dram_dqs_n => open,
      mcbx_dram_udqs => open,
      mcbx_dram_udqs_n => open,
      mcbx_dram_udm => open,
      mcbx_dram_ldm => open,
      mcbx_dram_odt => open,
      mcbx_dram_ddr3_rst => open,
      selfrefresh_enter => net_gnd0,
      selfrefresh_mode => open,
      calib_recal => net_gnd0,
      rzq => open,
      zio => open
    );

  qmfir_0 : qmfir_0_wrapper
    port map (
      SPLB_Clk => clk_125_0000MHzPLL0_ADJUST,
      SPLB_Rst => plb_v46_0_SPLB_Rst(9),
      PLB_ABus => plb_v46_0_PLB_ABus,
      PLB_UABus => plb_v46_0_PLB_UABus,
      PLB_PAValid => plb_v46_0_PLB_PAValid,
      PLB_SAValid => plb_v46_0_PLB_SAValid,
      PLB_rdPrim => plb_v46_0_PLB_rdPrim(9),
      PLB_wrPrim => plb_v46_0_PLB_wrPrim(9),
      PLB_masterID => plb_v46_0_PLB_masterID(0 to 0),
      PLB_abort => plb_v46_0_PLB_abort,
      PLB_busLock => plb_v46_0_PLB_busLock,
      PLB_RNW => plb_v46_0_PLB_RNW,
      PLB_BE => plb_v46_0_PLB_BE,
      PLB_MSize => plb_v46_0_PLB_MSize,
      PLB_size => plb_v46_0_PLB_size,
      PLB_type => plb_v46_0_PLB_type,
      PLB_lockErr => plb_v46_0_PLB_lockErr,
      PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      PLB_reqPri => plb_v46_0_PLB_reqPri,
      PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      Sl_addrAck => plb_v46_0_Sl_addrAck(9),
      Sl_SSize => plb_v46_0_Sl_SSize(18 to 19),
      Sl_wait => plb_v46_0_Sl_wait(9),
      Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(9),
      Sl_wrDAck => plb_v46_0_Sl_wrDAck(9),
      Sl_wrComp => plb_v46_0_Sl_wrComp(9),
      Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(9),
      Sl_rdDBus => plb_v46_0_Sl_rdDBus(1152 to 1279),
      Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(36 to 39),
      Sl_rdDAck => plb_v46_0_Sl_rdDAck(9),
      Sl_rdComp => plb_v46_0_Sl_rdComp(9),
      Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(9),
      Sl_MBusy => plb_v46_0_Sl_MBusy(9 to 9),
      Sl_MWrErr => plb_v46_0_Sl_MWrErr(9 to 9),
      Sl_MRdErr => plb_v46_0_Sl_MRdErr(9 to 9),
      Sl_MIRQ => plb_v46_0_Sl_MIRQ(9 to 9),
      IP2INTC_Irpt => qmfir_0_IP2INTC_Irpt
    );

  iobuf_0 : IOBUF
    port map (
      I => fpga_0_Hard_Ethernet_MAC_MDIO_0_pin_O,
      IO => fpga_0_Hard_Ethernet_MAC_MDIO_0_pin,
      O => fpga_0_Hard_Ethernet_MAC_MDIO_0_pin_I,
      T => fpga_0_Hard_Ethernet_MAC_MDIO_0_pin_T
    );

end architecture STRUCTURE;

