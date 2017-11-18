# Author: Peter Dobler (@Juppit)
#
# based on esp-alt-sdk from Dmitry Kireev (@kireevco)
#
# Credits to Max Fillipov (@jcmvbkbc) for major xtensa-toolchain (gcc-extensa, newlib-xtensa)
# Credits to Paul Sokolovsky (@pfalcon) for esp-open-sdk
# Credits to Fabien Poussin (@fpoussin) for xtensa-lx106-elf build script
#
# Last edit: 18.11.2017

#*******************************************
#************** configuration **************
#*******************************************

PLATFORM := $(shell uname -s)
ifneq (,$(findstring 64, $(shell uname -m)))
    ARCH = 64
else
    ARCH = 32
endif

BUILD := $(PLATFORM)
ifeq ($(OS),Windows_NT)
    ifneq (,$(findstring MINGW32,$(PLATFORM)))
        BUILD := MinGW32
    endif
    ifneq (,$(findstring MSYS,$(PLATFORM)))
        BUILD := MSYS
    endif
    ifneq (,$(findstring CYGWIN,$(PLATFORM)))
        BUILD := Cygwin
    endif
else
    ifeq ($(PLATFORM),Darwin)
        BUILD := MacOS
    endif
    ifeq ($(PLATFORM),Linux)
        ifneq (,$(findstring ARM,$(PLATFORM)))
            BUILD := LinuxARM
        else
            BUILD := Linux
        endif
    endif
endif

# various hosts are not supported
#HOST   = x86_64-apple-darwin14.0.0
TARGET = xtensa-lx106-elf

# create tar-file for distribution
DISTRIB  := $(BUILD)-$(ARCH)-$(TARGET)
#DISTRIB  := ""

STANDALONE = y
# debug = y gives a lot of output
DEBUG = n
# strip:	reduces "du" by approx. 40-50 percent
STRIP = n
# compress:	reduces "du" by approx. 40-50 percent
COMPRESS = n
# build lwip-lib
LWIP = n
# build debugger
GDB = n

# GNU C Library 2.26?
GLIBC = n
# ftp://gcc.gnu.org/pub/gcc/infrastructure/ 
# 0.18?
ISL = n
# 0.18.1
CLOOG = n

WITH_NLX  = --with-newlib
GMP_OPT   = --disable-shared --enable-static
MPFR_OPT  = --disable-shared --enable-static
MPC_OPT   = --disable-shared --enable-static
BUILD_OPT = --enable-werror=no --enable-multilib --disable-nls --disable-shared --disable-threads \
            --with-gnu-as --with-gnu-ld
BIN_OPT   = $(BUILD_OPT) --with-gcc
GCC_OPT   = $(BUILD_OPT) --with-gmp=$(MLIB_DIR)/gmp --with-mpfr=$(MLIB_DIR)/mpfr --with-mpc=$(MLIB_DIR)/mpc $(WITH_NLX) \
            --disable-libssp --disable-__cxa_atexit
GC1_OPT   = --enable-languages=c $(GCC_OPT) --without-headers
GC2_OPT   = --enable-languages=c,c++ $(GCC_OPT)
NLX_OPT   = --enable-multilib --with-gnu-as --with-gnu-ld --disable-nls
NLX_OPT   = --enable-multilib --with-gnu-as --with-gnu-ld --disable-nls \
            --with-newlib --enable-target-optspace --disable-option-checking \
            --enable-newlib-nano-formatted-io --enable-newlib-reent-small \
            --disable-newlib-io-c99-formats --disable-newlib-supplied-syscalls \
            --program-transform-name="s&^&$(TARGET)-&" --with-target-subdir=$(TARGET)
GDB_OPT   = $(BUILD_OPT)

# xtensa-lx106-elf-gcc means the executable e.g. xtensa-lx106-elf-gcc.exe
XCC  = $(TARGET)-cc
XGCC = $(TARGET)-gcc
XAR  = $(TARGET)-ar
XOCP = $(TARGET)-objcopy

# listed versions are tested
# the last versions will be used
SDK_VERSION = 1.3.0-rtos
SDK_VERSION = 1.4.0-rtos
SDK_VERSION = 1.5.0
SDK_VERSION = 1.5.1
SDK_VERSION = 1.5.2
SDK_VERSION = 1.5.3
SDK_VERSION = 1.5.4
SDK_VERSION = 2.0.0
SDK_VERSION = 2.1.0
SDK_VERSION = 2.1.x

GMP_VERSION = 6.0.0a
GMP_VERSION = 6.1.0
GMP_VERSION = 6.1.1
GMP_VERSION = 6.1.2

MPFR_VERSION = 3.1.1
MPFR_VERSION = 3.1.2
MPFR_VERSION = 3.1.3
MPFR_VERSION = 3.1.4
MPFR_VERSION = 3.1.5
MPFR_VERSION = 3.1.6

MPC_VERSION  = 1.0.1
MPC_VERSION  = 1.0.2
MPC_VERSION  = 1.0.3

GCC_VERSION  = 4.8.2
GCC_VERSION  = 4.9.2
GCC_VERSION  = 5.1.0
GCC_VERSION  = 5.2.0
GCC_VERSION  = 5.3.0
GCC_VERSION  = 6.4.0
#GCC_VERSION = 7.1.0
GCC_VERSION  = 7.2.0

GDB_VERSION  = 7.5.1
GDB_VERSION  = 7.10
GDB_VERSION  = 7.11
GDB_VERSION  = 7.12
GDB_VERSION  = 7.12.1
GDB_VERSION  = 8.0.1

BIN_VERSION  = 2.26
BIN_VERSION  = 2.27
BIN_VERSION  = 2.28
BIN_VERSION  = 2.29

HAL_VERSION  = lx106-hal

LWIP_VERSION = esp-open-lwip

#*******************************************
#************* define variables ************
#*******************************************
SAFEPATH = $(PATH)

SDK_SRC_DIR = sdk
SDK_VER = $(SDK_SRC_DIR)_v$(SDK_VERSION)

TOP = $(PWD)
TOP_SDK = $(TOP)/$(SDK_SRC_DIR)
SDK_DIR = $(TOP_SDK)/$(SDK_VER)

TOOLCHAIN = $(TOP)/$(TARGET)

MLIB_DIR = $(TOP)/math_libs
SOURCE_DIR = $(TOP)/src
TAR_DIR = $(TOP)/tarballs
PATCHES_DIR = $(SOURCE_DIR)/patches
BUILD_DIR = build-$(BUILD)
DIST_DIR = $(TOP)/dist

GMP_TAR  = gmp-$(GMP_VERSION).tar.bz2
MPFR_TAR = mpfr-$(MPFR_VERSION).tar.bz2
MPC_TAR  = mpc-$(MPC_VERSION).tar.gz
GCC_TAR  = gcc-$(GCC_VERSION).tar.gz
GDB_TAR  = gdb-$(GDB_VERSION).tar.gz
BIN_TAR  = binutils-$(BIN_VERSION).tar.gz

NLX = newlib
# newlib version
NLX_VERSION  = xtensa
#NLX_VERSION  = 2.5.0
#NLX_VERSION  = esp32
# get from NLX_URL
# find as NLX_TAR (zip/tar.gz) in tarballs
# untar to NLX_TAR_DIR directory
NLX_URL  = ftp://sourceware.org/pub/newlib/newlib-$(NLX_VERSION).tar.gz
NLX_TAR  = $(NLX)-$(NLX_VERSION).tar.gz
NLX_TAR_DIR = $(SOURCE_DIR)/$(NLX)-$(NLX_VERSION)

ifneq (,$(findstring xtensa,$(NLX_VERSION)))
    NLX_URL  = https://github.com/jcmvbkbc/newlib-xtensa/archive/xtensa.zip
    NLX_TAR  = newlib-xtensa-xtensa.zip
    NLX_TAR_DIR = $(SOURCE_DIR)/$(NLX)-xtensa-xtensa
endif

