## v0.2.0: The Bootloader of the Absolute Kernel

Get snuck-up on!<br>
I apologize for the radio silence, but I am finally here to deliver on what I said 5 months ago. School has been pretty rough, but this break has given me the perfect opportunity to finish up on the update. Feel free to let me know your thoughts!

### New features:
- 64 bit support
- Paging
- Bootloader creates memory map (count at 0x5000, map starts at 0x5004)
- Added halt loop in the kernel
- Prints out all colors

### Bug fixes:
- Fixed stack address of bootloader, so it can now run on hardware
- Fixed the `new_line` function in the vga text mode driver

### Refactored:
- Reformatted directory structure and makefile
- Changed compiler from i386-elf-gcc to x86_64-elf-gcc from homebrew
- Merged `new_line` procedure into `print` procedure in the bootloader
- Made bootloader code more modular
- Reformatted code to make it more c-like

### Removed:
- Removed `init_text_vga()`
- Excluded `memory.map` from repo, still created when compiled
- Removed comments from bootloader, opting for writing readable code instead

## v0.1.0: BOOTING UP // EXPOSITION_
- Created repo for CynOS.
