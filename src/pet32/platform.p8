;
; Lets try merging this straight into main for now
;
platform {
%option merge

    ; custom settings
    const ubyte MAX_BLOCKS = 32

    ; C64 colors (cleanup)
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

    str title = "Easy Storage Benchmark PET"
    const ubyte title_start = (40 - len(title)) / 2

    ; UI keys
    const ubyte KEY_DRIVE_UP    = KEY_U
    const ubyte KEY_DRIVE_DOWN  = KEY_D
    const ubyte KEY_BLOCK_UP    = KEY_P
    const ubyte KEY_BLOCK_DOWN  = KEY_M
    const ubyte KEY_LOG         = KEY_H
    const ubyte KEY_LOAD        = KEY_L
    const ubyte KEY_SAVE        = KEY_S
    const ubyte KEY_EXIT        = KEY_X

    ; UI labels
    str UI_DRIVE_UP     = " U "
    str UI_DRIVE_DOWN   = " D "
    str UI_BLOCK_UP     = " P "
    str UI_BLOCK_DOWN   = " M "
    str UI_LOG          = " H "
    str UI_LOAD         = " L "
    str UI_SAVE         = " S "
    str UI_EXIT         = " X "

    ; platform specific keys.

    ; control style keys
    const ubyte KEY_ESCAPE      = 27
    const ubyte KEY_CONTROL_L   = 12

    ; numbers & letters
    const ubyte KEY_0           = '0'
    const ubyte KEY_1           = '1'
    const ubyte KEY_2           = '2'
    const ubyte KEY_3           = '3'
    const ubyte KEY_4           = '4'
    const ubyte KEY_5           = '5'
    const ubyte KEY_6           = '6'
    const ubyte KEY_7           = '7'
    const ubyte KEY_8           = '8'
    const ubyte KEY_9           = '9'
    const ubyte KEY_A           = 'a'
    const ubyte KEY_B           = 'b'
    const ubyte KEY_C           = 'c'
    const ubyte KEY_D           = 'd'
    const ubyte KEY_E           = 'e'
    const ubyte KEY_F           = 'f'
    const ubyte KEY_G           = 'g'
    const ubyte KEY_H           = 'h'
    const ubyte KEY_I           = 'i'
    const ubyte KEY_J           = 'j'
    const ubyte KEY_K           = 'k'
    const ubyte KEY_L           = 'l'
    const ubyte KEY_M           = 'm'
    const ubyte KEY_N           = 'n'
    const ubyte KEY_O           = 'o'
    const ubyte KEY_P           = 'p'
    const ubyte KEY_Q           = 'q'
    const ubyte KEY_R           = 'r'
    const ubyte KEY_S           = 's'
    const ubyte KEY_T           = 't'
    const ubyte KEY_U           = 'u'
    const ubyte KEY_V           = 'v'
    const ubyte KEY_W           = 'w'
    const ubyte KEY_X           = 'x'
    const ubyte KEY_Y           = 'y'
    const ubyte KEY_Z           = 'z'
    ; capital / shifted
    const ubyte KEY_SHIFT_A     = 'A'
    const ubyte KEY_SHIFT_B     = 'B'
    const ubyte KEY_SHIFT_C     = 'C'
    const ubyte KEY_SHIFT_D     = 'D'
    const ubyte KEY_SHIFT_E     = 'E'
    const ubyte KEY_SHIFT_F     = 'F'
    const ubyte KEY_SHIFT_G     = 'G'
    const ubyte KEY_SHIFT_H     = 'H'
    const ubyte KEY_SHIFT_I     = 'I'
    const ubyte KEY_SHIFT_J     = 'J'
    const ubyte KEY_SHIFT_K     = 'K'
    const ubyte KEY_SHIFT_L     = 'L'
    const ubyte KEY_SHIFT_M     = 'M'
    const ubyte KEY_SHIFT_N     = 'N'
    const ubyte KEY_SHIFT_O     = 'O'
    const ubyte KEY_SHIFT_P     = 'P'
    const ubyte KEY_SHIFT_Q     = 'Q'
    const ubyte KEY_SHIFT_R     = 'R'
    const ubyte KEY_SHIFT_S     = 'S'
    const ubyte KEY_SHIFT_T     = 'T'
    const ubyte KEY_SHIFT_U     = 'U'
    const ubyte KEY_SHIFT_V     = 'V'
    const ubyte KEY_SHIFT_W     = 'W'
    const ubyte KEY_SHIFT_X     = 'X'
    const ubyte KEY_SHIFT_Y     = 'Y'
    const ubyte KEY_SHIFT_Z     = 'Z'

}
