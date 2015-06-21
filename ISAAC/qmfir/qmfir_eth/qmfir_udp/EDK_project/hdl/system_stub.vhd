-------------------------------------------------------------------------------
-- system_stub.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity system_stub is
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
end system_stub;

architecture STRUCTURE of system_stub is

  component system is
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
  end component;

  attribute BOX_TYPE : STRING;
  attribute BOX_TYPE of system : component is "user_black_box";

begin

  system_i : system
    port map (
      fpga_0_RS232_0_RX_pin => fpga_0_RS232_0_RX_pin,
      fpga_0_RS232_0_TX_pin => fpga_0_RS232_0_TX_pin,
      fpga_0_Hard_Ethernet_MAC_TemacPhy_RST_n_pin => fpga_0_Hard_Ethernet_MAC_TemacPhy_RST_n_pin,
      fpga_0_Hard_Ethernet_MAC_MII_TXD_0_pin => fpga_0_Hard_Ethernet_MAC_MII_TXD_0_pin,
      fpga_0_Hard_Ethernet_MAC_MII_TX_EN_0_pin => fpga_0_Hard_Ethernet_MAC_MII_TX_EN_0_pin,
      fpga_0_Hard_Ethernet_MAC_MII_TX_ER_0_pin => fpga_0_Hard_Ethernet_MAC_MII_TX_ER_0_pin,
      fpga_0_Hard_Ethernet_MAC_MII_RXD_0_pin => fpga_0_Hard_Ethernet_MAC_MII_RXD_0_pin,
      fpga_0_Hard_Ethernet_MAC_MII_RX_DV_0_pin => fpga_0_Hard_Ethernet_MAC_MII_RX_DV_0_pin,
      fpga_0_Hard_Ethernet_MAC_MII_RX_ER_0_pin => fpga_0_Hard_Ethernet_MAC_MII_RX_ER_0_pin,
      fpga_0_Hard_Ethernet_MAC_MII_RX_CLK_0_pin => fpga_0_Hard_Ethernet_MAC_MII_RX_CLK_0_pin,
      fpga_0_Hard_Ethernet_MAC_MII_TX_CLK_0_pin => fpga_0_Hard_Ethernet_MAC_MII_TX_CLK_0_pin,
      fpga_0_Hard_Ethernet_MAC_MDC_0_pin => fpga_0_Hard_Ethernet_MAC_MDC_0_pin,
      fpga_0_Hard_Ethernet_MAC_MDIO_0_pin => fpga_0_Hard_Ethernet_MAC_MDIO_0_pin,
      fpga_0_Hard_Ethernet_MAC_PHY_INTR_pin => fpga_0_Hard_Ethernet_MAC_PHY_INTR_pin,
      fpga_0_DDR_SDRAM_0_DDR_Clk_pin => fpga_0_DDR_SDRAM_0_DDR_Clk_pin,
      fpga_0_DDR_SDRAM_0_DDR_Clk_n_pin => fpga_0_DDR_SDRAM_0_DDR_Clk_n_pin,
      fpga_0_DDR_SDRAM_0_DDR_Addr_pin => fpga_0_DDR_SDRAM_0_DDR_Addr_pin,
      fpga_0_DDR_SDRAM_0_DDR_BankAddr_pin => fpga_0_DDR_SDRAM_0_DDR_BankAddr_pin,
      fpga_0_DDR_SDRAM_0_DDR_CAS_n_pin => fpga_0_DDR_SDRAM_0_DDR_CAS_n_pin,
      fpga_0_DDR_SDRAM_0_DDR_CE_pin => fpga_0_DDR_SDRAM_0_DDR_CE_pin,
      fpga_0_DDR_SDRAM_0_DDR_CS_n_pin => fpga_0_DDR_SDRAM_0_DDR_CS_n_pin,
      fpga_0_DDR_SDRAM_0_DDR_RAS_n_pin => fpga_0_DDR_SDRAM_0_DDR_RAS_n_pin,
      fpga_0_DDR_SDRAM_0_DDR_WE_n_pin => fpga_0_DDR_SDRAM_0_DDR_WE_n_pin,
      fpga_0_DDR_SDRAM_0_DDR_DM_pin => fpga_0_DDR_SDRAM_0_DDR_DM_pin,
      fpga_0_DDR_SDRAM_0_DDR_DQS_pin => fpga_0_DDR_SDRAM_0_DDR_DQS_pin,
      fpga_0_DDR_SDRAM_0_DDR_DQ_pin => fpga_0_DDR_SDRAM_0_DDR_DQ_pin,
      fpga_0_DDR_SDRAM_0_CLK_RESET_n_pin => fpga_0_DDR_SDRAM_0_CLK_RESET_n_pin,
      fpga_0_sys_clk_pin => fpga_0_sys_clk_pin,
      fpga_0_sys_rst_pin => fpga_0_sys_rst_pin
    );

end architecture STRUCTURE;

