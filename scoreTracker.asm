; scoreTracker.asm
; Yara Zrigan
; 17 November 2024
; Tracks and displays the score for each player across multiple rounds.

.386P
.model flat

;extern PLAYER_X:BYTE
;extern PLAYER_O:BYTE
;extern printString2:PROC
;extern printChar2:PROC
extern getCurrentPlayer:PROC
extern _WriteConsoleA@20:near
;extern currentPlayer:BYTE

.data
PLAYER_X db 'X'        ; Defines PLAYER_X
PLAYER_O db 'O'        ; Defines PLAYER_O
scoreX db 0
scoreO db 0
scoreMsg db 'Score: Player X = ', 0
newline db 13, 10, 0
NULL equ 0
outputHandle  dword   ?                             ; Output handle writing to consol. uninitslized
written   dword   ?

.code

updateScore PROC
    ; Updates the score for the current player
    call getCurrentPlayer     ;Load the current player
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
    ; call printString2          ; Call printString to display the score message
    push NULL
    push offset written
    push LENGTHOF scoreMsg
    push offset scoreMsg
    push [outputHandle]
    call _WriteConsoleA@20
    
    mov al, [scoreX]
    ; call printChar2            ; Print Player X score
    push eax
    push NULL
    push offset written
    push 1
    push esp
    push [outputHandle]
    call _WriteConsoleA@20
    pop eax
    
    mov al, 32                ; Print a space
    ; call printChar2
    push eax
    push NULL
    push offset written
    push 1
    push esp
    push [outputHandle]
    call _WriteConsoleA@20
    pop eax

    mov edx, OFFSET newline   ; newline
    ; call printString2
    push NULL
    push offset written
    push LENGTHOF newline
    push offset newline
    push [outputHandle]
    call _WriteConsoleA@20

    mov edx, OFFSET scoreMsg  ; Load the score message string again
    ; call printString2
    push NULL
    push offset written
    push LENGTHOF scoreMsg
    push offset scoreMsg
    push [outputHandle]
    call _WriteConsoleA@20
    
    mov al, [scoreO]
    ; call printChar2            ; Print Player O score
    push eax
    push NULL
    push offset written
    push 1
    push esp
    push [outputHandle]
    call _WriteConsoleA@20
    pop eax
    
    mov al, 32                ; Print a space
    ; call printChar2
    push eax
    push NULL
    push offset written
    push 1
    push esp
    push [outputHandle]
    call _WriteConsoleA@20
    pop eax
    
    ret
displayScore ENDP

END