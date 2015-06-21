-------------------------------------------------------------------------------
-- ppc440_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library ppc440_virtex5_v1_01_a;
use ppc440_virtex5_v1_01_a.all;

entity ppc440_0_wrapper is
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

  attribute x_core_info : STRING;
  attribute x_core_info of ppc440_0_wrapper : entity is "ppc440_virtex5_v1_01_a";

end ppc440_0_wrapper;

architecture STRUCTURE of ppc440_0_wrapper is

  component ppc440_virtex5 is
    generic (
      C_PIR : std_logic_vector(28 to 31);
      C_ENDIAN_RESET : std_logic;
      C_USER_RESET : std_logic_vector(0 to 3);
      C_INTERCONNECT_IMASK : BIT_VECTOR(0 to 31);
      C_ICU_RD_FETCH_PLB_PRIO : std_logic_vector(0 to 1);
      C_ICU_RD_SPEC_PLB_PRIO : std_logic_vector(0 to 1);
      C_ICU_RD_TOUCH_PLB_PRIO : std_logic_vector(0 to 1);
      C_DCU_RD_LD_CACHE_PLB_PRIO : std_logic_vector(0 to 1);
      C_DCU_RD_NONCACHE_PLB_PRIO : std_logic_vector(0 to 1);
      C_DCU_RD_TOUCH_PLB_PRIO : std_logic_vector(0 to 1);
      C_DCU_RD_URGENT_PLB_PRIO : std_logic_vector(0 to 1);
      C_DCU_WR_FLUSH_PLB_PRIO : std_logic_vector(0 to 1);
      C_DCU_WR_STORE_PLB_PRIO : std_logic_vector(0 to 1);
      C_DCU_WR_URGENT_PLB_PRIO : std_logic_vector(0 to 1);
      C_DMA0_PLB_PRIO : bit_vector(0 to 1);
      C_DMA1_PLB_PRIO : bit_vector(0 to 1);
      C_DMA2_PLB_PRIO : bit_vector(0 to 1);
      C_DMA3_PLB_PRIO : bit_vector(0 to 1);
      C_IDCR_BASEADDR : std_logic_vector(0 to 9);
      C_IDCR_HIGHADDR : std_logic_vector(0 to 9);
      C_APU_CONTROL : BIT_VECTOR(0 to 16);
      C_APU_UDI_0 : BIT_VECTOR(0 to 23);
      C_APU_UDI_1 : BIT_VECTOR(0 to 23);
      C_APU_UDI_2 : BIT_VECTOR(0 to 23);
      C_APU_UDI_3 : BIT_VECTOR(0 to 23);
      C_APU_UDI_4 : BIT_VECTOR(0 to 23);
      C_APU_UDI_5 : BIT_VECTOR(0 to 23);
      C_APU_UDI_6 : BIT_VECTOR(0 to 23);
      C_APU_UDI_7 : BIT_VECTOR(0 to 23);
      C_APU_UDI_8 : BIT_VECTOR(0 to 23);
      C_APU_UDI_9 : BIT_VECTOR(0 to 23);
      C_APU_UDI_10 : BIT_VECTOR(0 to 23);
      C_APU_UDI_11 : BIT_VECTOR(0 to 23);
      C_APU_UDI_12 : BIT_VECTOR(0 to 23);
      C_APU_UDI_13 : BIT_VECTOR(0 to 23);
      C_APU_UDI_14 : BIT_VECTOR(0 to 23);
      C_APU_UDI_15 : BIT_VECTOR(0 to 23);
      C_PPC440MC_ADDR_BASE : std_logic_vector(0 to 31);
      C_PPC440MC_ADDR_HIGH : std_logic_vector(0 to 31);
      C_PPC440MC_ROW_CONFLICT_MASK : BIT_VECTOR(0 to 31);
      C_PPC440MC_BANK_CONFLICT_MASK : BIT_VECTOR(0 to 31);
      C_PPC440MC_CONTROL : BIT_VECTOR(0 to 31);
      C_PPC440MC_PRIO_ICU : integer;
      C_PPC440MC_PRIO_DCUW : integer;
      C_PPC440MC_PRIO_DCUR : integer;
      C_PPC440MC_PRIO_SPLB1 : integer;
      C_PPC440MC_PRIO_SPLB0 : integer;
      C_PPC440MC_ARB_MODE : integer;
      C_PPC440MC_MAX_BURST : integer;
      C_MPLB_AWIDTH : integer;
      C_MPLB_DWIDTH : integer;
      C_MPLB_NATIVE_DWIDTH : integer;
      C_MPLB_COUNTER : BIT_VECTOR(0 to 31);
      C_MPLB_PRIO_ICU : integer;
      C_MPLB_PRIO_DCUW : integer;
      C_MPLB_PRIO_DCUR : integer;
      C_MPLB_PRIO_SPLB1 : integer;
      C_MPLB_PRIO_SPLB0 : integer;
      C_MPLB_ARB_MODE : integer;
      C_MPLB_SYNC_TATTRIBUTE : integer;
      C_MPLB_MAX_BURST : integer;
      C_MPLB_ALLOW_LOCK_XFER : integer;
      C_MPLB_READ_PIPE_ENABLE : integer;
      C_MPLB_WRITE_PIPE_ENABLE : integer;
      C_MPLB_WRITE_POST_ENABLE : integer;
      C_MPLB_P2P : integer;
      C_MPLB_WDOG_ENABLE : integer;
      C_SPLB0_AWIDTH : integer;
      C_SPLB0_DWIDTH : integer;
      C_SPLB0_NATIVE_DWIDTH : integer;
      C_SPLB0_SUPPORT_BURSTS : integer;
      C_SPLB0_USE_MPLB_ADDR : integer;
      C_SPLB0_NUM_MPLB_ADDR_RNG : integer;
      C_SPLB0_RNG_MC_BASEADDR : std_logic_vector(0 to 31);
      C_SPLB0_RNG_MC_HIGHADDR : std_logic_vector(0 to 31);
      C_SPLB0_RNG0_MPLB_BASEADDR : std_logic_vector(0 to 31);
      C_SPLB0_RNG0_MPLB_HIGHADDR : std_logic_vector(0 to 31);
      C_SPLB0_RNG1_MPLB_BASEADDR : std_logic_vector(0 to 31);
      C_SPLB0_RNG1_MPLB_HIGHADDR : std_logic_vector(0 to 31);
      C_SPLB0_RNG2_MPLB_BASEADDR : std_logic_vector(0 to 31);
      C_SPLB0_RNG2_MPLB_HIGHADDR : std_logic_vector(0 to 31);
      C_SPLB0_RNG3_MPLB_BASEADDR : std_logic_vector(0 to 31);
      C_SPLB0_RNG3_MPLB_HIGHADDR : std_logic_vector(0 to 31);
      C_SPLB0_NUM_MASTERS : INTEGER;
      C_SPLB0_MID_WIDTH : INTEGER;
      C_SPLB0_ALLOW_LOCK_XFER : integer;
      C_SPLB0_READ_PIPE_ENABLE : integer;
      C_SPLB0_PROPAGATE_MIRQ : integer;
      C_SPLB0_P2P : integer;
      C_SPLB1_AWIDTH : integer;
      C_SPLB1_DWIDTH : integer;
      C_SPLB1_NATIVE_DWIDTH : integer;
      C_SPLB1_SUPPORT_BURSTS : integer;
      C_SPLB1_USE_MPLB_ADDR : integer;
      C_SPLB1_NUM_MPLB_ADDR_RNG : integer;
      C_SPLB1_RNG_MC_BASEADDR : std_logic_vector(0 to 31);
      C_SPLB1_RNG_MC_HIGHADDR : std_logic_vector(0 to 31);
      C_SPLB1_RNG0_MPLB_BASEADDR : std_logic_vector(0 to 31);
      C_SPLB1_RNG0_MPLB_HIGHADDR : std_logic_vector(0 to 31);
      C_SPLB1_RNG1_MPLB_BASEADDR : std_logic_vector(0 to 31);
      C_SPLB1_RNG1_MPLB_HIGHADDR : std_logic_vector(0 to 31);
      C_SPLB1_RNG2_MPLB_BASEADDR : std_logic_vector(0 to 31);
      C_SPLB1_RNG2_MPLB_HIGHADDR : std_logic_vector(0 to 31);
      C_SPLB1_RNG3_MPLB_BASEADDR : std_logic_vector(0 to 31);
      C_SPLB1_RNG3_MPLB_HIGHADDR : std_logic_vector(0 to 31);
      C_SPLB1_NUM_MASTERS : INTEGER;
      C_SPLB1_MID_WIDTH : INTEGER;
      C_SPLB1_ALLOW_LOCK_XFER : integer;
      C_SPLB1_READ_PIPE_ENABLE : integer;
      C_SPLB1_PROPAGATE_MIRQ : integer;
      C_SPLB1_P2P : integer;
      C_NUM_DMA : INTEGER;
      C_DMA0_TXCHANNELCTRL : BIT_VECTOR(0 to 31);
      C_DMA0_RXCHANNELCTRL : BIT_VECTOR(0 to 31);
      C_DMA0_CONTROL : BIT_VECTOR(0 to 7);
      C_DMA0_TXIRQTIMER : BIT_VECTOR(0 to 9);
      C_DMA0_RXIRQTIMER : BIT_VECTOR(0 to 9);
      C_DMA1_TXCHANNELCTRL : BIT_VECTOR(0 to 31);
      C_DMA1_RXCHANNELCTRL : BIT_VECTOR(0 to 31);
      C_DMA1_CONTROL : BIT_VECTOR(0 to 7);
      C_DMA1_TXIRQTIMER : BIT_VECTOR(0 to 9);
      C_DMA1_RXIRQTIMER : BIT_VECTOR(0 to 9);
      C_DMA2_TXCHANNELCTRL : BIT_VECTOR(0 to 31);
      C_DMA2_RXCHANNELCTRL : BIT_VECTOR(0 to 31);
      C_DMA2_CONTROL : BIT_VECTOR(0 to 7);
      C_DMA2_TXIRQTIMER : BIT_VECTOR(0 to 9);
      C_DMA2_RXIRQTIMER : BIT_VECTOR(0 to 9);
      C_DMA3_TXCHANNELCTRL : BIT_VECTOR(0 to 31);
      C_DMA3_RXCHANNELCTRL : BIT_VECTOR(0 to 31);
      C_DMA3_CONTROL : BIT_VECTOR(0 to 7);
      C_DMA3_TXIRQTIMER : BIT_VECTOR(0 to 9);
      C_DMA3_RXIRQTIMER : BIT_VECTOR(0 to 9);
      C_DCR_AUTOLOCK_ENABLE : INTEGER;
      C_PPCDM_ASYNCMODE : INTEGER;
      C_PPCDS_ASYNCMODE : INTEGER
    );
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
      PLBPPCS0MASTERID : in std_logic_vector(0 to (C_SPLB0_MID_WIDTH-1));
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
      PPCS0PLBMBUSY : out std_logic_vector(0 to (C_SPLB0_NUM_MASTERS-1));
      PPCS0PLBMRDERR : out std_logic_vector(0 to (C_SPLB0_NUM_MASTERS-1));
      PPCS0PLBMWRERR : out std_logic_vector(0 to (C_SPLB0_NUM_MASTERS-1));
      PPCS0PLBMIRQ : out std_logic_vector(0 to (C_SPLB0_NUM_MASTERS-1));
      PPCS0PLBSSIZE : out std_logic_vector(0 to 1);
      CPMPPCS1PLBCLK : in std_logic;
      PLBPPCS1MASTERID : in std_logic_vector(0 to (C_SPLB1_MID_WIDTH-1));
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
      PPCS1PLBMBUSY : out std_logic_vector(0 to (C_SPLB1_NUM_MASTERS-1));
      PPCS1PLBMRDERR : out std_logic_vector(0 to (C_SPLB1_NUM_MASTERS-1));
      PPCS1PLBMWRERR : out std_logic_vector(0 to (C_SPLB1_NUM_MASTERS-1));
      PPCS1PLBMIRQ : out std_logic_vector(0 to (C_SPLB1_NUM_MASTERS-1));
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

