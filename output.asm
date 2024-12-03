; output.asm
; Yara Zrigan
; 14 November 2024
; Handles all output-related tasks for the game, including displaying messages.

.386P
.model flat

extern _WriteConsoleA@20:near
extern _GetStdHandle@4:near  
extern getCurrentPlayer:PROC     ; from gameLogic.asm
;extern PLAYER_X:BYTE
;extern PLAYER_O:BYTE

.data
PLAYER_X db 'X'        ; Defines PLAYER_X
PLAYER_O db 'O'        ; Defines PLAYER_O
turnMsg db 'Player ', 0             ;message for whose turn is is
winMsg db ' wins the game!', 0      ;message for the winning player
currentPlayerString db ' ', 0
newline db 13, 10, 0
NULL equ 0
outputHandle  dword   ?                             ; Output handle writing to consol. uninitslized
written   dword   ?


.code

; Print players character
;used in main to display the win message
;Used to be printChar
printChar2 PROC
    call getCurrentPlayer
    mov [currentPlayerString], al
    mov edx, OFFSET currentPlayerString          
    call printString2                ;Displays the message for whose turn it is
    ret
printChar2 ENDP

charCount PROC
_charCount:
                pop   edx            ; Save return address [++]
                pop   ebx            ; save offset/address of string [++]
                push  edx            ; Put return address back on the stack [--]
                mov   eax,0          ; load counter to 0
                mov   ecx,0          ; Clear ECX register
_countLoop:
                mov   cl,[ebx]       ; Look at the character in the string
                cmp   cl,NULL        ; check for end of string.
                je    _endCount
                inc   eax           ; Up the count by one
                inc   ebx           ; go to next letter
                jmp   _countLoop
_endCount:
                ret                 ; Return with EAX containing character count [++]

charCount ENDP            ; [ESP+=8], Parameter removed from stack [+*2]

; Initialize Output Handle (standard output)
initializeOutputHandle PROC
    mov eax, -11                 
    call _GetStdHandle@4          ; Get the standard output handle
    mov [outputHandle], eax       ; Store the handle in outputHandle
    ret
initializeOutputHandle ENDP


;Display the message for whos turn it is
printString2 PROC
_printString:
    pop   edx                         ; Pop return address into EDX
    pop   ebx                         ; Pop buffer location into EBX
    push  edx                         ; Restore return address
    push  ebx
    push  ebx
    call  charCount                   ; Calculate the length of the string
    pop   ebx
    ; Now call WriteConsoleA
    push  NULL                        ; [--]
    push  offset written              ; [--]
    push  eax                         ; Size of the string
    push  ebx                         ; Pointer to the string
    push  outputHandle                ; Output handle
    call  _WriteConsoleA@20           ; write to console
    ret
printString2 ENDP


displayTurn PROC
    ;shows the current player's turn
    push NULL
    push offset written
    push LENGTHOF turnMsg
    push offset turnMsg
    push [outputHandle]
    call _WriteConsoleA@20
    call getCurrentPlayer       ;loads the current player's character
    push eax
    push offset written
    push 1
    push esp
    push [outputHandle]
    call _WriteConsoleA@20
    pop eax
    ret
displayTurn ENDP


displayWin PROC
    ;Show message when player wins!
    push NULL
    push offset written
    push LENGTHOF winMsg
    push offset winMsg
    push [outputHandle]
    call _WriteConsoleA@20

    call getCurrentPlayer       ;load the currentPlayer's symbol
    push eax
    push NULL
    push offset written
    push 1
    push esp
    push [outputHandle]
    call _WriteConsoleA@20
    pop eax

    push NULL
    push offset written
    push LENGTHOF newline
    push offset newline
    push [outputHandle]
    call _WriteConsoleA@20
    ret
displayWin ENDP
END