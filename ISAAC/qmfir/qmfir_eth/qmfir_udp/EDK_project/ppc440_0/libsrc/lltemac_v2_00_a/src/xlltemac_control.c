/* $Id: xlltemac_control.c,v 1.5.2.1 2009/02/03 01:10:53 wyang Exp $ */
/******************************************************************************
*
*       XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
*       AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND
*       SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,
*       OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
*       APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION
*       THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
*       AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
*       FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
*       WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
*       IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
*       REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
*       INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
*       FOR A PARTICULAR PURPOSE.
*
*       (c) Copyright 2005-2008 Xilinx Inc.
*       All rights reserved.
*
******************************************************************************/
/*****************************************************************************/
/**
 *
 * @file xlltemac_control.c
 *
 * Functions in this file implement general purpose command and control related
 * functionality. See xlltemac.h for a detailed description of the driver.
 *
 * <pre>
 * MODIFICATION HISTORY:
 *
 * Ver   Who  Date     Changes
 * ----- ---- -------- -------------------------------------------------------
 * 1.00a jvb  11/10/06 First release
 * 2.00a wsy  08/08/08 Added extended VLAN and multicast features
 * </pre>
 *****************************************************************************/

/***************************** Include Files *********************************/

#include "xlltemac.h"

/************************** Constant Definitions *****************************/


/**************************** Type Definitions *******************************/


/***************** Macros (Inline Functions) Definitions *********************/


/************************** Function Prototypes ******************************/


/************************** Variable Definitions *****************************/


/*****************************************************************************/
/**
 * XLlTemac_MulticastAdd adds the Ethernet address, <i>AddressPtr</i> to the
 * TEMAC channel's multicast filter list, at list index <i>Entry</i>. The
 * address referenced by <i>AddressPtr</i> may be of any unicast, multicast, or
 * broadcast address form. The harware for the TEMAC channel can hold up to
 * XTE_MULTI_MAT_ENTRIES addresses in this filter list.<br><br>
 *
 * The device must be stopped to use this function.<br><br>
 *
 * Once an Ethernet address is programmed, the TEMAC channel will begin
 * receiving data sent from that address. The TEMAC hardware does not have a
 * control bit to disable multicast filtering. The only way to prevent the
 * TEMAC channel from receiving messages from an Ethernet address in the
 * Multicast Address Table (MAT) is to clear it with XLlTemac_MulticastClear().
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param AddressPtr is a pointer to the 6-byte Ethernet address to set. The
 *        previous address at the location <i>Entry</i> (if any) is overwritten
 *        with the value at <i>AddressPtr</i>.
 * @param Entry is the hardware storage location to program this address and
 *        must be between 0..XTE_MULTI_MAT_ENTRIES-1. 
 *
 * @return On successful completion, XLlTemac_MulticastAdd returns XST_SUCCESS.
 *         Otherwise, if the TEMAC channel is not stopped, XLlTemac_MulticastAdd
 *         returns XST_DEVICE_IS_STARTED.
 *
 * @note
 *
 * This routine accesses the hard TEMAC registers through a shared interface
 * between both channels of the TEMAC. Becuase of this, the application/OS code
 * must provide mutual exclusive access to this routine with any of the other
 * routines in this TEMAC driverr.
 *
 * This routine works only with XTE_MULTICAST_OPTION that supports up to
 * XTE_MULTI_MAT_ENTRIES. To use extended multicast feature
 * (XTE_EXT_MULTICAST_OPTION), please enable extended multicast in hardware
 * build and use XLlTemac_[Add|Clear|Get]ExtMulticastGroup() to manage
 * multicast addresses.
 *
 ******************************************************************************/
int XLlTemac_MulticastAdd(XLlTemac *InstancePtr, void *AddressPtr, int Entry)
{
	u32 Maw0Reg;
	u32 Maw1Reg;
	u8 *Aptr = (u8 *) AddressPtr;
	u32 Rdy;
	int MaxWait = 100;

	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_NONVOID(AddressPtr != NULL);
	XASSERT_NONVOID(Entry < XTE_MULTI_MAT_ENTRIES);
	/*
	 * If the mutual exclusion is enforced properly in the calling code, we
	 * should never get into the following case.
	 */
	XASSERT_NONVOID(XLlTemac_ReadReg(InstancePtr->Config.BaseAddress,
			XTE_RDY_OFFSET) & XTE_RDY_HARD_ACS_RDY_MASK);

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_MulticastAdd\n");

	/* The device must be stopped before clearing the multicast hash table */
	if (InstancePtr->IsStarted == XCOMPONENT_IS_STARTED) {
		xdbg_printf(XDBG_DEBUG_GENERAL,
			   "XLlTemac_MulticastAdd: returning DEVICE_IS_STARTED\n");

		return (XST_DEVICE_IS_STARTED);
	}

	/* Set MAC bits [31:0] */
	Maw0Reg = Aptr[0];
	Maw0Reg |= Aptr[1] << 8;
	Maw0Reg |= Aptr[2] << 16;
	Maw0Reg |= Aptr[3] << 24;

	/* Set MAC bits [47:32] */
	Maw1Reg = Aptr[4];
	Maw1Reg |= Aptr[5] << 8;

	/* Add in MAT address */
	Maw1Reg |= (Entry << XTE_MAW1_MATADDR_SHIFT_MASK);

	/* Program HW */
	xdbg_printf(XDBG_DEBUG_GENERAL, "Setting MAT entry: %d\n", Entry);
	XLlTemac_WriteReg(InstancePtr->Config.BaseAddress,
		XTE_LSW_OFFSET, Maw0Reg);
	XLlTemac_WriteReg(InstancePtr->Config.BaseAddress, XTE_CTL_OFFSET,
			XTE_MAW0_OFFSET | XTE_CTL_WEN_MASK);
	Rdy = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress, XTE_RDY_OFFSET);
	while (MaxWait && (!(Rdy & XTE_RDY_HARD_ACS_RDY_MASK))) {
		Rdy = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress,
			XTE_RDY_OFFSET);
		xdbg_stmnt(
			if (MaxWait == 100) {
				xdbg_printf(XDBG_DEBUG_GENERAL,
					    "RDY reg not initially ready\n");
			}
		);
		MaxWait--;
		xdbg_stmnt(
			if (MaxWait == 0) {
				xdbg_printf(XDBG_DEBUG_GENERAL,
					    "RDY reg never showed ready\n");
			}
		)
	}
	XLlTemac_WriteReg(InstancePtr->Config.BaseAddress, XTE_LSW_OFFSET,
			Maw1Reg);
	XLlTemac_WriteReg(InstancePtr->Config.BaseAddress, XTE_CTL_OFFSET,
			XTE_MAW1_OFFSET | XTE_CTL_WEN_MASK);
	Rdy = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress, XTE_RDY_OFFSET);
	while (MaxWait && (!(Rdy & XTE_RDY_HARD_ACS_RDY_MASK))) {
		Rdy = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress, XTE_RDY_OFFSET);
		xdbg_stmnt(
			if (MaxWait == 100) {
				xdbg_printf(XDBG_DEBUG_GENERAL,
					    "RDY reg not initially ready\n");
			}
		);
		MaxWait--;
		xdbg_stmnt(
			if (MaxWait == 0) {
				xdbg_printf(XDBG_DEBUG_GENERAL,
					    "RDY reg never showed ready\n");
			}
		)
	}
	
	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_MulticastAdd: returning SUCCESS\n");

	return (XST_SUCCESS);
}


/*****************************************************************************/
/**
 * XLlTemac_MulticastGet gets the Ethernet address stored at index <i>Entry</i>
 * in the TEMAC channel's multicast filter list.<br><br>
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param AddressPtr references the memory buffer to store the retrieved
 *        Ethernet address. This memory buffer must be at least 6 bytes in
 *        length.
 * @param Entry is the hardware storage location from which to retrieve the
 *        address and must be between 0..XTE_MULTI_MAT_ENTRIES-1. 
 *
 * @return N/A
 *
 * @note
 *
 * This routine accesses the hard TEMAC registers through a shared interface
 * between both channels of the TEMAC. Becuase of this, the application/OS code
 * must provide mutual exclusive access to this routine with any of the other
 * routines in this TEMAC driver.
 *
 * This routine works only with XTE_MULTICAST_OPTION that supports up to
 * XTE_MULTI_MAT_ENTRIES. To use extended multicast feature
 * (XTE_EXT_MULTICAST_OPTION), please enable extended multicast in hardware
 * build and use XLlTemac_[Add|Clear|Get]ExtMulticastGroup() to manage
 * multicast addresses.
 *
 ******************************************************************************/
