; inputHandler.asm
; Yara Zrigan
; 15 November 2024
; Handles user input for the game.
;Uses ReadColsoleA to get user input for row and column choices
;Validates the move (makes sure the cell is within bounds and is empty)

.386P
.model flat

;extern currentPlayer:BYTE
;extern board:BYTE
extern printString2:PROC
;extern printChar2:PROC
;extern PLAYER_X:BYTE
;extern PLAYER_O:BYTE
extern _ReadConsoleA@20: near
extern _GetStdHandle@4: near   
extern getCellContent:PROC
extern getCurrentPlayer:PROC
extern _WriteConsoleA@20:near

.data
PLAYER_X db 'X'        ; Defines PLAYER_X
PLAYER_O db 'O'        ; Defines PLAYER_O
promptRow db 'Enter Row (1-5): ', 0
promptCol db 'Enter Column (1-5): ', 0
invalidMoveMsg db 'Invalid move. Try again.', 13, 10, 0
buffer db 2, 0           ; Buffer for input
NULL equ 0
outputHandle  dword   ?                             ; Output handle writing to consol. uninitslized
written   dword   ?

.code
;Read the user input with the row (1-5) and colum (1-5)
getUserInput PROC
    ; Function to get a single character input from user using Windows API (ReadConsoleA)
    push -11                 
    call _GetStdHandle@4      ; Call GetStdHandle to get the input handle
    mov ebx, eax              ; store the input in EBX
    lea edx, buffer           
    push 0                    ; set to 0
    push 1                    ; Number of characters to read
    push edx                  ; Buffer address
    push ebx                  ; Input handle
    call _ReadConsoleA@20     ; Reads console for user input
    ret
getUserInput ENDP
END