# Put your custom version and overide default directories as needed
#
#

#setup defaults values
#BUILD_DIR ?= build
#OUT_DIR ?= out
#LIB_DIR ?= $(CURDIR)/$(OUT_DIR)
#INSTALL_DIR ?= $(CURDIR)/$(OUT_DIR)


#Setup versions of the required software
#gcc-core
AVRGCC_VER = 4.5.1
#gcc-g++, should normally be the same as AVRGCC_VER
#AVRGXX_VER = 4.5.1
AVRLIBC_VER = 1.7.0
BINUTILS_VER = 2.20.1
AVRDUDE_VER = 5.4
GDB_VER = 7.1
GMP_VER = 4.3.2
MPC_VER = 0.8.2
MPFR_VER = 2.3.1
LIBTOOL_VER = 2.2.10
LIBTOOL_VER = 2.2.10
AVARICE_VER = 2.10
LIBUSB_VER = 0.1.12
SIMULAVR = 0.1.2.6

#configure options
#../configure --target=avr --prefix=/usr/local/test/avr --disable-nsl --enable-languages=c,c++ --disable-libssp -with-gmp=/usr/local/test/lib/lib --with-mpfr=/usr/local/test/lib/lib  --with-mpc=/usr/local/test/lib/lib -isysroot
/Developer/SDKs/MacOSX10.5.sdk -mmacosx-version-min=10.5 -no_compact_linkedit

AVRGCC_CONF = --disable-nsl --enable-languages=c,c++ --disable-libssp --disable-dependency-tracking --disable-werror --with-dwarf2 --enable-thread=single 

include ./Makefile.master

localpatches:
	echo "local patches"
