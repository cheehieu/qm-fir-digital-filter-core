-------------------------------------------------------------------------------
-- hard_ethernet_mac_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library xps_ll_temac_v2_03_a;
use xps_ll_temac_v2_03_a.all;

entity hard_ethernet_mac_wrapper is
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

  attribute x_core_info : STRING;
  attribute x_core_info of hard_ethernet_mac_wrapper : entity is "xps_ll_temac_v2_03_a";

end hard_ethernet_mac_wrapper;

architecture STRUCTURE of hard_ethernet_mac_wrapper is

  component xps_ll_temac is
    generic (
      C_NUM_IDELAYCTRL : INTEGER;
      C_SUBFAMILY : string;
      C_RESERVED : INTEGER;
      C_FAMILY : STRING;
      C_BASEADDR : std_logic_vector;
      C_HIGHADDR : std_logic_vector;
      C_SPLB_DWIDTH : INTEGER;
      C_SPLB_AWIDTH : INTEGER;
      C_SPLB_NUM_MASTERS : INTEGER;
      C_SPLB_MID_WIDTH : INTEGER;
      C_SPLB_P2P : INTEGER;
      C_INCLUDE_IO : INTEGER;
      C_PHY_TYPE : INTEGER;
      C_TEMAC1_ENABLED : INTEGER;
      C_TEMAC0_TXFIFO : INTEGER;
      C_TEMAC0_RXFIFO : INTEGER;
      C_TEMAC1_TXFIFO : INTEGER;
      C_TEMAC1_RXFIFO : INTEGER;
      C_BUS2CORE_CLK_RATIO : INTEGER;
      C_TEMAC_TYPE : INTEGER;
      C_TEMAC0_TXCSUM : INTEGER;
      C_TEMAC0_RXCSUM : INTEGER;
      C_TEMAC1_TXCSUM : INTEGER;
      C_TEMAC1_RXCSUM : INTEGER;
      C_TEMAC0_PHYADDR : std_logic_vector;
      C_TEMAC1_PHYADDR : std_logic_vector;
      C_TEMAC0_TXVLAN_TRAN : INTEGER;
      C_TEMAC0_RXVLAN_TRAN : INTEGER;
      C_TEMAC1_TXVLAN_TRAN : INTEGER;
      C_TEMAC1_RXVLAN_TRAN : INTEGER;
      C_TEMAC0_TXVLAN_TAG : INTEGER;
      C_TEMAC0_RXVLAN_TAG : INTEGER;
      C_TEMAC1_TXVLAN_TAG : INTEGER;
      C_TEMAC1_RXVLAN_TAG : INTEGER;
      C_TEMAC0_TXVLAN_STRP : INTEGER;
      C_TEMAC0_RXVLAN_STRP : INTEGER;
      C_TEMAC1_TXVLAN_STRP : INTEGER;
      C_TEMAC1_RXVLAN_STRP : INTEGER;
      C_TEMAC0_MCAST_EXTEND : INTEGER;
      C_TEMAC1_MCAST_EXTEND : INTEGER;
      C_TEMAC0_STATS : INTEGER;
      C_TEMAC1_STATS : INTEGER;
      C_TEMAC0_AVB : INTEGER;
      C_TEMAC1_AVB : INTEGER;
      C_SIMULATION : INTEGER
    );
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
      PLB_masterID : in std_logic_vector(0 to (C_SPLB_MID_WIDTH-1));
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to ((C_SPLB_DWIDTH/8)-1));
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to (C_SPLB_DWIDTH-1));
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
      Sl_rdDBus : out std_logic_vector(0 to (C_SPLB_DWIDTH-1));
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to (C_SPLB_NUM_MASTERS-1));
      Sl_MWrErr : out std_logic_vector(0 to (C_SPLB_NUM_MASTERS-1));
      Sl_MRdErr : out std_logic_vector(0 to (C_SPLB_NUM_MASTERS-1));
      Sl_MIRQ : out std_logic_vector(0 to (C_SPLB_NUM_MASTERS-1));
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

