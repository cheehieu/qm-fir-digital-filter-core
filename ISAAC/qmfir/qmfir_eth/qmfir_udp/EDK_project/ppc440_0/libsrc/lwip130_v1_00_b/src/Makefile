include Makefile.lwip
include Makefile.adapter

COMPILER=
ARCHIVER=
CP=cp
COMPILER_FLAGS=
EXTRA_COMPILER_FLAGS=

RELEASEDIR=../../../lib
INCLUDEDIR=../../../include
INCLUDES=-I${INCLUDEDIR} -I$(LWIP_DIR)/src/include -I$(LWIP_DIR)/src/include/ipv4 -I$(PORT)/include

EXPORT_INCLUDE_FILES =  $(LWIP_DIR)/src/include/ipv4/lwip \
			$(LWIP_DIR)/src/include/lwip \
			$(LWIP_DIR)/src/include/netif \
			contrib/ports/xilinx/include/netif \
			contrib/ports/xilinx/include/arch \
			contrib/ports/xilinx/include/lwipopts.h

libs: liblwip4.a
	cp liblwip4.a $(RELEASEDIR)

include: 
	@for i in $(EXPORT_INCLUDE_FILES); do \
	echo ${CP} -r $$i ${INCLUDEDIR}; \
	${CP} -r $$i ${INCLUDEDIR}; \
	done

clean:
	echo "clean target for lwip"

liblwip4.a: obj_dir print_msg_lwip_base $(LWIP_OBJS) print_msg_lwip_adapter $(ADAPTER_OBJS)
	@echo "Creating archive $@"
	$(ARCHIVER) rc $@ obj/*.o

obj_dir:
	mkdir -p obj

print_msg_lwip_base:
	@echo "Compiling lwIP with $(GCC_COMPILER)"

print_msg_lwip_adapter:
	@echo "Compiling lwIP adapter for Xilinx MAC:"

.c.o:
	@echo "Compiling $<"
	$(GCC_COMPILER) $(COMPILER_FLAGS) $(EXTRA_COMPILER_FLAGS) $(INCLUDES) -c $< -o obj/$(@F)
