# Nucleo-F446RE-From-Scratch
## Prerequisites
Test on Ubuntu 22.04 distribution.
### Toolchain
```bash
$ sudo apt install build-essential cmake gdb-multiarch lcov make qemu qemu-system-arm
```
Download the package from [ARM-Website](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads) (need 13.2rel1 version).
```bash
$ tar -xf arm-gnu-toolchain-13.2.rel1-x86_64-arm-none-eabi.tar.xz
$ arm-gnu-toolchain-13.2.Rel1-x86_64-arm-none-eabi/bin
$ echo export PATH="\$PATH:arm-gnu-toolchain-13.2.Rel1-x86_64-arm-none-eabi/bin" >> .bashrc
$ source ./bashrc
$ arm-none-eabi-gcc --version
```
Download the package from Openocd github repository (need 0.12.0 version).
```bash
$ git clone git://git.code.sf.net/p/openocd/code openocd
$ cd openocd
$ git checkout v0.12.0
$ git submodule update --init
$ sudo apt install autoconf automake libtool libusb-1.0-0 libusb-1.0-0-dev make pkg-config texinfo
$ ./bootstrap
$ ./configure
$ sudo make install
$ openocd --version
```
## Build the firmware
```bash
$ cmake -B build/<Debug or Release> -DCMAKE_BUILD_TYPE=<Debug or Release> # Create workspace
$ cmake --build build/<Debug or Release> # Build
$ cmake --build build/<Debug or Release> -t clean # Clean
```
## Display assembler code
```bash
$ arm-none-eabi-objdump -D bin/firmware_<Debug or Release>.elf
```
## Flash the firmware
```bash
$ openocd -f config/nucleo-f446re.cfg -c "setup" -c "program_release bin/firmware_<Debug or release>.elf"
```
## Open a debug session
```bash
$ openocd -f config/nucleo-f446re.cfg -c "setup" -c "program_debug bin/firmware_Debug.elf"
```
```bash
$ gdb-multiarch bin/firmware_Debug.elf
(gdb) target extended-remote localhost:3333
(gdb) monitor reset halt
(gdb) load
(gdb) break main
(gdb) next # Debug line per line
(gdb) continue
```
## Emulator with Qemu
```bash
$ qemu-system-arm -cpu cortex-m3 -machine stm32vldiscovery -gdb tcp::3333 -S -nographic -semihosting -kernel bin/firmware_Debug.elf
```
Then, open a debug session.
