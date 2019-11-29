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
	beq $t6, -1, done
	
	#get each character
	la $a1, input
	addu $a1, $a1, $t6
	lb $a0, 0($a1)
	
	li $t0, 0
	beq $a0, 10, skip
	beq $a0, 0, skip
	addi $sp, $sp, -4
	sw $a0, 0($sp)
skip:
	addi $t6, $t6, -1
	j push
done: