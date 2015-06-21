-------------------------------------------------------------------------------
-- hard_ethernet_mac_fifo_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library xps_ll_fifo_v1_02_a;
use xps_ll_fifo_v1_02_a.all;

entity hard_ethernet_mac_fifo_wrapper is
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

  attribute x_core_info : STRING;
  attribute x_core_info of hard_ethernet_mac_fifo_wrapper : entity is "xps_ll_fifo_v1_02_a";

end hard_ethernet_mac_fifo_wrapper;

architecture STRUCTURE of hard_ethernet_mac_fifo_wrapper is

  component xps_ll_fifo is
    generic (
      C_SPLB_MID_WIDTH : INTEGER;
      C_SPLB_NUM_MASTERS : INTEGER;
      C_SPLB_SMALLEST_MASTER : INTEGER;
      C_SPLB_AWIDTH : INTEGER;
      C_BASEADDR : std_logic_vector;
      C_HIGHADDR : std_logic_vector;
      C_SPLB_DWIDTH : INTEGER;
      C_SPLB_P2P : INTEGER;
      C_FAMILY : STRING
    );
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
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

begin

  Hard_Ethernet_MAC_fifo : xps_ll_fifo
    generic map (
      C_SPLB_MID_WIDTH => 1,
      C_SPLB_NUM_MASTERS => 1,
      C_SPLB_SMALLEST_MASTER => 128,
      C_SPLB_AWIDTH => 32,
      C_BASEADDR => X"81a00000",
      C_HIGHADDR => X"81a0ffff",
      C_SPLB_DWIDTH => 128,
      C_SPLB_P2P => 0,
      C_FAMILY => "virtex5"
    )
    port map (
      SPLB_Clk => SPLB_Clk,
      SPLB_Rst => SPLB_Rst,
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
      IP2INTC_Irpt => IP2INTC_Irpt,
      llink_rst => llink_rst,
      tx_llink_din => tx_llink_din,
      tx_llink_src_rdy_n => tx_llink_src_rdy_n,
      tx_llink_dest_rdy_n => tx_llink_dest_rdy_n,
      tx_llink_sof_n => tx_llink_sof_n,
      tx_llink_sop_n => tx_llink_sop_n,
      tx_llink_eof_n => tx_llink_eof_n,
      tx_llink_eop_n => tx_llink_eop_n,
      tx_llink_rem_n => tx_llink_rem_n,
      rx_llink_din => rx_llink_din,
      rx_llink_src_rdy_n => rx_llink_src_rdy_n,
      rx_llink_dest_rdy_n => rx_llink_dest_rdy_n,
      rx_llink_sof_n => rx_llink_sof_n,
      rx_llink_sop_n => rx_llink_sop_n,
      rx_llink_eof_n => rx_llink_eof_n,
      rx_llink_eop_n => rx_llink_eop_n,
      rx_llink_rem_n => rx_llink_rem_n
    );

end architecture STRUCTURE;

