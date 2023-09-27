.globl binary_search
binary_search:

.include "address_map_arm.s"
.text
.globl _start
_mystart:

// R0 = 0xFF200040
// R1 = key
// R2 = length
// R3 = startIndex
// R4 = endIndex
// R5 = middleIndex
// R6 = keyIndex
// R7 = NumIters

    MOV R3,#0
	SUB R4,R2,#1
	
	SUB R11,R4,R3
	lsr R12,R11,#1
	ADD R5,R3,R12
	
	MOV R6,#-1
	MOV R7,#1
	B while_check

while_check: 
	cmp R6,#-1
	beq loop
	cmp R6,#-1
	bne return
	
loop:
	cmp R3,R4
	bgt break
	LSL R9,R5,#2
	ldr R8,[R0,R9]
	cmp R8,R1
	beq found
	cmp R8,R1
	bgt greater
	ADD R10,R5,#1
	MOV R3,R10
	B set
	
set:
	NEG R8,R7
 	STR R8,[R0,R9]
	SUB R11,R4,R3
	lsr R12,R11,#1
	ADD R5,R3,R12
	ADD R7,R7,#1
	B while_check
	
found:
	MOV R6,R5
	B set
	
greater:
	SUB R10,R5,#1
	MOV R4,R10
	B set

break:
	nop

return:
	MOV R0,R6
	MOV PC,LR
