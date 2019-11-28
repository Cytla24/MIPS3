  
# MIPS Programming Project 2 
# Aimie Ojuba - @02837763
.data

	Ask_Input: .asciiz "Please Enter a String\n"
	in: .asciiz "im in\n"
	invalidinp: .asciiz "invalid input\n"
	input: .space 1000

.text
main:
	lui $t8, 43
	ori $t8, $t8, 19715
	add $t0, $zero, $t8				# int $t0 = 02837763
	addi $t1, $zero, 11				# int $t1 = 11
	div $t0, $t1					# divide t0/t1
	mfhi $t3						# remainder = t3
	addi $s0, $t3, 26				# N = s0
	addi $t9, $zero, 10
	sub $s1, $s0, $t9				# M = s1
	
	#display req for input
	li $v0, 4
	la $a0, Ask_Input
	syscall
	
	#input string
	li $v0, 8
	la $a0, input
	li $a1, 1000
	syscall
	
	addi $s0, $sp, 0
	li $t6, 999
push:
	beq $t6, -1, done
	addi $sp, $sp, -4
	
	#get each character
	la $a1, input
	addu $a1, $a1, $t6
	lb $a0, 0($a1)
	
	sw $a0, 0($sp)
	addi $t6, $t6, -1
	j push
done:
	jal convert
	
	beq $v0, 4, end
	li $v0, 1
	add $a0, $v1, $zero
	syscall

end:
	li $v0,10
	syscall
	
convert:
	beq $sp, $s0, exit
	#instantiate index to 0
	addi $t6, $zero, 0
	
	li $t4, 0 		#total variable
	li $t9, 0		#Count variable
	li $t7, 1		#Square Variable
	li $t5, 0 		#num variable
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal substring
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	lw $t6, 0($sp)
	sne $t2, $t6, 44
	sne $t3, $sp, $s0
	slt $t0, $t9, 4
	
	#branch test cases
	and $t8, $t8, $t2
	and $t8, $t8, $t3
	
	
	
	and $t8, $t8, $t0
	
	
	
test2:
	blt $t6,$t2, body
	
	#get each character
	la $a1, input
	addu $a1, $a1, $t6
	lb $a0, 0($a1)
	
	#Check valididy of char
	#Check if number
	li $t5, 47		
	sgt $s2, $a0, $t5

	li $t5, 58
	slt $s7, $a0, $t5
	
	and $s2, $s2, $s7
	
	#Check if big  letter
	li $t5, 64		
	sgt $s3, $a0, $t5
	
	li $t5, 86
	slt $s4, $a0, $t5
	
	and $s3, $s3, $s4
	
	#check if small letter
	li $t5, 96
	sgt $s5, $a0, $t5
	
	li $t5, 118
	slt $s6, $a0, $t5
	
	and $s5, $s5, $s6
	
	#verify if any are true
	or $s7, $s2, $s3
	or $s7, $s7, $s5

	#if not valid, skip to next char
	li $t8, 1
	bne $s7, $t8, invalid
	
	li $t5, 0
	li $t7, 1 		#reset SQ to zero
	
	#loop to find the square of base we would be multiplying by
countloop:
	bge $t5, $t9, endcountloop
	mult $s0, $t7
	mflo $t7
	addi $t5, $t5, 1
	j countloop
	
endcountloop:
	#separate numbers from other valid inputs
	bne $s2, $t8, letters
	li $t5, 0				#temporary increment
	li $t0, 48
	sub $t5, $a0, $t0
	mult $t5, $t7
	mflo $t5
	add $t4, $t4, $t5
	j increment
	
letters:
	#separate small letters from big letters
	bne $s3, $t8, small
	li $t5, 0			#temporary increment
	li $t0, 65
	sub $t5, $a0, $t0
	addi $t5, $t5, 10
	mult $t5, $t7
	mflo $t5			#multiply by square
	add $t4, $t4, $t5	
	j increment
	
small:
	bne $s5, $t8, invalid
	li $t5, 0			#temporary increment
	li $t0, 97
	sub $t5, $a0, $t0
	addi $t5, $t5, 10
	mult $t5, $t7
	mflo $t5	
	add $t4, $t4, $t5

	li $v0, 11

increment:
	#increment count
	addi $t9, $t9, 1
	#decrement counter
	li $t1, 1
	sub $t6, $t6, $t1
	j test2
body:
	addi $v1, $t4, 0
	j exit

	

invalid:
	#display invalid input
	li $v0, 4
	la $a0, invalidinp
	syscall	
	
exit:
	jr $ra
	
substring:

	add $t0, $ra, $zero
	
	li $t8, 1
	bne $t8, 1, nexxt
	sne $t2, $t6, 44
	sne $t3, $sp, $s0
	
	and $t8, $t2, $t3
	
	lw $t6, 0($sp)
nexxt:

process:

	
