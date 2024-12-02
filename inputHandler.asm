; inputHandler.asm
; Yara Zrigan
; 15 November 2024
; Handles user input for the game.
;Uses ReadColsoleA to get user input for row and column choices
;Validates the move (makes sure the cell is within bounds and is empty)

.386P
.model flat

extern currentPlayer:BYTE
extern board:BYTE
extern printString:PROC
extern printChar:PROC
extern PLAYER_X:BYTE
extern PLAYER_O:BYTE
extern _ReadConsoleA@20: near
extern _GetStdHandle@4: near    

.data
promptRow db 'Enter Row (1-5): ', 0
promptCol db 'Enter Column (1-5): ', 0
invalidMoveMsg db 'Invalid move. Try again.', 13, 10, 0
buffer db 2, 0           ; Buffer for input

.code
;Read the user input with the row (1-5) and colum (1-5)
getUserInput PROC
    ; Function to get a single character input from user using Windows API (ReadConsoleA)
    push -11                  ; STD_INPUT_HANDLE = -11
    call _GetStdHandle@4      ; Call GetStdHandle to get the input handle
    mov ebx, eax              ; store input
    lea edx, buffer           
    push 0                    ; set to 0
    push 1                    ; Number of characters to read
    push edx                  ; Buffer address
    push ebx                  ; Input handle
    call _ReadConsoleA@20     ; Call ReadConsoleA to get user input
    ret
getUserInput ENDP

getPlayerInput PROC
inputLoop:
    mov edx, OFFSET promptRow  
    call printString
    call getUserInput
    sub al, '1'                 ; Convert input to 0-4 range (row)
    mov dl, al                  ; Store row in dl

    mov edx, OFFSET promptCol   
    call printString
    call getUserInput
    sub al, '1'                 ; Convert input to 0-4 range (column)
    mov cl, al                  ; Store column in cl

    cmp dl, 4
    jae invalidInput            ; Check if row is out of range (0-4)
    cmp cl, 4
    jae invalidInput            ; Check if column is out of range (0-4)

    mov ax, dx                  ; Use dx for row (dl) and column (cl)
    imul ax, 5                  ; Multiply row by 5 (board width)
    add ax, cx                  ; Add column to get the correct index
    mov bx, ax
    mov al, board[bx]           ; Check if the selected cell is empty ('-')
    cmp al, '-'
    jne invalidInput            ; If not empty, move is invalid

    ret

invalidInput:
    mov edx, OFFSET invalidMoveMsg  
    call printString            ;Prints message to tell player that they have an invalid move
    jmp inputLoop

getPlayerInput ENDP

END
