; display.asm
;Yara Zrigan
;11 November 2024
; Handles all display-related tasks for the game; Board + Player info

EXTERN board:BYTE        ; Reference to the board array in boardManager.asm
EXTERN currentPlayer:BYTE ; Reference to the current player variable in gameLogic.asm

.data
newline db 13, 10, 0         ; Newline characters for readability
turnMsg db 'Player ', 0      ; Message prefix for displaying current player
separator db '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', 0 ; Line separator

; Display the board in a 5x5 grid with | separators and dashed lines between rows
displayBoard PROC
    mov cx, 5                ; Number of rows
    lea si, board            ; Load board address into SI
row_loop:
    mov bx, 5                ; Cells per row
col_loop:
    mov al, [si]             ; Load cell into AL
    call printChar           ; Display the cell ('X', 'O', or '-')
    dec bx
    inc si
    cmp bx, 0
    je end_row               ; If end of row, move to next line
    mov al, '|'              ; Otherwise, display cell separator
    call printChar
    jmp col_loop
end_row:
    mov dx, OFFSET newline   ; Move to the next line after each row
    call printString         ; Display newline
    cmp cx, 1
    je skip_separator        ; Skip separator on the last row
    mov dx, OFFSET separator ; Display separator line between rows
    call printString
    mov dx, OFFSET newline   ; Newline after separator
    call printString
skip_separator:
    loop row_loop
    ret
displayBoard ENDP

; Display the current player's turn
displayTurn PROC
    mov dx, OFFSET turnMsg   ; Display "Player "
    call printString
    mov al, currentPlayer    ; Load the current player's mark
    call printChar           ; Display 'X' or 'O'
    call printString         ; Display newline
    ret
displayTurn ENDP
