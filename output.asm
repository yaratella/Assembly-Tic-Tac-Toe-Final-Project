; output.asm
; Yara Zrigan
; 14 November 2024
; Handles all output-related tasks for the game, including displaying messages.

.386P
.model flat

extern _WriteConsoleA@20:near
extern _GetStdHandle@4:near
extern printChar:PROC
extern printString:PROC
extern newline:BYTE           
extern currentPlayer:BYTE     ; from gameLogic.asm
extern PLAYER_X:BYTE
extern PLAYER_O:BYTE

.data
turnMsg db 'Player ', 0             ;message for whose turn is is
winMsg db ' wins the game!', 0      ;message for the winning player

.code

displayTurn PROC
    ;shows the current player's turn
    mov edx, OFFSET turnMsg           
    call printString                ;Displays the message for whose turn it is
    mov al, currentPlayer           ;load current player's character ('X' or 'O')
    call printChar                  ;Print player's character
    ret
displayTurn ENDP

displayWin PROC
    ;Show message when player wins!
    mov edx, OFFSET winMsg   ;load winning message   
    call printString
    mov al, currentPlayer    ;load current player's symbol
    call printChar
    mov edx, OFFSET newline     
    call printString
    ret
displayWin ENDP

END