void XLlTemac_MulticastGet(XLlTemac *InstancePtr, void *AddressPtr, int Entry)
{
	u32 Maw0Reg;
	u32 Maw1Reg;
	u8 *Aptr = (u8 *) AddressPtr;
	u32 Rdy;
	int MaxWait = 100;

	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_VOID(Entry < XTE_MULTI_MAT_ENTRIES);
	/*
	 * If the mutual exclusion is enforced properly in the calling code, we
	 * should never get into the following case.
	 */
	XASSERT_VOID(XLlTemac_ReadReg(InstancePtr->Config.BaseAddress,
			XTE_RDY_OFFSET) & XTE_RDY_HARD_ACS_RDY_MASK);

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_MulticastGet\n");

	/*
	 * Tell HW to provide address stored in given entry.
	 * In this case, the Access is a little weird, becuase we need to
	 * write the LSW register first, then initiate a write operation,
	 * even though it's a read operation.
	 */
	xdbg_printf(XDBG_DEBUG_GENERAL, "Getting MAT entry: %d\n", Entry);
	XLlTemac_WriteReg(InstancePtr->Config.BaseAddress, XTE_LSW_OFFSET,
			 Entry << XTE_MAW1_MATADDR_SHIFT_MASK | XTE_MAW1_RNW_MASK);
	XLlTemac_WriteReg(InstancePtr->Config.BaseAddress, XTE_CTL_OFFSET,
			 XTE_MAW1_OFFSET | XTE_CTL_WEN_MASK);
	Rdy = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress, XTE_RDY_OFFSET);
	while (MaxWait && (!(Rdy & XTE_RDY_HARD_ACS_RDY_MASK))) {
		Rdy = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress, XTE_RDY_OFFSET);
		xdbg_stmnt(
			if (MaxWait == 100) {
				xdbg_printf(XDBG_DEBUG_GENERAL,
					    "RDY reg not initially ready\n");
			}
		);
		MaxWait--;
		xdbg_stmnt(
			if (MaxWait == 0) {
				xdbg_printf(XDBG_DEBUG_GENERAL,
					    "RDY reg never showed ready\n");
			}
		)

	}
	Maw0Reg = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress, XTE_LSW_OFFSET);
	Maw1Reg = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress, XTE_MSW_OFFSET);
	
	/* Copy the address to the user buffer */
	Aptr[0] = (u8) Maw0Reg;
	Aptr[1] = (u8) (Maw0Reg >> 8);
	Aptr[2] = (u8) (Maw0Reg >> 16);
	Aptr[3] = (u8) (Maw0Reg >> 24);
	Aptr[4] = (u8) Maw1Reg;
	Aptr[5] = (u8) (Maw1Reg >> 8);
	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_MulticastGet: done\n");
}

/*****************************************************************************/
/**
 * XLlTemac_MulticastClear clears the Ethernet address stored at index <i>Entry</i>
 * in the TEMAC channel's multicast filter list.<br><br>
 *
 * The device must be stopped to use this function.<br><br>
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param Entry is the HW storage location used when this address was added.
 *        It must be between 0..XTE_MULTI_MAT_ENTRIES-1.
 * @param Entry is the hardware storage location to clear and must be between
 *        0..XTE_MULTI_MAT_ENTRIES-1. 
 *
 * @return On successful completion, XLlTemac_MulticastClear returns XST_SUCCESS.
 *         Otherwise, if the TEMAC channel is not stopped, XLlTemac_MulticastClear
 *         returns XST_DEVICE_IS_STARTED.
 *
 * @note
 *
 * This routine accesses the hard TEMAC registers through a shared interface
 * between both channels of the TEMAC. Becuase of this, the application/OS code
 * must provide mutual exclusive access to this routine with any of the other
 * routines in this TEMAC driverr.
 *
 * This routine works only with XTE_MULTICAST_OPTION that supports up to
 * XTE_MULTI_MAT_ENTRIES. To use extended multicast feature
 * (XTE_EXT_MULTICAST_OPTION), please enable extended multicast in hardware
 * build and use XLlTemac_[Add|Clear|Get]ExtMulticastGroup() to manage
 * multicast addresses.
 *
 ******************************************************************************/
int XLlTemac_MulticastClear(XLlTemac *InstancePtr, int Entry)
{
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_NONVOID(Entry < XTE_MULTI_MAT_ENTRIES);
	/*
	 * If the mutual exclusion is enforced properly in the calling code, we
	 * should never get into the following case.
	 */
	XASSERT_NONVOID(XLlTemac_ReadReg(InstancePtr->Config.BaseAddress,
			XTE_RDY_OFFSET) & XTE_RDY_HARD_ACS_RDY_MASK);
	
	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_MulticastClear\n");

	/* The device must be stopped before clearing the multicast hash table */
	if (InstancePtr->IsStarted == XCOMPONENT_IS_STARTED) {
		xdbg_printf(XDBG_DEBUG_GENERAL,
			   "XLlTemac_MulticastClear: returning DEVICE_IS_STARTED\n");
		return (XST_DEVICE_IS_STARTED);
	}

	/* Clear the entry by writing 0:0:0:0:0:0 to it */
	XLlTemac_WriteIndirectReg(InstancePtr->Config.BaseAddress,
			XTE_MAW0_OFFSET, 0);
	XLlTemac_WriteIndirectReg(InstancePtr->Config.BaseAddress,
			XTE_MAW1_OFFSET, Entry << XTE_MAW1_MATADDR_SHIFT_MASK);
	
	xdbg_printf(XDBG_DEBUG_GENERAL,
		    "XLlTemac_MulticastClear: returning SUCCESS\n");
	return (XST_SUCCESS);
}


/*****************************************************************************/
/**
 * XLlTemac_SetMacPauseAddress sets the MAC address used for pause frames to
 * <i>AddressPtr</i>. <i>AddressPtr</i> will be the address the TEMAC channel
 * will recognize as being for pause frames. Pause frames transmitted with
 * XLlTemac_SendPausePacket() will also use this address.
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param AddressPtr is a pointer to the 6-byte Ethernet address to set.
 *
 * @return On successful completion, XLlTemac_SetMacPauseAddress returns
 *         XST_SUCCESS. Otherwise, if the TEMAC channel is not stopped,
 *         XLlTemac_SetMacPauseAddress returns XST_DEVICE_IS_STARTED.
 *
 * @note
 *
 * This routine accesses the hard TEMAC registers through a shared interface
 * between both channels of the TEMAC. Becuase of this, the application/OS code
 * must provide mutual exclusive access to this routine with any of the other
 * routines in this TEMAC driverr.
 *
 ******************************************************************************/
int XLlTemac_SetMacPauseAddress(XLlTemac *InstancePtr, void *AddressPtr)
{
	u32 MacAddr;
	u8 *Aptr = (u8 *) AddressPtr;

	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	/*
	 * If the mutual exclusion is enforced properly in the calling code, we
	 * should never get into the following case.
	 */
	XASSERT_NONVOID(XLlTemac_ReadReg(InstancePtr->Config.BaseAddress,
			XTE_RDY_OFFSET) & XTE_RDY_HARD_ACS_RDY_MASK);
	
	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_SetMacPauseAddress\n");
	/* Be sure device has been stopped */
	if (InstancePtr->IsStarted == XCOMPONENT_IS_STARTED) {
		xdbg_printf(XDBG_DEBUG_GENERAL,
			   "XLlTemac_SetMacPauseAddress: returning DEVICE_IS_STARTED\n");
		return (XST_DEVICE_IS_STARTED);
	}

	/* Set the MAC bits [31:0] in ERXC0 */
	MacAddr = Aptr[0];
	MacAddr |= Aptr[1] << 8;
	MacAddr |= Aptr[2] << 16;
	MacAddr |= Aptr[3] << 24;
	XLlTemac_WriteIndirectReg(InstancePtr->Config.BaseAddress,
			XTE_RCW0_OFFSET, MacAddr);

	/* ERCW1 contains other info that must be preserved */
	MacAddr = XLlTemac_ReadIndirectReg(InstancePtr->Config.BaseAddress,
			XTE_RCW1_OFFSET);
	MacAddr &= ~XTE_RCW1_PAUSEADDR_MASK;

	/* Set MAC bits [47:32] */
	MacAddr |= Aptr[4];
	MacAddr |= Aptr[5] << 8;
	XLlTemac_WriteIndirectReg(InstancePtr->Config.BaseAddress,
			XTE_RCW1_OFFSET, MacAddr);

	xdbg_printf(XDBG_DEBUG_GENERAL,
		   "XLlTemac_SetMacPauseAddress: returning SUCCESS\n");

	return (XST_SUCCESS);
}


