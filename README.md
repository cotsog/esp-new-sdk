# esp-new-sdk

Makefile to build the toolchain and a complete standalone SDK for Espressif ESP8266.

It was developed for use under Windows on Cygwin.

Under Travis-CI it builds successfully on Linux and as well on MacOS.

Thus it should build successfully on
- Cygwin
- MSYS
- MinGW32
- Linux (maybe LinuxARM)
- MacOS

Install the project in a directory of your choice, for example 'esp-new-sdk'
```bash
  git clone https://github.com/Juppit/esp-new-sdk esp-new-sdk
```

If you like to prepare the build before 'make' you can
- download the sources into the tarballs directory:
```bash
  make get-tars
```
- extract them into there source directories
```bash
  make get-src
```

If you edit the 'Makefile' you can use the following versions
```bash
  xtensa-lx106-elf-sdk:   version 2.1.x down to 1.5.0
```

To build the complete project use the following command:
```bash
  make                  # build all with last versions
                        # configure with or without gdb and lwip
```

To build parts of the project use the following commands:
```bash
  make build-gmp        # version 6.1.2 down to 6.0.0a
  make build-mpfr       # version 3.1.6 down to 3.1.1
  make build-mpc        # version 1.0.3 down to 1.0.1
  make build-binutils   # version 2.26  down to 2.29
  make build-gcc-pass-1 # version 7.2.0 down to 4.8.2
  make build-newlib     # version xtensa
  make build-gcc-pass-2
  make build-gcc-libhal # version lx106-hal
  make build-gdb        # version 8.0.1 down to 7.5.1
  make build-lwip       # version esp-open-lwip
```

To rebuild one of the above parts it should be enough to:
- delete the associated build directory (e.g. esp-new-sdk/src/binutils-2.2.9/build-Cygwin)
- delete the corresponding file <.installed-xxx> in the directory 'xtensa-lx106-elf'
- for math libraries delete <.installed-xxx> in the directory 'math_libs'.

Note: build directories are named after the operating system, for example 'build-Cygwin'

To clean the build system use the following commands:
```bash
  make clean            # removes all build directories and <.installed-xxx> marker
  make purge            # removes additionally the source directories
```
