;inputHandler.asm
;Yara Zrigan
;15 November 2024
;Handles User input for the game

EXTERN currentPlayer:BYTE    ; Reference to the current player in gameLogic.asm
EXTERN board:BYTE            ; Reference to the board array in boardManager.asm

.data
promptRow db 'Enter Row (1-5): ', 0
promptCol db 'Enter Column (1-5): ', 0
invalidMoveMsg db 'Invalid move. Try again.', 13, 10, 0

.code
getPlayerInput PROC
    ; This function captures and validates the row and column inputs from the player.
    ; Returns in DX = row (0-4), CX = column (0-4)

inputLoop:
    ; Prompt for row
    mov dx, OFFSET promptRow
    call printString
    call getUserInput      ; Assume this captures a single character as input
    sub al, '1'            ; Convert ASCII to row index (0-based)
    mov dl, al             ; Store row in DL for later use

    ; Prompt for column
    mov dx, OFFSET promptCol
    call printString
    call getUserInput
    sub al, '1'            ; Convert ASCII to column index (0-based)
    mov cl, al             ; Store column in CL

    ; Validate input
    cmp dl, 4              ; Check if row is within range (0-4)
    jae invalidInput
    cmp cl, 4              ; Check if column is within range (0-4)
    jae invalidInput

    ; Calculate index in the board array
    mov ax, dx
    imul ax, 5             ; Multiply row by 5
    add ax, cx             ; Add column index to get board index
    mov bx, ax             ; Move board index to BX
    mov al, board[bx]      ; Load board cell into AL

    ; Check if cell is empty
    cmp al, '-'            ; Is cell empty?
    jne invalidInput       ; If not, go back to input loop

    ret                    ; Valid input, return to caller

invalidInput:
    ; Display invalid move message and retry
    mov dx, OFFSET invalidMoveMsg
    call printString
    jmp inputLoop          ; Loop back to get valid input

getPlayerInput ENDP
