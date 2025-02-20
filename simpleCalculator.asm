section .data
    ;Pesan Untuk Menu Di Awal Program
    msg db "---Simple Calculator----", 0xa,"Choice :",0xa,"1.Addition",0xa,"2.subtraction",0xa,"3.multiply",0xa,"4.Divided",0xa
    lenWelcome equ $ - msg
    
    ;Pesan untuk Menerima Input Angka Pertama
    msgNumOne db "Enter Number One : ",0xa
    lenNumOne equ $ - msgNumOne

    ;Pesan Untuk Menerima Input Angka Kedua
    msgNumTwo db "Enter Number Two : ",0xa
    lenNumTwo equ $ - msgNumTwo

    ;Pesan Untuk Menerima Input Pilihan Operator
    msgChoice db "Enter Choice :",0xa
    lenMsgChoice equ $ - msgChoice

    ;Pesan Untuk Menampilkan Hasil Operasi
    msgResult db "result : "
    lenResult equ $ - msgResult

    ;Variabel Untuk Membuat Baris Baru
    msgNewline db 10

    ;Variabel Untuk Debuging
    msgBerhasil db "Benar"
    lenMsgBerhasil equ $ - msgBerhasil

    ;Variabel Untuk Pembagian Error
    msgDivError db "Maaf Belum Program Ini belum Bisa",0xA
    lenMsgDivError equ $ - msgDivError

    ;Variabel Terima Kasih
    msgThanks db "Thank You :)",0xA
    lenThanks equ $ - msgThanks

    ;Perintah Untuk File Descriptor
    STDIN equ 0
    STDOUT equ 1
    STDERR equ 2

;Sesi Pembuatan Variabel
section .bss
    valOne resb 100 ;Variabel Untuk Menyimpan Angka Pertama
    valTwo resb 100 ;Variabel Untuk Menyimpan Angka Kedua
    valResult resd 100  ;Varibel Untuk Menyimpan Hasil Operator
    valChoice resd 100 ;Variabel Untuk Menyimpan Hasil Pilihan
    num1 resd 100 ;variabel Untuk Menyimpan Angka 1 Yang Sudah Di Konversi Ke Integer
    num2 resd 100 ;variabel Untuk Menyimpan Angka 2 Yang Sudah DI Konversi Ke Integer

section .text
    global _start

_start:
    ;Definition Macro For STDOUT
    %macro Print 2
    mov rax, 1
    mov rdi, STDOUT
    mov rsi, %1
    mov rdx, %2
    syscall
    %endmacro

    ;Definition Macro For STDIN
    %macro Input 2
    mov rax, 0
    mov rdi, STDIN
    mov rsi, %1
    mov rdx, %2
    syscall
    %endmacro

    Print msg,lenWelcome
    Print msgNumOne,lenNumOne
    Input valOne,3
    Print msgNumTwo,lenNumTwo
    Input valTwo,3
    Print msgChoice,lenMsgChoice
    Input valChoice,3

;Convert Data Type Input From String To Integer
    ;Change Value Number One
    mov al,[valOne]
    sub al,'0'
    mov bl,10
    mul bl
    mov [num1],al

    xor bl,bl
    mov bl,[valOne + 1]
    sub bl,'0'  
    add [num1],bl

    ;Change Value Number Two
    xor al,al
    xor bl,bl
    mov al,[valTwo]
    sub al,'0'
    mov bl,10
    mul bl
    mov [num2],al

    xor bl,bl
    mov bl,[valTwo + 1]
    sub bl,'0'  
    add [num2],bl

    ;Compare The User Choice
    mov al,[valChoice]
    cmp al,'1'
    je _add
    cmp al,'2'
    je _sub
    cmp al,'3'
    je _mul
    cmp al,'4'
    je _div
    jne _exit

;Adding Program Start Session
_add:

    xor al,al
    xor bl,bl
    mov al,[num1]
    add al,[num2]
    mov bl,10
    div bl

    xor bl,bl
    mov bl,0xA
    add al,'0'
    add ah,'0'

    mov [valResult],al
    mov [valResult + 1],ah
    mov [valResult + 2],bl
    
    Print msgResult,lenResult
    Print valResult,3
    jmp _exit