ifneq (,$(findstring esp32,$(NLX_VERSION)))
    NLX_URL  = https://github.com/espressif/newlib-esp32/archive/master.zip
    NLX_TAR  = newlib-esp32.zip
    NLX_TAR_DIR = $(SOURCE_DIR)/$(NLX)-esp32-master
endif

NLX_DIR = $(SOURCE_DIR)/$(NLX)-$(NLX_VERSION)
BUILD_NLX_DIR = $(NLX_DIR)/$(BUILD_DIR)

HAL = libhal
HAL = lx106-hal

HAL_TAR  = master.zip
HAL_URL  = https://github.com/tommie/lx106-hal/archive

HAL_GIT = https://github.com/tommie/lx106-hal.git
HAL_BRANCH = master
HAL_ZIP = https://github.com/tommie/lx106-hal/archive/master.zip

HAL_DIR = $(SOURCE_DIR)/$(HAL)
BUILD_HAL_DIR = $(HAL_DIR)/$(BUILD_DIR)

BIN = binutils
BIN_DIR = $(SOURCE_DIR)/$(BIN)-$(BIN_VERSION)
BUILD_BIN_DIR = $(BIN_DIR)/$(BUILD_DIR)

LWIP_TAR = https://github.com/pfalcon/esp-open-lwip/archive/sdk-1.5.0-experimental.zip

GMP = gmp-$(GMP_VERSION)
# make it easy for gmp-6.0.0a
ifeq ($(GMP_VERSION),6.0.0a)
    GMP = $(SOURCE_DIR)/gmp-6.0.0
endif

GMP_DIR = $(SOURCE_DIR)/$(GMP)
BUILD_GMP_DIR = $(GMP_DIR)/$(BUILD_DIR)

MPFR = mpfr-$(MPFR_VERSION)
MPFR_DIR = $(SOURCE_DIR)/$(MPFR)
BUILD_MPFR_DIR = $(MPFR_DIR)/$(BUILD_DIR)

MPC = mpc-$(MPC_VERSION)
MPC_DIR = $(SOURCE_DIR)/$(MPC)
BUILD_MPC_DIR = $(MPC_DIR)/$(BUILD_DIR)

GDB = gdb-$(GDB_VERSION)
GDB_DIR = $(SOURCE_DIR)/$(GDB)
BUILD_GDB_DIR = $(GGB_DIR)/$(BUILD_DIR)

GCC = gcc-$(GCC_VERSION)
GCC_DIR = $(SOURCE_DIR)/$(GCC)
BUILD_GCC_DIR = $(GCC_DIR)/$(BUILD_DIR)

LWIP_DIR = $(SOURCE_DIR)/$(LWIP_VERSION)
BUILD_LWIP_DIR = $(LWIP_DIR)/$(BUILD_DIR)

OUTPUT_DATE = date +"%Y-%m-%d %X"; sleep 2

DEV_NULL = "> /dev/null 2>&1"

ifeq ($(DEBUG),y)
	WGET     := wget -c
	PATCH    := patch -b -N
	SILENT   :=
	MKDIR    := mkdir -p
	RMDIR    := -rm -R
	MOVE     := -mv
	UNTAR    := bsdtar -vxf
	MAKE_OPT := make
	CONF_OPT := configure
	INST_OPT := install
	ARCH_OPT := dv
else
	WGET     := @wget -c
	PATCH    := patch -s -b -N 
	SILENT   := > /dev/null
	MKDIR    := @mkdir -p
	RMDIR    := -@rm -R
	MOVE     := -@mv
	UNTAR    := @bsdtar -xf
	#MAKE_OPT := make -s -j2
	MAKE_OPT := make V=1 -s
	CONF_OPT := configure -q
	INST_OPT := install -s
	ARCH_OPT := d
endif

# Clear Travis CI cache between build steps to speed up the complete process
RM_BUILD_DIR := $(RMDIR) --interactive=never
#RM_BUILD_DIR :=

# if we take it from github
# use "Load" instead of "Extract"
# GCC_BRANCH_4.8.2 = call0-4.8.2
# GCC_BRANCH_4.9.2 = call0-4.9.2
# GCC_BRANCH_5.1.0 = lx106-5.1

# GCC_BRANCH = $(GCC_BRANCH_$(GCC_VERSION))
# GCC_GIT = https://github.com/jcmvbkbc/gcc-xtensa.git
# GCC_ZIP = https://github.com/jcmvbkbc/gcc-xtensa/archive/$(GCC_BRANCH).zip

GNU_URL = https://ftp.gnu.org/gnu

# from SDK_URL get archive with SDK_ZIP inside and extract to SDK_VER
SDK_URL_1.4.0-rtos = "https://github.com/espressif/ESP8266_RTOS_SDK/archive/dba89f9aba75f9858157618e8bb4927d2da76296.zip"
SDK_ZIP_1.4.0-rtos = ESP8266_RTOS_SDK-dba89f9aba75f9858157618e8bb4927d2da76296
SDK_VER_1.4.0-rtos = esp-rtos-sdk-v1.4.0
SDK_URL_1.3.0-rtos = "https://github.com/espressif/ESP8266_RTOS_SDK/archive/3ca6af5da68678d809b34c7cd98bee71e0235039.zip"
SDK_ZIP_1.3.0-rtos = ESP8266_RTOS_SDK-3ca6af5da68678d809b34c7cd98bee71e0235039
SDK_VER_1.3.0-rtos = esp-rtos-sdk-v1.3.0
#ESP8266_NONOS_SDK-2.1.0-18-g61248df
SDK_URL_2.1.x = "https://github.com/espressif/ESP8266_NONOS_SDK/archive/release/v2.1.x.zip"
SDK_ZIP_2.1.x = ESP8266_NONOS_SDK-release-v2.1.x
SDK_VER_2.1.x = esp_iot_sdk_v2.1.x
SDK_URL_2.1.0 = "https://github.com/espressif/ESP8266_NONOS_SDK/archive/v2.1.0.zip"
SDK_ZIP_2.1.0 = ESP8266_NONOS_SDK-2.1.0
SDK_VER_2.1.0 = esp_iot_sdk_v2.1.0
SDK_URL_2.0.0 = "http://bbs.espressif.com/download/file.php?id=1690"
SDK_ZIP_2.0.0 = ESP8266_NONOS_SDK
SDK_VER_2.0.0 = esp_iot_sdk_v2.0.0
SDK_URL_1.5.4 = "http://bbs.espressif.com/download/file.php?id=1469"
SDK_ZIP_1.5.4 = ESP8266_NONOS_SDK
SDK_VER_1.5.4 = esp_iot_sdk_v1.5.4
SDK_URL_1.5.3 = "http://bbs.espressif.com/download/file.php?id=1361"
SDK_ZIP_1.5.3 = ESP8266_NONOS_SDK_V1.5.3_16_04_18
SDK_VER_1.5.3 = esp_iot_sdk_v1.5.3
SDK_ZIP_1.5.2 = esp_iot_sdk_v1.5.2
SDK_URL_1.5.2 = "http://bbs.espressif.com/download/file.php?id=1079"
SDK_VER_1.5.2 = esp_iot_sdk_v1.5.2
SDK_URL_1.5.1 = "http://bbs.espressif.com/download/file.php?id=1046"
SDK_ZIP_1.5.1 = esp_iot_sdk_v1.5.1
SDK_VER_1.5.1 = esp_iot_sdk_v1.5.1
SDK_URL_1.5.0 = "http://bbs.espressif.com/download/file.php?id=989"
SDK_ZIP_1.5.0 = esp_iot_sdk_v1.5.0_15_11_27
SDK_VER_1.5.0 = esp_iot_sdk_v1.5.0

SDK_ZIP = $(SDK_ZIP_$(SDK_VERSION))
SDK_URL = $(SDK_URL_$(SDK_VERSION))
SDK_VER = $(SDK_VER_$(SDK_VERSION))


#*******************************************
#************* targets section *************
#*******************************************

