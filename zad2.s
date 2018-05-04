
.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
BUFLEN = 512
SIODEMKA = 7
NORMAAL = 10
LICZBY = 48
.bss
.comm podstawa, 512
.comm textout, 512
.comm textfinal, 512
.text
.globl main

main:

#Pobranie podstawy
movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $podstawa, %rsi
movq $BUFLEN, %rdx
syscall

#Przed petla0
movq %rax, %rdi
sub $2, %rdi
movq $1, %rsi
movq $0, %r12

#Umieszczenie podstawy w r12
petla0:
movq $0, %rax
movb podstawa(, %rdi, 1), %al
sub $LICZBY, %al

mul %rsi
add %rax, %r12

movq %rsi, %rax
movq $NORMAAL, %rbx
mul %rbx
mov %rax, %rsi

dec %rdi
cmp $0, %rdi
jge petla0

#Przygotowanie do algorytmmu
movq $0, %rcx
movq $128, %r11
movq $0, %rsi

#Glowny algorytm
algorytm:
add %r11, %rcx
movq %rcx, %rax
movq %rcx, %rbx
mul %rbx
cmp %r12, %rax
jle dalej
sub %r11, %rcx

dalej:
movq $2, %rbx
movq %r11, %rax
movq $0, %rdx
div %rbx
movq %rax, %r11
inc %rsi
cmp $8, %rsi
jle algorytm
movq %rcx, %r11
#Umieszczenie wyniku w textfinal
przed:
movq $0, %rdi
movq %r11, %rax
movq $10, %rbx
movq $0, %rcx
wyswietl:
movq $0, %rdx
div %rbx
add $LICZBY, %rdx
movb %dl, textfinal(, %rcx, 1)
inc %rcx
cmp $0, %rax
jne wyswietl


na_ekran0:
movq $0, %rdi
movq %rcx, %rsi
dec %rsi

#Odwrocenie kolejnosci cyfr
na_ekran1:
movb textfinal(, %rsi, 1), %al
movb %al, textout(, %rdi, 1)
inc %rdi
dec %rsi
cmp %rcx, %rdi
jle na_ekran1



koniec:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $textout, %rsi
movq $BUFLEN, %rdx
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
