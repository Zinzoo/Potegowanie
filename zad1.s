
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
.comm wykladnik, 512
.comm textin, 512
.comm textout, 512
.comm textfinal, 512
.text
.globl main

main:

wykladnik_wywolanie:
movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $wykladnik, %rsi
movq $BUFLEN, %rdx
syscall
movq $0, %rsi
movb wykladnik(, %rsi, 1), %al
sub $LICZBY, %rax
movq %rax, %r12


movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $textin, %rsi
movq $BUFLEN, %rdx
syscall

movq %rax, %rdi
movq %rax, %r9
sub $2, %rdi
movq $1, %rsi
movq $0, %r8

petla:
movq $0, %rax
movb textin(, %rdi, 1), %al
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

movq %r8, %rax
movq $2, %rbx
movq $0, %rcx

petla2:
movq $0, %rdx
div %rbx
add $LICZBY, %rdx
movb %dl, textout(, %rcx, 1)
inc %rcx
cmp $0, %rax
jne petla2
jmp poczatek

test:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $textout, %rsi
movq $BUFLEN, %rdx
syscall

poczatek:
movq $0, %rsi
movq $1, %r11
algorytm:
movb textout(, %rsi, 1), %bl
movq %rbx, %rax
sub $LICZBY, %rax
cmp $1, %rax
jle cos_dziwnego

sub $256, %rax

cos_dziwnego:
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