.PHONY: toolchain info inst-info build build-info dist dist-info

all:
	@date +"%Y-%m-%d %X" > build-start.txt
	@$(OUTPUT_DATE)
	@echo "Detected: $(BUILD) with $(ARCH)bit on $(OS)"
	@echo "Processors: $(NUMBER_OF_PROCESSORS)"
	@$(MAKE) build-info
	@$(MAKE_OPT) build # install
	@$(MAKE) info
	@cat build-start.txt; rm build-start.txt
	@$(OUTPUT_DATE)
	@echo -e "\07"

dist:
ifneq ($(DISTRIB), "")
	@$(MAKE) dist-info
	@$(MKDIR) $(DIST_DIR)
	-@bsdtar -cz --exclude=$(TARGET)/.installed-* -f $(DIST_DIR)/$(DISTRIB).tar.gz $(TARGET)
endif

#*******************************************
#**************** TOOLCHAIN ****************
#*******************************************

$(TOOLCHAIN):
	@git config --global core.autocrlf false
	$(MKDIR) $(TOOLCHAIN)

toolchain: $(SOURCE_DIR) $(TAR_DIR) $(MLIB_DIR) $(TOOLCHAIN) $(MLIB_DIR)/.installed-gmp $(MLIB_DIR)/.installed-mpfr $(MLIB_DIR)/.installed-mpc $(TARGET)/.installed-binutils $(TARGET)/.installed-gcc-pass-1 $(TARGET)/.installed-newlib $(TARGET)/.installed-gcc-pass-2 $(TARGET)/.installed-gdb $(TARGET)/.installed-libhal $(TOOLCHAIN)/$(TARGET)/lib/libcirom.a $(TOOLCHAIN)/$(TARGET)/lib/liblwip_open.a strip compress

# be aware: with parallel jobs, this order could be change?
build: $(SOURCE_DIR) $(TAR_DIR) $(MLIB_DIR) toolchain $(TARGET)/.installed-sdk sdk_patch

# split install for travis build
install: install-part-0 install-part-1 install-part-2 install-part-3 install-part-4
install-part-0: install-info $(SOURCE_DIR) $(TAR_DIR) $(MLIB_DIR) get-tars
install-part-1: $(MLIB_DIR)/.installed-gmp $(MLIB_DIR)/.installed-mpfr $(MLIB_DIR)/.installed-mpc $(TARGET)/.installed-binutils
install-part-2: $(TARGET)/.installed-gcc-pass-1 $(TARGET)/.installed-newlib
install-part-3: $(TARGET)/.installed-gcc-pass-2 $(TARGET)/.installed-libhal
install-part-4: $(TARGET)/.installed-gdb toolchain strip compress

get-tars: $(TAR_DIR) $(TAR_DIR)/$(GMP_TAR) $(TAR_DIR)/$(MPFR_TAR) $(TAR_DIR)/$(MPC_TAR) $(TAR_DIR)/$(BIN_TAR) $(TAR_DIR)/$(GCC_TAR) $(TAR_DIR)/$(NLX_TAR) $(TAR_DIR)/$(HAL)-$(HAL_TAR) $(TAR_DIR)/$(GDB_TAR)
get-src: $(GMP_DIR)/configure.ac $(MPFR_DIR)/configure.ac $(MPC_DIR)/configure.ac $(BIN_DIR)/configure.ac $(GCC_DIR)/configure.ac $(NLX_DIR)/configure.ac $(HAL_DIR)/configure.ac $(GDB_DIR)/configure.ac
get-gcc: $(GCC_DIR)/configure.ac

