
%import diskio
%import floats
%import textio
;%zeropage floatsafe
;%zeropage basicsafe
%zeropage dontuse

; critical for IDE64 use!
%option no_sysinit

; core functions
%import esbcore

main {
    const uword data = $5000

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

    str title = "Easy Storage Benchmark 64"
    const ubyte title_start = (40 - len(title)) / 2

    ; cia2 timera registers
    &uword timer2a      = $dd04
    &ubyte timer2a_lo   = $dd04
    &ubyte timer2a_hi   = $dd05
    &ubyte timer2actl   = $dd0e

    ; cia2 timerb registers
    &uword timer2b      = $dd06
    &ubyte timer2b_lo   = $dd06
    &ubyte timer2b_hi   = $dd07
    &ubyte timer2bctl   = $dd0f

    sub start() {
        ubyte key

        txt.color(COLOR_TEXT)
        c64.EXTCOL = COLOR_BORDER
        c64.BGCOL0 = COLOR_SCREEN

        txt.lowercase()
        copychars()
        esb.drawtitle()
        esb.drawmenu(2)

        esb.drawchunks()
        esb.drawlast()

        ; this is needed to get a jiffy clock from timer2b
        timer2a_start()

        diskio.drivenumber = @($ba)
        esb.drawdrive()
        txt.nl()

        repeat {
            void, key = cbm.GETIN()
            if key != $00 {
                esb.dispatch(key)
            }
        }
    }

    ; copy characters for numbers from the rom font
    sub copychars() {
        ubyte i
        ubyte previous = @($01)
        const uword ptr = $d800 + 8 * '0' ; start of '0' character

        ; disable interrupts during copy
        sys.set_irqd()

        ; map in character rom
        @($01) = @($01) & %11111011
        repeat 80 {
            esb.chars[i] = ptr[i]
            i++
        }

        ; restore map
        @($01) = previous

        ; re-enable interrupts
        sys.clear_irqd()
    }

    ; timer related
    uword timer_value

    ; enable / clear / start cia2 timerb
    ; timerB ticks when timerA reaches 0
    sub timer_start() {
        timer2bctl = %00000000
        timer2b = $ffff
        ;timer2b_hi = $ff
        timer2bctl = %01000001
    }

    ; stop the timer
    sub timer_stop() {
        timer2bctl = %00000000
        timer_value = 65535 - timer2b
    }

    ; *required* to get 1/60th jiffies from timer2b
    ; enable / clear / start cia2 timerA
    sub timer2a_start() {
        timer2actl = %00000000
        ;timer2a = $ffff
        ; should fire ~60 times per second
        timer2a = 17045
        timer2actl = %00000001
    }

}

