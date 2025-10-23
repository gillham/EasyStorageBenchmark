
%import diskio
%import floats
%import textio
;%zeropage floatsafe
;%zeropage basicsafe
%zeropage dontuse

; not needed as a module?
;%zeropage dontuse
; critical for IDE64 use!
;%option no_sysinit

esb {
    const uword data = $1f00 ; $1f00 - $9f00 = 32KB

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

    str data_file = "esbdata0.bin"
    uword data_size = 8192
    ubyte data_blocks = 1   ; single 8KB chunk for testing.

    ubyte[80] chars

    ; timing
    ;uword total_time = 0
    uword total_time2 = 0   ; debug
    float seconds = 0
    float bytes_sec = 0

    ; performance
    float last_read = 0
    float last_write = 0

    ; results log
    const ubyte LOG_MAX = 23
    ubyte log_index = 0
;    ubyte log_start = 1
    ubyte[LOG_MAX] log_device
    ubyte[LOG_MAX] log_chunks
    uword[LOG_MAX] log_jiffies
    bool[LOG_MAX]  log_read
    float[LOG_MAX] log_speed

    sub clearbottom() {
        ubyte i
;        txt.plot(0,16)
;        return
        for i in 16 to 23 {
            txt.plot(0,i)
            repeat 40 {
                txt.spc()
            }
        }
        txt.plot(0,16)
    }

    sub dispatch(ubyte key) {
        when key {
            $85 -> {
                diskio.drivenumber--
                if diskio.drivenumber < MIN_DRIVE
                    diskio.drivenumber = MAX_DRIVE
                drawdrive()
            }
            $86 -> {
                diskio.drivenumber++
                if diskio.drivenumber > MAX_DRIVE
                    diskio.drivenumber = MIN_DRIVE
                drawdrive()
            }
            $87 -> {
                ;writetest()
                cleanfiles()
                savetest()
            }
            $88 -> {
                ;readtest()
                loadtest()
            }
            $8c -> {
                results()
            }
            $2b, $3d -> {
                if data_blocks < 16
                    data_blocks++
                if data_blocks <= 2
                    data_size = 8192
                if data_blocks > 2 and data_blocks < 5
                    data_size = 16384
                if data_blocks >= 5
                    data_size = 32768
                drawchunks()
            }
            $2d -> {
                if data_blocks > 1
                    data_blocks--
                if data_blocks <= 2
                    data_size = 8192
                if data_blocks > 2 and data_blocks < 5
                    data_size = 16384
                if data_blocks >= 5
                    data_size = 32768
                drawchunks()
            }
            $18 -> {
                txt.plot(0,20)
                sys.exit(0)
            }
            else -> {
                clearbottom()
                txt.print("KEY: ")
                txt.print_ubhex(key, true)
                txt.nl()
            }
        }
    }

    ;
    ; calculates file size in KB.
    ;
    sub drawchunks() {
        txt.plot(2, 10)
        txt.print("File size: ")
        txt.color(COLOR_RESULTS)
        txt.print_f((data_blocks as float) * (data_size as float) / (1024 as float))
        txt.print("KB")
        txt.spc()
        txt.spc()
        txt.color(COLOR_TEXT)
    }

    sub drawdrive() {
        txt.plot(24, 6)
        txt.color(COLOR_LIGHT_RED)
        txt.print("-= D R I V E =-")
        txt.color(COLOR_DRIVE)
        drawnumber(diskio.drivenumber/10, 23, 8)
        drawnumber(diskio.drivenumber % 10, 32, 8)
        txt.color(COLOR_TEXT)
    }

    sub drawlast() {

        ; clear old information
        txt.plot(0, 12)
        repeat 21
            txt.spc()
        txt.plot(0, 13)
        repeat 21
            txt.spc()

        ; read performance
        txt.plot(2, 12)
        txt.print(" Read Bps: ")
        txt.color(COLOR_RESULTS)
        txt.print_f(last_read)
        txt.color(COLOR_TEXT)

        ; write performance
        txt.plot(2, 13)
        txt.print("Write Bps: ")
        txt.color(COLOR_RESULTS)
        txt.print_f(last_write)
        txt.color(COLOR_TEXT)
    }

    sub drawtitle() {
        txt.cls()
        txt.color(COLOR_TITLE)
        txt.plot(main.title_start, 0)
        txt.print(main.title)
        txt.color(COLOR_TEXT)
    }

    sub drawmenu(ubyte row) {

        txt.plot(0, row)
        txt.color(COLOR_KEYS)
        txt.print(" F1")
        txt.color(COLOR_MENU)
        txt.print(": Lower drive number")
        txt.nl()
        txt.color(COLOR_KEYS)
        txt.print(" F3")
        txt.color(COLOR_MENU)
        txt.print(": Higher drive number")
        txt.nl()
        txt.color(COLOR_KEYS)
        txt.print(" F5")
        txt.color(COLOR_MENU)
        txt.print(": Start SAVE test")
        txt.nl()
        txt.color(COLOR_KEYS)
        txt.print(" F7")
        txt.color(COLOR_MENU)
        txt.print(": Start LOAD test")
        txt.nl()
        txt.color(COLOR_KEYS)
        txt.print(" F8")
        txt.color(COLOR_MENU)
        txt.print(": Results log")
        txt.nl()
        txt.color(COLOR_KEYS)
        txt.print(" - ")
        txt.color(COLOR_MENU)
        txt.print(": Smaller file")
        txt.nl()
        txt.color(COLOR_KEYS)
        txt.print(" + ")
        txt.color(COLOR_MENU)
        txt.print(": Larger file")
        txt.nl()

        ; exit keystroke
        txt.plot(26, row)
        txt.color(COLOR_KEYS)
        txt.print("Ctrl-X")
        txt.color(COLOR_MENU)
        txt.print(": exits")

;        txt.plot(26, row+1)
;        txt.color(COLOR_KEYS)
;        txt.print("F8")
;        txt.color(COLOR_MENU)
;        txt.print(": Scoreboard")
;        txt.nl()
        txt.color(COLOR_TEXT)
    }

    sub drawnumber(ubyte number, ubyte col, ubyte row) {
        ubyte i = 0
        ubyte temp
        ubyte index = number * 8

        txt.plot(col, row)

        repeat 8 {
            txt.plot(col, row+i)
            temp = chars[index+i]
            repeat 8 {
                if (temp & %10000000) != 00 {
                    txt.chrout('*')
                } else {
                    txt.chrout(' ')
                }
                temp = temp << 1
            }
            i++
        }
    }

    sub cleanfiles() {
        data_file[7] = '?'
        clearbottom()
        txt.print("Cleaning temp files.")
        diskio.delete(data_file)
        ;repeat 16 {
        ;    if diskio.exists(data_file)
        ;        diskio.delete(data_file)
        ;    data_file[7] += 1
        ;}
    }

    sub loadtest() {
        data_file[7] = 'a'

        clearbottom()
        txt.print("Loading ")
        txt.print_ub(data_blocks)
        txt.print(" chunk(s) of ")
        txt.print_f(data_size as float / 1024)
        txt.print("KB.")
        txt.nl()

        ; debug
        uword result

        ; reset jiffy clock before load
        main.timer_start()

        repeat data_blocks {
            result =  diskio.load(data_file, data)
            data_file[7] += 1
        }

        ; get clock immediately
        main.timer_stop()
        ;total_time = cbm.RDTIM16()
        total_time2 = main.timer_value

;        txt.nl()
;        txt.nl()
;        txt.print("total_time2: ")
;        txt.print_uw(total_time2)
;        txt.spc()
;        sys.wait(180)
;        txt.print_uw(total_time2)
;        txt.nl()

        ; show speed
        ;speed((data_size as float) * (data_blocks as float), total_time, true)
        speed((data_size as float) * (data_blocks as float), total_time2, true)

        drawlast()
        txt.plot(0,23)
        txt.print("LOAD done...")
    }

    sub savetest() {
        data_file[7] = 'a'

        clearbottom()
        txt.print("Saving ")
        txt.print_ub(data_blocks)
        txt.print(" chunk(s) of ")
        txt.print_uw(data_size / 1024)
        txt.print("KB.")
        txt.nl()

        ; reset / start timer before save
        main.timer_start()

        repeat data_blocks {
            void diskio.save(data_file, data, data_size)
            data_file[7] += 1
        }

        ; get clock immediately
        ;total_time = cbm.RDTIM16()
        main.timer_stop()
        total_time2 = main.timer_value

;        txt.nl()
;        txt.nl()
;        txt.print("total_time2: ")
;        txt.print_uw(total_time2)
;        txt.spc()
;        sys.wait(180)
;        txt.print_uw(total_time2)
;        txt.nl()

        ; show speed
        ;speed((data_size as float) * (data_blocks as float), total_time, false)
        speed((data_size as float) * (data_blocks as float), total_time2, false)
        drawlast()
        txt.plot(0,23)
        txt.print("SAVE done, press F7 for LOAD test.")
    }

    sub results() {
        ubyte i = log_index
        txt.cls()
        txt.print("DRIVE CHUNKS ACTION JIFFIES BYTES/SEC\n")
        repeat LOG_MAX {
            if log_device[i] != 0 {
                ;txt.print_ub(i)
                txt.column(2)
                txt.print_ub0(log_device[i])
                ;txt.spc()
                txt.column(9)
                txt.print_ub0(log_chunks[i])
                ;txt.spc()
                txt.column(15)
                if log_read[i]
                    txt.print("LOAD")
                else
                    txt.print("SAVE")
                ;txt.spc()
                txt.column(22)
                txt.print_uw0(log_jiffies[i])
                ;txt.spc()
                txt.column(28)
                txt.print_f(log_speed[i])
                txt.nl()
            }
            i++
            if i>=LOG_MAX
                i=0
        }
        txt.print("PRESS ANY KEY")
        void txt.waitkey()
        ; redraw screen
        txt.cls()
        drawtitle()
        drawmenu(2)
        drawchunks()
        drawlast()
        drawdrive()
    }

    sub speed(float size, uword jiffies, bool read ) {

        txt.plot(1, 18)
        if jiffies == 0 {
            txt.print("0 jiffies, too fast to measure!")
            return
        }
        ;seconds = jiffies as float / 60.0
        seconds = jiffies as float / 60.0   ; calibrate cia1 timerB against jiffy?
        bytes_sec = floats.floor(size / seconds)
        floats.print(seconds)
        txt.print(" seconds")
        txt.nl()
        txt.spc()
        txt.print_f(bytes_sec)
        txt.print(" bytes/sec")
        drawlast()
        ; update results log
        log_device[log_index] = diskio.drivenumber
        log_chunks[log_index] = data_blocks
        log_jiffies[log_index] = jiffies
        log_speed[log_index] = bytes_sec
        if read {
            last_read = bytes_sec
            log_read[log_index] = true
        }
        else {
            last_write = bytes_sec
            log_read[log_index] = false
        }

        ; increment to next slot
        log_index++
        ;log_start++
;        if log_index == LOG_MAX {
;            log_start = 0
;            return
;        }
        if log_index > LOG_MAX {
            log_index = 0
        }
;        if log_start > LOG_MAX
;            log_start = 0

        ; zero next slot
        log_device[log_index] = 0
        log_chunks[log_index] = 0
        log_jiffies[log_index] = 0
        log_read[log_index] = false
        log_speed[log_index] = 0.0
    }

}

