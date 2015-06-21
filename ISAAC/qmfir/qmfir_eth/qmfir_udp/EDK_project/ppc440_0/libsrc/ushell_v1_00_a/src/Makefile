###############################################################################
#
# uShell - A minimalist shell for the Xilinx Virtex PPC-class 
# uProcessors
#
# ORIGINAL AUTHOR: Thomas Werne
# COMPANY: Jet Propulsion Laboratory
# VERSION: 1.00
#
# File: Makefile
# $Author: werne $
# $Date: 2010-02-08 12:07:53 -0800 (Mon, 08 Feb 2010) $
# $Rev: 58 $
#
# Used to build a uShell project
#
# Copyright 2009, 2010, by the California Institute of Technology.  ALL
# RIGHTS RESERVED.  United States Government Sponsorship acknowledged.
# Any commercial use must be negotiated with the Office of Technology
# Transfer at the California Institute of Technology.
#
# This software may be subject to U.S. export control laws and
# regulations.  by accepting this document, the user agrees to comply
# with all U.S. export laws and regulations.  User has the
# responsibility to obtain export licenses, or other export authority
# as may be required before exporting such information to foreign
# countries or providing access to foreign persons.
###############################################################################

# Includes the processor type
include Makefile.deps

COMPILER=
ARCHIVER=
CP:=cp
COMPILER_FLAGS=
EXTRA_COMPILER_FLAGS=
LIBRARY := libushell.a

RELEASEDIR:=../../../lib
INCLUDE_FILES:=*.h
INCLUDE_DIR:=../../../include
INCLUDES:=-I${INCLUDE_DIR}

SRCS := ushell.c main.c ushell_sem.c function_map.c memory_map.c device_map.c ${PROC_SRC}
OBJS := ${SRCS:.c=.o}

PHONY:= print_info

libs: print_info ${OBJS}
	${ARCHIVER} -r ${RELEASEDIR}/${LIBRARY} ${OBJS}
	make clean

include: 
	${CP} -rf ${INCLUDE_FILES} ${INCLUDE_DIR}

clean:
	rm -rf $(OBJS)

.c.o:
	$(COMPILER) $(COMPILER_FLAGS) $(EXTRA_COMPILER_FLAGS) $(INCLUDES) -c $< -o $@

print_info:
	@echo "Compiling uShell"
