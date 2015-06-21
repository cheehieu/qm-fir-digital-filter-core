##############################################################################
## Filename:          /proj/users/hmnguyen/EDKproject/qmfir_2new/drivers/qmfir_v1_00_a/data/qmfir_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Fri Feb 25 13:30:20 2011 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "qmfir" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" "C_MEM0_BASEADDR" "C_MEM0_HIGHADDR" "C_MEM1_BASEADDR" "C_MEM1_HIGHADDR" "C_MEM2_BASEADDR" "C_MEM2_HIGHADDR" 
}