/*****************************************************************************/
/**
 * XLlTemac_GetMacPauseAddress gets the MAC address used for pause frames for the
 * TEMAC channel specified by <i>InstancePtr</i>. 
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param AddressPtr references the memory buffer to store the retrieved MAC
 *        address. This memory buffer must be at least 6 bytes in length.
 *
 * @return N/A
 *
 * @note
 *
 * This routine accesses the hard TEMAC registers through a shared interface
 * between both channels of the TEMAC. Becuase of this, the application/OS code
 * must provide mutual exclusive access to this routine with any of the other
 * routines in this TEMAC driverr.
 *
 ******************************************************************************/
void XLlTemac_GetMacPauseAddress(XLlTemac *InstancePtr, void *AddressPtr)
{
	u32 MacAddr;
	u8 *Aptr = (u8 *) AddressPtr;

	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	/*
	 * If the mutual exclusion is enforced properly in the calling code, we
	 * should never get into the following case.
	 */
	XASSERT_VOID(XLlTemac_ReadReg(InstancePtr->Config.BaseAddress,
			XTE_RDY_OFFSET) & XTE_RDY_HARD_ACS_RDY_MASK);

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_SetMacPauseAddress\n");
	
	/* Read MAC bits [31:0] in ERXC0 */
	MacAddr = XLlTemac_ReadIndirectReg(InstancePtr->Config.BaseAddress,
			XTE_RCW0_OFFSET);
	Aptr[0] = (u8) MacAddr;
	Aptr[1] = (u8) (MacAddr >> 8);
	Aptr[2] = (u8) (MacAddr >> 16);
	Aptr[3] = (u8) (MacAddr >> 24);

	/* Read MAC bits [47:32] in RCW1 */
	MacAddr = XLlTemac_ReadIndirectReg(InstancePtr->Config.BaseAddress,
			XTE_RCW1_OFFSET);
	Aptr[4] = (u8) MacAddr;
	Aptr[5] = (u8) (MacAddr >> 8);
	
	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_SetMacPauseAddress: done\n");
}

/*****************************************************************************/
/**
 * XLlTemac_SendPausePacket sends a pause packet with the value of
 * <i>PauseValue</i>.
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param PauseValue is the pause value in units of 512 bit times.
 *
 * @return On successful completion, XLlTemac_SendPausePacket returns
 *         XST_SUCCESS. Otherwise, if the TEMAC channel is not started,
 *         XLlTemac_SendPausePacket returns XST_DEVICE_IS_STOPPED.
 *
 * @note
 *
 * This routine accesses the hard TEMAC registers through a shared interface
 * between both channels of the TEMAC. Becuase of this, the application/OS code
 * must provide mutual exclusive access to this routine with any of the other
 * routines in this TEMAC driverr.
 *
 ******************************************************************************/
int XLlTemac_SendPausePacket(XLlTemac *InstancePtr, u16 PauseValue)
{
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	/*
	 * If the mutual exclusion is enforced properly in the calling code, we
	 * should never get into the following case.
	 */
	XASSERT_NONVOID(XLlTemac_ReadReg(InstancePtr->Config.BaseAddress,
			XTE_RDY_OFFSET) & XTE_RDY_HARD_ACS_RDY_MASK);

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_SetMacPauseAddress\n");

	/* Make sure device is ready for this operation */
	if (InstancePtr->IsStarted != XCOMPONENT_IS_STARTED) {
		xdbg_printf(XDBG_DEBUG_GENERAL,
			   "XLlTemac_SendPausePacket: returning DEVICE_IS_STOPPED\n");
		return (XST_DEVICE_IS_STOPPED);
	}

	/* Send flow control frame */
	XLlTemac_WriteReg(InstancePtr->Config.BaseAddress, XTE_TPF_OFFSET,
			     (u32) PauseValue & XTE_TPF_TPFV_MASK);
	
	xdbg_printf(XDBG_DEBUG_GENERAL,
		   "XLlTemac_SendPausePacket: returning SUCCESS\n");
	return (XST_SUCCESS);
}

/*****************************************************************************/
/**
 * XLlTemac_GetSgmiiStatus get the state of the link when using the SGMII media
 * interface.
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param SpeedPtr references the location to store the result, which is the
 *        autonegotiated link speed in units of Mbits/sec, either 0, 10, 100,
 *        or 1000.
 *
 * @return On successful completion, XLlTemac_GetSgmiiStatus returns XST_SUCCESS.
 *         Otherwise, if TEMAC channel is not using an SGMII interface,
 *         XLlTemac_GetSgmiiStatus returns XST_NO_FEATURE.
 *
 * @note
 *
 * This routine accesses the hard TEMAC registers through a shared interface
 * between both channels of the TEMAC. Becuase of this, the application/OS code
 * must provide mutual exclusive access to this routine with any of the other
 * routines in this TEMAC driverr.
 *
 ******************************************************************************/
int XLlTemac_GetSgmiiStatus(XLlTemac *InstancePtr, u16 *SpeedPtr)
{
	int PhyType;
	u32 EgmicReg;

	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	/*
	 * If the mutual exclusion is enforced properly in the calling code, we
	 * should never get into the following case.
	 */
	XASSERT_NONVOID(XLlTemac_ReadReg(InstancePtr->Config.BaseAddress,
			XTE_RDY_OFFSET) & XTE_RDY_HARD_ACS_RDY_MASK);

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_GetSgmiiStatus\n");
	/* Make sure PHY is SGMII */
	PhyType = XLlTemac_GetPhysicalInterface(InstancePtr);
	if (PhyType != XTE_PHY_TYPE_SGMII) {
		xdbg_printf(XDBG_DEBUG_GENERAL,
			   "XLlTemac_GetSgmiiStatus: returning NO_FEATURE\n");
		return (XST_NO_FEATURE);
	}

	/* Get the current contents of RGMII/SGMII config register */
	EgmicReg = XLlTemac_ReadIndirectReg(InstancePtr->Config.BaseAddress,
			XTE_PHYC_OFFSET);

	/* Extract speed */
	switch (EgmicReg & XTE_PHYC_SGMIILINKSPEED_MASK) {
	case XTE_PHYC_SGLINKSPD_10:
		*SpeedPtr = 10;
		break;

	case XTE_PHYC_SGLINKSPD_100:
		*SpeedPtr = 100;
		break;

	case XTE_PHYC_SGLINKSPD_1000:
		*SpeedPtr = 1000;
		break;

	default:
		*SpeedPtr = 0;
	}
		
	xdbg_printf(XDBG_DEBUG_GENERAL,
		   "XLlTemac_GetSgmiiStatus: returning SUCCESS\n");
	return (XST_SUCCESS);
}


