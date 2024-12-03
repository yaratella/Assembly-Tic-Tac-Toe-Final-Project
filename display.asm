; display.asm
; Yara Zrigan
; 11 November 2024
; Handles all display-related tasks for the game.
;Shows the 5x5 grid, and shows the appropriate symbols for each cell '-', 'X' 'O'

.386P
.model flat

extern _WriteConsoleA@20:near
extern _GetStdHandle@4:near    
extern getCurrentPlayer:PROC
extern setCurrentPlayer:PROC
extern getUserInput:PROC

.data
PLAYER_X db 'X'        ; Defines PLAYER_X
PLAYER_O db 'O'        ; Defines PLAYER_O
promptRow db 'Enter Row (1-5): ', 0
promptCol db 'Enter Column (1-5): ', 0
invalidMoveMsg db 'Invalid move. Try again.', 13, 10, 0
buffer db 2, 0           ; Buffer for input
newline db 13, 10, 0
turnMsg db 'Player ', 0
separator db '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', 0
board db 25 DUP('-') ; Defines board as 5x5 grid
resetMsg db 'Resetting the game...', 0
winMsg db 'Player ', 0
winSuffix db ' Wins!', 0
NULL equ 0
outputHandle  dword   ?                             ; Output handle writing to consol. uninitslized
written   dword   ?

.code

getCellContent PROC
    mov al, board[bx]  
    ret
getCellContent ENDP

checkWin PROC
    ; Check all possible winning conditions (vertical, horizontal, diagonal) for Player X and Player O
    ; The winning condition is having 4 consecutive marks in a row, column, or diagonal

    ; Horizontal check
    mov ecx, 5                 ; Loop over rows
row_check:
    ; Calculate the start of the current row (board + (ecx-1)*5)
    dec ecx                     ; Adjust for 0-based index
    mov eax, ecx                ; Copy the row index to eax
    imul eax, eax, 5            ; Multiply by 5 to get the byte offset (5 columns per row)
    lea esi, board              ; Load base address of the board
    add esi, eax                ; Add the row offset to the base address

    mov al, [esi]               ; Load the first element in the row
    cmp al, '-'
    je no_win_row               ; Skip if empty
    ; Check the whole row for 4 consecutive marks
    mov ebx, 4                   ; Column counter (looking for 4 marks)
check_row:
    cmp al, [esi]                ; Compare all elements in the row
    jne no_win_row               ; If not equal, no win in this row
    inc esi                      ; Move to the next column in the row
    dec ebx
    jnz check_row                ; Continue checking if there are more marks
    mov ax, 1                    ; Return win condition found
    ret
no_win_row:
    inc ecx
    jnz row_check                ; Check the next row

    ; Vertical check
    mov ecx, 5                   ; Loop over columns
col_check:
    ; Calculate the start of the current column (board + ecx)
    lea esi, board               ; Load base address of the board
    add esi, ecx                 ; Add the column offset to base address

    mov al, [esi]                ; Load the first element in the column
    cmp al, '-'
    je no_win_col                ; Skip if empty
    
    ; Check the whole column for 4 consecutive marks
    mov ebx, 4                    ; Row counter (looking for 4 marks)
check_col:
    cmp al, [esi]                 ; Compare all elements in the column
    jne no_win_col                ; If not equal, no win in this column
    add esi, 5                    ; Move to the next row in the same column
    dec ebx
    jnz check_col                 ; Continue checking if there are more marks
    mov ax, 1                     ; Return win condition found
    ret
no_win_col:
    inc ecx
    jnz col_check                 ; Check the next column

    ; Diagonal check
    ; Left-to-right diagonal (top-left to bottom-right)
    lea esi, board               ; Load the base address of the board
    mov al, [esi]                ; Load the first element of the diagonal
    cmp al, '-'
    je no_win_diag               ; Skip if empty
    
    ; Check the whole diagonal for 4 consecutive marks
    mov ebx, 4                    ; Counter for 4 marks
check_diag:
    cmp al, [esi]                ; Compare all elements in the diagonal
    jne no_win_diag              ; If not equal, no win in this diagonal
    add esi, 6                   ; Move diagonally in a 5x5 grid
    dec ebx
    jnz check_diag               ; Continue checking if there are more marks
    mov ax, 1                   
    ret
no_win_diag:

    ; Right-to-left diagonal (top-right to bottom-left)
    lea esi, board + 4           ; Start at the top-right corner
    mov al, [esi]                ; Load the first element of the diagonal
    cmp al, '-'
    je no_win_diag_r             ; Skip if empty
   
   ; Check the whole diagonal for 4 consecutive marks
    mov ebx, 4                    ; Counter for 4 marks
