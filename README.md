# Easy Storage Benchmark

Easy Storage Benchmark (ESB) is tool to test the performance of various storage devices on Commodore 64 or Commander X16 computers.

ESB is written in [Prog8](https://github.com/irmen/prog8) a high-level language for 6502 based computers.

Currently two platforms are supported; Commodore 64 and Commander X16.  Additional platforms Like Commodore 128 or VIC-20 as well as Mega65 will be added at some point.

ESB uses the kernal load & save routines and should work with any devices where those work properly.

## Usage

Download `esb64.prg` or `esbx16.prg` from the [release](./release/) directory.
There is also `esb.d64` which can be attached to VICE or used on an SD2IEC etc.

Run on a C64 with:
```
LOAD"ESB64",8
RUN
```

Or on Commander X16:
```
LOAD"ESBX16"
RUN
```

Keys:
 - F1: Increase device number
 - F3: Decrease device number
 - F5: Execute SAVE test on current device
 - F7: Execute LOAD test on current device (run SAVE test first to create files)
 - F8: Show a log of LOAD/SAVE tests with device numbers and chunks / size.
 - '+': Increase number of size / quantity of chunks SAVEd or LOADed.
 - '-': Decrease number of size / quantity of chunks SAVEd or LOADed.
 - Ctrl-X: exit

## Commodore 64 (& Commodore 128 in GO64 mode)

Hardware known to work on C64:
 - VICE 1541, CMD HD, IDE64
 - Real 1541, CMD HD, IDE64

Here are a couple of screenshots of ESB64 in action on the VICE emulator.

Launch screen:
![ESB64 Screenshot](images/esb64-launch.png)

After doing a save:
![ESB64 Save](images/esb64-save.png)

After doing a load:
![ESB64 Load](images/esb64-load.png)

Showing the log after several tests:
![ESB64 Log](images/esb64-log.png)


ESB64 works less reliably with the VICE host file-system.  This is a known issue with VICE and/or Prog8 where results are inconsistent or hang.  Since ESB is meant for benchmarking real hardware it shouldn't be a big issue, but keep it in mind when testing with VICE.  Hopefully I'll figure out a way to workaround the issues eventually, but for now realize it isn't reliable.

After doing a save/load to a VICE host file-system on device 10:
![ESB64 HOSTFS](images/esb64-hostfs.png)


## Commander X16 (& OtterX)

Hardware known to work on X16:
 - x16emu sd card and hostfs
 - Real hardware SD card
 - Real hardware IEC port (with some caveats)

Here are a couple of screenshots of ESBX16 in action on the X16 emulator.

Launch screen:
![ESBX16 Screenshot](images/esbx16-launch.png)


After doing a save & load:
![ESBX16 Load](images/esbx16-load.png)
