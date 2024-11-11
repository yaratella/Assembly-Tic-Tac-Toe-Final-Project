; gameLogic.asm
;Yara Zrigan
;11 November 2024
;Manages the core game mechanics:
;Alternating turns, checking if a move is allowed, updating the board after each move.
.data
PLAYER_X db 'X'
PLAYER_O db 'O'
currentPlayer db 'X'  ; Start with Player X

; Function to switch the current player
switchPlayer PROC
    cmp currentPlayer, PLAYER_X
    jne setPlayerX
    mov currentPlayer, PLAYER_O
    ret
setPlayerX:
    mov currentPlayer, PLAYER_X
    ret
switchPlayer ENDP
