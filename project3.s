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

	or $t7, $t5, $t7
	or $t7, $t7, $t8
	beq $s2, $sp, invalid
	beq $t7, 0, nospaceeach
	addi $sp, $sp, 4
	j estart
	
nospaceeach:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	#call final sub routine
	jal change
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4


invalid:
eachend:
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	jr $ra

change:
	lw $t2, 0($sp)
	addi $sp, $sp, 4
	addi $s5, $sp, 0
	li $s7, 0
	li $t9, 0		#Count variable
	li $t7, 1		#Square Variable
	
changestart:
	lw $t6, 0($s5)
	seq $t5, $t6, 0
	seq $t3,$t6, 32
	seq $t8,$t6, 9
	
	or $t5, $t3, $t5
	or $t5, $t5, $t8
	lw $t6, 0($s5)
	addi $s4, $s3, 0
	beq $t5, 0, changestart2
	beq $s3, $s2, changestart2
	addi $s5, $s5, 4
	lw $t6, 0($s5)
	j changestart

changestart2:
	lw $t6, 0($s4)
	seq $t5, $t6, 0
	seq $t3,$t6, 32
	seq $t8,$t6, 9
	or $t5, $t3, $t5
	or $t5, $t5, $t8
	beq $t5, 0, stage1change
	addi $s4, $s4, -4
	lw $t6, 0($s4)
	j changestart2

stage1change:
	lw $t6, 0($s5)
	
	sub $t5, $s2, $s5
	bgt $t5, 16, invalidchange
	addi $t5, $s3, 4
	beq $s5, $t5, printval

	
	#Check valididy of char
	#Check if number
	li $t5, 47		
	sgt $t4, $t6, $t5
	
	li $t5, 58
	slt $t8, $t6, $t5
	
	and $t0, $t4, $t8
	
	#Check if big  letter
	li $t5, 64		
	sgt $t4, $t6, $t5
	
	li $t5, 86
	slt $t8, $t6, $t5

	and $t4, $t4, $t8
	or $t0, $t0, $t4 
	
	#check if small letter
	li $t5, 96
	sgt $t4, $t6, $t5
	
	li $t5, 118
	slt $t8, $t6, $t5
	
	and $t4, $t4, $t8
	or $t0, $t0, $t4


	#if not valid, skip to next char
	li $t8, 1
	addi $t5, $s4, 4
	beq $s5,$t5,printval
	bne $t0, $t8, invalidchange
	
	li $t5, 0
	li $t7, 1 		#reset SQ to zero
	#loop to find the square of base we would be multiplying by

countloop:
	bge $t5, $t9, endcountloop
	li $s6, 31
	mult $s6, $t7
	mflo $t7
	addi $t5, $t5, 1
	j countloop
endcountloop:
	#Check if number
	li $t5, 47		
	sgt $t4, $t6, $t5

	li $t5, 58
	slt $t8, $t6, $t5
	
	and $t0, $t4, $t8
	beq $t0, 1, numbers
	
	#Check if big  letter
	li $t5, 64		
	sgt $t4, $t6, $t5
	
	li $t5, 86
	slt $t8, $t6, $t5
	
	and $t4, $t4, $t8
	beq $t4, 1, bletters
	
	#check if small letter
	li $t5, 96
	sgt $t4, $t6, $t5
	
	li $t5, 118
	slt $t8, $t6, $t5
	
	and $t4, $t4, $t8
	beq $t4, 1, sletters
	j invalidchange
		#separate numbers from other valid inputs