build-info:
	@$(OUTPUT_DATE)
	$(info ############################)
	$(info #### Build Toolchain... ####)
	$(info ############################)

install-info:
	@$(OUTPUT_DATE)
	$(info ##############################)
	$(info #### Install Toolchain... ####)
	$(info ##############################)

info:
	@echo "+-----------------------------------------------------------+"
	@echo "| $(TARGET) Toolchain is build with:"
	@echo "|"
	@echo "|   GMP      $(GMP_VERSION)"
	@echo "|   MPFR     $(MPFR_VERSION)"
	@echo "|   MPC      $(MPC_VERSION)"
	@echo "|   BINUTILS $(BIN_VERSION)"
	@echo "|   GCC      $(GCC_VERSION)"
	@echo "|   NEWLIB   $(NLX_VERSION)"
	@echo "|   LIBHAL   $(HAL_VERSION)"
ifeq ($(GDB),y)
	@echo "|   GDB      $(GDB_VERSION)"
endif
ifeq ($(LWIP),y)
	@echo "|   LWIP     $(LWIP_VERSION)"
endif
	@echo "|"
	@echo "|   SDK      $(SDK_VERSION)"
	@echo "+-----------------------------------------------------------+"

inst-info:
	@echo "+-----------------------------------------------------------+"
	@echo "| $(TARGET) Toolchain is built. To use it:"
	@echo "|   export PATH=$(TARGET)/bin:\$$PATH"
	@echo "|"
ifneq ($(STANDALONE),y)
	@echo "| Espressif ESP8266 SDK is installed."
	@echo "| Toolchain contains only Open Source components"
	@echo "| To link external proprietary libraries add:"
	@echo "|"
	@echo "|   $(XGCC) \\"
	@echo "|       -I $(SDK_DIR)/include \\"
	@echo "|       -L $(SDK_DIR)/lib"
	@echo "+-----------------------------------------------------------+"
else
	@echo "| Espressif ESP8266 SDK is installed,"
	@echo "|   libraries and headers are merged with the Toolchain"
	@echo "+-----------------------------------------------------------+"
endif

dist-info:
	@$(OUTPUT_DATE)
	@echo "+-----------------------------------------------------------+"
	@echo "| The Toolchain will be packed for distribution,"
	@echo "|   creating: $(DISTRIB).tar.gz"
	@echo "+-----------------------------------------------------------+"

exit-info-bin:
	@echo "+-----------------------------------------------------------+"
	@echo "| The Build stops now:"
	@echo "|   missing: $(BIN)"
	@echo "+-----------------------------------------------------------+"
	exit 1

exit-info-gcc:
	@echo "+-----------------------------------------------------------+"
	@echo "| The Build stops now:"
	@echo "|   missing: $(GCC)-pass-1"
	@echo "+-----------------------------------------------------------+"
	exit 1

#*******************************************
#************** patch section **************
#*******************************************

sdk_patch_1.4.0-rtos:

sdk_patch_1.3.0-rtos:

sdk_patch_2.1.x: $(SDK_DIR)/user_rf_cal_sector_set.o
	@echo -e "#undef ESP_SDK_VERSION\n#define ESP_SDK_VERSION 020100" >>$(SDK_DIR)/include/esp_sdk_ver.h
	-@$(PATCH) -d $(SDK_DIR) -p1 -i $(PATCHES_DIR)/c_types-c99_sdk_2.patch $(SILENT)
	@cd $(SDK_DIR)/lib; mkdir -p tmp; cd tmp; $(TOOLCHAIN)/bin/$(XAR) x ../libcrypto.a; cd ..; $(TOOLCHAIN)/bin/$(XAR) rs libwpa.a tmp/*.o; rm -R tmp
	@$(TOOLCHAIN)/bin/$(XAR) r $(SDK_DIR)/lib/libmain.a $(SDK_DIR)/user_rf_cal_sector_set.o

sdk_patch_2.1.0: $(SDK_DIR)/user_rf_cal_sector_set.o
	@echo -e "#undef ESP_SDK_VERSION\n#define ESP_SDK_VERSION 020100" >>$(SDK_DIR)/include/esp_sdk_ver.h
	-@$(PATCH) -d $(SDK_DIR) -p1 -i $(PATCHES_DIR)/c_types-c99_sdk_2.patch $(SILENT)
	@cd $(SDK_DIR)/lib; mkdir -p tmp; cd tmp; $(TOOLCHAIN)/bin/$(XAR) x ../libcrypto.a; cd ..; $(TOOLCHAIN)/bin/$(XAR) rs libwpa.a tmp/*.o; rm -R tmp
	@$(TOOLCHAIN)/bin/$(XAR) r $(SDK_DIR)/lib/libmain.a $(SDK_DIR)/user_rf_cal_sector_set.o

sdk_patch_2.0.0: ESP8266_NONOS_SDK_V2.0.0_patch_16_08_09.zip $(SDK_DIR)/user_rf_cal_sector_set.o
	@echo -e "#undef ESP_SDK_VERSION\n#define ESP_SDK_VERSION 020000" >>$(SDK_DIR)/include/esp_sdk_ver.h
	$(UNTAR) $(PATCHES_DIR)/ESP8266_NONOS_SDK_V2.0.0_patch_16_08_09.zip
	$(MOVE) libmain.a libnet80211.a libpp.a $(SDK_DIR_2.0.0)/lib/
	-@$(PATCH) -d $(SDK_DIR) -p1 -i $(PATCHES_DIR)/c_types-c99_sdk_2.patch $(SILENT)
	@cd $(SDK_DIR)/lib; mkdir -p tmp; cd tmp; $(TOOLCHAIN)/bin/$(XAR) x ../libcrypto.a; cd ..; $(TOOLCHAIN)/bin/$(XAR) rs libwpa.a tmp/*.o; rm -R tmp
	@$(TOOLCHAIN)/bin/$(XAR) r $(SDK_DIR)/lib/libmain.a $(SDK_DIR)/user_rf_cal_sector_set.o

sdk_patch_1.5.4:
	@echo -e "#undef ESP_SDK_VERSION\n#define ESP_SDK_VERSION 010504" >>$(SDK_DIR)/include/esp_sdk_ver.h
	-@$(PATCH) -d $(SDK_DIR) -p1 -i $(PATCHES_DIR)/c_types-c99.patch $(SILENT)
	@cd $(SDK_DIR)/lib; mkdir -p tmp; cd tmp; $(TOOLCHAIN)/bin/$(XAR) x ../libcrypto.a; cd ..; $(TOOLCHAIN)/bin/$(XAR) rs libwpa.a tmp/*.o; rm -R tmp

sdk_patch_1.5.3:
	@echo -e "#undef ESP_SDK_VERSION\n#define ESP_SDK_VERSION 010503" >>$(SDK_DIR)/include/esp_sdk_ver.h
	-@$(PATCH) -d $(SDK_DIR) -p1 -i $(PATCHES_DIR)/c_types-c99.patch $(SILENT)
	@cp -p FRM_ERR_PATCH/*.a $(SDK_DIR)/lib/

sdk_patch_1.5.2: Patch01_for_ESP8266_NONOS_SDK_V1.5.2.zip
	@echo -e "#undef ESP_SDK_VERSION\n#define ESP_SDK_VERSION 010502" >>$(SDK_DIR)/include/esp_sdk_ver.h
	$(UNTAR) $(PATCHES_DIR)/Patch01_for_ESP8266_NONOS_SDK_V1.5.2.zip 
	$(MOVE) libssl.a libnet80211.a libmain.a $(SDK_DIR_1.5.2)/lib/
	-@$(PATCH) -d $(SDK_DIR) -p1 -i $(PATCHES_DIR)/c_types-c99.patch $(SILENT)
	@cd $(SDK_DIR)/lib; mkdir -p tmp; cd tmp; $(TOOLCHAIN)/bin/$(XAR) x ../libcrypto.a; cd ..; $(TOOLCHAIN)/bin/$(XAR) rs libwpa.a tmp/*.o; rm -R tmp

sdk_patch_1.5.1:
	@echo -e "#undef ESP_SDK_VERSION\n#define ESP_SDK_VERSION 010504" >>$(SDK_DIR)/include/esp_sdk_ver.h
	-@$(PATCH) -d $(SDK_DIR) -p1 -i $(PATCHES_DIR)/c_types-c99.patch $(SILENT)
	@cd $(SDK_DIR)/lib; mkdir -p tmp; cd tmp; $(TOOLCHAIN)/bin/$(XAR) x ../libcrypto.a; cd ..; $(TOOLCHAIN)/bin/$(XAR) rs libwpa.a tmp/*.o; rm -R tmp

sdk_patch_1.5.0:
	@echo -e "#undef ESP_SDK_VERSION\n#define ESP_SDK_VERSION 010504" >>$(SDK_DIR)/include/esp_sdk_ver.h
	-@$(PATCH) -d $(SDK_DIR) -p1 -i $(PATCHES_DIR)/c_types-c99.patch $(SILENT)
	@cd $(SDK_DIR)/lib; mkdir -p tmp; cd tmp; $(TOOLCHAIN)/bin/$(XAR) x ../libcrypto.a; cd ..; $(TOOLCHAIN)/bin/$(XAR) rs libwpa.a tmp/*.o; rm -R tmp

sdk_patch: sdk_patch_$(SDK_VERSION)

gcc_patch:
ifneq "$(wildcard $(PATCHES_DIR)/gcc/$(GCC_VERSION) )" ""
	-for i in $(PATCHES_DIR)/gcc/$(GCC_VERSION)/*.patch; do $(PATCH) -d $(GCC_DIR) -p1 < $$i $(SILENT); done
endif

binutils_patch:
ifneq "$(wildcard $(PATCHES_DIR)/binutils/$(BIN_VERSION) )" ""
	-for i in $(PATCHES_DIR)/binutils/$(BIN_VERSION)/*.patch; do $(PATCH) -d $(BIN_DIR) -p1 < $$i $(SILENT); done
endif

newlib_patch:
ifneq "$(wildcard $(PATCHES_DIR)/newlib/$(NLX_VERSION) )" ""
	-for i in $(PATCHES_DIR)/newlib/$(NLX_VERSION)/*.patch; do $(PATCH) -d $(NLX_DIR) -p1 < $$i $(SILENT); done
	-@touch $(NLX_DIR)/newlib/libc/sys/xtensa/include/xtensa/dummy.h
endif

gdb_patch:
ifneq "$(wildcard $(PATCHES_DIR)/gdb/$(GDB_VERSION) )" ""
	-for i in $(PATCHES_DIR)/gdb/$(GDB_VERSION)/*.patch; do $(PATCH) -d $(GDB_DIR) -p1 < $$i $(SILENT); done
endif

lwip_patch:
ifneq "$(wildcard $(PATCHES_DIR)/lwip/$(LWIP_VERSION) )" ""
	-for i in $(PATCHES_DIR)/lwip/$(LWIP_VERSION)/*.patch; do $(PATCH) -d $(LWIP_DIR) -p1 < $$i $(SILENT); done
endif

Patch01_for_ESP8266_NONOS_SDK_V1.5.2.zip:
	$(WGET) --content-disposition "http://bbs.espressif.com/download/file.php?id=1168" --output-document $(PATCHES_DIR)/$@
ESP8266_NONOS_SDK_V2.0.0_patch_16_08_09.zip:
	$(WGET) --content-disposition "http://bbs.espressif.com/download/file.php?id=1654" --output-document $(PATCHES_DIR)/$@

$(SDK_DIR)/user_rf_cal_sector_set.o: $(SDK_DIR)
	@cp -p $(PATCHES_DIR)/user_rf_cal_sector_set.c $(SDK_DIR)
	@cd $(SDK_DIR); $(TOOLCHAIN)/bin/$(XGCC) -O2 -I$(SDK_DIR)/include -c $(SDK_DIR)/user_rf_cal_sector_set.c

#*******************************************
#*************** SDK  section **************
#*******************************************
$(TARGET)/.installed-sdk: $(SDK_DIR) sdk_patch
ifeq ($(STANDALONE),y)
	@$(OUTPUT_DATE)
	$(info ########################)
	$(info #### Install SDK... ####)
	$(info ########################)
	@echo "Installing vendor SDK headers into Toolchain"
	@cp -p -R -f $(SDK_DIR)/include/* $(TOOLCHAIN)/$(TARGET)/include/
	@echo "Installing vendor SDK libs into Toolchain"
	@cp -p -R -f $(SDK_DIR)/lib/* $(TOOLCHAIN)/$(TARGET)/lib/
	@echo "Installing vendor SDK linker scripts into Toolchain"
	@sed -e 's/\r//' $(SDK_DIR)/ld/eagle.app.v6.ld | sed -e s@../ld/@@ >$(TOOLCHAIN)/$(TARGET)/lib/eagle.app.v6.ld
	@sed -e 's/\r//' $(SDK_DIR)/ld/eagle.rom.addr.v6.ld >$(TOOLCHAIN)/$(TARGET)/lib/eagle.rom.addr.v6.ld
	@touch $@
endif

$(TAR_DIR)/$(SDK_VER).zip:
ifeq "$(wildcard $@ )" ""
	@$(OUTPUT_DATE)
	$(info #########################)
	$(info #### Download SDK... ####)
	$(info #########################)
	echo $(SDK_URL) $(TAR_DIR)/$(SDK_VER).zip
	$(WGET) --content-disposition $(SDK_URL) --output-document $@
endif

$(SDK_DIR): $(TAR_DIR)/$(SDK_VER).zip
	@$(OUTPUT_DATE)
	$(info ########################)
	$(info #### Extract SDK... ####)
	$(info ########################)
	$(MKDIR) $(TOP_SDK)
	$(UNTAR) $(TAR_DIR)/$(SDK_VER).zip -C $(TOP_SDK)/
    ifeq "$(wildcard $(TOP_SDK)/$(SDK_ZIP) )" ""
		$(MOVE) $(TOP_SDK)/$(SDK_ZIP) $(TOP_SDK)/$(SDK_VER)/
    endif
    ifneq "$(wildcard $(TOP_SDK)/release_note.txt )" ""
		$(MOVE) $(TOP_SDK)/release_note.txt $(TOP_SDK)/$(SDK_VER)/
    endif
    ifneq "$(wildcard $(TOP_SDK)/License )" ""
		$(MOVE) $(TOP_SDK)/License $(TOP_SDK)/$(SDK_VER)/
    endif
	@rm -f $(TARGET)/.installed-sdk
	@touch $@

#*******************************************
#*************** LIBs section **************
#*******************************************
$(TOOLCHAIN)/$(TARGET)/lib/libhal.a: $(BUILD_HAL_DIR) $(SDK_DIR)
$(TOOLCHAIN)/$(TARGET)/lib/libc.a: $(BUILD_NLX_DIR)

$(TOOLCHAIN)/$(TARGET)/lib/libcirom.a: $(TOOLCHAIN)/$(TARGET)/lib/libc.a $(TARGET)/.installed-sdk
	@$(OUTPUT_DATE)
	$(info ########################)
	$(info #### Modify Libs... ####)
	$(info ########################)
	@$(TOOLCHAIN)/bin/$(XOCP) --rename-section .text=.irom0.text \
		--rename-section .literal=.irom0.literal $(<) $(@);
	@touch $@
	@$(MAKE_OPT) libmain
	@$(MAKE_OPT) libc
	@$(MAKE_OPT) libgcc
	@$(MAKE_OPT) libstdc++

libmain_objs = mem_manager.o time.o
libmain: $(TOOLCHAIN)/$(TARGET)/lib/libmain.a
	@$(TOOLCHAIN)/bin/$(XAR) $(ARCH_OPT) $(TOOLCHAIN)/$(TARGET)/lib/$@.a $(libmain_objs)

libc_objs = lib_a-bzero.o lib_a-memcmp.o lib_a-memcpy.o lib_a-memmove.o lib_a-memset.o lib_a-rand.o \
		lib_a-strcmp.o lib_a-strcpy.o lib_a-strlen.o lib_a-strncmp.o lib_a-strncpy.o lib_a-strstr.o
libc: $(TOOLCHAIN)/$(TARGET)/lib/libc.a
	@$(TOOLCHAIN)/bin/$(XAR) $(ARCH_OPT) $(TOOLCHAIN)/$(TARGET)/lib/$@.a $(libc_objs)

libgcc_objs = _addsubdf3.o _addsubsf3.o _divdf3.o _divdi3.o _divsi3.o _extendsfdf2.o _fixdfsi.o _fixunsdfsi.o \
		_fixunssfsi.o _floatsidf.o _floatsisf.o _floatunsidf.o _floatunsisf.o _muldf3.o _muldi3.o _mulsf3.o \
		_truncdfsf2.o _udivdi3.o _udivsi3.o _umoddi3.o _umulsidi3.o
libgcc: $(TOOLCHAIN)/$(TARGET)/lib/libgcc.a
	@$(TOOLCHAIN)/bin/$(XAR) $(ARCH_OPT) $(TOOLCHAIN)/$(TARGET)/lib/$@.a $(libgcc_objs)

libstdc++_objs = pure.o vterminate.o guard.o functexcept.o del_op.o del_opv.o new_op.o new_opv.o
libstdc++: $(TOOLCHAIN)/$(TARGET)/lib/libstdc++.a
	@$(TOOLCHAIN)/bin/$(XAR) $(ARCH_OPT) $(TOOLCHAIN)/$(TARGET)/lib/$@.a $(libstdc++_objs)

$(TOOLCHAIN)/$(TARGET)/lib/liblwip_open.a:
	@$(MAKE) lwip

build-lwip:
	@$(MAKE) lwip_patch
	@$(MAKE) -C $(LWIP_DIR) -f Makefile.open install \
	    CC=$(TOOLCHAIN)/bin/$(XGCC) \
	    AR=$(TOOLCHAIN)/bin/$(XAR) \
	    PREFIX=$(TOOLCHAIN)
	@cp -p -a $(LWIP_DIR)/include/arch $(LWIP_DIR)/include/lwip $(LWIP_DIR)/include/netif \
	    $(LWIP_DIR)/include/lwipopts.h \
	    $(TOOLCHAIN)/$(TARGET)/include/

lwip: $(TOOLCHAIN) sdk_patch
ifeq ($(LWIP),y)
	@$(OUTPUT_DATE)
	$(info #######################)
	$(info #### Build LWIP... ####)
	$(info #######################)
	$(WGET) $(LWIP_TAR) --output-document=$(TAR_DIR)/$(LWIP_VERSION).zip
	-@rm -R $(LWIP_DIR)/*
	$(UNTAR) $(TAR_DIR)/$(LWIP_VERSION).zip -C $(SOURCE_DIR)
	$(MOVE) -f $(SOURCE_DIR)/$(LWIP_VERSION)-*/* $(LWIP_DIR)
	-@rm -R $(SOURCE_DIR)/$(LWIP_VERSION)-*
    ifeq ($(STANDALONE),y)
		$(MAKE) build-lwip
    endif
endif

#*******************************************
#*************** test targets **************
#*******************************************

# use $(TARGET)/.installed-xxx instead of $(XXX_DIR) so the source is no longer necessary after the build
build-gmp: $(MLIB_DIR)/.installed-gmp
build-mpfr: $(MLIB_DIR)/.installed-gmp $(MLIB_DIR)/.installed-mpfr
build-mpc: $(MLIB_DIR)/.installed-gmp $(MLIB_DIR)/.installed-mpfr $(MLIB_DIR)/.installed-mpc
build-binutils: $(MLIB_DIR)/.installed-gmp $(MLIB_DIR)/.installed-mpfr $(MLIB_DIR)/.installed-mpc $(TARGET)/.installed-binutils
ifneq "$(wildcard $(TARGET)/.installed-binutils )" ""
# so we don't need dependency from $(TARGET)/.installed-binutils
# otherwise BIN_TAR or configure.ac is missing without sources
    build-gcc-pass-1: $(TARGET)/.installed-gcc-pass-1
    # so we don't need dependency from $(TARGET)/.installed-gcc-pass-1
    # otherwise GCC_TAR or configure.ac is missing without sources
    ifneq "$(wildcard $(TARGET)/.installed-gcc-pass-1 )" ""
        build-newlib: $(TARGET)/.installed-newlib
        build-gcc-pass-2: build-newlib $(TARGET)/.installed-gcc-pass-2
        build-libhal: $(TARGET)/.installed-libhal
        build-gdb: $(TARGET)/.installed-gdb
    else
        build-newlib: exit-info-gcc
        build-gcc-pass-2: exit-info-gcc
        build-libhal: exit-info-gcc
        build-gdb: exit-info-gcc
    endif
else
    build-gcc-pass-1: exit-info-bin
    build-newlib: exit-info-bin
    build-gcc-pass-2: exit-info-bin
    build-libhal: exit-info-bin
    build-gdb: exit-info-bin
endif

$(SOURCE_DIR):
	$(MKDIR) $(SOURCE_DIR)

$(TAR_DIR):
	$(MKDIR) $(TAR_DIR)

$(MLIB_DIR):
	$(MKDIR) $(MLIB_DIR)
	$(MKDIR) $(MLIB_DIR)/gmp
	$(MKDIR) $(MLIB_DIR)/mpfr
	$(MKDIR) $(MLIB_DIR)/mpc


#*******************************************
#************ submodul section *************
#*******************************************

#************** GMP (GNU Multiple Precision Arithmetic Library)
$(TAR_DIR)/$(GMP_TAR):
ifeq "$(wildcard $@ )" ""
	@$(OUTPUT_DATE)
	$(info #####################)
	$(info #### Wget GMP... ####)
	$(info #####################)
	$(MKDIR) $(TAR_DIR)
	$(WGET) $(GNU_URL)/gmp/$(GMP_TAR) --output-document $(TAR_DIR)/$(GMP_TAR)
endif

$(GMP_DIR)/configure.ac: $(TAR_DIR)/$(GMP_TAR)
ifeq "$(wildcard $@ )" ""
	@$(OUTPUT_DATE)
	$(info ########################)
	$(info #### Extract GMP... ####)
	$(info ########################)
	@$(UNTAR) $(TAR_DIR)/$(GMP_TAR) -C $(SOURCE_DIR)
	@touch $@
endif

$(BUILD_GMP_DIR): $(GMP_DIR)/configure.ac
	@$(OUTPUT_DATE)
	$(info ######################)
	$(info #### Build GMP... ####)
	$(info ######################)
	$(MKDIR) $(BUILD_GMP_DIR)
	@cd $(BUILD_GMP_DIR); ../$(CONF_OPT) --prefix=$(MLIB_DIR)/gmp $(GMP_OPT) $(SILENT)
	@$(MAKE_OPT) -C $(BUILD_GMP_DIR) $(SILENT)
	@rm -f $(MLIB_DIR)/.installed-gmp
	@touch $@

$(MLIB_DIR)/.installed-gmp: $(BUILD_GMP_DIR)
	@$(OUTPUT_DATE)
	$(info ########################)
	$(info #### Install GMP... ####)
	$(info ########################)
	$(MKDIR) $(MLIB_DIR)/gmp
	@$(MAKE_OPT) $(INST_OPT) -C $(BUILD_GMP_DIR) $(SILENT)
	@touch $@

$(MLIB_DIR)/gmp: $(BUILD_GMP_DIR) $(MLIB_DIR)/.installed-gmp
	@touch $@

#************** MPFR (Multiple Precision Floating-Point Reliable Library)
$(TAR_DIR)/$(MPFR_TAR):
ifeq "$(wildcard $@ )" ""
	@$(OUTPUT_DATE)
	$(info ######################)
	$(info #### Wget MPFR... ####)
	$(info ######################)
	$(MKDIR) $(TAR_DIR)
	$(WGET) $(GNU_URL)/mpfr/$(MPFR_TAR) --output-document $(TAR_DIR)/$(MPFR_TAR)
endif

$(MPFR_DIR)/configure.ac: $(TAR_DIR)/$(MPFR_TAR)
ifeq "$(wildcard $@ )" ""
	@$(OUTPUT_DATE)
	$(info #########################)
	$(info #### Extract MPFR... ####)
	$(info #########################)
	@$(UNTAR) $(TAR_DIR)/$(MPFR_TAR) -C $(SOURCE_DIR)
	@touch $@
endif

$(BUILD_MPFR_DIR): $(MPFR_DIR)/configure.ac
	@$(OUTPUT_DATE)
	$(info #######################)
	$(info #### Build MPFR... ####)
	$(info #######################)
	$(MKDIR) $(BUILD_MPFR_DIR)
	@cd $(BUILD_MPFR_DIR); ../$(CONF_OPT) --prefix=$(MLIB_DIR)/mpfr --with-gmp=$(MLIB_DIR)/gmp $(MPFR_OPT) $(SILENT)
	@$(MAKE_OPT) -C $(BUILD_MPFR_DIR) $(SILENT)
	@rm -f $(MLIB_DIR)/.installed-mpfr
	@touch $@

$(MLIB_DIR)/.installed-mpfr: $(BUILD_MPFR_DIR)
	@$(OUTPUT_DATE)
	$(info ########################)
	$(info #### Install MPFR...####)
	$(info ########################)
	$(MKDIR) $(MLIB_DIR)/mpfr
	@$(MAKE_OPT) $(INST_OPT) -C $(BUILD_MPFR_DIR) $(SILENT)
	@touch $@

$(MLIB_DIR)/mpfr: $(BUILD_MPFR_DIR) $(MLIB_DIR)/.installed-mpfr
	@touch $@

#************** MPC (Multiple precision complex arithmetic Library)
$(TAR_DIR)/$(MPC_TAR):
ifeq "$(wildcard $@ )" ""
	@$(OUTPUT_DATE)
	$(info #####################)
	$(info #### Wget MPC... ####)
	$(info #####################)
	$(MKDIR) $(TAR_DIR)
	$(WGET) $(GNU_URL)/mpc/$(MPC_TAR) --output-document $(TAR_DIR)/$(MPC_TAR)
endif

$(MPC_DIR)/configure.ac: $(TAR_DIR)/$(MPC_TAR)
ifeq "$(wildcard $@ )" ""
	@$(OUTPUT_DATE)
	$(info ########################)
	$(info #### Extract MPC... ####)
	$(info ########################)
	@$(UNTAR) $(TAR_DIR)/$(MPC_TAR) -C $(SOURCE_DIR)
	@touch $@
endif

$(BUILD_MPC_DIR): $(MPC_DIR)/configure.ac
	@$(OUTPUT_DATE)
	$(info ######################)
	$(info #### Build MPC... ####)
	$(info ######################)
	$(MKDIR) $(BUILD_MPC_DIR)
	@cd $(BUILD_MPC_DIR); ../$(CONF_OPT) --prefix=$(MLIB_DIR)/mpc --with-mpfr=$(MLIB_DIR)/mpfr --with-gmp=$(MLIB_DIR)/gmp $(MPC_OPT) $(SILENT)
	@$(MAKE_OPT) -C $(BUILD_MPC_DIR) $(SILENT)
	@rm -f $(MLIB_DIR)/.installed-mpc
	@touch $@

$(MLIB_DIR)/.installed-mpc: $(BUILD_MPC_DIR)
	@$(OUTPUT_DATE)
	$(info ########################)
	$(info #### Install MPC... ####)
	$(info ########################)
	$(MKDIR) $(MLIB_DIR)/mpc
	@$(MAKE_OPT) $(INST_OPT) -C $(BUILD_MPC_DIR) $(SILENT)
	@touch $@

$(MLIB_DIR)/mpc: $(BUILD_MPC_DIR) $(MLIB_DIR)/.installed-mpc
	@touch $@

#************** Binutils (The GNU binary utilities)
$(TAR_DIR)/$(BIN_TAR):
ifeq "$(wildcard $@ )" ""
	@$(OUTPUT_DATE)
	$(info ##########################)
	$(info #### Wget Binutils... ####)
	$(info ##########################)
	$(MKDIR) $(TAR_DIR)
	$(WGET) $(GNU_URL)/binutils/$(BIN_TAR) --output-document $(TAR_DIR)/$(BIN_TAR)
endif

$(BIN_DIR)/configure.ac: $(TAR_DIR)/$(BIN_TAR)
ifeq "$(wildcard $@ )" ""
	@$(OUTPUT_DATE)
	$(info #############################)
	$(info #### Extract Binutils... ####)
	$(info #############################)
	$(MKDIR) $(BIN_DIR)
	$(UNTAR) $(TAR_DIR)/$(BIN_TAR) -C $(SOURCE_DIR)
	@touch $@
endif

$(BUILD_BIN_DIR): $(BIN_DIR)/configure.ac
	@$(OUTPUT_DATE)
	$(info ###########################)
	$(info #### Build Binutils... ####)
	$(info ###########################)
	@$(MAKE_OPT) binutils_patch $(SILENT)
	$(MKDIR) $(BUILD_BIN_DIR)
	@cd $(BUILD_BIN_DIR); ../$(CONF_OPT) --prefix=$(TOOLCHAIN) --target=$(TARGET) $(BIN_OPT) $(SILENT)
	@rm -f $(TARGET)/.installed-binutils
	@PATH="$(TOOLCHAIN)/bin:$(SAFEPATH)" $(MAKE_OPT) -C $(BUILD_BIN_DIR) $(SILENT)
	@touch $@

$(TARGET)/.installed-binutils: $(BUILD_BIN_DIR)
	@$(OUTPUT_DATE)
	$(info #############################)
	$(info #### Install Binutils... ####)
	$(info #############################)
	@$(MAKE_OPT) $(INST_OPT) -C $(BUILD_BIN_DIR) $(SILENT)
	@touch $@

$(BIN_DIR): $(BUILD_BIN_DIR) $(TARGET)/.installed-binutils
	@touch $@

#************** GCC (The GNU C preprocessor)
$(TAR_DIR)/$(GCC_TAR):
ifeq "$(wildcard $@ )" ""
	@$(OUTPUT_DATE)
	$(info #####################)
	$(info #### Wget GCC... ####)
	$(info #####################)
	$(MKDIR) $(TAR_DIR)
	$(WGET) $(GNU_URL)/gcc/gcc-$(GCC_VERSION)/$(GCC_TAR) --output-document $(TAR_DIR)/$(GCC_TAR)
endif

$(GCC_DIR)/configure.ac: $(TAR_DIR)/$(GCC_TAR)
ifeq "$(wildcard $@ )" ""
	@$(OUTPUT_DATE)
	$(info ########################)
	$(info #### Extract GCC... ####)
	$(info ########################)
	$(MKDIR) $(GCC_DIR)
	$(UNTAR) $(TAR_DIR)/$(GCC_TAR) -C $(SOURCE_DIR)
	@touch $@
endif

#************** GCC Pass 1
$(BUILD_GCC_DIR)-pass-1: $(GCC_DIR)/configure.ac
	@$(OUTPUT_DATE)
	$(info #############################)
	$(info #### Build GCC Pass 1... ####)
	$(info #############################)
	$(MKDIR) $(BUILD_GCC_DIR)-pass-1
	@cd $(BUILD_GCC_DIR)-pass-1; ../$(CONF_OPT) --prefix=$(TOOLCHAIN) --target=$(TARGET) $(GC1_OPT) $(SILENT)
	@$(MAKE_OPT) all-gcc -C $(BUILD_GCC_DIR)-pass-1 $(SILENT)
	@rm -f $(TARGET)/.installed-gcc-pass-1
	@$(MAKE_OPT) $(TARGET)/.installed-gcc-pass-1 $(SILENT)
	@touch $@

$(TARGET)/.installed-gcc-pass-1: $(BUILD_GCC_DIR)-pass-1
	@$(OUTPUT_DATE)
	$(info ###############################)
	$(info #### Install GCC Pass 1... ####)
	$(info ###############################)
	@$(MAKE_OPT) install-gcc -C $(BUILD_GCC_DIR)-pass-1 $(SILENT)
	@cp -p $(TOOLCHAIN)/bin/$(XGCC) $(TOOLCHAIN)/bin/$(XCC)
	@touch $@

#************** GCC Pass 2
$(BUILD_GCC_DIR)-pass-2: $(GCC_DIR)/configure.ac
	@$(OUTPUT_DATE)
	$(info #############################)
	$(info #### Build GCC Pass 2... ####)
	$(info #############################)
	@$(MAKE_OPT) gcc_patch $(SILENT)
	$(MKDIR) $(BUILD_GCC_DIR)-pass-2
	@cd $(BUILD_GCC_DIR)-pass-2; ../$(CONF_OPT) --prefix=$(TOOLCHAIN) --target=$(TARGET) $(GC2_OPT) $(SILENT)
	@$(MAKE_OPT) -C $(BUILD_GCC_DIR)-pass-2 $(SILENT)
	@rm -f $(TARGET)/.installed-gcc-pass-2
	@$(MAKE_OPT) $(TARGET)/.installed-gcc-pass-2 $(SILENT)
	@touch $@

$(TARGET)/.installed-gcc-pass-2: $(BUILD_GCC_DIR)-pass-2
	@$(OUTPUT_DATE)
	$(info ###############################)
	$(info #### Install GCC Pass 2... ####)
	$(info ###############################)
	@$(MAKE_OPT) $(INST_OPT) -C $(BUILD_GCC_DIR)-pass-2 $(SILENT)
	@touch $@

#************** Newlib (ANSI C library, math library, and collection of board support packages)
$(TAR_DIR)/$(NLX_TAR):
ifeq "$(wildcard $@ )" ""
	@$(OUTPUT_DATE)
	$(info ########################)
	$(info #### Wget Newlib... ####)
	$(info ########################)
	$(MKDIR) $(TAR_DIR)
	$(WGET) $(NLX_URL) --output-document $(TAR_DIR)/$(NLX_TAR)
endif

$(NLX_DIR)/configure.ac: $(TAR_DIR)/$(NLX_TAR)
ifeq "$(wildcard $@ )" ""
	$(info ###########################)
	$(info #### Extract Newlib... ####)
	$(info ###########################)
	#note: NLX:$(NLX) NLX_DIR:$(NLX_DIR) NLX_TAR:$(NLX_TAR) NLX_TAR_DIR:$(NLX_TAR_DIR)
	$(UNTAR) $(TAR_DIR)/$(NLX_TAR) -C $(SOURCE_DIR)
    ifeq (,$(findstring $(NLX_TAR_DIR),$(NLX_DIR)))
		$(MKDIR) $(NLX_DIR)
		$(MOVE) $(NLX_TAR_DIR)/* $(NLX_DIR)
		@rm -r $(NLX_TAR_DIR)
    endif
	@touch $@
endif

$(BUILD_NLX_DIR): $(NLX_DIR)/configure.ac
	@$(OUTPUT_DATE)
	$(info #########################)
	$(info #### Build Newlib... ####)
	$(info #########################)
	@$(MAKE_OPT) newlib_patch $(SILENT)
	$(MKDIR) $(BUILD_NLX_DIR)
	@cd $(BUILD_NLX_DIR) && PATH="$(TOOLCHAIN)/bin:$(SAFEPATH)" ../$(CONF_OPT) --prefix=$(TOOLCHAIN) --target=$(TARGET) $(NLX_OPT) $(SILENT)
	@cd $(BUILD_NLX_DIR) && PATH="$(TOOLCHAIN)/bin:$(SAFEPATH)" CROSS_CFLAGS="-DSIGNAL_PROVIDED -DABORT_PROVIDED -DMALLOC_PROVIDED" $(MAKE_OPT) all $(SILENT)
	@rm -f $(TARGET)/.installed-newlib
	@PATH="$(TOOLCHAIN)/bin:$(SAFEPATH)" $(MAKE_OPT) -C $(BUILD_NLX_DIR) $(SILENT)
	@touch $@

$(TARGET)/.installed-newlib: $(BUILD_NLX_DIR)
	@$(OUTPUT_DATE)
	$(info ###########################)
	$(info #### Install Newlib... ####)
	$(info ###########################)
	@PATH="$(TOOLCHAIN)/bin:$(SAFEPATH)" $(MAKE_OPT) $(INST_OPT) -C $(BUILD_NLX_DIR) $(SILENT)
	@touch $@

$(NLX_DIR): $(BUILD_NLX_DIR) $(TARGET)/.installed-newlib
	@cp -p $(TOOLCHAIN)/bin/$(XGCC) $(TOOLCHAIN)/bin/$(XCC)
	@touch $@

#************** Libhal (Hardware Abstraction Library for Xtensa LX106)
$(TAR_DIR)/$(HAL)-$(HAL_TAR):
ifeq "$(wildcard $@ )" ""
	@$(OUTPUT_DATE)
	$(info ########################)
	$(info #### Wget Libhal... ####)
	$(info ########################)
	$(MKDIR) $(TAR_DIR)
	$(WGET) $(HAL_URL)/$(HAL_TAR) --output-document $(TAR_DIR)/$(HAL)-$(HAL_TAR)
endif

$(HAL_DIR)/configure.ac: $(TAR_DIR)/$(HAL)-$(HAL_TAR)
ifeq "$(wildcard $@ )" ""
	$(info ###########################)
	$(info #### Extract Libhal... ####)
	$(info ###########################)
	$(UNTAR) $(TAR_DIR)/$(HAL)-$(HAL_TAR) -C $(SOURCE_DIR)
	$(RMDIR) $(HAL_DIR) $(SILENT)
	$(MOVE) $(HAL_DIR)-*/ $(HAL_DIR)
	@touch $@
endif

$(BUILD_HAL_DIR): $(HAL_DIR)/configure.ac
	@$(OUTPUT_DATE)
	$(info #########################)
	$(info #### Build Libhal... ####)
	$(info #########################)
	@cd $(HAL_DIR); autoreconf -i $(SILENT)
	$(MKDIR) $(BUILD_HAL_DIR)
	@cd $(BUILD_HAL_DIR); PATH="$(TOOLCHAIN)/bin:$(SAFEPATH)" ../$(CONF_OPT) --host=$(TARGET) --prefix=$(TOOLCHAIN)/$(TARGET) $(SILENT)
	@rm -f $(TARGET)/.installed-libhal
	@PATH="$(TOOLCHAIN)/bin:$(SAFEPATH)" $(MAKE_OPT) -C $(BUILD_HAL_DIR) $(SILENT)
	@touch $@

$(TARGET)/.installed-libhal: $(BUILD_HAL_DIR)
	@$(OUTPUT_DATE)
	$(info ###########################)
	$(info #### Install Libhal... ####)
	$(info ###########################)
	@PATH="$(TOOLCHAIN)/bin:$(SAFEPATH)" $(MAKE_OPT) $(INST_OPT) -C $(BUILD_HAL_DIR) $(SILENT)
	@touch $@

$(HAL_DIR): $(BUILD_HAL_DIR) $(TARGET)/.installed-libhal
	@cp -p $(TOOLCHAIN)/bin/$(XGCC) $(TOOLCHAIN)/bin/$(XCC)
	@touch $@

#************** GDB (The GNU debugger)
$(TAR_DIR)/$(GDB_TAR):
ifeq ($(GDB),y)
    ifeq "$(wildcard $@ )" ""
		@$(OUTPUT_DATE)
		$(info #####################)
		$(info #### Wget GDB... ####)
		$(info #####################)
		$(MKDIR) $(TAR_DIR)
		$(WGET) $(GNU_URL)/gdb/$(GDB_TAR) --output-document $(TAR_DIR)/$(GDB_TAR)
    endif
endif

$(GDB_DIR)/configure.ac: $(TAR_DIR)/$(GDB_TAR)
ifeq ($(GDB),y)
    ifeq "$(wildcard $@ )" ""
		@$(OUTPUT_DATE)
		$(info ########################)
		$(info #### Extract GDB... ####)
		$(info ########################)
		$(MKDIR) $(GDB_DIR)
		@$(UNTAR) $(TAR_DIR)/$(GDB_TAR) -C $(SOURCE_DIR)
		@touch $@
    endif
endif

$(BUILD_GDB_DIR): $(GDB_DIR)/configure.ac
ifeq ($(GDB),y)
	@$(OUTPUT_DATE)
	$(info ######################)
	$(info #### Build GDB... ####)
	$(info ######################)
	@$(MAKE_OPT) gdb_patch $(SILENT)
	$(MKDIR) $(BUILD_GDB_DIR)
	@chmod -R 777 $(GDB_DIR)
	@cd $(BUILD_GDB_DIR); ../$(CONF_OPT) --prefix=$(TOOLCHAIN) --target=$(TARGET) $(GDB_OPT) $(SILENT)
	@rm -f $(TARGET)/.installed-gdb
	@$(MAKE_OPT) -C $(BUILD_GDB_DIR) $(SILENT)
	@touch $@
endif

$(TARGET)/.installed-gdb: $(GDB_BUILD_DIR)
ifeq ($(GDB),y)
	@$(OUTPUT_DATE)
	$(info ########################)
	$(info #### Install GDB... ####)
	$(info ########################)
	@$(MAKE_OPT) $(INST_OPT) -C $(BUILD_GDB_DIR) $(SILENT)
	@touch $@
endif

$(GDB_DIR): $(BUILD_GDB_DIR) $(TARGET)/.installed-gdb
ifeq ($(GDB),y)
	@touch $@
endif

#************** Strip Debug
strip:
ifeq ($(STRIP),y)
	@$(OUTPUT_DATE)
	$(info #######################)
	$(info ###### stripping ######)
	$(info #######################)
	@du -sh $(TOOLCHAIN)/bin
	-@find $(TOOLCHAIN) -maxdepth 2 -type f -perm /0111 -exec strip -s "{}" +
	@du -sh $(TOOLCHAIN)/bin
endif

#************** Compress via UPX
compress:
ifeq ($(COMPRESS),y)
	@$(OUTPUT_DATE)
	$(info #######################)
	$(info ##### compressing #####)
	$(info #######################)
	@du -sh $(TOOLCHAIN)/bin
	-@find $(TOOLCHAIN) -maxdepth 2 -type f -perm /0111 -exec upx -q -1 "{}" +
	@$(OUTPUT_DATE)
	@du -sh $(TOOLCHAIN)/bin
endif

#*******************************************
#*******************************************
#*******************************************

#*******************************************
#************** clean section **************
#*******************************************
clean: clean-sdk clean-build

clean-build:
	$(info ######## clean ########)
	-rm -rf $(TOOLCHAIN) $(MLIB_DIR)/ $(BUILD_GMP_DIR) $(BUILD_MPFR_DIR) $(BUILD_MPC_DIR) $(BUILD_BIN_DIR)
	-rm -rf $(BUILD_GCC_DIR)-pass-1 $(BUILD_NLX_DIR) $(BUILD_GCC_DIR)-pass-2 $(BUILD_HAL_DIR) $(BUILD_GDB_DIR)
	-rm -f $(MLIB_DIR).installed-* $(TARGET)/.installed-*

clean-sdk:
	$(info ###### clean-sdk ######)
	-rm -rf $(TOP_SDK)
	-$(MAKE) -C $(LWIP_DIR) -f Makefile.open clean

purge: clean
	$(info ######## purge ########)
	-rm -rf $(GMP_DIR) $(MPFR_DIR) $(MPC_DIR) $(BIN_DIR)
	-rm -rf $(GCC_DIR) $(NLX_DIR) $(HAL_DIR) $(GDB_DIR)
	#rm -rf $(TAR_DIR)/*.{zip,bz2,xz,gz}