begin

  Hard_Ethernet_MAC : xps_ll_temac
    generic map (
      C_NUM_IDELAYCTRL => 0,
      C_SUBFAMILY => "FX",
      C_RESERVED => 0,
      C_FAMILY => "virtex5",
      C_BASEADDR => X"83c80000",
      C_HIGHADDR => X"83cfffff",
      C_SPLB_DWIDTH => 128,
      C_SPLB_AWIDTH => 32,
      C_SPLB_NUM_MASTERS => 1,
      C_SPLB_MID_WIDTH => 1,
      C_SPLB_P2P => 0,
      C_INCLUDE_IO => 1,
      C_PHY_TYPE => 0,
      C_TEMAC1_ENABLED => 0,
      C_TEMAC0_TXFIFO => 4096,
      C_TEMAC0_RXFIFO => 4096,
      C_TEMAC1_TXFIFO => 4096,
      C_TEMAC1_RXFIFO => 4096,
      C_BUS2CORE_CLK_RATIO => 1,
      C_TEMAC_TYPE => 0,
      C_TEMAC0_TXCSUM => 0,
      C_TEMAC0_RXCSUM => 0,
      C_TEMAC1_TXCSUM => 0,
      C_TEMAC1_RXCSUM => 0,
      C_TEMAC0_PHYADDR => B"00001",
      C_TEMAC1_PHYADDR => B"00010",
      C_TEMAC0_TXVLAN_TRAN => 0,
      C_TEMAC0_RXVLAN_TRAN => 0,
      C_TEMAC1_TXVLAN_TRAN => 0,
      C_TEMAC1_RXVLAN_TRAN => 0,
      C_TEMAC0_TXVLAN_TAG => 0,
      C_TEMAC0_RXVLAN_TAG => 0,
      C_TEMAC1_TXVLAN_TAG => 0,
      C_TEMAC1_RXVLAN_TAG => 0,
      C_TEMAC0_TXVLAN_STRP => 0,
      C_TEMAC0_RXVLAN_STRP => 0,
      C_TEMAC1_TXVLAN_STRP => 0,
      C_TEMAC1_RXVLAN_STRP => 0,
      C_TEMAC0_MCAST_EXTEND => 0,
      C_TEMAC1_MCAST_EXTEND => 0,
      C_TEMAC0_STATS => 0,
      C_TEMAC1_STATS => 0,
      C_TEMAC0_AVB => 0,
      C_TEMAC1_AVB => 0,
      C_SIMULATION => 0
    )
    port map (
      TemacIntc0_Irpt => TemacIntc0_Irpt,
      TemacIntc1_Irpt => TemacIntc1_Irpt,
      TemacPhy_RST_n => TemacPhy_RST_n,
      GTX_CLK_0 => GTX_CLK_0,
      MGTCLK_P => MGTCLK_P,
      MGTCLK_N => MGTCLK_N,
      REFCLK => REFCLK,
      DCLK => DCLK,
      SPLB_Clk => SPLB_Clk,
      SPLB_Rst => SPLB_Rst,
      Core_Clk => Core_Clk,
      PLB_ABus => PLB_ABus,
      PLB_UABus => PLB_UABus,
      PLB_PAValid => PLB_PAValid,
      PLB_SAValid => PLB_SAValid,
      PLB_rdPrim => PLB_rdPrim,
      PLB_wrPrim => PLB_wrPrim,
      PLB_masterID => PLB_masterID,
      PLB_abort => PLB_abort,
      PLB_busLock => PLB_busLock,
      PLB_RNW => PLB_RNW,
      PLB_BE => PLB_BE,
      PLB_MSize => PLB_MSize,
      PLB_size => PLB_size,
      PLB_type => PLB_type,
      PLB_lockErr => PLB_lockErr,
      PLB_wrDBus => PLB_wrDBus,
      PLB_wrBurst => PLB_wrBurst,
      PLB_rdBurst => PLB_rdBurst,
      PLB_wrPendReq => PLB_wrPendReq,
      PLB_rdPendReq => PLB_rdPendReq,
      PLB_wrPendPri => PLB_wrPendPri,
      PLB_rdPendPri => PLB_rdPendPri,
      PLB_reqPri => PLB_reqPri,
      PLB_TAttribute => PLB_TAttribute,
      Sl_addrAck => Sl_addrAck,
      Sl_SSize => Sl_SSize,
      Sl_wait => Sl_wait,
      Sl_rearbitrate => Sl_rearbitrate,
      Sl_wrDAck => Sl_wrDAck,
      Sl_wrComp => Sl_wrComp,
      Sl_wrBTerm => Sl_wrBTerm,
      Sl_rdDBus => Sl_rdDBus,
      Sl_rdWdAddr => Sl_rdWdAddr,
      Sl_rdDAck => Sl_rdDAck,
      Sl_rdComp => Sl_rdComp,
      Sl_rdBTerm => Sl_rdBTerm,
      Sl_MBusy => Sl_MBusy,
      Sl_MWrErr => Sl_MWrErr,
      Sl_MRdErr => Sl_MRdErr,
      Sl_MIRQ => Sl_MIRQ,
      LlinkTemac0_CLK => LlinkTemac0_CLK,
      LlinkTemac0_RST => LlinkTemac0_RST,
      LlinkTemac0_SOP_n => LlinkTemac0_SOP_n,
      LlinkTemac0_EOP_n => LlinkTemac0_EOP_n,
      LlinkTemac0_SOF_n => LlinkTemac0_SOF_n,
      LlinkTemac0_EOF_n => LlinkTemac0_EOF_n,
      LlinkTemac0_REM => LlinkTemac0_REM,
      LlinkTemac0_Data => LlinkTemac0_Data,
      LlinkTemac0_SRC_RDY_n => LlinkTemac0_SRC_RDY_n,
      Temac0Llink_DST_RDY_n => Temac0Llink_DST_RDY_n,
      Temac0Llink_SOP_n => Temac0Llink_SOP_n,
      Temac0Llink_EOP_n => Temac0Llink_EOP_n,
      Temac0Llink_SOF_n => Temac0Llink_SOF_n,
      Temac0Llink_EOF_n => Temac0Llink_EOF_n,
      Temac0Llink_REM => Temac0Llink_REM,
      Temac0Llink_Data => Temac0Llink_Data,
      Temac0Llink_SRC_RDY_n => Temac0Llink_SRC_RDY_n,
      LlinkTemac0_DST_RDY_n => LlinkTemac0_DST_RDY_n,
      LlinkTemac1_CLK => LlinkTemac1_CLK,
      LlinkTemac1_RST => LlinkTemac1_RST,
      LlinkTemac1_SOP_n => LlinkTemac1_SOP_n,
      LlinkTemac1_EOP_n => LlinkTemac1_EOP_n,
      LlinkTemac1_SOF_n => LlinkTemac1_SOF_n,
      LlinkTemac1_EOF_n => LlinkTemac1_EOF_n,
      LlinkTemac1_REM => LlinkTemac1_REM,
      LlinkTemac1_Data => LlinkTemac1_Data,
      LlinkTemac1_SRC_RDY_n => LlinkTemac1_SRC_RDY_n,
      Temac1Llink_DST_RDY_n => Temac1Llink_DST_RDY_n,
      Temac1Llink_SOP_n => Temac1Llink_SOP_n,
      Temac1Llink_EOP_n => Temac1Llink_EOP_n,
      Temac1Llink_SOF_n => Temac1Llink_SOF_n,
      Temac1Llink_EOF_n => Temac1Llink_EOF_n,
      Temac1Llink_REM => Temac1Llink_REM,
      Temac1Llink_Data => Temac1Llink_Data,
      Temac1Llink_SRC_RDY_n => Temac1Llink_SRC_RDY_n,
      LlinkTemac1_DST_RDY_n => LlinkTemac1_DST_RDY_n,
      MII_TXD_0 => MII_TXD_0,
      MII_TX_EN_0 => MII_TX_EN_0,
      MII_TX_ER_0 => MII_TX_ER_0,
      MII_RXD_0 => MII_RXD_0,
      MII_RX_DV_0 => MII_RX_DV_0,
      MII_RX_ER_0 => MII_RX_ER_0,
      MII_RX_CLK_0 => MII_RX_CLK_0,
      MII_TX_CLK_0 => MII_TX_CLK_0,
      MII_TXD_1 => MII_TXD_1,
      MII_TX_EN_1 => MII_TX_EN_1,
      MII_TX_ER_1 => MII_TX_ER_1,
      MII_RXD_1 => MII_RXD_1,
      MII_RX_DV_1 => MII_RX_DV_1,
      MII_RX_ER_1 => MII_RX_ER_1,
      MII_RX_CLK_1 => MII_RX_CLK_1,
      MII_TX_CLK_1 => MII_TX_CLK_1,
      GMII_TXD_0 => GMII_TXD_0,
      GMII_TX_EN_0 => GMII_TX_EN_0,
      GMII_TX_ER_0 => GMII_TX_ER_0,
      GMII_TX_CLK_0 => GMII_TX_CLK_0,
      GMII_RXD_0 => GMII_RXD_0,
      GMII_RX_DV_0 => GMII_RX_DV_0,
      GMII_RX_ER_0 => GMII_RX_ER_0,
      GMII_RX_CLK_0 => GMII_RX_CLK_0,
      GMII_TXD_1 => GMII_TXD_1,
      GMII_TX_EN_1 => GMII_TX_EN_1,
      GMII_TX_ER_1 => GMII_TX_ER_1,
      GMII_TX_CLK_1 => GMII_TX_CLK_1,
      GMII_RXD_1 => GMII_RXD_1,
      GMII_RX_DV_1 => GMII_RX_DV_1,
      GMII_RX_ER_1 => GMII_RX_ER_1,
      GMII_RX_CLK_1 => GMII_RX_CLK_1,
      TXP_0 => TXP_0,
      TXN_0 => TXN_0,
      RXP_0 => RXP_0,
      RXN_0 => RXN_0,
      TXP_1 => TXP_1,
      TXN_1 => TXN_1,
      RXP_1 => RXP_1,
      RXN_1 => RXN_1,
      RGMII_TXD_0 => RGMII_TXD_0,
      RGMII_TX_CTL_0 => RGMII_TX_CTL_0,
      RGMII_TXC_0 => RGMII_TXC_0,
      RGMII_RXD_0 => RGMII_RXD_0,
      RGMII_RX_CTL_0 => RGMII_RX_CTL_0,
      RGMII_RXC_0 => RGMII_RXC_0,
      RGMII_TXD_1 => RGMII_TXD_1,
      RGMII_TX_CTL_1 => RGMII_TX_CTL_1,
      RGMII_TXC_1 => RGMII_TXC_1,
      RGMII_RXD_1 => RGMII_RXD_1,
      RGMII_RX_CTL_1 => RGMII_RX_CTL_1,
      RGMII_RXC_1 => RGMII_RXC_1,
      MDC_0 => MDC_0,
      MDC_1 => MDC_1,
      HostMiimRdy => HostMiimRdy,
      HostRdData => HostRdData,
      HostMiimSel => HostMiimSel,
      HostReq => HostReq,
      HostAddr => HostAddr,
      HostEmac1Sel => HostEmac1Sel,
      Temac0AvbTxClk => Temac0AvbTxClk,
      Temac0AvbTxClkEn => Temac0AvbTxClkEn,
      Temac0AvbRxClk => Temac0AvbRxClk,
      Temac0AvbRxClkEn => Temac0AvbRxClkEn,
      Avb2Mac0TxData => Avb2Mac0TxData,
      Avb2Mac0TxDataValid => Avb2Mac0TxDataValid,
      Avb2Mac0TxUnderrun => Avb2Mac0TxUnderrun,
      Mac02AvbTxAck => Mac02AvbTxAck,
      Mac02AvbRxData => Mac02AvbRxData,
      Mac02AvbRxDataValid => Mac02AvbRxDataValid,
      Mac02AvbRxFrameGood => Mac02AvbRxFrameGood,
      Mac02AvbRxFrameBad => Mac02AvbRxFrameBad,
      Temac02AvbTxData => Temac02AvbTxData,
      Temac02AvbTxDataValid => Temac02AvbTxDataValid,
      Temac02AvbTxUnderrun => Temac02AvbTxUnderrun,
      Avb2Temac0TxAck => Avb2Temac0TxAck,
      Avb2Temac0RxData => Avb2Temac0RxData,
      Avb2Temac0RxDataValid => Avb2Temac0RxDataValid,
      Avb2Temac0RxFrameGood => Avb2Temac0RxFrameGood,
      Avb2Temac0RxFrameBad => Avb2Temac0RxFrameBad,
      Temac1AvbTxClk => Temac1AvbTxClk,
      Temac1AvbTxClkEn => Temac1AvbTxClkEn,
      Temac1AvbRxClk => Temac1AvbRxClk,
      Temac1AvbRxClkEn => Temac1AvbRxClkEn,
      Avb2Mac1TxData => Avb2Mac1TxData,
      Avb2Mac1TxDataValid => Avb2Mac1TxDataValid,
      Avb2Mac1TxUnderrun => Avb2Mac1TxUnderrun,
      Mac12AvbTxAck => Mac12AvbTxAck,
      Mac12AvbRxData => Mac12AvbRxData,
      Mac12AvbRxDataValid => Mac12AvbRxDataValid,
      Mac12AvbRxFrameGood => Mac12AvbRxFrameGood,
      Mac12AvbRxFrameBad => Mac12AvbRxFrameBad,
      Temac12AvbTxData => Temac12AvbTxData,
      Temac12AvbTxDataValid => Temac12AvbTxDataValid,
      Temac12AvbTxUnderrun => Temac12AvbTxUnderrun,
      Avb2Temac1TxAck => Avb2Temac1TxAck,
      Avb2Temac1RxData => Avb2Temac1RxData,
      Avb2Temac1RxDataValid => Avb2Temac1RxDataValid,
      Avb2Temac1RxFrameGood => Avb2Temac1RxFrameGood,
      Avb2Temac1RxFrameBad => Avb2Temac1RxFrameBad,
      TxClientClk_0 => TxClientClk_0,
      ClientTxStat_0 => ClientTxStat_0,
      ClientTxStatsVld_0 => ClientTxStatsVld_0,
      ClientTxStatsByteVld_0 => ClientTxStatsByteVld_0,
      RxClientClk_0 => RxClientClk_0,
      ClientRxStats_0 => ClientRxStats_0,
      ClientRxStatsVld_0 => ClientRxStatsVld_0,
      ClientRxStatsByteVld_0 => ClientRxStatsByteVld_0,
      TxClientClk_1 => TxClientClk_1,
      ClientTxStat_1 => ClientTxStat_1,
      ClientTxStatsVld_1 => ClientTxStatsVld_1,
      ClientTxStatsByteVld_1 => ClientTxStatsByteVld_1,
      RxClientClk_1 => RxClientClk_1,
      ClientRxStats_1 => ClientRxStats_1,
      ClientRxStatsVld_1 => ClientRxStatsVld_1,
      ClientRxStatsByteVld_1 => ClientRxStatsByteVld_1,
      MDIO_0_I => MDIO_0_I,
      MDIO_0_O => MDIO_0_O,
      MDIO_0_T => MDIO_0_T,
      MDIO_1_I => MDIO_1_I,
      MDIO_1_O => MDIO_1_O,
      MDIO_1_T => MDIO_1_T
    );

end architecture STRUCTURE;

