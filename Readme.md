# Nucleo-F446RE-From-Scratch
## Prerequisites
Test on Ubuntu 22.04 distribution.
### Toolchain
```bash
$ sudo apt install build-essential cmake gdb-multiarch lcov make
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
### Emulator
Download the package from Renode github repository.
```bash
$ mkdir renode
$ tar xf renode-*.linux-portable.tar.gz -C renode --strip-components=1
$ cd renode
$ export PATH="`pwd`:$PATH"
$ renode --version
$ pip3 install -r tests/requirements.txt
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
$ gdb-multiarch --tui build/firmware_Debug.elf
(gdb) target extended-remote localhost:3333
(gdb) monitor reset halt
(gdb) load
(gdb) break main
(gdb) next # Debug line per line
(gdb) continue
```
## Use emulator
```bash
$ renode config/nucleo-f446re.resc
(machine-0) logFile @/tmp/function-trace.log
(machine-0) logLevel -1
(machine-0) machine StartGdbServer 3333
(machine-0) start
(machine-0) pause
(machine-0) sysbus.cpu PC
(machine-0) sysbus.cpu LogFunctionNames true
(machine-0) machine GetTimeSourceInfo
(machine-0) machine EnableProfiler
(machine-0) quit
```
```bash
$ gdb-multiarch
(gdb) target extended-remote localhost:3333
(gdb) file bin/firmware_Debug.elf
(gdb) load
(gdb) monitor start
(gdb) monitor halt
(gdb) continue
```
## Build test suite
```bash
$ cmake -B build/Test -DCMAKE_BUILD_TYPE=Test
$ cmake --build build/Test
$ ctest -V --test-dir build/Test # Run all tests with verbose output
```
## Show code coverage
Need build test suite before code coverage generation.
```bash
$ cmake --build build/Test --target coverage # Generate code coverage report
```
