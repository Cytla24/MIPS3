  
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
	
	jal convert
	
	beq $v0, 4, end
	li $v0, 1
	add $a0, $v1, $zero
	syscall

end:
	li $v0,10
	syscall
convert:
	
	#instantiate index to 0
	addi $t6, $zero, 0

	#declare final reg
	li $t4, 0
	
	#Finding first non space char
	li $t2, 0
floop:
	beq $t6, 996 , test
	
	#get each character
	la $a1, input
	addu $a1, $a1, $t6
	lb $a0, 0($a1)
	
	
	#branch if character is not a space or tab
	seq $t5, $a0, 0
	seq $t7,$a0, 32
	seq $t8,$a0, 9
	
	or $t7, $t5, $t7
	or $t7, $t7, $t8
	add $t2, $t6, $zero			#set t2 = first non space value 
	beq $t7, 0, inloop
	
	
	#increment index
	addi $t6, $t6, 1
	add $t2, $t6, $zero
	j floop

inloop:
	#loop from back
	li $t6, 999
	j lloop

lloop:	
	blt $t6, $t2, body 			#if index is back at t2, jump to body
	
	#get each character
	la $a1, input
	addu $a1, $a1, $t6
	lb $a0, 0($a1)
	
	#branch if character is not a space or tab
	seq $t5, $a0, 0
	seq $t9,$a0, 32
	seq $t8,$a0, 9
	seq $t0, $a0,10
	
	#beq $a0, 10, test 			#check if enter key
	
	or $t9, $t5, $t9
	or $t9, $t0, $t9
	or $t9, $t9, $t8 
	beq $t9, 0, test			#MOTE LAST = ENTER - 2
	

	
	#increment index
	li $t1, 1
	sub $t6, $t6, $t1
	j lloop

test: 	
	
	#display req for input
	li $v0, 4
	la $a0, in
	syscall
	
	#first = t2, last = t3
	li $t1, 0
	sub $t3, $t6, $t1
	addi $t1, $t2, 4
	bgt $t3, $t1, invalid
	li $t9, 0		#Count variable
	li $t7, 1		#Square Variable
	add $t6, $t3, $zero
	
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
	
