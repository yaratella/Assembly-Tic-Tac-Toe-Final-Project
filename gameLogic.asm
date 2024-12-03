; gameLogic.asm
; Yara Zrigan
; 12 November 2024
; Manages the core game mechanics and logic to switch players
;switchPlayer checks teh current player and switches to the other player

.386P
.model flat

.data
PLAYER_X db 'X'        ; Defines PLAYER_X
PLAYER_O db 'O'        ; Defines PLAYER_O
currentPlayer db 'X'   ; Defines currentPlayer

.code

;By looking at the currentPlayer, switch between Player X and Player O

getCurrentPlayer PROC
    mov al, [currentPlayer]
    ret
getCurrentPlayer ENDP

setCurrentPlayer PROC
    mov [currentPlayer], al         ;Updates the current player
setCurrentPlayer ENDP

switchPlayer PROC
    mov al, currentPlayer       ; Load the current player value into al
    cmp al, PLAYER_X            ; Compare the value in al (currentPlayer) with PLAYER_X
    jne setPlayerX              ;If the current player is not 'X', (meaning current player is 'O') switch to 'X'
    mov al, PLAYER_O            ; Set 'O' in currentPlayer
    mov currentPlayer, al       ;Update currentPlayer
    ret
setPlayerX:
    mov al, PLAYER_X            ; Load 'X' into al
    mov currentPlayer, al       ; Set currentPlayer to 'X'
    ret
    
switchPlayer ENDP
END