
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
.comm wykladnik, 512
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


movq $0, %rsi
movb podstawa(, %rsi, 1), %al
sub $LICZBY, %rax
movq %rax, %r12

#Pobranie wykladnika
movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $wykladnik, %rsi
movq $BUFLEN, %rdx
syscall

#Przed petla
movq %rax, %rdi
movq %rax, %r9
sub $2, %rdi
movq $1, %rsi
movq $0, %r8

#Umieszczenie wykladnika w r8
petla:
movq $0, %rax
movb wykladnik(, %rdi, 1), %al
sub $LICZBY, %al

mul %rsi
add %rax, %r8

movq %rsi, %rax
movq $NORMAAL, %rbx
mul %rbx
mov %rax, %rsi

dec %rdi
cmp $0, %rdi
jge petla


#Przed petla2
movq %r8, %rax
movq $2, %rbx
movq $0, %rcx

#Zamiana wykladnika na liczbe w systemie dwojkowym
petla2:
movq $0, %rdx
div %rbx
add $LICZBY, %rdx
movb %dl, textout(, %rcx, 1)
inc %rcx
cmp $0, %rax
jne petla2


#Przygotowanie do algorytmu
movq $0, %rsi
movq $1, %r11

#Glowny algorytm
algorytm:
movq $0, %rbx
movb textout(, %rsi, 1), %bl	#Problem
movq $0, %rax
movq %rbx, %rax
sub $LICZBY, %rax
cmp $1, %rax
jle jest_ok			#Proba naprawy problemu, nieskuteczna poniewaz kazda koleja pozycja staje sie wieksza po i-tej iteracji
sub $256, %rax
jest_ok:
cmp $1, %rax
jnz dalej
movq %r11, %rax
movq %r12, %rbx
mul %rbx
movq %rax, %r11

dalej:
movq %r12, %rbx
movq %r12, %rax
mul %rbx
movq %rax, %r12
inc %rsi
cmp %rsi, %rcx
jge algorytm

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
