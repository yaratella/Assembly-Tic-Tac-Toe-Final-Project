; main.asm
; Yara Zrigan
; 11 November 2024
; Responsible for initializing and orchestrating the game's main loop.

.386P
.model flat

extern initializeBoard:PROC
extern displayBoard:PROC
extern displayTurn:PROC
extern switchPlayer:PROC
extern checkWin:PROC
extern printChar:PROC      
extern printString:PROC     
extern PLAYER_X:BYTE
extern PLAYER_O:BYTE
extern currentPlayer:BYTE
extern board:BYTE
extern _ExitProcess@4: near

.data
playerPrefix db 'Player ', 0
winSuffix db ' Wins!', 0
newline db 13, 10, 0

.code

main PROC
    call initializeBoard        ;calls the inital board
    call displayBoard           ;Displays the current board

game_loop:
    call displayTurn            ;show whose turn it is
    call displayBoard           ;Show updated board
    call checkWin               ;Check if there is a winner
    cmp ax, 1                   ;Check if game is won
    je display_win_message
    call switchPlayer           ;switch to current player
    jmp game_loop

display_win_message:
    mov edx, OFFSET playerPrefix   
    call printString
    mov al, currentPlayer
    call printChar
    mov edx, OFFSET winSuffix     
    call printString
    mov edx, OFFSET newline       
    call printString
    ret

exit_game:
    push 0
    call _ExitProcess@4
main ENDP

END
