;winChecker.asm
;Yara Zrigan
;19 November 2024
;Checks the game board for a win condition (four in a row) or a tie


EXTERN board:BYTE
EXTERN currentPlayer:BYTE

.code

checkWin PROC
    ; Call each of the win-checking procedures
    call checkHorizontalWin
    cmp ax, 1           ; If checkHorizontalWin indicates a win
    je win_found        ; jump to win_found

    call checkVerticalWin
    cmp ax, 1           ; If checkVerticalWin indicates a win
    je win_found        ; jump to win_found

    call checkDiagonalWin
    cmp ax, 1           ; If checkDiagonalWin indicates a win
    je win_found        ; jump to win_found

    ; No win found
    mov ax, 0           ; Indicate no win
    ret

win_found:
    mov ax, 1           ; Indicate a win
    ret
checkWin ENDP



checkHorizontalWin PROC
; Check each row for four consecutive cells with the same player's mark
; Implement similar to vertical, but iterate across rows
    
    mov cx, 5               ; Number of rows
    lea si, board           ; Load the base address of the board
    mov dx, 0               ; Reset row start offset

row_loop:
    mov bx, dx              ; Set start of row
    mov di, 4               ; Number of horizontal checks per row (5 - 4 + 1)

horizontal_check:
    mov al, [si + bx]       ; Load the first cell in row
    cmp al, currentPlayer   ; Check if it matches the current player
    jne next_position       ; If not, go to next starting position

    ; Compare the next three cells for a total of four
    mov al, [si + bx + 1]
    cmp al, currentPlayer
    jne next_position

    mov al, [si + bx + 2]
    cmp al, currentPlayer
    jne next_position

    mov al, [si + bx + 3]
    cmp al, currentPlayer
    jne next_position

    ; Found a winning line
    mov ax, 1               ; Return 1 to indicate a win
    ret

next_position:
    inc bx                  ; Move to next start position in the row
    dec di
    jnz horizontal_check

    add dx, 5               ; Move to the start of the next row
    loop row_loop
    mov ax, 0               ; No win found
    ret
checkHorizontalWin ENDP

checkVerticalWin PROC
; Check each column for four consecutive cells with the same player's mark
    
    mov cx, 5               ; Number of columns
    mov bx, 0               ; Column start offset

column_loop:
    mov di, 2               ; Number of vertical checks per column (5 - 4 + 1)

vertical_check:
    mov al, [si + bx]       ; Load the cell at the start of vertical check
    cmp al, currentPlayer   ; Check if it matches the current player
    jne next_column_start

    ; Check next three cells below for a total of four
    mov al, [si + bx + 5]
    cmp al, currentPlayer
    jne next_column_start

    mov al, [si + bx + 10]
    cmp al, currentPlayer
    jne next_column_start

    mov al, [si + bx + 15]
    cmp al, currentPlayer
    jne next_column_start

    ; Found a winning line
    mov ax, 1               ; Return 1 to indicate a win
    ret

next_column_start:
    inc bx                  ; Move to the next cell down in the column
    dec di
    jnz vertical_check

    add bx, 1               ; Move to the start of the next column
    loop column_loop
    mov ax, 0               ; No win found
    ret
checkVerticalWin ENDP

checkDiagonalWin PROC
; Check diagonals for four consecutive cells with the same player's mark

    mov cx, 2               ; Two types of diagonal checks
    mov di, 0               ; Offset for first row to start checking diagonals

    ; Check left-to-right diagonal (\)
    lea si, board
    mov bx, 0               ; Start position

left_right_diag:
    mov al, [si + bx]
    cmp al, currentPlayer
    jne right_left_diag

    mov al, [si + bx + 6]   ; Check down-right diagonal cell
    cmp al, currentPlayer
    jne right_left_diag

    mov al, [si + bx + 12]
    cmp al, currentPlayer
    jne right_left_diag

    mov al, [si + bx + 18]
    cmp al, currentPlayer
    jne right_left_diag

    ; Found a winning diagonal
    mov ax, 1
    ret

right_left_diag:
    ; Check right-to-left diagonal (/)
    mov al, [si + bx + 3]
    cmp al, currentPlayer
    jne end_diagonal_check

    mov al, [si + bx + 8]
    cmp al, currentPlayer
    jne end_diagonal_check

    mov al, [si + bx + 12]
    cmp al, currentPlayer
    jne end_diagonal_check

    mov al, [si + bx + 16]
    cmp al, currentPlayer
    jne end_diagonal_check

    ; Found a winning diagonal
    mov ax, 1
    ret

end_diagonal_check:
    mov ax, 0
    ret
checkDiagonalWin ENDP