/*****************************************************************************/
/**
 * XLlTemac_GetRgmiiStatus get the state of the link when using the RGMII media
 * interface.
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param SpeedPtr references the location to store the result, which is the
 *        autonegotiaged link speed in units of Mbits/sec, either 0, 10, 100,
 *        or 1000.
 * @param IsFullDuplexPtr references the value to set to indicate full duplex
 *        operation. XLlTemac_GetRgmiiStatus sets <i>IsFullDuplexPtr</i> to TRUE
 *        when the RGMII link is operating in full duplex mode. Otherwise,
 *        XLlTemac_GetRgmiiStatus sets <i>IsFullDuplexPtr</i> to FALSE.
 * @param IsLinkUpPtr references the value to set to indicate the link status.
 *        XLlTemac_GetRgmiiStatus sets <i>IsLinkUpPtr</i> to TRUE when the RGMII
 *        link up. Otherwise, XLlTemac_GetRgmiiStatus sets <i>IsLinkUpPtr</i> to
 *        FALSE.
 *
 * @return On successful completion, XLlTemac_GetRgmiiStatus returns XST_SUCCESS.
 *         Otherwise, if TEMAC channel is not using an RGMII interface,
 *         XLlTemac_GetRgmiiStatus returns XST_NO_FEATURE.
 *
 * @note
 *
 * This routine accesses the hard TEMAC registers through a shared interface
 * between both channels of the TEMAC. Becuase of this, the application/OS code
 * must provide mutual exclusive access to this routine with any of the other
 * routines in this TEMAC driverr.
 *
 ******************************************************************************/
int XLlTemac_GetRgmiiStatus(XLlTemac *InstancePtr, u16 *SpeedPtr,
			    int *IsFullDuplexPtr, int *IsLinkUpPtr)
{
	int PhyType;
	u32 EgmicReg;

	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	/*
	 * If the mutual exclusion is enforced properly in the calling code, we
	 * should never get into the following case.
	 */
	XASSERT_NONVOID(XLlTemac_ReadReg(InstancePtr->Config.BaseAddress,
			XTE_RDY_OFFSET) & XTE_RDY_HARD_ACS_RDY_MASK);
		
	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_GetRgmiiStatus\n");
	/* Make sure PHY is RGMII */
	PhyType = XLlTemac_GetPhysicalInterface(InstancePtr);
	if ((PhyType != XTE_PHY_TYPE_RGMII_1_3) &&
	    (PhyType != XTE_PHY_TYPE_RGMII_2_0)) {
		xdbg_printf(XDBG_DEBUG_GENERAL,
			   "XLlTemac_GetRgmiiStatus: returning NO_FEATURE\n");
		return (XST_NO_FEATURE);
	}

	/* Get the current contents of RGMII/SGMII config register */
	EgmicReg = XLlTemac_ReadIndirectReg(InstancePtr->Config.BaseAddress,
			XTE_PHYC_OFFSET);

	/* Extract speed */
	switch (EgmicReg & XTE_PHYC_RGMIILINKSPEED_MASK) {
	case XTE_PHYC_RGLINKSPD_10:
		*SpeedPtr = 10;
		break;

	case XTE_PHYC_RGLINKSPD_100:
		*SpeedPtr = 100;
		break;

	case XTE_PHYC_RGLINKSPD_1000:
		*SpeedPtr = 1000;
		break;

	default:
		*SpeedPtr = 0;
	}

	/* Extract duplex and link status */
	if (EgmicReg & XTE_PHYC_RGMIIHD_MASK) {
		*IsFullDuplexPtr = FALSE;
	} else {
		*IsFullDuplexPtr = TRUE;
	}

	if (EgmicReg & XTE_PHYC_RGMIILINK_MASK) {
		*IsLinkUpPtr = TRUE;
	} else {
		*IsLinkUpPtr = FALSE;
	}

	xdbg_printf(XDBG_DEBUG_GENERAL,
		   "XLlTemac_GetRgmiiStatus: returning SUCCESS\n");
	return (XST_SUCCESS);
}


/*****************************************************************************/
/**
 * XLlTemac_SetTpid sets the VLAN Tag Protocol Identifier(TPID).
 *
 * The device must be stopped to use this function.<br><br>
 *
 * Four values can be configured,
 * 0x8100, 0x9100, 0x9200, 0x88A8.
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param Tpid is a hex value to be added to the TPID table.
 * @param Entry is the hardware storage location to program this address and
 *        must be between 0..XTE_TPID_MAX_ENTRIES.
 *
 * @return On successful completion, returns XST_SUCCESS.
 *         Otherwise, returns
 *         1. XST_DEVICE_IS_STARTED, if the TEMAC channel is not stopped.
 *         2. XST_NO_FEATURE,        if the TEMAC does not enable or have the
 *                                   VLAN tag capability.
 *         3. XST_INVALID_PARAM,     if Tpid is not one of supported values.
 *
 * @note
 *
 *****************************************************************************/
int XLlTemac_SetTpid(XLlTemac *InstancePtr, u16 Tpid, u8 Entry)
{
	u32 RegTpid;
	u32 RegTpidOffset;
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_NONVOID(Entry < XTE_TPID_MAX_ENTRIES);

	/* The device must be stopped before modifiy VLAN TPID */
	if (InstancePtr->IsStarted == XCOMPONENT_IS_STARTED) {
		xdbg_printf(XDBG_DEBUG_GENERAL,
			   "XLlTemac_SetTpid: returning DEVICE_IS_STARTED\n");
		return (XST_DEVICE_IS_STARTED);
	}

        /* Check hw capability */
	if (!XLlTemac_IsExtFuncCap(InstancePtr)) {
		xdbg_printf(XDBG_DEBUG_GENERAL,
			   "XLlTemac_SetTpid: returning DEVICE_NO_FEATURE\n");
		return (XST_NO_FEATURE);
	}

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_SetTpid\n");

	/* verify TPID */
	switch (Tpid) {
		case 0x8100:
		case 0x88a8:
		case 0x9100:
		case 0x9200:
			break;
		default:
			return (XST_INVALID_PARAM);
	}

	/* Determine which register to operate on */
	if (Entry < 2) {
		RegTpidOffset = XTE_TPID0_OFFSET;
	} else {
		RegTpidOffset = XTE_TPID1_OFFSET;
	}

	RegTpid = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress,
				RegTpidOffset);

	/* Determine upper/lower 16 bits to operate on */
	if (Entry % 2) {
		/* Program HW */
		XLlTemac_WriteReg(InstancePtr->Config.BaseAddress,
			RegTpidOffset, (RegTpid & XTE_TPID_0_MASK) |
			(Tpid << 16));
	} else {
		/* Program HW */
		XLlTemac_WriteReg(InstancePtr->Config.BaseAddress,
			RegTpidOffset, (RegTpid & XTE_TPID_1_MASK) |
			Tpid);
	}
	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_SetTpid: returning SUCCESS\n");
	return (XST_SUCCESS);
}

/*****************************************************************************/
/**
 * XLlTemac_ClearTpid clears the VLAN Tag Protocol Identifier(TPID).
 *
 * The device must be stopped to use this function.<br><br>
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param Entry is the hardware storage location to program this address and
 *        must be between 0..XTE_TPID_MAX_ENTRIES.
 *
 * @return On successful completion, returns XST_SUCCESS.
 *         Otherwise, returns
 *         1. XST_DEVICE_IS_STARTED, if the TEMAC channel is not stopped.
 *         2. XST_NO_FEATURE,        if the TEMAC does not enable or have the
 *                                   VLAN tag capability.
 *
 * @note
 *
 *****************************************************************************/
int XLlTemac_ClearTpid(XLlTemac *InstancePtr, u8 Entry)
{
	u32 RegTpid;
	u32 RegTpidOffset;
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_NONVOID(Entry < XTE_TPID_MAX_ENTRIES);

	/* The device must be stopped before modifiy VLAN TPID */
	if (InstancePtr->IsStarted == XCOMPONENT_IS_STARTED) {
		xdbg_printf(XDBG_DEBUG_GENERAL,
			   "XLlTemac_ClearTpid: returning DEVICE_IS_STARTED\n");
		return (XST_DEVICE_IS_STARTED);
	}

        /* Check hw capability */
	if (!XLlTemac_IsExtFuncCap(InstancePtr))
	{
		xdbg_printf(XDBG_DEBUG_GENERAL,
			   "XLlTemac_ClearTpid: returning DEVICE_NO_FEATURE\n");
		return (XST_NO_FEATURE);
	}

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_ClearExtTpid\n");

	/* Determine which register to operate on */
	if (Entry < 2) {
		RegTpidOffset = XTE_TPID0_OFFSET;
	} else {
		RegTpidOffset = XTE_TPID1_OFFSET;
	}

	RegTpid = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress,
				RegTpidOffset);

	/* Determine upper/lower 16 bits to operate on */
	if (Entry % 2) {
		/* Program HW */
		XLlTemac_WriteReg(InstancePtr->Config.BaseAddress,
			RegTpidOffset, (RegTpid & XTE_TPID_1_MASK));
	} else {
		/* Program HW */
		XLlTemac_WriteReg(InstancePtr->Config.BaseAddress,
			RegTpidOffset, (RegTpid & XTE_TPID_0_MASK));
	}
	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_ClearTpid: returning SUCCESS\n");
	return (XST_SUCCESS);
}


