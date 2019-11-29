.data
	comma: .asciiz ","
	invv: .asciiz "NaN"
	input: .space 6
.text
main:
#input string
	li $v0, 8
	la $a0, input
	li $a1, 6
	syscall
	
	addi $s0, $sp, 0
	li $t6, 5
push: