
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
movq %rax, %r10
sub $LICZBY, %r10


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

jmp skok
movq %rcx, %rsi
#sub $2, %rsi
dec %rsi
movq $0, %rdi
odwracanie:
movb textout(, %rsi, 1), %al
movb %al, textfinal( %rdi, 1)
inc %rdi
dec %rsi
cmp %rcx, %rdi
jle odwracanie

skok:
movq $4, %rdi

movq $256, %r12
movq $0, %rsi
#sub $1, %rsi
movq $1, %r11
algorytm:
movb textout(, %rdi, 1), %bl
movq %rbx, %rax
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
movq %r10, %rbx
mul %rbx
movq %rax, %r11

dalej:
movq %r10, %rbx
movq %r10, %rax
mul %rbx
movq %rax, %r10
inc %rsi
cmp %rsi, %rcx
jge algorytm

koniec:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $textout, %rsi
movq $BUFLEN, %rdx
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
