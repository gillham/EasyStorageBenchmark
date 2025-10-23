
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

main {
    const uword data = $1f00    ; $1f00 - $9f00 = 32KB

    const ubyte MIN_DRIVE = 8
    const ubyte MAX_DRIVE = 30

    ; C64 colors
    const ubyte COLOR_BLACK = 0
    const ubyte COLOR_WHITE = 1
    const ubyte COLOR_RED = 2
    const ubyte COLOR_CYAN = 3
    const ubyte COLOR_PURPLE = 4
    const ubyte COLOR_GREEN = 5
    const ubyte COLOR_BLUE = 6
    const ubyte COLOR_YELLOW = 7
    const ubyte COLOR_ORANGE = 8
    const ubyte COLOR_BROWN = 9
    const ubyte COLOR_LIGHT_RED = 10
    const ubyte COLOR_DARK_GRAY = 11
    const ubyte COLOR_MEDIUM_GRAY = 12
    const ubyte COLOR_LIGHT_GREEN = 13
    const ubyte COLOR_LIGHT_BLUE = 14
    const ubyte COLOR_LIGHT_GRAY = 15

    ; UI colors
    const ubyte COLOR_BORDER = COLOR_BLACK
    const ubyte COLOR_SCREEN = COLOR_BLUE
    const ubyte COLOR_TEXT = COLOR_WHITE
    const ubyte COLOR_TITLE = COLOR_LIGHT_GREEN
    const ubyte COLOR_DRIVE = COLOR_YELLOW
    const ubyte COLOR_KEYS = COLOR_LIGHT_GRAY
    const ubyte COLOR_MENU = COLOR_TEXT
    const ubyte COLOR_RESULTS = COLOR_CYAN

    str title = "Easy Storage Benchmark X16"
    const ubyte title_start = (40 - len(title)) / 2

    sub start() {
        ubyte key

        txt.color2(COLOR_TEXT, COLOR_SCREEN)
        ;c64.EXTCOL = COLOR_BORDER
        ;c64.BGCOL0 = COLOR_SCREEN

        txt.lowercase()
        copychars()
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

