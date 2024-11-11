; main.asm
;Yara Zrigan
; 11 November 2024
;Responsible for initializing and orchestrating the game's main loop.

EXTERN initBoard:PROC
EXTERN displayBoard:PROC
EXTERN displayTurn:PROC
EXTERN switchPlayer:PROC

.code
main PROC
    call initBoard         ; Initialize board with empty cells
    call displayBoard      ; Display the initial board

    call displayTurn       ; Show current player's turn (Player X)
    call switchPlayer      ; Switch to Player O
    call displayTurn       ; Show updated player's turn (Player O)

    ret
main ENDP
