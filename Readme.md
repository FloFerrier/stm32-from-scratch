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
$ gdb-multiarch --tui bin/firmware_Debug.elf
(gdb) target extended-remote localhost:3333
(gdb) monitor reset halt
(gdb) load
(gdb) break main
(gdb) step
(gdb) next
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

## Code profiling
### Memory mapping
To display section memory footprint:
```bash
$ find -iname "*.elf"
$ arm-none-eabi-size -A -x /path-to-find-firmware.elf
../path-to-find-firmware.elf:
section             size         addr
.isr_vector         0x2c    0x8000000
.text              0x118    0x800002c
.init                0x4    0x8000144
.fini                0x4    0x8000148
.rodata              0x0    0x800014c
.bss                 0x4   0x20000000
.data                0x0   0x20000004
.stack             0x604   0x20000004
.ARM.attributes     0x30          0x0
.comment            0x44          0x0
.debug_info        0x57f          0x0
.debug_abbrev      0x340          0x0
.debug_loclists     0xb6          0x0
.debug_aranges      0xb0          0x0
.debug_rnglists     0x7c          0x0
.debug_line        0x689          0x0
.debug_str         0x38f          0x0
.debug_frame        0xf0          0x0
Total             0x1d71
```
Add linker flag ***-Wl,--print-memory-usage*** to display this :
```bash
Memory region         Used Size  Region Size  %age Used
             RAM:        1544 B       128 KB      1.18%
             ROM:         332 B       512 KB      0.06%
```
To have more detail, need generate map file on compilation with linker flag ***-Wl,-Map=output.map,--cref***.
```bash
$ find -iname "output.map"
```
This file is illisible for human, so you can use **fpvgcc** to display infos :
```bash
$ pip3 install fpvgcc
$ fpvgcc --sar /path-to-find/output.map
+----------------+-----+-----+-----+-------+
| FILE           | VEC | ROM | RAM | TOTAL |
+----------------+-----+-----+-----+-------+
| startup.c.obj  |     | 136 | 512 |   648 |
| user_led.c.obj |     | 104 |     |   104 |
| delay.c.obj    |     |  48 |   4 |    52 |
| main.c.obj     |     |  36 |     |    36 |
| crti.o         |     |   8 |     |     8 |
| TOTALS         |   0 | 332 | 516 |       |
+----------------+-----+-----+-----+-------+
```
Or with **puncover**
```bash
$ pip3 install puncover
$ puncover --elf-file /path-to-find-firmware.elf
```
Open a browser to see code source.

### Function Timing
#### Prerequisites
Download code source from Orbuculum github repository.
```bash
$ mkdir Orbuculum
$ sudo apt install libusb-1.0-0 libusb-1.0-0-dev libczmq-dev libelf-dev libcapstone-dev libsdl2-2.0-0 libsdl2-dev libncurses-dev meson ncurses-base ninja-build pkg-config
$ tar xf orbuculum-2.1.0.tar.gz -C .
$ cd orbuculum-2.1.0
$ meson setup build
$ ninja -C build
$ echo "export PATH=\$PATH:Orbuculum/orbucul-2.1.0/build" >> .bashrc
$ source ./bashrc
$ orbuculum --version
```
And need to build on Debug mode for using SWV.
#### PC Sampling information
Open a debug session with the hardware:
```bash
$ openocd -f config/nucleo-f446re.cfg -c "setup" -c "program_debug bin/firmware_Debug.elf"
```
Open gdb and as follow:
```bash
$ gdb-multiarch --tui bin/firmware_Debug.elf
(gdb) target extended-remote localhost:3333
(gdb) monitor reset halt
(gdb) load
(gdb) monitor mww 0xE0001000 0x17ff # PC Sampling enable
(gdb) continue
```
Finally, to have PC Sampling information with Orbuculum tool:
```bash
$ orbtop -s localhost:3443 -e bin/firmware_Debug.elf
```