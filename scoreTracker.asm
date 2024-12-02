; scoreTracker.asm
; Yara Zrigan
; 17 November 2024
; Tracks and displays the score for each player across multiple rounds.

.386P
.model flat

extern PLAYER_X:BYTE
extern PLAYER_O:BYTE
extern printString:PROC
extern printChar:PROC
extern currentPlayer:BYTE

.data
scoreX db 0
scoreO db 0
scoreMsg db 'Score: Player X = ', 0
newline db 13, 10, 0

.code

updateScore PROC
    ; Updates the score for the current player
    mov al, [currentPlayer]   ;Load the current player
    cmp al, [PLAYER_X]        ; Compare current player with PLAYER_X
    je playerXScore           ; If Player X, then increment their score
    cmp al, [PLAYER_O]        ; Else, compare with PLAYER_O
    je playerOScore           ; If Player O, them increment their score
    ret                       ; If neither, return

playerXScore:
    inc byte ptr [scoreX]     ; Increments Player X score
    ret

playerOScore:
    inc byte ptr [scoreO]     ; Increments Player O score
    ret

updateScore ENDP

displayScore PROC
    ; Display the score
    mov edx, OFFSET scoreMsg  ; Load the score message string
    call printString          ;Call printString to display the score message
    mov al, [scoreX]
    call printChar            ; Print Player X score
    mov al, 32                ; Print a space
    call printChar
    mov edx, OFFSET newline   ; newline
    call printString

    mov edx, OFFSET scoreMsg  ; Load the score message string again
    call printString
    mov al, [scoreO]
    call printChar            ; Print Player O score
    mov al, 32                ; Print a space
    call printChar
    ret
displayScore ENDP

END