begin

  ppc440_0 : ppc440_virtex5
    generic map (
      C_PIR => B"1111",
      C_ENDIAN_RESET => '0',
      C_USER_RESET => B"0000",
      C_INTERCONNECT_IMASK => X"ffffffff",
      C_ICU_RD_FETCH_PLB_PRIO => B"00",
      C_ICU_RD_SPEC_PLB_PRIO => B"00",
      C_ICU_RD_TOUCH_PLB_PRIO => B"00",
      C_DCU_RD_LD_CACHE_PLB_PRIO => B"00",
      C_DCU_RD_NONCACHE_PLB_PRIO => B"00",
      C_DCU_RD_TOUCH_PLB_PRIO => B"00",
      C_DCU_RD_URGENT_PLB_PRIO => B"00",
      C_DCU_WR_FLUSH_PLB_PRIO => B"00",
      C_DCU_WR_STORE_PLB_PRIO => B"00",
      C_DCU_WR_URGENT_PLB_PRIO => B"00",
      C_DMA0_PLB_PRIO => B"00",
      C_DMA1_PLB_PRIO => B"00",
      C_DMA2_PLB_PRIO => B"00",
      C_DMA3_PLB_PRIO => B"00",
      C_IDCR_BASEADDR => B"0000000000",
      C_IDCR_HIGHADDR => B"0011111111",
      C_APU_CONTROL => B"00010000000000000",
      C_APU_UDI_0 => B"000000000000000000000000",
      C_APU_UDI_1 => B"000000000000000000000000",
      C_APU_UDI_2 => B"000000000000000000000000",
      C_APU_UDI_3 => B"000000000000000000000000",
      C_APU_UDI_4 => B"000000000000000000000000",
      C_APU_UDI_5 => B"000000000000000000000000",
      C_APU_UDI_6 => B"000000000000000000000000",
      C_APU_UDI_7 => B"000000000000000000000000",
      C_APU_UDI_8 => B"000000000000000000000000",
      C_APU_UDI_9 => B"000000000000000000000000",
      C_APU_UDI_10 => B"000000000000000000000000",
      C_APU_UDI_11 => B"000000000000000000000000",
      C_APU_UDI_12 => B"000000000000000000000000",
      C_APU_UDI_13 => B"000000000000000000000000",
      C_APU_UDI_14 => B"000000000000000000000000",
      C_APU_UDI_15 => B"000000000000000000000000",
      C_PPC440MC_ADDR_BASE => X"FFFFFFFF",
      C_PPC440MC_ADDR_HIGH => X"00000000",
      C_PPC440MC_ROW_CONFLICT_MASK => X"00000000",
      C_PPC440MC_BANK_CONFLICT_MASK => X"00000000",
      C_PPC440MC_CONTROL => X"80F0008F",
      C_PPC440MC_PRIO_ICU => 4,
      C_PPC440MC_PRIO_DCUW => 3,
      C_PPC440MC_PRIO_DCUR => 2,
      C_PPC440MC_PRIO_SPLB1 => 0,
      C_PPC440MC_PRIO_SPLB0 => 1,
      C_PPC440MC_ARB_MODE => 0,
      C_PPC440MC_MAX_BURST => 8,
      C_MPLB_AWIDTH => 32,
      C_MPLB_DWIDTH => 128,
      C_MPLB_NATIVE_DWIDTH => 128,
      C_MPLB_COUNTER => X"00000500",
      C_MPLB_PRIO_ICU => 4,
      C_MPLB_PRIO_DCUW => 3,
      C_MPLB_PRIO_DCUR => 2,
      C_MPLB_PRIO_SPLB1 => 0,
      C_MPLB_PRIO_SPLB0 => 1,
      C_MPLB_ARB_MODE => 0,
      C_MPLB_SYNC_TATTRIBUTE => 0,
      C_MPLB_MAX_BURST => 8,
      C_MPLB_ALLOW_LOCK_XFER => 1,
      C_MPLB_READ_PIPE_ENABLE => 1,
      C_MPLB_WRITE_PIPE_ENABLE => 1,
      C_MPLB_WRITE_POST_ENABLE => 1,
      C_MPLB_P2P => 0,
      C_MPLB_WDOG_ENABLE => 1,
      C_SPLB0_AWIDTH => 32,
      C_SPLB0_DWIDTH => 128,
      C_SPLB0_NATIVE_DWIDTH => 128,
      C_SPLB0_SUPPORT_BURSTS => 1,
      C_SPLB0_USE_MPLB_ADDR => 0,
      C_SPLB0_NUM_MPLB_ADDR_RNG => 0,
      C_SPLB0_RNG_MC_BASEADDR => X"ffffffff",
      C_SPLB0_RNG_MC_HIGHADDR => X"00000000",
      C_SPLB0_RNG0_MPLB_BASEADDR => X"ffffffff",
      C_SPLB0_RNG0_MPLB_HIGHADDR => X"00000000",
      C_SPLB0_RNG1_MPLB_BASEADDR => X"ffffffff",
      C_SPLB0_RNG1_MPLB_HIGHADDR => X"00000000",
      C_SPLB0_RNG2_MPLB_BASEADDR => X"ffffffff",
      C_SPLB0_RNG2_MPLB_HIGHADDR => X"00000000",
      C_SPLB0_RNG3_MPLB_BASEADDR => X"ffffffff",
      C_SPLB0_RNG3_MPLB_HIGHADDR => X"00000000",
      C_SPLB0_NUM_MASTERS => 1,
      C_SPLB0_MID_WIDTH => 1,
      C_SPLB0_ALLOW_LOCK_XFER => 1,
      C_SPLB0_READ_PIPE_ENABLE => 1,
      C_SPLB0_PROPAGATE_MIRQ => 0,
      C_SPLB0_P2P => -1,
      C_SPLB1_AWIDTH => 32,
      C_SPLB1_DWIDTH => 128,
      C_SPLB1_NATIVE_DWIDTH => 128,
      C_SPLB1_SUPPORT_BURSTS => 1,
      C_SPLB1_USE_MPLB_ADDR => 0,
      C_SPLB1_NUM_MPLB_ADDR_RNG => 0,
      C_SPLB1_RNG_MC_BASEADDR => X"ffffffff",
      C_SPLB1_RNG_MC_HIGHADDR => X"00000000",
      C_SPLB1_RNG0_MPLB_BASEADDR => X"ffffffff",
      C_SPLB1_RNG0_MPLB_HIGHADDR => X"00000000",
      C_SPLB1_RNG1_MPLB_BASEADDR => X"ffffffff",
      C_SPLB1_RNG1_MPLB_HIGHADDR => X"00000000",
      C_SPLB1_RNG2_MPLB_BASEADDR => X"ffffffff",
      C_SPLB1_RNG2_MPLB_HIGHADDR => X"00000000",
      C_SPLB1_RNG3_MPLB_BASEADDR => X"ffffffff",
      C_SPLB1_RNG3_MPLB_HIGHADDR => X"00000000",
      C_SPLB1_NUM_MASTERS => 1,
      C_SPLB1_MID_WIDTH => 1,
      C_SPLB1_ALLOW_LOCK_XFER => 1,
      C_SPLB1_READ_PIPE_ENABLE => 1,
      C_SPLB1_PROPAGATE_MIRQ => 0,
      C_SPLB1_P2P => -1,
      C_NUM_DMA => 0,
      C_DMA0_TXCHANNELCTRL => X"01010000",
      C_DMA0_RXCHANNELCTRL => X"01010000",
      C_DMA0_CONTROL => B"00000000",
      C_DMA0_TXIRQTIMER => B"1111111111",
      C_DMA0_RXIRQTIMER => B"1111111111",
      C_DMA1_TXCHANNELCTRL => X"01010000",
      C_DMA1_RXCHANNELCTRL => X"01010000",
      C_DMA1_CONTROL => B"00000000",
      C_DMA1_TXIRQTIMER => B"1111111111",
      C_DMA1_RXIRQTIMER => B"1111111111",
      C_DMA2_TXCHANNELCTRL => X"01010000",
      C_DMA2_RXCHANNELCTRL => X"01010000",
      C_DMA2_CONTROL => B"00000000",
      C_DMA2_TXIRQTIMER => B"1111111111",
      C_DMA2_RXIRQTIMER => B"1111111111",
      C_DMA3_TXCHANNELCTRL => X"01010000",
      C_DMA3_RXCHANNELCTRL => X"01010000",
      C_DMA3_CONTROL => B"00000000",
      C_DMA3_TXIRQTIMER => B"1111111111",
      C_DMA3_RXIRQTIMER => B"1111111111",
      C_DCR_AUTOLOCK_ENABLE => 1,
      C_PPCDM_ASYNCMODE => 0,
      C_PPCDS_ASYNCMODE => 0
    )
    port map (
      CPMC440CLK => CPMC440CLK,
      CPMC440CLKEN => CPMC440CLKEN,
      CPMINTERCONNECTCLK => CPMINTERCONNECTCLK,
      CPMINTERCONNECTCLKEN => CPMINTERCONNECTCLKEN,
      CPMINTERCONNECTCLKNTO1 => CPMINTERCONNECTCLKNTO1,
      CPMC440CORECLOCKINACTIVE => CPMC440CORECLOCKINACTIVE,
      CPMC440TIMERCLOCK => CPMC440TIMERCLOCK,
      C440MACHINECHECK => C440MACHINECHECK,
      C440CPMCORESLEEPREQ => C440CPMCORESLEEPREQ,
      C440CPMDECIRPTREQ => C440CPMDECIRPTREQ,
      C440CPMFITIRPTREQ => C440CPMFITIRPTREQ,
      C440CPMMSRCE => C440CPMMSRCE,
      C440CPMMSREE => C440CPMMSREE,
      C440CPMTIMERRESETREQ => C440CPMTIMERRESETREQ,
      C440CPMWDIRPTREQ => C440CPMWDIRPTREQ,
      PPCCPMINTERCONNECTBUSY => PPCCPMINTERCONNECTBUSY,
      DBGC440DEBUGHALT => DBGC440DEBUGHALT,
      DBGC440DEBUGHALTNEG => DBGC440DEBUGHALTNEG,
      DBGC440SYSTEMSTATUS => DBGC440SYSTEMSTATUS,
      DBGC440UNCONDDEBUGEVENT => DBGC440UNCONDDEBUGEVENT,
      C440DBGSYSTEMCONTROL => C440DBGSYSTEMCONTROL,
      SPLB0_Error => SPLB0_Error,
      SPLB1_Error => SPLB1_Error,
      EICC440CRITIRQ => EICC440CRITIRQ,
      EICC440EXTIRQ => EICC440EXTIRQ,
      PPCEICINTERCONNECTIRQ => PPCEICINTERCONNECTIRQ,
      CPMDCRCLK => CPMDCRCLK,
      DCRPPCDMACK => DCRPPCDMACK,
      DCRPPCDMDBUSIN => DCRPPCDMDBUSIN,
      DCRPPCDMTIMEOUTWAIT => DCRPPCDMTIMEOUTWAIT,
      PPCDMDCRREAD => PPCDMDCRREAD,
      PPCDMDCRWRITE => PPCDMDCRWRITE,
      PPCDMDCRABUS => PPCDMDCRABUS,
      PPCDMDCRDBUSOUT => PPCDMDCRDBUSOUT,
      DCRPPCDSREAD => DCRPPCDSREAD,
      DCRPPCDSWRITE => DCRPPCDSWRITE,
      DCRPPCDSABUS => DCRPPCDSABUS,
      DCRPPCDSDBUSOUT => DCRPPCDSDBUSOUT,
      PPCDSDCRACK => PPCDSDCRACK,
      PPCDSDCRDBUSIN => PPCDSDCRDBUSIN,
      PPCDSDCRTIMEOUTWAIT => PPCDSDCRTIMEOUTWAIT,
      CPMFCMCLK => CPMFCMCLK,
      FCMAPUCR => FCMAPUCR,
      FCMAPUDONE => FCMAPUDONE,
      FCMAPUEXCEPTION => FCMAPUEXCEPTION,
      FCMAPUFPSCRFEX => FCMAPUFPSCRFEX,
      FCMAPURESULT => FCMAPURESULT,
      FCMAPURESULTVALID => FCMAPURESULTVALID,
      FCMAPUSLEEPNOTREADY => FCMAPUSLEEPNOTREADY,
      FCMAPUCONFIRMINSTR => FCMAPUCONFIRMINSTR,
      FCMAPUSTOREDATA => FCMAPUSTOREDATA,
      APUFCMDECNONAUTON => APUFCMDECNONAUTON,
      APUFCMDECFPUOP => APUFCMDECFPUOP,
      APUFCMDECLDSTXFERSIZE => APUFCMDECLDSTXFERSIZE,
      APUFCMDECLOAD => APUFCMDECLOAD,
      APUFCMNEXTINSTRREADY => APUFCMNEXTINSTRREADY,
      APUFCMDECSTORE => APUFCMDECSTORE,
      APUFCMDECUDI => APUFCMDECUDI,
      APUFCMDECUDIVALID => APUFCMDECUDIVALID,
      APUFCMENDIAN => APUFCMENDIAN,
      APUFCMFLUSH => APUFCMFLUSH,
      APUFCMINSTRUCTION => APUFCMINSTRUCTION,
      APUFCMINSTRVALID => APUFCMINSTRVALID,
      APUFCMLOADBYTEADDR => APUFCMLOADBYTEADDR,
      APUFCMLOADDATA => APUFCMLOADDATA,
      APUFCMLOADDVALID => APUFCMLOADDVALID,
      APUFCMOPERANDVALID => APUFCMOPERANDVALID,
      APUFCMRADATA => APUFCMRADATA,
      APUFCMRBDATA => APUFCMRBDATA,
      APUFCMWRITEBACKOK => APUFCMWRITEBACKOK,
      APUFCMMSRFE0 => APUFCMMSRFE0,
      APUFCMMSRFE1 => APUFCMMSRFE1,
      JTGC440TCK => JTGC440TCK,
      JTGC440TDI => JTGC440TDI,
      JTGC440TMS => JTGC440TMS,
      JTGC440TRSTNEG => JTGC440TRSTNEG,
      C440JTGTDO => C440JTGTDO,
      C440JTGTDOEN => C440JTGTDOEN,
      CPMMCCLK => CPMMCCLK,
      MCMIREADDATA => MCMIREADDATA,
      MCMIREADDATAVALID => MCMIREADDATAVALID,
      MCMIREADDATAERR => MCMIREADDATAERR,
      MCMIADDRREADYTOACCEPT => MCMIADDRREADYTOACCEPT,
      MIMCREADNOTWRITE => MIMCREADNOTWRITE,
      MIMCADDRESS => MIMCADDRESS,
      MIMCADDRESSVALID => MIMCADDRESSVALID,
      MIMCWRITEDATA => MIMCWRITEDATA,
      MIMCWRITEDATAVALID => MIMCWRITEDATAVALID,
      MIMCBYTEENABLE => MIMCBYTEENABLE,
      MIMCBANKCONFLICT => MIMCBANKCONFLICT,
      MIMCROWCONFLICT => MIMCROWCONFLICT,
      CPMPPCMPLBCLK => CPMPPCMPLBCLK,
      PLBPPCMMBUSY => PLBPPCMMBUSY,
      PLBPPCMMIRQ => PLBPPCMMIRQ,
      PLBPPCMMRDERR => PLBPPCMMRDERR,
      PLBPPCMMWRERR => PLBPPCMMWRERR,
      PLBPPCMADDRACK => PLBPPCMADDRACK,
      PLBPPCMRDBTERM => PLBPPCMRDBTERM,
      PLBPPCMRDDACK => PLBPPCMRDDACK,
      PLBPPCMRDDBUS => PLBPPCMRDDBUS,
      PLBPPCMRDWDADDR => PLBPPCMRDWDADDR,
      PLBPPCMREARBITRATE => PLBPPCMREARBITRATE,
      PLBPPCMSSIZE => PLBPPCMSSIZE,
      PLBPPCMTIMEOUT => PLBPPCMTIMEOUT,
      PLBPPCMWRBTERM => PLBPPCMWRBTERM,
      PLBPPCMWRDACK => PLBPPCMWRDACK,
      PLBPPCMRDPENDPRI => PLBPPCMRDPENDPRI,
      PLBPPCMRDPENDREQ => PLBPPCMRDPENDREQ,
      PLBPPCMREQPRI => PLBPPCMREQPRI,
      PLBPPCMWRPENDPRI => PLBPPCMWRPENDPRI,
      PLBPPCMWRPENDREQ => PLBPPCMWRPENDREQ,
      PPCMPLBABORT => PPCMPLBABORT,
      PPCMPLBABUS => PPCMPLBABUS,
      PPCMPLBBE => PPCMPLBBE,
      PPCMPLBBUSLOCK => PPCMPLBBUSLOCK,
      PPCMPLBLOCKERR => PPCMPLBLOCKERR,
      PPCMPLBMSIZE => PPCMPLBMSIZE,
      PPCMPLBPRIORITY => PPCMPLBPRIORITY,
      PPCMPLBRDBURST => PPCMPLBRDBURST,
      PPCMPLBREQUEST => PPCMPLBREQUEST,
      PPCMPLBRNW => PPCMPLBRNW,
      PPCMPLBSIZE => PPCMPLBSIZE,
      PPCMPLBTATTRIBUTE => PPCMPLBTATTRIBUTE,
      PPCMPLBTYPE => PPCMPLBTYPE,
      PPCMPLBUABUS => PPCMPLBUABUS,
      PPCMPLBWRBURST => PPCMPLBWRBURST,
      PPCMPLBWRDBUS => PPCMPLBWRDBUS,
      CPMPPCS0PLBCLK => CPMPPCS0PLBCLK,
      PLBPPCS0MASTERID => PLBPPCS0MASTERID,
      PLBPPCS0PAVALID => PLBPPCS0PAVALID,
      PLBPPCS0SAVALID => PLBPPCS0SAVALID,
      PLBPPCS0RDPENDREQ => PLBPPCS0RDPENDREQ,
      PLBPPCS0WRPENDREQ => PLBPPCS0WRPENDREQ,
      PLBPPCS0RDPENDPRI => PLBPPCS0RDPENDPRI,
      PLBPPCS0WRPENDPRI => PLBPPCS0WRPENDPRI,
      PLBPPCS0REQPRI => PLBPPCS0REQPRI,
      PLBPPCS0RDPRIM => PLBPPCS0RDPRIM,
      PLBPPCS0WRPRIM => PLBPPCS0WRPRIM,
      PLBPPCS0BUSLOCK => PLBPPCS0BUSLOCK,
      PLBPPCS0ABORT => PLBPPCS0ABORT,
      PLBPPCS0RNW => PLBPPCS0RNW,
      PLBPPCS0BE => PLBPPCS0BE,
      PLBPPCS0SIZE => PLBPPCS0SIZE,
      PLBPPCS0TYPE => PLBPPCS0TYPE,
      PLBPPCS0TATTRIBUTE => PLBPPCS0TATTRIBUTE,
      PLBPPCS0LOCKERR => PLBPPCS0LOCKERR,
      PLBPPCS0MSIZE => PLBPPCS0MSIZE,
      PLBPPCS0UABUS => PLBPPCS0UABUS,
      PLBPPCS0ABUS => PLBPPCS0ABUS,
      PLBPPCS0WRDBUS => PLBPPCS0WRDBUS,
      PLBPPCS0WRBURST => PLBPPCS0WRBURST,
      PLBPPCS0RDBURST => PLBPPCS0RDBURST,
      PPCS0PLBADDRACK => PPCS0PLBADDRACK,
      PPCS0PLBWAIT => PPCS0PLBWAIT,
      PPCS0PLBREARBITRATE => PPCS0PLBREARBITRATE,
      PPCS0PLBWRDACK => PPCS0PLBWRDACK,
      PPCS0PLBWRCOMP => PPCS0PLBWRCOMP,
      PPCS0PLBRDDBUS => PPCS0PLBRDDBUS,
      PPCS0PLBRDWDADDR => PPCS0PLBRDWDADDR,
      PPCS0PLBRDDACK => PPCS0PLBRDDACK,
      PPCS0PLBRDCOMP => PPCS0PLBRDCOMP,
      PPCS0PLBRDBTERM => PPCS0PLBRDBTERM,
      PPCS0PLBWRBTERM => PPCS0PLBWRBTERM,
      PPCS0PLBMBUSY => PPCS0PLBMBUSY,
      PPCS0PLBMRDERR => PPCS0PLBMRDERR,
      PPCS0PLBMWRERR => PPCS0PLBMWRERR,
      PPCS0PLBMIRQ => PPCS0PLBMIRQ,
      PPCS0PLBSSIZE => PPCS0PLBSSIZE,
      CPMPPCS1PLBCLK => CPMPPCS1PLBCLK,
      PLBPPCS1MASTERID => PLBPPCS1MASTERID,
      PLBPPCS1PAVALID => PLBPPCS1PAVALID,
      PLBPPCS1SAVALID => PLBPPCS1SAVALID,
      PLBPPCS1RDPENDREQ => PLBPPCS1RDPENDREQ,
      PLBPPCS1WRPENDREQ => PLBPPCS1WRPENDREQ,
      PLBPPCS1RDPENDPRI => PLBPPCS1RDPENDPRI,
      PLBPPCS1WRPENDPRI => PLBPPCS1WRPENDPRI,
      PLBPPCS1REQPRI => PLBPPCS1REQPRI,
      PLBPPCS1RDPRIM => PLBPPCS1RDPRIM,
      PLBPPCS1WRPRIM => PLBPPCS1WRPRIM,
      PLBPPCS1BUSLOCK => PLBPPCS1BUSLOCK,
      PLBPPCS1ABORT => PLBPPCS1ABORT,
      PLBPPCS1RNW => PLBPPCS1RNW,
      PLBPPCS1BE => PLBPPCS1BE,
      PLBPPCS1SIZE => PLBPPCS1SIZE,
      PLBPPCS1TYPE => PLBPPCS1TYPE,
      PLBPPCS1TATTRIBUTE => PLBPPCS1TATTRIBUTE,
      PLBPPCS1LOCKERR => PLBPPCS1LOCKERR,
      PLBPPCS1MSIZE => PLBPPCS1MSIZE,
      PLBPPCS1UABUS => PLBPPCS1UABUS,
      PLBPPCS1ABUS => PLBPPCS1ABUS,
      PLBPPCS1WRDBUS => PLBPPCS1WRDBUS,
      PLBPPCS1WRBURST => PLBPPCS1WRBURST,
      PLBPPCS1RDBURST => PLBPPCS1RDBURST,
      PPCS1PLBADDRACK => PPCS1PLBADDRACK,
      PPCS1PLBWAIT => PPCS1PLBWAIT,
      PPCS1PLBREARBITRATE => PPCS1PLBREARBITRATE,
      PPCS1PLBWRDACK => PPCS1PLBWRDACK,
      PPCS1PLBWRCOMP => PPCS1PLBWRCOMP,
      PPCS1PLBRDDBUS => PPCS1PLBRDDBUS,
      PPCS1PLBRDWDADDR => PPCS1PLBRDWDADDR,
      PPCS1PLBRDDACK => PPCS1PLBRDDACK,
      PPCS1PLBRDCOMP => PPCS1PLBRDCOMP,
      PPCS1PLBRDBTERM => PPCS1PLBRDBTERM,
      PPCS1PLBWRBTERM => PPCS1PLBWRBTERM,
      PPCS1PLBMBUSY => PPCS1PLBMBUSY,
      PPCS1PLBMRDERR => PPCS1PLBMRDERR,
      PPCS1PLBMWRERR => PPCS1PLBMWRERR,
      PPCS1PLBMIRQ => PPCS1PLBMIRQ,
      PPCS1PLBSSIZE => PPCS1PLBSSIZE,
      CPMDMA0LLCLK => CPMDMA0LLCLK,
      LLDMA0TXDSTRDYN => LLDMA0TXDSTRDYN,
      LLDMA0RXD => LLDMA0RXD,
      LLDMA0RXREM => LLDMA0RXREM,
      LLDMA0RXSOFN => LLDMA0RXSOFN,
      LLDMA0RXEOFN => LLDMA0RXEOFN,
      LLDMA0RXSOPN => LLDMA0RXSOPN,
      LLDMA0RXEOPN => LLDMA0RXEOPN,
      LLDMA0RXSRCRDYN => LLDMA0RXSRCRDYN,
      LLDMA0RSTENGINEREQ => LLDMA0RSTENGINEREQ,
      DMA0LLTXD => DMA0LLTXD,
      DMA0LLTXREM => DMA0LLTXREM,
      DMA0LLTXSOFN => DMA0LLTXSOFN,
      DMA0LLTXEOFN => DMA0LLTXEOFN,
      DMA0LLTXSOPN => DMA0LLTXSOPN,
      DMA0LLTXEOPN => DMA0LLTXEOPN,
      DMA0LLTXSRCRDYN => DMA0LLTXSRCRDYN,
      DMA0LLRXDSTRDYN => DMA0LLRXDSTRDYN,
      DMA0LLRSTENGINEACK => DMA0LLRSTENGINEACK,
      DMA0TXIRQ => DMA0TXIRQ,
      DMA0RXIRQ => DMA0RXIRQ,
      CPMDMA1LLCLK => CPMDMA1LLCLK,
      LLDMA1TXDSTRDYN => LLDMA1TXDSTRDYN,
      LLDMA1RXD => LLDMA1RXD,
      LLDMA1RXREM => LLDMA1RXREM,
      LLDMA1RXSOFN => LLDMA1RXSOFN,
      LLDMA1RXEOFN => LLDMA1RXEOFN,
      LLDMA1RXSOPN => LLDMA1RXSOPN,
      LLDMA1RXEOPN => LLDMA1RXEOPN,
      LLDMA1RXSRCRDYN => LLDMA1RXSRCRDYN,
      LLDMA1RSTENGINEREQ => LLDMA1RSTENGINEREQ,
      DMA1LLTXD => DMA1LLTXD,
      DMA1LLTXREM => DMA1LLTXREM,
      DMA1LLTXSOFN => DMA1LLTXSOFN,
      DMA1LLTXEOFN => DMA1LLTXEOFN,
      DMA1LLTXSOPN => DMA1LLTXSOPN,
      DMA1LLTXEOPN => DMA1LLTXEOPN,
      DMA1LLTXSRCRDYN => DMA1LLTXSRCRDYN,
      DMA1LLRXDSTRDYN => DMA1LLRXDSTRDYN,
      DMA1LLRSTENGINEACK => DMA1LLRSTENGINEACK,
      DMA1TXIRQ => DMA1TXIRQ,
      DMA1RXIRQ => DMA1RXIRQ,
      CPMDMA2LLCLK => CPMDMA2LLCLK,
      LLDMA2TXDSTRDYN => LLDMA2TXDSTRDYN,
      LLDMA2RXD => LLDMA2RXD,
      LLDMA2RXREM => LLDMA2RXREM,
      LLDMA2RXSOFN => LLDMA2RXSOFN,
      LLDMA2RXEOFN => LLDMA2RXEOFN,
      LLDMA2RXSOPN => LLDMA2RXSOPN,
      LLDMA2RXEOPN => LLDMA2RXEOPN,
      LLDMA2RXSRCRDYN => LLDMA2RXSRCRDYN,
      LLDMA2RSTENGINEREQ => LLDMA2RSTENGINEREQ,
      DMA2LLTXD => DMA2LLTXD,
      DMA2LLTXREM => DMA2LLTXREM,
      DMA2LLTXSOFN => DMA2LLTXSOFN,
      DMA2LLTXEOFN => DMA2LLTXEOFN,
      DMA2LLTXSOPN => DMA2LLTXSOPN,
      DMA2LLTXEOPN => DMA2LLTXEOPN,
      DMA2LLTXSRCRDYN => DMA2LLTXSRCRDYN,
      DMA2LLRXDSTRDYN => DMA2LLRXDSTRDYN,
      DMA2LLRSTENGINEACK => DMA2LLRSTENGINEACK,
      DMA2TXIRQ => DMA2TXIRQ,
      DMA2RXIRQ => DMA2RXIRQ,
      CPMDMA3LLCLK => CPMDMA3LLCLK,
      LLDMA3TXDSTRDYN => LLDMA3TXDSTRDYN,
      LLDMA3RXD => LLDMA3RXD,
      LLDMA3RXREM => LLDMA3RXREM,
      LLDMA3RXSOFN => LLDMA3RXSOFN,
      LLDMA3RXEOFN => LLDMA3RXEOFN,
      LLDMA3RXSOPN => LLDMA3RXSOPN,
      LLDMA3RXEOPN => LLDMA3RXEOPN,
      LLDMA3RXSRCRDYN => LLDMA3RXSRCRDYN,
      LLDMA3RSTENGINEREQ => LLDMA3RSTENGINEREQ,
      DMA3LLTXD => DMA3LLTXD,
      DMA3LLTXREM => DMA3LLTXREM,
      DMA3LLTXSOFN => DMA3LLTXSOFN,
      DMA3LLTXEOFN => DMA3LLTXEOFN,
      DMA3LLTXSOPN => DMA3LLTXSOPN,
      DMA3LLTXEOPN => DMA3LLTXEOPN,
      DMA3LLTXSRCRDYN => DMA3LLTXSRCRDYN,
      DMA3LLRXDSTRDYN => DMA3LLRXDSTRDYN,
      DMA3LLRSTENGINEACK => DMA3LLRSTENGINEACK,
      DMA3TXIRQ => DMA3TXIRQ,
      DMA3RXIRQ => DMA3RXIRQ,
      RSTC440RESETCORE => RSTC440RESETCORE,
      RSTC440RESETCHIP => RSTC440RESETCHIP,
      RSTC440RESETSYSTEM => RSTC440RESETSYSTEM,
      C440RSTCORERESETREQ => C440RSTCORERESETREQ,
      C440RSTCHIPRESETREQ => C440RSTCHIPRESETREQ,
      C440RSTSYSTEMRESETREQ => C440RSTSYSTEMRESETREQ,
      TRCC440TRACEDISABLE => TRCC440TRACEDISABLE,
      TRCC440TRIGGEREVENTIN => TRCC440TRIGGEREVENTIN,
      C440TRCBRANCHSTATUS => C440TRCBRANCHSTATUS,
      C440TRCCYCLE => C440TRCCYCLE,
      C440TRCEXECUTIONSTATUS => C440TRCEXECUTIONSTATUS,
      C440TRCTRACESTATUS => C440TRCTRACESTATUS,
      C440TRCTRIGGEREVENTOUT => C440TRCTRIGGEREVENTOUT,
      C440TRCTRIGGEREVENTTYPE => C440TRCTRIGGEREVENTTYPE
    );

end architecture STRUCTURE;

