COMPILER=
ARCHIVER=
CP=cp
COMPILER_FLAGS=
EXTRA_COMPILER_FLAGS=
LIB=libxil.a

RELEASEDIR=../../../lib
INCLUDEDIR=../../../include
INCLUDES=-I./. -I${INCLUDEDIR}

INCLUDEFILES=xlltemac.h xlltemac_hw.h xdebug.h
LIBSOURCES=*.c
OUTS = *.o 


libs:
	echo "Compiling lltemac"
	$(COMPILER) $(COMPILER_FLAGS) $(EXTRA_COMPILER_FLAGS) $(INCLUDES) $(LIBSOURCES)
	$(ARCHIVER) -r ${RELEASEDIR}/${LIB} ${OUTS} 
	make clean

include: 
	 ${CP} ${INCLUDEFILES} ${INCLUDEDIR} 

clean:
	rm -rf ${OUTS}

