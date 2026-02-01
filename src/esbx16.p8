
%import diskio
%import floats
%import textio
;%zeropage floatsafe
;%zeropage basicsafe
%zeropage dontuse

; critical for IDE64 use!
%option no_sysinit

; cross platform routines
%import esbcore

; platform specific
%import platform

main {
    const uword data = $1f00    ; $1f00 - $9f00 = 32KB

    const ubyte MIN_DRIVE = 8
    const ubyte MAX_DRIVE = 30

    sub start() {
        ubyte key

        txt.color2(COLOR_TEXT, COLOR_SCREEN)
        ;c64.EXTCOL = COLOR_BORDER
        ;c64.BGCOL0 = COLOR_SCREEN

        txt.lowercase()
        copychars()

        ; default to larger blocks
        esb.data_blocks = 16
        esb.data_size = 32768

        esb.drawtitle()
        esb.drawmenu(2)

        esb.drawchunks()
        esb.drawlast()

        diskio.drivenumber = @($0292)
        esb.drawdrive()
        txt.nl()

        repeat {
            void, key = cbm.GETIN()
            if key != $00 {
                esb.dispatch(key)
            }
        }
    }

    sub copychars() {
        ubyte i
        ;const uword ptr = $c000 + 8 * '0' ; start of '0' character in upper/graphics
        const uword ptr = $c400 + 8 * '0' ; start of '0' character in lower/upper

        ; disable interrupts during copy
        sys.set_irqd()

        cx16.push_rombank(6)    ; switch to rom bank with the character sets

        ; map in character rom
        repeat 80 {
            esb.chars[i] = ptr[i]
            i++
        }

        ; restore map
        cx16.pop_rombank()      ; switch to previous rom bank from stack

        ; re-enable interrupts
        sys.clear_irqd()
    }

    uword timer_value
    ; enable / clear / start "timer"
    sub timer_start() {
        cbm.SETTIM(0,0,0)
    }

    ; stop the timer
    sub timer_stop() {
        main.timer_value = cbm.RDTIM16()
    }

}