;End Addding Program Session

;Subtracting Program Start Session
_sub:
    xor al,al
    xor bl,bl
    mov al,[num1]
    sub al,[num2]
    mov bl,10
    div bl

    xor bl,bl
    mov bl,0xA
    add al,'0'
    add ah,'0'

    cmp al,'0'
    je _rmZeroSub
    mov [valResult],al
    mov [valResult + 1],ah
    mov [valResult + 2],bl
    
    Print msgResult,lenResult
    Print valResult,3
    jmp _exit

_rmZeroSub:
    xor al,al
    mov [valResult],al
    mov [valResult + 1],ah
    mov [valResult + 2],bl

    Print msgResult,lenResult
    Print valResult,3
    jmp _exit

;End Subtracting Program Session


;Multiply Program Start Session 
_mul:
    xor al,al
    xor bl,bl
    mov al,[num1]
    mov bl,[num2]
    mul bl
    xor bl,bl
    mov bl,100
    div bl
    cmp ah,0
    je _addZero
    jne _addNumber

;Program If The AH is zero
_addZero:
    xor bl,bl
    xor r8,r8
    xor dl,dl
    mov r9,0xA
    mov dl,'0'
    mov r8,'0'
    mov [valResult+2],dl
    mov [valResult+3],r8
    mov bl,10
    div bl
    cmp al,0
    je _resultHundredZero

    add al,'0'
    add ah,'0'
    mov [valResult],al
    mov [valResult+1],ah
    mov [valResult+4],r9

    Print msgResult,lenResult
    Print valResult,100
    jmp _exit

;Program if AL zero and the final result is hundred
_resultHundredZero:
    mov al,0
    add ah,'0'
    mov [valResult],al
    mov [valResult+1],ah
    mov [valResult+4],r9

    Print msgResult,lenResult
    Print valResult,100
    jmp _exit

;Program if AH not zero
_addNumber:
    xor bl,bl
    xor r9,r9
    xor dl,dl
    mov r9,0xA
    mov bl,10
    mov [num1],al
    mov [num2],ah
    xor al,al
    xor ah,ah
    mov al,[num1]
    div bl
    add al,'0'
    add ah,'0'
    mov [valResult],al
    mov [valResult+1],ah
    xor al,al
    xor ah,ah
    mov al,[num2]
    div bl
    add al,'0'
    add ah,'0'
    mov [valResult+2],al
    mov [valResult+3],ah
    mov [valResult+4],r9

    mov dl,[valResult]
    cmp dl,'0'
    je _resultHundredNumber

    Print msgResult,lenResult
    Print valResult,100
    jmp _exit

;Progran if the result is hundred
_resultHundredNumber:
    xor dl,dl
    mov dl,0
    mov [valResult],dl

    Print msgResult,lenResult
    Print valResult,100
    jmp _exit

;End Multiply Program Session


;Div program start session
_div:
    xor al,al
    xor bl,bl
    xor dl,dl
    mov dl,0xA
    mov al,[num1]
    mov bl,[num2]
    div bl
    cmp ah,0
    jne _resultError
    mov bl,10
    div bl
    add al,'0'
    add ah,'0'
    cmp al,'0'
    je _rmDivZero
    mov [valResult],al
    mov [valResult+1],ah
    mov [valResult+2],dl

    Print msgResult,lenResult
    Print valResult,100
    jmp _exit

_rmDivZero:
    mov al,0
    mov [valResult],al
    mov [valResult+1],ah
    mov [valResult+2],dl

    Print msgResult,lenResult
    Print valResult,100
    jmp _exit

_resultError:
    Print msgDivError,lenMsgDivError
    jmp _exit

;End Div program Session


;Debuging
_benar:
    Print msgBerhasil,lenMsgBerhasil


;Exit Program
_exit:
    mov rax, 1
    mov rdi, STDOUT
    mov rsi, msgThanks
    mov rdx, lenThanks
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

