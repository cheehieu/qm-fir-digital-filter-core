***********************************************************************************************
*  This README.TXT describes the filesystem hierarchy for the QM-FIR Digital Filter Core(s)   *
*  Last updated by Hieu Nguyen on May 6, 2011					    	      *
***********************************************************************************************

Working QM-FIR implementations:
	- Ethernet, UDP with Matlab GUI
	- UART, 240MHz filter with Python GUI

Future QM-FIR implementations:
	- Ethernet, TCP transfer protocol
	- Ethernet, raw packets with no SW overhead
	- UART, split spectrum filter for DESDynI


-----------------------------------------------------------------------------------------
EXAMPLE FILESYSTEM DIRECTORIES STRUCTURE:

								/EDK_project
		/qmfir_eth	>>	/qmfir_udp	>>	/matlab_gui
								/documentation

/qmfir	>>	  						

								/ISE_project
		/qmfir_uart	>>	/qmfir_240MHz	>>	/python_gui
								/documentation


-----------------------------------------------------------------------------------------
DIRECTORY CONTENT INFO:

qmfir/qmfir_eth/qmfir_udp/EDK_project 		contains EDK project files (.MHS, .MSS, HDL, pcores, sw_src, etc.)
qmfir/qmfir_eth/qmfir_udp/matlab_gui 		contains Matlab GUI, Matlab files for synthetic data generation
qmfir/qmfir_eth/qmfir_udp/documentation		contains all relevant documents, core information LIST THE FILES AND A DESCRIPTION OF EACH
qmfir/qmfir_eth/qmfir_raw			Placeholder to contain project for raw ethernet packets to reduce the software overhead
qmfir/qmfir_eth/qmfir_tcp			Placeholder to contain the faster TCP implementation

qmfir/qmfir_uart/qmfir_240MHz/ISE_project 	contains ISE project files (.V, .XCO, .BIT, etc.)
qmfir/qmfir_uart/qmfir_240MHz/python_gui 	contains Python GUI, Matlab files for synthetic data generation
qmfir/qmfir_uart/qmfir_240MHz/documentation	contains all relevant documents, core information
qmfir/qmfir_uart/qmfir_split_spectrum		Placeholder to contain the split spectrum project for DESDynI


DOCUMENTATION INFO:
Documentation for qmfir_udp:
- "DemoSpec.pdf"			provides information for setting up the UDP demonstration using the Matlab GUI
- "firdecim.pdf"			includes information on the polyphase decimation filter
- "isaac_demo_newton_08_07_24_2.ppt"	old presentation for ISAAC demo plan
- "isaac_internal_demo_Newton.ppt"	old presentation for ISAAC demo plan
- "isaac_smap_briefing_v2.ppt"		old presentation for SMAP briefing
- "newton_ip.pdf"			diagram and description of internal registers
- "Newton_QMFIR_Spec.pdf"		includes information on the overall QMFIR architecture and FPGA modules description
- "qmfir_diagram.xls"			a diagram illustrating the low-level data flow
- "qmfir_eth_from_scratch.doc"		provides a general step-by-step guide to creating the project from scratch and running the demo
- "qmfir_eth_spec.doc"			a comprehensive technical document for this project

Documentation for qmfir_240MHz:
- "bram_diagram.xls"			a diagram of the BRAM regions where filter input/output is stored
- "iReg.xls"				includes information on the registers for iReg
- "isaac_smap_virtexII_proposal.ppt"	old presentation for virtex-II proposal
- "KNguyen_SMAP_Demo_090407.pdf"	a presentation on the SMAP 240MHz digital filter demo from 2009
- "QM_240.ppt"				some slides on clock speed and firdecim architecture
- "qmfir_uart_from_scratch.doc"		provdes a general step-by-step guide to creating the project from scratch and running the demo
- "qmfir_HDL.xls"			a diagram showing the HDL structure of the ISE project
- "qmfir_uart_spec.doc"			a comprehensive technical document for this project


