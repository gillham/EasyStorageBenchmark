
%import diskio
%import floats
%import textio
;%zeropage floatsafe
;%zeropage basicsafe
%zeropage dontuse

; critical for IDE64 use!
;%option no_sysinit

; core functions
%import esbcore

; platform specific
%import platform

main {
    const uword data = $5000

    const ubyte MIN_DRIVE = 8
    const ubyte MAX_DRIVE = 30

    sub start() {
        ubyte key

;        txt.color(COLOR_TEXT)

        txt.lowercase()
        copychars()
        esb.drawtitle()
        esb.drawmenu(2)

        esb.drawchunks()
        esb.drawlast()

        diskio.drivenumber = @($d4)
        esb.drawdrive()
        txt.nl()

        repeat {
            void, key = cbm.GETIN()
            if key != $00 {
                esb.dispatch(key)
                ; debug
                ;txt.print_ubhex(key, true)
            }
        }
    }

    ; copy characters for numbers from the rom font
    sub copychars() {
        ubyte i
        ubyte[] chars = [   $3c,$66,$6e,$76,$66,$66,$3c,$00,
                            $18,$18,$38,$18,$18,$18,$7e,$00,
                            $3c,$66,$06,$0c,$30,$60,$7e,$00,
                            $3c,$66,$06,$1c,$06,$66,$3c,$00,
                            $06,$0e,$1e,$66,$7f,$06,$06,$00,
                            $7e,$60,$7c,$06,$06,$66,$3c,$00,
                            $3c,$66,$60,$7c,$66,$66,$3c,$00,
                            $7e,$66,$0c,$18,$18,$18,$18,$00,
                            $3c,$66,$66,$3c,$66,$66,$3c,$00,
                            $3c,$66,$66,$3e,$06,$66,$3c,$00]

        ; copy?  switch to pointer.
        repeat 80 {
            esb.chars[i] = chars[i]
            i++
        }
    }

    ; timer related
    uword timer_value

    ; reset jiffie clock to zero
    sub timer_start() {
        sys.set_irqd()
        cbm.TIME_HI = 0
        cbm.TIME_MID = 0
        cbm.TIME_LO = 0
        sys.clear_irqd()
    }

    ; collect jiffie clock value
    sub timer_stop() {
        sys.set_irqd()
        timer_value = mkword(cbm.TIME_MID, cbm.TIME_LO)
        sys.clear_irqd()
    }

}

