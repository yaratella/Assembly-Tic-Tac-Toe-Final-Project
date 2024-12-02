; boardManager.asm
; Yara Zrigan
; 11 November 2024
; Initializes and manages the game board’s data structure.
;"initialzeBoard" clears the board  '-'

.386P
.model flat

.data
board db 25 DUP('-') ; Defines board as 5x5 grid

.code

;initalizes the board
initializeBoard PROC
    mov ecx, 25           ; Total cells (5x5), using 32-bit register (ecx)
    lea edi, board        ; Load address of board array (use edi, 32-bit)
clearBoardLoop:
    mov byte ptr [edi], '-'  ; Set each cell to empty ('-')
    inc edi                  ;Increments pointer to the next cell
    loop clearBoardLoop      ;Repeats this until all cells are cleared
    ret
initializeBoard ENDP

END
