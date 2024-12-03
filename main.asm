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
extern initializeOutputHandle:PROC
extern updateScore:PROC
extern displayScore:PROC
extern getCurrentPlayer:PROC
extern getPlayerInput:PROC
extern _ExitProcess@4: near
extern _WriteConsoleA@20: near

.data
PLAYER_X db 'X'        ; Defines PLAYER_X
PLAYER_O db 'O'        ; Defines PLAYER_O
playerPrefix db 'Player ', 0
winSuffix db ' Wins!', 0
newline db 13, 10, 0
NULL equ 0
outputHandle dword ?   ; Output handle writing to console. Uninitialized.
written dword ?        ; Number of characters written (output for WriteConsoleA)

.code
main PROC
    call initializeOutputHandle  ; Initializes the output handle
    call initializeBoard         ; Calls the initial board
    call displayBoard            ; Displays the current board
    call displayScore            ; Displays initial score

game_loop:
    call displayTurn             ; Shows whose turn it is
    call displayBoard            ; Show updated board
    call getPlayerInput          ; Get the player's move
    call checkWin                ; Check if there is a winner
    cmp ax, 1                    ; Check if game is won
    je display_win_message
    call updateScore             ; Update the score for the current player
    call displayScore            ; Display the updated score
    call switchPlayer            ; Switch to the next player
    jmp game_loop                ; Repeat the game loop

display_win_message:
    ; Display player win message
    push NULL
    push offset written
    push 8                       ; Length of 'Player ' string (hardcoded length)
    push offset playerPrefix
    push [outputHandle]
    call _WriteConsoleA@20

    ; Display the current player's symbol (X or O)
    call getCurrentPlayer
    push eax
    push NULL
    push offset written
    push 1                       ; Length of the player's symbol (X or O)
    push esp
    push [outputHandle]
    call _WriteConsoleA@20
    pop eax

    ; Display the "wins" message
    push NULL
    push offset written
    push 8                       ; Length of ' Wins!' string (hardcoded length)
    push offset winSuffix
    push [outputHandle]
    call _WriteConsoleA@20

    ; Print newline for better formatting
    push NULL
    push offset written
    push 2                       ; Length of newline (CR + LF)
    push offset newline
    push [outputHandle]
    call _WriteConsoleA@20

    ret

exit_game:
    push 0
    call _ExitProcess@4
main ENDP
END
