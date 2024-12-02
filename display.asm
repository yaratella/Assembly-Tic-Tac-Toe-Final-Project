; display.asm
; Yara Zrigan
; 11 November 2024
; Handles all display-related tasks for the game.
;Shows the 5x5 grid, and shows the appropriate symbols for each cell '-', 'X' 'O'

.386P
.model flat

extern _WriteConsoleA@20:near
extern _GetStdHandle@4:near
extern printChar:PROC       
extern printString:PROC     
extern board:BYTE           ; from boardManager.asm
extern currentPlayer:BYTE   ; from gameLogic.asm

.data
newline db 13, 10, 0
turnMsg db 'Player ', 0
separator db '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', 0

.code

displayBoard PROC
    mov ecx, 5
    lea esi, board   ; Use esi (32-bit) instead of si (16-bit) for 32-bit addressing

;Display each row of the board
row_loop:
    mov ebx, 5       ; counter for colums
col_loop:
    mov al, [esi]    ; Loads board calue into AL
    call printChar
    dec ebx          ;drecrement colum counter
    inc esi          ;move to next colum
    cmp ebx, 0
    je end_row       ;if we reached the end of the row, break out of the colum loop
    mov al, '|'
    call printChar
    jmp col_loop
end_row:
    mov edx, OFFSET newline  
    call printString
    cmp ecx, 1
    je skip_separator
    mov edx, OFFSET separator  
    call printString
    mov edx, OFFSET newline    
    call printString
skip_separator:
    loop row_loop
    ret
displayBoard ENDP


END