check_diag_r:
    cmp al, [esi]                ; Compare all elements in the diagonal
    jne no_win_diag_r            ; If it's not equal, no win in this diagonal
    sub esi, 4                   ; Move diagonally in the board (right to left)
    dec ebx
    jnz check_diag_r             ; Continue checking if more marks
    mov ax, 1                    ; Return win condition found
    ret
no_win_diag_r:
    mov ax, 0                    ; No wins
    ret
checkWin ENDP


;initalizes the board
initializeBoard PROC
    mov ecx, 25           ; Total cells (5x5), using 32-bit register (ecx)
    lea edi, board        ; Load address of board array (use edi, 32-bit)
clearBoardLoop:
    mov byte ptr [edi], '-'  ; Set each cell to empty ('-')
    inc edi                  ;Increments pointer to the next cell
    loop clearBoardLoop      ;Repeats this until all cells are cleared
   ; Reset the board to empty states and switch to Player X
    call initializeBoard        ; Calls the function to reset the board
    mov al, PLAYER_X            ; set current player to X (X always starts the game)
    call setCurrentPlayer       ; update currentPlayer
    ret
initializeBoard ENDP

displayBoard PROC
    mov ecx, 5                ; Loop over rows
    lea esi, board            ; Load address of the board into esi

row_loop:
    mov ebx, 5                ; Loop over columns
col_loop:
    mov al, [esi]             ; Load board value into AL
    push eax
    push offset written
    push 1
    push esp
    push [outputHandle]
    call _WriteConsoleA@20
    pop eax
    dec ebx                   ; Decrement column counter
    inc esi                   ; Move to next column in the row
    cmp ebx, 0                ; If all columns in the row are processed, break
    je end_row
    push '|'                  ; Print the separator for the colums
    push offset written
    push 1
    push esp
    push [outputHandle]
    call _WriteConsoleA@20
    pop eax
    jmp col_loop

end_row:
    push NULL
    push offset written
    push LENGTHOF newline
    push offset newline
    push [outputHandle]
    call _WriteConsoleA@20
    cmp ecx, 1                 ; If it's the last row, skip separator
    je skip_separator
    push NULL
    push offset written
    push LENGTHOF separator
    push offset separator
    push [outputHandle]
    call _WriteConsoleA@20
    push NULL
    push offset written
    push LENGTHOF newline
    push offset newline
    push [outputHandle]
    call _WriteConsoleA@20

skip_separator:
    dec ecx                   ; Decrement the row counter
    jnz row_loop              ; Jump to row_loop if ecx is not zero
    ret
displayBoard ENDP

getPlayerInput PROC
inputLoop:
    ; Prompt for row input
    push NULL
    push offset written
    push LENGTHOF promptRow
    push offset promptRow
    push [outputHandle]
    call _WriteConsoleA@20

    call getUserInput
    sub al, '1'                 ; Convert input to 0-4 range (row)
    mov dl, al                  ; Store row in dl

    ; Prompt for column input
    push NULL
    push offset written
    push LENGTHOF promptCol
    push offset promptCol
    push [outputHandle]
    call _WriteConsoleA@20

    call getUserInput
    sub al, '1'                 ; Convert input to 0-4 range (column)
    mov cl, al                  ; Store column in cl

    ; Validate input
    cmp dl, 4
    jae invalidInput            ; Check if row is out of range (0-4)
    cmp cl, 4
    jae invalidInput            ; Check if column is out of range (0-4)

    ; Calculate board index
    mov ax, dx                  ; Use dx for row (dl) and column (cl)
    imul ax, 5                  ; Multiply row by 5 (board width)
    add ax, cx                  ; Add column to get the correct index
    mov bx, ax                  ; Store the calculated index in bx

    call getCellContent         ; Get the content of the cell at index bx
                                 
    cmp al, '-'                 ; Check if the selected cell is empty ('-')
    jne invalidInput            ; If not empty, move is invalid

    ; Update the board with the player's move
    call getCurrentPlayer       ; Get current player symbol (X or O)
    mov [board + bx], al        ; Update the board at the calculated index with player's symbol

    ret

invalidInput:
    ; Print invalid move message
    push NULL
    push offset written
    push LENGTHOF invalidMoveMsg
    push offset invalidMoveMsg
    push [outputHandle]
    call _WriteConsoleA@20

    jmp inputLoop               ; Repeat input loop for valid entry

getPlayerInput ENDP
END