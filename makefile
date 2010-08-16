#Makefile that will build a specified version of avr-gcc,g++ with all it's helper files
#Copyright (C) 2010 Rick Anderson
#This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
#
#This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#
# Assumptions: curl is installed
# You are running Mac OS X with Xcode ver=? Installed


#setup defaults values
MKDIR = mkdir -p
BUILD_DIR = build
LIB_DIR = /usr/local/test/avr1
INSTALL_DIR = /usr/local/test/avr1


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

all:

setup:
	$(MKDIR) $(CURDIR)/src
	$(MKDIR) $(CURDIR)/build

getsources: setup
	$(shell cd $(CURDIR)/src; \
	curl -O ftp://ftp.gmplib.org/pub/gmp-$(GMP_VER)/gmp-$(GMP_VER).tar.bz2 ;\
	curl -O http://www.mpfr.org/mpfr-$(MPFR_VER)/mpfr-$(MPFR_VER).tar.gz ;\
	curl -O http://www.multiprecision.org/mpc/download/mpc-$(MPC_VER).tar.gz ; \
	curl -O ftp://ftp.gnu.org/gnu/binutils/binutils-$(BINUTILS_VER).tar.gz ; \
	curl -O ftp://ftp.gnu.org/gnu/gcc/gcc-$(AVRGCC_VER)/gcc-g++-$(AVRGCC_VER).tar.gz ; \
	curl -O ftp://ftp.gnu.org/gnu/gcc/gcc-$(AVRGCC_VER)/gcc-core-$(AVRGCC_VER).tar.gz ; \
	curl -O http://nongnu.askapache.com/avr-libc/avr-libc-$(AVRLIBC_VER).tar.bz2 ; \
	curl -O http://ftp.gnu.org/gnu/gdb/gdb-$(GDB_VER).tar.gz ; \
	curl -O http://mirror.its.uidaho.edu/pub/savannah/avrdude/avrdude-$(AVRDUDE_VER).tar.gz ;)
	
unpacksources:
	bunzip2 -kf $(CURDIR)/src/gmp-$(GMP_VER).tar.bz2 
	tar xvf $(CURDIR)/src/gmp-$(GMP_VER).tar  -C $(CURDIR)/build
	tar xvzf $(CURDIR)/src/mpc-$(MPC_VER).tar.gz  -C $(CURDIR)/build
	tar xvzf $(CURDIR)/src/mpfr-$(MPFR_VER).tar.gz  -C $(CURDIR)/build
	tar xvzf $(CURDIR)/src/binutils-$(BINUTILS_VER).tar.gz  -C $(CURDIR)/build
	tar xvzf $(CURDIR)/src/gcc-core-$(AVRGCC_VER).tar.gz  -C $(CURDIR)/build
	tar xvzf $(CURDIR)/src/gcc-g++-$(AVRGCC_VER).tar.gz  -C $(CURDIR)/build
	bunzip2 -kf $(CURDIR)/src/avr-libc-$(AVRLIBC_VER).tar.bz2  
	tar xvf $(CURDIR)/src/avr-libc-$(AVRLIBC_VER).tar  -C $(CURDIR)/build
	tar xvzf $(CURDIR)/src/avrdude-$(AVRDUDE_VER).tar.gz -C $(CURDIR)/build
	tar xvzf $(CURDIR)/src/gdb-$(GDB_VER).tar.gz -C $(CURDIR)/build
	
#build-prereqs: build-gmp build-mpfr build-mpc
#Because these prereq libraries are built as part of the gcc source, that don't need to be installed after being built
build-gmp:
	$(MKDIR) build/gmp-$(GMP_VER)/tmp
	cd build/gmp-$(GMP_VER)/tmp &&  ../configure --prefix=$(LIB_DIR)
	cd build/gmp-$(GMP_VER)/tmp && $(MAKE)
	cd build/gmp-$(GMP_VER)/tmp && $(MAKE) check

install-gmp:
	cd build/gmp-$(GMP_VER)/tmp && sudo $(MAKE) install

build-mpfr:
	#mpfr
	$(MKDIR) build/mpfr-$(MPFR_VER)/tmp
	cd  build/mpfr-$(MPFR_VER)/tmp && ../configure --prefix=$(LIB_DIR) --with-gmp-build=../../gmp-$(GMP_VER)/tmp
	cd  build/mpfr-$(MPFR_VER)/tmp && $(MAKE)
	cd  build/mpfr-$(MPFR_VER)/tmp && $(MAKE)  check

install-mpfr:
	cd  build/mpfr-$(MPFR_VER)/tmp && sudo $(MAKE) install

build-mpc:	
	#mpc
	$(MKDIR) build/mpc-$(MPC_VER)/tmp 
	cd build/mpc-$(MPC_VER)/tmp  && ../configure --prefix=$(INSTALL_DIR) --with-gmp=$(LIB_DIR) --with-mpfr=$(LIB_DIR)
	cd build/mpc-$(MPC_VER)/tmp  && $(MAKE)

install-mpc:
	cd build/mpc-$(MPC_VER)/tm  && sudo $(MAKE)  install;
	
build-linkprereqs:
	#Build the libraries then symlink to tmp build directories for easier compilationg, because reference the libraries is not working yet. 
	$(shell cd build/gcc-$(AVRGCC_VER);\
	ln -s ../mpfr-$(MPFR_VER) mpfr;\
	ln -s ../mpc-$(MPC_VER)/ mpc;\
	ln -s ../gmp-$(GMP_VER)/ gmp;\)

build-avrgccgxx:
	$(MKDIR) build/gcc-$(AVRGCC_VER)/tmp
	#my custom library location is not working 
	#../configure --target=avr --prefix=/usr/local/test/avr --disable-nsl --enable-languages=c,c++ --disable-libssp -with-gmp=/usr/local/test/lib/lib --with-mpfr=/usr/local/test/lib/lib  --with-mpc=/usr/local/test/lib/lib 
	cd build/gcc-$(AVRGCC_VER)/tmp && ../configure --target=avr --prefix=$(INSTALL_DIR) --disable-nsl --enable-languages=c,c++ --disable-libssp
	cd build/gcc-$(AVRGCC_VER)/tmp && $(MAKE)

install-avrgccgxx:
	cd build/gcc-$(AVRGCC_VER)/tmp && sudo $(MAKE) install
	$(INSTALL_DIR)/bin/avr-gcc --version
	
build-avrlibc:
	$(MKDIR) build/avr-libc-$(AVRLIBC_VER)/tmp
	cd build/avr-libc-$(AVRLIBC_VER)/tmp && ../configure --build=`../config.guess` --host=avr --prefix=$(INSTALL_DIR)
	cd build/avr-libc-$(AVRLIBC_VER)/tmp && $(MAKE)

install-avrlibc:
	cd build/avr-libc-$(AVRLIBC_VER)/tmp && sudo $(MAKE) install

build-avrdude:
	$(MKDIR) build/avrdude-$(AVRDUDE_VER)/tmp
	cd  build/avrdude-$(AVRDUDE_VER)/tmp && ../configure --prefix=$(INSTALL_DIR)
	cd  build/avrdude-$(AVRDUDE_VER)/tmp && $(MAKE)

install-avrdude:
	cd  build/avrdude-$(AVRDUDE_VER)/tmp && sudo $(MAKE) install

build-avrgdb:
	$(MKDIR) build/gdb-$(GDB_VER)/tmp
	cd build/gdb-$(GDB_VER)/tmp  && ../configure --target=avr --prefix=$(INSTALL_DIR) --disable-werror
	cd build/gdb-$(GDB_VER)/tmp  && $(MAKE)

install-avrgdb:
	cd build/gdb-$(GDB_VER)/tmp  && sudo $(MAKE) install


clean:
	rm -rf src
	rm -rf build

distclean:


