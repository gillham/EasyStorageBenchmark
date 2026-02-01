#
# Simple Makefile for a Prog8 program.
#

# Cross-platform removal command
ifeq ($(OS),Windows_NT)
    CLEAN = del /Q build\* 
    CP = copy
    RM = del /Q
    MD = mkdir
else
    CLEAN = rm -f build/*
    CP = cp -p
    RM = rm -f
    MD = mkdir -p
endif

# disk image settings
DISKTYPE=d64
DISKNAME=esb
DISK=build/$(DISKNAME).$(DISKTYPE)

# Emulator settings
EMU_CMD=x64sc
EMU_CMD128=x128
EMU_BASE=-default -keymap 1 -model ntsc
EMU_DISK08=-8 $(DISK) -drive8type 1542
EMU_DISK10=-fs10 build -devicebackend10 1 -busdevice10 -trapdevice10
EMU_DISK=$(EMU_DISK08) $(EMU_DISK10)
#EMU_KERNAL=-kernal jiffykernal
EMU_KERNAL=
EMU_REUSIZE=256
EMU_REU=-reu -reusize $(EMU_REUSIZE)
EMU=$(EMU_CMD) $(EMU_BASE) $(EMU_KERNAL) $(EMU_DISK) $(EMU_DOS) $(EMU_REU)
EMUIDE=$(EMU_CMD) $(EMU_BASE) $(EMU_KERNAL) $(EMU_CART) $(EMU_DISK08) $(EMU_DISK12) $(EMU_REU)
EMU128=$(EMU_CMD128) $(EMU_BASE) $(EMU_KERNAL) $(EMU_DISK) $(EMU_REU)
#EMUPET=xpet -keymap 1 -model 4032 $(EMU_DISK)
EMUPET=xpet -model 4032 $(EMU_DISK)

PCC?=prog8c
PCCARGSC64=-srcdirs src:src/c64 -asmlist -target c64 -out build
PCCARGSC128=-srcdirs src:src/c128 -asmlist -target c128 -out build
PCCARGSX16=-srcdirs src:src/cx16 -asmlist -target cx16 -out build
PCCARGSPET32=-srcdirs src:src/pet32 -asmlist -target pet32 -out build

PROGS		= build/esb64.prg build/esbx16.prg
SRCSC64		= src/esb64.p8 src/esbcore.p8 src/c64/platform.p8
SRCSX16		= src/esbx16.p8 src/esbcore.p8 src/cx16/platform.p8
SRCSPET32	= src/esbpet.p8 src/esbcore.p8 src/pet32/platform.p8

all: $(PROGS)

builddir:
ifeq ($(wildcard build),)
	$(MD) build
	@echo "Created build directory."
endif

build/esb64.prg: $(SRCSC64) | builddir
	$(PCC) $(PCCARGSC64) $<

build/esbx16.prg: $(SRCSX16) | builddir
	$(PCC) $(PCCARGSX16) $<

build/esbpet.prg: $(SRCSPET32) | builddir
	$(PCC) $(PCCARGSPET32) $<

clean:
	$(CLEAN)

disk: build/esb64.prg build/esbpet.prg build/esbx16.prg
	@c1541 -silent on -verbose off -format $(DISKNAME),52 $(DISKTYPE) $(DISK) 
	@c1541 -silent on -verbose off -attach $(DISK) -write $< esb64,p
	@c1541 -silent on -verbose off -attach $(DISK) -write build/esbpet.prg esbpet,p
	@c1541 -silent on -verbose off -attach $(DISK) -write build/esbx16.prg esbx16,p

run: all emu

emu:	disk
	$(EMU)

emuide: disk
	$(EMUIDE)

emu128: disk
	$(EMU128)

emupet: build/esbpet.prg
	$(EMUPET) $<

emux16: build/esbx16.prg
	x16emu -scale 1 -fsroot build/ -prg $< -run

#
# end-of-file
#
