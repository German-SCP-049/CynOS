# CynOS v0.2.0

CynOS is a x86/x64 general purpose operating system, written in C and Assembly. The goal is to eventually make it a daily driver intended for small devices (or whatever you wish to be infected with Cyn.) Currently being programmed and maintained exclusively by [SCP-049](https://github.com/German-SCP-049), to use as a learning experience and practice, as well as being a fun side project.

Check out `changelog.md` for new features / history!

## Features
- 32/64 bit support
- Bootloader
- VGA text mode driver
- Paging

## Building/running
In order to build and run CynOS, you'll need 2 main things<br>
- [x86_64-elf-gcc](https://formulae.brew.sh/formula/x86_64-elf-gcc)
- QEMU<br>

To compile and run, all you have to do is type `make` in the terminal. If however you want to compile the 32 bit version, go into the `Makefile` on line 13 and change x86_64 from true to false. (Make sure to `make clean` before you recompile for 32 bits!)
```makefile
# set to false to compile and run 32 bit code
x86_64 := true
```

If you want to just run the binaries in QEMU, enter `qemu-system-x86_64 -drive format=raw,file=./bin/CynOS64.bin` or `qemu-system-i386 -drive format=raw,file=./bin/CynOS32.bin` to try out the 64 and 32 bit binaries respectively.

## Next update to-do:
- Interrupt handling
- Keyboard driver
- Heap allocation

## Inspirations
These are some of the resources I used to learn how to do OS development:<br>
[MellOS](https://github.com/mell-o-tron/MellOs/tree/main)<br>
[Making an OS](https://www.youtube.com/watch?v=MwPjvJ9ulSc&list=PLm3B56ql_akNcvH8vvJRYOc7TbYhRs19M) Made by the same guy that made MellOS, really good for getting started.<br>
[OSDev Wiki](https://wiki.osdev.org/Expanded_Main_Page)<br>
[The Holy Intel Manual](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html)<br>
The good people in the osdev discord
