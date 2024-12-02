;resetGame.asm
;Yara Zrigan
;20 November 2024
;Resetting the game

.386P
.model flat

extern board:BYTE              ; from boardManager.asm
extern currentPlayer:BYTE      ; from gameLogic.asm
extern PLAYER_X:BYTE           ; from gameLogic.asm
extern PLAYER_O:BYTE           ; from gameLogic.asm
extern initializeBoard:PROC

.data
resetMsg db 'Resetting the game...', 0
newline db 13, 10, 0

.code

resetBoard PROC
    ; Reset the board to empty states and switch to Player X
    call initializeBoard        ; Calls the function to reset the board
    mov al, PLAYER_X            ; set current player to X (X always starts the game)
    mov currentPlayer, al       ; update currentPlayer
    ret
resetBoard ENDP

END
