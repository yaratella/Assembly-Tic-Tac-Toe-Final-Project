; boardManager.asm
;Yara Zrigan
;11 November 2024
;Initializes and manages the game board’s data structure.

.data
board db 25 DUP(0x2D) ; Initialize a 5x5 board with 25 cells, all empty ('-')

; Function to initialize the board with empty cells
initBoard PROC
    mov cx, 25        ; Number of cells to initialize
    lea di, board     ; Load address of the board into DI
fill_board:
    mov byte ptr [di], 0x2D ; Set cell to '-'
    inc di
    loop fill_board
    ret
initBoard ENDP
