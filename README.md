# CynOS v0.1.0

A simple OS primarily developed by 1 person. (Yes, this has a Murder Drones theme)

## Lore
I started this project because after 3 years of doing coding, I haven't got much to show for it other than basic knowledge. Another problem was that for that duration, I've hopped around programming languages without really sticking to one. I have been interested with doing low level programming, so while in my "rust phase" I followed a [guide](https://os.phil-opp.com) but eventually gave up when I got to a point where it became difficult for myself to manage.

I eventually moved onto C, experimenting with it, but like everything before, nothing to show but basic knowledge. So I decided to actually try and make something. [Daedalus Community](https://www.youtube.com/@DaedalusCommunity) got me into the beginning, by teaching how to make a simple bootloader. From there I used my previous knowledge from doing a OS in rust to make a VGA driver, and now here we are.

Ideally, the goal would be to have an OS with a GUI, a good portion of libc, and a custom shell that can execute binarys. From there I would like to create some apps, a C compilier, and maybe some games. Although it will definently take a while, it will certainly be a fun (and frustrating) journey.

So all and all, the main point I'm trying to make is that this OS is mainly a way for me to learn not how to *code*, since I already know how, but rather how to *program*. Feel free to use this OS or it's code however you wish, go make something cool.

## Features
- Bootloader with LBA and CHS disk reading
- VGA text mode driver
- A basic printf implementation
- GDB debugging in vscode

## Building/running
The compiler I use can be installed from this [install script](https://github.com/mell-o-tron/MellOs/tree/main/A_Setup). Then you can just `make` and run it.<br>
If you don't want to compile and only wish to run it, `make run_drive` or `make run_floppy` will just run `./bin/os.bin` in qemu if its installed.

## Next update to-do:
- Get available memory
- Make OS work on real hardware
- Make 64 bit boot option
- Generally just improve the bootloader

## Insperations
These are some of the resources I used to learn how to do OS development:<br>
[MellOS](https://github.com/mell-o-tron/MellOs/tree/main)<br>
[Making an OS](https://www.youtube.com/watch?v=MwPjvJ9ulSc&list=PLm3B56ql_akNcvH8vvJRYOc7TbYhRs19M) Made by the same guy that made MellOS, really good for getting started.<br>
[OSDev Wiki](https://wiki.osdev.org/Expanded_Main_Page)