/*****************************************************************************/
/**
 * XLlTemac_GetTpid gets the VLAN Tag Protocol Identifier value (TPID).
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param TpidPtr references the location to store the result.
 * @param Entry is the hardware storage location to program this address and
 *        must be between 0..XTE_TPID_MAX_ENTRIES.
 *
 * @return N/A.
 *
 * @note
 *
 *****************************************************************************/
void XLlTemac_GetTpid(XLlTemac *InstancePtr, u16 *TpidPtr, u8 Entry)
{
	u32 RegTpid;
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_VOID(Entry < XTE_TPID_MAX_ENTRIES);

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_GetTpid\n");

	if (Entry < 2) {
		RegTpid = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress,
					XTE_TPID0_OFFSET);
	} else {
		RegTpid = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress,
					XTE_TPID1_OFFSET);
	}

	if (Entry % 2) {
		*TpidPtr = (RegTpid >> 16);
	} else {
		*TpidPtr = (RegTpid & XTE_TPID_0_MASK);
	}
	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_GetTpid: done\n");
}


/*****************************************************************************/
/**
 * XLlTemac_SetVTagMode configures the VLAN tagging mode.
 *
 * The device must be stopped to use this function.<br><br>
 *
 * Four modes can be configured,
 * XTE_VTAG_NONE    - no tagging.
 * XTE_VTAG_ALL     - tag all frames.
 * XTE_VTAG_EXISTED - tag already tagged frames.
 * XTE_VTAG_SELECT  - tag selected already tagged frames based on VID value.
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param Mode is the VLAN tag mode. Value must be between b'00-b'11. 
 * @param Dir must be either XTE_TX or XTE_RX.
 *
 * @return On successful completion, returns XST_SUCCESS.
 *         Otherwise, returns
 *         1. XST_DEVICE_IS_STARTED, if the TEMAC channel is not stopped.
 *         2. XST_NO_FEATURE,        if the TEMAC does not enable or have the
 *                                   TX VLAN tag capability.
 *         3. XST_INVALID_PARAM,     if Mode is not one of supported modes.
 *
 * @note
 *
 * The fourth mode requires a method for specifying which tagged frames should
 * receive an additional VLAN tag. The VLAN translation table 'tag enabled' is
 * referenced. That configuration is handled in XLlTemac_SetVidTable().
 *
 * Mode value shifting is handled in this function. No shifting is required to
 * call this function.
 * 
 *****************************************************************************/
int XLlTemac_SetVTagMode(XLlTemac *InstancePtr, u32 Mode, int Dir)
{
	u32 RegRaf;

	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_NONVOID((Dir == XTE_TX) || (Dir == XTE_RX));

	/* The device must be stopped before modifiy TX VLAN Tag mode */
	if (InstancePtr->IsStarted == XCOMPONENT_IS_STARTED) {
		xdbg_printf(XDBG_DEBUG_GENERAL,
			   "XLlTemac_SetVTagMode: returning DEVICE_IS_STARTED\n");
		return (XST_DEVICE_IS_STARTED);
	}

        /* Check hw capability */
	if (!XLlTemac_IsExtFuncCap(InstancePtr)) {
		xdbg_printf(XDBG_DEBUG_GENERAL,
			   "XLlTemac_SetVTagMode: returning DEVICE_NO_FEATURE\n");
		return (XST_NO_FEATURE);
	}

	/* Mode has to be one of the supported values */
	switch (Mode) {
		case XTE_VTAG_NONE:
		case XTE_VTAG_ALL:
		case XTE_VTAG_EXISTED:
		case XTE_VTAG_SELECT:
			break;
		default:
			return (XST_INVALID_PARAM);
	}

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_SetVTagMode\n");

	/* Program HW */
	RegRaf = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress, XTE_RAF_OFFSET);
	/* transmit direction */
	if (XTE_TX == Dir) {
		XLlTemac_WriteReg(InstancePtr->Config.BaseAddress,
			XTE_RAF_OFFSET, ((RegRaf & ~XTE_RAF_TXVTAGMODE_MASK) |
			(Mode << XTE_RAF_TXVTAGMODE_SHIFT)));
	} else { /* receive direction */
		XLlTemac_WriteReg(InstancePtr->Config.BaseAddress,
			XTE_RAF_OFFSET, ((RegRaf & ~XTE_RAF_RXVTAGMODE_MASK) |
			(Mode << XTE_RAF_RXVTAGMODE_SHIFT)));
	}

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_SetVTagMode: returning SUCCESS\n");

	return (XST_SUCCESS);
}

/*****************************************************************************/
/**
 * XLlTemac_GetVTagMode gets VLAN tagging mode.
 *
 * The device must be stopped to use this function.<br><br>
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param ModePtr references the location to store the result. It is the VLAN
 *        tag mode. Value is between b'00-b'11. 
 * @param Dir must be either XTE_TX or XTE_RX.
 *
 * @return N/A.
 *
 * @note
 *
 * Mode value shifting is handled in this function. No shifting is required to
 * call this function.
 * 
 *****************************************************************************/
void XLlTemac_GetVTagMode(XLlTemac *InstancePtr, u8 *ModePtr, int Dir)
{
	u32 RegRaf;

	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_VOID((Dir == XTE_TX) || (Dir == XTE_RX));

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_GetVTagMode\n");

	/* access HW configuration */
	RegRaf = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress, XTE_RAF_OFFSET);
	/* transmit direction */
	if (XTE_TX == Dir) {
		*ModePtr = (RegRaf & XTE_RAF_TXVTAGMODE_MASK) >> XTE_RAF_TXVTAGMODE_SHIFT;
	} else { /* receive direction */
		*ModePtr = (RegRaf & XTE_RAF_RXVTAGMODE_MASK) >> XTE_RAF_RXVTAGMODE_SHIFT;
	}

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_GetVTagMode: done\n");

}


/*****************************************************************************/
/**
 * XLlTemac_SetVStripMode configures the VLAN strip mode.
 *
 * The device must be stopped to use this function.<br><br>
 *
 * Three modes can be configured,
 * XTE_VSTRP_NONE   - no stripping.
 * XTE_VSTRP_ALL    - strip one tag from all frames.
 * XTE_VSTRP_SELECT - strip one tag from selected already tagged frames based
 *                    on VID value.
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param Mode is the VLAN strip mode. Value must be b'00, b'01, or b'11. 
 * @param Dir must be either XTE_TX or XTE_RX.
 *
 * @return On successful completion, returns XST_SUCCESS.
 *         Otherwise, returns
 *         1. XST_DEVICE_IS_STARTED, if the TEMAC channel is not stopped.
 *         2. XST_NO_FEATURE,        if the TEMAC does not enable or have the
 *                                   TX VLAN strip capability.
 *         3. XST_INVALID_PARAM,     if Mode is not one of supported modes.
 *
 * @note
 *
 * The third mode requires a method for specifying which tagged frames should
 * be stripped. The VLAN translation table 'stripped enabled' is
 * referenced. That configuration is handled in XLlTemac_SetVidTable().
 *
 * Mode value shifting is handled in this function. No shifting is required to
 * call this function.
 * 
 *****************************************************************************/
