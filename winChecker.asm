; winChecker.asm
; Yara Zrigan
; 16 November 2024
; Checks for win conditions based on the current board state.

.386P
.model flat

; External references to external functions and variables
extern board:BYTE            ; Declare board from boardManager.asm
extern currentPlayer:BYTE    ; Declare currentPlayer from gameLogic.asm
extern PLAYER_X:BYTE         ; Represents Player X
extern PLAYER_O:BYTE         ; Represents Player O
extern printString:PROC      ; Declare printString as external
extern printChar:PROC        ; Declare printChar as external

.data
winMsg db 'Player ', 0
winSuffix db ' Wins!', 0
newline db 13, 10, 0

.code

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
    add esi, ecx                 ; Add the column offset (ecx) to the base address

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
    mov ax, 1                    ; Return win condition found
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
    add esi, 4                   ; Move diagonally in the board (right to left)
    dec ebx
    jnz check_diag_r             ; Continue checking if more marks
    mov ax, 1                    ; Return win condition found
    ret
no_win_diag_r:
    mov ax, 0                    ; No win found
    ret
checkWin ENDP

END
