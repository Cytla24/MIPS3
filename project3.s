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
jal convert
	
	#add a to test where stack is 
	#li $t5, 97
	#addi $sp, $sp, -4
	#sw $t5, 0($sp)
new:
	
	

end:
	li $v0,10
	syscall
	
convert:
	add $s2, $sp, $zero
	addi $s3, $sp, -4
	add $s1, $sp, $zero
cstart:
	beq $s1, $s0, flip2
	li $t8, 1		#make t8 =1 for conditionals
	#li $t5, 0		#add null inbetween characters 		REMEMBER TO CHANGE
	#addi $sp, $sp, -4	
	#sw $t5, 0($sp)
	
stage1:

	#add substring to front of stack 			KEEP TRACK OF $S1
	bne $t8, 1, flip
	lw $t6, 0($s1)
	beq $t6, 10, addjump
	
	addi $sp, $sp, -4
	sw $t6, 0($sp)
addjump:	
	addi $s1, $s1, 4
	
	sne $t2, $t6, 44
	sne $t3, $s1, $s0
	and $t8, $t2, $t3
	
	j stage1

flip:
	lw $t6, 0($sp)
	bne $t6, 44, flipmid
delete:
	addi $sp, $sp, 4
flipmid:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal each
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	j cstart
	
flip2:
	jr $ra

each:
	lw $t1, 0($sp)
	addi $sp, $sp, 4
estart:	
	lw $t6, 0($sp)
	
	seq $t5, $t6, 0
	seq $t7,$t6, 32
	seq $t8,$t6, 9