int XLlTemac_SetVStripMode(XLlTemac *InstancePtr, u32 Mode, int Dir)
{
	u32 RegRaf;

	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_NONVOID((Dir == XTE_TX) || (Dir == XTE_RX));

	/* The device must be stopped before modifiy TX VLAN Tag mode */
	if (InstancePtr->IsStarted == XCOMPONENT_IS_STARTED) {
		xdbg_printf(XDBG_DEBUG_GENERAL,
			   "XLlTemac_SetVStripMode: returning DEVICE_IS_STARTED\n");
		return (XST_DEVICE_IS_STARTED);
	}

        /* Check hw capability */
	if (!XLlTemac_IsExtFuncCap(InstancePtr)) {
		xdbg_printf(XDBG_DEBUG_GENERAL,
			   "XLlTemac_SetVStripMode: returning DEVICE_NO_FEATURE\n");
		return (XST_NO_FEATURE);
	}

	/* Mode has to be one of the supported values */
	switch (Mode) {
		case XTE_VSTRP_NONE:
		case XTE_VSTRP_ALL:
		case XTE_VSTRP_SELECT:
			break;
		default:
			return (XST_INVALID_PARAM);
	}

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_SetStripMode\n");

	/* Program HW */
	RegRaf = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress, XTE_RAF_OFFSET);
	/* transmit direction */
	if (XTE_TX == Dir) {
		XLlTemac_WriteReg(InstancePtr->Config.BaseAddress,
			XTE_RAF_OFFSET, ((RegRaf & ~XTE_RAF_TXVSTRPMODE_MASK) |
			(Mode << XTE_RAF_TXVSTRPMODE_SHIFT)));
	} else { /* receive direction */
		XLlTemac_WriteReg(InstancePtr->Config.BaseAddress,
			XTE_RAF_OFFSET, ((RegRaf & ~XTE_RAF_RXVSTRPMODE_MASK) |
			(Mode << XTE_RAF_RXVSTRPMODE_SHIFT)));
	}

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_SetVStripMode: returning SUCCESS\n");

	return (XST_SUCCESS);
}


/*****************************************************************************/
/**
 * XLlTemac_GetVStripMode configures the VLAN stripping mode.
 *
 * The device must be stopped to use this function.<br><br>
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param ModePtr references the location to store the result. It is the VLAN
 *        strip mode. Value is b'00, b'01 or b'11. 
 * @param Dir must be either XTE_TX or XTE_RX.
 *
 * @return N/A.
 *
 * @note
 *
 * Three modes are supported,
 * XTE_VSTRP_NONE   - no stripping.
 * XTE_VSTRP_ALL    - strip one tag from all frames.
 * XTE_VSTRP_SELECT - strip one tag from selected already tagged frames based
 *                    on VID value.
 *
 * The third mode(XTE_VSTRP_SELECT) requires a method for specifying which
 * tagged frames should be stripped. The VLAN translation table
 * 'stripped enabled' is referenced. That configuration is handled in
 * XLlTemac_SetVidTable().
 *
 * Mode value shifting is handled in this function. No shifting is required to
 * call this function.
 * 
 *****************************************************************************/
void XLlTemac_GetVStripMode(XLlTemac *InstancePtr, u8 *ModePtr, int Dir)
{
	u32 RegRaf;

	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_VOID((Dir == XTE_TX) || (Dir == XTE_RX));

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_GetVStripMode\n");

	/* access HW configuration */
	RegRaf = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress, XTE_RAF_OFFSET);
	/* transmit direction */
	if (XTE_TX == Dir) {
		*ModePtr = (RegRaf & XTE_RAF_TXVSTRPMODE_MASK) >> XTE_RAF_TXVSTRPMODE_SHIFT;
	} else { /* receive direction */
		*ModePtr = (RegRaf & XTE_RAF_RXVSTRPMODE_MASK) >> XTE_RAF_RXVSTRPMODE_SHIFT;
	}

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_GetVStripMode: done\n");
}


/*****************************************************************************/
/**
 * XLlTemac_SetVTagValue configures the VLAN tagging value.
 *
 * The device must be stopped to use this function.<br><br>
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param VTagValue is the VLAN tag value to be configured. A 32bit value.
 *        TPID, one of the following 16 bit values,
 *              0x8100, 0x88a8, 0x9100, 0x9200. 
 *        Priority, 3  bits
 *        CFI,      1  bit
 *        VID,      12 bits
 * @param Dir must be either XTE_TX or XTE_RX.
 * 
 * @return On successful completion, returns XST_SUCCESS.
 *         Otherwise, returns
 *         1. XST_DEVICE_IS_STARTED, if the TEMAC channel is not stopped.
 *         2. XST_NO_FEATURE,        if the TEMAC does not enable/have
 *                                   TX VLAN tag capability.
 *         3. XST_INVALID_PARAM,     if the TPID is not one the four supported
 *                                   values.
 *
 * @note
 *
 * The four supported TPID values are 0x8100, 0x88a8, 0x9100, 0x9200.
 * XLlTemac_SetVTagValue performs verification on TPID only.
 *
 * Ethernet VLAN frames' VLAN type/length(2B) and tag control information(2B).
 * Bit layout : bbbb bbbb bbbb bbbb bbb b bbbb bbbb bbbb
 *              \                 /  |  | \ VID (12b)  /
 *               \               /   |  CFI bit (1b)
 *                   TPID (16b)      priority bit (3b)
 *
 *****************************************************************************/
int XLlTemac_SetVTagValue(XLlTemac *InstancePtr, u32 VTagValue, int Dir)
{
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_NONVOID((Dir == XTE_TX) || (Dir == XTE_RX));

	/* The device must be stopped before modifiy TX VLAN Tag value */
	if (InstancePtr->IsStarted == XCOMPONENT_IS_STARTED) {
		xdbg_printf(XDBG_DEBUG_GENERAL,
			   "XLlTemac_SetVTagValue: returning DEVICE_IS_STARTED\n");
		return (XST_DEVICE_IS_STARTED);
	}

        /* Check hw capability */
	if (!XLlTemac_IsExtFuncCap(InstancePtr)) {
		xdbg_printf(XDBG_DEBUG_GENERAL,
			   "XLlTemac_SetVTagValue: returning DEVICE_NO_FEATURE\n");
		return (XST_NO_FEATURE);
	}

	/* verify TPID */
	switch (VTagValue >> 16) {
		case 0x8100:
		case 0x88a8:
		case 0x9100:
		case 0x9200:
			break;
		default:
			return (XST_INVALID_PARAM);
	}

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_SetVTagValue\n");

	/* Program HW */
	/* transmit direction */
	if (XTE_TX == Dir) {
		XLlTemac_WriteReg(InstancePtr->Config.BaseAddress,
			XTE_TTAG_OFFSET, VTagValue);
	} else { /* receive direction */
		XLlTemac_WriteReg(InstancePtr->Config.BaseAddress,
			XTE_RTAG_OFFSET, VTagValue);
	}
	
	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_SetVTagValue: returning SUCCESS\n");

	return (XST_SUCCESS);
}


/*****************************************************************************/
/**
 * XLlTemac_GetVTagValue gets the configured VLAN tagging value.
 *
 * The device must be stopped to use this function.<br><br>
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param VTagValuePtr references the location to store the result. Format is,
 *        TPID, one of the following 16 bit values,
 *              0x8100, 0x88a8, 0x9100, 0x9200. 
 *        Priority, 3  bits
 *        CFI,      1  bit
 *        VID,      12 bits
 * @param Dir must be either XTE_TX or XTE_RX.
 * 
 * @return N/A.
 *
 * @note
 *
 * Ethernet VLAN frames' VLAN type/length(2B) and tag control information(2B).
 * Bit layout : bbbb bbbb bbbb bbbb bbb b bbbb bbbb bbbb
 *              \                 /  |  | \ VID (12b)  /
 *               \               /   |  CFI bit (1b)
 *                   TPID (16b)      priority bit (3b)
 *
 *****************************************************************************/
void XLlTemac_GetVTagValue(XLlTemac *InstancePtr, u32 *VTagValuePtr, int Dir)
{
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_VOID((Dir == XTE_TX) || (Dir == XTE_RX));

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_GetVTagValue\n");

	/* transmit direction */
	if (XTE_TX == Dir) {
		*VTagValuePtr = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress,
				XTE_TTAG_OFFSET);
	}
	else { /* receive direction */
		*VTagValuePtr = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress,
				XTE_RTAG_OFFSET);
	}

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_GetVTagValue: done\n");
}


/*****************************************************************************/
/**
 * XLlTemac_SetVidTable sets VID table includes new VLAN ID, strip
 * and tag enable bits.
 *
 * The device must be stopped to use this function.<br><br>
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param Entry is the hardware storage location/index to program updated
 *        VID value, strip, or tag value.
 *        must be between 0..0xFFF. 
 * @param Vid is updated/translated Vid value to be programmed.
 * @param Strip is strip enable indication for Vid.
 * @param Tag is tag enable indication for Vid.
 * @param Dir must be either XTE_TX or XTE_RX.
 *
 * @return On successful completion, returns XST_SUCCESS.
 *         Otherwise, returns
 *         1. XST_DEVICE_IS_STARTED, if the TEMAC channel is not stopped.
 *         2. XST_NO_FEATURE,        if the TEMAC does not enable/have
 *                                   extended functionalities.
 *
 * @note
 *
 * In BRAM, hardware requires table to be 'indexed' with Entry and must be
 * 0x000..0xFFF.
 *
 * Bits layout is bbbb bbbb bbbb b b
 *                VLAN ID (12b), | |
 *                               | VLAN double tag enable bit
 *                               VLAN strip enable bit
 *
 * To disable translation indexed by Entry, Set Vid = Entry.
 *
 *****************************************************************************/
int XLlTemac_SetVidTable(XLlTemac *InstancePtr, u32 Entry, u32 Vid, u8 Strip, u8 Tag, int Dir)
{
	u32 Reg;

	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_NONVOID(Entry <= 0xFFF);
	XASSERT_NONVOID((Dir == XTE_TX) || (Dir == XTE_RX));
	XASSERT_NONVOID(Vid <= 0xFFF);
	XASSERT_NONVOID(Strip <= 1);
	XASSERT_NONVOID(Tag <= 1);

	/* The device must be stopped before modifiy TX VLAN Tag value */
	if (InstancePtr->IsStarted == XCOMPONENT_IS_STARTED) {
		xdbg_printf(XDBG_DEBUG_GENERAL,
			   "XLlTemac_SetVidTable: returning DEVICE_IS_STARTED\n");
		return (XST_DEVICE_IS_STARTED);
	}

        /* Check hw capability */
	if (!XLlTemac_IsExtFuncCap(InstancePtr)) {
		xdbg_printf(XDBG_DEBUG_GENERAL,
			   "XLlTemac_SetVidTable: returning DEVICE_NO_FEATURE\n");
		return (XST_NO_FEATURE);
	}

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_SetVidTable\n");

	/* Program HW */
	Reg = (Vid << 2) | (Strip << 1) | Tag;
	/* transmit direction */
	if (XTE_TX == Dir) {
		XLlTemac_WriteReg(InstancePtr->Config.BaseAddress,
			XTE_TX_VLAN_DATA_OFFSET + (Entry << 2), Reg);
	} else { /* receive direction */
		XLlTemac_WriteReg(InstancePtr->Config.BaseAddress,
			XTE_RX_VLAN_DATA_OFFSET + (Entry << 2), Reg);
	}
	
	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_SetVidTable: returning SUCCESS\n");
	return (XST_SUCCESS);
}

/*****************************************************************************/
/**
 * XLlTemac_GetVidTable gets VID table content includes new VLAN ID, strip
 * and tag enable bits.
 *
 * The device must be stopped to use this function.<br><br>
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param Entry is the hardware storage location/index to program updated
 *        VID value, strip, or tag value.
 *        must be between 0..0xFFF. 
 * @param VidPtr references the location to store the result. It has Vid value
 *        indexed by Entry.
 * @param StripPtr references the location to store the result. It is strip
 *        enable bit value indexed by Entry.
 * @param TagPtr references the location to store the result. It is tag enable
 *        bit value indexed by Entry.
 * @param Dir must be either XTE_TX or XTE_RX.
 *
 * @return N/A.
 *
 * @note
 *
 * In BRAM, hardware requires table to be 'indexed' with Entry and
 * must be 0x000..0xFFF.
 *
 * Bits layout is bbbb bbbb bbbb b b
 *                VLAN ID (12b), | |
 *                               | VLAN double tag enable bit
 *                               VLAN strip enable bit
 *
 *****************************************************************************/
void XLlTemac_GetVidTable(XLlTemac *InstancePtr, u32 Entry, u32 *VidPtr, u8 *StripPtr, u8 *TagPtr, int Dir)
{
	u32 Reg;

	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_VOID(Entry <= 0xFFF);
	XASSERT_VOID((Dir == XTE_TX) || (Dir == XTE_RX));

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_GetVidTable\n");

	/* transmit direction */
	if (XTE_TX == Dir) {
		Reg = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress,
			XTE_TX_VLAN_DATA_OFFSET + (Entry << 2));
	} else { /* receive direction */
		Reg = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress,
			XTE_RX_VLAN_DATA_OFFSET + (Entry << 2));
	}

	*VidPtr   = (Reg >> 2);
	*StripPtr = (Reg >> 1) & 0x01;
	*TagPtr   = Reg & 0x01;
	
	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_GetVidTable: done\n");
}


/*****************************************************************************/
/**
 * XLlTemac_AddExtMulticastGroup adds an entry to the multicast Ethernet
 * address table in BRAM. The new entry, represents a group of MAC addresses
 * based on the contents of AddressPtr. AddressPtr is one member of the MAC
 * address set in the newly added entry.
 *
 * The device must be stopped to use this function.<br><br>
 *
 * Once an Ethernet address is programmed, the TEMAC channel will begin
 * receiving data sent from that address. The TEMAC hardware does not have a
 * control bit to disable multicast filtering. The only way to prevent the
 * TEMAC channel from receiving messages from an Ethernet address in the
 * BRAM table is to clear it with XLlTemac_ClearExtMulticastGroup().
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param AddressPtr is a pointer to the 6-byte Ethernet address to add.
 *
 * @return On successful completion, returns XST_SUCCESS.
 *         Otherwise, returns
 *         XST_DEVICE_IS_STARTED, if the TEMAC channel is not stopped
 *         XST_INVALID_PARAM,     if input MAC address is not between 
 *                                01:00:5E:00:00:00 and 01:00:5E:7F:FF:FF
 *                                per RFC1112.
 *
 * @note
 *
 * This routine consider all 2**23 possible multicast ethernet addresses to be
 * 8Mx1 bit or 1M bytes memory area. All defined multicast addresses are from
 * 01.00.5E.00.00.00 to 01.00.5E.7F.FF.FF
 * The most significant 25 bit out of 48 bit are static, so they will not be
 * part of calculation.
 *
 * In BRAM table, hardware requires to 'index' with bit 22-8, 15 bits in
 * total. The least significant byte/8 bits are considered a group.
 *
 * This API operates at a group (256 MAC addresses) for hardware to do the
 * first layer address filtering. It is user's responsibility to provision
 * this table appropriately.
 *
 *****************************************************************************/
int XLlTemac_AddExtMulticastGroup(XLlTemac *InstancePtr, void *AddressPtr)
{
	u8 *Aptr = (u8 *) AddressPtr;
	u32 Loc;

	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_NONVOID(AddressPtr != NULL);

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_AddExtMulticastGroup\n");

	/* The device must be stopped before setting the multicast table
	 * in BRAM.
	 */
	if (InstancePtr->IsStarted == XCOMPONENT_IS_STARTED) {
		xdbg_printf(XDBG_DEBUG_GENERAL,
			"XLlTemac_AddExtMulticastGroup: returning DEVICE_IS_STARTED\n");

		return (XST_DEVICE_IS_STARTED);
	}

        /* Check hw capability */
	if (!XLlTemac_IsExtFuncCap(InstancePtr) ||
	    !XLlTemac_IsExtMcastEnable(InstancePtr)) {
		xdbg_printf(XDBG_DEBUG_GENERAL,
			"XLlTemac_AddExtMulticastGroup: returning DEVICE_NO_FEATURE\n");
		return (XST_NO_FEATURE);
	}

	/* verify if address is a good/valid multicast address, between
         * 01:00:5E:00:00:00 to 01:00:5E:7F:FF:FF per RFC1112.
	 * This address is referenced to be index to BRAM table.
	 */
	if ((0x01 != Aptr[0]) || (0x00 != Aptr[1]) || (0x5e != Aptr[2]) ||
	    (0x0 != (Aptr[3] & 0x80)))
		return (XST_INVALID_PARAM);

	/* program hardware table in BRAM, index : bit 22-8. Bit 23 is 0,
         * when passed the if statement above. 
         * note: if the index/bits changed, need to revisit calculation.
	 */
	Loc  = Aptr[3];
	Loc  = Loc << 8;
	Loc |= Aptr[4];

	/* word aligned BRAM address access */
	Loc  = Loc << 2;

	XLlTemac_WriteReg(InstancePtr->Config.BaseAddress,
		XTE_MCAST_BRAM_OFFSET + Loc, 0x01);

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_AddExtMulticastGroup: returning SUCCESS\n");

	return (XST_SUCCESS);
}


/*****************************************************************************/
/**
 * XLlTemac_ClearExtMulticastGroup clears input multicast Ethernet address
 * group from BRAM table.
 *
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param AddressPtr is a pointer to the 6-byte Ethernet address to clear.
 *
 * @return On successful completion, returns XST_SUCCESS.
 *         Otherwise, returns
 *         XST_DEVICE_IS_STARTED, if the TEMAC channel is not stopped
 *         XST_INVALID_PARAM,     if input MAC address is not between 
 *                                01:00:5E:00:00:00 and 01:00:5E:7F:FF:FF        *                                per RFC1112.
 *
 * @note
 *
 * Please reference XLlTemac_AddExtMulticastGroup for multicast address index
 * and bit value calculation.
 *
 * In BRAM table, hardware requires to 'index' with bit 22-8, 15 bits in
 * total. The least significant byte/8 bits are considered a group.
 *
 * There is a scenario might introduce issues.
 * When multicast tables are programed initially to accept
 * 01:00:5E:12:34:56 and 01:00:5E:12:34:78 but later decided to clear
 * 01:00:5E:12:34:78. Without validating all possible combinations at the
 * indexed entry, multicast BRAM table might be misconfigured and drop
 * frames.
 *
 * When clearing a multicast address table entry, note that a whole group of
 * mac addresses will no longer be accepted - this because an entry in the
 * table represents multiple(256) mac addresses.
 *
 * The device must be stopped to use this function.<br><br>
 * This API operates at a group (256 MAC addresses) level for hardware to
 * perform the first layer address filtering. It is user's responsibility to
 * provision this table appropriately.
 *
 *****************************************************************************/
int XLlTemac_ClearExtMulticastGroup(XLlTemac *InstancePtr, void *AddressPtr)
{
	u8 *Aptr = (u8 *) AddressPtr;
	u32 Loc;

	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_NONVOID(AddressPtr != NULL);

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_ClearExtMulticastGroup\n");

	/* The device must be stopped before clearing the multicast table
	 * in BRAM.
	 */
	if (InstancePtr->IsStarted == XCOMPONENT_IS_STARTED) {
		xdbg_printf(XDBG_DEBUG_GENERAL,
			   "XLlTemac_ClearExtMulticastGroup: returning DEVICE_IS_STARTED\n");

		return (XST_DEVICE_IS_STARTED);
	}

        /* Check hw capability */
	if (!XLlTemac_IsExtFuncCap(InstancePtr) ||
	    !XLlTemac_IsExtMcastEnable(InstancePtr)) {
		xdbg_printf(XDBG_DEBUG_GENERAL,
			   "XLlTemac_ClearExtMulticastGroup: returning DEVICE_NO_FEATURE\n");
		return (XST_NO_FEATURE);
	}

	/* verify if address is a good/valid multicast address, between
         * 01:00:5E:00:00:00 to 01:00:5E:7F:FF:FF per RFC1112.
	 * This address is referenced to be index to BRAM table.
	 */
	if ((0x01 != Aptr[0]) || (0x00 != Aptr[1]) || (0x5e != Aptr[2]) ||
	    (0x0 != (Aptr[3] & 0x80)))
		return (XST_INVALID_PARAM);

	Loc  = Aptr[3];
	Loc  = Loc << 8;
	Loc |= Aptr[4];

	/* word aligned BRAM address access */
	Loc  = Loc << 2;

	XLlTemac_WriteReg(InstancePtr->Config.BaseAddress,
		XTE_MCAST_BRAM_OFFSET + Loc, 0x00);

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_ClearExtMulticastGroup: returning SUCCESS\n");

	return (XST_SUCCESS);
}


/*****************************************************************************/
/**
 * XLlTemac_GetExtMulticastGroup inquery the Ethernet addresses group stored
 * in BRAM table.
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 * @param AddressPtr references the memory buffer to store the retrieved
 *        Ethernet address. This memory buffer must be at least 6 bytes in
 *        length.
 *
 * @return TRUE,  a provisioned acceptable multicast MAC address.
 *         FALSE, an unacceptable multicast MAC address.
 *
 * @note
 *
 * In BRAM table, hardware requires to 'index' with bit 22-8, 15 bits in
 * total. The least significant byte/8 bits are considered a group.
 * This API operates at a group (256 MAC addresses) level.
 *
 *****************************************************************************/
int XLlTemac_GetExtMulticastGroup(XLlTemac *InstancePtr, void *AddressPtr)
{
	u8 *Aptr = (u8 *) AddressPtr;
	u32 Loc;
	u8 Bit;

	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_NONVOID(AddressPtr != NULL);

	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_GetExtMulticastGroup\n");

	/* verify if address is a good/valid multicast address, between
         * 01:00:5E:00:00:00 to 01:00:5E:7F:FF:FF per RFC1112.
	 * This address is referenced to be index to BRAM table.
	 */
	if ((0x01 != Aptr[0]) || (0x00 != Aptr[1]) || (0x5e != Aptr[2]) ||
	    (0x0 != (Aptr[3] & 0x80)))
		return (FALSE);

	Loc  = Aptr[3];
	Loc  = Loc << 8;
	Loc |= Aptr[4];
	/* word aligned BRAM address access */

	Loc  = Loc << 2;

	Bit = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress,
		XTE_MCAST_BRAM_OFFSET + Loc);

	if (Bit) {
		return (TRUE);
	} else {
		return (FALSE);
	}
	xdbg_printf(XDBG_DEBUG_GENERAL, "XLlTemac_GetExtMulticastGroup: done\n");
}


/*****************************************************************************/
/**
 * XLlTemac_DumpExtMulticastGroup dump ALL provisioned acceptable multicast MAC
 * in the TEMAC channel's multicast BRAM table.
 *
 * @param InstancePtr references the TEMAC channel on which to operate.
 *
 * @return N/A.
 *
 * @note
 *
 * In BRAM table, hardware requires to 'index' with bit 22-8, 15 bits in
 * total. The least significant byte/8 bits are considered a set.
 *
 * This API operates at a set (256 MAC addresses) level.
 *
 *****************************************************************************/
void XLlTemac_DumpExtMulticastGroup(XLlTemac *InstancePtr)
{
	u32 Loc, i;
	u8  Bit;
	char MacAddr[6];

	XASSERT_VOID(InstancePtr != NULL);

	/*
	 * pre-populated these bytes, we know and guarantee these if 
         * provisioned through the XLlTemac_AddExtMulticastGroup().
	 */
	MacAddr[0] = 0x01;
	MacAddr[1] = 0x00;
	MacAddr[2] = 0x5E;

	for (i = 0; i < (1 << 15); i++)
	{
		MacAddr[3] = i << 16;
		MacAddr[4] = i << 8;
		MacAddr[5] = 0;
		
		Loc  = MacAddr[3];
		Loc |= MacAddr[4] << 8;

		/* word aligned BRAM address access */
		Loc  = Loc << 2;

		Bit = XLlTemac_ReadReg(InstancePtr->Config.BaseAddress,
			XTE_MCAST_BRAM_OFFSET + Loc);
		if (Bit)
		{
			xdbg_printf(XDBG_DEBUG_GENERAL,
			"%x:%x:%x:%x:%x:%x\n", MacAddr[5], MacAddr[4],
			MacAddr[3], MacAddr[2], MacAddr[1], MacAddr[0]);
		}
	}
}

